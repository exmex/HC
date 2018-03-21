<?php
require_once ($GLOBALS ['GAME_ROOT'] . "CMySQL.php");
require_once ("SQLUtil.php");
/**
 *  [The generated files]
 */

class SysPlayerTask {
	
	private /*string*/ $id; //PRIMARY KEY 
	private /*string*/ $user_id;
	private /*int*/ $task_line;
	private /*int*/ $task_id;
	private /*int*/ $task_status;
	private /*int*/ $task_target;
	private /*int*/ $claim_reward_time;
	private /*int*/ $last_reset_time;

	
	private $this_table_status_field = false;
	private $id_status_field = false;
	private $user_id_status_field = false;
	private $task_line_status_field = false;
	private $task_id_status_field = false;
	private $task_status_status_field = false;
	private $task_target_status_field = false;
	private $claim_reward_time_status_field = false;
	private $last_reset_time_status_field = false;


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
			$sql = "SELECT {$p} FROM `player_task`";
		}
		else
		{			
			$sql = "SELECT {$p} FROM `player_task` WHERE ".SQLUtil::parseCondition($condition);
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
			$tb = new SysPlayerTask();			
			if (isset($row['id'])) $tb->id = $row['id'];
			if (isset($row['user_id'])) $tb->user_id = $row['user_id'];
			if (isset($row['task_line'])) $tb->task_line = intval($row['task_line']);
			if (isset($row['task_id'])) $tb->task_id = intval($row['task_id']);
			if (isset($row['task_status'])) $tb->task_status = intval($row['task_status']);
			if (isset($row['task_target'])) $tb->task_target = intval($row['task_target']);
			if (isset($row['claim_reward_time'])) $tb->claim_reward_time = intval($row['claim_reward_time']);
			if (isset($row['last_reset_time'])) $tb->last_reset_time = intval($row['last_reset_time']);
		
			$result[] = $tb;
		}
		
		return $result;
	}	
	
	public static function insertSqlHeader($fields=NULL)
	{
		$result = array();				
		if(!empty($fields)){
			$where = SQLUtil::parseFields($fields);			
			$result[0] = "INSERT INTO `player_task` ({$where}) VALUES ";	
			$ar = array();
			foreach($fields as $key){
				$ar[$key]=1;
			}
			$result[1] = $ar;
		}else{
			$result[0]="INSERT INTO `player_task` (`id`,`user_id`,`task_line`,`task_id`,`task_status`,`task_target`,`claim_reward_time`,`last_reset_time`) VALUES ";
			$result[1] = array('id'=>1,'user_id'=>1,'task_line'=>1,'task_id'=>1,'task_status'=>1,'task_target'=>1,'claim_reward_time'=>1,'last_reset_time'=>1);
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
		
		$sql = "SELECT {$p} FROM `player_task` WHERE {$where}";

		if(isset($this->user_id)){MySQL::selectDbForUser($this->user_id);}else{MySQL::selectDbForUser($GLOBALS['USER_ID']);}
		$qr = MySQL::getInstance()->RunQuery($sql);
		$ar = MySQL::getInstance()->FetchArray($qr);
		
		if (!$ar || count($ar)==0)
		{
			return false;
		}
		
		if (isset($ar['id'])) $this->id = $ar['id'];
		if (isset($ar['user_id'])) $this->user_id = $ar['user_id'];
		if (isset($ar['task_line'])) $this->task_line = intval($ar['task_line']);
		if (isset($ar['task_id'])) $this->task_id = intval($ar['task_id']);
		if (isset($ar['task_status'])) $this->task_status = intval($ar['task_status']);
		if (isset($ar['task_target'])) $this->task_target = intval($ar['task_target']);
		if (isset($ar['claim_reward_time'])) $this->claim_reward_time = intval($ar['claim_reward_time']);
		if (isset($ar['last_reset_time'])) $this->last_reset_time = intval($ar['last_reset_time']);
		
		
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
	
		$sql = "SELECT {$p} FROM `player_task` WHERE {$where}";
	
				if(isset($this->user_id)){MySQL::selectDbForUser($this->user_id);}else{MySQL::selectDbForUser($GLOBALS['USER_ID']);}
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
    	if (!isset($this->user_id)){
    		$emptyFields = false;
    		$fields[] = 'user_id';
    	}else{
    		$emptyCondition = false; 
    		$condition['user_id']=$this->user_id;
    	}
    	if (!isset($this->task_line)){
    		$emptyFields = false;
    		$fields[] = 'task_line';
    	}else{
    		$emptyCondition = false; 
    		$condition['task_line']=$this->task_line;
    	}
    	if (!isset($this->task_id)){
    		$emptyFields = false;
    		$fields[] = 'task_id';
    	}else{
    		$emptyCondition = false; 
    		$condition['task_id']=$this->task_id;
    	}
    	if (!isset($this->task_status)){
    		$emptyFields = false;
    		$fields[] = 'task_status';
    	}else{
    		$emptyCondition = false; 
    		$condition['task_status']=$this->task_status;
    	}
    	if (!isset($this->task_target)){
    		$emptyFields = false;
    		$fields[] = 'task_target';
    	}else{
    		$emptyCondition = false; 
    		$condition['task_target']=$this->task_target;
    	}
    	if (!isset($this->claim_reward_time)){
    		$emptyFields = false;
    		$fields[] = 'claim_reward_time';
    	}else{
    		$emptyCondition = false; 
    		$condition['claim_reward_time']=$this->claim_reward_time;
    	}
    	if (!isset($this->last_reset_time)){
    		$emptyFields = false;
    		$fields[] = 'last_reset_time';
    	}else{
    		$emptyCondition = false; 
    		$condition['last_reset_time']=$this->last_reset_time;
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
		
		if(isset($this->user_id)){MySQL::selectDbForUser($this->user_id);}else{MySQL::selectDbForUser($GLOBALS['USER_ID']);}
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
		
		if(isset($this->user_id)){MySQL::selectDbForUser($this->user_id);}else{MySQL::selectDbForUser($GLOBALS['USER_ID']);}

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
		
		$sql = "DELETE FROM `player_task` WHERE ".SQLUtil::parseCondition($condition);
		
		$qr = MySQL::getInstance()->RunQuery($sql);
				
		return (boolean)$qr;
	}
	
	public function  delete()
	{
		if (!isset($this->id))
		{
			return false;
		}
		
		$sql = "DELETE FROM `player_task` WHERE `id`='{$this->id}'";
		
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
 			}else if($f == 'task_line'){
 				$values .= "'{$this->task_line}',";
 			}else if($f == 'task_id'){
 				$values .= "'{$this->task_id}',";
 			}else if($f == 'task_status'){
 				$values .= "'{$this->task_status}',";
 			}else if($f == 'task_target'){
 				$values .= "'{$this->task_target}',";
 			}else if($f == 'claim_reward_time'){
 				$values .= "'{$this->claim_reward_time}',";
 			}else if($f == 'last_reset_time'){
 				$values .= "'{$this->last_reset_time}',";
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
		if (isset($this->user_id))
		{
			$fields .= "`user_id`,";
			$values .= "'{$this->user_id}',";
		}
		if (isset($this->task_line))
		{
			$fields .= "`task_line`,";
			$values .= "'{$this->task_line}',";
		}
		if (isset($this->task_id))
		{
			$fields .= "`task_id`,";
			$values .= "'{$this->task_id}',";
		}
		if (isset($this->task_status))
		{
			$fields .= "`task_status`,";
			$values .= "'{$this->task_status}',";
		}
		if (isset($this->task_target))
		{
			$fields .= "`task_target`,";
			$values .= "'{$this->task_target}',";
		}
		if (isset($this->claim_reward_time))
		{
			$fields .= "`claim_reward_time`,";
			$values .= "'{$this->claim_reward_time}',";
		}
		if (isset($this->last_reset_time))
		{
			$fields .= "`last_reset_time`,";
			$values .= "'{$this->last_reset_time}',";
		}

		
		$fields .= ")";
		$values .= ")";
		
		$sql = "INSERT INTO `player_task` ".$fields.$values;
		
		return str_replace(",)",")",$sql);
	}
	
	private function  getUpFields()
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
		if ($this->task_line_status_field)
		{			
			if (!isset($this->task_line))
			{
				$update .= ("`task_line`=null,");
			}
			else
			{
				$update .= ("`task_line`='{$this->task_line}',");
			}
		}
		if ($this->task_id_status_field)
		{			
			if (!isset($this->task_id))
			{
				$update .= ("`task_id`=null,");
			}
			else
			{
				$update .= ("`task_id`='{$this->task_id}',");
			}
		}
		if ($this->task_status_status_field)
		{			
			if (!isset($this->task_status))
			{
				$update .= ("`task_status`=null,");
			}
			else
			{
				$update .= ("`task_status`='{$this->task_status}',");
			}
		}
		if ($this->task_target_status_field)
		{			
			if (!isset($this->task_target))
			{
				$update .= ("`task_target`=null,");
			}
			else
			{
				$update .= ("`task_target`='{$this->task_target}',");
			}
		}
		if ($this->claim_reward_time_status_field)
		{			
			if (!isset($this->claim_reward_time))
			{
				$update .= ("`claim_reward_time`=null,");
			}
			else
			{
				$update .= ("`claim_reward_time`='{$this->claim_reward_time}',");
			}
		}
		if ($this->last_reset_time_status_field)
		{			
			if (!isset($this->last_reset_time))
			{
				$update .= ("`last_reset_time`=null,");
			}
			else
			{
				$update .= ("`last_reset_time`='{$this->last_reset_time}',");
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
		
		$sql = "UPDATE `player_task` SET {$update} WHERE {$condition}";
		
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
		
		$sql = "UPDATE `player_task` SET {$update} WHERE {$uc}";
		
		if(isset($this->user_id)){MySQL::selectDbForUser($this->user_id);}else{MySQL::selectDbForUser($GLOBALS['USER_ID']);}
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
		
		$sql = "UPDATE `player_task` SET {$update} WHERE {$uc}";
		
		if(isset($this->user_id)){MySQL::selectDbForUser($this->user_id);}else{MySQL::selectDbForUser($GLOBALS['USER_ID']);}
		$qr = MySQL::getInstance()->RunQuery($sql);
				
		return (boolean)$qr;
	}
	
	private function /*void*/ clean() 
	{
		$this->this_table_status_field = false;
		$this->id_status_field = false;
		$this->user_id_status_field = false;
		$this->task_line_status_field = false;
		$this->task_id_status_field = false;
		$this->task_status_status_field = false;
		$this->task_target_status_field = false;
		$this->claim_reward_time_status_field = false;
		$this->last_reset_time_status_field = false;

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

	public function /*int*/ getTaskLine()
	{
		return $this->task_line;
	}
	
	public function /*void*/ setTaskLine(/*int*/ $task_line)
	{
		$this->task_line = intval($task_line);
		$this->task_line_status_field = true;		
		$this->this_table_status_field = true;		
	}

	public function /*void*/ setTaskLineNull()
	{
		$this->task_line = null;
		$this->task_line_status_field = true;		
		$this->this_table_status_field = true;
	}

	public function /*int*/ getTaskId()
	{
		return $this->task_id;
	}
	
	public function /*void*/ setTaskId(/*int*/ $task_id)
	{
		$this->task_id = intval($task_id);
		$this->task_id_status_field = true;		
		$this->this_table_status_field = true;		
	}

	public function /*void*/ setTaskIdNull()
	{
		$this->task_id = null;
		$this->task_id_status_field = true;		
		$this->this_table_status_field = true;
	}

	public function /*int*/ getTaskStatus()
	{
		return $this->task_status;
	}
	
	public function /*void*/ setTaskStatus(/*int*/ $task_status)
	{
		$this->task_status = intval($task_status);
		$this->task_status_status_field = true;		
		$this->this_table_status_field = true;		
	}

	public function /*void*/ setTaskStatusNull()
	{
		$this->task_status = null;
		$this->task_status_status_field = true;		
		$this->this_table_status_field = true;
	}

	public function /*int*/ getTaskTarget()
	{
		return $this->task_target;
	}
	
	public function /*void*/ setTaskTarget(/*int*/ $task_target)
	{
		$this->task_target = intval($task_target);
		$this->task_target_status_field = true;		
		$this->this_table_status_field = true;		
	}

	public function /*void*/ setTaskTargetNull()
	{
		$this->task_target = null;
		$this->task_target_status_field = true;		
		$this->this_table_status_field = true;
	}

	public function /*int*/ getClaimRewardTime()
	{
		return $this->claim_reward_time;
	}
	
	public function /*void*/ setClaimRewardTime(/*int*/ $claim_reward_time)
	{
		$this->claim_reward_time = intval($claim_reward_time);
		$this->claim_reward_time_status_field = true;		
		$this->this_table_status_field = true;		
	}

	public function /*void*/ setClaimRewardTimeNull()
	{
		$this->claim_reward_time = null;
		$this->claim_reward_time_status_field = true;		
		$this->this_table_status_field = true;
	}

	public function /*int*/ getLastResetTime()
	{
		return $this->last_reset_time;
	}
	
	public function /*void*/ setLastResetTime(/*int*/ $last_reset_time)
	{
		$this->last_reset_time = intval($last_reset_time);
		$this->last_reset_time_status_field = true;		
		$this->this_table_status_field = true;		
	}

	public function /*void*/ setLastResetTimeNull()
	{
		$this->last_reset_time = null;
		$this->last_reset_time_status_field = true;		
		$this->this_table_status_field = true;
	}

	
	public function /*string*/ toDebugString()
	{
		$dbg = "(";
		
		$dbg .= ("id={$this->id},");
		$dbg .= ("user_id={$this->user_id},");
		$dbg .= ("task_line={$this->task_line},");
		$dbg .= ("task_id={$this->task_id},");
		$dbg .= ("task_status={$this->task_status},");
		$dbg .= ("task_target={$this->task_target},");
		$dbg .= ("claim_reward_time={$this->claim_reward_time},");
		$dbg .= ("last_reset_time={$this->last_reset_time},");

		$dbg .= ")";
				
		return str_replace(",)",")",$dbg);
	}
}

?>
