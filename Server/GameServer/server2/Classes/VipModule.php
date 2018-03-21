<?php

require_once($GLOBALS['GAME_ROOT'] . "DbModule/SysUser.php");
require_once($GLOBALS['GAME_ROOT'] . "DbModule/SysUserServer.php");
require_once($GLOBALS['GAME_ROOT'] . "DbModule/SysPlayerVip.php");
require_once($GLOBALS['GAME_ROOT'] . "DbModule/SysPlayerMail.php");
//@why 14.10.18 15:15
require_once($GLOBALS['GAME_ROOT'] . "DbModule/SysPayInfo.php");
require_once($GLOBALS['GAME_ROOT'] . "DbModule/SysPlayer.php");

require_once($GLOBALS['GAME_ROOT'] . "Classes/MathUtil.php");
require_once($GLOBALS['GAME_ROOT'] . "Classes/DataModule.php");;
require_once($GLOBALS['GAME_ROOT'] . "Classes/MonthCardModule.php");
require_once($GLOBALS['GAME_ROOT'] . "Classes/NewServerActivity.php");
require_once($GLOBALS['GAME_ROOT'] . "Classes/NotifyModule.php");
require_once($GLOBALS['GAME_ROOT'] . "Classes/DailyActivityModule.php");
require_once($GLOBALS['GAME_ROOT'] . "Classes/PlayerCacheModule.php");

class VipModule
{
    private static $VipTableCached = array();

    /** @var array vip模块定义信息 */
    private static $_VIPModuleLimit = array();

    /** @var array 对应vip等级充值奖励的比例值 */
    private static $_VIPRewardRateArr = array(
        0 => 0,
        1 => 5,
        2 => 7,
        3 => 10,
        4 => 15,
        5 => 20,
        6 => 30,
        7 => 40,
        8 => 50,
        9 => 60,
        10 => 70,
        11 => 80,
        12 => 90,
        13 => 100,
        14 => 110,
        15 => 120,
    );

    /**
     * 获取vip信息
     *
     * @param $userId
     * @return TbPlayerVip
     */
    public static function getVipTable($userId)
    {
        if (isset(self::$VipTableCached[$userId])) {
            return self::$VipTableCached[$userId];
        }

        $tbVip = new SysPlayerVip();
        $tbVip->setUserId($userId);
        if ($tbVip->loaded()) {

        } else {
            $tbVip = new SysPlayerVip();
            $tbVip->setUserId($userId);
            $tbVip->setVip(0);
            $tbVip->setRecharge(0);
            $tbVip->setRechargeLimit("");
            $tbVip->inOrUp();
        }

        self::$VipTableCached[$userId] = $tbVip;

        return $tbVip;
    }

    /**
     * 获取用户的vip等级
     *
     * @param $userId
     * @return mixed
     */
    public static function getVipLevel($userId)
    {
        $tbVip = self::getVipTable($userId);

        return $tbVip->getVip();
    }

    /**
     * 获取vip exp总值
     *
     * @param $userId
     * @return mixed
     */
    public static function getRechargeSum($userId)
    {
        $tbVip = self::getVipTable($userId);

        return $tbVip->getRecharge();
    }

    /**
     * 获取礼包购买次数限制
     *
     * @param $userId
     * @return array
     */
    public static function getRechargeLimitDownArr($userId)
    {
        $tbVip = self::getVipTable($userId);

        $limitArr = array();
        $rechargeStr = $tbVip->getRechargeLimit();
        $rechargeArr = explode("|", $rechargeStr);
        foreach ($rechargeArr as $rechargeInfo) {
            $oneRecharge = explode("-", $rechargeInfo);
            if (count($oneRecharge) == 2) {
                $isLimit = 0;
                if ($oneRecharge[1] > 0) {
                    $isLimit = 1;
                }
                $arg_arr = array(17, $isLimit, 16, $oneRecharge[0]);
                $limitArr[] = MathUtil::makeBits($arg_arr);
            }
        }

        return $limitArr;
    }

