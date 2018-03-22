#pragma once
#include "Singleton.h"
#include "Concurrency.h"
#include <list>
#include <set>
#include <string>

class CurlDownload : public Singleton<CurlDownload>
{	
private:
	class DownloadFile
	{
	public:
		std::string _url;
		std::string _filename;
		unsigned short _crc;
		bool _checkCRC;

		DownloadFile( const std::string &url, const std::string& filename)
			   :_url(url),_filename(filename),_checkCRC(false){}
		DownloadFile( const std::string &url, const std::string& filename, unsigned short crc)
			:_url(url),_filename(filename),_crc(crc),_checkCRC(true){}
	};
	typedef std::list<DownloadFile> DownloadQueue;
	DownloadQueue mDownloadQueue;// operated in main thread


public:
	CurlDownload(void);
	~CurlDownload(void);

	void reInit();

	class DownloadListener
	{
	public:
		virtual void downloaded(const std::string& url,const std::string& filename){};
		virtual void downloadFailed(const std::string& url, const std::string& filename){};
	};
	
	void downloadFile(const std::string & url, const std::string& filename);
	void downloadFile(const std::string & url, const std::string& filename,unsigned short crcCheck);

	void addListener(DownloadListener* listener){_mutex.lock();mListeners.insert(listener);_mutex.unlock();}
	void removeListener(DownloadListener* listener){_mutex.lock();mListeners.erase(listener);_mutex.unlock();}
	void removeAllListener(){_mutex.lock();mListeners.clear();_mutex.unlock();}

	int getDownloadQueueSize(){return mDownloadQueue.size();}
	void update(float dt);

private:
	std::set<DownloadListener*> mListeners;
	Mutex _mutex;		
};

