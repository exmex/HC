#ifndef __StringConverter_H__
#define __StringConverter_H__

#include "cocos2d.h"

#include <string>
#include <ios>

class StringConverter
{
public:

    /** Converts a Real to a String. */
    static std::string toString(float val, unsigned short precision = 6, 
        unsigned short width = 0, char fill = ' ', 
        std::ios::fmtflags flags = std::ios::fmtflags(0) );
    
    /** Converts an int to a String. */
    static std::string toString(int val, unsigned short width = 0, 
        char fill = ' ', 
        std::ios::fmtflags flags = std::ios::fmtflags(0) );

    /** Converts an unsigned int to a String. */
    static std::string toString(unsigned int val, 
        unsigned short width = 0, char fill = ' ', 
        std::ios::fmtflags flags = std::ios::fmtflags(0) );
    /** Converts an unsigned long to a String. */
    static std::string toString(unsigned long val, 
        unsigned short width = 0, char fill = ' ', 
        std::ios::fmtflags flags = std::ios::fmtflags(0) );
    /** Converts a long to a String. */
    static std::string toString(long val, 
        unsigned short width = 0, char fill = ' ', 
        std::ios::fmtflags flags = std::ios::fmtflags(0) );

	/** Converts a int64 to a String. */
	static std::string toString(int64_t val, 
		unsigned short width = 0, char fill = ' ', 
		std::ios::fmtflags flags = std::ios::fmtflags(0) );
    /** Converts a boolean to a String. 
    @param yesNo If set to true, result is 'yes' or 'no' instead of 'true' or 'false'
    */
    static std::string toString(bool val, bool yesNo = false);

	static std::string toString(const cocos2d::CCRect& val);
	static std::string toString(const cocos2d::CCSize& val);
	static std::string toString(const cocos2d::CCPoint& val);
	static std::string toString(const cocos2d::ccColor3B& val);
	

    /** Converts a String to a Real. 
    @return
        0.0 if the value could not be parsed, otherwise the Real version of the String.
    */
    static float parseReal(const std::string& val, float defaultValue = 0);
    
    /** Converts a String to a whole number. 
    @return
        0.0 if the value could not be parsed, otherwise the numeric version of the String.
    */
    static int parseInt(const std::string& val, int defaultValue = 0);
    /** Converts a String to a whole number. 
    @return
        0.0 if the value could not be parsed, otherwise the numeric version of the String.
    */
    static unsigned int parseUnsignedInt(const std::string& val, unsigned int defaultValue = 0);
    /** Converts a String to a whole number. 
    @return
        0.0 if the value could not be parsed, otherwise the numeric version of the String.
    */
    static long parseLong(const std::string& val, long defaultValue = 0);

	/** Converts a String to a whole number. 
    @return
        0.0 if the value could not be parsed, otherwise the numeric version of the String.
    */
	static int64_t parseInt64(const std::string &val,int64_t defaultValue = 0);

    /** Converts a String to a whole number. 
    @return
        0.0 if the value could not be parsed, otherwise the numeric version of the String.
    */
    static unsigned long parseUnsignedLong(const std::string& val, unsigned long defaultValue = 0);
    /** Converts a String to size_t. 
    @return
        defaultValue if the value could not be parsed, otherwise the numeric version of the String.
    */
    static size_t parseSizeT(const std::string& val, size_t defaultValue = 0);
    /** Converts a String to a boolean. 
    @remarks
        Returns true if case-insensitive match of the start of the string
		matches "true", "yes" or "1", false otherwise.
    */
    static bool parseBool(const std::string& val, bool defaultValue = 0);

	static cocos2d::CCRect parseRect(const std::string& val);
	static cocos2d::CCPoint parsePoint(const std::string& val);
	static cocos2d::CCSize parseSize(const std::string& val);
	static cocos2d::ccColor3B parseColor3B(const std::string& val);
	//add by xinghui
	static cocos2d::ccColor4F parseColor4F(const std::string& val);
	//
	/*Convert a string to map
	*for example "14:12,12:23" 14 is key 12 is val
	*/
	static void parseVectorForColon(const std::string& val,std::vector<unsigned int>& vec);
	/*Convert a string to map
	*for example "14_12,12_23" 14 is key 12 is val
	*/
	static void parseVectorForUnderline(const std::string& val,std::vector<unsigned int>& vec);
	static void parseVector(const std::string& val,std::vector<unsigned int>& vec);
};

#endif

