#include "Base64.h"
   
std::string core_base64Encode(const unsigned char* inData, int inSize)   
{  		
	if (!inData || inSize <= 0)
		return "";
		
	//返回值
	std::string strEncode = "";
	const unsigned char* pTmpData = inData;

	//编码表
	const static char EncodeTable[] = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/";

	unsigned char Tmp[3] = {0};
	for(int i=0;i<(inSize / 3);i++)
	{
		Tmp[0] = *pTmpData++;
		Tmp[1] = *pTmpData++;
		Tmp[2] = *pTmpData++;

		strEncode += EncodeTable[Tmp[0] >> 2];
		strEncode += EncodeTable[((Tmp[0] << 4) | (Tmp[1] >> 4)) & 0x3F];
		strEncode += EncodeTable[((Tmp[1] << 2) | (Tmp[2] >> 6)) & 0x3F];
		strEncode += EncodeTable[Tmp[2] & 0x3F];
	}

	//对剩余数据进行编码
	int iMod = inSize % 3;
	if(iMod == 1)
	{
		Tmp[0] = *pTmpData++;
		strEncode += EncodeTable[(Tmp[0] & 0xFC) >> 2];
		strEncode += EncodeTable[((Tmp[0] & 0x03) << 4)];
		strEncode += "==";
	}
	else if(iMod == 2)
	{
		Tmp[0] = *pTmpData++;
		Tmp[1] = *pTmpData++;
		strEncode += EncodeTable[(Tmp[0] & 0xFC) >> 2];
		strEncode += EncodeTable[((Tmp[0] & 0x03) << 4) | ((Tmp[1] & 0xF0) >> 4)];
		strEncode += EncodeTable[((Tmp[1] & 0x0F) << 2)];
		strEncode += "=";
	}
	return strEncode;
}
