<?php

/**
 * 网站访问游戏数据接口
 */
$this_file_path = realpath(dirname(__FILE__) . "/../") . '/';
require_once($this_file_path . "CMySQL.php");
require_once($GLOBALS['GAME_ROOT'] . "Log/Logger.php");
require_once($GLOBALS['GAME_ROOT'] . "Log/LogClient.php");
require_once($GLOBALS['GAME_ROOT'] . "Log/LogAction.php");
require_once($GLOBALS['GAME_ROOT'] . "Classes/VipModule.php");
//add why
require_once($GLOBALS['GAME_ROOT'] . "Classes/PlayerModule.php");
class SiteInterface
{

    /** @var array */
    protected static $arr_user_id;

    /** md5 key, only used for php, don't public for flash */
    const MD5_PHP_KEY = '{djl*ei84}-{JD&IE$*@#}-{dk#ld83*#}-{j398Fd*&#}';

    /** @var array */
    protected static $arr_sql_query;

    /** @var bool */
    public $debug = false;

    /** @var array 初始化的子类对象数组 */
    protected static $classArr = array();


    public function __construct()
    {
        //初始化各服务器的时区

    }


    /**
     * 增加以及查询过的url,用于debug输出
     * @param $p_sql
     * @return bool
     */
    public function logSql($p_sql)
    {
        if (!empty($p_sql)) {
            if ($this->debug) {
                echo $p_sql . "<br />";
            }
            $i = count(self::$arr_sql_query);
            self::$arr_sql_query[$i]['time'] = microtime(true);
            self::$arr_sql_query[$i]['sql'] = $p_sql;
            return true;
        }
        return false;
    }

    protected function addObject($oElement)
    {
        self::$classArr[] = $oElement;
    }

    /**
     * 为用户充值和更新对应的vip等级等
     *
     * @param $userId
     * @param int $transactionType 充值的类型
     */
    public function updateUserPayMoneyAndVipLevel($userId, $transactionType, $orderId,$payPf,$OPForce = false)
    {
        return VipModule::updateUserPayMoneyAndVipLevel($userId, $transactionType, $orderId,$payPf,$OPForce);
    }
    
    //add why
    /**
     * 查询用户信息
     *  
     * @param $userId
     * @param 
     */
    public function GmSelectUser($userId)
    {
    	$vipLevel = VipModule::getVipLevel($userId);
    	$getPlayer = PlayerModule::getPlayerInfo($userId);
	    $getPlayer['vip'] = $vipLevel;
    	return $getPlayer;
    }
    

 /**
     * 通过nickname查询userid
     *
     * @param $nickname
     * @param
     */
    public function GmUserName($nickname,$serverid)
    {
    	$getPlayer = PlayerModule::getUserInfo($nickname,$serverid,'nickname');
    	return $getPlayer;
    }
    
    
    
    /**
     * 通过puid查询userid
     *
     * @param $puid
     * @param
     */
    public function GmUserPuid($puid,$serverid)
    {
    	
    	$getPlayer = PlayerModule::getUserInfo($puid,$serverid,'puid');
    	return $getPlayer;
    }
    

    /**
     * 增加用户钻石
     *
     * @param $userId
     * @param
     */
    public function modifyGem($userId,$gem)
    {
    	return PlayerModule::modifyGem($userId,$gem);
    }
    
    /**
     * 增加用户金币
     *
     * @param $userId
     * @param
     */
    public function modifyMoney($userId,$money)
    {
    	return PlayerModule::modifyMoney($userId,$money);
    }
    
	    /**
     * 增加用户邮件
     * 
     *
     * @param $userId
     * @param
     */
        public function GmSetMail($userId, $title,$sender,$content,$expireTime,$gem,$money,$items,$serverid,$type)
    {
    	return PlayerModule::GmSetMail($userId,$title,$sender,$content,$expireTime,$gem,$money,$items,$serverid,$type);
    }
    
    /**
     * 增加用户经验
     *
     *
     * @param $userId
     * @param
     */
    public function modifyPlyExp($userId, $exp)
    {
    	return PlayerModule::modifyPlyExp($userId,$exp);
    }
    
    /**
     * 增加用户等级
     *
     *
     * @param $userId
     * @param
     */
    public function modifyPlyLevel($userId,$level)
    {
    	return PlayerModule::modifyPlyLevel($userId,$level);
    }

   /**
     * 增加竞技场点数
     *
     *
     * @param $userId
     * @param
     */
    public function modifyPlyArenaPoint($userId,$level)
    {
    	return PlayerModule::modifyPlyArenaPoint($userId,$level);
    }
    
    
    /**
     * 增加远征点数
     *
     *
     * @param $userId
     * @param
     */
    public function modifyPlyCrusadePoint($userId,$level)
    {
    	return PlayerModule::modifyPlyCrusadePoint($userId,$level);
    }
    
    
    /**
     * 增加用户公会点数
     *
     *
     * @param $userId
     * @param
     */
    public function modifyPlyGuildPoint($userId,$level)
    {
    	return PlayerModule::modifyPlyGuildPoint($userId,$level);
    }
    
    
    //end
    
    /**
     * 访问子方法
     * 采用可扩展的方法
     * @param $name
     * @param $params
     * @return mixed
     * @throws Exception
     */
    public function __call($name, $params)
    {
        //初次访问
        if (count(self::$classArr) == 0) {
            //把子类压入,不采用遍历目录方式,遍历可能会造成效率低下
            //$this->addObject(new NotifyInterface($this));
            //$this->addObject(new PayInterface($this));
            //$this->addObject(new PlayerDataInterface($this));
            //$this->addObject(new DigiInterface($this));
        }

        foreach (self::$classArr as $oElement) {
            if (method_exists($oElement, $name)) {
                return call_user_func_array(array(&$oElement, $name), $params);
            }
            /*$strClass = get_class($oElement);
            $arrMethods = get_class_methods($strClass);

            if (in_array($name, $arrMethods)) {
                $arrCaller = Array($strClass, $name);
                return call_user_func_array($arrCaller, $params);
            }*/
        }

        throw new Exception(" Method " . $name . " not exist in this class " . get_class($this) . ".");
    }

    public function __destruct()
    {
        if (!empty(self::$arr_sql_query)) {
            $log_str = '';
            foreach (self::$arr_sql_query as $i => $v) {
                $log_str .= "{$i} Time:{$v['time']} Sql: {$v['sql']}\r\n";
            }
            //Logger::getLogger()->debug("Sql: \r\n" . $log_str);
            if ($this->debug) {
                echo "<pre>{$log_str}</pre>";
            }
        }
    }

}
