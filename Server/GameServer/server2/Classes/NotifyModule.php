<?php
require_once($GLOBALS['GAME_ROOT'] . "DbModule/SysPlayerNotify.php");
require_once($GLOBALS['GAME_ROOT'] . "Classes/GuildModule.php");
require_once($GLOBALS['GAME_ROOT'] . "Classes/MailModule.php");

define("NOTIFY_USING_MEMCACHE_ONLY", 1);

define("NOTIFY_TYPE_LADDER", 1); //竞技场战斗
define("NOTIFY_TYPE_MAIL", 2); //邮件
define("NOTIFY_TYPE_GUILD_CHAT", 3); //工会聊天
define("NOTIFY_TYPE_ACTIVITY_NOTIFY", 4); //活动通知 activity_notify
define("NOTIFY_TYPE_ACTIVITY_REWARD", 5); //活动奖励activity_reward
define("NOTIFY_TYPE_RELEASE_HEROES", 6); //回到自由状态的英雄们 release_heroes
define("NOTIFY_TYPE_EXCAV_RECORD", 7); //守矿记录 excav_record

define("NOTIFY_MSG_MAX_AMOUNT", 1);

define("HERO_NOTIFY_MEMCACHKEY","HERO_NOTIFY_");
define('NOTIFY_MEMCACHE_EXPIRE_TIME', 86400*10);

class NotifyModule
{
	
	private static $localCache = array();
    public static function getNotifyTable($userId, $type)
    {
    	if ($type != NOTIFY_TYPE_LADDER && $type != NOTIFY_TYPE_MAIL && $type != NOTIFY_TYPE_GUILD_CHAT) {
    		return null;
    	}
    	
    	if(NOTIFY_USING_MEMCACHE_ONLY )
    	{
    		$key = HERO_NOTIFY_MEMCACHKEY. $type ."_".$userId;
    		if(isset(self::$localCache[$key]))
    		{
    			return self::$localCache[$key];
    		}
    		else
    		{
    			$data = CMemcache::getInstance()->getData($key);
    			
    			if($data===false)
    			{
    				$tbNotify = new SysPlayerNotify();
    				$tbNotify->setUserId($userId);
    				$tbNotify->setType($type);
    				$tbNotify->setAmount(0);
    				$tbNotify->inOrUp();
    				return $tbNotify;
    			}
    			else {
    				$ret = igbinary_unserialize($data);
    				self::$localCache[$key] = $ret;
    				return $ret;
    			}
    			
    		}
    		
    	}
    	else {
    		
    		$searchKey = "`user_id` = '{$userId}' and `type` = '{$type}'";
    		$tbNotify = SysPlayerNotify::loadedTable(null, $searchKey);
    		
    		if (count($tbNotify) <= 0) {
    			$tbNotify = new SysPlayerNotify();
    			$tbNotify->setUserId($userId);
    			$tbNotify->setType($type);
    			$tbNotify->setAmount(0);
    			$tbNotify->inOrUp();
    			return $tbNotify;
    		} else {
    			return $tbNotify[0];
    		}
    	}
       
    }

    public static function getNotifyAllTable($userId)
    {
    	if(NOTIFY_USING_MEMCACHE_ONLY )
    	{
    		$keys = array( 
    				HERO_NOTIFY_MEMCACHKEY. NOTIFY_TYPE_LADDER ."_".$userId,
    				HERO_NOTIFY_MEMCACHKEY. NOTIFY_TYPE_MAIL ."_".$userId,
    				HERO_NOTIFY_MEMCACHKEY. NOTIFY_TYPE_GUILD_CHAT ."_".$userId,
    				HERO_NOTIFY_MEMCACHKEY. NOTIFY_TYPE_ACTIVITY_NOTIFY ."_".$userId,
    				HERO_NOTIFY_MEMCACHKEY. NOTIFY_TYPE_ACTIVITY_REWARD ."_".$userId,
    				HERO_NOTIFY_MEMCACHKEY. NOTIFY_TYPE_RELEASE_HEROES ."_".$userId,
    				HERO_NOTIFY_MEMCACHKEY. NOTIFY_TYPE_EXCAV_RECORD ."_".$userId);
    		
    				
    		$needsQuery = array();
    		$results = array();
    		
    		foreach($keys as $key)
    		{
	    		if(isset(self::$localCache[$key]))
	    		{
	    			array_push($results,self::$localCache[$key]);
	    		}
	    		else
	    		{
	    			array_push($needsQuery, $key);
	    		}
    		}
    		if(count($needsQuery)>0)
    		{
    			$memdata = CMemcache::getInstance()->getDataArr($needsQuery);
    			foreach($memdata as $rawData)
    			{
    				if($rawData==false)
    					continue;
    				
    				$data = igbinary_unserialize($rawData);
    				array_push($results,$data);
    				$key = HERO_NOTIFY_MEMCACHKEY. $data->getType() ."_".$userId;
    				self::$localCache[$key] = $data;
    			}
    		}
    		
    		return $results;
    		
    	}
    	else {
    		$searchKey = "`user_id` = '{$userId}'";
    		$tbNotify = SysPlayerNotify::loadedTable(null, $searchKey);
    		return $tbNotify;
    	}
      
    }

