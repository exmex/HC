<?php
require_once ($GLOBALS ['GAME_ROOT'] . "CMySQL.php");
require_once ("SQLUtil.php");
/**
 *  [The generated files]
 */

class SysPlayer {
	
	private /*string*/ $user_id; //PRIMARY KEY 
	private /*int*/ $server_id;
	private /*string*/ $nickname;
	private /*int*/ $last_set_name_time;
	private /*int*/ $avatar;
	private /*int*/ $level;
	private /*string*/ $exp;
	private /*string*/ $money;
	private /*string*/ $gem;
	private /*int*/ $arena_point;
	private /*int*/ $crusade_point;
	private /*int*/ $guild_point;
	private /*int*/ $last_midas_time;
	private /*int*/ $today_midas_times;
	private /*int*/ $total_online_time;
	private /*int*/ $tutorialstep;
	private /*string*/ $rechargegem;
	private /*int*/ $facebook_follow;
	private /*string*/ $wood;
	private /*string*/ $iron;

	
	private $this_table_status_field = false;
	private $user_id_status_field = false;
	private $server_id_status_field = false;
	private $nickname_status_field = false;
	private $last_set_name_time_status_field = false;
	private $avatar_status_field = false;
	private $level_status_field = false;
	private $exp_status_field = false;
	private $money_status_field = false;
	private $gem_status_field = false;
	private $arena_point_status_field = false;
	private $crusade_point_status_field = false;
	private $guild_point_status_field = false;
	private $last_midas_time_status_field = false;
	private $today_midas_times_status_field = false;
	private $total_online_time_status_field = false;
	private $tutorialstep_status_field = false;
	private $rechargegem_status_field = false;
	private $facebook_follow_status_field = false;
	private $wood_status_field = false;
	private $iron_status_field = false;

	
	private static $KEY_FORMAT = "player_%s";
	private static $users_cache = array();
	private $load_from_cache = false;
	
	
	public static function clearUserCache($userId)
	{
		if(!defined('ENABLE_DB_CACHE') || ENABLE_DB_CACHE==FALSE){
			return ;
		}
		$key = sprintf(self::$KEY_FORMAT,$userId);;
		CMemcache::getInstance()->deleteData($key);
	}
	
	/**
	 * @param String $userId
	 * @return array(SysPlayer)
	 */
	private static function loadedRecordsFromCache($userId)
	{
		if(!defined('ENABLE_DB_CACHE') || ENABLE_DB_CACHE==FALSE){
			return false;
		}
		
		if(isset(self::$users_cache[$userId])){
			return self::$users_cache[$userId];
		}
		$key = sprintf(self::$KEY_FORMAT,$userId);;
		$data = CMemcache::getInstance()->getData($key);
		if(!empty($data)){
			self::$users_cache[$userId] = $data;
			return $data;
		}
	
		return false;
	}
	
	/**
	 * @param String $userId
	 * @param array(SysPlayer) $data
	 * @return boolean
	 */
	private static function saveRecordsToCache($userId,$data)
	{
		if(!defined('ENABLE_DB_CACHE') || ENABLE_DB_CACHE==FALSE){
			return false;
		}
		
		$newData = array();
		foreach($data as $tb){
			$newData[$tb->user_id] = $tb;
		}
	
		self::$users_cache[$userId] = $newData;
	
		$key = sprintf(self::$KEY_FORMAT,$userId);;
		$ret = CMemcache::getInstance()->setData($key,$newData,60*60);
	
		return $ret;
	}
	
	/**
	 * @param String $userId
	 * @param array(SysPlayer) $data
	 * @return boolean
	 */
	private static function addRecordsToCache($userId,$data)
	{
		if(!defined('ENABLE_DB_CACHE') || ENABLE_DB_CACHE==FALSE){
			return false;
		}
		
		$cacheData = self::loadedRecordsFromCache($userId);
		if(empty($cacheData)){
			return self::saveRecordsToCache($userId, $data);
		}
	
		foreach($data as $tb){
			$cacheData[$tb->user_id] = $tb;
		}
	
		self::$users_cache[$userId] = $cacheData;
	
		$key = sprintf(self::$KEY_FORMAT,$userId);;
		$ret = CMemcache::getInstance()->setData($key,$cacheData,60*60);
	
		return $ret;
	}
	
	/**
	 * @param String $userId
	 * @param $key PRIMARY KEY
	 */
	private static function deleteTableFromCache($userId,$key)
	{
		if(!defined('ENABLE_DB_CACHE') || ENABLE_DB_CACHE==FALSE){
			return;
		}
		
		$allRecords = self::loadedRecordsFromCache($userId);
		if(empty($allRecords)){
			return;
		}
		if(isset($allRecords[$key])){
			unset($allRecords[$key]);
			$key = sprintf(self::$KEY_FORMAT,$userId);;
			CMemcache::getInstance()->setData($key,$allRecords,60*60);
		}
	}
	
