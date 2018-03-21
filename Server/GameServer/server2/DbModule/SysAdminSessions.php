<?php
require_once ($GLOBALS ['GAME_ROOT'] . "CMySQL.php");
require_once ("SQLUtil.php");
/**
 *  [The generated files]
 */

class SysAdminSessions {
	
	private /*string*/ $sesskey; //PRIMARY KEY 
	private /*int*/ $expiry;
	private /*string*/ $value;

	
	private $this_table_status_field = false;
	private $sesskey_status_field = false;
	private $expiry_status_field = false;
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
			$sql = "SELECT {$p} FROM `admin_sessions`";
		}
		else
		{			
			$sql = "SELECT {$p} FROM `admin_sessions` WHERE ".SQLUtil::parseCondition($condition);
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
			$tb = new SysAdminSessions();			
			if (isset($row['sesskey'])) $tb->sesskey = $row['sesskey'];
			if (isset($row['expiry'])) $tb->expiry = intval($row['expiry']);
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
			$result[0] = "INSERT INTO `admin_sessions` ({$where}) VALUES ";	
			$ar = array();
			foreach($fields as $key){
				$ar[$key]=1;
			}
			$result[1] = $ar;
		}else{
			$result[0]="INSERT INTO `admin_sessions` (`sesskey`,`expiry`,`value`) VALUES ";
			$result[1] = array('sesskey'=>1,'expiry'=>1,'value'=>1);
		}				
		return $result;
	}
		
	public function  loaded( $fields=NULL,$condition=NULL)
	{

		if (empty($condition) && empty($this->sesskey))
		{
			return false;
		}
		
		$p = "*";
		$where = "`sesskey` = '{$this->sesskey}'";
		
		if(!empty($fields))
		{
			$p = SQLUtil::parseFields($fields);			
		}
	    if (!empty($condition))
		{
			$where =SQLUtil::parseCondition($condition);
		}
		
		$sql = "SELECT {$p} FROM `admin_sessions` WHERE {$where}";

		MySQL::selectDefaultDb();
		$qr = MySQL::getInstance()->RunQuery($sql);
		$ar = MySQL::getInstance()->FetchArray($qr);
		
		if (!$ar || count($ar)==0)
		{
			return false;
		}
		
		if (isset($ar['sesskey'])) $this->sesskey = $ar['sesskey'];
		if (isset($ar['expiry'])) $this->expiry = intval($ar['expiry']);
		if (isset($ar['value'])) $this->value = $ar['value'];
		
		
		$this->clean();
		
		return true;
	}
	
	
	public function  loadedCount( $fields=NULL,$condition=NULL)
	{
	
		if (empty($condition) && empty($this->sesskey))
		{
			return false;
		}
	
		$p = "*";
		$where = "`sesskey` = '{$this->sesskey}'";
	
		if(!empty($fields))
		{
			$p = SQLUtil::parseFields($fields);
		}
		if (!empty($condition))
		{
			$where =SQLUtil::parseCondition($condition);
		}
	
		$sql = "SELECT {$p} FROM `admin_sessions` WHERE {$where}";
	
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
    	
    	if (!isset($this->sesskey)){
    		$emptyFields = false;
    		$fields[] = 'sesskey';
    	}else{
    		$emptyCondition = false; 
    		$condition['sesskey']=$this->sesskey;
    	}
    	if (!isset($this->expiry)){
    		$emptyFields = false;
    		$fields[] = 'expiry';
    	}else{
    		$emptyCondition = false; 
    		$condition['expiry']=$this->expiry;
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
				
		if (empty($this->sesskey))
		{
			$this->sesskey = MySQL::getInstance()->GetInsertId();
		}		
		
		$this->clean();
		
		return true;	
		
	}
	
	public function save($condition=NULL)
	{
		if (empty($condition))
		{
			$uc = "`sesskey`='{$this->sesskey}'";
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
		
		$sql = "DELETE FROM `admin_sessions` WHERE ".SQLUtil::parseCondition($condition);
		
		$qr = MySQL::getInstance()->RunQuery($sql);
				
		return (boolean)$qr;
	}
	
	public function  delete()
	{
		if (!isset($this->sesskey))
		{
			return false;
		}
		
		$sql = "DELETE FROM `admin_sessions` WHERE `sesskey`='{$this->sesskey}'";
		
		MySQL::selectDefaultDb();
		$qr = MySQL::getInstance()->RunQuery($sql);
				
		return (boolean)$qr;
	}
	
	public function getInsertValue($fields)
	{
		$values = "(";		
		foreach($fields as $f => $k){
			if($f == 'sesskey'){
 				$values .= "'{$this->sesskey}',";
 			}else if($f == 'expiry'){
 				$values .= "'{$this->expiry}',";
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

		if (isset($this->sesskey))
		{
			$fields .= "`sesskey`,";
			$values .= "'{$this->sesskey}',";
		}
		if (isset($this->expiry))
		{
			$fields .= "`expiry`,";
			$values .= "'{$this->expiry}',";
		}
		if (isset($this->value))
		{
			$fields .= "`value`,";
			$values .= "'{$this->value}',";
		}

		
		$fields .= ")";
		$values .= ")";
		
		$sql = "INSERT INTO `admin_sessions` ".$fields.$values;
		
		return str_replace(",)",")",$sql);
	}
	
	private function  getUpFields()
	{
		$update = "";
		
		if ($this->expiry_status_field)
		{			
			if (!isset($this->expiry))
			{
				$update .= ("`expiry`=null,");
			}
			else
			{
				$update .= ("`expiry`='{$this->expiry}',");
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
		
		$sql = "UPDATE `admin_sessions` SET {$update} WHERE {$condition}";
		
		return $sql;
	}
	
	public function  add($fieldsValue,$condition=NULL)
	{				
		if (empty($condition))
		{
			$uc = "`sesskey`='{$this->sesskey}'";
		}
		else
		{			
			$uc = SQLUtil::parseCondition($condition);
		}
		
		$update = SQLUtil::parseASFieldValues($fieldsValue);
		
		$sql = "UPDATE `admin_sessions` SET {$update} WHERE {$uc}";
		
		MySQL::selectDefaultDb();
		$qr = MySQL::getInstance()->RunQuery($sql);
				
		return (boolean)$qr;
	}	
	
	public function sub($fieldsVal,$condition=NULL)
	{
		if (empty($condition))
		{
			$uc = "`sesskey`='{$this->sesskey}'";
		}
		else
		{			
			$uc = SQLUtil::parseCondition($condition);
		}
		
		$update = SQLUtil::parseASFieldValues($fieldsVal,false);
		
		$sql = "UPDATE `admin_sessions` SET {$update} WHERE {$uc}";
		
		MySQL::selectDefaultDb();
		$qr = MySQL::getInstance()->RunQuery($sql);
				
		return (boolean)$qr;
	}
	
	private function /*void*/ clean() 
	{
		$this->this_table_status_field = false;
		$this->sesskey_status_field = false;
		$this->expiry_status_field = false;
		$this->value_status_field = false;

	}
	
	public function /*string*/ getSesskey()
	{
		return $this->sesskey;
	}
	
	public function /*void*/ setSesskey(/*string*/ $sesskey)
	{
		$this->sesskey = SQLUtil::toSafeSQLString($sesskey);
		$this->sesskey_status_field = true;		
		$this->this_table_status_field = true;		
	}

	public function /*void*/ setSesskeyNull()
	{
		$this->sesskey = null;
		$this->sesskey_status_field = true;		
		$this->this_table_status_field = true;
	}

	public function /*int*/ getExpiry()
	{
		return $this->expiry;
	}
	
	public function /*void*/ setExpiry(/*int*/ $expiry)
	{
		$this->expiry = intval($expiry);
		$this->expiry_status_field = true;		
		$this->this_table_status_field = true;		
	}

	public function /*void*/ setExpiryNull()
	{
		$this->expiry = null;
		$this->expiry_status_field = true;		
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
		
		$dbg .= ("sesskey={$this->sesskey},");
		$dbg .= ("expiry={$this->expiry},");
		$dbg .= ("value={$this->value},");

		$dbg .= ")";
				
		return str_replace(",)",")",$dbg);
	}
}

?>
