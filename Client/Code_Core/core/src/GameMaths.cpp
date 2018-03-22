
#include "stdafx.h"

#include "GameMaths.h"
#include <stdarg.h>
#include <math.h>
#include <vector>
unsigned short GameMaths::GetCRC16( 
	const unsigned char *p, /* points to chars to process */ 
	int n,/* how many chars to process */ 
	int start /*= 0 /* starting value */ )
{
	static unsigned int crcl6_table[16] = /* CRC-16s */
	{
		0x0000, 0xCC01, 0xD801, 0x1400,
		0xF001, 0x3C00, 0x2800, 0xE401,
		0xA001, 0X6C00, 0x7800, 0xB401,
		0x5000, 0x9C01, 0x8801, 0x4400
	};
	unsigned short int total; /* the CRC-16 value we compute */
	int r1;
	total = start;
	/* process each byte */
	while ( n-- > 0 )
	{
		/* do the lower four bits */
		r1 = crcl6_table[ total & 0xF ];
		total = ( total >> 4 ) & 0x0FFF;
		total = total ^ r1 ^ crcl6_table[ *p & 0xF ];
		/* do the upper four bits */
		r1 = crcl6_table[ total & 0xF ];
		total = ( total >> 4 ) & 0x0FFF;
		total = total ^ r1 ^ crcl6_table[ ( *p >> 4 ) & 0xF ];
		/* advance to next byte */
		p++;
	}
	return total;
}

void GameMaths::stringAutoReturn( const std::string& inString, std::string& outString, int width, int& lines )
{
	std::string::size_type start;
	outString = "";
	outString.reserve(inString.size()+64);

	width*=2;
	int count = 0;
	for(start = 0;start<inString.size();++start)
	{

		unsigned char cha = inString[start];
		unsigned char andres1 = cha&0x80;
		if(andres1==0)
		{
			count++;
			if(count>width)
			{
				outString.push_back('\n');
				count = 0;
				lines++;
			}			
			outString.push_back(cha);			
		}
		else
		{
			unsigned char andres2 = cha&0x40;
			if(andres2!=0)
			{
				count+=2;
				if(count>=width)
				{
					outString.push_back('\n');
					count = 2;
					lines++;
				}
			}
			outString.push_back(cha);
		}
	}
}

std::string GameMaths::stringAutoReturnForLua( const std::string& inString,int width, int& lines )
{
	std::string::size_type start;
	std::string outString = "";
	outString.reserve(inString.size()+64);

	width*=2;
	int count = 0;
	for(start = 0;start<inString.size();++start)
	{

		unsigned char cha = inString[start];
		unsigned char andres1 = cha&0x80;
		if(andres1==0)
		{
			count++;
			outString.push_back(cha);
			if(count>=width)
			{
				outString.push_back('\n');
				count = 0;
				lines++;
			}
		}
		else
		{
			unsigned char andres2 = cha&0x40;
			if(andres2!=0)
			{
				count+=2;
				if(count>width)
				{
					outString.push_back('\n');
					count = 2;
					lines++;
				}
			}
			outString.push_back(cha);
		}
	}
	return outString;
}

std::string GameMaths::stringCutWidthLen(const std::string& inString,int len)
{
	std::string::size_type start;
	std::string outString = "";
	outString.reserve(inString.size()+64);

	len*=2;
	int count = 0;
	for(start = 0;start<inString.size();++start)
	{

		unsigned char cha = inString[start];
		unsigned char andres1 = cha&0x80;
		if(andres1==0)
		{
			count++;
			outString.push_back(cha);
			if(count>=len)
			{
				return outString;
			}
		}
		else
		{
			unsigned char andres2 = cha&0x40;
			if(andres2!=0)
			{
				count+=2;
				if(count>len)
				{
					return outString;
				}
			}
			outString.push_back(cha);
		}
	}
	return outString;
}

