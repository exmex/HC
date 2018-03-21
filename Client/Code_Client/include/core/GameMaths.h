#pragma once


#include <string>
#include <list>
#include <map>
#include <vector>
#include <time.h>
class GameMaths
{
public:

// 	int start, /* starting value */
// 	const char *p, /* points to chars to process */
// 	int n 	/* how many chars to process */
	static unsigned short GetCRC16 (
		const unsigned char *p, /* points to chars to process */
		int n,/* how many chars to process */
		int start = 0 /* starting value */);	

	static void stringAutoReturn(const std::string& inString, std::string& outString, int width, int& lines);
	static std::string stringAutoReturnForLua(const std::string& inString, int width, int& lines);
	static std::string stringCutWidthLen(const std::string& inString,int len);
	static int calculateStringCharacters(const std::string& str);

	static int calculateStringCharactersOfChina(const std::string& str);

	static std::string getStringSubCharacters(const std::string& str, int offset, int lenght);
	static void replaceStringWithBlank(const std::string& inString, std::string& outString);
	static void readStringToMap(const std::string& inString, std::map<int, std::string>& strMap);
	static void replaceStringWithCharacter(const std::string& inString, char partten, char dest, std::string& outCharacter);
	static void replaceStringWithCharacter(std::string& inString, char dest);
	static std::string formatSecondsToTime(int seconds);
	static std::string formatTimeToDate(int seconds);
	static std::vector<std::string> tokenize(const std::string& src,std::string tok);
	static std::string replaceStringWithStringList(const std::string& inString,std::list<std::string>* _list);
	static std::string replaceStringOneForLua(const std::string& inString,const std::string& param);
	static std::string replaceStringTwoForLua(const std::string& inString,const std::string& param1,const std::string& param2);
    static bool isStringHasUTF8mb4(const std::string& instring);
    static bool hasSubString(const char* longString, const char* subString);
	static int ReverseAuto( int value );
	static void replaceStringWithCharacterAll(std::string&  str,const std::string& old_value,const std::string& new_value);   
	static void  replaceStringWithCharacterAllDistinct(std::string& str,const std::string& old_value,const std::string& new_value);     
};




template <typename Integer>
Integer Reverse( Integer value )

{
	char *p1 = reinterpret_cast<char*>(&value);
	char *p2 = p1 + sizeof(Integer) - 1;
	for (; p1 < p2; ++p1, --p2) {
		char t = *p1;*p1=*p2;*p2 =t;
	}

	return value;
}


template <typename Integer>
Integer ReverseAuto( Integer value )
{
	union BE_Check
	{
		int i;
		char c[4];
	}bec;
	bec.i=1;
	if (bec.c[0] == 1)
	{
		return Reverse<Integer>(value); /* little endian */
	}
	else
	{
		return value; /* big endian */		
	}
}


