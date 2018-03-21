#ifndef _INI_FILE_H_
#define _INI_FILE_H_

#include <map>
#include <string>
#include "IteratorWrapper.h"

/*
1.支持 # 和 @ 开头的注释
2.支持自定义分隔符，默认支持 "\t" ":" "=" 作为分隔符
3.支持去前后空格
example：
#example star
[path]
@path
 qulityA=mainscene/aa.png
qulityb = mainscene/bb.png
 qulityc =mainscene/cc.png

 qulitye : 256
 qulityf	777
#color
[color]
qulityd = 255 255 255

#example end

*/
class ConfigFile
{
public:

    ConfigFile();
    virtual ~ConfigFile();

    void load(std::stringstream& stream, const std::string& separators = "\t:=", bool trimWhitespace = true);

	void load(const std::string& filename, const std::string& separators = "\t:=", bool trimWhitespace = true);
	
    std::string getSetting(const std::string& key, const std::string& section = "", const std::string& defaultValue = "") const;

    typedef std::map<std::string, std::string> SettingsMap;

    typedef std::map<std::string, SettingsMap*> SettingsBySection;
    
    void clear(void);

	typedef ConstMapIterator<SettingsMap> SettingsMapIterator;
	SettingsMapIterator getSettingsMapIterator(const std::string& section = "");
protected:
	
    SettingsBySection mSettings;
};

#endif //end of _INI_FILE_H_