void GameMaths::replaceStringWithBlank( const std::string& inString, std::string& outString )
{
	std::string::size_type start;
	outString = "";
	outString.reserve(inString.size());
	for(start = 0;start<inString.size();++start)
	{

		unsigned char cha = inString[start];
		unsigned char andres1 = cha&0x80;
		if(andres1==0)
		{
			outString.push_back(' ');
		}
		else
		{
			unsigned char andres2 = cha&0x40;
			if(andres2!=0)
			{
				outString.push_back(' ');
				outString.push_back(' ');
			}

		}

	}
}

std::string GameMaths::formatSecondsToTime(int seconds)
{
	if(seconds<0)
	{
		seconds = 0; 
	}
	std::string time = "";
	unsigned int hour = (unsigned int)floor((float)(seconds/3600));
	unsigned int minute = ((unsigned int)floor((float)(seconds/60)))%60;
	unsigned int second = seconds%60;
	char timeStr[32];
	sprintf(timeStr,"%02d:%02d:%02d",hour,minute,second);
	return (std::string)timeStr;
}

std::string GameMaths::formatTimeToDate(int seconds)
{
	time_t tick=(time_t)(seconds);
	struct tm *l=localtime(&tick);
	char buf[128];
	sprintf(buf,"%04d-%02d-%02d %02d:%02d:%02d",l->tm_year+1900,l->tm_mon+1,l->tm_mday,l->tm_hour,l->tm_min,l->tm_sec);
	std::string s(buf);
	return s;
}

std::string GameMaths::replaceStringWithStringList(const std::string& inString,std::list<std::string>* _list)
{
	std::string newStr=inString;
	std::string outStr="";
	std::list<std::string>::iterator it=_list->begin();
	for(int i=1;it!=_list->end();++it,++i)
	{
		char key[128];
		sprintf(key,"#v%d#",i);
		std::string::size_type index=newStr.find(key);
		if(index!=newStr.npos)
		{
			int splitEnd=index+3+(i>9?2:1);
			outStr+=newStr.substr(0,index);
			outStr+=*it;
			newStr=newStr.substr(splitEnd,newStr.length());
		}
	}
	outStr+=newStr;
	_list->clear();
	return outStr;
} 

std::string GameMaths::replaceStringOneForLua(const std::string& inString,const std::string& param)
{
	std::list<std::string> list;
	list.push_back(param);

	return GameMaths::replaceStringWithStringList(inString,&list);
}

std::string GameMaths::replaceStringTwoForLua(const std::string& inString,const std::string& param1,const std::string& param2)
{
	std::list<std::string> list;
	list.push_back(param1);
	list.push_back(param2);

	return GameMaths::replaceStringWithStringList(inString,&list);
}
void GameMaths::readStringToMap( const std::string& inString, std::map<int, std::string>& strMap )
{
	std::string::size_type start = 0;
	std::string::size_type lastEnd = 0;
	int id = 0;
	for(start = 0;start<inString.size();++start)
	{

		char cha = inString[start];
		unsigned char andres1 = cha&0x80;
		unsigned char andres2 = cha&0x40;
		if(andres1==0 || (andres1!=0 && andres2!=0))
		{
			if(start>lastEnd)
			{
				strMap.insert(std::make_pair(id,inString.substr(lastEnd,start - lastEnd)));
				lastEnd = start;
				id++;
			}
		}
	}
	if(lastEnd<inString.size())
	{
		std::string lastStr = inString.substr(lastEnd,inString.size() - lastEnd);
		strMap.insert(std::make_pair(id,lastStr));
	}
}
std::vector<std::string> GameMaths::tokenize(const std::string& src,std::string tok)
{  
	if( src.empty() || tok.empty() )
	{
		throw "tokenize: empty string\0";  
	}  
	std::vector<std::string> v;  
	unsigned int pre_index = 0, index = 0, len = 0;  
	while( (index = src.find_first_of(tok, pre_index))!=-1 )  
	{  
		if( (len = index-pre_index)!=0 )
		{
			v.push_back(src.substr(pre_index, len));
		}
		else
		{
			v.push_back(""); 
		}
		pre_index = index+1;  
	}   
	std::string endstr = src.substr(pre_index);  
	v.push_back( endstr.empty()?"":endstr);   
	return v;  
}