	/**
	 * @param String $userId
	 * @param $key PRIMARY KEY
	 */
	private static function loadedTableFromCacheByKey($userId,$key)
	{
		if(!defined('ENABLE_DB_CACHE') || ENABLE_DB_CACHE==FALSE){
			return false;
		}
		
		$allRecords = self::loadedRecordsFromCache($userId);
		if(empty($allRecords)){
			return false;
		}
	
		if(isset($allRecords[$key])){
			$rc =  $allRecords[$key];
			if(!empty($rc)){
				$rc->load_from_cache = true;
				return $rc;
			}
		}
	
		return false;
	}
	
	
	private static function loadedTableFromCache($condition)
	{
		if(!defined('ENABLE_DB_CACHE') || ENABLE_DB_CACHE==FALSE){
			return false;
		}
		
		if(empty($condition) || !is_array($condition)){
			return false;
		}
	
		if(!isset($condition['user_id'])){
			return false;
		}
	
		$userId = $condition['user_id'];
		$allRecords = self::loadedRecordsFromCache($userId);
		if(empty($allRecords)){
			return false;
		}
	
		$result = array();
		foreach($allRecords as $key=>$record){
			if(isset($condition['user_id']) && strval($condition['user_id']) != $record->user_id) continue;
			if(isset($condition['server_id']) && intval($condition['server_id']) != $record->server_id) continue;
			if(isset($condition['nickname']) && strval($condition['nickname']) != $record->nickname) continue;
			if(isset($condition['last_set_name_time']) && intval($condition['last_set_name_time']) != $record->last_set_name_time) continue;
			if(isset($condition['avatar']) && intval($condition['avatar']) != $record->avatar) continue;
			if(isset($condition['level']) && intval($condition['level']) != $record->level) continue;
			if(isset($condition['exp']) && strval($condition['exp']) != $record->exp) continue;
			if(isset($condition['money']) && strval($condition['money']) != $record->money) continue;
			if(isset($condition['gem']) && strval($condition['gem']) != $record->gem) continue;
			if(isset($condition['arena_point']) && intval($condition['arena_point']) != $record->arena_point) continue;
			if(isset($condition['crusade_point']) && intval($condition['crusade_point']) != $record->crusade_point) continue;
			if(isset($condition['guild_point']) && intval($condition['guild_point']) != $record->guild_point) continue;
			if(isset($condition['last_midas_time']) && intval($condition['last_midas_time']) != $record->last_midas_time) continue;
			if(isset($condition['today_midas_times']) && intval($condition['today_midas_times']) != $record->today_midas_times) continue;
			if(isset($condition['total_online_time']) && intval($condition['total_online_time']) != $record->total_online_time) continue;
			if(isset($condition['tutorialstep']) && intval($condition['tutorialstep']) != $record->tutorialstep) continue;
			if(isset($condition['rechargegem']) && strval($condition['rechargegem']) != $record->rechargegem) continue;
			if(isset($condition['facebook_follow']) && intval($condition['facebook_follow']) != $record->facebook_follow) continue;
			if(isset($condition['wood']) && strval($condition['wood']) != $record->wood) continue;
			if(isset($condition['iron']) && strval($condition['iron']) != $record->iron) continue;

			$record->load_from_cache = true;
			$result[] = $record;
		}
	
		return $result;
	}

	/**
	 * @example loadedTable(array('user_id'),array("user_id"=>"123"))
	 * @param array($condition)
	 * @return array(SysPlayer)
	 */
	public static function /*array(SysPlayer)*/ loadedTable(/*array*/ $fields=NULL,/*array*/$condition=NULL)
	{
		$result = array();
		
		$p = "*";
		
		if(!empty($fields))
		{
			$p = SQLUtil::parseFields($fields);			
		}
		
		if (empty($condition))
		{
			$sql = "SELECT {$f} FROM `player`";
		}
		else
		{			
	 		$ret = self::loadedTableFromCache($condition);
			if(is_array($ret) && count($ret) > 0){
				return $ret;
			}
			$sql = "SELECT {$p} FROM `player` WHERE ".SQLUtil::parseCondition($condition);
		}			
		
		$qr = MySQL::getInstance()->RunQuery($sql);
		if(empty($qr)){
			return $result;
		}
		$ar = MySQL::getInstance()->FetchAllRows($qr);
		
		if (empty($ar) || count($ar) == 0)
		{
			return $result;
		}
		
		foreach($ar as $row)
		{
			$tb = new SysPlayer();			
			if (isset($row['user_id'])) $tb->user_id = $row['user_id'];
			if (isset($row['server_id'])) $tb->server_id = intval($row['server_id']);
			if (isset($row['nickname'])) $tb->nickname = $row['nickname'];
			if (isset($row['last_set_name_time'])) $tb->last_set_name_time = intval($row['last_set_name_time']);
			if (isset($row['avatar'])) $tb->avatar = intval($row['avatar']);
			if (isset($row['level'])) $tb->level = intval($row['level']);
			if (isset($row['exp'])) $tb->exp = $row['exp'];
			if (isset($row['money'])) $tb->money = $row['money'];
			if (isset($row['gem'])) $tb->gem = $row['gem'];
			if (isset($row['arena_point'])) $tb->arena_point = intval($row['arena_point']);
			if (isset($row['crusade_point'])) $tb->crusade_point = intval($row['crusade_point']);
			if (isset($row['guild_point'])) $tb->guild_point = intval($row['guild_point']);
			if (isset($row['last_midas_time'])) $tb->last_midas_time = intval($row['last_midas_time']);
			if (isset($row['today_midas_times'])) $tb->today_midas_times = intval($row['today_midas_times']);
			if (isset($row['total_online_time'])) $tb->total_online_time = intval($row['total_online_time']);
			if (isset($row['tutorialstep'])) $tb->tutorialstep = intval($row['tutorialstep']);
			if (isset($row['rechargegem'])) $tb->rechargegem = $row['rechargegem'];
			if (isset($row['facebook_follow'])) $tb->facebook_follow = intval($row['facebook_follow']);
			if (isset($row['wood'])) $tb->wood = $row['wood'];
			if (isset($row['iron'])) $tb->iron = $row['iron'];
		
			$result[] = $tb;
		}
	 		
	 	if(is_array($condition) && isset($condition['user_id'])){
			if(count($condition) == 1){
				self::saveRecordsToCache($condition['user_id'], $result);
			}else{
				self::addRecordsToCache($condition['user_id'], $result);
			}
		}
		
		return $result;
	}	
	
