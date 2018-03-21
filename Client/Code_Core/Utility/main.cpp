// encryption_aes.cpp : Defines the entry point for the console application.
//

#include "stdafx.h"
#include <stdlib.h>
#include <stdio.h>
#include <iostream>
#include <io.h>
#include <bitset>
#include <utility>
#include <string>
#include <fstream>
#include <iostream>
#include <list>
#include <vector>
#include <json/json.h>
#include <map>

#include "zlib/zlib.h"
#include "AES.h"
#include "GameMaths.h"
#include "AsyncSocket.h"
#include "PacketManager.h"
#include "rc4.h"
#include "GameEncryptKey.h"
#include "md5.h"
#include "Base64.h"
using namespace std;
#define CC_BREAK_IF(cond) if(cond) break

unsigned char* _getFileData(const char* pszFileName, const char* pszMode, unsigned long* pSize)
{
	unsigned char* pBuffer = NULL;
	
	*pSize = 0;
	do 
	{
		// read the file from hardware
		FILE *fp = fopen(pszFileName, pszMode);
		CC_BREAK_IF(!fp);

		fseek(fp,0,SEEK_END);
		*pSize = ftell(fp);
		fseek(fp,0,SEEK_SET);
		pBuffer = new unsigned char[*pSize];
		*pSize = fread(pBuffer,sizeof(unsigned char), *pSize,fp);
		fclose(fp);
	} while (0);

	return pBuffer;
}

#define ARG_OPERATION (argv[1])
#define ARG_OUTFILE (argv[3])
#define ARG_INFILE (argv[2])
#define ARG_PARA (argv[4])
int checkFile(int argc, char* argv[])
{
	ifstream is(ARG_INFILE, ios::in | ios::binary);
	if(!is)
	{
		cerr << "InputFileNotFoundException" << endl;
		return 2;
	}

	is.close();
	return 0;
}
int encrypt(int argc, char* argv[])
{
	if(argc != 5)
		return 1;

	if(checkFile(argc,argv)!=0)
		return 2;
	
	if(strlen(ARG_PARA) != 16)
	{
		cerr << "Key must be 16 byte(128bit)" << endl;
		return 2;
	}

	AES aes;

	unsigned long size = 0;
	unsigned char* dataIn = _getFileData(ARG_INFILE,"rb",&size);
	unsigned char* dataOut = new unsigned char[size+2];
	dataOut[0]=0xef;
	dataOut[1]=0xfe;
	aes.Encrypt(dataIn,size,dataOut+2,(const unsigned char*)(ARG_PARA));

	FILE* fp;
	fp = fopen(ARG_OUTFILE,"wb");
	fwrite(dataOut,1, size+2,fp);
	fclose(fp); 
	delete[] dataOut; 
	delete[] dataIn;
	return 0;
}

int decrypt(int argc, char* argv[])
{

	if(argc != 5)
		return 1;
	if(checkFile(argc,argv)!=0)
		return 2;


	if(strlen(ARG_PARA)!=16)
	{
		cerr << "Key must be 16 byte(128bit)" << endl;
		return 2;
	}

	AES aes;
	unsigned long size = 0;
	unsigned char* dataIn = _getFileData(ARG_INFILE,"rb",&size);
	if(dataIn[0]!=0xef || dataIn[1]!=0xfe)
		printf("error file head!");
	size-=2;
	dataIn;
	unsigned char* data3 = new unsigned char[size];
	aes.Decrypt(dataIn+2,size,data3,(const unsigned char*)(ARG_PARA));

	FILE* fp;
	fp = fopen(ARG_OUTFILE,"wb");
	fwrite(data3,1,size,fp);
	fclose(fp);
	delete[] data3;
	delete[] dataIn;

}

struct FileInfo
{
	std::string name;
	int crc;
	int size;
};

void getFiles(const std::string& rootpath,const std::string& subpath, std::list<FileInfo* > & filelist )
{
	_finddata_t file;
	std::string findfiles = rootpath;
	findfiles.append("/");
	findfiles.append(subpath);
	findfiles.append("/*.*");
	long lf;
	if((lf = _findfirst(findfiles.c_str(), &file))==-1l)//_findfirst返回的是long型; long __cdecl _findfirst(const char *, struct _finddata_t *)
		cout<<"Path:" + findfiles + " not found\n";
	else
	{
		//cout<<"\nfile list:\n";
		while( _findnext( lf, &file ) == 0 )//int __cdecl _findnext(long, struct _finddata_t *);如果找到下个文件的名字成功的话就返回0,否则返回-1
		{
			//cout<<file.name;
			switch (file.attrib)
			{
			case _A_SUBDIR:
				//cout<<" subdir";
				if(strcmp(file.name,"..")!=0 && strcmp(file.name,".svn")!=0)
				{
					std::string thesubpath = subpath+"/"+file.name;
					getFiles(rootpath,thesubpath,filelist);
				}
				break;
			case _A_NORMAL:
			case _A_RDONLY:
			case _A_HIDDEN:
			case _A_SYSTEM:
			default:
				{
					//cout<<" file";
					if (strcmp(file.name,".svn") == 0)
						continue;

					std::string thefile = subpath+"/";
					thefile.append(file.name);
					unsigned long size = 0;
					unsigned char* dataIn = _getFileData((rootpath+"/"+thefile).c_str(),"rb",&size);
					unsigned short crcvalue = GameMaths::GetCRC16(dataIn,size);
					FileInfo *fileinfo = new FileInfo;
					fileinfo->name = thefile;
					fileinfo->crc = crcvalue;
					fileinfo->size = size;
					filelist.push_back(fileinfo);
					delete[] dataIn;
					break;
				}
			}
			//cout<<endl;
		}
	}
	_findclose(lf);
}

void subFileList_allSame(std::list<FileInfo* >  &modifyList, const std::list<FileInfo* >& sublist,std::set<std::string >& filelistChanged)
{
	std::list<FileInfo* > listmod;
	modifyList.swap(listmod);
	std::list<FileInfo* >::iterator it = listmod.begin();
	for(;it!=listmod.end();++it)
	{
		if(filelistChanged.find((*it)->name) != filelistChanged.end())
		{
			modifyList.push_back(*it);
			continue;
		}
		bool foundIt = false;
		std::list<FileInfo* >::const_iterator its = sublist.begin();
		for(;its!=sublist.end();++its)
		{
			if((*its)->name == (*it)->name &&
				(*its)->crc == (*it)->crc &&
				(*its)->size == (*it)->size )
			{
				foundIt = true;
				break;
			}
		}
		if(!foundIt)
		{
			modifyList.push_back(*it);
		}
	}
}


