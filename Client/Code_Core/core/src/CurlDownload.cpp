
#include "stdafx.h"

#include "CurlDownload.h"
#include "curl/curl.h"
#include "GameMaths.h"
#include <list>
#include <cstdio>

#include "GamePlatform.h"

class DownloadPoolTask : public ThreadTask
{
private:
	std::string url;
	std::string filename;
public:
	DownloadPoolTask(const std::string& _url, const std::string& _filename)
	{
		url = _url;
		filename = _filename;
	}
	int run();
};


class DownLoadTask:public Singleton<DownLoadTask>
{
private:
	std::string _url;
	std::string _filename;
	bool _crcCheck;
	unsigned short _crc;

	Mutex _mutex;
	ThreadService mThread;

	Mutex _DataMutex;
	unsigned char* _data;
	unsigned long _size;

public:
	enum DLTASK
	{
		DL_READY,
		DL_OK,
		DL_PROCESSING,
		DL_FAILED,
	}mTaskState;
	DownLoadTask():mTaskState(DL_READY),_mutex(),_data(0),_DataMutex(),_size(0){}
	~DownLoadTask()	{}

	bool startTask(const std::string& url, const std::string& filename,bool crcCheck, unsigned short crc)
	{
		if(checkTask() == DL_PROCESSING)
			return false;
		
		_data = 0;
		_size = 0;

		_url = url;
		_filename = filename;
		_crc = crc;
		_crcCheck = crcCheck;

		mTaskState = DL_PROCESSING;
		DownloadPoolTask * task = new DownloadPoolTask(url,filename);
		mThread.execute(task);

		
		return true;
	}

	//set data in thread
	void setData(unsigned char* buff, unsigned long size,unsigned long nmemb)
	{
		_DataMutex.lock();

		unsigned char *newbuff = new unsigned char[size*nmemb+_size];
		if(_data && _size>0)
			memcpy(newbuff,_data,_size);
		memcpy(newbuff+_size,buff,size*nmemb);
		if(_data)delete[]_data;

		_data = newbuff;
		_size += size*nmemb;
		_DataMutex.unlock();
	}

	unsigned short getDataCRC()
	{
		_DataMutex.lock();
		unsigned short ret = GameMaths::GetCRC16(_data,_size);
		_DataMutex.unlock();
		return ret;
	}

	//save data in main thread
	void saveData()
	{
		_DataMutex.lock();

		saveFileInPath(_filename,"wb",_data,_size);
		if(_data)
		{
			delete[] _data;
			_data = 0;
		}

		_DataMutex.unlock();
	}
	DLTASK checkTask(){return mTaskState;}
	const std::string& getFilename(){return _filename;}
	const std::string& getURL(){return _url;}
	bool getCheckCRC(){return _crcCheck;}
	unsigned short getCRC(){return _crc;}
public:
	void setDone()
	{
		if(checkTask()!=DL_OK)
		{
			_mutex.lock();
			mTaskState = DL_OK;
			_mutex.unlock();
		}
	}
	void setFailed()
	{
		if(checkTask()!=DL_FAILED)
		{
			_mutex.lock();
			mTaskState = DL_FAILED;
			_mutex.unlock();
		}
	}
	void setReady()
	{
		_mutex.lock();
		mThread.shutdown();
		mTaskState = DL_READY;
		_mutex.unlock();
	}
};
DownLoadTask* _tempTask = DownLoadTask::Get();

size_t process_data(void *buffer, size_t size, size_t nmemb, void *user_p) 
{  
	DownLoadTask::Get()->setData((unsigned char*)buffer,size,nmemb);
	return size*nmemb; 
}

int DownloadPoolTask::run()
{
	// 获取easy handle  
	CURL* easy_handle = curl_easy_init();  
	if (NULL == easy_handle)  
	{   
		DownLoadTask::Get()->setFailed();
		return false;  
	} 
	  
	// 设置easy handle属性  
	curl_easy_setopt(easy_handle, CURLOPT_URL, url.c_str());  
	curl_easy_setopt(easy_handle, CURLOPT_WRITEFUNCTION, &process_data); 
    curl_easy_setopt(easy_handle, CURLOPT_CONNECTTIMEOUT,10);
    curl_easy_setopt(easy_handle, CURLOPT_TIMEOUT,5*60);

	if (url.find("curlsignal") == std::string::npos)	
		curl_easy_setopt(easy_handle, CURLOPT_NOSIGNAL, 1);

	curl_easy_setopt(easy_handle, CURLOPT_HEADER, 0);
	curl_easy_setopt(easy_handle, CURLOPT_SSL_VERIFYPEER, 0);
	curl_easy_setopt(easy_handle, CURLOPT_SSL_VERIFYHOST, 0);
	curl_easy_setopt(easy_handle, CURLOPT_FORBID_REUSE, 1); 

	// 执行数据请求  
	if(CURLE_OK == curl_easy_perform(easy_handle))  
		DownLoadTask::Get()->setDone();
	else
		DownLoadTask::Get()->setFailed();

	curl_easy_cleanup(easy_handle);
	return 0;
}


void CurlDownload::update( float dt )
{
	//mutex is to avoid changes of listeners list in listeners' callback
	_mutex.lock();
	bool sendOK = false;
	bool sendFailed = false;
	if(DownLoadTask::Get()->checkTask() == DownLoadTask::DL_OK)
	{
		if(DownLoadTask::Get()->getCheckCRC())
		{
			if(DownLoadTask::Get()->getDataCRC() == DownLoadTask::Get()->getCRC())
				sendOK = true;
			else
				sendFailed = true;
		}
		else
			sendOK = true;
	}
	else if(DownLoadTask::Get()->checkTask() == DownLoadTask::DL_FAILED)
		sendFailed = true;

	if(sendOK)
	{
		DownLoadTask::Get()->saveData();
		DownLoadTask::Get()->setReady();
		for(std::set<DownloadListener*>::iterator it = mListeners.begin();it!=mListeners.end();++it)
		{
			(*it)->downloaded(DownLoadTask::Get()->getURL(),DownLoadTask::Get()->getFilename());
		}
	}
	if(sendFailed)
	{
		DownLoadTask::Get()->setReady();
		for(std::set<DownloadListener*>::iterator it = mListeners.begin();it!=mListeners.end();++it)
		{
			(*it)->downloadFailed(DownLoadTask::Get()->getURL(),DownLoadTask::Get()->getFilename());
		}
	}
	_mutex.unlock();

	if(!mDownloadQueue.empty() && DownLoadTask::Get()->checkTask() == DownLoadTask::DL_READY)
	{
		DownloadQueue::iterator it = mDownloadQueue.begin();
		const std::string& url = it->_url;
		const std::string& filename = it->_filename;
		if(DownLoadTask::Get()->startTask(url,filename,it->_checkCRC,it->_crc))
		{
			mDownloadQueue.erase(it);
		}
	}
}

void CurlDownload::downloadFile( const std::string & url, const std::string& filename )
{
	DownloadFile file(url,filename);
	mDownloadQueue.push_back(file);
}

void CurlDownload::downloadFile( const std::string & url, const std::string& filename,unsigned short crcCheck )
{
	DownloadFile file(url,filename,crcCheck);
	mDownloadQueue.push_back(file);
}

CurlDownload::CurlDownload()
{
	curl_global_init(CURL_GLOBAL_ALL);
}

CurlDownload::~CurlDownload()
{
	DownLoadTask::Get()->Free();

	curl_global_cleanup();
}

void CurlDownload::reInit()
{
	curl_global_cleanup();
	curl_global_init(CURL_GLOBAL_ALL);
}
