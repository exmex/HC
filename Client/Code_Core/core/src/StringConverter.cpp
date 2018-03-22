#include "stdafx.h"

#include "StringConverter.h"
#include "Language.h"
#include <sstream>

//-----------------------------------------------------------------------
std::string StringConverter::toString(float val, unsigned short precision, 
	unsigned short width, char fill, std::ios::fmtflags flags)
{
	std::stringstream stream;
	stream.precision(precision);
	stream.width(width);
	stream.fill(fill);
	if (flags)
		stream.setf(flags);
	stream << val;
	return stream.str();
}
//-----------------------------------------------------------------------
std::string StringConverter::toString(int val, 
	unsigned short width, char fill, std::ios::fmtflags flags)
{
	std::stringstream stream;
	stream.width(width);
	stream.fill(fill);
	if (flags)
		stream.setf(flags);
	stream << val;
	return stream.str();
}
//-----------------------------------------------------------------------
std::string StringConverter::toString(unsigned int val, 
	unsigned short width, char fill, std::ios::fmtflags flags)
{
	std::stringstream stream;
	stream.width(width);
	stream.fill(fill);
	if (flags)
		stream.setf(flags);
	stream << val;
	return stream.str();
}
//-----------------------------------------------------------------------
std::string StringConverter::toString(unsigned long val, 
	unsigned short width, char fill, std::ios::fmtflags flags)
{
	std::stringstream stream;
	stream.width(width);
	stream.fill(fill);
	if (flags)
		stream.setf(flags);
	stream << val;
	return stream.str();
}
//-----------------------------------------------------------------------
std::string StringConverter::toString(long val, 
	unsigned short width, char fill, std::ios::fmtflags flags)
{
	std::stringstream stream;
	stream.width(width);
	stream.fill(fill);
	if (flags)
		stream.setf(flags);
	stream << val;
	return stream.str();
}
//-----------------------------------------------------------------------
std::string StringConverter::toString(int64_t val, 
	unsigned short width, char fill, std::ios::fmtflags flags)
{
	std::stringstream stream;
	stream.width(width);
	stream.fill(fill);
	if (flags)
		stream.setf(flags);
	stream << val;
	return stream.str();
}

//-----------------------------------------------------------------------
std::string StringConverter::toString(bool val, bool yesNo)
{
	if (val)
	{
		if (yesNo)
		{
			return "yes";
		}
		else
		{
			return "true";
		}
	}
	else
		if (yesNo)
		{
			return "no";
		}
		else
		{
			return "false";
		}
}

std::string StringConverter::toString( const cocos2d::CCRect& val )
{
	char buff[256] = {0};
	sprintf(buff , "%f %f %f %f" , val.origin.x , val.origin.y , val.size.width , val.size.height);

	return std::string(buff);
}

std::string StringConverter::toString( const cocos2d::CCSize& val )
{
	char buff[128] = {0};
	sprintf(buff , "%f %f" , val.width , val.height);

	return std::string(buff);
}

std::string StringConverter::toString( const cocos2d::CCPoint& val )
{
	char buff[128] = {0};
	sprintf(buff , "%f %f" , val.x , val.y);

	return std::string(buff);
}

std::string StringConverter::toString( const cocos2d::ccColor3B& val )
{
	char buff[256] = {0};
	int r = val.r;
	int g = val.g;
	int b = val.b;
	sprintf(buff , "%d %d %d" , r , g , b);

	return std::string(buff);
}

//-----------------------------------------------------------------------
float StringConverter::parseReal(const std::string& val, float defaultValue)
{
	// Use istringstream for direct correspondence with toString
	std::stringstream str(val);
	float ret = defaultValue;
	if( !(str >> ret) )
		return defaultValue;

	return ret;
}
//-----------------------------------------------------------------------
int StringConverter::parseInt(const std::string& val, int defaultValue)
{
	// Use istringstream for direct correspondence with toString
	std::stringstream str(val);
	int ret = defaultValue;
	if( !(str >> ret) )
		return defaultValue;

	return ret;
}
//-----------------------------------------------------------------------
unsigned int StringConverter::parseUnsignedInt(const std::string& val, unsigned int defaultValue)
{
	// Use istringstream for direct correspondence with toString
	std::stringstream str(val);
	unsigned int ret = defaultValue;
	if( !(str >> ret) )
		return defaultValue;

	return ret;
}
//-----------------------------------------------------------------------
long StringConverter::parseLong(const std::string& val, long defaultValue)
{
	// Use istringstream for direct correspondence with toString
	std::stringstream str(val);
	long ret = defaultValue;
	if( !(str >> ret) )
		return defaultValue;

	return ret;
}

int64_t StringConverter::parseInt64(const std::string &val,int64_t defaultValue /* = 0 */)
{
	std::stringstream str(val);
	int64_t ret = defaultValue;
	if( !(str >> ret) )
		return defaultValue;

	return ret;
}

