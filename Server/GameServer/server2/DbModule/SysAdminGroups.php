<?php
require_once ($GLOBALS ['GAME_ROOT'] . "CMySQL.php");
require_once ("SQLUtil.php");
/**
 *  [The generated files]
 */

class SysAdminGroups {
	
	private /*int*/ $admin_groups_id; //PRIMARY KEY 
	private /*string*/ $admin_groups_name;

	
	private $this_table_status_field = false;
	private $admin_groups_id_status_field = false;
	private $admin_groups_name_status_field = false;


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
			$sql = "SELECT {$p} FROM `admin_groups`";
		}
		else
		{			
			$sql = "SELECT {$p} FROM `admin_groups` WHERE ".SQLUtil::parseCondition($condition);
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
			$tb = new SysAdminGroups();			
			if (isset($row['admin_groups_id'])) $tb->admin_groups_id = intval($row['admin_groups_id']);
			if (isset($row['admin_groups_name'])) $tb->admin_groups_name = $row['admin_groups_name'];
		
			$result[] = $tb;
		}
		
		return $result;
	}	
	
	public static function insertSqlHeader($fields=NULL)
	{
		$result = array();				
		if(!empty($fields)){
			$where = SQLUtil::parseFields($fields);			
			$result[0] = "INSERT INTO `admin_groups` ({$where}) VALUES ";	
			$ar = array();
			foreach($fields as $key){
				$ar[$key]=1;
			}
			$result[1] = $ar;
		}else{
			$result[0]="INSERT INTO `admin_groups` (`admin_groups_id`,`admin_groups_name`) VALUES ";
			$result[1] = array('admin_groups_id'=>1,'admin_groups_name'=>1);
		}				
		return $result;
	}
		
	public function  loaded( $fields=NULL,$condition=NULL)
	{

		if (empty($condition) && empty($this->admin_groups_id))
		{
			return false;
		}
		
		$p = "*";
		$where = "`admin_groups_id` = '{$this->admin_groups_id}'";
		
		if(!empty($fields))
		{
			$p = SQLUtil::parseFields($fields);			
		}
	    if (!empty($condition))
		{
			$where =SQLUtil::parseCondition($condition);
		}
		
		$sql = "SELECT {$p} FROM `admin_groups` WHERE {$where}";

		MySQL::selectDefaultDb();
		$qr = MySQL::getInstance()->RunQuery($sql);
		$ar = MySQL::getInstance()->FetchArray($qr);
		
		if (!$ar || count($ar)==0)
		{
			return false;
		}
		
		if (isset($ar['admin_groups_id'])) $this->admin_groups_id = intval($ar['admin_groups_id']);
		if (isset($ar['admin_groups_name'])) $this->admin_groups_name = $ar['admin_groups_name'];
		
		
		$this->clean();
		
		return true;
	}
	
	
	public function  loadedCount( $fields=NULL,$condition=NULL)
	{
	
		if (empty($condition) && empty($this->admin_groups_id))
		{
			return false;
		}
	
		$p = "*";
		$where = "`admin_groups_id` = '{$this->admin_groups_id}'";
	
		if(!empty($fields))
		{
			$p = SQLUtil::parseFields($fields);
		}
		if (!empty($condition))
		{
			$where =SQLUtil::parseCondition($condition);
		}
	
		$sql = "SELECT {$p} FROM `admin_groups` WHERE {$where}";
	
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
    	
    	if (!isset($this->admin_groups_id)){
    		$emptyFields = false;
    		$fields[] = 'admin_groups_id';
    	}else{
    		$emptyCondition = false; 
    		$condition['admin_groups_id']=$this->admin_groups_id;
    	}
    	if (!isset($this->admin_groups_name)){
    		$emptyFields = false;
    		$fields[] = 'admin_groups_name';
    	}else{
    		$emptyCondition = false; 
    		$condition['admin_groups_name']=$this->admin_groups_name;
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
				
		if (empty($this->admin_groups_id))
		{
			$this->admin_groups_id = MySQL::getInstance()->GetInsertId();
		}		
		
		$this->clean();
		
		return true;	
		
	}
	
	public function save($condition=NULL)
	{
		if (empty($condition))
		{
			$uc = "`admin_groups_id`='{$this->admin_groups_id}'";
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
		
		$sql = "DELETE FROM `admin_groups` WHERE ".SQLUtil::parseCondition($condition);
		
		$qr = MySQL::getInstance()->RunQuery($sql);
				
		return (boolean)$qr;
	}
	
	public function  delete()
	{
		if (!isset($this->admin_groups_id))
		{
			return false;
		}
		
		$sql = "DELETE FROM `admin_groups` WHERE `admin_groups_id`='{$this->admin_groups_id}'";
		
		MySQL::selectDefaultDb();
		$qr = MySQL::getInstance()->RunQuery($sql);
				
		return (boolean)$qr;
	}
	
	public function getInsertValue($fields)
	{
		$values = "(";		
		foreach($fields as $f => $k){
			if($f == 'admin_groups_id'){
 				$values .= "'{$this->admin_groups_id}',";
 			}else if($f == 'admin_groups_name'){
 				$values .= "'{$this->admin_groups_name}',";
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

		if (isset($this->admin_groups_id))
		{
			$fields .= "`admin_groups_id`,";
			$values .= "'{$this->admin_groups_id}',";
		}
		if (isset($this->admin_groups_name))
		{
			$fields .= "`admin_groups_name`,";
			$values .= "'{$this->admin_groups_name}',";
		}

		
		$fields .= ")";
		$values .= ")";
		
		$sql = "INSERT INTO `admin_groups` ".$fields.$values;
		
		return str_replace(",)",")",$sql);
	}
	
	private function  getUpFields()
	{
		$update = "";
		
		if ($this->admin_groups_name_status_field)
		{			
			if (!isset($this->admin_groups_name))
			{
				$update .= ("`admin_groups_name`=null,");
			}
			else
			{
				$update .= ("`admin_groups_name`='{$this->admin_groups_name}',");
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
		
		$sql = "UPDATE `admin_groups` SET {$update} WHERE {$condition}";
		
		return $sql;
	}
	
	public function  add($fieldsValue,$condition=NULL)
	{				
		if (empty($condition))
		{
			$uc = "`admin_groups_id`='{$this->admin_groups_id}'";
		}
		else
		{			
			$uc = SQLUtil::parseCondition($condition);
		}
		
		$update = SQLUtil::parseASFieldValues($fieldsValue);
		
		$sql = "UPDATE `admin_groups` SET {$update} WHERE {$uc}";
		
		MySQL::selectDefaultDb();
		$qr = MySQL::getInstance()->RunQuery($sql);
				
		return (boolean)$qr;
	}	
	
	public function sub($fieldsVal,$condition=NULL)
	{
		if (empty($condition))
		{
			$uc = "`admin_groups_id`='{$this->admin_groups_id}'";
		}
		else
		{			
			$uc = SQLUtil::parseCondition($condition);
		}
		
		$update = SQLUtil::parseASFieldValues($fieldsVal,false);
		
		$sql = "UPDATE `admin_groups` SET {$update} WHERE {$uc}";
		
		MySQL::selectDefaultDb();
		$qr = MySQL::getInstance()->RunQuery($sql);
				
		return (boolean)$qr;
	}
	
	private function /*void*/ clean() 
	{
		$this->this_table_status_field = false;
		$this->admin_groups_id_status_field = false;
		$this->admin_groups_name_status_field = false;

	}
	
	public function /*int*/ getAdminGroupsId()
	{
		return $this->admin_groups_id;
	}
	
	public function /*void*/ setAdminGroupsId(/*int*/ $admin_groups_id)
	{
		$this->admin_groups_id = intval($admin_groups_id);
		$this->admin_groups_id_status_field = true;		
		$this->this_table_status_field = true;		
	}

	public function /*void*/ setAdminGroupsIdNull()
	{
		$this->admin_groups_id = null;
		$this->admin_groups_id_status_field = true;		
		$this->this_table_status_field = true;
	}

	public function /*string*/ getAdminGroupsName()
	{
		return $this->admin_groups_name;
	}
	
	public function /*void*/ setAdminGroupsName(/*string*/ $admin_groups_name)
	{
		$this->admin_groups_name = SQLUtil::toSafeSQLString($admin_groups_name);
		$this->admin_groups_name_status_field = true;		
		$this->this_table_status_field = true;		
	}

	public function /*void*/ setAdminGroupsNameNull()
	{
		$this->admin_groups_name = null;
		$this->admin_groups_name_status_field = true;		
		$this->this_table_status_field = true;
	}

	
	public function /*string*/ toDebugString()
	{
		$dbg = "(";
		
		$dbg .= ("admin_groups_id={$this->admin_groups_id},");
		$dbg .= ("admin_groups_name={$this->admin_groups_name},");

		$dbg .= ")";
				
		return str_replace(",)",")",$dbg);
	}
}

?>
