<?php
require_once ($GLOBALS ['GAME_ROOT'] . "CMySQL.php");
require_once ("SQLUtil.php");
/**
 *  [The generated files]
 */

class SysAdminFiles {
	
	private /*int*/ $admin_files_id; //PRIMARY KEY 
	private /*string*/ $admin_files_name;
	private /*int*/ $admin_files_is_boxes;
	private /*int*/ $admin_files_to_boxes;
	private /*string*/ $admin_groups_id;

	
	private $this_table_status_field = false;
	private $admin_files_id_status_field = false;
	private $admin_files_name_status_field = false;
	private $admin_files_is_boxes_status_field = false;
	private $admin_files_to_boxes_status_field = false;
	private $admin_groups_id_status_field = false;


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
			$sql = "SELECT {$p} FROM `admin_files`";
		}
		else
		{			
			$sql = "SELECT {$p} FROM `admin_files` WHERE ".SQLUtil::parseCondition($condition);
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
			$tb = new SysAdminFiles();			
			if (isset($row['admin_files_id'])) $tb->admin_files_id = intval($row['admin_files_id']);
			if (isset($row['admin_files_name'])) $tb->admin_files_name = $row['admin_files_name'];
			if (isset($row['admin_files_is_boxes'])) $tb->admin_files_is_boxes = intval($row['admin_files_is_boxes']);
			if (isset($row['admin_files_to_boxes'])) $tb->admin_files_to_boxes = intval($row['admin_files_to_boxes']);
			if (isset($row['admin_groups_id'])) $tb->admin_groups_id = $row['admin_groups_id'];
		
			$result[] = $tb;
		}
		
		return $result;
	}	
	
	public static function insertSqlHeader($fields=NULL)
	{
		$result = array();				
		if(!empty($fields)){
			$where = SQLUtil::parseFields($fields);			
			$result[0] = "INSERT INTO `admin_files` ({$where}) VALUES ";	
			$ar = array();
			foreach($fields as $key){
				$ar[$key]=1;
			}
			$result[1] = $ar;
		}else{
			$result[0]="INSERT INTO `admin_files` (`admin_files_id`,`admin_files_name`,`admin_files_is_boxes`,`admin_files_to_boxes`,`admin_groups_id`) VALUES ";
			$result[1] = array('admin_files_id'=>1,'admin_files_name'=>1,'admin_files_is_boxes'=>1,'admin_files_to_boxes'=>1,'admin_groups_id'=>1);
		}				
		return $result;
	}
		
	public function  loaded( $fields=NULL,$condition=NULL)
	{

		if (empty($condition) && empty($this->admin_files_id))
		{
			return false;
		}
		
		$p = "*";
		$where = "`admin_files_id` = '{$this->admin_files_id}'";
		
		if(!empty($fields))
		{
			$p = SQLUtil::parseFields($fields);			
		}
	    if (!empty($condition))
		{
			$where =SQLUtil::parseCondition($condition);
		}
		
		$sql = "SELECT {$p} FROM `admin_files` WHERE {$where}";

		MySQL::selectDefaultDb();
		$qr = MySQL::getInstance()->RunQuery($sql);
		$ar = MySQL::getInstance()->FetchArray($qr);
		
		if (!$ar || count($ar)==0)
		{
			return false;
		}
		
		if (isset($ar['admin_files_id'])) $this->admin_files_id = intval($ar['admin_files_id']);
		if (isset($ar['admin_files_name'])) $this->admin_files_name = $ar['admin_files_name'];
		if (isset($ar['admin_files_is_boxes'])) $this->admin_files_is_boxes = intval($ar['admin_files_is_boxes']);
		if (isset($ar['admin_files_to_boxes'])) $this->admin_files_to_boxes = intval($ar['admin_files_to_boxes']);
		if (isset($ar['admin_groups_id'])) $this->admin_groups_id = $ar['admin_groups_id'];
		
		
		$this->clean();
		
		return true;
	}
	
	
	public function  loadedCount( $fields=NULL,$condition=NULL)
	{
	
		if (empty($condition) && empty($this->admin_files_id))
		{
			return false;
		}
	
		$p = "*";
		$where = "`admin_files_id` = '{$this->admin_files_id}'";
	
		if(!empty($fields))
		{
			$p = SQLUtil::parseFields($fields);
		}
		if (!empty($condition))
		{
			$where =SQLUtil::parseCondition($condition);
		}
	
		$sql = "SELECT {$p} FROM `admin_files` WHERE {$where}";
	
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
    	
    	if (!isset($this->admin_files_id)){
    		$emptyFields = false;
    		$fields[] = 'admin_files_id';
    	}else{
    		$emptyCondition = false; 
    		$condition['admin_files_id']=$this->admin_files_id;
    	}
    	if (!isset($this->admin_files_name)){
    		$emptyFields = false;
    		$fields[] = 'admin_files_name';
    	}else{
    		$emptyCondition = false; 
    		$condition['admin_files_name']=$this->admin_files_name;
    	}
    	if (!isset($this->admin_files_is_boxes)){
    		$emptyFields = false;
    		$fields[] = 'admin_files_is_boxes';
    	}else{
    		$emptyCondition = false; 
    		$condition['admin_files_is_boxes']=$this->admin_files_is_boxes;
    	}
    	if (!isset($this->admin_files_to_boxes)){
    		$emptyFields = false;
    		$fields[] = 'admin_files_to_boxes';
    	}else{
    		$emptyCondition = false; 
    		$condition['admin_files_to_boxes']=$this->admin_files_to_boxes;
    	}
    	if (!isset($this->admin_groups_id)){
    		$emptyFields = false;
    		$fields[] = 'admin_groups_id';
    	}else{
    		$emptyCondition = false; 
    		$condition['admin_groups_id']=$this->admin_groups_id;
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
				
		if (empty($this->admin_files_id))
		{
			$this->admin_files_id = MySQL::getInstance()->GetInsertId();
		}		
		
		$this->clean();
		
		return true;	
		
	}
	
	public function save($condition=NULL)
	{
		if (empty($condition))
		{
			$uc = "`admin_files_id`='{$this->admin_files_id}'";
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
		
		$sql = "DELETE FROM `admin_files` WHERE ".SQLUtil::parseCondition($condition);
		
		$qr = MySQL::getInstance()->RunQuery($sql);
				
		return (boolean)$qr;
	}
	
	public function  delete()
	{
		if (!isset($this->admin_files_id))
		{
			return false;
		}
		
		$sql = "DELETE FROM `admin_files` WHERE `admin_files_id`='{$this->admin_files_id}'";
		
		MySQL::selectDefaultDb();
		$qr = MySQL::getInstance()->RunQuery($sql);
				
		return (boolean)$qr;
	}
	
	public function getInsertValue($fields)
	{
		$values = "(";		
		foreach($fields as $f => $k){
			if($f == 'admin_files_id'){
 				$values .= "'{$this->admin_files_id}',";
 			}else if($f == 'admin_files_name'){
 				$values .= "'{$this->admin_files_name}',";
 			}else if($f == 'admin_files_is_boxes'){
 				$values .= "'{$this->admin_files_is_boxes}',";
 			}else if($f == 'admin_files_to_boxes'){
 				$values .= "'{$this->admin_files_to_boxes}',";
 			}else if($f == 'admin_groups_id'){
 				$values .= "'{$this->admin_groups_id}',";
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

		if (isset($this->admin_files_id))
		{
			$fields .= "`admin_files_id`,";
			$values .= "'{$this->admin_files_id}',";
		}
		if (isset($this->admin_files_name))
		{
			$fields .= "`admin_files_name`,";
			$values .= "'{$this->admin_files_name}',";
		}
		if (isset($this->admin_files_is_boxes))
		{
			$fields .= "`admin_files_is_boxes`,";
			$values .= "'{$this->admin_files_is_boxes}',";
		}
		if (isset($this->admin_files_to_boxes))
		{
			$fields .= "`admin_files_to_boxes`,";
			$values .= "'{$this->admin_files_to_boxes}',";
		}
		if (isset($this->admin_groups_id))
		{
			$fields .= "`admin_groups_id`,";
			$values .= "'{$this->admin_groups_id}',";
		}

		
		$fields .= ")";
		$values .= ")";
		
		$sql = "INSERT INTO `admin_files` ".$fields.$values;
		
		return str_replace(",)",")",$sql);
	}
	
	private function  getUpFields()
	{
		$update = "";
		
		if ($this->admin_files_name_status_field)
		{			
			if (!isset($this->admin_files_name))
			{
				$update .= ("`admin_files_name`=null,");
			}
			else
			{
				$update .= ("`admin_files_name`='{$this->admin_files_name}',");
			}
		}
		if ($this->admin_files_is_boxes_status_field)
		{			
			if (!isset($this->admin_files_is_boxes))
			{
				$update .= ("`admin_files_is_boxes`=null,");
			}
			else
			{
				$update .= ("`admin_files_is_boxes`='{$this->admin_files_is_boxes}',");
			}
		}
		if ($this->admin_files_to_boxes_status_field)
		{			
			if (!isset($this->admin_files_to_boxes))
			{
				$update .= ("`admin_files_to_boxes`=null,");
			}
			else
			{
				$update .= ("`admin_files_to_boxes`='{$this->admin_files_to_boxes}',");
			}
		}
		if ($this->admin_groups_id_status_field)
		{			
			if (!isset($this->admin_groups_id))
			{
				$update .= ("`admin_groups_id`=null,");
			}
			else
			{
				$update .= ("`admin_groups_id`='{$this->admin_groups_id}',");
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
		
		$sql = "UPDATE `admin_files` SET {$update} WHERE {$condition}";
		
		return $sql;
	}
	
	public function  add($fieldsValue,$condition=NULL)
	{				
		if (empty($condition))
		{
			$uc = "`admin_files_id`='{$this->admin_files_id}'";
		}
		else
		{			
			$uc = SQLUtil::parseCondition($condition);
		}
		
		$update = SQLUtil::parseASFieldValues($fieldsValue);
		
		$sql = "UPDATE `admin_files` SET {$update} WHERE {$uc}";
		
		MySQL::selectDefaultDb();
		$qr = MySQL::getInstance()->RunQuery($sql);
				
		return (boolean)$qr;
	}	
	
	public function sub($fieldsVal,$condition=NULL)
	{
		if (empty($condition))
		{
			$uc = "`admin_files_id`='{$this->admin_files_id}'";
		}
		else
		{			
			$uc = SQLUtil::parseCondition($condition);
		}
		
		$update = SQLUtil::parseASFieldValues($fieldsVal,false);
		
		$sql = "UPDATE `admin_files` SET {$update} WHERE {$uc}";
		
		MySQL::selectDefaultDb();
		$qr = MySQL::getInstance()->RunQuery($sql);
				
		return (boolean)$qr;
	}
	
	private function /*void*/ clean() 
	{
		$this->this_table_status_field = false;
		$this->admin_files_id_status_field = false;
		$this->admin_files_name_status_field = false;
		$this->admin_files_is_boxes_status_field = false;
		$this->admin_files_to_boxes_status_field = false;
		$this->admin_groups_id_status_field = false;

	}
	
	public function /*int*/ getAdminFilesId()
	{
		return $this->admin_files_id;
	}
	
	public function /*void*/ setAdminFilesId(/*int*/ $admin_files_id)
	{
		$this->admin_files_id = intval($admin_files_id);
		$this->admin_files_id_status_field = true;		
		$this->this_table_status_field = true;		
	}

	public function /*void*/ setAdminFilesIdNull()
	{
		$this->admin_files_id = null;
		$this->admin_files_id_status_field = true;		
		$this->this_table_status_field = true;
	}

	public function /*string*/ getAdminFilesName()
	{
		return $this->admin_files_name;
	}
	
	public function /*void*/ setAdminFilesName(/*string*/ $admin_files_name)
	{
		$this->admin_files_name = SQLUtil::toSafeSQLString($admin_files_name);
		$this->admin_files_name_status_field = true;		
		$this->this_table_status_field = true;		
	}

	public function /*void*/ setAdminFilesNameNull()
	{
		$this->admin_files_name = null;
		$this->admin_files_name_status_field = true;		
		$this->this_table_status_field = true;
	}

	public function /*int*/ getAdminFilesIsBoxes()
	{
		return $this->admin_files_is_boxes;
	}
	
	public function /*void*/ setAdminFilesIsBoxes(/*int*/ $admin_files_is_boxes)
	{
		$this->admin_files_is_boxes = intval($admin_files_is_boxes);
		$this->admin_files_is_boxes_status_field = true;		
		$this->this_table_status_field = true;		
	}

	public function /*void*/ setAdminFilesIsBoxesNull()
	{
		$this->admin_files_is_boxes = null;
		$this->admin_files_is_boxes_status_field = true;		
		$this->this_table_status_field = true;
	}

	public function /*int*/ getAdminFilesToBoxes()
	{
		return $this->admin_files_to_boxes;
	}
	
	public function /*void*/ setAdminFilesToBoxes(/*int*/ $admin_files_to_boxes)
	{
		$this->admin_files_to_boxes = intval($admin_files_to_boxes);
		$this->admin_files_to_boxes_status_field = true;		
		$this->this_table_status_field = true;		
	}

	public function /*void*/ setAdminFilesToBoxesNull()
	{
		$this->admin_files_to_boxes = null;
		$this->admin_files_to_boxes_status_field = true;		
		$this->this_table_status_field = true;
	}

	public function /*string*/ getAdminGroupsId()
	{
		return $this->admin_groups_id;
	}
	
	public function /*void*/ setAdminGroupsId(/*string*/ $admin_groups_id)
	{
		$this->admin_groups_id = SQLUtil::toSafeSQLString($admin_groups_id);
		$this->admin_groups_id_status_field = true;		
		$this->this_table_status_field = true;		
	}

	public function /*void*/ setAdminGroupsIdNull()
	{
		$this->admin_groups_id = null;
		$this->admin_groups_id_status_field = true;		
		$this->this_table_status_field = true;
	}

	
	public function /*string*/ toDebugString()
	{
		$dbg = "(";
		
		$dbg .= ("admin_files_id={$this->admin_files_id},");
		$dbg .= ("admin_files_name={$this->admin_files_name},");
		$dbg .= ("admin_files_is_boxes={$this->admin_files_is_boxes},");
		$dbg .= ("admin_files_to_boxes={$this->admin_files_to_boxes},");
		$dbg .= ("admin_groups_id={$this->admin_groups_id},");

		$dbg .= ")";
				
		return str_replace(",)",")",$dbg);
	}
}

?>