	public static function insertSqlHeader(/*array*/ $fields=NULL)
	{
		$result = array();				
		if(!empty($fields)){
			$f = SQLUtil::parseFields($fields);			
			$result[0] = "INSERT INTO `player` ({$f}) VALUES ";	
			$ar = array();
			foreach($fields as $key){
				$ar[$key]=1;
			}
			$result[1] = $ar;
		}else{
			$result[0]="INSERT INTO `player` (`user_id`,`server_id`,`nickname`,`last_set_name_time`,`avatar`,`level`,`exp`,`money`,`gem`,`arena_point`,`crusade_point`,`guild_point`,`last_midas_time`,`today_midas_times`,`total_online_time`,`tutorialstep`,`rechargegem`,`facebook_follow`,`wood`,`iron`) VALUES ";
			$result[1] = array('user_id'=>1,'server_id'=>1,'nickname'=>1,'last_set_name_time'=>1,'avatar'=>1,'level'=>1,'exp'=>1,'money'=>1,'gem'=>1,'arena_point'=>1,'crusade_point'=>1,'guild_point'=>1,'last_midas_time'=>1,'today_midas_times'=>1,'total_online_time'=>1,'tutorialstep'=>1,'rechargegem'=>1,'facebook_follow'=>1,'wood'=>1,'iron'=>1);
		}				
		return $result;
	}
		
	public function /*boolean*/ loaded(/*array*/ $fields=NULL,/*array*/$condition=NULL)
	{
		//ERROR:no condition
		if (empty($condition) && empty($this->user_id))
		{
			return false;
		}
						
		//load from cache first
		$cacheTb = null;
		if(!empty($condition)){
			$tbs = self::loadedTableFromCache($condition);
			if(!empty($tbs) && is_array($tbs)){
				$cacheTb = $tbs[0];
			}
		}else{
			$uid = 0;
			if(isset($this->user_id)){
				$uid = $this->user_id;
			}else if(isset($GLOBALS['USER_ID'])){
				$uid = $GLOBALS['USER_ID'];
			}
			if(!empty($uid)){
				$cacheTb = self::loadedTableFromCacheByKey($uid, $this->user_id);
			}
		}
		if(!empty($cacheTb)){
			$this->user_id = $cacheTb->user_id;
			$this->server_id = $cacheTb->server_id;
			$this->nickname = $cacheTb->nickname;
			$this->last_set_name_time = $cacheTb->last_set_name_time;
			$this->avatar = $cacheTb->avatar;
			$this->level = $cacheTb->level;
			$this->exp = $cacheTb->exp;
			$this->money = $cacheTb->money;
			$this->gem = $cacheTb->gem;
			$this->arena_point = $cacheTb->arena_point;
			$this->crusade_point = $cacheTb->crusade_point;
			$this->guild_point = $cacheTb->guild_point;
			$this->last_midas_time = $cacheTb->last_midas_time;
			$this->today_midas_times = $cacheTb->today_midas_times;
			$this->total_online_time = $cacheTb->total_online_time;
			$this->tutorialstep = $cacheTb->tutorialstep;
			$this->rechargegem = $cacheTb->rechargegem;
			$this->facebook_follow = $cacheTb->facebook_follow;
			$this->wood = $cacheTb->wood;
			$this->iron = $cacheTb->iron;
									
			$this->load_from_cache = true;
			$this->clean();
			return true;
		}
		
		$p = "*";
		$c = "`user_id` = '{$this->user_id}'";
		
		if(!empty($fields))
		{
			$p = SQLUtil::parseFields($fields);			
		}
	    if (!empty($condition))
		{
			$c =SQLUtil::parseCondition($condition);
		}
		
		$sql = "SELECT {$p} FROM `player` WHERE {$c}";

		if(isset($this->user_id)){MySQL::selectDbForUser($this->user_id);}else{MySQL::selectDbForUser($GLOBALS['USER_ID']);}
		$qr = MySQL::getInstance()->RunQuery($sql);
		$ar = MySQL::getInstance()->FetchArray($qr);
		
		if (!$ar || count($ar)==0)
		{
			return false;
		}
		
		if (isset($ar['user_id'])) $this->user_id = $ar['user_id'];
		if (isset($ar['server_id'])) $this->server_id = intval($ar['server_id']);
		if (isset($ar['nickname'])) $this->nickname = $ar['nickname'];
		if (isset($ar['last_set_name_time'])) $this->last_set_name_time = intval($ar['last_set_name_time']);
		if (isset($ar['avatar'])) $this->avatar = intval($ar['avatar']);
		if (isset($ar['level'])) $this->level = intval($ar['level']);
		if (isset($ar['exp'])) $this->exp = $ar['exp'];
		if (isset($ar['money'])) $this->money = $ar['money'];
		if (isset($ar['gem'])) $this->gem = $ar['gem'];
		if (isset($ar['arena_point'])) $this->arena_point = intval($ar['arena_point']);
		if (isset($ar['crusade_point'])) $this->crusade_point = intval($ar['crusade_point']);
		if (isset($ar['guild_point'])) $this->guild_point = intval($ar['guild_point']);
		if (isset($ar['last_midas_time'])) $this->last_midas_time = intval($ar['last_midas_time']);
		if (isset($ar['today_midas_times'])) $this->today_midas_times = intval($ar['today_midas_times']);
		if (isset($ar['total_online_time'])) $this->total_online_time = intval($ar['total_online_time']);
		if (isset($ar['tutorialstep'])) $this->tutorialstep = intval($ar['tutorialstep']);
		if (isset($ar['rechargegem'])) $this->rechargegem = $ar['rechargegem'];
		if (isset($ar['facebook_follow'])) $this->facebook_follow = intval($ar['facebook_follow']);
		if (isset($ar['wood'])) $this->wood = $ar['wood'];
		if (isset($ar['iron'])) $this->iron = $ar['iron'];
		
				
		if(empty($fields)){
			$this->load_from_cache = true;
			self::addRecordsToCache($this->user_id, array($this));
		}
		
		$this->clean();
		
		return true;
	}
	
