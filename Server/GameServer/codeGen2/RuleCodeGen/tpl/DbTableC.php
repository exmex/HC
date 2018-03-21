<?php
require_once ($GLOBALS ['GAME_ROOT'] . "CMySQL.php");
require_once ("SQLUtil.php");
/**
 * database table /*::TABLE_NAME::*/ description
 * 
 * [This file was auto-generated. PLEASE DONT EDIT]
 * 
 * @author LiangZhixian
 * 
 */
class /*::TABLE_CLASS_NAME::*/ {
	
/*::FIELD_DEFINE_CODE::*/
	
	private $is_this_table_dirty = false;
/*::FIELD_DIRTY_DEFINE_CODE::*/
	
	private static $KEY_FORMAT = "/*::TABLE_NAME::*/_%s";
	private static $users_cache = array();
	private $is_load_from_cache = false;
	
	
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
	 * @return array(/*::TABLE_CLASS_NAME::*/)
	 */
	private static function loadRecordsFromCache($userId)
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
	 * @param array(/*::TABLE_CLASS_NAME::*/) $data
	 * @return boolean
	 */
	private static function saveRecordsToCache($userId,$data)
	{
		if(!defined('ENABLE_DB_CACHE') || ENABLE_DB_CACHE==FALSE){
			return false;
		}
		
		$newData = array();
		foreach($data as $tb){
			$newData[$tb->/*::KEY_NAME::*/] = $tb;
		}
	
		self::$users_cache[$userId] = $newData;
	
		$key = sprintf(self::$KEY_FORMAT,$userId);;
		$ret = CMemcache::getInstance()->setData($key,$newData,60*60);
	
		return $ret;
	}
	
	/**
	 * @param String $userId
	 * @param array(/*::TABLE_CLASS_NAME::*/) $data
	 * @return boolean
	 */
	private static function addRecordsToCache($userId,$data)
	{
		if(!defined('ENABLE_DB_CACHE') || ENABLE_DB_CACHE==FALSE){
			return false;
		}
		
		$cacheData = self::loadRecordsFromCache($userId);
		if(empty($cacheData)){
			return self::saveRecordsToCache($userId, $data);
		}
	
		foreach($data as $tb){
			$cacheData[$tb->/*::KEY_NAME::*/] = $tb;
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
		
		$allRecords = self::loadRecordsFromCache($userId);
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
	private static function loadTableFromCacheByKey($userId,$key)
	{
		if(!defined('ENABLE_DB_CACHE') || ENABLE_DB_CACHE==FALSE){
			return false;
		}
		
		$allRecords = self::loadRecordsFromCache($userId);
		if(empty($allRecords)){
			return false;
		}
	
		if(isset($allRecords[$key])){
			$rc =  $allRecords[$key];
			if(!empty($rc)){
				$rc->is_load_from_cache = true;
				return $rc;
			}
		}
	
		return false;
	}
	
	
	private static function loadTableFromCache($condition)
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
		$allRecords = self::loadRecordsFromCache($userId);
		if(empty($allRecords)){
			return false;
		}
	
		$result = array();
		foreach($allRecords as $key=>$record){
/*::CACHE_CMP_CONDITION_CODE::*/
			$record->is_load_from_cache = true;
			$result[] = $record;
		}
	
		return $result;
	}

	/**
	 * @example loadTable(array('/*::KEY_NAME::*/'),array("/*::KEY_NAME::*/"=>"123"))
	 * @param array($condition)
	 * @return array(/*::TABLE_CLASS_NAME::*/)
	 */
	public static function /*array(/*::TABLE_CLASS_NAME::*/)*/ loadTable(/*array*/ $fields=NULL,/*array*/$condition=NULL)
	{
		$result = array();
		
		$f = "*";
		
		if(!empty($fields))
		{
			$f = SQLUtil::parseFields($fields);			
		}
		
		if (empty($condition))
		{
			$sql = "SELECT {$f} FROM `/*::TABLE_NAME::*/`";
		}
		else
		{			
	 		$ret = self::loadTableFromCache($condition);
			if(is_array($ret) && count($ret) > 0){
				return $ret;
			}
			$sql = "SELECT {$f} FROM `/*::TABLE_NAME::*/` WHERE ".SQLUtil::parseCondition($condition);
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
			$tb = new /*::TABLE_CLASS_NAME::*/();			
/*::LOAD_TABLE_CODE::*/			
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
			$result[0] = "INSERT INTO `/*::TABLE_NAME::*/` ({$f}) VALUES ";	
			$ar = array();
			foreach($fields as $key){
				$ar[$key]=1;
			}
			$result[1] = $ar;
		}else{
/*::SQL_HEADER_CODE::*/
		}				
		return $result;
	}
		
	public function /*boolean*/ load(/*array*/ $fields=NULL,/*array*/$condition=NULL)
	{
		//ERROR:no condition
		if (empty($condition) && empty($this->/*::KEY_NAME::*/))
		{
			return false;
		}
						
		//load from cache first
		$cacheTb = null;
		if(!empty($condition)){
			$tbs = self::loadTableFromCache($condition);
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
				$cacheTb = self::loadTableFromCacheByKey($uid, $this->/*::KEY_NAME::*/);
			}
		}
		if(!empty($cacheTb)){
/*::COPY_CACHE_TABLE_CODE::*/									
			$this->is_load_from_cache = true;
			$this->clean();
			return true;
		}
		
		$f = "*";
		$c = "`/*::KEY_NAME::*/` = '{$this->/*::KEY_NAME::*/}'";
		
		if(!empty($fields))
		{
			$f = SQLUtil::parseFields($fields);			
		}
	    if (!empty($condition))
		{
			$c =SQLUtil::parseCondition($condition);
		}
		
		$sql = "SELECT {$f} FROM `/*::TABLE_NAME::*/` WHERE {$c}";