void GameMaths::replaceStringWithCharacter( const std::string& inString, char partten, char dest, std::string& outCharacter )
{
	size_t start = 0;
	size_t length = inString.length();
	outCharacter = inString;
	for(;start<length && start!=std::string::npos;++start)
	{
		if(outCharacter[start]==partten)
			outCharacter[start]=dest;
			//outCharacter.replace(start,start+1,1,dest);
	}
}

void  GameMaths::replaceStringWithCharacterAll(std::string&  str,const std::string& old_value,const std::string& new_value)     
{     
	while(true)   
	{     
		std::string::size_type   pos(0);     
		if((pos=str.find(old_value))!=std::string::npos)     
			str.replace(pos,old_value.length(),new_value);     
		else   
			break;     
	}     
}  

void  GameMaths::replaceStringWithCharacterAllDistinct(std::string& str,const std::string& old_value,const std::string& new_value)     
{     
	for(std::string::size_type pos(0);pos!=std::string::npos;pos+=new_value.length())  
	{     
		if((pos=str.find(old_value,pos))!=std::string::npos)     
			str.replace(pos,old_value.length(),new_value);     
		else  
			break;     
	}     
}     

int GameMaths::calculateStringCharacters( const std::string& str )
{
	std::string::size_type start;

	int count = 0;
	for(start = 0;start<str.size();++start)
	{

		unsigned char cha = str[start];
		unsigned char andres1 = cha&0x80;
		if(andres1==0)
		{
			count++;
		}
		else
		{
			unsigned char andres2 = cha&0x40;
			if(andres2!=0)
			{
				count++;
			}
		}

	}
	return count;
}

int GameMaths::calculateStringCharactersOfChina(const std::string& str)
{
	std::string::size_type start;
	
	int chinaNum = 0;
	int englishNum = 0;
	
	for(start = 0;start<str.size();++start)
	{
		unsigned char cha = str[start];
		unsigned char andres1 = cha&0x80;
		if(andres1==0)
		{
			englishNum++;
		}else
		{
			unsigned char andres2 = cha&0x40;
			if(andres2!=0)
			{
				chinaNum++;
			}
		}
	}
	
	int tmp = englishNum%2>0?englishNum/2+1:englishNum/2;
	return tmp+chinaNum;
}


std::string GameMaths::getStringSubCharacters( const std::string& inString, int offset, int length )
{
	std::string::size_type start;
	std::string outString = "";
	
	int count = 0;
	
	for(start = 0;start<inString.size();++start)
	{

		unsigned char cha = inString[start];
		
		unsigned char andres1 = cha&0x80;
		if(andres1==0)
		{
			count++;
		}
		else
		{
			unsigned char andres2 = cha&0x40;
			if(andres2!=0)
			{
				count++;
			}
		}

		if(count>offset && count<= offset+length)
			outString.push_back(cha);
		else if(count>offset+length)
			break;

	}
	return outString;
}

bool GameMaths::hasSubString(const char * str_trgt, const char * str_src)
{
    
    while(*str_trgt){
        
        if(strncmp(str_trgt++, str_src,strlen(str_src)) == 0)
        {
            return true;
        }
    }
    return false;
}

bool GameMaths::isStringHasUTF8mb4( const std::string& inString )
{
	std::string::size_type start;
	int count = 1;

	for(start = 0;start<inString.size();++start)
	{
		unsigned char cha = inString[start];

		unsigned char andres1 = cha&0x80;
		if(andres1==0)
		{
			count=1;
		}
		else
		{
			unsigned char andres2 = cha&0x40;
			if(andres2!=0)
				count=1;
			else
				count++;
		}

		if(count==4)
			return true;

	}
	return false;
}
int GameMaths::ReverseAuto( int value )
{
	union BE_Check
	{
		int i;
		char c[4];
	}bec;
	bec.i=1;
	if (bec.c[0] = 1)
	{
		return Reverse<int>(value); /* little endian */
	}
	else
	{
		return value; /* big endian */		
	}
}