void subFileList_sameName(std::list<FileInfo* >  &modifyList_ori, const std::list<FileInfo* >& sublist)
{
	std::list<FileInfo* > listmod;
	modifyList_ori.swap(listmod);
	std::list<FileInfo* >::iterator it = listmod.begin();
	for(;it!=listmod.end();++it)
	{
		bool foundIt = false;
		std::list<FileInfo* >::const_iterator its = sublist.begin();
		for(;its!=sublist.end();++its)
		{
			if((*its)->name == (*it)->name)
			{
				foundIt = true;
				break;
			}
		}
		if(!foundIt)
		{
			modifyList_ori.push_back(*it);
		}
	}
}

void _parseUpdateFile( const std::string& severfile ,std::list<FileInfo* >  &modifyList)
{
	Json::Value root;
	Json::Reader jreader;
	Json::Value data;
	unsigned long filesize;
	char* pBuffer = (char*)_getFileData(severfile.c_str(),"rt",&filesize);

	if(!pBuffer)
	{
		printf("FAILED to get Update file!!");
		return;
	}

	jreader.parse(pBuffer,data,false);
	if(	data["version"].empty() || 
		data["version"].asInt()!=1 ||
		data["severVersion"].empty() ||
		data["files"].empty() ||
		!data["files"].isArray())
	{
		printf("FAILED to get Update file!!");
		return;
	}
	{


		Json::Value files = data["files"];
		for(int i=0;i<files.size();++i)
		{
			if(	!files[i]["c"].empty() &&
				!files[i]["f"].empty() &&
				!files[i]["s"].empty())
			{
				FileInfo* fileatt = new FileInfo;
				fileatt->name = files[i]["f"].asString();
				fileatt->crc = files[i]["c"].asInt();
				fileatt->size = files[i]["s"].asInt();

				modifyList.push_back(fileatt);
			}
		}
	}
}
void createVersonFile(
	const std::string& versonfile, 
	const std::string& rootdir, 
	const std::string& fileExt = "", 
	const std::string& comparePath = "", 
	const std::string& _version = "", 
	const std::string& lastVersionFile = "")
{
	std::list<FileInfo* >  orilist;
	if(lastVersionFile!="")
		_parseUpdateFile(lastVersionFile,orilist);

	std::list<FileInfo* >  filelist;
	getFiles(rootdir,"",filelist);

	std::list<FileInfo* >  filelistCmp;
	if(comparePath!="")
	{
		getFiles(comparePath,"",filelistCmp);
		std::set<std::string > filelistChanged;
		subFileList_allSame(filelist,filelistCmp,filelistChanged);
	}

	subFileList_sameName(orilist,filelist);

	std::list<FileInfo* >::iterator itcpy = filelist.begin();
	for(;itcpy!=filelist.end();++itcpy)
	{
		orilist.push_back(*itcpy);
	}

	std::string version = _version;
	if(version == "")
	{
		char versonstr[512];
		printf("Please input the target verson:");
		scanf("%s",versonstr);
		version = versonstr;
	}

	Json::Value fileroot;
	fileroot["version"] = 1;
	fileroot["severVersion"] = version.c_str();
	Json::Value files;

	int iTotalByteSize = 0;

	std::list<FileInfo*>::iterator it = filelist.begin();
	for(;it!=filelist.end();++it)
	{
		std::string ext = fileExt;
		if(!fileExt.empty())
		{
			if(fileExt.find_first_of('.') != 0)
				ext = std::string(".")+fileExt;
			int extpos = (*it)->name.find_last_of('.');
			if((*it)->name=="version.cfg")
			{
				continue;
			}
			if((*it)->name=="/version.cfg")
			{
				continue;
			}

			if(extpos!=-1)
			{
				std::string oriExt = (*it)->name.substr(extpos,(*it)->name.length());
				transform(oriExt.begin(), oriExt.end(), oriExt.begin(), (int (*)(int))tolower);
				transform(ext.begin(), ext.end(), ext.begin(), (int (*)(int))tolower);
				if(ext == oriExt)
					continue;
				if(oriExt == ".dll")
					continue;
				if(oriExt == ".exe")
					continue;
				if(oriExt == ".bat")
					continue;
				if(oriExt == ".log")
					continue;
				if(oriExt == ".pdb")
					continue;
				if(oriExt == ".cfg")
				{
					//version_ios.cfg
					//version_android.cfg
					//version_360.cfg
					std::string strTmp = (*it)->name;
					transform(strTmp.begin(), strTmp.end(), strTmp.begin(), (int (*)(int))tolower);
					if (strTmp.find("version_android_") == 0 || strTmp.find("/version_android_") == 0 || strTmp.find("version_ios_except") == 0 || strTmp.find("/version_ios_except") == 0 
						|| strTmp.find("version_win32") == 0 || strTmp.find("/version_win32") == 0)//modify by cooper.x
					{
						continue;
					}
				}
				if(oriExt == ".lua")
					continue;
			}
		}
		Json::Value unitFile;
		unitFile["f"] = (*it)->name;
		unitFile["c"] = (*it)->crc;
		unitFile["s"] = (*it)->size;
		files.append(unitFile);

		iTotalByteSize += (*it)->size;
	}
	fileroot["files"] = files;
	fileroot["totalByteSize"] = iTotalByteSize;
	
	Json::StyledWriter writer;
	std::string outstr = writer.write(fileroot);
	FILE* fp;
	fp = fopen(versonfile.c_str(),"wb");
	fwrite(outstr.c_str(),1, outstr.size(),fp);
	fclose(fp); 
}

//////////////////////////////////////////////////////////////////////////
bool changeElToLuaAndSave(const std::string& filePath, const std::string& destPath)
{
	unsigned long filesize = 0;
	unsigned char* filebuf = _getFileData(filePath.c_str(), "rb", &filesize);

	if(filebuf)
	{
		unsigned long outBufferSize = 0;
		unsigned char* outBuffer = 0;
		if(decBuffer(filesize,filebuf,outBufferSize,outBuffer))
		{
			FILE* fp = fopen(destPath.c_str(), "wb"); //
			size_t return_size = fwrite(outBuffer, 1, outBufferSize, fp);  
			fclose(fp);

			delete[] outBuffer;
			delete[] filebuf;

			return true;
		}
		delete[] outBuffer;
		delete[] filebuf;
	}

	return false;
}

