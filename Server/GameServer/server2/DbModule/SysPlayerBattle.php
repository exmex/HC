<?php
require_once ($GLOBALS ['GAME_ROOT'] . "CMySQL.php");
require_once ("SQLUtil.php");
/**
 *  [The generated files]
 */

class SysPlayerBattle {
	
	private /*string*/ $user_id; //PRIMARY KEY 
	private /*int*/ $enter_stage_time;
	private /*int*/ $stage_group;
	private /*int*/ $stage_id;
	private /*int*/ $srand;
	private /*string*/ $loot;
	private /*string*/ $pvp_buffer;

	
	private $this_table_status_field = false;
	private $user_id_status_field = false;
	private $enter_stage_time_status_field = false;
	private $stage_group_status_field = false;
	private $stage_id_status_field = false;
	private $srand_status_field = false;
	private $loot_status_field = false;
	private $pvp_buffer_status_field = false;

	
	private static $KEY_FORMAT = "player_battle_%s";
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
	 * @return array(SysPlayerBattle)
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
	 * @param array(SysPlayerBattle) $data
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
	 * @param array(SysPlayerBattle) $data
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
			if(isset($condition['enter_stage_time']) && intval($condition['enter_stage_time']) != $record->enter_stage_time) continue;
			if(isset($condition['stage_group']) && intval($condition['stage_group']) != $record->stage_group) continue;
			if(isset($condition['stage_id']) && intval($condition['stage_id']) != $record->stage_id) continue;
			if(isset($condition['srand']) && intval($condition['srand']) != $record->srand) continue;
			if(isset($condition['loot']) && strval($condition['loot']) != $record->loot) continue;
			if(isset($condition['pvp_buffer']) && strval($condition['pvp_buffer']) != $record->pvp_buffer) continue;

