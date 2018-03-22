
#include "stdafx.h"

#include "CurlUpload.h"
#include "curl/curl.h"
#include "GameMaths.h"
#include <list>
#include <cstdio>

#include "GamePlatform.h"

class UploadPoolTask : public ThreadTask
{
private:
	std::string remoteUrl;
	std::string upFilename;
	std::string localUrl;
	long tryTimes;
public:
	UploadPoolTask(const std::string& _remoteUrl, const std::string& _filename,const std::string& _localUrl,long _tryTimes)
	{
		remoteUrl = _remoteUrl;
		upFilename = _filename;
		localUrl = _localUrl;
		tryTimes = _tryTimes;
	}
	int run();
};


class UploadTask:public Singleton<UploadTask>
{
private:
	std::string remoteUrl;
	std::string upFilename;
	std::string localUrl;
	long		tryTimes;
	Mutex _mutex;
	ThreadService mThread;
	long		retCode;
	Mutex _DataMutex;
	unsigned char* _data;
	unsigned long _size;

public:
	enum ULTASK
	{
		UL_READY,
		UL_OK,
		UL_PROCESSING,
		UL_FAILED,
	}mTaskState;
	UploadTask():mTaskState(UL_READY),_mutex(),_data(0),_DataMutex(),_size(0){}
	~UploadTask()	{}

	bool startTask(const std::string& _remoteUrl, const std::string& _filename,const std::string& _localUrl,long _tryTimes)
	{
		if(checkTask() == UL_PROCESSING)
			return false;

		retCode=0;	
		_data = 0;
		_size = 0;

		remoteUrl = _remoteUrl;
		upFilename = _filename;
		localUrl = _localUrl;
		tryTimes = _tryTimes;

		mTaskState = UL_PROCESSING;
		UploadPoolTask * task = new UploadPoolTask(remoteUrl,upFilename,localUrl,tryTimes);
		mThread.execute(task);

		
		return true;
	}

	ULTASK checkTask(){return mTaskState;}
	const std::string& getFilename(){return upFilename;}
	const std::string& getRemoteURL(){return remoteUrl;}
	const std::string& getLocalUrl(){return localUrl;}
	long getTryTimes(){return tryTimes;}
	long getRetCode() { return retCode;} 
public:
	void setDone()
	{
		if(checkTask()!=UL_OK)
		{
			_mutex.lock();
			mTaskState = UL_OK;
			_mutex.unlock();
		}
	}
	void setFailed(long _retCode)
	{
		if(checkTask()!=UL_FAILED)
		{
			retCode=_retCode;
			_mutex.lock();
			mTaskState = UL_FAILED;
			_mutex.unlock();
		}
	}
	void setReady()
	{
		_mutex.lock();
		mThread.shutdown();
		mTaskState = UL_READY;
		_mutex.unlock();
	}
};
UploadTask* _tempUploadTask = UploadTask::Get();


/* read data to upload */  
size_t readfunc(void *ptr, size_t size, size_t nmemb, void *stream)  
{  
	FILE *f = (FILE*)stream;  
	size_t n;  
	if (ferror(f))  
		return CURL_READFUNC_ABORT;  
	n = fread(ptr, size, nmemb, f) * size;  
	return n;  
} 

/* discard downloaded data */  
size_t discardfunc(void *ptr, size_t size, size_t nmemb, void *stream)   
{  
	return size * nmemb;  
}  

/* parse headers for Content-Length */  
size_t getcontentlengthfunc(void *ptr, size_t size, size_t nmemb, void *stream)   
{  
	int r;  
	long len = 0;  
	/* _snscanf() is Win32 specific */  
	//r = _snscanf(ptr, size * nmemb, "Content-Length: %ld\n", &len);  
	r = sscanf((const char*)ptr, "Content-Length: %ld\n", &len);  
	if (r) /* Microsoft: we don't read the specs */  
		*((long *) stream) = len;  
	return size * nmemb;  
}  

