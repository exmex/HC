<?php
require_once ($GLOBALS ['GAME_ROOT'] . "CMySQL.php");
require_once ("SQLUtil.php");
/**
 *  [The generated files]
 */

class SysDailyTaskServer {
	
	private /*string*/ $id; //PRIMARY KEY 
	private /*int*/ $server_id;
	private /*string*/ $task;
	private /*int*/ $last_run_time;
	private /*int*/ $lock;

	
	private $this_table_status_field = false;
	private $id_status_field = false;
	private $server_id_status_field = false;
	private $task_status_field = false;
	private $last_run_time_status_field = false;
	private $lock_status_field = false;


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
			$sql = "SELECT {$p} FROM `daily_task_server`";
		}
		else
		{			
			$sql = "SELECT {$p} FROM `daily_task_server` WHERE ".SQLUtil::parseCondition($condition);
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
			$tb = new SysDailyTaskServer();			
			if (isset($row['id'])) $tb->id = $row['id'];
			if (isset($row['server_id'])) $tb->server_id = intval($row['server_id']);
			if (isset($row['task'])) $tb->task = $row['task'];
			if (isset($row['last_run_time'])) $tb->last_run_time = intval($row['last_run_time']);
			if (isset($row['lock'])) $tb->lock = intval($row['lock']);
		
			$result[] = $tb;
		}
		
		return $result;
	}	
	
	public static function insertSqlHeader($fields=NULL)
	{
		$result = array();				
		if(!empty($fields)){
			$where = SQLUtil::parseFields($fields);			
			$result[0] = "INSERT INTO `daily_task_server` ({$where}) VALUES ";	
			$ar = array();
			foreach($fields as $key){
				$ar[$key]=1;
			}
			$result[1] = $ar;
		}else{
			$result[0]="INSERT INTO `daily_task_server` (`id`,`server_id`,`task`,`last_run_time`,`lock`) VALUES ";
			$result[1] = array('id'=>1,'server_id'=>1,'task'=>1,'last_run_time'=>1,'lock'=>1);
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
		
		$sql = "SELECT {$p} FROM `daily_task_server` WHERE {$where}";

		MySQL::selectDefaultDb();
		$qr = MySQL::getInstance()->RunQuery($sql);
		$ar = MySQL::getInstance()->FetchArray($qr);
		
		if (!$ar || count($ar)==0)
		{
			return false;
		}
		
		if (isset($ar['id'])) $this->id = $ar['id'];
		if (isset($ar['server_id'])) $this->server_id = intval($ar['server_id']);
		if (isset($ar['task'])) $this->task = $ar['task'];
		if (isset($ar['last_run_time'])) $this->last_run_time = intval($ar['last_run_time']);
		if (isset($ar['lock'])) $this->lock = intval($ar['lock']);
		
		
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
	
		$sql = "SELECT {$p} FROM `daily_task_server` WHERE {$where}";
	
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
    	if (!isset($this->server_id)){
    		$emptyFields = false;
    		$fields[] = 'server_id';
    	}else{
    		$emptyCondition = false; 
    		$condition['server_id']=$this->server_id;
    	}
    	if (!isset($this->task)){
    		$emptyFields = false;
    		$fields[] = 'task';
    	}else{
    		$emptyCondition = false; 
    		$condition['task']=$this->task;
    	}
    	if (!isset($this->last_run_time)){
    		$emptyFields = false;
    		$fields[] = 'last_run_time';
    	}else{
    		$emptyCondition = false; 
    		$condition['last_run_time']=$this->last_run_time;
    	}
    	if (!isset($this->lock)){
    		$emptyFields = false;
    		$fields[] = 'lock';
    	}else{
    		$emptyCondition = false; 
    		$condition['lock']=$this->lock;
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
		
		$sql = "DELETE FROM `daily_task_server` WHERE ".SQLUtil::parseCondition($condition);
		
		$qr = MySQL::getInstance()->RunQuery($sql);
				
		return (boolean)$qr;
	}
	
	public function  delete()
	{
		if (!isset($this->id))
		{
			return false;
		}
		
		$sql = "DELETE FROM `daily_task_server` WHERE `id`='{$this->id}'";
		
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
 			}else if($f == 'server_id'){
 				$values .= "'{$this->server_id}',";
 			}else if($f == 'task'){
 				$values .= "'{$this->task}',";
 			}else if($f == 'last_run_time'){
 				$values .= "'{$this->last_run_time}',";
 			}else if($f == 'lock'){
 				$values .= "'{$this->lock}',";
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
		if (isset($this->server_id))
		{
			$fields .= "`server_id`,";
			$values .= "'{$this->server_id}',";
		}
		if (isset($this->task))
		{
			$fields .= "`task`,";
			$values .= "'{$this->task}',";
		}
		if (isset($this->last_run_time))
		{
			$fields .= "`last_run_time`,";
			$values .= "'{$this->last_run_time}',";
		}
		if (isset($this->lock))
		{
			$fields .= "`lock`,";
			$values .= "'{$this->lock}',";
		}

		
		$fields .= ")";
		$values .= ")";
		
		$sql = "INSERT INTO `daily_task_server` ".$fields.$values;
		
		return str_replace(",)",")",$sql);
	}
	
	private function  getUpFields()
	{
		$update = "";
		
		if ($this->server_id_status_field)
		{			
			if (!isset($this->server_id))
			{
				$update .= ("`server_id`=null,");
			}
			else
			{
				$update .= ("`server_id`='{$this->server_id}',");
			}
		}
		if ($this->task_status_field)
		{			
			if (!isset($this->task))
			{
				$update .= ("`task`=null,");
			}
			else
			{
				$update .= ("`task`='{$this->task}',");
			}
		}
		if ($this->last_run_time_status_field)
		{			
			if (!isset($this->last_run_time))
			{
				$update .= ("`last_run_time`=null,");
			}
			else
			{
				$update .= ("`last_run_time`='{$this->last_run_time}',");
			}
		}
		if ($this->lock_status_field)
		{			
			if (!isset($this->lock))
			{
				$update .= ("`lock`=null,");
			}
			else
			{
				$update .= ("`lock`='{$this->lock}',");
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
		
		$sql = "UPDATE `daily_task_server` SET {$update} WHERE {$condition}";
		
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
		
		$sql = "UPDATE `daily_task_server` SET {$update} WHERE {$uc}";
		
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
		
		$sql = "UPDATE `daily_task_server` SET {$update} WHERE {$uc}";
		
		MySQL::selectDefaultDb();
		$qr = MySQL::getInstance()->RunQuery($sql);
				
		return (boolean)$qr;
	}
	
	private function /*void*/ clean() 
	{
		$this->this_table_status_field = false;
		$this->id_status_field = false;
		$this->server_id_status_field = false;
		$this->task_status_field = false;
		$this->last_run_time_status_field = false;
		$this->lock_status_field = false;

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

	public function /*int*/ getServerId()
	{
		return $this->server_id;
	}
	
	public function /*void*/ setServerId(/*int*/ $server_id)
	{
		$this->server_id = intval($server_id);
		$this->server_id_status_field = true;		
		$this->this_table_status_field = true;		
	}

	public function /*void*/ setServerIdNull()
	{
		$this->server_id = null;
		$this->server_id_status_field = true;		
		$this->this_table_status_field = true;
	}

	public function /*string*/ getTask()
	{
		return $this->task;
	}
	
	public function /*void*/ setTask(/*string*/ $task)
	{
		$this->task = SQLUtil::toSafeSQLString($task);
		$this->task_status_field = true;		
		$this->this_table_status_field = true;		
	}

	public function /*void*/ setTaskNull()
	{
		$this->task = null;
		$this->task_status_field = true;		
		$this->this_table_status_field = true;
	}

	public function /*int*/ getLastRunTime()
	{
		return $this->last_run_time;
	}
	
	public function /*void*/ setLastRunTime(/*int*/ $last_run_time)
	{
		$this->last_run_time = intval($last_run_time);
		$this->last_run_time_status_field = true;		
		$this->this_table_status_field = true;		
	}

	public function /*void*/ setLastRunTimeNull()
	{
		$this->last_run_time = null;
		$this->last_run_time_status_field = true;		
		$this->this_table_status_field = true;
	}

	public function /*int*/ getLock()
	{
		return $this->lock;
	}
	
	public function /*void*/ setLock(/*int*/ $lock)
	{
		$this->lock = intval($lock);
		$this->lock_status_field = true;		
		$this->this_table_status_field = true;		
	}

	public function /*void*/ setLockNull()
	{
		$this->lock = null;
		$this->lock_status_field = true;		
		$this->this_table_status_field = true;
	}

	
	public function /*string*/ toDebugString()
	{
		$dbg = "(";
		
		$dbg .= ("id={$this->id},");
		$dbg .= ("server_id={$this->server_id},");
		$dbg .= ("task={$this->task},");
		$dbg .= ("last_run_time={$this->last_run_time},");
		$dbg .= ("lock={$this->lock},");

		$dbg .= ")";
				
		return str_replace(",)",")",$dbg);
	}
}

?>