bool changeLuaToElAndSave(const std::string& filePath, const std::string& destPathDir, FileInfo* pInfo, std::string& destPath,std::string& newfilepath)
{

	unsigned long filesize = 0;
	unsigned char* filebuf = _getFileData(filePath.c_str(), "rb", &filesize);

	if(filebuf)
	{
		unsigned long outBufferSize = 0;
		unsigned char* outBuffer = 0;
		if(encBuffer(filesize,filebuf,outBufferSize,outBuffer))
		{
			std::string::size_type pos1 = filePath.find_last_of("/");
			std::string::size_type pos2 = filePath.find_last_of(".");

			newfilepath = destPathDir + 
				filePath.substr(pos1, pos2-pos1) + ".el";

			FILE* fp = fopen(rc4EncFileName(newfilepath.c_str()).c_str(), "wb"); //
			size_t return_size = fwrite(outBuffer, 1, outBufferSize, fp);  
			fclose(fp);
			

			{
				unsigned short crcvalue = GameMaths::GetCRC16(outBuffer,outBufferSize);
				
				char szTemp[512] = {0};
				strcpy(szTemp, pInfo->name.c_str());
				int iLen = pInfo->name.length();
				szTemp[iLen-1] = 0;
				szTemp[iLen-2] = 'l';
				szTemp[iLen-3] = 'e';
				
				pInfo->name = szTemp;
				pInfo->crc = crcvalue;
				pInfo->size = outBufferSize;
			}

			delete[] outBuffer;
			delete[] filebuf;

			destPath = newfilepath;
			return true;
		}
		delete[] outBuffer;
		delete[] filebuf;
	}
	

	return false;
}

bool decryptTxtAndSave(const std::string& filePath, const std::string& destPath)
{
	unsigned long size = 0;
	unsigned char* dataIn = _getFileData(filePath.c_str(), "rb", &size);

	if (dataIn)
	{
		{
			unsigned long outBufferSize = 0;
			unsigned char* outBuffer = 0;
			if(decBuffer(size-2,dataIn+2,outBufferSize,outBuffer))//
			{
				FILE* fp = fopen(destPath.c_str(), "wb"); //
				size_t return_size = fwrite(outBuffer, 1, outBufferSize, fp);  
				fclose(fp);

				delete[] outBuffer;
				delete[] dataIn;

				return true;
			}
			delete[] outBuffer;
			delete[] dataIn;
		}
	}

	return false;
}

bool encryptTxtAndSave(const std::string& filePath, const std::string& destPathDir, FileInfo* pInfo, std::string& destPath)
{
	
	unsigned long size = 0;
	unsigned char* dataIn = _getFileData(filePath.c_str(), "rb", &size);
	
	if (dataIn)
	{
		std::string::size_type pos1 = filePath.find_last_of("/");
		std::string::size_type pos2 = filePath.find_last_of(".");

		std::string newfilepath = destPathDir + 
			filePath.substr(pos1);
		
		{
			unsigned long outBufferSize = 0;
			unsigned char* outBuffer = 0;
			if(encBuffer(size,dataIn,outBufferSize,outBuffer))//先压缩再加密
			{
				FILE* fp = fopen(rc4EncFileName(newfilepath.c_str()).c_str(), "wb"); //

				if(!fp)
				{
					return false;
				}
				unsigned char head[2];
				head[0] = 0xef;
				head[1] = 0xfe;

				fwrite(head, 1, 2, fp);

				size_t return_size = fwrite(outBuffer, 1, outBufferSize, fp);  
				fclose(fp);

				{
					{
						unsigned char* szTemp = new unsigned char[outBufferSize+5];
						szTemp[0] = 0xef;
						szTemp[1] = 0xfe;
						szTemp[outBufferSize+2] = 0;
						szTemp[outBufferSize+3] = 0;
						szTemp[outBufferSize+4] = 0;
						memcpy(szTemp+2, outBuffer, outBufferSize);

						unsigned short crcvalue = GameMaths::GetCRC16(szTemp,outBufferSize+2);

						pInfo->crc = crcvalue;
						pInfo->size = outBufferSize+2;

						delete[] szTemp;
					}
				}

				delete[] outBuffer;
				delete[] dataIn;

				destPath = newfilepath;
				return true;
			}
			delete[] outBuffer;
			delete[] dataIn;
		}
	}

	return false;
}

/************************************************************************/
/* 文件名进行加密                                                       */
/************************************************************************/
std::string encFileNameCtrl(std::string oriName, bool isEncFileName)
{
	if (isEncFileName)
	{
		return rc4EncFileName(oriName.c_str());
	}
	return oriName;
}

/************************************************************************/
/* 加密图片文件                                                         */
/************************************************************************/
bool encryptImageAndSave(std::string sourceFilePath, const std::string& destPathDir, std::string& destPath, FileInfo* pInfo, std::string versionStr,bool isEncFileName)
{
	unsigned char* dataOut=NULL;
	unsigned long sourceBufferSize = 0;
	const int pngEncodeSize = 128;
	const int dataBufferSize = 1024*1024;
	unsigned char* codeBuffer = _getFileData(sourceFilePath.c_str(),"rb",&sourceBufferSize);
	unsigned long writeBufferSize = 0;
	std::string::size_type pos = sourceFilePath.find_last_of("/");
	std::string fileName = sourceFilePath.substr(pos + 1, sourceFilePath.length());
	std::string encFileName = core_base64Encode((const unsigned char*)(fileName.c_str()), strlen(fileName.c_str()));
	MD5 md5(encFileName);
	std::string rc4 = encFileNameRc4(md5.md5().c_str());
	unsigned char key[10];
	for (int i = 0; i < 10; ++i)
	{
		key[i] = rc4[i * 2];
	}
	AVRC4 rc4_key;
	memset(&rc4_key,0,sizeof(AVRC4));	
	av_rc4_init(&rc4_key, key, 10 * 8);
	int markSize = 3;
	dataOut = new unsigned char[sourceBufferSize+markSize];
	dataOut[0] = 0xef;
	dataOut[1] = 0xfe;
	dataOut[2] = 0x80;
	int bufferSize = 0;
	int encodeSize = 0x80;
	(sourceBufferSize > encodeSize) ? bufferSize = encodeSize : bufferSize = sourceBufferSize;
	av_rc4_crypt(&rc4_key,dataOut + markSize,codeBuffer,bufferSize);
	if (bufferSize < sourceBufferSize)
	{
		memcpy(dataOut + encodeSize + markSize,codeBuffer+encodeSize,sourceBufferSize - encodeSize);
	}					
	writeBufferSize = sourceBufferSize+markSize;
	std::cout << "Encrypt file : " << sourceFilePath << " done." << std::endl;

	std::string::size_type pos1 = sourceFilePath.find_last_of("/");
	std::string::size_type pos2 = sourceFilePath.find_last_of(".");

	std::string newfilepath = destPathDir + 
		sourceFilePath.substr(pos1);
	destPath = encFileNameCtrl(newfilepath.c_str(), isEncFileName);
	FILE *g_fpLog;
	std::string tmpPath = destPath;
	if (versionStr != "")
	{
		std::string::size_type pos = destPath.find_first_of("/");
		std::string tmp1 = destPath.substr(0, pos);
		std::string tmp2 = destPath.substr(pos, destPath.length() - pos);
		tmpPath = tmp1 + "/" + versionStr + tmp2;
	}
	g_fpLog = fopen(tmpPath.c_str(), "wb");
	assert(g_fpLog);
	fwrite(dataOut,1,writeBufferSize,g_fpLog);
	unsigned short crcvalue = GameMaths::GetCRC16(dataOut,writeBufferSize);
	pInfo->crc = crcvalue;
	pInfo->size = writeBufferSize;
	fclose(g_fpLog);
	delete[] dataOut;
	delete[] codeBuffer;
	
	return true;
}

