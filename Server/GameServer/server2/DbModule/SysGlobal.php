<?php
require_once ($GLOBALS ['GAME_ROOT'] . "CMySQL.php");
require_once ("SQLUtil.php");
/**
 *  [The generated files]
 */

class SysGlobal {
	
	private /*string*/ $id; //PRIMARY KEY 
	private /*int*/ $key;
	private /*int*/ $day;
	private /*string*/ $value;

	
	private $this_table_status_field = false;
	private $id_status_field = false;
	private $key_status_field = false;
	private $day_status_field = false;
	private $value_status_field = false;


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
			$sql = "SELECT {$p} FROM `global`";
		}
		else
		{			
			$sql = "SELECT {$p} FROM `global` WHERE ".SQLUtil::parseCondition($condition);
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
			$tb = new SysGlobal();			
			if (isset($row['id'])) $tb->id = $row['id'];
			if (isset($row['key'])) $tb->key = intval($row['key']);
			if (isset($row['day'])) $tb->day = intval($row['day']);
			if (isset($row['value'])) $tb->value = $row['value'];
		
			$result[] = $tb;
		}
		
		return $result;
	}	
	
	public static function insertSqlHeader($fields=NULL)
	{
		$result = array();				
		if(!empty($fields)){
			$where = SQLUtil::parseFields($fields);			
			$result[0] = "INSERT INTO `global` ({$where}) VALUES ";	
			$ar = array();
			foreach($fields as $key){
				$ar[$key]=1;
			}
			$result[1] = $ar;
		}else{
			$result[0]="INSERT INTO `global` (`id`,`key`,`day`,`value`) VALUES ";
			$result[1] = array('id'=>1,'key'=>1,'day'=>1,'value'=>1);
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
		
		$sql = "SELECT {$p} FROM `global` WHERE {$where}";

		MySQL::selectDefaultDb();
		$qr = MySQL::getInstance()->RunQuery($sql);
		$ar = MySQL::getInstance()->FetchArray($qr);
		
		if (!$ar || count($ar)==0)
		{
			return false;
		}
		
		if (isset($ar['id'])) $this->id = $ar['id'];
		if (isset($ar['key'])) $this->key = intval($ar['key']);
		if (isset($ar['day'])) $this->day = intval($ar['day']);
		if (isset($ar['value'])) $this->value = $ar['value'];
		
		
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
	
		$sql = "SELECT {$p} FROM `global` WHERE {$where}";
	
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
    	if (!isset($this->key)){
    		$emptyFields = false;
    		$fields[] = 'key';
    	}else{
    		$emptyCondition = false; 
    		$condition['key']=$this->key;
    	}
    	if (!isset($this->day)){
    		$emptyFields = false;
    		$fields[] = 'day';
    	}else{
    		$emptyCondition = false; 
    		$condition['day']=$this->day;
    	}
    	if (!isset($this->value)){
    		$emptyFields = false;
    		$fields[] = 'value';
    	}else{
    		$emptyCondition = false; 
    		$condition['value']=$this->value;
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
		
		$sql = "DELETE FROM `global` WHERE ".SQLUtil::parseCondition($condition);
		
		$qr = MySQL::getInstance()->RunQuery($sql);
				
		return (boolean)$qr;
	}
	
	public function  delete()
	{
		if (!isset($this->id))
		{
			return false;
		}
		
		$sql = "DELETE FROM `global` WHERE `id`='{$this->id}'";
		
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
 			}else if($f == 'key'){
 				$values .= "'{$this->key}',";
 			}else if($f == 'day'){
 				$values .= "'{$this->day}',";
 			}else if($f == 'value'){
 				$values .= "'{$this->value}',";
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
		if (isset($this->key))
		{
			$fields .= "`key`,";
			$values .= "'{$this->key}',";
		}
		if (isset($this->day))
		{
			$fields .= "`day`,";
			$values .= "'{$this->day}',";
		}
		if (isset($this->value))
		{
			$fields .= "`value`,";
			$values .= "'{$this->value}',";
		}

		
		$fields .= ")";
		$values .= ")";
		
		$sql = "INSERT INTO `global` ".$fields.$values;
		
		return str_replace(",)",")",$sql);
	}
	
	private function  getUpFields()
	{
		$update = "";
		
		if ($this->key_status_field)
		{			
			if (!isset($this->key))
			{
				$update .= ("`key`=null,");
			}
			else
			{
				$update .= ("`key`='{$this->key}',");
			}
		}
		if ($this->day_status_field)
		{			
			if (!isset($this->day))
			{
				$update .= ("`day`=null,");
			}
			else
			{
				$update .= ("`day`='{$this->day}',");
			}
		}
		if ($this->value_status_field)
		{			
			if (!isset($this->value))
			{
				$update .= ("`value`=null,");
			}
			else
			{
				$update .= ("`value`='{$this->value}',");
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
		
		$sql = "UPDATE `global` SET {$update} WHERE {$condition}";
		
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
		
		$sql = "UPDATE `global` SET {$update} WHERE {$uc}";
		
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
		
		$sql = "UPDATE `global` SET {$update} WHERE {$uc}";
		
		MySQL::selectDefaultDb();
		$qr = MySQL::getInstance()->RunQuery($sql);
				
		return (boolean)$qr;
	}
	
	private function /*void*/ clean() 
	{
		$this->this_table_status_field = false;
		$this->id_status_field = false;
		$this->key_status_field = false;
		$this->day_status_field = false;
		$this->value_status_field = false;

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

	public function /*int*/ getKey()
	{
		return $this->key;
	}
	
	public function /*void*/ setKey(/*int*/ $key)
	{
		$this->key = intval($key);
		$this->key_status_field = true;		
		$this->this_table_status_field = true;		
	}

	public function /*void*/ setKeyNull()
	{
		$this->key = null;
		$this->key_status_field = true;		
		$this->this_table_status_field = true;
	}

	public function /*int*/ getDay()
	{
		return $this->day;
	}
	
	public function /*void*/ setDay(/*int*/ $day)
	{
		$this->day = intval($day);
		$this->day_status_field = true;		
		$this->this_table_status_field = true;		
	}

	public function /*void*/ setDayNull()
	{
		$this->day = null;
		$this->day_status_field = true;		
		$this->this_table_status_field = true;
	}

	public function /*string*/ getValue()
	{
		return $this->value;
	}
	
	public function /*void*/ setValue(/*string*/ $value)
	{
		$this->value = SQLUtil::toSafeSQLString($value);
		$this->value_status_field = true;		
		$this->this_table_status_field = true;		
	}

	public function /*void*/ setValueNull()
	{
		$this->value = null;
		$this->value_status_field = true;		
		$this->this_table_status_field = true;
	}

	
	public function /*string*/ toDebugString()
	{
		$dbg = "(";
		
		$dbg .= ("id={$this->id},");
		$dbg .= ("key={$this->key},");
		$dbg .= ("day={$this->day},");
		$dbg .= ("value={$this->value},");

		$dbg .= ")";
				
		return str_replace(",)",")",$dbg);
	}
}

?>