    /**
     * 根据礼包类型获取充值的礼包配置信息
     *
     * @param $transactionType
     */
    public static function getRechargePackageByType($transactionType)
    {
        $recharge = DataModule::getInstance()->getDataSetting(RECHARGE_LUA_KEY);
        if (isset($recharge[$transactionType])) {
            return $recharge[$transactionType];
        }

        return array();
    }

    /**
     * 为用户充值并更新对应的vip等级等数据
     *
     * @param int $userId
     * @param int $transactionType Recharge.lua中配置的充值数据
     * @return array
     */
    public static function updateUserPayMoneyAndVipLevel($userId, $transactionType, $orderId,$payPf,$OPForce = false)
    {
        $tbUserServer = new SysUserServer();
        $tbUserServer->setUserId($userId);
        if ($tbUserServer->loaded()) {
            $tbUser = PlayerCacheModule::getUserInfo($tbUserServer->getUin(), 1);
            if ($tbUser) {
                $timeZone = $tbUser->getUserZone();
                date_default_timezone_set($timeZone);
            }
        }

        $package = self::getRechargePackageByType($transactionType);
        if (empty($package)) {
            Logger::getLogger()->debug("updateUserPayMoneyAndVipLevel_error_package");
            return array('S' => false, "E" => "", 'error_str' => 'No package', 'error_code' => __LINE__);
        }

        $tbVip = self::getVipTable($userId);
        //检查购买限制,超过限制的不予发货 记录下信息
        if ($package['Limit'] == 1 && $OPForce == false) {
            $rechargeLimitArr = array();
            if (count($tbVip->getRechargeLimit()) > 0) {
                $payArr_ = explode("|", $tbVip->getRechargeLimit());
                foreach ($payArr_ as $rechargeInfo) {
                    $oneRechargeArr_ = explode("-", $rechargeInfo);
                    if (count($oneRechargeArr_) == 2) {
                        $rechargeLimitArr[$oneRechargeArr_[0]] = $oneRechargeArr_[1];
                    }
                }

                if (isset($rechargeLimitArr[$transactionType]) && $rechargeLimitArr[$transactionType] > 0) {
                    Logger::getLogger()->debug("updateUserPayMoneyAndVipLevel_limit");
                    return array('S' => false, "E" => "", 'error_str' => 'reach limit', 'error_code' => __LINE__);
                }
            }
        }

        $opStr = "";
        if ($OPForce == true) {
            $opStr = ".OP.";
        }
        $PlayerVip = new SysPlayerVip();
        $PlayerVip->setUserId($userId);
        $PlayerVip->loaded();
        Logger::getLogger()->debug("updateUserPayMoneyAndVipLevel_give_gems" . $opStr . __LINE__);

        //增加gems
        PlayerModule::modifyGem($userId, $package['Get Diamond'], "updateUserPayMoneyAndVipLevel" . $opStr);
        //增加getRechargeGem 【why 方便单独记录充值金钱】
        PlayerModule::modifyRechargeGem($userId, $package['Get Diamond'], "updateUserPayMoneyAndVipLevel" . $opStr);
        
        Logger::getLogger()->debug("updateUserPayMoneyAndVipLevel_updateVIP" . $opStr . __LINE__);
        //更新vip相关
        self::updateVIP($userId, $package);

        //Vip充值返利关闭 hgs@20141018
        //self::vipPayReward($tbVip, $package);

        // 每日充值活动
      //  self::DayPayReward($package['Cost'],$userId);
        
        //发送礼包奖励 邮件形式
        if (isset($package['Hero']) && $package['Hero'] > 0) {
            Logger::getLogger()->debug("updateUserPayMoneyAndVipLevel_giveHero" . __LINE__);
            //获取武将名称
            $heroDefineArr = DataModule::getInstance()->lookupDataTable(HERO_UNIT_LUA_KEY, $package['Hero']);
            $heroName = "";
            if (!empty($heroDefineArr)) {
                $heroName = $heroDefineArr['Display Name'];
            }

            $mail = new SysPlayerMail();
            $mail->setUserId($userId);
            $mail->setType(0);
            $curTime = time();
            $expireTime = $curTime + 3600 * 24 * 365;
            $mail->setMailTime($curTime);
            $mail->setExpireTime($expireTime);
            $mail->setTitle("You Hero Delivered!");
            $mail->setFrom("System");
            $mail->setContent("As a thanks gift for your purchasing of {$package['Cost']} package, you were given the hero {$heroName}. Claim and deploy the hero into your army now!");
            $mail->setItems($package['Hero'] . ":1;");
            $mail->setStatus(0);
            $mail->inOrUp();

//            NotifyModule::addNotify($userId, NOTIFY_TYPE_MAIL);
        }

        if ($tbVip->getFirstPayReward() == 0) {
            Logger::getLogger()->debug("updateUserPayMoneyAndVipLevel_giveFirstPay" . __LINE__);
            $state = NewServerActivity::firstPay($userId, $package);
            if ($state) {
                $tbVip->setFirstPayReward(1);
                $tbVip->save();
            }
        }

        DailyActivityModule::payActivityInstance($userId);

        DailyActivityModule::firstPayActivity($userId, $package);

        Logger::getLogger()->debug("updateUserPayMoneyAndVipLevel_finish" . __LINE__);
        
        
        $Player = new SysPlayer();
        $Player->setUserId($userId);
        $Player->loaded();
        $order_state = 0;
        
        $userListId=array(1);//测试充值
        $userListPuid=array("dt_ggl_ya_10034");//测试充值
        if(empty($payPf))
        {
        	$order_state= 1;
        }
       	else if(in_array($userId,$userListId))
        {
        	$order_state= 1;
        }
        else if(in_array($tbUser->getGameCenterId(),$userListPuid))
        {
        	$order_state= 1;
        }
        
        $PayInfo = new SysPayInfo();
        $PayInfo->setBuyerId($userId);
        $PayInfo->setOrderId($orderId);
        $PayInfo->setOrderState($order_state);
        $PayInfo->setTransactionId($transactionType);
        $PayInfo->setPayMoney($package['Cost']);
        $PayInfo->setOrderMoney($package['Cost']);
        $PayInfo->setServerUniqueFlag($tbUserServer->getServerId());
        $PayInfo->setGoldNum($package['Get Diamond']);
        $PayInfo->setOrderDate(date("Y-m-d H:i:s"));
        $PayInfo->setPayDate(date("Y-m-d H:i:s"));
        $PayInfo->setPaypalDate(date("Y-m-d H:i:s"));
        $PayInfo->setCheckDate(date("Y-m-d H:i:s"));
        $PayInfo->setPaypalFee($package['Cost']);
        $PayInfo->setPaypalPaykey($payPf); //平台
        $PayInfo->setOrderTime(time());
        $PayInfo->setPayTime(time());
        $PayInfo->setGmaeCenterId($tbUser->getGameCenterId());
        $PayInfo->setLevel($Player->getLevel());
        $PayInfo->setVipLevel($PlayerVip->getVip());
        $is_first = 1;
        if($PlayerVip->getVip()>0)
        {
        	$is_first = 0;
        }
        $PayInfo->setIsFirst($is_first);
        $PayInfo->setDeviceId($tbUser->getModel());
        
        $PayInfo->inOrUp();

        
        
       
        Logger::getLogger()->debug($userId.$transactionType.$orderId.$package['Cost']."updateUserPayMoneyAndVipLevel_finish_OK" . __LINE__);
        return array("S" => true, "E" => "", 'error_str' => '', 'error_code' => 0);
    }

