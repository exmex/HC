
#include "stdafx.h"

#include "inifile.h"
#include "cocos2d.h"
#include "GamePlatform.h"
#include "StringConverter.h"
#include "GameEncryptKey.h"
//-----------------------------------------------------------------------
ConfigFile::ConfigFile()
{
}
//-----------------------------------------------------------------------
ConfigFile::~ConfigFile()
{
	clear();
}
//-----------------------------------------------------------------------
void ConfigFile::clear(void)
{
	for (SettingsBySection::iterator seci = mSettings.begin(); 
		seci != mSettings.end(); ++seci)
	{
		delete seci->second;
		seci->second = NULL;
	}
	mSettings.clear();
}
//-----------------------------------------------------------------------
void ConfigFile::load(const std::string& filename, const std::string& separators, bool trimWhitespace)
{
	bool ret = false;
	unsigned long filesize;
	char* pBuffer = (char*)getFileData(
		cocos2d::CCFileUtils::sharedFileUtils()->fullPathForFilename(filename.c_str(),EncFileNameFlag,EncFilePath,ShowSuffixFlag).c_str(),
		"rt",&filesize);
	if(!pBuffer)
		return;
	char* newData = new char[filesize+1];
	if(newData)
	{
		memcpy(newData,pBuffer,filesize);
		newData[filesize]=0;

		std::stringstream filestream(newData);
		load(filestream, separators, trimWhitespace);
	
		delete[] newData;
	}
	CC_SAFE_DELETE_ARRAY(pBuffer);
	return;

}

//-----------------------------------------------------------------------
void ConfigFile::load(std::stringstream& stream, const std::string& separators, bool trimWhitespace)
{
	/* Clear current settings map */
	clear();

	std::string currentSection = "";
	SettingsMap* currentSettings = new SettingsMap();
	mSettings[currentSection] = currentSettings;

	/* Process the file line for line */
	std::string line, optName, optVal;
	while (!stream.eof())
	{
		std::getline(stream,line);

		/* Ignore comments & blanks */
		if (line.length() > 0 && line.at(0) != '#' && line.at(0) != '@')
		{
			static int optName_pos = 0;
			if (line.at(0) == '[' && line.at(line.length()-1) == ']')
			{
				// Section
				currentSection = line.substr(1, line.length() - 2);
				SettingsBySection::const_iterator seci = mSettings.find(currentSection);
				if (seci == mSettings.end())
				{
					currentSettings = new SettingsMap();
					mSettings[currentSection] = currentSettings;
					optName_pos = 0;
				}
				else
				{
					currentSettings = seci->second;
				} 
			}
			else
			{
				/* Find the first seperator character and split the string there */
				std::string::size_type separator_pos = line.find_first_of(separators, 0);
				if (separator_pos == std::string::npos)
					separator_pos = 0;
				optName = line.substr(0, separator_pos);
				/* Find the first non-seperator character following the name */
				std::string::size_type nonseparator_pos = line.find_first_not_of(separators, separator_pos);
				/* ... and extract the value */
				/* Make sure we don't crash on an empty setting (it might be a valid value) */
				optVal = (nonseparator_pos == std::string::npos) ? "" : line.substr(nonseparator_pos);
				if (trimWhitespace)
				{
					static const std::string delims = " \t\r";
					optVal.erase(optVal.find_last_not_of(delims) + 1);
					optVal.erase(0, optVal.find_first_not_of(delims));

					optName.erase(optName.find_last_not_of(delims) + 1);
					optName.erase(0, optName.find_first_not_of(delims));
				}

				if(optName == "")
				{
					do 
					{
						optName = StringConverter::toString(optName_pos++);
					} while (currentSettings->find(optName) != currentSettings->end());
				}
				currentSettings->insert(SettingsMap::value_type(optName, optVal));
			}
		}
	}
}
//-----------------------------------------------------------------------
std::string ConfigFile::getSetting(const std::string& key, const std::string& section, const std::string& defaultValue) const
{
	SettingsBySection::const_iterator seci = mSettings.find(section);
	if (seci == mSettings.end())
	{
		return defaultValue;
	}
	else
	{
		SettingsMap::const_iterator i = seci->second->find(key);
		if (i == seci->second->end())
		{
			return defaultValue;
		}
		else
		{
			return i->second;
		}
	}
}
//-----------------------------------------------------------------------
ConfigFile::SettingsMapIterator ConfigFile::getSettingsMapIterator( const std::string& section /*= ""*/ )
{
	return SettingsMapIterator(mSettings[section]->begin(), mSettings[section]->end());
}
