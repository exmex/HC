<?php
require_once ($GLOBALS ['GAME_ROOT'] . "CMySQL.php");
require_once ("SQLUtil.php");
/**
 *  [The generated files]
 */

class SysAutoRun {
	
	private /*int*/ $id; //PRIMARY KEY 
	private /*string*/ $script_name;
	private /*int*/ $statu;
	private /*int*/ $run_time;

	
	private $this_table_status_field = false;
	private $id_status_field = false;
	private $script_name_status_field = false;
	private $statu_status_field = false;
	private $run_time_status_field = false;


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
			$sql = "SELECT {$p} FROM `auto_run`";
		}
		else
		{			
			$sql = "SELECT {$p} FROM `auto_run` WHERE ".SQLUtil::parseCondition($condition);
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
			$tb = new SysAutoRun();			
			if (isset($row['id'])) $tb->id = intval($row['id']);
			if (isset($row['script_name'])) $tb->script_name = $row['script_name'];
			if (isset($row['statu'])) $tb->statu = intval($row['statu']);
			if (isset($row['run_time'])) $tb->run_time = intval($row['run_time']);
		
			$result[] = $tb;
		}
		
		return $result;
	}	
	
	public static function insertSqlHeader($fields=NULL)
	{
		$result = array();				
		if(!empty($fields)){
			$where = SQLUtil::parseFields($fields);			
			$result[0] = "INSERT INTO `auto_run` ({$where}) VALUES ";	
			$ar = array();
			foreach($fields as $key){
				$ar[$key]=1;
			}
			$result[1] = $ar;
		}else{
			$result[0]="INSERT INTO `auto_run` (`id`,`script_name`,`statu`,`run_time`) VALUES ";
			$result[1] = array('id'=>1,'script_name'=>1,'statu'=>1,'run_time'=>1);
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
		
		$sql = "SELECT {$p} FROM `auto_run` WHERE {$where}";

		MySQL::selectDefaultDb();
		$qr = MySQL::getInstance()->RunQuery($sql);
		$ar = MySQL::getInstance()->FetchArray($qr);
		
		if (!$ar || count($ar)==0)
		{
			return false;
		}
		
		if (isset($ar['id'])) $this->id = intval($ar['id']);
		if (isset($ar['script_name'])) $this->script_name = $ar['script_name'];
		if (isset($ar['statu'])) $this->statu = intval($ar['statu']);
		if (isset($ar['run_time'])) $this->run_time = intval($ar['run_time']);
		
		
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
	
		$sql = "SELECT {$p} FROM `auto_run` WHERE {$where}";
	
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
    	if (!isset($this->script_name)){
    		$emptyFields = false;
    		$fields[] = 'script_name';
    	}else{
    		$emptyCondition = false; 
    		$condition['script_name']=$this->script_name;
    	}
    	if (!isset($this->statu)){
    		$emptyFields = false;
    		$fields[] = 'statu';
    	}else{
    		$emptyCondition = false; 
    		$condition['statu']=$this->statu;
    	}
    	if (!isset($this->run_time)){
    		$emptyFields = false;
    		$fields[] = 'run_time';
    	}else{
    		$emptyCondition = false; 
    		$condition['run_time']=$this->run_time;
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
		
		$sql = "DELETE FROM `auto_run` WHERE ".SQLUtil::parseCondition($condition);
		
		$qr = MySQL::getInstance()->RunQuery($sql);
				
		return (boolean)$qr;
	}
	
	public function  delete()
	{
		if (!isset($this->id))
		{
			return false;
		}
		
		$sql = "DELETE FROM `auto_run` WHERE `id`='{$this->id}'";
		
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
 			}else if($f == 'script_name'){
 				$values .= "'{$this->script_name}',";
 			}else if($f == 'statu'){
 				$values .= "'{$this->statu}',";
 			}else if($f == 'run_time'){
 				$values .= "'{$this->run_time}',";
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
		if (isset($this->script_name))
		{
			$fields .= "`script_name`,";
			$values .= "'{$this->script_name}',";
		}
		if (isset($this->statu))
		{
			$fields .= "`statu`,";
			$values .= "'{$this->statu}',";
		}
		if (isset($this->run_time))
		{
			$fields .= "`run_time`,";
			$values .= "'{$this->run_time}',";
		}

		
		$fields .= ")";
		$values .= ")";
		
		$sql = "INSERT INTO `auto_run` ".$fields.$values;
		
		return str_replace(",)",")",$sql);
	}
	
	private function  getUpFields()
	{
		$update = "";
		
		if ($this->script_name_status_field)
		{			
			if (!isset($this->script_name))
			{
				$update .= ("`script_name`=null,");
			}
			else
			{
				$update .= ("`script_name`='{$this->script_name}',");
			}
		}
		if ($this->statu_status_field)
		{			
			if (!isset($this->statu))
			{
				$update .= ("`statu`=null,");
			}
			else
			{
				$update .= ("`statu`='{$this->statu}',");
			}
		}
		if ($this->run_time_status_field)
		{			
			if (!isset($this->run_time))
			{
				$update .= ("`run_time`=null,");
			}
			else
			{
				$update .= ("`run_time`='{$this->run_time}',");
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
		
		$sql = "UPDATE `auto_run` SET {$update} WHERE {$condition}";
		
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
		
		$sql = "UPDATE `auto_run` SET {$update} WHERE {$uc}";
		
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
		
		$sql = "UPDATE `auto_run` SET {$update} WHERE {$uc}";
		
		MySQL::selectDefaultDb();
		$qr = MySQL::getInstance()->RunQuery($sql);
				
		return (boolean)$qr;
	}
	
	private function /*void*/ clean() 
	{
		$this->this_table_status_field = false;
		$this->id_status_field = false;
		$this->script_name_status_field = false;
		$this->statu_status_field = false;
		$this->run_time_status_field = false;

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

	public function /*string*/ getScriptName()
	{
		return $this->script_name;
	}
	
	public function /*void*/ setScriptName(/*string*/ $script_name)
	{
		$this->script_name = SQLUtil::toSafeSQLString($script_name);
		$this->script_name_status_field = true;		
		$this->this_table_status_field = true;		
	}

	public function /*void*/ setScriptNameNull()
	{
		$this->script_name = null;
		$this->script_name_status_field = true;		
		$this->this_table_status_field = true;
	}

	public function /*int*/ getStatu()
	{
		return $this->statu;
	}
	
	public function /*void*/ setStatu(/*int*/ $statu)
	{
		$this->statu = intval($statu);
		$this->statu_status_field = true;		
		$this->this_table_status_field = true;		
	}

	public function /*void*/ setStatuNull()
	{
		$this->statu = null;
		$this->statu_status_field = true;		
		$this->this_table_status_field = true;
	}

	public function /*int*/ getRunTime()
	{
		return $this->run_time;
	}
	
	public function /*void*/ setRunTime(/*int*/ $run_time)
	{
		$this->run_time = intval($run_time);
		$this->run_time_status_field = true;		
		$this->this_table_status_field = true;		
	}

	public function /*void*/ setRunTimeNull()
	{
		$this->run_time = null;
		$this->run_time_status_field = true;		
		$this->this_table_status_field = true;
	}

	
	public function /*string*/ toDebugString()
	{
		$dbg = "(";
		
		$dbg .= ("id={$this->id},");
		$dbg .= ("script_name={$this->script_name},");
		$dbg .= ("statu={$this->statu},");
		$dbg .= ("run_time={$this->run_time},");

		$dbg .= ")";
				
		return str_replace(",)",")",$dbg);
	}
}

?>
