// encryption_aes.cpp : Defines the entry point for the console application.
//

#include "stdafx.h"
#include <stdio.h>
#include <iostream>
#include <bitset>
#include <utility>
#include <string>
#include <fstream>
#include <iostream>

#include "AES.h"
#include "GameMaths.h"

using namespace std;
#define CC_BREAK_IF(cond) if(cond) break

unsigned char* getFileData(const char* pszFileName, const char* pszMode, unsigned long* pSize)
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

int main(int argc, char* argv[])
{
	const string USAGE =	"Usage:	Utility [-E | -D | -C] sourcefile destinationfile key\n" \
							"	-E:	Encrypt" \
							"	-D:	Decrypt" \
							"	-C:	CRC validate";


	ifstream is(ARG_INFILE, ios::in | ios::binary);
	if(!is)
	{
		cerr << "InputFileNotFoundException" << endl;
		return 2;
	}

	is.close();

	unsigned long size = 0;
	unsigned char* dataIn = getFileData(ARG_INFILE,"rb",&size);
	

	if(strcmp(ARG_OPERATION, "-C") == 0 || strcmp(ARG_OPERATION, "-c") == 0)
	{
		unsigned short crcvalue = GameMaths::GetCRC16(dataIn,size);
		printf("CRC:%d",crcvalue);
	}
	

	if(strcmp(ARG_OPERATION, "-E") == 0 || strcmp(ARG_OPERATION, "-e") == 0)
	{

		if(argc != 5)
		{
			cout << USAGE << endl;
			return 1;
		}

		if(!strlen(ARG_PARA)==16)
		{
			cerr << "Key must be 16 byte(128bit)" << endl;
			return 2;
		}

		AES aes;
		unsigned char* dataOut = new unsigned char[size];
		aes.Encrypt(dataIn,size,dataOut,(const unsigned char*)(ARG_PARA));

		FILE* fp;
		fp = fopen(ARG_OUTFILE,"wb");
		fwrite(dataOut,1, size,fp);
		fclose(fp); 
		delete[] dataOut; 
	}

	if(strcmp(ARG_OPERATION, "-D") == 0 || strcmp(ARG_OPERATION, "-d") == 0)
	{

		if(argc != 5)
		{
			cout << USAGE << endl;
			return 1;
		}

		if(!strlen(ARG_PARA)==16)
		{
			cerr << "Key must be 16 byte(128bit)" << endl;
			return 2;
		}

		AES aes;
		unsigned long size = 0;
		unsigned char* data3 = new unsigned char[size];
		aes.Decrypt(dataIn,size,data3,(const unsigned char*)(ARG_PARA));
		
		FILE* fp;
		fp = fopen(ARG_OUTFILE,"wb");
		fwrite(data3,1,size,fp);
		fclose(fp);
		delete[] data3;
	}




	delete[] dataIn;
	return 0;
}