/************************************************************************/
/* 解密图片文件                                                                     */
/************************************************************************/
bool decodeRC4TextureBuffer(const std::string& filePath, const std::string& destPath)
{
	unsigned long inSize = 0;
	unsigned char* inBuffer = _getFileData(filePath.c_str(), "rb", &inSize);

	if (inBuffer)
	{
		unsigned char* outBuffer = NULL;

		inBuffer=rc4TextureBuffer(inSize,inBuffer,&inSize,filePath.c_str());
		FILE* fp = fopen(destPath.c_str(), "wb"); //
		if(fp)
		{
			size_t return_size = fwrite(inBuffer, 1, inSize, fp);  
		}
		fclose(fp);
		return true;
	}

	return false;
}

/************************************************************************/
/* 加密plist和ccbi文件                                                                     */
/************************************************************************/
bool encryptRC4DocumentAndSave(std::string sourceFilePath, const std::string& destPathDir, std::string& destPath, FileInfo* pInfo, std::string versionStr, bool isEncFileName = false)
{
	unsigned char* dataOut = NULL;
	unsigned long sourceBufferSize = 0;
	const int pngEncodeSize = 128;
	const int dataBufferSize = 1024 * 1024;
	unsigned char* codeBuffer = _getFileData(sourceFilePath.c_str(), "rb", &sourceBufferSize);
	unsigned long writeBufferSize = 0;
	std::string::size_type pos = sourceFilePath.find_last_of("/");
	std::string fileName = sourceFilePath.substr(pos + 1, sourceFilePath.length());
	std::string encFileName = core_base64Encode((const unsigned char*)(fileName.c_str()), strlen(fileName.c_str()));
	MD5 md5(encFileName);
	std::string rc4 = encFileNameRc4(md5.md5().c_str());
	unsigned char key[10];
	for (int i = 0; i < 10; ++i)
	{
		key[i] = rc4[i * 2];
	}
	AVRC4 rc4_key;
	memset(&rc4_key, 0, sizeof(AVRC4));
	av_rc4_init(&rc4_key, key, 10 * 8);
	int markSize = 3;
	unsigned long compressSize = (unsigned long)(sourceBufferSize * 1.5);
	unsigned char* compressData = new unsigned char[compressSize];
	int ret = compress(compressData, &compressSize, codeBuffer, sourceBufferSize);
	if (ret == Z_OK)
	{
		dataOut = new unsigned char[compressSize + 3];
		dataOut[0] = 0xef;
		dataOut[1] = 0xfe;
		dataOut[2] = 0xff;
		av_rc4_crypt(&rc4_key, dataOut + 3, compressData, compressSize);
		writeBufferSize = compressSize + 3;

		delete[] compressData;
	}
	else
	{
		delete[] dataOut;
		delete[] codeBuffer;
		delete[] compressData;
		std::cout << "Encrypt file Failed : " << sourceFilePath << " done." << std::endl;
		return false;
	}


	std::string::size_type pos1 = sourceFilePath.find_last_of("/");
	std::string::size_type pos2 = sourceFilePath.find_last_of(".");

	std::string newfilepath = destPathDir +
		sourceFilePath.substr(pos1);
	destPath = encFileNameCtrl(newfilepath.c_str(), isEncFileName);;
	FILE *g_fpLog;
	std::string tmpPath = destPath;
	if (versionStr != "")
	{
		std::string::size_type pos = destPath.find_first_of("/");
		std::string tmp1 = destPath.substr(0, pos);
		std::string tmp2 = destPath.substr(pos, destPath.length() - pos);
		tmpPath = tmp1 + "/" + versionStr + tmp2;
	}
	g_fpLog = fopen(tmpPath.c_str(), "wb");
	assert(g_fpLog);
	fwrite(dataOut,1,writeBufferSize,g_fpLog);
	unsigned short crcvalue = GameMaths::GetCRC16(dataOut,writeBufferSize);
	pInfo->crc = crcvalue;
	pInfo->size = writeBufferSize;
	fclose(g_fpLog);
	delete[] dataOut;
	delete[] codeBuffer;
	std::cout << "Encrypt file : " << sourceFilePath << " done." << std::endl;
	return true;
}

/************************************************************************/
/* 解密plist和ccbi文件                                                  */
/************************************************************************/
bool decodeRC4DocumentBuffer(const std::string& filePath, const std::string& destPath)
{
	unsigned long inSize = 0;
	unsigned char* inBuffer = _getFileData(filePath.c_str(), "rb", &inSize);

	if (inBuffer)
	{
		unsigned char* outBuffer = NULL;
		inBuffer=rc4DocumentBuffer(inSize,inBuffer,&inSize,filePath.c_str());
		FILE* fp = fopen(destPath.c_str(), "wb"); //
		if(fp)
		{
			if(inBuffer)
			{
				size_t return_size = fwrite(inBuffer, 1, inSize, fp);  
			}
		}
		fclose(fp);
		return true;
	}

	return false;
}

void getpreviousChangedVersionFiles(const std::string& findfile, std::set<std::string > & filelist )
{
	unsigned long size = 0;
	unsigned char* dataIn = _getFileData(findfile.c_str(), "rb", &size);
	
	if(!dataIn)
	{
		cout<<"Failed open file :" + findfile + "\n";
		return;
	}
	else
	{
		Json::Reader jreader;
		Json::Value data;
		jreader.parse((char*)dataIn,data,false);
		Json::Value& Files = data["files"];
		Json::Value::iterator itr = Files.begin();
		Json::Value::iterator itrend = Files.end();
		for (;itr!=itrend; itr++)
		{
			Json::Value ele = *itr;
			std::string fileName=ele["f"].asString();
			if(fileName.find(".el")!=std::string::npos)
			{
				std::string::size_type pos=fileName.find_last_of(".");
				filelist.insert(fileName.substr(0,pos)+".lua");
			}
			else
			{
				filelist.insert(fileName);
			}
		}
	}
}

std::string rightPath(const std::string& s)
{
	std::string str(s);
	while(true)
	{
		string::size_type pos(0);
		if( (pos=str.find("/")) != string::npos )
			str.replace(pos,1,"\\");
		else
			return str;
	}
	return str;
}

