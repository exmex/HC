<?php
require_once ($GLOBALS ['GAME_ROOT'] . "CMySQL.php");
require_once ("SQLUtil.php");
/**
 *  [The generated files]
 */

class SysPlayerItems {
	
	private /*string*/ $id; //PRIMARY KEY 
	private /*string*/ $user_id;
	private /*int*/ $item_id;
	private /*int*/ $count;

	
	private $this_table_status_field = false;
	private $id_status_field = false;
	private $user_id_status_field = false;
	private $item_id_status_field = false;
	private $count_status_field = false;

	
	private static $KEY_FORMAT = "player_items_%s";
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
	 * @return array(SysPlayerItems)
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
	 * @param array(SysPlayerItems) $data
	 * @return boolean
	 */
	private static function saveRecordsToCache($userId,$data)
	{
		if(!defined('ENABLE_DB_CACHE') || ENABLE_DB_CACHE==FALSE){
			return false;
		}
		
		$newData = array();
		foreach($data as $tb){
			$newData[$tb->id] = $tb;
		}
	
		self::$users_cache[$userId] = $newData;
	
		$key = sprintf(self::$KEY_FORMAT,$userId);;
		$ret = CMemcache::getInstance()->setData($key,$newData,60*60);
	
		return $ret;
	}
	
	/**
	 * @param String $userId
	 * @param array(SysPlayerItems) $data
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
			$cacheData[$tb->id] = $tb;
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
			if(isset($condition['id']) && strval($condition['id']) != $record->id) continue;
			if(isset($condition['user_id']) && strval($condition['user_id']) != $record->user_id) continue;
			if(isset($condition['item_id']) && intval($condition['item_id']) != $record->item_id) continue;
			if(isset($condition['count']) && intval($condition['count']) != $record->count) continue;

			$record->load_from_cache = true;
			$result[] = $record;
		}
	
		return $result;
	}

	/**
	 * @example loadedTable(array('id'),array("id"=>"123"))
	 * @param array($condition)
	 * @return array(SysPlayerItems)
	 */
	public static function /*array(SysPlayerItems)*/ loadedTable(/*array*/ $fields=NULL,/*array*/$condition=NULL)
	{
		$result = array();
		
		$p = "*";
		
		if(!empty($fields))
		{
			$p = SQLUtil::parseFields($fields);			
		}
		
		if (empty($condition))
		{
			$sql = "SELECT {$f} FROM `player_items`";
		}
		else
		{			
	 		$ret = self::loadedTableFromCache($condition);
			if(is_array($ret) && count($ret) > 0){
				return $ret;
			}
			$sql = "SELECT {$p} FROM `player_items` WHERE ".SQLUtil::parseCondition($condition);
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
			$tb = new SysPlayerItems();			
			if (isset($row['id'])) $tb->id = $row['id'];
			if (isset($row['user_id'])) $tb->user_id = $row['user_id'];
			if (isset($row['item_id'])) $tb->item_id = intval($row['item_id']);
			if (isset($row['count'])) $tb->count = intval($row['count']);
		
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
			$result[0] = "INSERT INTO `player_items` ({$f}) VALUES ";	
			$ar = array();
			foreach($fields as $key){
				$ar[$key]=1;
			}
			$result[1] = $ar;
		}else{
			$result[0]="INSERT INTO `player_items` (`id`,`user_id`,`item_id`,`count`) VALUES ";
			$result[1] = array('id'=>1,'user_id'=>1,'item_id'=>1,'count'=>1);
		}				
		return $result;
	}
		
