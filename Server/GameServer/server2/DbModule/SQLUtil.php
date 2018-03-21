<?php

class SQLUtil
{
    /**
     * 将查询field转为字符串
     * @param $fields
     * @return string
     */
    public static function parseFields($fields)
    {
        if (!is_array($fields)) {
            return $fields;
        }

        $nf = '';

        foreach ($fields as $key) {
            $k = addslashes($key);
            $nf .= "`{$k}`,";
        }

        $i = strrpos($nf, ",");
        if (!is_bool($i)) {
            $nf = substr($nf, 0, $i);
        }

        return $nf;
    }

    /**
     * 增加 或者减少
     * @param $fields
     * @param $values
     * @return unknown_type
     */
    public static function parseASFieldValues($fieldValue, $add = true)
    {
        $op = "-";
        if ($add) {
            $op = "+";
        }
        //检查 fields 跟 values是否对应 
        if (!is_array($fieldValue) || count($fieldValue) == 0) {
            return;
        }

        $fs = "";

        foreach ($fieldValue as $key => $value) {
            $k = addslashes($key);
            $v = addslashes($value);
            $fs .= "`{$k}`=`{$k}`{$op}'{$v}',";
        }

        $j = strrpos($fs, ",");
        if (!is_bool($j)) {
            $fs = substr($fs, 0, $j);
        }

        return $fs;
    }

    /**
     * 将查询条件数组转为字符串
     * @param array $con
     * @return string
     */
    public static function parseCondition($con)
    {
        if (!is_array($con)) {
            return $con;
        }

        $newCon = '';

        foreach ($con as $key => $value) {
            //if((is_string($key) && empty($key)) || (is_string($value) && empty($value)))
            //{
            //	return "0=1";
            //}

            $k = addslashes($key);
            $v = addslashes($value);

            $newCon .= "`{$k}`='{$v}' AND ";
        }

        $i = strrpos($newCon, "AND");
        if (!is_bool($i)) {
            $newCon = substr($newCon, 0, $i);
        }

        return $newCon;
    }

    public static function toSafeSQLString($s)
    {
        $s = strval($s);
        $ns = addslashes($s);
        return $ns;
    }

    public static function now()
    {
        return date("Y-m-d H:i:s");
    }

    public static function today()
    {
        return date("Y-m-d");
    }

    public static function curHour()
    {
        return date("Y-m-d H:00:00");
    }

    public static function curMinute()
    {
        return date("Y-m-d H:i:00");
    }

    public static function toMinute($time)
    {
        return date("Y-m-d H:i:00", $time);
    }

    //time格式 Y-m-d H:i:s
    public static function isTodayByStr($time)
    {
        if (date("Y-m-d") === date("Y-m-d", strtotime($time))) {
            return true;
        }
        return false;
    }

    //time格式int
    public static function isTodayByStamp($time)
    {
        if (date("Y-m-d") === date("Y-m-d", $time)) {
            return true;
        }
        return false;
    }

    //time格式int
    public static function isSameDayByStamp($timeA, $timeB)
    {
        if (date("Y-m-d", $timeA) === date("Y-m-d", $timeB)) {
            return true;
        }
        return false;
    }


    //time格式 Y-m-d H:i:s
    //计算经过的小时
    public static function hourDiff($time)
    {
        $lastHour = date("Y-m-d H:00:00", strtotime($time));
        $currentHour = date("Y-m-d H:00:00");

        $diff = floor((strtotime($currentHour) - strtotime($lastHour)) / 3600);

        return $diff;
    }

    //time格式 Y-m-d H:i:s
    //计算经过的天
    public static function dayDiff($time)
    {
        $lastHour = date("Y-m-d H:00:00", strtotime($time));
        $currentHour = date("Y-m-d H:00:00");

        $diff = floor((strtotime($currentHour) - strtotime($lastHour)) / 86400);

        return $diff;
    }

    /**
     * 字符串时间转时间戳
     * @param  Y -m-d H:i:s $time
     */
    public static function str2timestamp($time)
    {
        return intval(strtotime($time));
    }

    /**
     * 时间戳转字符串
     * @param  int $time
     */
    public static function timestamp2str($time)
    {
        return date("Y-m-d H:i:s", $time);
    }

    /**
     * 传入上次重置时间，返回当前是否需要重置
     *
     * @param $lastResetTimestamp 上次刷新时间
     * @return boolean 返回是否需要重置
     * @author Ray ray@raymix.net
     *
     */
    public static function isTimeNeedReset( /*int*/
        $lastResetTimestamp)
    {
        $h = 5; //每日重置 Hour
        $m = 0; //每日重置 Min
        $s = 0; //每日重置 Sec
        $ts = ($h * 3600 + $m * 60 + $s);
        return !SQLUtil::isSameDayByStamp(time() - $ts, $lastResetTimestamp - $ts);
    }

    /**
     * 获取上一次应该重置系统的时间戳
     *
     * @return int
     */
    public static function getLastRestTimeStamp()
    {
        $h = 5; //每日重置 Hour
        $m = 0; //每日重置 Min
        $s = 0; //每日重置 Sec

        $nowH = date("H");

        $resetTime = str_pad($h, 2, "0", STR_PAD_LEFT) . ":" . str_pad($m, 2, "0", STR_PAD_LEFT) . ":" . str_pad($s, 2, "0", STR_PAD_LEFT);
        $tTime = $nowH >= $h ? strtotime($resetTime) : strtotime("yesterday $resetTime");

        return $tTime;
    }