void run_cmd(const char* cmdstr)
{
	::system((std::string("echo  ") + std::string(cmdstr)).c_str());
	::system(cmdstr);
}

void copy_cmd(std::string newDir,std::string filename,std::string destPath,std::string updateVersionPath,std::string updateFileVersionDir)
{
	std::string strCmd = "COPY /Y \"" + 
		rightPath(newDir + filename) + "\" \"" + rightPath(destPath) + "\"";
	run_cmd(strCmd.c_str());

	if(updateFileVersionDir!="")
	{
		strCmd = "COPY /Y \"" + 
			rightPath(newDir + filename) + "\" \"" + rightPath(updateVersionPath) + "\"";
		run_cmd(strCmd.c_str());
	}
}

void echoFileList(std::string currUpdateFileVersionDir, std::string difListFile, Json::Value fileroot, std::string outDirStr, std::string updateFileVersionDir, Json::Value files=NULL)
{
	Json::StyledWriter writer;
	std::string outstr = writer.write(fileroot);


	std::string outUpdateFileName = outDirStr + "/" + difListFile;
	FILE* fp;
	fp = fopen(outUpdateFileName.c_str(), "wb");
	if (fp)
	{
		fwrite(outstr.c_str(), 1, outstr.size(), fp);
		fclose(fp);

		if (updateFileVersionDir != "")
		{
			if (files != NULL)
			{
				fp = fopen((currUpdateFileVersionDir + "/" + difListFile).c_str(), "wb");
				if (fp)
				{
					fileroot["files"] = files;
					outstr = writer.write(fileroot);
					fwrite(outstr.c_str(), 1, outstr.size(), fp);
					fclose(fp);
				}
			}
			else
			{
				//输出本次加密版本的列表文件
				std::string strCmd = "COPY /Y \"" +
					rightPath(outUpdateFileName) + "\" \"" + rightPath(currUpdateFileVersionDir + "/" + difListFile) + "\"";
				run_cmd(strCmd.c_str());
			}
			
		}
	}
	else
	{
		std::string strCmd = "[Warning.....] Echo failed: \"" + difListFile + "\"";
		run_cmd(strCmd.c_str());
	}
}

/************************************************************************/
/* 文件路径进行加密                                                     */
/************************************************************************/
std::string getAbsEncFilePath(std::string filePath,bool isEncPath)
{
	if (isEncPath)
	{
		std::string::size_type posOutDir = filePath.find_first_of("/");
		std::string encFilePathStr = "";
		if (posOutDir != std::string::npos)
		{
			std::string rootDir = filePath.substr(0, posOutDir);
			std::string splitFilePath = filePath.substr(posOutDir + 1, filePath.length());

			std::string::size_type posSplit = splitFilePath.find_first_of("/");
			for (; posSplit != std::string::npos;)
			{
				std::string tempFileDir = splitFilePath.substr(0, posSplit);
				if (tempFileDir.find(".") != std::string::npos)
				{
					encFilePathStr += "/" + tempFileDir;
				}
				else
				{
					encFilePathStr += "/" + encFilePath(tempFileDir.c_str());
				}
				
				splitFilePath = splitFilePath.substr(posSplit + 1, splitFilePath.length());
				posSplit = splitFilePath.find_first_of("/");
			}

			posSplit = splitFilePath.find_first_of(".");
			if (posSplit != 0 && posSplit != std::string::npos)
			{
				encFilePathStr = encShortFilePath(encFilePathStr.c_str());
				encFilePathStr += "/" + splitFilePath;
			}
			else
			{
				encFilePathStr += "/" + encFilePath(splitFilePath.c_str());
				encFilePathStr =encShortFilePath(encFilePathStr.c_str());
			}
			if (filePath.find("data") != std::string::npos)
			{
				encFilePathStr = rootDir + "/" + "9df2ac2i4s8fs/" + encFilePathStr;
			}
			else
			{
				encFilePathStr = rootDir + "/" + encFilePathStr;
			}
			return encFilePathStr;
		}
		else
		{
			return filePath;
		}
		
	}
	return filePath;
}