	public function /*boolean*/ loadedFromExistFields()
	{
		$emptyCondition = true;
    	$emptyFields = true;
    	
    	$fields = array();
    	$condition = array();
    	
    	if (!isset($this->user_id)){
    		$emptyFields = false;
    		$fields[] = 'user_id';
    	}else{
    		$emptyCondition = false; 
    		$condition['user_id']=$this->user_id;
    	}
    	if (!isset($this->server_id)){
    		$emptyFields = false;
    		$fields[] = 'server_id';
    	}else{
    		$emptyCondition = false; 
    		$condition['server_id']=$this->server_id;
    	}
    	if (!isset($this->nickname)){
    		$emptyFields = false;
    		$fields[] = 'nickname';
    	}else{
    		$emptyCondition = false; 
    		$condition['nickname']=$this->nickname;
    	}
    	if (!isset($this->last_set_name_time)){
    		$emptyFields = false;
    		$fields[] = 'last_set_name_time';
    	}else{
    		$emptyCondition = false; 
    		$condition['last_set_name_time']=$this->last_set_name_time;
    	}
    	if (!isset($this->avatar)){
    		$emptyFields = false;
    		$fields[] = 'avatar';
    	}else{
    		$emptyCondition = false; 
    		$condition['avatar']=$this->avatar;
    	}
    	if (!isset($this->level)){
    		$emptyFields = false;
    		$fields[] = 'level';
    	}else{
    		$emptyCondition = false; 
    		$condition['level']=$this->level;
    	}
    	if (!isset($this->exp)){
    		$emptyFields = false;
    		$fields[] = 'exp';
    	}else{
    		$emptyCondition = false; 
    		$condition['exp']=$this->exp;
    	}
    	if (!isset($this->money)){
    		$emptyFields = false;
    		$fields[] = 'money';
    	}else{
    		$emptyCondition = false; 
    		$condition['money']=$this->money;
    	}
    	if (!isset($this->gem)){
    		$emptyFields = false;
    		$fields[] = 'gem';
    	}else{
    		$emptyCondition = false; 
    		$condition['gem']=$this->gem;
    	}
    	if (!isset($this->arena_point)){
    		$emptyFields = false;
    		$fields[] = 'arena_point';
    	}else{
    		$emptyCondition = false; 
    		$condition['arena_point']=$this->arena_point;
    	}
    	if (!isset($this->crusade_point)){
    		$emptyFields = false;
    		$fields[] = 'crusade_point';
    	}else{
    		$emptyCondition = false; 
    		$condition['crusade_point']=$this->crusade_point;
    	}
    	if (!isset($this->guild_point)){
    		$emptyFields = false;
    		$fields[] = 'guild_point';
    	}else{
    		$emptyCondition = false; 
    		$condition['guild_point']=$this->guild_point;
    	}
    	if (!isset($this->last_midas_time)){
    		$emptyFields = false;
    		$fields[] = 'last_midas_time';
    	}else{
    		$emptyCondition = false; 
    		$condition['last_midas_time']=$this->last_midas_time;
    	}
    	if (!isset($this->today_midas_times)){
    		$emptyFields = false;
    		$fields[] = 'today_midas_times';
    	}else{
    		$emptyCondition = false; 
    		$condition['today_midas_times']=$this->today_midas_times;
    	}
    	if (!isset($this->total_online_time)){
    		$emptyFields = false;
    		$fields[] = 'total_online_time';
    	}else{
    		$emptyCondition = false; 
    		$condition['total_online_time']=$this->total_online_time;
    	}
    	if (!isset($this->tutorialstep)){
    		$emptyFields = false;
    		$fields[] = 'tutorialstep';
    	}else{
    		$emptyCondition = false; 
    		$condition['tutorialstep']=$this->tutorialstep;
    	}
    	if (!isset($this->rechargegem)){
    		$emptyFields = false;
    		$fields[] = 'rechargegem';
    	}else{
    		$emptyCondition = false; 
    		$condition['rechargegem']=$this->rechargegem;
    	}
    	if (!isset($this->facebook_follow)){
    		$emptyFields = false;
    		$fields[] = 'facebook_follow';
    	}else{
    		$emptyCondition = false; 
    		$condition['facebook_follow']=$this->facebook_follow;
    	}
    	if (!isset($this->wood)){
    		$emptyFields = false;
    		$fields[] = 'wood';
    	}else{
    		$emptyCondition = false; 
    		$condition['wood']=$this->wood;
    	}
    	if (!isset($this->iron)){
    		$emptyFields = false;
    		$fields[] = 'iron';
    	}else{
    		$emptyCondition = false; 
    		$condition['iron']=$this->iron;
    	}

    	
		if ($emptyFields)
    	{
    		unset($fields);
    	}
    	
    	if ($emptyCondition)
    	{
    		unset($condition); 
    	}
    	
    	return $this->loaded($fields,$condition);    	
	}
	
	public function /*boolean*/ inOrUp()
	{
		$sql = $this->getInSQL();
		if (empty($sql))
		{
			return false;
		}		
		$sql .= " ON DUPLICATE KEY UPDATE ";		
		$sql .= $this->getUpFields();		
		
		if(isset($this->user_id)){MySQL::selectDbForUser($this->user_id);}else{MySQL::selectDbForUser($GLOBALS['USER_ID']);}
		$qr = MySQL::getInstance()->RunQuery($sql);
		if (!$qr)
		{
			return false;
		}
				
		if (empty($this->user_id))
		{
			$this->user_id = MySQL::getInstance()->GetInsertId();
			$this->loaded(); //reload all fields for cache
		}		
		
		$this->clean();
		
		return true;	
		
	}
	
	public function /*boolean*/ save(/*array*/$condition=NULL)
	{
		if (empty($condition))
		{
			$uc = "`user_id`='{$this->user_id}'";
		}
		else
		{			
			$uc = SQLUtil::parseCondition($condition);
		}
		$sql = $this->getUpSQL($uc);
		
		if(empty($sql)){
			return true;
		}
		
		if(isset($this->user_id)){MySQL::selectDbForUser($this->user_id);}else{MySQL::selectDbForUser($GLOBALS['USER_ID']);}

		$qr = MySQL::getInstance()->RunQuery($sql);
		
		$this->clean();
				
		
		$ret = (boolean)$qr;
	
		if($ret && $this->load_from_cache){
			self::addRecordsToCache($this->user_id, array($this));
		}
				
		return $ret;
	}
	