/*::SELECT_DB_CODE::*/
		$qr = MySQL::getInstance()->RunQuery($sql);
		$ar = MySQL::getInstance()->FetchArray($qr);
		
		if (!$ar || count($ar)==0)
		{
			return false;
		}
		
/*::LOAD_CODE::*/		
				
		if(empty($fields)){
			$this->is_load_from_cache = true;
			self::addRecordsToCache($this->user_id, array($this));
		}
		
		$this->clean();
		
		return true;
	}
	
	public function /*boolean*/ loadFromExistFields()
	{
		$emptyCondition = true;
    	$emptyFields = true;
    	
    	$fields = array();
    	$condition = array();
    	
/*::LOAD_FROM_EXIST_FIELDS_CODE::*/
    	
		if ($emptyFields)
    	{
    		unset($fields);
    	}
    	
    	if ($emptyCondition)
    	{
    		unset($condition); 
    	}
    	
    	return $this->load($fields,$condition);    	
	}
	
	public function /*boolean*/ insertOrUpdate()
	{
		$sql = $this->getInsertSQL();
		if (empty($sql))
		{
			return false;
		}		
		$sql .= " ON DUPLICATE KEY UPDATE ";		
		$sql .= $this->getUpdateFields();		
		
/*::SELECT_DB_CODE::*/
		$qr = MySQL::getInstance()->RunQuery($sql);
		if (!$qr)
		{
			return false;
		}
				
		if (empty($this->/*::KEY_NAME::*/))
		{
			$this->/*::KEY_NAME::*/ = MySQL::getInstance()->GetInsertId();
			$this->load(); //reload all fields for cache
		}		
		
		$this->clean();
		
		return true;	
		
	}
	
	public function /*boolean*/ save(/*array*/$condition=NULL)
	{
		if (empty($condition))
		{
			$uc = "`/*::KEY_NAME::*/`='{$this->/*::KEY_NAME::*/}'";
		}
		else
		{			
			$uc = SQLUtil::parseCondition($condition);
		}
		$sql = $this->getUpdateSQL($uc);
		
		if(empty($sql)){
			return true;
		}
		
/*::SELECT_DB_CODE::*/

		$qr = MySQL::getInstance()->RunQuery($sql);
		
		$this->clean();
				
		
		$ret = (boolean)$qr;
	
		if($ret && $this->is_load_from_cache){
			self::addRecordsToCache($this->user_id, array($this));
		}
				
		return $ret;
	}
	
	public static function s_delete(/*array*/$condition=NULL)
	{
		if (empty($condition))
		{
			return false;
		}
		
		$sql = "DELETE FROM `/*::TABLE_NAME::*/` WHERE ".SQLUtil::parseCondition($condition);
		
		$qr = MySQL::getInstance()->RunQuery($sql);
				
		return (boolean)$qr;
	}
	
	public function /*boolean*/ delete()
	{
		if (!isset($this->/*::KEY_NAME::*/))
		{
			return false;
		}
					
		self::deleteTableFromCache($this->user_id, $this->/*::KEY_NAME::*/);
		
		$sql = "DELETE FROM `/*::TABLE_NAME::*/` WHERE `/*::KEY_NAME::*/`='{$this->/*::KEY_NAME::*/}'";
		
/*::SELECT_DB_CODE::*/
		$qr = MySQL::getInstance()->RunQuery($sql);
				
		return (boolean)$qr;
	}
	
	public function getInsertValue($fields)
	{
		$values = "(";		
		foreach($fields as $f => $k){
/*::INSERT_VALUE_CODE::*/		
		}
		$values .= ")";
		
		return str_replace(",,)",")",$values);		
	}
	
	private function /*string*/ getInsertSQL()
	{
		if (!$this->is_this_table_dirty)
		{
			return;
		}		
		
		$fields = "(";
		$values = " VALUES(";

/*::INSERT_SQL_CODE::*/
		
		$fields .= ")";
		$values .= ")";
		
		$sql = "INSERT INTO `/*::TABLE_NAME::*/` ".$fields.$values;
		
		return str_replace(",,)",")",$sql);
	}
	
	private function /*string*/ getUpdateFields()
	{
		$update = "";
		
/*::UPDATE_SQL_CODE::*/
			
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
	
	private function /*string*/ getUpdateSQL($condition)
	{
		if (!$this->is_this_table_dirty)
		{
			return null;
		}
		
		$update = $this->getUpdateFields();
		
		if (empty($update))
		{
			return;
		}
		
		$sql = "UPDATE `/*::TABLE_NAME::*/` SET {$update} WHERE {$condition}";
		
		return $sql;
	}
		
	private function /*void*/ clean() 
	{
		$this->is_this_table_dirty = false;
/*::CLEAN_CODE::*/
	}
	
/*::FIELD_GET_SET_CODE::*/	
	public function /*string*/ toDebugString()
	{
		$dbg = "(";
		
/*::TO_DEBUG_STRING_CODE::*/
		$dbg .= ")";
				
		return str_replace(",,)",")",$dbg);
	}
}

?>