    public static function getAllNotifyDownInfo($userId)
    {
        $downNotify = new Down_NotifyMsg();
        $notifyArr = self::getNotifyAllTable($userId);
        $hasNotify = false;
        foreach ($notifyArr as $tbNotify) {
            /* @var TbPlayerNotify $tbNotify */
            switch ($tbNotify->getType()) {
                case NOTIFY_TYPE_LADDER:
                    $downNotifyLadder = new Down_LadderNotify();
                    if ($tbNotify->getAmount() > 0) {
                        $downNotifyLadder->setIsAttacked(1);
                        $downNotify->setLadderNotify($downNotifyLadder);
                        $hasNotify = true;
                    }
                    break;
                case NOTIFY_TYPE_MAIL:
//                    if ($tbNotify->getAmount() > 0) {
//                        $downNotify->setNewMail($tbNotify->getAmount());
//                        $hasNotify = true;
//                    }

                    break;
                case NOTIFY_TYPE_GUILD_CHAT:
                    if ($tbNotify->getAmount() > 0) {
                        $downNotify->setGuildChat($tbNotify->getAmount());
                        $hasNotify = true;
                    }
                    break;
            }
        }

        $mailCount = MailModule::checkNewMail($userId);
        if($mailCount>0){
            $downNotify->setNewMail($mailCount);
            $hasNotify = true;
        }

        if ($hasNotify) {
            return $downNotify;
        } else {
            return null;
        }

    }


    
    public static function addGuildChatNotify($guildId,$type = NOTIFY_TYPE_GUILD_CHAT)
    {
    	
    	$userArr = GuildModule::getGuildAllUserId($guildId);
    	if(NOTIFY_USING_MEMCACHE_ONLY )
    	{
    		
    		
    		//先批量读取到本地变量的cache中。
    		//
    		$keys = array();

    		foreach($userArr as $userId){
    			$key = HERO_NOTIFY_MEMCACHKEY. $type ."_".$userId;
    			if(!isset(self::$localCache[$key]))
    			{
    				array_push($keys,$key);
    			}
    		}
    		
    		if(count($keys)>0)
    		{
	    		$mdataArr = CMemcache::getInstance()->getDataArr($keys);
	    		foreach ($mdataArr as $rawData)
	    		{
	    			if($rawData==false)
	    				continue;
	    			
	    			$data = igbinary_unserialize($rawData);
	    			
	    			$key = HERO_NOTIFY_MEMCACHKEY. $data->getType() ."_".$userId;
	    			//$results[$key] = $data;
	    			self::$localCache[$key] = $data;
	    		}
    		}
    		
    		
    		//这里再调用getNotifyTable可利用
    		$memdata = array();
    		foreach($userArr as $userId){
    			$tbNotify = self::getNotifyTable($userId, $type);
    			if (isset($tbNotify) && NOTIFY_MSG_MAX_AMOUNT >= $tbNotify->getAmount()) {
    				array_push($memdata,$tbNotify);
    			}
    		}
    		
    		CMemcache::getInstance()->setDataMulti($memdata,NOTIFY_MEMCACHE_EXPIRE_TIME);
    		
    	}
    	else
    	{
        
        
        
	        foreach($userArr as $userId){
	            self::addNotify($userId, $type);
	        }
    	}
        
        
    }
    public static function addNotify($userId, $type)
    {
    	if(NOTIFY_USING_MEMCACHE_ONLY )
    	{
    		$tbNotify = self::getNotifyTable($userId, $type);
    		if (isset($tbNotify) && NOTIFY_MSG_MAX_AMOUNT >= $tbNotify->getAmount()) {
    			$tbNotify->setAmount($tbNotify->getAmount() + 1);
    			$rawdata = igbinary_serialize($tbNotify);
    			$key = HERO_NOTIFY_MEMCACHKEY. $type ."_".$userId;
    			CMemcache::getInstance()->setData($key, $rawdata,NOTIFY_MEMCACHE_EXPIRE_TIME);
    				
    		}
    	}
    	else 
    	{
	        $tbNotify = self::getNotifyTable($userId, $type);
	        if (isset($tbNotify) && NOTIFY_MSG_MAX_AMOUNT >= $tbNotify->getAmount()) {
	            $tbNotify->setAmount($tbNotify->getAmount() + 1);
	            $tbNotify->save();
	        }
    	}
    }

    public static function clearNotify($userId, $type)
    {
    	if(NOTIFY_USING_MEMCACHE_ONLY )
    	{
    		$key = HERO_NOTIFY_MEMCACHKEY. $type ."_".$userId;
    		$tbNotify = self::getNotifyTable($userId, $type);
    		if (isset($tbNotify)) {
    			$tbNotify->setAmount(0);
    			$rawdata = igbinary_serialize($tbNotify);
    			CMemcache::getInstance()->setData($key, $rawdata,NOTIFY_MEMCACHE_EXPIRE_TIME);
    		}
    		
    	}
    	else
    	{
	        $tbNotify = self::getNotifyTable($userId, $type);
	        if (isset($tbNotify)) {
	            $tbNotify->setAmount(0);
	            $tbNotify->save();
	        }
    	}
    }
}
 