    /**
     * 更新用户的vip等级
     *
     * @param $userId
     * @param array $package 充值礼包
     */
    public static function updateVIP($userId, $package)
    {
        if (isset($package['Type']) && $package['Type'] == "MonthlyCard") {
            MonthCardModule::updateMonthCard($userId, $package['ID']);
        }

        if (isset($package['VIP Exp'])) {
            $addCharge = $package['VIP Exp'];
            $tbVip = self::getVipTable($userId);
            $newCharge = $tbVip->getRecharge() + $addCharge;
            $newVip = 0;

            $vipModule = self::getVIPModuleDefine();

            foreach ($vipModule as $vip_ => $limitArr_) {
                if ($newCharge < $limitArr_[_VIP_MODULE_TYPE::RECHARGE]) {
                    continue;
                }

                if ($vip_ > $newVip) {
                    $newVip = $vip_;
                }
            }

            $rechargeLimitArr = array();
            if (count($tbVip->getRechargeLimit()) > 0) {
                $payArr_ = explode("|", $tbVip->getRechargeLimit());
                foreach ($payArr_ as $rechargeInfo) {
                    $oneRechargeArr_ = explode("-", $rechargeInfo);
                    if (count($oneRechargeArr_) == 2) {
                        $rechargeLimitArr[$oneRechargeArr_[0]] = $oneRechargeArr_[1];
                    }
                }
            }

            if (isset($rechargeLimitArr[$package['ID']])) {
                $rechargeLimitArr[$package['ID']] += 1;
            } else {
                $rechargeLimitArr[$package['ID']] = 1;
            }

            if (count($rechargeLimitArr) > 0) {
                $limitTbArr = array();
                foreach ($rechargeLimitArr as $kk => $num) {
                    $limitTbArr[] = $kk . "-" . $num;
                }

                $tbVip->setRechargeLimit(implode("|", $limitTbArr));
            }

            $tbVip->setVip($newVip);
            $tbVip->setRecharge($newCharge);
            $tbVip->inOrUp();
        }
    }