    /**
     * 获取距离下次游戏重置的间隔
     * @param $param
     */
    public static function getDiffNextGameReset()
    {
        $h = 5; //每日重置 Hour
        $m = 0; //每日重置 Min
        $s = 0; //每日重置 Sec

        $nowH = date("H");

        $resetTime = str_pad($h, 2, "0", STR_PAD_LEFT) . ":" . str_pad($m, 2, "0", STR_PAD_LEFT) . ":" . str_pad($s, 2, "0", STR_PAD_LEFT);
        $tTime = ($nowH >= $h) ? strtotime("tomorrow $resetTime") : strtotime($resetTime);

        return $tTime - time();
    }

    /**
     * 获取当前游戏时间的时间戳
     * 游戏时间是以每日5点为分割
     * @author Ray ray@raymix.net
     */
    public static function gameNow()
    {
        $h = 5; //每日重置 Hour
        $m = 0; //每日重置 Min
        $s = 0; //每日重置 Sec
        return time() - ($h * 3600 + $m * 60 + $s);
    }

    /**
     * 根据传入的时间点，返回当前所处的时间范围
     *
     * @param $refreshTimes 刷新时间
     * <p>
     * format : <br>
     *     String: "9:00:00"<br>
     *     array: array( 1=> "9:00:00",2=> "12:00:00", );<br>
     * </p>
     * @return array<p>
     *     array[0]: start timestamp<br>
     *     array[1]: end timestamp<br>
     * </p>
     * @author Ray ray@raymix.net
     *
     */
    public static function /*array*/
    getRefreshTimeRange( /*array or String*/
        $refreshTimes)
    {
        ksort($refreshTimes);
        $curTime = time();
        if (!is_array($refreshTimes)) {
            $refreshTimes = array(1 => $refreshTimes);
        }
        $imax = count($refreshTimes);
        $time_range = array();
        $t = explode(":", $refreshTimes[$imax]);
        array_push($time_range, mktime((int)$t[0], (int)$t[1], (int)$t[2], date('m'), date('d') - 1, date('Y')));
        for ($i = 1; $i <= $imax; $i++) {
            $t = explode(":", $refreshTimes[$i]);
            array_push($time_range, mktime((int)$t[0], (int)$t[1], (int)$t[2], date('m'), date('d'), date('Y')));
            if (($curTime > $time_range[$i - 1]) && ($curTime < $time_range[$i])) {
                return array($time_range[$i - 1], $time_range[$i]);
            }
        }
        $t = explode(":", $refreshTimes[1]);
        array_push($time_range, mktime((int)$t[0], (int)$t[1], (int)$t[2], date('m'), date('d') + 1, date('Y')));
        return array($time_range[$imax], $time_range[$imax + 1]);
    }

    public static function getArrayString($array)
    {
        $ret = "";
        $keys = array_keys($array);
        foreach ($keys as $key) {
            $ret .= $key . ":" . $array[$key] . ";";
        }
        return $ret;
    }

    public static function getArrayFromString($str)
    {
        $objects = explode(";", $str);
        $ret = array();
        foreach ($objects as $obj) {
            if (!empty($obj)) {
                $kv = explode(":", $obj);
                $k = array_shift($kv);
                $ret[$k] = $kv;
            }
        }
        return $ret;
    }

    static function getTodaySecond()
    {
        $todayStart = date("Y-m-d");
        $now = date("Y-m-d h:i:s");
        $todaySecond = strtotime($now) - strtotime($todayStart);
        return $todaySecond;
    }

    /**
     * 执行指定的SQL语句,返回结果集中的第一行第一列.
     *
     * @param $sql SQL语句 string
     * @return 返回结果集第一行第一列
     * @author Ray ray@raymix.net
     *
     */
    public static function sqlExecuteScalar($sql)
    {
        $qr = MySQL::getInstance()->RunQuery($sql);
        if (empty($qr)) {
            return -1;
        }
        $ar = MySQL::getInstance()->FetchAllRows($qr);

        if (empty($ar) || count($ar) == 0) {
            return -1;
        }
        return $ar[0][0];
    }

    /**
     * 执行指定的SQL语句,返回结果集Array.
     *
     * @param $sql SQL语句 string
     * @return 返回结果集Array
     * @author Ray ray@raymix.net
     *
     */
    public static function sqlExecuteArray($sql)
    {
        $result = array();
        $qr = MySQL::getInstance()->RunQuery($sql);
        if (empty($qr)) {
            return $result;
        }
        $ar = MySQL::getInstance()->FetchAllRows($qr);

        if (empty($ar) || count($ar) == 0) {
            return $result;
        }
        return $ar;
    }

    public static function getTimezoneOffset($remote_tz, $origin_tz = null)
    {
        $remote_dtz = new DateTimeZone($remote_tz);
        $remote_dt = new DateTime("now", $remote_dtz);
        if ($origin_tz == null) {
            return $remote_dtz->getOffset($remote_dt);
        } else {
            $origin_dtz = new DateTimeZone($origin_tz);
            $origin_dt = new DateTime("now", $origin_dtz);
            $offset = $origin_dtz->getOffset($origin_dt) - $remote_dtz->getOffset($remote_dt);
            return $offset;
        }
    }
}

?>