	public static function sql_delete(/*array*/$condition=NULL)
	{
		if (empty($condition))
		{
			return false;
		}
		
		$sql = "DELETE FROM `player` WHERE ".SQLUtil::parseCondition($condition);
		
		$qr = MySQL::getInstance()->RunQuery($sql);
				
		return (boolean)$qr;
	}
	
	public function /*boolean*/ delete()
	{
		if (!isset($this->user_id))
		{
			return false;
		}
					
		self::deleteTableFromCache($this->user_id, $this->user_id);
		
		$sql = "DELETE FROM `player` WHERE `user_id`='{$this->user_id}'";
		
		if(isset($this->user_id)){MySQL::selectDbForUser($this->user_id);}else{MySQL::selectDbForUser($GLOBALS['USER_ID']);}
		$qr = MySQL::getInstance()->RunQuery($sql);
				
		return (boolean)$qr;
	}
	
	public function getInsertValue($fields)
	{
		$values = "(";		
		foreach($fields as $f => $k){
			if($f == 'user_id'){
 				$values .= "'{$this->user_id}',";
 			}else if($f == 'server_id'){
 				$values .= "'{$this->server_id}',";
 			}else if($f == 'nickname'){
 				$values .= "'{$this->nickname}',";
 			}else if($f == 'last_set_name_time'){
 				$values .= "'{$this->last_set_name_time}',";
 			}else if($f == 'avatar'){
 				$values .= "'{$this->avatar}',";
 			}else if($f == 'level'){
 				$values .= "'{$this->level}',";
 			}else if($f == 'exp'){
 				$values .= "'{$this->exp}',";
 			}else if($f == 'money'){
 				$values .= "'{$this->money}',";
 			}else if($f == 'gem'){
 				$values .= "'{$this->gem}',";
 			}else if($f == 'arena_point'){
 				$values .= "'{$this->arena_point}',";
 			}else if($f == 'crusade_point'){
 				$values .= "'{$this->crusade_point}',";
 			}else if($f == 'guild_point'){
 				$values .= "'{$this->guild_point}',";
 			}else if($f == 'last_midas_time'){
 				$values .= "'{$this->last_midas_time}',";
 			}else if($f == 'today_midas_times'){
 				$values .= "'{$this->today_midas_times}',";
 			}else if($f == 'total_online_time'){
 				$values .= "'{$this->total_online_time}',";
 			}else if($f == 'tutorialstep'){
 				$values .= "'{$this->tutorialstep}',";
 			}else if($f == 'rechargegem'){
 				$values .= "'{$this->rechargegem}',";
 			}else if($f == 'facebook_follow'){
 				$values .= "'{$this->facebook_follow}',";
 			}else if($f == 'wood'){
 				$values .= "'{$this->wood}',";
 			}else if($f == 'iron'){
 				$values .= "'{$this->iron}',";
 			}		
		}
		$values .= ")";
		
		return str_replace(",)",")",$values);		
	}
	
	private function /*string*/ getInSQL()
	{
		if (!$this->this_table_status_field)
		{
			return;
		}		
		
		$fields = "(";
		$values = " VALUES(";

		if (isset($this->user_id))
		{
			$fields .= "`user_id`,";
			$values .= "'{$this->user_id}',";
		}
		if (isset($this->server_id))
		{
			$fields .= "`server_id`,";
			$values .= "'{$this->server_id}',";
		}
		if (isset($this->nickname))
		{
			$fields .= "`nickname`,";
			$values .= "'{$this->nickname}',";
		}
		if (isset($this->last_set_name_time))
		{
			$fields .= "`last_set_name_time`,";
			$values .= "'{$this->last_set_name_time}',";
		}
		if (isset($this->avatar))
		{
			$fields .= "`avatar`,";
			$values .= "'{$this->avatar}',";
		}
		if (isset($this->level))
		{
			$fields .= "`level`,";
			$values .= "'{$this->level}',";
		}
		if (isset($this->exp))
		{
			$fields .= "`exp`,";
			$values .= "'{$this->exp}',";
		}
		if (isset($this->money))
		{
			$fields .= "`money`,";
			$values .= "'{$this->money}',";
		}
		if (isset($this->gem))
		{
			$fields .= "`gem`,";
			$values .= "'{$this->gem}',";
		}
		if (isset($this->arena_point))
		{
			$fields .= "`arena_point`,";
			$values .= "'{$this->arena_point}',";
		}
		if (isset($this->crusade_point))
		{
			$fields .= "`crusade_point`,";
			$values .= "'{$this->crusade_point}',";
		}
		if (isset($this->guild_point))
		{
			$fields .= "`guild_point`,";
			$values .= "'{$this->guild_point}',";
		}
		if (isset($this->last_midas_time))
		{
			$fields .= "`last_midas_time`,";
			$values .= "'{$this->last_midas_time}',";
		}
		if (isset($this->today_midas_times))
		{
			$fields .= "`today_midas_times`,";
			$values .= "'{$this->today_midas_times}',";
		}
		if (isset($this->total_online_time))
		{
			$fields .= "`total_online_time`,";
			$values .= "'{$this->total_online_time}',";
		}
		if (isset($this->tutorialstep))
		{
			$fields .= "`tutorialstep`,";
			$values .= "'{$this->tutorialstep}',";
		}
		if (isset($this->rechargegem))
		{
			$fields .= "`rechargegem`,";
			$values .= "'{$this->rechargegem}',";
		}
		if (isset($this->facebook_follow))
		{
			$fields .= "`facebook_follow`,";
			$values .= "'{$this->facebook_follow}',";
		}
		if (isset($this->wood))
		{
			$fields .= "`wood`,";
			$values .= "'{$this->wood}',";
		}
		if (isset($this->iron))
		{
			$fields .= "`iron`,";
			$values .= "'{$this->iron}',";
		}

		
		$fields .= ")";
		$values .= ")";
		
		$sql = "INSERT INTO `player` ".$fields.$values;
		
		return str_replace(",)",")",$sql);
	}
	
