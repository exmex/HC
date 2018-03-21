<?php
require_once($GLOBALS['GAME_ROOT'] . "Classes/UserSettingsModule.php");
require_once($GLOBALS['GAME_ROOT'] . "DbModule/SysLocalStrings.php");

class LocalString
{
    private static $StringMap = array();

    public static $SupportLanguages = array(
        "en-US",
        "fr-FR",
        "it-IT",
        "de-DE",
        "es-ES",
        "ru-RU",
        "ko-KR",
        "ja-JP",
        "pt-BR",
        "ms-MY",
        "nb-NO",
        "nl-NL",
        "th-TH",
        "tr-TR",
        "vi-VN",
        "id-ID");

    public static function getString($key, $lang = null)
    {
        if (!$lang) {
            $setting = UserSettingsModule::GetUserSetting();
            $lang = $setting->language;
        }

        if (isset (self::$StringMap [$lang])) {
            $strings = self::$StringMap [$lang];
            if (isset ($strings [$key])) {
                return $strings [$key];
            }
        } else {
            self::$StringMap [$lang] = array();
        }

        $string = self::getData($key, $lang);
        if (empty($string)) {
            $tbLocalString = new SysLocalStrings();
            $tbLocalString->setKey($key);
            $tbLocalString->setLang($lang);
            $found = true;
            if (!$tbLocalString->LoadedExistFields()) {
                $found = false;
            }
            $string = $tbLocalString->getString();
            if (empty($string)) {
                $found = false;
            }
            if ($found == false) {
                if ($lang == UserSetting::default_language) {
                    return $key;
                } else {
                    return self::getString($key, UserSetting::default_language);
                }
            }
            self::setString($key, $lang, $string);
        }
        return $string;
    }

    public static function setString($key, $lang = null, $value)
    {
        if (!isset (self::$StringMap [$lang])) {
            self::$StringMap [$lang] = array();
        }
        self::$StringMap [$lang][$key] = $value;
        $tbLocalString = new SysLocalStrings();
        $tbLocalString->setKey($key);
        $tbLocalString->setLang($lang);
        $tbLocalString->LoadedExistFields();
        $tbLocalString->setString($value);
        $tbLocalString->inOrUp();


        self::setData($key, $lang, $value);
    }

    private static function setData($key, $lang, $val)
    {
        $key = "local_" . $lang . "_" . $key;
        CMemcache::getInstance()->setData($key, $val, MEMCACHE_EXPIRE_TIME); //默认24个小时过期
    }

    private static function getData($key, $lang)
    {
        $key = "local_" . $lang . "_" . $key;
        $val = CMemcache::getInstance()->getData($key);
        if (empty($val) && isset($default)) {
            $val = "";
        }
        return $val;
    }
}
 