    /**
     * 对于vip用户给予赠送一定额度的gems
     *
     * 采用邮件方式发送
     *
     * @param TbPlayerVip $tbVip
     * @param $package
     */
    private static function vipPayReward($tbVip, $package)
    {
        $rate = 0;
        if (isset(self::$_VIPRewardRateArr[$tbVip->getVip()])) {
            $rate = self::$_VIPRewardRateArr[$tbVip->getVip()];
        }

        if ($rate > 0) {
            $giveGems = ceil($package['VIP Exp'] * $rate / 100);
            if($giveGems > 0){
                $mail = new SysPlayerMail();
                $mail->setUserId($tbVip->getUserId());
                $mail->setType(0);
                $curTime = time();
                $expireTime = $curTime + 3600 * 24 * 365;
                $mail->setMailTime($curTime);
                $mail->setExpireTime($expireTime);
                $mail->setDiamonds($giveGems);
                $mail->setTitle("VIP Bonus for Purchasing Gems");
                $mail->setFrom("Ember");
                $vipLevel = $tbVip->getVip();
                $content = <<<EOT
My Leader,

To thank you for supporting Heroes Charge, I've given you bonus gems in your purchase! Your current VIP level is {$vipLevel}, and that gives you an extra {$rate}% gems every time you buy! Good luck hunting!

Best Regards
EOT;

                $mail->setContent($content);
                //$mail->setTemplate(4);
                $mail->setStatus(0);
                $mail->inOrUp();
            }
        }

    }
    
    