void createDiffVersionFile(
		const std::string& currentFileDir,	//参与比较的新资源目录
		const std::string& originalFileDir,	//参与比较的旧资源目录
		const std::string& difDir,	//比较结果，差异文件输出目录，lua文件转el，txt、cfg加密
		/*const */std::string& difListFile,	//在difDir输出这个文件，json格式差异列表
		const std::string& previousVersion="",	//前一个版本的update文件
		const std::string& verionStr="",//本次版本号
		const std::string& updateFileVersionDir="",
		const std::string& excludeFileExt = "",
		const std::string& includeFileExt = "",
		bool isNeedDecryptOut=false
	)
{
	std::vector<std::string> echoFailedList;
	//
	static std::map<std::string,std::string> DirMap;
	std::list<FileInfo* >  filelist;
	getFiles(currentFileDir,"",filelist);
	
	//
	std::list<FileInfo* >  filelistCmp;
	getFiles(originalFileDir,"",filelistCmp);

	//拿到上一个版本的更新列表，供检测曾经有变更的文件
	std::string previousVersionUpdateFile = "";
	std::string noEncryptFile = "CompareEncryptFile";
	std::string::size_type filePos = difListFile.find_last_of(".");

	if (filePos != 0 && filePos != std::string::npos)
	{
		previousVersionUpdateFile=difListFile.substr(0, filePos) + noEncryptFile + "." + difListFile.substr(filePos + 1, difListFile.length());
		previousVersionUpdateFile = updateFileVersionDir + "/" + previousVersion + "/" + previousVersionUpdateFile;
	}
	else
	{
		previousVersionUpdateFile=updateFileVersionDir + "/" + previousVersion + "/" + difListFile;
	}
		
	std::set<std::string >  filelistChanged;
	if(!previousVersionUpdateFile.empty())
		getpreviousChangedVersionFiles(previousVersionUpdateFile,filelistChanged);
	
	//
	subFileList_allSame(filelist,filelistCmp,filelistChanged);
	std::string currUpdateFileVersionDir="";
	if(verionStr!="")
	{
		//创建产出本次版本的文件夹
		currUpdateFileVersionDir=updateFileVersionDir+"/"+verionStr;
		if(updateFileVersionDir!="")
		{
			std::string strCmdcurrUpdateFile = "mkdir \"" + currUpdateFileVersionDir + "\"";
			run_cmd(strCmdcurrUpdateFile.c_str());
			DirMap.insert(std::make_pair(currUpdateFileVersionDir,currUpdateFileVersionDir));
		}
	}

	std::string outDirStr=difDir;
	if(updateFileVersionDir!="")
	{
		outDirStr=difDir+"/"+verionStr;
	}
	//
	std::string strCmd = "mkdir \"" + outDirStr + "\"";
	run_cmd(strCmd.c_str());
	DirMap.insert(std::make_pair(outDirStr,outDirStr));

	std::string decryptDir = outDirStr + "Decrypt";
	//modify by dylan at 20140515,这个目录不需要，平时就没用过
	
	if(isNeedDecryptOut)
	{
		std::string strCmd0 = "mkdir \"" + decryptDir + "\"";
		run_cmd(strCmd0.c_str());
		DirMap.insert(std::make_pair(decryptDir,decryptDir));
	}
	//
	//filelist now is new aded and modified files
	//
	Json::Value fileroot;
	fileroot["version"] = 1;
	fileroot["severVersion"] = verionStr;
	Json::Value encfiles;
	Json::Value files;
	int iTotalByteSize = 0;
	std::string strIncludeFileExt = includeFileExt;
	std::string strExcludeFileExt = excludeFileExt;

	//需要加密的文件
	std::vector<std::string> fileFilterVec;//暂未使用
	//不加密的文件夹
	std::vector<std::string> pathFilterVec;

	bool isEncFileName = false;
	bool isEncFilePath = false;
	bool isShowSuffixFlag = true;
	//load encrypt config 
	Json::Value root;
	Json::Reader jreader;
	Json::Value data;
	unsigned long filesize;
	char* pBuffer = (char*)_getFileData("Utility.cfg","rt",&filesize);

	if(!pBuffer)
	{
		std::string strCmd = "echo failed: FAILED to get Utility.cfg ConfigFile!!";
		run_cmd(strCmd.c_str());
		return ;
	}

	jreader.parse(pBuffer,data,false);

	if (!data["Encode"].empty())
	{
		Json::Value encodeData = data["Encode"];
		if (!encodeData["files"].empty())
		{
			Json::Value files = encodeData["files"];
			for(int i=0;i<files.size();++i)
			{
				if(	!files[i]["suffix"].empty() )
				{
					fileFilterVec.push_back(files[i]["suffix"].asString());
				}
			}
		}
		if (!encodeData["floder"].empty())
		{
			Json::Value files = encodeData["floder"];
			for(int i=0;i<files.size();++i)
			{
				if(	!files[i]["suffix"].empty() )
				{
					pathFilterVec.push_back(files[i]["suffix"].asString());
				}
			}
		}
	}

	if (!data["EncFlags"].empty())
	{
		Json::Value flags = data["EncFlags"];
		if (!flags["encFileName"].empty())
		{
			isEncFileName = flags["encFileName"].asBool();
		}
		if (!flags["encFilePath"].empty())
		{
			isEncFilePath = flags["encFilePath"].asBool();
		}
		if (!flags["suffixFlag"].empty())
		{
			isShowSuffixFlag = flags["suffixFlag"].asBool();
		}
	}

	setEncFlag(isEncFileName, isEncFilePath, isShowSuffixFlag);

	std::list<FileInfo*>::iterator it = filelist.begin();
	for(;it!=filelist.end();++it)
	{
		bool isUpdateDown=true;
		if((*it)->name=="version.cfg")
		{
			continue;
		}
		if((*it)->name=="/version.cfg")
		{
			continue;
		}
		if((*it)->name=="/.svn")
		{
			continue;
		}
		int extpos = (*it)->name.find_last_of('.');

		bool isNotEncrptFolder = false;


		if(extpos!=-1)
		{
			std::string oriExt = (*it)->name.substr(extpos,(*it)->name.length());
			transform(oriExt.begin(), oriExt.end(), oriExt.begin(), (int (*)(int))tolower);

			transform(strIncludeFileExt.begin(), strIncludeFileExt.end(), strIncludeFileExt.begin(), (int (*)(int))tolower);
			transform(strExcludeFileExt.begin(), strExcludeFileExt.end(), strExcludeFileExt.begin(), (int (*)(int))tolower);
				
			if(strExcludeFileExt.find(oriExt) != std::string::npos)
				continue;

			if (!strIncludeFileExt.empty() && strIncludeFileExt.find(oriExt) == std::string::npos)
				continue;

			if(oriExt == ".dll")
				continue;
			if(oriExt == ".exe")
				continue;
			if(oriExt == ".bat")
				continue;
			if(oriExt == ".log")
				continue;
			if(oriExt == ".pdb")
				continue;
			if(oriExt == ".php")
				continue;
			if(oriExt == ".luaprj")
				continue;
			if (oriExt == ".cmd")
				continue;
			if(oriExt == ".cfg")
			{
				std::string strTmp = (*it)->name;
				transform(strTmp.begin(), strTmp.end(), strTmp.begin(), (int (*)(int))tolower);
				if (strTmp.find("version_android_") == 0 || strTmp.find("/version_android_") == 0 || strTmp.find("version_ios_except") == 0 || strTmp.find("/version_ios_except") == 0
					|| strTmp.find("version_win32") == 0 || strTmp.find("/version_win32") == 0)
				{
					//continue;
					isUpdateDown = false;
					std::string strCmd = "COPY /Y \"" + 
						rightPath(currentFileDir + (*it)->name) + "\" \"" + rightPath(outDirStr + (*it)->name) + "\"";
					run_cmd(strCmd.c_str());
					continue;
				}
			}
			if (oriExt == ".ttf")
			{
				isUpdateDown = false;
				std::string strCmd = "COPY /Y \"" +
					rightPath(currentFileDir + (*it)->name) + "\" \"" + rightPath(outDirStr + (*it)->name) + "\"";
				run_cmd(strCmd.c_str());
				continue;
			}

			std::vector<std::string>::iterator pathFliterIter = pathFilterVec.begin();
			for (; pathFliterIter != pathFilterVec.end(); ++pathFliterIter )
			{
				if(((*it)->name).find((*pathFliterIter+"/"))!=std::string::npos)
				{
					isNotEncrptFolder=true;
					break;
				}
			}

			std::string destPath = outDirStr + (*it)->name;
			std::string updateVersionPath = currUpdateFileVersionDir + (*it)->name;
			std::string destDir;
			std::string destUpdateVersionDir;
			std::string::size_type pos = destPath.find_last_of("/");

			if (pos != 0 && pos != std::string::npos)
			{
				destDir = destPath.substr(0, pos);
				if (verionStr != "")
				{
					std::string::size_type verPos = destDir.find(verionStr.c_str());
					std::string tmp1 = destDir.substr(0, verPos);
					std::string tmp2 = destDir.substr(verPos + verionStr.length() + 1, destDir.length() - verPos - verionStr.length() - 1);
					destDir = tmp1 + tmp2;
				}
				if (DirMap.find(destDir) == DirMap.end())
				{
					std::string encFilePathStr = isNotEncrptFolder ? destDir:getAbsEncFilePath(destDir, isEncFilePath);
					if (verionStr != "")
					{
						std::string::size_type pos = encFilePathStr.find_first_of("/");
						std::string tmp1 = encFilePathStr.substr(0, pos);
						std::string tmp2 = encFilePathStr.substr(pos, encFilePathStr.length() - pos);
						std::string out = tmp1 + "/" + verionStr + tmp2;
						strCmd = "mkdir \"" + out + "\"";
					}
					else
					{
						strCmd = "mkdir \"" + encFilePathStr + "\"";
					}
					run_cmd(strCmd.c_str());
					DirMap.insert(std::make_pair(destDir, encFilePathStr));
					std::string::size_type updateVersionPos = updateVersionPath.find_last_of("/");
					destUpdateVersionDir = updateVersionPath.substr(0, updateVersionPos);

					if (updateFileVersionDir != "")
					{
						strCmd = "mkdir \"" + destUpdateVersionDir + "\"";
						run_cmd(strCmd.c_str());
						DirMap.insert(std::make_pair(destUpdateVersionDir, destUpdateVersionDir));
					}
				}
			}

			if(!isNotEncrptFolder)
			{
				isNotEncrptFolder=true;
				std::vector<std::string>::iterator fileFilterIter=fileFilterVec.begin();
				for (; fileFilterIter != fileFilterVec.end(); ++fileFilterIter)
				{
					if(oriExt==(*fileFilterIter))
					{
						isNotEncrptFolder=false;
						break;
					}
				}
			}

			if(isNotEncrptFolder)
			{
				copy_cmd(currentFileDir, (*it)->name, destPath, updateVersionPath.c_str(), currUpdateFileVersionDir);
			}
			else
			{
				if(isNeedDecryptOut)
				{
					if (oriExt == ".lua" || oriExt == ".txt" || oriExt == ".cfg" || oriExt == ".json" || oriExt == ".plist" || oriExt == ".png" || oriExt == ".ccbi" || oriExt == ".jpg" || oriExt == ".ccz" || oriExt == ".ani" || oriExt == ".abc" || oriExt == ".proto" || oriExt == ".atlas" || oriExt == ".vsh" || oriExt == ".fsh" || oriExt == ".sh")
					{
						std::string destPath11 = decryptDir + (*it)->name;
						std::string destDir11;
						std::string::size_type pos = destPath11.find_last_of("/");
						if (pos != 0 && pos != std::string::npos)
						{
							destDir11 = destPath11.substr(0, pos);
							if (DirMap.find(destDir11) == DirMap.end())
							{								
								std::string encFilePathStr = getAbsEncFilePath(destDir11.c_str(), isEncFilePath);
								std::string strCmd = "mkdir \"" + encFilePathStr + "\"";
								run_cmd(strCmd.c_str());
								DirMap.insert(std::make_pair(destDir11, encFilePathStr));
							}
						}
					}
				}
				//--begin
				if (oriExt == ".png" || oriExt == ".jpg" || oriExt == ".ccz" || oriExt == ".ani" || oriExt == ".abc")
				{//处理图片资源加密
					std::string outDestPathStr;
					std::string encFilePathStr = getAbsEncFilePath(destDir.c_str(), isEncFilePath);
					bool bRet = encryptImageAndSave(currentFileDir + (*it)->name, encFilePathStr, outDestPathStr, (*it),verionStr,isEncFileName);
					if(bRet)
					{
						if(updateFileVersionDir!="")
						{
							if (verionStr != "")
							{
								std::string::size_type pos = outDestPathStr.find_first_of("/");
								std::string tmp1 = outDestPathStr.substr(0, pos);
								std::string tmp2 = outDestPathStr.substr(pos, outDestPathStr.length() - pos);
								std::string out = tmp1 + "/" + verionStr + tmp2;
								strCmd = "COPY /Y \"" + rightPath(out) + "\" \"" + rightPath(updateVersionPath).c_str() + "\"";
							}
							else
							{
								strCmd = "COPY /Y \"" + rightPath(outDestPathStr) + "\" \"" + rightPath(updateVersionPath).c_str() + "\"";
							}
							run_cmd(strCmd.c_str());
						}
						if(isNeedDecryptOut) 
						{
							decodeRC4TextureBuffer(outDestPathStr.c_str(), decryptDir + (*it)->name);
						}
					}
					else
					{
						std::string strCmd = "echo failed: \"" + currentFileDir + (*it)->name + "\"";
						run_cmd(strCmd.c_str());
						echoFailedList.push_back(strCmd);
						//run_cmd("pause");
						copy_cmd(currentFileDir, (*it)->name, encFileNameCtrl(getAbsEncFilePath(destPath, isEncFilePath).c_str(), isEncFileName), updateVersionPath.c_str(), currUpdateFileVersionDir);
					}
				}
				else if (oriExt == ".ccbi" || oriExt == ".plist" || oriExt == ".txt" || oriExt == ".cfg" || oriExt == ".json" || oriExt == ".lua" || oriExt == ".xml" || oriExt == ".proto" || oriExt == ".atlas" || oriExt == ".vsh" || oriExt == ".fsh" || oriExt == ".sh" || oriExt == ".lang")
				{//处理ccbi文件加密
					std::string destPath1;
					std::string tempName=(*it) ->name;
					std::string encFilePathStr = getAbsEncFilePath(destDir.c_str(), isEncFilePath);
					bool bRet = encryptRC4DocumentAndSave(currentFileDir + (*it)->name, encFilePathStr, destPath1, (*it), verionStr,isEncFileName);
					if(bRet)
					{
						if(updateFileVersionDir!="")
						{
							if (verionStr != "")
							{
								std::string::size_type pos = destPath1.find_first_of("/");
								std::string tmp1 = destPath1.substr(0, pos);
								std::string tmp2 = destPath1.substr(pos, destPath1.length() - pos);
								std::string out = tmp1 + "/" + verionStr + tmp2;
								strCmd = "COPY /Y \"" + rightPath(out) + "\" \"" + rightPath(updateVersionPath).c_str() + "\"";
							}
							else
							{
								strCmd = "COPY /Y \"" + rightPath(destPath1) + "\" \"" + rightPath(updateVersionPath).c_str() + "\"";
							}
							
							run_cmd(strCmd.c_str());
						}
						if(isNeedDecryptOut) 
						{
							decodeRC4DocumentBuffer(encFileNameCtrl(destPath1.c_str(), isEncFileName), decryptDir + tempName);
						}
					}
					else
					{
						std::string strCmd = "echo failed: \"" + currentFileDir + (*it)->name + "\"";
						run_cmd(strCmd.c_str());
						echoFailedList.push_back(strCmd);

						copy_cmd(currentFileDir, (*it)->name, encFileNameCtrl(getAbsEncFilePath(destPath, isEncFilePath).c_str(), isEncFileName), updateVersionPath.c_str(), currUpdateFileVersionDir);
					}
				}
				else
				{//only copy
					copy_cmd(currentFileDir, (*it)->name, encFileNameCtrl(getAbsEncFilePath(destPath, isEncFilePath).c_str(), isEncFileName), updateVersionPath.c_str(), currUpdateFileVersionDir);
				}
				//--end
			}

		}

		//version_xxx 类型的文件 不进行内更新
		if (!isUpdateDown)
		{
			continue;
		}

		Json::Value unitFile;
		std::string absEncFilePath = isNotEncrptFolder ? (*it)->name: getAbsEncFilePath((*it)->name, isEncFilePath);
		std::string::size_type pos = absEncFilePath.find_last_of("/");
		std::string fileName = absEncFilePath;
		if (pos == 0 && pos != std::string::npos)
		{
			fileName = absEncFilePath.substr(pos + 1, absEncFilePath.length());
		}
		unitFile["f"] = isNotEncrptFolder ? fileName:encFileNameCtrl(fileName.c_str(), isEncFileName);
		unitFile["c"] = (*it)->crc;
		unitFile["s"] = (*it)->size;
		encfiles.append(unitFile);

		unitFile["compare"] = unitFile["f"].asString();
		unitFile["f"] = (*it)->name.c_str();
		files.append(unitFile);

		iTotalByteSize += (*it)->size;
	}

	fileroot["files"] = encfiles;
	fileroot["totalByteSize"] = iTotalByteSize;

	//输出文件名加密后的文件列表
	echoFileList(currUpdateFileVersionDir, difListFile, fileroot, outDirStr, updateFileVersionDir, files);

	fileroot["files"] = files;

	if (filePos != 0 && filePos != std::string::npos)
	{
		difListFile = difListFile.substr(0, filePos) + noEncryptFile + "." + difListFile.substr(filePos + 1, difListFile.length());
	}
	//输出文件加密后的文件列表
	echoFileList(currUpdateFileVersionDir, difListFile, fileroot, outDirStr, updateFileVersionDir);


	for (int i = 0; i < echoFailedList.size(); ++i)
	{
		run_cmd(echoFailedList.at(i).c_str());
	}

	run_cmd("pause");
}

