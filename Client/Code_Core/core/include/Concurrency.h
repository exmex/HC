#pragma once
#include "Singleton.h"


#include <queue>
#include <list>

#ifdef _WINDOWS
#include <windows.h>
#else
#include <pthread.h>
#endif//WINDOWS

#ifndef ULONG
typedef unsigned long ULONG;
#endif //ULONG

#define OUTPUT_DLL

        //thread entrance is different caused by different platform
#ifndef THREAD_ENTRANCE_RETURN
#ifdef _WINDOWS
        typedef unsigned int THREAD_ENTRANCE_RETURN;
#else
        typedef void* THREAD_ENTRANCE_RETURN;
#endif//WINDOWS
#endif//THREAD_ENTRANCE_RETURN

#ifndef THREAD_ENTRANCE_CALL
#ifdef _WINDOWS
#define THREAD_ENTRANCE_CALL __stdcall
#else
#define THREAD_ENTRANCE_CALL 
#endif//WINDOWS
#endif//THREAD_ENTRANCE_CALL

#ifndef PTR_THREAD_ENTRANCE
        typedef THREAD_ENTRANCE_RETURN(THREAD_ENTRANCE_CALL *PTR_THREAD_ENTRANCE)(void*);
#endif//PTR_THREAD_ENTRANCE

        static void sleeping(float ts);

        //Mutex, lock protected for multi-thread
        class OUTPUT_DLL Mutex
        {
        public:
                Mutex();
                virtual ~Mutex();

                virtual void lock();
                virtual void unlock();

        protected:
#ifdef _WINDOWS
                HANDLE _mutex;
#else
                pthread_mutex_t _mutex;
#endif//WINDOWS
        };

        class OUTPUT_DLL AutoRelaseLock
        {
        protected:
                Mutex& mMutex;
        public:
                AutoRelaseLock(Mutex& _mutex)
                        :mMutex(_mutex)
                {
                        _mutex.lock();
                }
                virtual ~AutoRelaseLock()
                {
                        mMutex.unlock();
                }

        };

        class ThreadBase;
        //state
        class OUTPUT_DLL ThreadState/* : public Singleton<ThreadState>*/
        {
        public:
                ThreadState(){}
                virtual ~ThreadState(){}
                virtual int start(PTR_THREAD_ENTRANCE pEntrance, void* params, ThreadBase* tb){return 0;}
                virtual int stop(ThreadBase* tb){return 0;}
        };

        class OUTPUT_DLL ThreadStateRunning : public ThreadState, public Singleton<ThreadStateRunning>
        {
        public:
                ThreadStateRunning(){}
                virtual ~ThreadStateRunning(){}
                virtual int stop(ThreadBase* tb);

                static ThreadStateRunning* instance(){return Singleton<ThreadStateRunning>::Get();}
        };

        class OUTPUT_DLL ThreadStateStoped : public ThreadState, public Singleton<ThreadStateStoped>
        {
        public:
                ThreadStateStoped(){}
                virtual ~ThreadStateStoped(){}
                virtual int start(PTR_THREAD_ENTRANCE pEntrance, void* params, ThreadBase* tb);

                static ThreadStateStoped* instance(){return Singleton<ThreadStateStoped>::Get();}
        };

        //base thread
        class OUTPUT_DLL ThreadBase
        {
        public:
                ThreadBase();
                virtual ~ThreadBase();

                virtual int start(PTR_THREAD_ENTRANCE pEntrance, void* params);
                virtual int stop();
                virtual void setState(ThreadState* state){_state=state;}

                friend class ThreadState;
                friend class ThreadStateRunning;
                friend class ThreadStateStoped;
        protected:
                //Mutex _mutex;
                ThreadState* _state;
#ifdef _WINDOWS
                HANDLE _mthread;
                unsigned int _tid;
#else
                pthread_t _mthread;
#endif //WINDOWS
        };

        //thread task interface
        class OUTPUT_DLL ThreadTask
        {
        public:
                ThreadTask(){}
                virtual ~ThreadTask(){}

                virtual int run(){return 0;} 
        };

        //schedule interface
        class OUTPUT_DLL ThreadSchedule
        {
        public:
                ThreadSchedule(){}
                virtual ~ThreadSchedule(){}

                virtual int schedule(ThreadTask* task, const ULONG delay) = 0;
                virtual void shutdown() = 0;
                virtual ThreadTask* fetchWork() = 0;
        };

        //execute interface
        class OUTPUT_DLL ThreadExecuter
        {
        public:
                ThreadExecuter(){}
                virtual ~ThreadExecuter(){}

                virtual int execute(ThreadTask* task) = 0;
                virtual void shutdown() = 0;
                virtual ThreadTask* fetchWork() = 0;
        };

        //timer task在delaytime后一直run
        class OUTPUT_DLL ThreadTimer : public ThreadSchedule
        {
        public:
                ThreadTimer();
                virtual ~ThreadTimer();

                virtual int schedule(ThreadTask* task, const ULONG delay);
                virtual void shutdown();
                virtual ThreadTask* fetchWork(){return _mTask;}
                static THREAD_ENTRANCE_RETURN THREAD_ENTRANCE_CALL entrance(void* params);

                virtual void tick();
        protected:
                Mutex _mutex;
                ThreadTask* _mTask;
                ThreadBase _mThread;
                ULONG _mDelay;
                ULONG _mLastTick;
        };

        //service task只run，每次执行都重新开线程
        class OUTPUT_DLL ThreadService : public ThreadExecuter
        {
        public:
                ThreadService();
                virtual ~ThreadService();

                virtual int execute(ThreadTask* task);
                virtual void shutdown();
                virtual ThreadTask* fetchWork(){return _mTask;}
        virtual void resetWork(){_mTask = 0;}
                static THREAD_ENTRANCE_RETURN THREAD_ENTRANCE_CALL entrance(void* params);
        protected:
                Mutex _mutex;
                ThreadTask* _mTask;
                ThreadBase _mThread;
        };

		//维护一个task队列，每次去对头task来run，线程会一直开启，除非手动shutdown
        class OUTPUT_DLL SingleThreadExecuter : public ThreadExecuter
        {
        public:
            SingleThreadExecuter();
            virtual ~SingleThreadExecuter();

            virtual int execute(ThreadTask* task);
            virtual void shutdown();
            virtual ThreadTask* fetchWork();
            static THREAD_ENTRANCE_RETURN THREAD_ENTRANCE_CALL entrance(void* params);
			bool isRunning(){return _running;}

        protected:
			void assignWork(ThreadTask *task);
            void clearWork();
        protected:
            Mutex _mutexWork;
            //Mutex _mutex;
            std::queue<ThreadTask*> _mWorkQueue;
            ThreadBase _mThread;
            bool _running;
        };