    /**
     * 每日充值活动。
     *
     * 采用邮件方式发送
     *
     * @param  $money
     * 
     */
    private static function DayPayReward($money,$userId)
    {
    	$date= date("Ymd");
    	$ContinueRecharge = DataModule::lookupDataTable(ACTIVITY_INFO_CONFIG_LUA_KEY, "ContinueRecharge");
    	
    	$activityConfig= DataModule::lookupDataTable(ACTIVITY_CONFIG_LUA_KEY, "OpenServerActivity");
    	
    	
    	
    	foreach ($ContinueRecharge[$date] as $key=>$val)
    	{
    		switch ($val['type'])
    		{
    			case 'Singlepen':  //需要判断 是否满足充值金额条件 活动是否在开放时间内 是否领取过奖励
    				$sql = "select * from continu_pay where user_id = ".$userId." and date=".$date;
    				$rs = MySQL::getInstance()->RunQuery($sql);
    				$ar = MySQL::getInstance()->FetchArray($rs);
    				if($money >= $val['limit']['pay money'] && !$ar)
    				{
    					$mail = new SysPlayerMail();
    					$mail->setUserId($userId);
    					$mail->setType(0);
    					$curTime = time();
    					$expireTime = $curTime + 3600 * 24 * 365;
    					$mail->setMailTime($curTime);
    					$mail->setExpireTime($expireTime);
    					$mail->setTitle($val['mail']['title']);
    					$mail->setFrom("System");
    					$mail->setContent($val['mail']['content']);
    					$mail->setMoney($val['reward']['money']);
    					$mail->setDiamonds($val['reward']['gem']);
    					$itemStr='';
    					foreach ($val['reward']['items'] as $k => $v) {
    						$itemStr .= "{$k}:{$v};";
    					}
    					$mail->setItems($itemStr);
    					$mail->setStatus(0);
    					$mail->inOrUp();
    					$insertSql = "insert into continu_pay(`user_id`,`date`,`version`)values('{$userId}','{$date}','{$activityConfig[2]['start_time']}')";
    					MySQL::getInstance()->RunQuery($insertSql);
    				}
    				break;
    			case 'CumulativeDaily':
                                $strTime = strtotime($date);
                                $payInfo = SysPayInfo::loadedTable("pay_money", " buyer_id = '{$userId}' and  order_time > '{$strTime}'");
                                $sql = "select * from continu_pay where user_id = ".$userId." and date=".$date;
                                $rs = MySQL::getInstance()->RunQuery($sql);
                                $ar = MySQL::getInstance()->FetchArray($rs);
                                if(!$ar)
                                {
                                        $payCount = 0;
                                        foreach ($payInfo as $v)
                                        {
                                                $payCount+=$v->getPayMoney();
                                        }
                                        $zNum = $payCount +$money;

                                        if($zNum >=$val['limit']['pay money'])
                                        {

                                                $mail = new SysPlayerMail();
                                                $mail->setUserId($userId);
                                                $mail->setType(0);
                                                $curTime = time();
                                                $expireTime = $curTime + 3600 * 24 * 365;
                                                $mail->setMailTime($curTime);
                                                $mail->setExpireTime($expireTime);
                                                $mail->setTitle($val['mail']['title']);
                                                $mail->setFrom("System");
                                                $mail->setContent($val['mail']['content']);
                                                $mail->setMoney($val['reward']['money']);
                                                $mail->setDiamonds($val['reward']['gem']);
                                                $itemStr='';
                                                foreach ($val['reward']['items'] as $k => $v) {
                                                        $itemStr .= "{$k}:{$v};";
                                                }
                                                $mail->setItems($itemStr);
                                                $mail->setStatus(0);
                                                $mail->inOrUp();
                                                $insertSql = "insert into continu_pay(`user_id`,`date`,`version`)values('{$userId}','{$date}','{$activityConfig[2]['start_time']}')";
                                                MySQL::getInstance()->RunQuery($insertSql);

                                        }
                                }
                                break;
	    			default:
	    			break;
    				
	    		}
	    	}

    
    }

    /**
     * 获取vip模块定义
     */
    private static function getVIPModuleDefine()
    {
        if (empty(self::$_VIPModuleLimit)) {
            self::$_VIPModuleLimit = DataModule::getInstance()->getDataSetting(VIP_LUA_KEY);
        }

        return self::$_VIPModuleLimit;
    }

