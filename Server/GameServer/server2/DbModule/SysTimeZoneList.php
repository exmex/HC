<?php
require_once ($GLOBALS ['GAME_ROOT'] . "CMySQL.php");
require_once ("SQLUtil.php");
/**
 *  [The generated files]
 */

class SysTimeZoneList {
	
	private /*int*/ $id; //PRIMARY KEY 
	private /*string*/ $time_zone;

	
	private $this_table_status_field = false;
	private $id_status_field = false;
	private $time_zone_status_field = false;


	public static function  loadedTable( $fields=NULL,$condition=NULL)
	{
		$result = array();
		
		$p = "*";
		
		if(!empty($fields))
		{
			$p = SQLUtil::parseFields($fields);			
		}
		if (empty($condition))
		{
			$sql = "SELECT {$p} FROM `time_zone_list`";
		}
		else
		{			
			$sql = "SELECT {$p} FROM `time_zone_list` WHERE ".SQLUtil::parseCondition($condition);
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
			$tb = new SysTimeZoneList();			
			if (isset($row['id'])) $tb->id = intval($row['id']);
			if (isset($row['time_zone'])) $tb->time_zone = $row['time_zone'];
		
			$result[] = $tb;
		}
		
		return $result;
	}	
	
	public static function insertSqlHeader($fields=NULL)
	{
		$result = array();				
		if(!empty($fields)){
			$where = SQLUtil::parseFields($fields);			
			$result[0] = "INSERT INTO `time_zone_list` ({$where}) VALUES ";	
			$ar = array();
			foreach($fields as $key){
				$ar[$key]=1;
			}
			$result[1] = $ar;
		}else{
			$result[0]="INSERT INTO `time_zone_list` (`id`,`time_zone`) VALUES ";
			$result[1] = array('id'=>1,'time_zone'=>1);
		}				
		return $result;
	}
		
	public function  loaded( $fields=NULL,$condition=NULL)
	{

		if (empty($condition) && empty($this->id))
		{
			return false;
		}
		
		$p = "*";
		$where = "`id` = '{$this->id}'";
		
		if(!empty($fields))
		{
			$p = SQLUtil::parseFields($fields);			
		}
	    if (!empty($condition))
		{
			$where =SQLUtil::parseCondition($condition);
		}
		
		$sql = "SELECT {$p} FROM `time_zone_list` WHERE {$where}";

		MySQL::selectDefaultDb();
		$qr = MySQL::getInstance()->RunQuery($sql);
		$ar = MySQL::getInstance()->FetchArray($qr);
		
		if (!$ar || count($ar)==0)
		{
			return false;
		}
		
		if (isset($ar['id'])) $this->id = intval($ar['id']);
		if (isset($ar['time_zone'])) $this->time_zone = $ar['time_zone'];
		
		
		$this->clean();
		
		return true;
	}
	
	
	public function  loadedCount( $fields=NULL,$condition=NULL)
	{
	
		if (empty($condition) && empty($this->id))
		{
			return false;
		}
	
		$p = "*";
		$where = "`id` = '{$this->id}'";
	
		if(!empty($fields))
		{
			$p = SQLUtil::parseFields($fields);
		}
		if (!empty($condition))
		{
			$where =SQLUtil::parseCondition($condition);
		}
	
		$sql = "SELECT {$p} FROM `time_zone_list` WHERE {$where}";
	
				MySQL::selectDefaultDb();
		$qr = MySQL::getInstance()->RunQuery($sql);
		$ar = MySQL::getInstance()->FetchArray($qr);
	
		if (!$ar || count($ar)==0)
		{
			return false;
		}
		return $ar;
	}
	
	
	
	public function loadedExistFields()
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
    	if (!isset($this->time_zone)){
    		$emptyFields = false;
    		$fields[] = 'time_zone';
    	}else{
    		$emptyCondition = false; 
    		$condition['time_zone']=$this->time_zone;
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
	
	public function  inOrUp()
	{
		$sql = $this->getInSQL();
		if (empty($sql))
		{
			return false;
		}		
		$sql .= " ON DUPLICATE KEY UPDATE ";		
		$sql .= $this->getUpFields();		
		
		MySQL::selectDefaultDb();
		$qr = MySQL::getInstance()->RunQuery($sql);
		if (!$qr)
		{
			return false;
		}
				
		if (empty($this->id))
		{
			$this->id = MySQL::getInstance()->GetInsertId();
		}		
		
		$this->clean();
		
		return true;	
		
	}
	
	public function save($condition=NULL)
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
		
		MySQL::selectDefaultDb();

		$qr = MySQL::getInstance()->RunQuery($sql);
		
		$this->clean();
				
		return (boolean)$qr;
	}
	
