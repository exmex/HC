#include "Concurrency.h"
#ifdef _WINDOWS
#include <process.h>
#else
#include <signal.h>
#include <unistd.h>
#endif//WINDOWS

#include <time.h>
/*
#ifdef _WINDOWS

#else
pthread_cond_t cond = PTHREAD_COND_INITIALIZER;
pthread_mutex_t mtx = PTHREAD_MUTEX_INITIALIZER;
#endif//WINDOWS
*/
        void sleeping(float ts)
        {
#ifdef _WINDOWS
                Sleep(ts * 1000);
#else
                //sleep(ts);
				usleep(ts * 1000 * 1000);
#endif//WINDOWS
        }

        Mutex::Mutex()
        {
#ifdef _WINDOWS
                _mutex = CreateMutex(0, FALSE, 0);
#else
                pthread_mutexattr_t _mutex_attr;
                pthread_mutexattr_init(&_mutex_attr);
                pthread_mutex_init(&_mutex, &_mutex_attr);
#endif // WINDOWS
        }

        Mutex::~Mutex()
        {
#ifdef _WINDOWS
                WaitForSingleObject(_mutex, INFINITE);
                CloseHandle(_mutex);
#else
                pthread_mutex_lock(& _mutex);
                pthread_mutex_unlock(& _mutex);
                pthread_mutex_destroy(& _mutex);
#endif // WINDOWS
        }

        void Mutex::lock()
        {
#ifdef _WINDOWS
                WaitForSingleObject(_mutex, INFINITE);
#else
                pthread_mutex_lock(& _mutex);
#endif // WINDOWS
        }

        void Mutex::unlock()
        {
#ifdef _WINDOWS
                ReleaseMutex(_mutex);
#else
                pthread_mutex_unlock(& _mutex);
#endif // WINDOWS
        }


        int ThreadStateRunning::stop(ThreadBase* tb)
        {
#ifdef _WINDOWS
                if(tb->_mthread)
                {
                        WaitForSingleObject(tb->_mthread, INFINITE);
                        CloseHandle(tb->_mthread);
                }
#endif
#ifdef CC_TARGET_OS_IPHONE
                pthread_cancel(tb->_mthread);
                //pthread_join(tb->_mthread, 0);

#endif // WINDOWS

                tb->_mthread = 0;
                tb->setState(ThreadStateStoped::instance());
                return 0;
        }

        int ThreadStateStoped::start(PTR_THREAD_ENTRANCE pEntrance, void* params, ThreadBase* tb)
        {
                stop(tb);

#ifdef _WINDOWS
                tb->_mthread = (HANDLE) _beginthreadex(0, 0, pEntrance, params, 0, &tb->_tid);
                if(! tb->_mthread)
                {
                        //return start thread error flag
                        return -1;
                }
#else
                int error = pthread_create(&tb->_mthread, 0, pEntrance, params);
                if(error)
                {
                        return -1;
                }
#endif // WINDOWS

                tb->setState(ThreadStateRunning::instance());
                return 0;
        }

        ThreadBase::ThreadBase()
                : _state(ThreadStateStoped::instance()), _mthread(0)
        {

        }

        ThreadBase::~ThreadBase()
        {
                stop();
        }

        int ThreadBase::start(PTR_THREAD_ENTRANCE pEntrance, void* params)
        {
                return _state->start(pEntrance, params, this);
        }

        int ThreadBase::stop()
        {
                return _state->stop(this);
        }

        ThreadTimer::ThreadTimer()
                : _mTask(0), _mDelay(0), _mLastTick(0)
        {
        }

        ThreadTimer::~ThreadTimer()
        {
                shutdown();
        }

        int ThreadTimer::schedule(ThreadTask* task, const ULONG delay)
        {
			shutdown();
            if(! task)
                return 1;

                _mTask = task;
                _mDelay = delay;

                return _mThread.start(&ThreadTimer::entrance, (void*)this);
        }

        void ThreadTimer::shutdown()
        {
            _mutex.lock();    
			if(_mTask)
            {
                //delete _mTask;
                _mTask = 0;
            }
			_mutex.unlock();

                _mThread.stop();
        }

        void ThreadTimer::tick()
        { 
                ULONG curTime = clock();
                ULONG interval = ((curTime - _mLastTick) / CLOCKS_PER_SEC);
                if(interval < _mDelay)
                {
                        //wait more time
                        sleeping(1);
                }
                else
                {
                        _mLastTick = curTime;
                        _mutex.lock();
                        if(_mTask) _mTask->run();
                        _mutex.unlock();
                }
        }

        THREAD_ENTRANCE_RETURN THREAD_ENTRANCE_CALL ThreadTimer::entrance(void* params)
        {
                if(! params)
                {
                        return 0;
                }

                ThreadTimer *service = static_cast<ThreadTimer*>(params);
                if(! service)
                {
                        return 0;
                }

                do
                {

                        ThreadTask* task = service->fetchWork();
                        if(! task)
                        {
                                break;
                        }

                        service->tick();
                        
                }while(1);

                service->_mThread.setState(ThreadStateStoped::instance());
                return 0;
        }

        ThreadService::ThreadService()
                : _mTask(0)
        {
        }

        ThreadService::~ThreadService()
        {
                shutdown();
        }

        int ThreadService::execute(ThreadTask* task)
        {
			shutdown();
            if(!task)
                return 1;

            _mTask = task;

                return _mThread.start(&ThreadService::entrance, (void*)this);
        }

        void ThreadService::shutdown()
        {
            _mutex.lock();
            if(_mTask)
            {
                delete _mTask;
                //_mTask = 0;
            }
            _mutex.unlock();

                _mThread.stop();
        }

        THREAD_ENTRANCE_RETURN THREAD_ENTRANCE_CALL ThreadService::entrance(void* params)
        {
                if(! params)
                {
                        return 0;
                }

                ThreadService *service = static_cast<ThreadService*>(params);
                if(! service)
                {
                        return 0;
                }
                
                do
                {
                        service->_mutex.lock();
                        ThreadTask* task = service->fetchWork();
            service->resetWork();
            service->_mutex.unlock();
            
                        if(task)
                        {
                                task->run();
                        }
                        
                }while(0);

                service->_mThread.setState(ThreadStateStoped::instance());
                return 0;
        }

        SingleThreadExecuter::SingleThreadExecuter()
                : _running(false)
        {
        }

        SingleThreadExecuter::~SingleThreadExecuter()
        {
                shutdown();
        }
        
        void SingleThreadExecuter::shutdown()
        {
            //clear task first
            clearWork();

            //_mutex.lock();
            _running = false;
            //_mutex.unlock();

			_mThread.stop();
        }

        void SingleThreadExecuter::clearWork()
        {
                _mutexWork.lock();
                while(! _mWorkQueue.empty())
                {
                        ThreadTask* task = _mWorkQueue.front();
                        _mWorkQueue.pop();
                        if(task)
                        {
                                //delete task;
                                task = 0;
                        }               
                }
                _mutexWork.unlock();
        }

        void SingleThreadExecuter::assignWork(ThreadTask *task)
        {
                if(! task) return;

                _mutexWork.lock();
                _mWorkQueue.push(task);
                _mutexWork.unlock();
        }
        
        ThreadTask* SingleThreadExecuter::fetchWork()
        {
            ThreadTask* task = 0;
            _mutexWork.lock();
            if(!_mWorkQueue.empty())
            {
				task = _mWorkQueue.front();
				_mWorkQueue.pop();
            }
            _mutexWork.unlock();
            return task;
        }

        int SingleThreadExecuter::execute(ThreadTask* task)
        {
            assignWork(task);
                
            //_mutex.lock();
            if(!_running)
            {
                _running = true;
                _mThread.start(&SingleThreadExecuter::entrance, (void*)this);
            }
            //_mutex.unlock();

			/*
#ifdef _WINDOWS
            
#else
            pthread_mutex_lock(&mtx);
            pthread_cond_signal(&cond);
            pthread_mutex_unlock(&mtx);
#endif//WINDOWS
			*/

                return 0;
        }


        THREAD_ENTRANCE_RETURN THREAD_ENTRANCE_CALL SingleThreadExecuter::entrance(void* params)
        {
                if(! params)
                {
                        return 0;
                }

                SingleThreadExecuter *service = static_cast<SingleThreadExecuter*>(params);
                if(! service)
                {
                        return 0;
                }

                do
                {
                        ThreadTask* task = service->fetchWork();
                        if(task == 0)
                        {
							sleeping(0.1f);
							continue;
							/*
#ifdef _WINDOWS
                            sleeping(0.1f);
                            continue;
#else
							pthread_mutex_lock(&mtx);
							pthread_cond_wait(&cond, &mtx);
							pthread_mutex_unlock(&mtx);
                            continue;
                            //struct timespec tv;
                            //clock_gettime(CLOCK_MONOTONIC, &tv);
                            //tv.tv_sec = time(0)+1;
                            //tv.tv_nsec = 100000;
                            //pthread_mutex_lock(&mtx);
                            //pthread_cond_timedwait(&cond, &mtx, &tv);
                            //pthread_mutex_unlock(&mtx);
                            //continue;
#endif//WINDOWS
							*/
                        }

                        task->run();
                        //delete task;
                }while(service->isRunning());
                return 0;
        }