	public function /*boolean*/ loaded(/*array*/ $fields=NULL,/*array*/$condition=NULL)
	{
		//ERROR:no condition
		if (empty($condition) && empty($this->id))
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
				$cacheTb = self::loadedTableFromCacheByKey($uid, $this->id);
			}
		}
		if(!empty($cacheTb)){
			$this->id = $cacheTb->id;
			$this->user_id = $cacheTb->user_id;
			$this->item_id = $cacheTb->item_id;
			$this->count = $cacheTb->count;
									
			$this->load_from_cache = true;
			$this->clean();
			return true;
		}
		
		$p = "*";
		$c = "`id` = '{$this->id}'";
		
		if(!empty($fields))
		{
			$p = SQLUtil::parseFields($fields);			
		}
	    if (!empty($condition))
		{
			$c =SQLUtil::parseCondition($condition);
		}
		
		$sql = "SELECT {$p} FROM `player_items` WHERE {$c}";

		if(isset($this->user_id)){MySQL::selectDbForUser($this->user_id);}else{MySQL::selectDbForUser($GLOBALS['USER_ID']);}
		$qr = MySQL::getInstance()->RunQuery($sql);
		$ar = MySQL::getInstance()->FetchArray($qr);
		
		if (!$ar || count($ar)==0)
		{
			return false;
		}
		
		if (isset($ar['id'])) $this->id = $ar['id'];
		if (isset($ar['user_id'])) $this->user_id = $ar['user_id'];
		if (isset($ar['item_id'])) $this->item_id = intval($ar['item_id']);
		if (isset($ar['count'])) $this->count = intval($ar['count']);
		
				
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
    	
    	if (!isset($this->id)){
    		$emptyFields = false;
    		$fields[] = 'id';
    	}else{
    		$emptyCondition = false; 
    		$condition['id']=$this->id;
    	}
    	if (!isset($this->user_id)){
    		$emptyFields = false;
    		$fields[] = 'user_id';
    	}else{
    		$emptyCondition = false; 
    		$condition['user_id']=$this->user_id;
    	}
    	if (!isset($this->item_id)){
    		$emptyFields = false;
    		$fields[] = 'item_id';
    	}else{
    		$emptyCondition = false; 
    		$condition['item_id']=$this->item_id;
    	}
    	if (!isset($this->count)){
    		$emptyFields = false;
    		$fields[] = 'count';
    	}else{
    		$emptyCondition = false; 
    		$condition['count']=$this->count;
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
				
		if (empty($this->id))
		{
			$this->id = MySQL::getInstance()->GetInsertId();
			$this->loaded(); //reload all fields for cache
		}		
		
		$this->clean();
		
		return true;	
		
	}
	
	public function /*boolean*/ save(/*array*/$condition=NULL)
	{
		if (empty($condition))
		{
			$uc = "`id`='{$this->id}'";
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
		
		$sql = "DELETE FROM `player_items` WHERE ".SQLUtil::parseCondition($condition);
		
		$qr = MySQL::getInstance()->RunQuery($sql);
				
		return (boolean)$qr;
	}
	
	public function /*boolean*/ delete()
	{
		if (!isset($this->id))
		{
			return false;
		}
					
		self::deleteTableFromCache($this->user_id, $this->id);
		
		$sql = "DELETE FROM `player_items` WHERE `id`='{$this->id}'";
		
		if(isset($this->user_id)){MySQL::selectDbForUser($this->user_id);}else{MySQL::selectDbForUser($GLOBALS['USER_ID']);}
		$qr = MySQL::getInstance()->RunQuery($sql);
				
		return (boolean)$qr;
	}
	
	public function getInsertValue($fields)
	{
		$values = "(";		
		foreach($fields as $f => $k){
			if($f == 'id'){
 				$values .= "'{$this->id}',";
 			}else if($f == 'user_id'){
 				$values .= "'{$this->user_id}',";
 			}else if($f == 'item_id'){
 				$values .= "'{$this->item_id}',";
 			}else if($f == 'count'){
 				$values .= "'{$this->count}',";
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

		if (isset($this->id))
		{
			$fields .= "`id`,";
			$values .= "'{$this->id}',";
		}
		if (isset($this->user_id))
		{
			$fields .= "`user_id`,";
			$values .= "'{$this->user_id}',";
		}
		if (isset($this->item_id))
		{
			$fields .= "`item_id`,";
			$values .= "'{$this->item_id}',";
		}
		if (isset($this->count))
		{
			$fields .= "`count`,";
			$values .= "'{$this->count}',";
		}

		
		$fields .= ")";
		$values .= ")";
		
		$sql = "INSERT INTO `player_items` ".$fields.$values;
		
		return str_replace(",)",")",$sql);
	}
	
	private function /*string*/ getUpFields()
	{
		$update = "";
		
		if ($this->user_id_status_field)
		{			
			if (!isset($this->user_id))
			{
				$update .= ("`user_id`=null,");
			}
			else
			{
				$update .= ("`user_id`='{$this->user_id}',");
			}
		}
		if ($this->item_id_status_field)
		{			
			if (!isset($this->item_id))
			{
				$update .= ("`item_id`=null,");
			}
			else
			{
				$update .= ("`item_id`='{$this->item_id}',");
			}
		}
		if ($this->count_status_field)
		{			
			if (!isset($this->count))
			{
				$update .= ("`count`=null,");
			}
			else
			{
				$update .= ("`count`='{$this->count}',");
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
		
		$sql = "UPDATE `player_items` SET {$update} WHERE {$condition}";
		
		return $sql;
	}
		
	private function /*void*/ clean() 
	{
		$this->this_table_status_field = false;
		$this->id_status_field = false;
		$this->user_id_status_field = false;
		$this->item_id_status_field = false;
		$this->count_status_field = false;

	}
	
	public function /*string*/ getId()
	{
		return $this->id;
	}
	
	public function /*void*/ setId(/*string*/ $id)
	{
		$this->id = SQLUtil::toSafeSQLString($id);
		$this->id_status_field = true;		
		$this->this_table_status_field = true;		
	}

	public function /*void*/ setIdNull()
	{
		$this->id = null;
		$this->id_status_field = true;		
		$this->this_table_status_field = true;
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

	public function /*int*/ getItemId()
	{
		return $this->item_id;
	}
	
	public function /*void*/ setItemId(/*int*/ $item_id)
	{
		$this->item_id = intval($item_id);
		$this->item_id_status_field = true;		
		$this->this_table_status_field = true;		
	}

	public function /*void*/ setItemIdNull()
	{
		$this->item_id = null;
		$this->item_id_status_field = true;		
		$this->this_table_status_field = true;
	}

	public function /*int*/ getCount()
	{
		return $this->count;
	}
	
	public function /*void*/ setCount(/*int*/ $count)
	{
		$this->count = intval($count);
		$this->count_status_field = true;		
		$this->this_table_status_field = true;		
	}

	public function /*void*/ setCountNull()
	{
		$this->count = null;
		$this->count_status_field = true;		
		$this->this_table_status_field = true;
	}

	
	public function /*string*/ toDebugString()
	{
		$dbg = "(";
		
		$dbg .= ("id={$this->id},");
		$dbg .= ("user_id={$this->user_id},");
		$dbg .= ("item_id={$this->item_id},");
		$dbg .= ("count={$this->count},");

		$dbg .= ")";
				
		return str_replace(",)",")",$dbg);
	}
}

?>