	public static function sql_delete($condition=NULL)
	{
		if (empty($condition))
		{
			return false;
		}
		
		$sql = "DELETE FROM `time_zone_list` WHERE ".SQLUtil::parseCondition($condition);
		
		$qr = MySQL::getInstance()->RunQuery($sql);
				
		return (boolean)$qr;
	}
	
	public function  delete()
	{
		if (!isset($this->id))
		{
			return false;
		}
		
		$sql = "DELETE FROM `time_zone_list` WHERE `id`='{$this->id}'";
		
		MySQL::selectDefaultDb();
		$qr = MySQL::getInstance()->RunQuery($sql);
				
		return (boolean)$qr;
	}
	
	public function getInsertValue($fields)
	{
		$values = "(";		
		foreach($fields as $f => $k){
			if($f == 'id'){
 				$values .= "'{$this->id}',";
 			}else if($f == 'time_zone'){
 				$values .= "'{$this->time_zone}',";
 			}		
		}
		$values .= ")";
		
		return str_replace(",)",")",$values);		
	}
	
	private function  getInSQL()
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
		if (isset($this->time_zone))
		{
			$fields .= "`time_zone`,";
			$values .= "'{$this->time_zone}',";
		}

		
		$fields .= ")";
		$values .= ")";
		
		$sql = "INSERT INTO `time_zone_list` ".$fields.$values;
		
		return str_replace(",)",")",$sql);
	}
	
	private function  getUpFields()
	{
		$update = "";
		
		if ($this->time_zone_status_field)
		{			
			if (!isset($this->time_zone))
			{
				$update .= ("`time_zone`=null,");
			}
			else
			{
				$update .= ("`time_zone`='{$this->time_zone}',");
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
	
	private function  getUpSQL($condition)
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
		
		$sql = "UPDATE `time_zone_list` SET {$update} WHERE {$condition}";
		
		return $sql;
	}
	
	public function  add($fieldsValue,$condition=NULL)
	{				
		if (empty($condition))
		{
			$uc = "`id`='{$this->id}'";
		}
		else
		{			
			$uc = SQLUtil::parseCondition($condition);
		}
		
		$update = SQLUtil::parseASFieldValues($fieldsValue);
		
		$sql = "UPDATE `time_zone_list` SET {$update} WHERE {$uc}";
		
		MySQL::selectDefaultDb();
		$qr = MySQL::getInstance()->RunQuery($sql);
				
		return (boolean)$qr;
	}	
	
	public function sub($fieldsVal,$condition=NULL)
	{
		if (empty($condition))
		{
			$uc = "`id`='{$this->id}'";
		}
		else
		{			
			$uc = SQLUtil::parseCondition($condition);
		}
		
		$update = SQLUtil::parseASFieldValues($fieldsVal,false);
		
		$sql = "UPDATE `time_zone_list` SET {$update} WHERE {$uc}";
		
		MySQL::selectDefaultDb();
		$qr = MySQL::getInstance()->RunQuery($sql);
				
		return (boolean)$qr;
	}
	
	private function /*void*/ clean() 
	{
		$this->this_table_status_field = false;
		$this->id_status_field = false;
		$this->time_zone_status_field = false;

	}
	
	public function /*int*/ getId()
	{
		return $this->id;
	}
	
	public function /*void*/ setId(/*int*/ $id)
	{
		$this->id = intval($id);
		$this->id_status_field = true;		
		$this->this_table_status_field = true;		
	}

	public function /*void*/ setIdNull()
	{
		$this->id = null;
		$this->id_status_field = true;		
		$this->this_table_status_field = true;
	}

	public function /*string*/ getTimeZone()
	{
		return $this->time_zone;
	}
	
	public function /*void*/ setTimeZone(/*string*/ $time_zone)
	{
		$this->time_zone = SQLUtil::toSafeSQLString($time_zone);
		$this->time_zone_status_field = true;		
		$this->this_table_status_field = true;		
	}

	public function /*void*/ setTimeZoneNull()
	{
		$this->time_zone = null;
		$this->time_zone_status_field = true;		
		$this->this_table_status_field = true;
	}

	
	public function /*string*/ toDebugString()
	{
		$dbg = "(";
		
		$dbg .= ("id={$this->id},");
		$dbg .= ("time_zone={$this->time_zone},");

		$dbg .= ")";
				
		return str_replace(",)",")",$dbg);
	}
}

?>
