#pragma once
#include "Singleton.h"
#include "Concurrency.h"
#include <list>
#include <set>
#include <string>

class CurlUpload : public Singleton<CurlUpload>
{	
private:
	class UploadFile
	{
	public:
		std::string _remoteUrl;
		std::string _upFilename;
		std::string _localUrl;
		long _tryTimes;
		UploadFile( const std::string &remoteUrl, const std::string& upFilename,const std::string& localUrl,long tryTimes)
			   :_remoteUrl(remoteUrl),_upFilename(upFilename),_localUrl(localUrl),_tryTimes(tryTimes){};
	};
	typedef std::list<UploadFile> UploadQueue;
	UploadQueue mUploadQueue;// operated in main thread


public:
	CurlUpload(void);
	~CurlUpload(void);

	class UploadListener
	{
	public:
		virtual void Uploaded(const std::string &remoteUrl, const std::string& upFilename,const std::string& localUrl,long tryTimes){};
		virtual void UploadFailed(const std::string &remoteUrl, const std::string& upFilename,const std::string& localUrl,long tryTimes,long errCode){};
	};
	
	void uploadFile(const std::string &remoteUrl, const std::string& upFilename,const std::string& localUrl,long tryTimes);

	void addListener(UploadListener* listener){_mutex.lock();mListeners.insert(listener);_mutex.unlock();}
	void removeListener(UploadListener* listener){_mutex.lock();mListeners.erase(listener);_mutex.unlock();}
	void removeAllListener(){_mutex.lock();mListeners.clear();_mutex.unlock();}

	int getUploadQueueSize(){return mUploadQueue.size();}
	void update(float dt);

private:
	std::set<UploadListener*> mListeners;
	Mutex _mutex;		
};