int UploadPoolTask::run()
{

	FILE *f;  
	long uploaded_len = 0;  
	CURLcode retCode = CURLE_GOT_NOTHING;  
	int count;  
	f = fopen(localUrl.c_str(), "rb");  
	if (f == NULL) 
	{  
		perror(NULL);  
		UploadTask::Get()->setFailed(retCode);
		return 0;
	}  

	// 获取easy handle  
	CURL* easy_handle = curl_easy_init();  
	if (NULL == easy_handle)  
	{   
		UploadTask::Get()->setFailed(-1L);
		return false;  
	} 

	// 设置easy handle属性
	curl_easy_setopt(easy_handle, CURLOPT_UPLOAD, 1L);  
	curl_easy_setopt(easy_handle, CURLOPT_URL, remoteUrl.c_str());  
	//curl_easy_setopt(easy_handle, CURLOPT_USERPWD, "");
	
	// 文本文件中的数据
	//curl_formadd(&post, &last, CURLFORM_COPYNAME, "file", CURLFORM_FILECONTENT, "ReadMe.txt", CURLFORM_END);
	curl_easy_setopt(easy_handle, CURLOPT_PUT, 1L);
	curl_easy_setopt(easy_handle, CURLOPT_HEADERFUNCTION, getcontentlengthfunc);  
	curl_easy_setopt(easy_handle, CURLOPT_HEADERDATA, &uploaded_len);  
	curl_easy_setopt(easy_handle, CURLOPT_WRITEFUNCTION, discardfunc);  
	curl_easy_setopt(easy_handle, CURLOPT_READFUNCTION, readfunc);  
	curl_easy_setopt(easy_handle, CURLOPT_READDATA, f);  
	curl_easy_setopt(easy_handle, CURLOPT_FTPPORT, "-"); /* disable passive mode */  
	curl_easy_setopt(easy_handle, CURLOPT_FTP_CREATE_MISSING_DIRS, 1L);  
	curl_easy_setopt(easy_handle, CURLOPT_VERBOSE, 1L);  

    curl_easy_setopt(easy_handle, CURLOPT_CONNECTTIMEOUT,10);
    curl_easy_setopt(easy_handle, CURLOPT_TIMEOUT,5*60);

	if (remoteUrl.find("curlsignal") == std::string::npos)	
		curl_easy_setopt(easy_handle, CURLOPT_NOSIGNAL, 1);

	//curl_easy_setopt(easy_handle, CURLOPT_HEADER, 0);
	//curl_easy_setopt(easy_handle, CURLOPT_SSL_VERIFYPEER, 0);
	//curl_easy_setopt(easy_handle, CURLOPT_SSL_VERIFYHOST, 0);
	//curl_easy_setopt(easy_handle, CURLOPT_FORBID_REUSE, 1); 

	for (count = 0; (retCode != CURLE_OK) && (count < tryTimes); count++) 
	{  
        /* are we resuming? */  
        if (count) 
		{ /* yes */  
            /* determine the length of the file already written */  
            /* 
            * With NOBODY and NOHEADER, libcurl will issue a SIZE 
            * command, but the only way to retrieve the result is 
            * to parse the returned Content-Length header. Thus, 
            * getcontentlengthfunc(). We need discardfunc() above 
            * because HEADER will dump the headers to stdout 
            * without it. 
            */  
            curl_easy_setopt(easy_handle, CURLOPT_NOBODY, 1L);  
            curl_easy_setopt(easy_handle, CURLOPT_HEADER, 1L);  
            retCode = curl_easy_perform(easy_handle);  
            if (retCode != CURLE_OK)  
                continue;  
            curl_easy_setopt(easy_handle, CURLOPT_NOBODY, 0L);  
            curl_easy_setopt(easy_handle, CURLOPT_HEADER, 0L);  
            fseek(f, uploaded_len, SEEK_SET);  
            curl_easy_setopt(easy_handle, CURLOPT_APPEND, 1L);  
        }  
        else 
		{ /* no */  
            curl_easy_setopt(easy_handle, CURLOPT_APPEND, 0L);  
        }  
        retCode = curl_easy_perform(easy_handle);  
    }  

    fclose(f);  
    if (retCode == CURLE_OK)  
	{
		UploadTask::Get()->setDone();
		return 1;  
	}
    else 
	{  
		UploadTask::Get()->setFailed(retCode);
        return 0;  
    }  
	curl_easy_cleanup(easy_handle);
	return 0;
}


void CurlUpload::update( float dt )
{
	//mutex is to avoid changes of listeners list in listeners' callback
	_mutex.lock();
	bool sendOK = false;
	bool sendFailed = false;
	if(UploadTask::Get()->checkTask() == UploadTask::UL_OK)
	{
		sendOK = true;
	}
	else if(UploadTask::Get()->checkTask() == UploadTask::UL_FAILED)
		sendFailed = true;

	if(sendOK)
	{
		UploadTask::Get()->setReady();
		for(std::set<UploadListener*>::iterator it = mListeners.begin();it!=mListeners.end();++it)
		{
			(*it)->Uploaded(UploadTask::Get()->getRemoteURL(),UploadTask::Get()->getFilename(),UploadTask::Get()->getLocalUrl(),UploadTask::Get()->getTryTimes());
		}
	}
	if(sendFailed)
	{
		UploadTask::Get()->setReady();
		for(std::set<UploadListener*>::iterator it = mListeners.begin();it!=mListeners.end();++it)
		{
			(*it)->UploadFailed(UploadTask::Get()->getRemoteURL(),UploadTask::Get()->getFilename(),UploadTask::Get()->getLocalUrl(),UploadTask::Get()->getTryTimes(),UploadTask::Get()->getRetCode());
		}
	}
	_mutex.unlock();

	if(!mUploadQueue.empty() && UploadTask::Get()->checkTask() == UploadTask::UL_READY)
	{
		UploadQueue::iterator it = mUploadQueue.begin();
		const std::string& remoteUrl = it->_remoteUrl;
		const std::string& upFilename = it->_upFilename;
		const std::string& localUrl = it->_localUrl;
		if(UploadTask::Get()->startTask(remoteUrl,upFilename,localUrl,it->_tryTimes))
		{
			mUploadQueue.erase(it);
		}
	}
}

void CurlUpload::uploadFile(const std::string &remoteUrl, const std::string& upFilename,const std::string& localUrl,long tryTimes)
{
	UploadFile _file(remoteUrl,upFilename,localUrl,tryTimes);
	mUploadQueue.push_back(_file);
}

CurlUpload::CurlUpload()
{
	curl_global_init(CURL_GLOBAL_ALL);
}

CurlUpload::~CurlUpload()
{
	UploadTask::Get()->Free();

	curl_global_cleanup();
}