//-----------------------------------------------------------------------
unsigned long StringConverter::parseUnsignedLong(const std::string& val, unsigned long defaultValue)
{
	// Use istringstream for direct correspondence with toString
	std::stringstream str(val);
	unsigned long ret = defaultValue;
	if( !(str >> ret) )
		return defaultValue;

	return ret;
}
//-----------------------------------------------------------------------
size_t StringConverter::parseSizeT(const std::string& val, size_t defaultValue)
{
	// Use istringstream for direct correspondence with toString
	std::stringstream str(val);
	size_t ret = defaultValue;
	if( !(str >> ret) )
		return defaultValue;

	return ret;
}
//-----------------------------------------------------------------------
bool StringConverter::parseBool(const std::string& val, bool defaultValue)
{
	if (val == "true" || val == "yes" || val == "1")
		return true;
	else if (val == "false" || val == "no" || val == "0")
		return false;
	else
		return defaultValue;
}

cocos2d::CCRect StringConverter::parseRect( const std::string& val )
{
	cocos2d::CCRect rect(0 , 0 , 0 , 0);
	sscanf(val.c_str(), "%f %f %f %f", &rect.origin.x , &rect.origin.y , &rect.size.width , &rect.size.height);

	return rect;
}

cocos2d::CCPoint StringConverter::parsePoint( const std::string& val )
{
	cocos2d::CCPoint point(0 , 0);
	sscanf(val.c_str(), "%f %f", &point.x , &point.y);

	return point;
}

cocos2d::CCSize StringConverter::parseSize( const std::string& val )
{
	cocos2d::CCSize size(0 , 0);
	sscanf(val.c_str(), "%f %f", &size.width , &size.height);

	return size;
}

cocos2d::ccColor3B StringConverter::parseColor3B( const std::string& val )
{
	cocos2d::ccColor3B color = cocos2d::ccBLACK;

	int a = 0 , b = 0 , c = 0;
	sscanf(val.c_str(), "%d %d %d", &a , &b , &c);

	color.r = a; color.g = b; color.b = c;

	return color;
}

//////////////////////////////////////////////////////////////////////////
//add by xinghui
cocos2d::ccColor4F StringConverter::parseColor4F(const std::string& val)
{
	cocos2d::ccColor4F color = cocos2d::ccc4FFromccc3B(cocos2d::ccBLACK);
	float r=0.0f, g=0.0f, b=0.0f, a=0.0f;
	if (!val.empty())
	{
		sscanf(val.c_str(), "%f %f %f %f", &r, &g, &b, &a);
		color.r = r; color.g = g; color.b = b, color.a = a;
	}
	return color;
}
//////////////////////////////////////////////////////////////////////////

void StringConverter::parseVectorForColon(const std::string& val,std::vector<unsigned int>& vec)
{
	std::string str = val;
	std::string::size_type pos = str.find_first_of(':');
	if (pos == std::string::npos)
	{
		StringConverter::parseUnsignedInt(str);
		return;
	}
	std::string token = str.substr(0,pos);
	while (pos != std::string::npos)
	{
		unsigned int n = StringConverter::parseUnsignedInt(token);
		vec.push_back(n);
		str = str.substr(pos+1,str.length());
		pos = str.find_first_of(':');
		token = str.substr(0,pos);
		if (pos == std::string::npos)
		{
			unsigned int n = StringConverter::parseUnsignedInt(str);
			vec.push_back(n);
		}
	}
}

void StringConverter::parseVectorForUnderline(const std::string& val,std::vector<unsigned int>& vec)
{
	std::string str = val;
	std::string::size_type pos = str.find_first_of('_');
	if (pos == std::string::npos)
	{
		vec.push_back(StringConverter::parseUnsignedInt(str));
		return;
	}
	std::string token = str.substr(0,pos);
	while (pos != std::string::npos)
	{
		unsigned int n = StringConverter::parseUnsignedInt(token);
		vec.push_back(n);
		str = str.substr(pos+1,str.length());
		pos = str.find_first_of('_');
		token = str.substr(0,pos);
		if (pos == std::string::npos)
		{
			unsigned int n = StringConverter::parseUnsignedInt(str);
			vec.push_back(n);
		}
	}
}

void StringConverter::parseVector(const std::string& val,std::vector<unsigned int>& vec)
{
	std::string str = val;
	std::string::size_type pos = str.find_first_of(',');	
	if (pos == std::string::npos)
	{
		StringConverter::parseVectorForUnderline(str,vec);
		return;
	}
	std::string token = str.substr(0, pos);
	while(pos != std::string::npos)
	{		
		StringConverter::parseVectorForUnderline(token,vec);		
		str = str.substr(pos+1,str.length());
		pos = str.find_first_of(',');
		token = str.substr(0,pos);
		if (pos == std::string::npos)
		{
			StringConverter::parseVectorForUnderline(str,vec);
		}
	}
}