			$record->load_from_cache = true;
			$result[] = $record;
		}
	
		return $result;
	}

	/**
	 * @example loadedTable(array('user_id'),array("user_id"=>"123"))
	 * @param array($condition)
	 * @return array(SysPlayerBattle)
	 */
	public static function /*array(SysPlayerBattle)*/ loadedTable(/*array*/ $fields=NULL,/*array*/$condition=NULL)
	{
		$result = array();
		
		$p = "*";
		
		if(!empty($fields))
		{
			$p = SQLUtil::parseFields($fields);			
		}
		
		if (empty($condition))
		{
			$sql = "SELECT {$f} FROM `player_battle`";
		}
		else
		{			
	 		$ret = self::loadedTableFromCache($condition);
			if(is_array($ret) && count($ret) > 0){
				return $ret;
			}
			$sql = "SELECT {$p} FROM `player_battle` WHERE ".SQLUtil::parseCondition($condition);
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
			$tb = new SysPlayerBattle();			
			if (isset($row['user_id'])) $tb->user_id = $row['user_id'];
			if (isset($row['enter_stage_time'])) $tb->enter_stage_time = intval($row['enter_stage_time']);
			if (isset($row['stage_group'])) $tb->stage_group = intval($row['stage_group']);
			if (isset($row['stage_id'])) $tb->stage_id = intval($row['stage_id']);
			if (isset($row['srand'])) $tb->srand = intval($row['srand']);
			if (isset($row['loot'])) $tb->loot = $row['loot'];
			if (isset($row['pvp_buffer'])) $tb->pvp_buffer = $row['pvp_buffer'];
		
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
			$result[0] = "INSERT INTO `player_battle` ({$f}) VALUES ";	
			$ar = array();
			foreach($fields as $key){
				$ar[$key]=1;
			}
			$result[1] = $ar;
		}else{
			$result[0]="INSERT INTO `player_battle` (`user_id`,`enter_stage_time`,`stage_group`,`stage_id`,`srand`,`loot`,`pvp_buffer`) VALUES ";
			$result[1] = array('user_id'=>1,'enter_stage_time'=>1,'stage_group'=>1,'stage_id'=>1,'srand'=>1,'loot'=>1,'pvp_buffer'=>1);
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
			$this->enter_stage_time = $cacheTb->enter_stage_time;
			$this->stage_group = $cacheTb->stage_group;
			$this->stage_id = $cacheTb->stage_id;
			$this->srand = $cacheTb->srand;
			$this->loot = $cacheTb->loot;
			$this->pvp_buffer = $cacheTb->pvp_buffer;
									
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
		
		$sql = "SELECT {$p} FROM `player_battle` WHERE {$c}";

		if(isset($this->user_id)){MySQL::selectDbForUser($this->user_id);}else{MySQL::selectDbForUser($GLOBALS['USER_ID']);}
		$qr = MySQL::getInstance()->RunQuery($sql);
		$ar = MySQL::getInstance()->FetchArray($qr);
		
		if (!$ar || count($ar)==0)
		{
			return false;
		}
		
		if (isset($ar['user_id'])) $this->user_id = $ar['user_id'];
		if (isset($ar['enter_stage_time'])) $this->enter_stage_time = intval($ar['enter_stage_time']);
		if (isset($ar['stage_group'])) $this->stage_group = intval($ar['stage_group']);
		if (isset($ar['stage_id'])) $this->stage_id = intval($ar['stage_id']);
		if (isset($ar['srand'])) $this->srand = intval($ar['srand']);
		if (isset($ar['loot'])) $this->loot = $ar['loot'];
		if (isset($ar['pvp_buffer'])) $this->pvp_buffer = $ar['pvp_buffer'];
		
				
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
    	if (!isset($this->enter_stage_time)){
    		$emptyFields = false;
    		$fields[] = 'enter_stage_time';
    	}else{
    		$emptyCondition = false; 
    		$condition['enter_stage_time']=$this->enter_stage_time;
    	}
    	if (!isset($this->stage_group)){
    		$emptyFields = false;
    		$fields[] = 'stage_group';
    	}else{
    		$emptyCondition = false; 
    		$condition['stage_group']=$this->stage_group;
    	}
    	if (!isset($this->stage_id)){
    		$emptyFields = false;
    		$fields[] = 'stage_id';
    	}else{
    		$emptyCondition = false; 
    		$condition['stage_id']=$this->stage_id;
    	}
    	if (!isset($this->srand)){
    		$emptyFields = false;
    		$fields[] = 'srand';
    	}else{
    		$emptyCondition = false; 
    		$condition['srand']=$this->srand;
    	}
    	if (!isset($this->loot)){
    		$emptyFields = false;
    		$fields[] = 'loot';
    	}else{
    		$emptyCondition = false; 
    		$condition['loot']=$this->loot;
    	}
    	if (!isset($this->pvp_buffer)){
    		$emptyFields = false;
    		$fields[] = 'pvp_buffer';
    	}else{
    		$emptyCondition = false; 
    		$condition['pvp_buffer']=$this->pvp_buffer;
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
		
		$sql = "DELETE FROM `player_battle` WHERE ".SQLUtil::parseCondition($condition);
		
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
		
		$sql = "DELETE FROM `player_battle` WHERE `user_id`='{$this->user_id}'";
		
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
 			}else if($f == 'enter_stage_time'){
 				$values .= "'{$this->enter_stage_time}',";
 			}else if($f == 'stage_group'){
 				$values .= "'{$this->stage_group}',";
 			}else if($f == 'stage_id'){
 				$values .= "'{$this->stage_id}',";
 			}else if($f == 'srand'){
 				$values .= "'{$this->srand}',";
 			}else if($f == 'loot'){
 				$values .= "'{$this->loot}',";
 			}else if($f == 'pvp_buffer'){
 				$values .= "'{$this->pvp_buffer}',";
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
		if (isset($this->enter_stage_time))
		{
			$fields .= "`enter_stage_time`,";
			$values .= "'{$this->enter_stage_time}',";
		}
		if (isset($this->stage_group))
		{
			$fields .= "`stage_group`,";
			$values .= "'{$this->stage_group}',";
		}
		if (isset($this->stage_id))
		{
			$fields .= "`stage_id`,";
			$values .= "'{$this->stage_id}',";
		}
		if (isset($this->srand))
		{
			$fields .= "`srand`,";
			$values .= "'{$this->srand}',";
		}
		if (isset($this->loot))
		{
			$fields .= "`loot`,";
			$values .= "'{$this->loot}',";
		}
		if (isset($this->pvp_buffer))
		{
			$fields .= "`pvp_buffer`,";
			$values .= "'{$this->pvp_buffer}',";
		}

		
		$fields .= ")";
		$values .= ")";
		
		$sql = "INSERT INTO `player_battle` ".$fields.$values;
		
		return str_replace(",)",")",$sql);
	}
	
	private function /*string*/ getUpFields()
	{
		$update = "";
		
		if ($this->enter_stage_time_status_field)
		{			
			if (!isset($this->enter_stage_time))
			{
				$update .= ("`enter_stage_time`=null,");
			}
			else
			{
				$update .= ("`enter_stage_time`='{$this->enter_stage_time}',");
			}
		}
		if ($this->stage_group_status_field)
		{			
			if (!isset($this->stage_group))
			{
				$update .= ("`stage_group`=null,");
			}
			else
			{
				$update .= ("`stage_group`='{$this->stage_group}',");
			}
		}
		if ($this->stage_id_status_field)
		{			
			if (!isset($this->stage_id))
			{
				$update .= ("`stage_id`=null,");
			}
			else
			{
				$update .= ("`stage_id`='{$this->stage_id}',");
			}
		}
		if ($this->srand_status_field)
		{			
			if (!isset($this->srand))
			{
				$update .= ("`srand`=null,");
			}
			else
			{
				$update .= ("`srand`='{$this->srand}',");
			}
		}
		if ($this->loot_status_field)
		{			
			if (!isset($this->loot))
			{
				$update .= ("`loot`=null,");
			}
			else
			{
				$update .= ("`loot`='{$this->loot}',");
			}
		}
		if ($this->pvp_buffer_status_field)
		{			
			if (!isset($this->pvp_buffer))
			{
				$update .= ("`pvp_buffer`=null,");
			}
			else
			{
				$update .= ("`pvp_buffer`='{$this->pvp_buffer}',");
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
		
		$sql = "UPDATE `player_battle` SET {$update} WHERE {$condition}";
		
		return $sql;
	}
		
	private function /*void*/ clean() 
	{
		$this->this_table_status_field = false;
		$this->user_id_status_field = false;
		$this->enter_stage_time_status_field = false;
		$this->stage_group_status_field = false;
		$this->stage_id_status_field = false;
		$this->srand_status_field = false;
		$this->loot_status_field = false;
		$this->pvp_buffer_status_field = false;

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

	public function /*int*/ getEnterStageTime()
	{
		return $this->enter_stage_time;
	}
	
	public function /*void*/ setEnterStageTime(/*int*/ $enter_stage_time)
	{
		$this->enter_stage_time = intval($enter_stage_time);
		$this->enter_stage_time_status_field = true;		
		$this->this_table_status_field = true;		
	}

	public function /*void*/ setEnterStageTimeNull()
	{
		$this->enter_stage_time = null;
		$this->enter_stage_time_status_field = true;		
		$this->this_table_status_field = true;
	}

	public function /*int*/ getStageGroup()
	{
		return $this->stage_group;
	}
	
	public function /*void*/ setStageGroup(/*int*/ $stage_group)
	{
		$this->stage_group = intval($stage_group);
		$this->stage_group_status_field = true;		
		$this->this_table_status_field = true;		
	}

	public function /*void*/ setStageGroupNull()
	{
		$this->stage_group = null;
		$this->stage_group_status_field = true;		
		$this->this_table_status_field = true;
	}

	public function /*int*/ getStageId()
	{
		return $this->stage_id;
	}
	
	public function /*void*/ setStageId(/*int*/ $stage_id)
	{
		$this->stage_id = intval($stage_id);
		$this->stage_id_status_field = true;		
		$this->this_table_status_field = true;		
	}

	public function /*void*/ setStageIdNull()
	{
		$this->stage_id = null;
		$this->stage_id_status_field = true;		
		$this->this_table_status_field = true;
	}

	public function /*int*/ getSrand()
	{
		return $this->srand;
	}
	
	public function /*void*/ setSrand(/*int*/ $srand)
	{
		$this->srand = intval($srand);
		$this->srand_status_field = true;		
		$this->this_table_status_field = true;		
	}

	public function /*void*/ setSrandNull()
	{
		$this->srand = null;
		$this->srand_status_field = true;		
		$this->this_table_status_field = true;
	}

	public function /*string*/ getLoot()
	{
		return $this->loot;
	}
	
	public function /*void*/ setLoot(/*string*/ $loot)
	{
		$this->loot = SQLUtil::toSafeSQLString($loot);
		$this->loot_status_field = true;		
		$this->this_table_status_field = true;		
	}

	public function /*void*/ setLootNull()
	{
		$this->loot = null;
		$this->loot_status_field = true;		
		$this->this_table_status_field = true;
	}

	public function /*string*/ getPvpBuffer()
	{
		return $this->pvp_buffer;
	}
	
	public function /*void*/ setPvpBuffer(/*string*/ $pvp_buffer)
	{
		$this->pvp_buffer = SQLUtil::toSafeSQLString($pvp_buffer);
		$this->pvp_buffer_status_field = true;		
		$this->this_table_status_field = true;		
	}

	public function /*void*/ setPvpBufferNull()
	{
		$this->pvp_buffer = null;
		$this->pvp_buffer_status_field = true;		
		$this->this_table_status_field = true;
	}

	
	public function /*string*/ toDebugString()
	{
		$dbg = "(";
		
		$dbg .= ("user_id={$this->user_id},");
		$dbg .= ("enter_stage_time={$this->enter_stage_time},");
		$dbg .= ("stage_group={$this->stage_group},");
		$dbg .= ("stage_id={$this->stage_id},");
		$dbg .= ("srand={$this->srand},");
		$dbg .= ("loot={$this->loot},");
		$dbg .= ("pvp_buffer={$this->pvp_buffer},");

		$dbg .= ")";
				
		return str_replace(",)",")",$dbg);
	}
}

?>