	private function /*string*/ getUpFields()
	{
		$update = "";
		
		if ($this->server_id_status_field)
		{			
			if (!isset($this->server_id))
			{
				$update .= ("`server_id`=null,");
			}
			else
			{
				$update .= ("`server_id`='{$this->server_id}',");
			}
		}
		if ($this->nickname_status_field)
		{			
			if (!isset($this->nickname))
			{
				$update .= ("`nickname`=null,");
			}
			else
			{
				$update .= ("`nickname`='{$this->nickname}',");
			}
		}
		if ($this->last_set_name_time_status_field)
		{			
			if (!isset($this->last_set_name_time))
			{
				$update .= ("`last_set_name_time`=null,");
			}
			else
			{
				$update .= ("`last_set_name_time`='{$this->last_set_name_time}',");
			}
		}
		if ($this->avatar_status_field)
		{			
			if (!isset($this->avatar))
			{
				$update .= ("`avatar`=null,");
			}
			else
			{
				$update .= ("`avatar`='{$this->avatar}',");
			}
		}
		if ($this->level_status_field)
		{			
			if (!isset($this->level))
			{
				$update .= ("`level`=null,");
			}
			else
			{
				$update .= ("`level`='{$this->level}',");
			}
		}
		if ($this->exp_status_field)
		{			
			if (!isset($this->exp))
			{
				$update .= ("`exp`=null,");
			}
			else
			{
				$update .= ("`exp`='{$this->exp}',");
			}
		}
		if ($this->money_status_field)
		{			
			if (!isset($this->money))
			{
				$update .= ("`money`=null,");
			}
			else
			{
				$update .= ("`money`='{$this->money}',");
			}
		}
		if ($this->gem_status_field)
		{			
			if (!isset($this->gem))
			{
				$update .= ("`gem`=null,");
			}
			else
			{
				$update .= ("`gem`='{$this->gem}',");
			}
		}
		if ($this->arena_point_status_field)
		{			
			if (!isset($this->arena_point))
			{
				$update .= ("`arena_point`=null,");
			}
			else
			{
				$update .= ("`arena_point`='{$this->arena_point}',");
			}
		}
		if ($this->crusade_point_status_field)
		{			
			if (!isset($this->crusade_point))
			{
				$update .= ("`crusade_point`=null,");
			}
			else
			{
				$update .= ("`crusade_point`='{$this->crusade_point}',");
			}
		}
		if ($this->guild_point_status_field)
		{			
			if (!isset($this->guild_point))
			{
				$update .= ("`guild_point`=null,");
			}
			else
			{
				$update .= ("`guild_point`='{$this->guild_point}',");
			}
		}
		if ($this->last_midas_time_status_field)
		{			
			if (!isset($this->last_midas_time))
			{
				$update .= ("`last_midas_time`=null,");
			}
			else
			{
				$update .= ("`last_midas_time`='{$this->last_midas_time}',");
			}
		}
		if ($this->today_midas_times_status_field)
		{			
			if (!isset($this->today_midas_times))
			{
				$update .= ("`today_midas_times`=null,");
			}
			else
			{
				$update .= ("`today_midas_times`='{$this->today_midas_times}',");
			}
		}
		if ($this->total_online_time_status_field)
		{			
			if (!isset($this->total_online_time))
			{
				$update .= ("`total_online_time`=null,");
			}
			else
			{
				$update .= ("`total_online_time`='{$this->total_online_time}',");
			}
		}
		if ($this->tutorialstep_status_field)
		{			
			if (!isset($this->tutorialstep))
			{
				$update .= ("`tutorialstep`=null,");
			}
			else
			{
				$update .= ("`tutorialstep`='{$this->tutorialstep}',");
			}
		}
		if ($this->rechargegem_status_field)
		{			
			if (!isset($this->rechargegem))
			{
				$update .= ("`rechargegem`=null,");
			}
			else
			{
				$update .= ("`rechargegem`='{$this->rechargegem}',");
			}
		}
		if ($this->facebook_follow_status_field)
		{			
			if (!isset($this->facebook_follow))
			{
				$update .= ("`facebook_follow`=null,");
			}
			else
			{
				$update .= ("`facebook_follow`='{$this->facebook_follow}',");
			}
		}
		if ($this->wood_status_field)
		{			
			if (!isset($this->wood))
			{
				$update .= ("`wood`=null,");
			}
			else
			{
				$update .= ("`wood`='{$this->wood}',");
			}
		}
		if ($this->iron_status_field)
		{			
			if (!isset($this->iron))
			{
				$update .= ("`iron`=null,");
			}
			else
			{
				$update .= ("`iron`='{$this->iron}',");
			}
		}

			
		if (empty($update) || strlen($update) < 1)
		{
			return;
		}
		
		$i = strrpos($update,",");
		if (!is_bool($i))
		{
			$update = substr($update,0,$i);
		}		
		
		return $update;
	}
	
	private function /*string*/ getUpSQL($condition)
	{
		if (!$this->this_table_status_field)
		{
			return null;
		}
		
		$update = $this->getUpFields();
		
		if (empty($update))
		{
			return;
		}
		
		$sql = "UPDATE `player` SET {$update} WHERE {$condition}";
		
		return $sql;
	}
		
