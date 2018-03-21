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
				
		return (boolean)$qr;
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
	
	public function /*boolean*/ add($fieldsValue,$condition=NULL)
	{				
		if (empty($condition))
		{
			$uc = "`/*::KEY_NAME::*/`='{$this->/*::KEY_NAME::*/}'";
		}
		else
		{			
			$uc = SQLUtil::parseCondition($condition);
		}
		
		$update = SQLUtil::parseASFieldValues($fieldsValue);
		
		$sql = "UPDATE `/*::TABLE_NAME::*/` SET {$update} WHERE {$uc}";
		
/*::SELECT_DB_CODE::*/
		$qr = MySQL::getInstance()->RunQuery($sql);
				
		return (boolean)$qr;
	}	
	
	public function /*boolean*/ sub($fieldsValue,$condition=NULL)
	{
		if (empty($condition))
		{
			$uc = "`/*::KEY_NAME::*/`='{$this->/*::KEY_NAME::*/}'";
		}
		else
		{			
			$uc = SQLUtil::parseCondition($condition);
		}
		
		$update = SQLUtil::parseASFieldValues($fieldsValue,false);
		
		$sql = "UPDATE `/*::TABLE_NAME::*/` SET {$update} WHERE {$uc}";
		
/*::SELECT_DB_CODE::*/
		$qr = MySQL::getInstance()->RunQuery($sql);
				
		return (boolean)$qr;
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