int main(int argc, char* argv[])
{
	

	const string USAGE =	"Usage:	Utility [-OPERATION]\n" \
							"	-E:	(Encrypt): Utility -E sourcefile destinationfile key\n" \
							"	-D:	(Decrypt): Utility -D sourcefile destinationfile key\n" \
							"	-C:	(CRC validate): Utility -C checkfile\n" \
							"	-N:	(Network test): Utility -N opcode" \
							"	-V:	(Verson file creation): Utility -V rootdir versonfile excludeFileExtension compareDir version"; \
							"	-P:	(Pressure test): Utility -P type(0:Login 1:PlayerSimulate 2:MassivePlayers"; 
	if(argc>=2 &&(strcmp(ARG_OPERATION, "-P") == 0 || strcmp(ARG_OPERATION, "-p") == 0))
	{
		/*
		if(strcmp(ARG_INFILE,"0")==0)
			pressureTest::Get()->testLogin();
		if(strcmp(ARG_INFILE,"1")==0)
			pressureTest::Get()->testPlay();
		if(strcmp(ARG_INFILE,"2")==0)
			pressureTest::Get()->testAmount();
		*/
	}
	else if(argc>=3 &&(strcmp(ARG_OPERATION, "-V") == 0 || strcmp(ARG_OPERATION, "-v") == 0))
	{
		if(argc == 5)
			createVersonFile(ARG_OUTFILE,ARG_INFILE);
		else if(argc == 6)
			createVersonFile(ARG_OUTFILE,ARG_INFILE,ARG_PARA);
		else if(argc == 7)
			createVersonFile(ARG_OUTFILE,ARG_INFILE,ARG_PARA,argv[5],argv[6]);
		else
			createVersonFile(ARG_OUTFILE,ARG_INFILE,ARG_PARA,argv[5],argv[6],argv[7]);
	}
	else if(argc>=3 &&(strcmp(ARG_OPERATION, "-VE") == 0 || strcmp(ARG_OPERATION, "-ve") == 0))
	{
		std::string destDiffFile = argv[5];
		std::string includeFileExt = "";
		std::string excludeFileExt = ".el";
		std::string version = "";
		std::string previousUpdateFile="";
		std::string updateFileVersionDir="";
		bool isNeedDecryptOut=false;
		if (argc >= 7)
			previousUpdateFile = argv[6];
		if (argc >= 8)
			version = argv[7];
		if(argc >=9)
			updateFileVersionDir=argv[8];
		if (argc >= 10)
			isNeedDecryptOut=true;
		if (argc >= 11)
			excludeFileExt = argv[10];
		if (argc >= 12)
			includeFileExt = argv[11];
		createDiffVersionFile(argv[2],argv[3],argv[4],destDiffFile,previousUpdateFile,version,updateFileVersionDir,excludeFileExt,includeFileExt,isNeedDecryptOut);
		return 0;
	}

	if(argc>=2 &&(strcmp(ARG_OPERATION, "-N") == 0 || strcmp(ARG_OPERATION, "-n") == 0))
	{
		//_gamePacketsCreatePackets();
		//if(ARG_INFILE)
		{
			//int opcode;
			//sscanf(ARG_INFILE,"%d",&opcode);
			//protoNet(0);
			return 0;
		}
	}

	if(argc>=3 &&(strcmp(ARG_OPERATION, "-C") == 0 || strcmp(ARG_OPERATION, "-c") == 0))
	{
		if(checkFile(argc,argv)!=0)
			return 2;
		unsigned long size = 0;
		unsigned char* dataIn = _getFileData(ARG_INFILE,"rb",&size);
		unsigned short crcvalue = GameMaths::GetCRC16(dataIn,size);
		printf("CRC:%d",crcvalue);
		return crcvalue;
	}
	

	if(argc>=5 &&(strcmp(ARG_OPERATION, "-E") == 0 || strcmp(ARG_OPERATION, "-e") == 0))
	{
		if(encrypt(argc,argv) !=0)
		{
			cout << USAGE << endl;
			return 1;
		}
	}

	if(argc>=5 && (strcmp(ARG_OPERATION, "-D") == 0 || strcmp(ARG_OPERATION, "-d") == 0))
	{
		if(decrypt(argc,argv) !=0)
		{
			cout << USAGE << endl;
			return 1;
		}
	}

	cout << USAGE << endl;
	return 0;
}