	private function /*void*/ clean() 
	{
		$this->this_table_status_field = false;
		$this->user_id_status_field = false;
		$this->server_id_status_field = false;
		$this->nickname_status_field = false;
		$this->last_set_name_time_status_field = false;
		$this->avatar_status_field = false;
		$this->level_status_field = false;
		$this->exp_status_field = false;
		$this->money_status_field = false;
		$this->gem_status_field = false;
		$this->arena_point_status_field = false;
		$this->crusade_point_status_field = false;
		$this->guild_point_status_field = false;
		$this->last_midas_time_status_field = false;
		$this->today_midas_times_status_field = false;
		$this->total_online_time_status_field = false;
		$this->tutorialstep_status_field = false;
		$this->rechargegem_status_field = false;
		$this->facebook_follow_status_field = false;
		$this->wood_status_field = false;
		$this->iron_status_field = false;

	}
	
	public function /*string*/ getUserId()
	{
		return $this->user_id;
	}
	
	public function /*void*/ setUserId(/*string*/ $user_id)
	{
		$this->user_id = SQLUtil::toSafeSQLString($user_id);
		$this->user_id_status_field = true;		
		$this->this_table_status_field = true;		
	}

	public function /*void*/ setUserIdNull()
	{
		$this->user_id = null;
		$this->user_id_status_field = true;		
		$this->this_table_status_field = true;
	}

	public function /*int*/ getServerId()
	{
		return $this->server_id;
	}
	
	public function /*void*/ setServerId(/*int*/ $server_id)
	{
		$this->server_id = intval($server_id);
		$this->server_id_status_field = true;		
		$this->this_table_status_field = true;		
	}

	public function /*void*/ setServerIdNull()
	{
		$this->server_id = null;
		$this->server_id_status_field = true;		
		$this->this_table_status_field = true;
	}

	public function /*string*/ getNickname()
	{
		return $this->nickname;
	}
	
	public function /*void*/ setNickname(/*string*/ $nickname)
	{
		$this->nickname = SQLUtil::toSafeSQLString($nickname);
		$this->nickname_status_field = true;		
		$this->this_table_status_field = true;		
	}

	public function /*void*/ setNicknameNull()
	{
		$this->nickname = null;
		$this->nickname_status_field = true;		
		$this->this_table_status_field = true;
	}

	public function /*int*/ getLastSetNameTime()
	{
		return $this->last_set_name_time;
	}
	
	public function /*void*/ setLastSetNameTime(/*int*/ $last_set_name_time)
	{
		$this->last_set_name_time = intval($last_set_name_time);
		$this->last_set_name_time_status_field = true;		
		$this->this_table_status_field = true;		
	}

	public function /*void*/ setLastSetNameTimeNull()
	{
		$this->last_set_name_time = null;
		$this->last_set_name_time_status_field = true;		
		$this->this_table_status_field = true;
	}

	public function /*int*/ getAvatar()
	{
		return $this->avatar;
	}
	
	public function /*void*/ setAvatar(/*int*/ $avatar)
	{
		$this->avatar = intval($avatar);
		$this->avatar_status_field = true;		
		$this->this_table_status_field = true;		
	}

	public function /*void*/ setAvatarNull()
	{
		$this->avatar = null;
		$this->avatar_status_field = true;		
		$this->this_table_status_field = true;
	}

	public function /*int*/ getLevel()
	{
		return $this->level;
	}
	
	public function /*void*/ setLevel(/*int*/ $level)
	{
		$this->level = intval($level);
		$this->level_status_field = true;		
		$this->this_table_status_field = true;		
	}

	public function /*void*/ setLevelNull()
	{
		$this->level = null;
		$this->level_status_field = true;		
		$this->this_table_status_field = true;
	}

	public function /*string*/ getExp()
	{
		return $this->exp;
	}
	
	public function /*void*/ setExp(/*string*/ $exp)
	{
		$this->exp = SQLUtil::toSafeSQLString($exp);
		$this->exp_status_field = true;		
		$this->this_table_status_field = true;		
	}

	public function /*void*/ setExpNull()
	{
		$this->exp = null;
		$this->exp_status_field = true;		
		$this->this_table_status_field = true;
	}

	public function /*string*/ getMoney()
	{
		return $this->money;
	}
	
	public function /*void*/ setMoney(/*string*/ $money)
	{
		$this->money = SQLUtil::toSafeSQLString($money);
		$this->money_status_field = true;		
		$this->this_table_status_field = true;		
	}

	public function /*void*/ setMoneyNull()
	{
		$this->money = null;
		$this->money_status_field = true;		
		$this->this_table_status_field = true;
	}

	public function /*string*/ getGem()
	{
		return $this->gem;
	}
	
	public function /*void*/ setGem(/*string*/ $gem)
	{
		$this->gem = SQLUtil::toSafeSQLString($gem);
		$this->gem_status_field = true;		
		$this->this_table_status_field = true;		
	}

	public function /*void*/ setGemNull()
	{
		$this->gem = null;
		$this->gem_status_field = true;		
		$this->this_table_status_field = true;
	}

	public function /*int*/ getArenaPoint()
	{
		return $this->arena_point;
	}
	
	public function /*void*/ setArenaPoint(/*int*/ $arena_point)
	{
		$this->arena_point = intval($arena_point);
		$this->arena_point_status_field = true;		
		$this->this_table_status_field = true;		
	}

	public function /*void*/ setArenaPointNull()
	{
		$this->arena_point = null;
		$this->arena_point_status_field = true;		
		$this->this_table_status_field = true;
	}

	public function /*int*/ getCrusadePoint()
	{
		return $this->crusade_point;
	}
	
	public function /*void*/ setCrusadePoint(/*int*/ $crusade_point)
	{
		$this->crusade_point = intval($crusade_point);
		$this->crusade_point_status_field = true;		
		$this->this_table_status_field = true;		
	}

	public function /*void*/ setCrusadePointNull()
	{
		$this->crusade_point = null;
		$this->crusade_point_status_field = true;		
		$this->this_table_status_field = true;
	}

