<?php

/**
 * User: Ray@raymix.net
 * Date: 14-9-11
 * Time: 上午10:19
 */
class UserSetting
{
    const default_language = "en-US";

    private $settings;

    public $language/*:string utf-8*/= self::default_language;

    function __set($n, $v)
    {
        $this->settings[$n] = $v;
    }

    function __get($name)
    {
        return $this->settings[$name];
    }

    function __construct($data)
    {
        if (empty($data)) {
            $this->settings = array();
        } else {
            $this->settings = json_decode($data, true);
        }
        $this->language = $this->getSetting("language",self::default_language);
    }

    private function getSetting($key,$default = null)
    {
        if(isset($this->settings[$key]))
        {
            return $this->settings[$key];
        }
        return $default;
    }

    function  toString()
    {
        return json_encode($this->settings);
    }
}


class UserSettingsModule
{
    public static function GetUserSetting($uin = 0)
    {
        if ($uin == 0 && isset($GLOBALS['USER_IN'])) {
            $uin = $GLOBALS['USER_IN'];
        }
        $settingsData = PlayerCacheModule::getSettings($uin);
        $value = new UserSetting($settingsData);
        return $value;
    }

}
 