    /**
     * 根据vip等级获取vip模块状态
     *
     * @param $vip
     * @param $module
     * @return int
     */
    public static function getVIPModuleLimitByVipLevel($vip, $module)
    {
        $vipModule = self::getVIPModuleDefine();

        if (isset($vipModule[$vip]) && isset($vipModule[$vip][$module])) {
            return $vipModule[$vip][$module];
        }

        return 0;
    }

    /**
     * 获取用户的vip模块状态
     *
     * @param $userId
     * @param $module
     * @return int
     */
    public static function getVIPModuleLimitByUserId($userId, $module)
    {
        $tbVip = self::getVipTable($userId);

        return self::getVIPModuleLimitByVipLevel($tbVip->getVip(), $module);
    }

}

/**
 * vip功能定义
 *
 * Interface _VIP_MODULE_TYPE
 */
interface _VIP_MODULE_TYPE
{
    /** 技能点上限 ok */
    const MAX_SKILL_POINTS = "Max Skill Points";

    /** 购买技能强化点数 ok */
    const SKILL_UPGRADE_CD_RESET = "Skill Upgrade CD Reset";

    /** 点金手 ok */
    const MIDAS = "Midas";

    /** 免费领取扫荡券xx张 ,这个配置在任务中,此数据暂时无用,仅作客户端显示 ok */
    const FREE_RAID = "Free Raid";

    /** 使用钻石扫荡关卡 ok */
    const RAID_WITH_DIAMOND = "Raid With Diamond";

    /** 扫荡关卡,一键扫十次功能 ok */
    const RAID_TEN_FUNCTION = "Raid Ten Function";

    /** 一次扫荡功能是否开启  ok */
    const RAID_ONE_FUNCTION = "Raid One Function";

    /** 召唤神秘魂匣宝箱 ok */
    const MAGIC_SOUL_BOX = "Magic Soul Box";

    /** 藏宝地穴中最多占领的宝藏数量 */
    const EXCAVATE_TREASURE_AMOUNT = "Excavate Treasure Amount";

    /** 立即重置竞技场CD功能 ok */
    const PVP_CD_RESET = "PVP CD Reset";

    /** 每天可购买竞技场门票次数 ok */
    const PVP_BUY = "PVP Buy";

    /** 需要充值多少钻石可以达到对应vip等级 ok */
    const RECHARGE = "Recharge";

    /** 公会的膜拜次数 ok */
    const WORSHIP_TIMES = "Worship Times";

    /** 公会的花钱膜拜 ok */
    const DIAMOND_WORSHIP = "Diamond Worship";

    /** 公会雇佣兵营地同时派出的英雄数量 ok */
    const GUILD_HERO_DISPATCH_LIMIT = "Guild Hero Dispatch Limit";

    /** 每天可进行燃烧的远征次数 */
    const CRUSADE_FREE_CHANCE = "Crusade Free Chance";

    /** 燃烧的远征宝箱战利品增加是否开启 */
    const CRUSADE_CHEST_BONUS_VALID = "Crusade Chest Bonus Valid";

    /** 燃烧的远征宝箱战利品增加xx% */
    const CRUSADE_MONEY_BONUS = "Crusade Money Bonus";

    /** 一键装备附魔 ok */
    const ITEM_ONE_CLICK_UPGRADE = "Item One-Click-Upgrade";

    /** 重置精英关卡次数 ok */
    const ELITE_RESET = "Elite Reset";

    /** 每天购买体力次数 ok */
    const BUY_VIT_MAX = "Buy Vit Max";

    /** 永久召唤地精商人 ok */
    const SUMMON_SPECIAL_SHOP = "Summon Special Shop";

    /** 永久召唤黑市老大 ok */
    const SUMMON_SO_SPECIAL_SHOP = "Summon So Special Shop";
}