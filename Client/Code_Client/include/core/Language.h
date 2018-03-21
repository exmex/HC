#pragma once
#include "Singleton.h"
#include <string>
#include <map>


namespace cocos2d{
	class CCNode;
};

/**
The language class is to translate key to a certain language
Which means all Strings being used to displayed must get from this class

*/
class Language: public Singleton<Language>
{
public:
	void init(const std::string& languagefile);
	void addLanguageFile(const std::string& languagefile);
	bool hasString(const std::string& _key);
	const std::string & getString(const std::string& _key);

	void updateNode(cocos2d::CCNode* _root);
	void clear();

	//for Lua script
	static Language* getInstance();
private:
	std::map<std::string,std::string> mStrings;
	void replaceEnter(std::string &_str);
};

