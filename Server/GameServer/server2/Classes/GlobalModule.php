<?php

require_once($GLOBALS['GAME_ROOT'] . "DbModule/SysGlobal.php");

/**
 * 用于存储全局数据信息
 *
 */
class GlobalModule
{

    const GLOBAL_MANAGER_MEMCACHE_PREFIX = "GLOBAL_MANAGER_KEY_";

    /** 魂匣每日可获取的三种灵魂石key */
    const TAVERN_MAGIC_DAY_SOUL = 1;

    public function __construct()
    {

    }

    /**
     * 获取存储的全局数据
     *
     * @param $key
     * @param int $day
     * @return bool|null
     */
    public static function getGlobalData($key, $day = 0)
    {
        if ($day == 0) {
            $day = self::getDayFromTimeStamp(0);
        }

        $value = self::getDataFromMemcache($key, $day);
        if (!empty($value)) {
            return $value;
        }

        $tbGlobal = new SysGlobal();
        $tbGlobal->setKey($key);
        $tbGlobal->setDay($day);
        if ($tbGlobal->LoadedExistFields()) {
            $value = $tbGlobal->getValue();
            self::setDataToMemcache($key, $value, $day);
            return $value;
        }

        return null;
    }

    /**
     *
     * @param $key
     * @param $value
     */
    public static function insertGlobalData($key, $value, $day = 0)
    {
        if ($day == 0) {
            $day = self::getDayFromTimeStamp(0);
        }

        $tbGlobal = new SysGlobal();
        $tbGlobal->setKey($key);
        $tbGlobal->setDay($day);
        if ($tbGlobal->LoadedExistFields()) {
            //不更新已有数据
        } else {
            $tbGlobal->setValue($value);
            $tbGlobal->inOrUp();
        }
    }

    /**
     * 从时间戳返回所需要的day
     *
     * @param int $time 时间戳
     * @return int
     */
    public static function getDayFromTimeStamp($time)
    {
        if ($time == 0) {
            return sprintf("%0.0f", date("Ymd", time()));
        }

        return sprintf("%0.0f", date("Ymd", $time));
    }


    /**
     * 从memcache中获取存储的数据
     *
     * @param $key
     * @param $day
     * @param null $default
     * @return bool|null
     */
    private static function getDataFromMemcache($key, $day, $default = null)
    {
        $key = self::GLOBAL_MANAGER_MEMCACHE_PREFIX . $key . "_" . $day;
        $val = CMemcache::getInstance()->getData($key);
        if (empty($val) && isset($default)) {
            $val = $default;
        }

        return $val;
    }

    /**
     * 把数据存进memcache
     *
     * @param $key
     * @param $value
     * @param $day
     */
    private static function setDataToMemcache($key, $value, $day)
    {
        $key = self::GLOBAL_MANAGER_MEMCACHE_PREFIX . $key . "_" . $day;
        CMemcache::getInstance()->setData($key, $value, 86400);
    }

}
 