	public function /*int*/ getGuildPoint()
	{
		return $this->guild_point;
	}
	
	public function /*void*/ setGuildPoint(/*int*/ $guild_point)
	{
		$this->guild_point = intval($guild_point);
		$this->guild_point_status_field = true;		
		$this->this_table_status_field = true;		
	}

	public function /*void*/ setGuildPointNull()
	{
		$this->guild_point = null;
		$this->guild_point_status_field = true;		
		$this->this_table_status_field = true;
	}

	public function /*int*/ getLastMidasTime()
	{
		return $this->last_midas_time;
	}
	
	public function /*void*/ setLastMidasTime(/*int*/ $last_midas_time)
	{
		$this->last_midas_time = intval($last_midas_time);
		$this->last_midas_time_status_field = true;		
		$this->this_table_status_field = true;		
	}

	public function /*void*/ setLastMidasTimeNull()
	{
		$this->last_midas_time = null;
		$this->last_midas_time_status_field = true;		
		$this->this_table_status_field = true;
	}

	public function /*int*/ getTodayMidasTimes()
	{
		return $this->today_midas_times;
	}
	
	public function /*void*/ setTodayMidasTimes(/*int*/ $today_midas_times)
	{
		$this->today_midas_times = intval($today_midas_times);
		$this->today_midas_times_status_field = true;		
		$this->this_table_status_field = true;		
	}

	public function /*void*/ setTodayMidasTimesNull()
	{
		$this->today_midas_times = null;
		$this->today_midas_times_status_field = true;		
		$this->this_table_status_field = true;
	}

	public function /*int*/ getTotalOnlineTime()
	{
		return $this->total_online_time;
	}
	
	public function /*void*/ setTotalOnlineTime(/*int*/ $total_online_time)
	{
		$this->total_online_time = intval($total_online_time);
		$this->total_online_time_status_field = true;		
		$this->this_table_status_field = true;		
	}

	public function /*void*/ setTotalOnlineTimeNull()
	{
		$this->total_online_time = null;
		$this->total_online_time_status_field = true;		
		$this->this_table_status_field = true;
	}

	public function /*int*/ getTutorialstep()
	{
		return $this->tutorialstep;
	}
	
	public function /*void*/ setTutorialstep(/*int*/ $tutorialstep)
	{
		$this->tutorialstep = intval($tutorialstep);
		$this->tutorialstep_status_field = true;		
		$this->this_table_status_field = true;		
	}

	public function /*void*/ setTutorialstepNull()
	{
		$this->tutorialstep = null;
		$this->tutorialstep_status_field = true;		
		$this->this_table_status_field = true;
	}

	public function /*string*/ getRechargegem()
	{
		return $this->rechargegem;
	}
	
	public function /*void*/ setRechargegem(/*string*/ $rechargegem)
	{
		$this->rechargegem = SQLUtil::toSafeSQLString($rechargegem);
		$this->rechargegem_status_field = true;		
		$this->this_table_status_field = true;		
	}

	public function /*void*/ setRechargegemNull()
	{
		$this->rechargegem = null;
		$this->rechargegem_status_field = true;		
		$this->this_table_status_field = true;
	}

	public function /*int*/ getFacebookFollow()
	{
		return $this->facebook_follow;
	}
	
	public function /*void*/ setFacebookFollow(/*int*/ $facebook_follow)
	{
		$this->facebook_follow = intval($facebook_follow);
		$this->facebook_follow_status_field = true;		
		$this->this_table_status_field = true;		
	}

	public function /*void*/ setFacebookFollowNull()
	{
		$this->facebook_follow = null;
		$this->facebook_follow_status_field = true;		
		$this->this_table_status_field = true;
	}

	public function /*string*/ getWood()
	{
		return $this->wood;
	}
	
	public function /*void*/ setWood(/*string*/ $wood)
	{
		$this->wood = SQLUtil::toSafeSQLString($wood);
		$this->wood_status_field = true;		
		$this->this_table_status_field = true;		
	}

	public function /*void*/ setWoodNull()
	{
		$this->wood = null;
		$this->wood_status_field = true;		
		$this->this_table_status_field = true;
	}

	public function /*string*/ getIron()
	{
		return $this->iron;
	}
	
	public function /*void*/ setIron(/*string*/ $iron)
	{
		$this->iron = SQLUtil::toSafeSQLString($iron);
		$this->iron_status_field = true;		
		$this->this_table_status_field = true;		
	}

	public function /*void*/ setIronNull()
	{
		$this->iron = null;
		$this->iron_status_field = true;		
		$this->this_table_status_field = true;
	}

	
	public function /*string*/ toDebugString()
	{
		$dbg = "(";
		
		$dbg .= ("user_id={$this->user_id},");
		$dbg .= ("server_id={$this->server_id},");
		$dbg .= ("nickname={$this->nickname},");
		$dbg .= ("last_set_name_time={$this->last_set_name_time},");
		$dbg .= ("avatar={$this->avatar},");
		$dbg .= ("level={$this->level},");
		$dbg .= ("exp={$this->exp},");
		$dbg .= ("money={$this->money},");
		$dbg .= ("gem={$this->gem},");
		$dbg .= ("arena_point={$this->arena_point},");
		$dbg .= ("crusade_point={$this->crusade_point},");
		$dbg .= ("guild_point={$this->guild_point},");
		$dbg .= ("last_midas_time={$this->last_midas_time},");
		$dbg .= ("today_midas_times={$this->today_midas_times},");
		$dbg .= ("total_online_time={$this->total_online_time},");
		$dbg .= ("tutorialstep={$this->tutorialstep},");
		$dbg .= ("rechargegem={$this->rechargegem},");
		$dbg .= ("facebook_follow={$this->facebook_follow},");
		$dbg .= ("wood={$this->wood},");
		$dbg .= ("iron={$this->iron},");

		$dbg .= ")";
				
		return str_replace(",)",")",$dbg);
	}
}

?>
