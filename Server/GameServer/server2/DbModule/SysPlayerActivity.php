<?php
require_once ($GLOBALS ['GAME_ROOT'] . "CMySQL.php");
require_once ("SQLUtil.php");
/**
 *  [The generated files]
 */

class SysPlayerActivity {
	
	private /*string*/ $user_id; //PRIMARY KEY 
	private /*int*/ $time_zone;
	private /*int*/ $last_login_reward_time;
	private /*string*/ $cost_gem; //total num
	private /*int*/ $last_cost_gem_time; //last cost time

	
	private $this_table_status_field = false;
	private $user_id_status_field = false;
	private $time_zone_status_field = false;
	private $last_login_reward_time_status_field = false;
	private $cost_gem_status_field = false;
	private $last_cost_gem_time_status_field = false;


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
			$sql = "SELECT {$p} FROM `player_activity`";
		}
		else
		{			
			$sql = "SELECT {$p} FROM `player_activity` WHERE ".SQLUtil::parseCondition($condition);
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
			$tb = new SysPlayerActivity();			
			if (isset($row['user_id'])) $tb->user_id = $row['user_id'];
			if (isset($row['time_zone'])) $tb->time_zone = intval($row['time_zone']);
			if (isset($row['last_login_reward_time'])) $tb->last_login_reward_time = intval($row['last_login_reward_time']);
			if (isset($row['cost_gem'])) $tb->cost_gem = $row['cost_gem'];
			if (isset($row['last_cost_gem_time'])) $tb->last_cost_gem_time = intval($row['last_cost_gem_time']);
		
			$result[] = $tb;
		}
		
		return $result;
	}	
	
	public static function insertSqlHeader($fields=NULL)
	{
		$result = array();				
		if(!empty($fields)){
			$where = SQLUtil::parseFields($fields);			
			$result[0] = "INSERT INTO `player_activity` ({$where}) VALUES ";	
			$ar = array();
			foreach($fields as $key){
				$ar[$key]=1;
			}
			$result[1] = $ar;
		}else{
			$result[0]="INSERT INTO `player_activity` (`user_id`,`time_zone`,`last_login_reward_time`,`cost_gem`,`last_cost_gem_time`) VALUES ";
			$result[1] = array('user_id'=>1,'time_zone'=>1,'last_login_reward_time'=>1,'cost_gem'=>1,'last_cost_gem_time'=>1);
		}				
		return $result;
	}
		
	public function  loaded( $fields=NULL,$condition=NULL)
	{

		if (empty($condition) && empty($this->user_id))
		{
			return false;
		}
		
		$p = "*";
		$where = "`user_id` = '{$this->user_id}'";
		
		if(!empty($fields))
		{
			$p = SQLUtil::parseFields($fields);			
		}
	    if (!empty($condition))
		{
			$where =SQLUtil::parseCondition($condition);
		}
		
		$sql = "SELECT {$p} FROM `player_activity` WHERE {$where}";

		if(isset($this->user_id)){MySQL::selectDbForUser($this->user_id);}else{MySQL::selectDbForUser($GLOBALS['USER_ID']);}
		$qr = MySQL::getInstance()->RunQuery($sql);
		$ar = MySQL::getInstance()->FetchArray($qr);
		
		if (!$ar || count($ar)==0)
		{
			return false;
		}
		
		if (isset($ar['user_id'])) $this->user_id = $ar['user_id'];
		if (isset($ar['time_zone'])) $this->time_zone = intval($ar['time_zone']);
		if (isset($ar['last_login_reward_time'])) $this->last_login_reward_time = intval($ar['last_login_reward_time']);
		if (isset($ar['cost_gem'])) $this->cost_gem = $ar['cost_gem'];
		if (isset($ar['last_cost_gem_time'])) $this->last_cost_gem_time = intval($ar['last_cost_gem_time']);
		
		
		$this->clean();
		
		return true;
	}
	
	
	public function  loadedCount( $fields=NULL,$condition=NULL)
	{
	
		if (empty($condition) && empty($this->user_id))
		{
			return false;
		}
	
		$p = "*";
		$where = "`user_id` = '{$this->user_id}'";
	
		if(!empty($fields))
		{
			$p = SQLUtil::parseFields($fields);
		}
		if (!empty($condition))
		{
			$where =SQLUtil::parseCondition($condition);
		}
	
		$sql = "SELECT {$p} FROM `player_activity` WHERE {$where}";
	
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
    	
    	if (!isset($this->user_id)){
    		$emptyFields = false;
    		$fields[] = 'user_id';
    	}else{
    		$emptyCondition = false; 
    		$condition['user_id']=$this->user_id;
    	}
    	if (!isset($this->time_zone)){
    		$emptyFields = false;
    		$fields[] = 'time_zone';
    	}else{
    		$emptyCondition = false; 
    		$condition['time_zone']=$this->time_zone;
    	}
    	if (!isset($this->last_login_reward_time)){
    		$emptyFields = false;
    		$fields[] = 'last_login_reward_time';
    	}else{
    		$emptyCondition = false; 
    		$condition['last_login_reward_time']=$this->last_login_reward_time;
    	}
    	if (!isset($this->cost_gem)){
    		$emptyFields = false;
    		$fields[] = 'cost_gem';
    	}else{
    		$emptyCondition = false; 
    		$condition['cost_gem']=$this->cost_gem;
    	}
    	if (!isset($this->last_cost_gem_time)){
    		$emptyFields = false;
    		$fields[] = 'last_cost_gem_time';
    	}else{
    		$emptyCondition = false; 
    		$condition['last_cost_gem_time']=$this->last_cost_gem_time;
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
				
		if (empty($this->user_id))
		{
			$this->user_id = MySQL::getInstance()->GetInsertId();
		}		
		
		$this->clean();
		
		return true;	
		
	}
	
	public function save($condition=NULL)
	{
		if (empty($condition))
		{
			$uc = "`user_id`='{$this->user_id}'";
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
		
		$sql = "DELETE FROM `player_activity` WHERE ".SQLUtil::parseCondition($condition);
		
		$qr = MySQL::getInstance()->RunQuery($sql);
				
		return (boolean)$qr;
	}
	
	public function  delete()
	{
		if (!isset($this->user_id))
		{
			return false;
		}
		
		$sql = "DELETE FROM `player_activity` WHERE `user_id`='{$this->user_id}'";
		
		if(isset($this->user_id)){MySQL::selectDbForUser($this->user_id);}else{MySQL::selectDbForUser($GLOBALS['USER_ID']);}
		$qr = MySQL::getInstance()->RunQuery($sql);
				
		return (boolean)$qr;
	}
	
	public function getInsertValue($fields)
	{
		$values = "(";		
		foreach($fields as $f => $k){
			if($f == 'user_id'){
 				$values .= "'{$this->user_id}',";
 			}else if($f == 'time_zone'){
 				$values .= "'{$this->time_zone}',";
 			}else if($f == 'last_login_reward_time'){
 				$values .= "'{$this->last_login_reward_time}',";
 			}else if($f == 'cost_gem'){
 				$values .= "'{$this->cost_gem}',";
 			}else if($f == 'last_cost_gem_time'){
 				$values .= "'{$this->last_cost_gem_time}',";
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

		if (isset($this->user_id))
		{
			$fields .= "`user_id`,";
			$values .= "'{$this->user_id}',";
		}
		if (isset($this->time_zone))
		{
			$fields .= "`time_zone`,";
			$values .= "'{$this->time_zone}',";
		}
		if (isset($this->last_login_reward_time))
		{
			$fields .= "`last_login_reward_time`,";
			$values .= "'{$this->last_login_reward_time}',";
		}
		if (isset($this->cost_gem))
		{
			$fields .= "`cost_gem`,";
			$values .= "'{$this->cost_gem}',";
		}
		if (isset($this->last_cost_gem_time))
		{
			$fields .= "`last_cost_gem_time`,";
			$values .= "'{$this->last_cost_gem_time}',";
		}

		
		$fields .= ")";
		$values .= ")";
		
		$sql = "INSERT INTO `player_activity` ".$fields.$values;
		
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
		if ($this->last_login_reward_time_status_field)
		{			
			if (!isset($this->last_login_reward_time))
			{
				$update .= ("`last_login_reward_time`=null,");
			}
			else
			{
				$update .= ("`last_login_reward_time`='{$this->last_login_reward_time}',");
			}
		}
		if ($this->cost_gem_status_field)
		{			
			if (!isset($this->cost_gem))
			{
				$update .= ("`cost_gem`=null,");
			}
			else
			{
				$update .= ("`cost_gem`='{$this->cost_gem}',");
			}
		}
		if ($this->last_cost_gem_time_status_field)
		{			
			if (!isset($this->last_cost_gem_time))
			{
				$update .= ("`last_cost_gem_time`=null,");
			}
			else
			{
				$update .= ("`last_cost_gem_time`='{$this->last_cost_gem_time}',");
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
		
		$sql = "UPDATE `player_activity` SET {$update} WHERE {$condition}";
		
		return $sql;
	}
	
	public function  add($fieldsValue,$condition=NULL)
	{				
		if (empty($condition))
		{
			$uc = "`user_id`='{$this->user_id}'";
		}
		else
		{			
			$uc = SQLUtil::parseCondition($condition);
		}
		
		$update = SQLUtil::parseASFieldValues($fieldsValue);
		
		$sql = "UPDATE `player_activity` SET {$update} WHERE {$uc}";
		
		if(isset($this->user_id)){MySQL::selectDbForUser($this->user_id);}else{MySQL::selectDbForUser($GLOBALS['USER_ID']);}
		$qr = MySQL::getInstance()->RunQuery($sql);
				
		return (boolean)$qr;
	}	
	
	public function sub($fieldsVal,$condition=NULL)
	{
		if (empty($condition))
		{
			$uc = "`user_id`='{$this->user_id}'";
		}
		else
		{			
			$uc = SQLUtil::parseCondition($condition);
		}
		
		$update = SQLUtil::parseASFieldValues($fieldsVal,false);
		
		$sql = "UPDATE `player_activity` SET {$update} WHERE {$uc}";
		
		if(isset($this->user_id)){MySQL::selectDbForUser($this->user_id);}else{MySQL::selectDbForUser($GLOBALS['USER_ID']);}
		$qr = MySQL::getInstance()->RunQuery($sql);
				
		return (boolean)$qr;
	}
	
	private function /*void*/ clean() 
	{
		$this->this_table_status_field = false;
		$this->user_id_status_field = false;
		$this->time_zone_status_field = false;
		$this->last_login_reward_time_status_field = false;
		$this->cost_gem_status_field = false;
		$this->last_cost_gem_time_status_field = false;

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

	public function /*int*/ getTimeZone()
	{
		return $this->time_zone;
	}
	
	public function /*void*/ setTimeZone(/*int*/ $time_zone)
	{
		$this->time_zone = intval($time_zone);
		$this->time_zone_status_field = true;		
		$this->this_table_status_field = true;		
	}

	public function /*void*/ setTimeZoneNull()
	{
		$this->time_zone = null;
		$this->time_zone_status_field = true;		
		$this->this_table_status_field = true;
	}

	public function /*int*/ getLastLoginRewardTime()
	{
		return $this->last_login_reward_time;
	}
	
	public function /*void*/ setLastLoginRewardTime(/*int*/ $last_login_reward_time)
	{
		$this->last_login_reward_time = intval($last_login_reward_time);
		$this->last_login_reward_time_status_field = true;		
		$this->this_table_status_field = true;		
	}

	public function /*void*/ setLastLoginRewardTimeNull()
	{
		$this->last_login_reward_time = null;
		$this->last_login_reward_time_status_field = true;		
		$this->this_table_status_field = true;
	}

	public function /*string*/ getCostGem()
	{
		return $this->cost_gem;
	}
	
	public function /*void*/ setCostGem(/*string*/ $cost_gem)
	{
		$this->cost_gem = SQLUtil::toSafeSQLString($cost_gem);
		$this->cost_gem_status_field = true;		
		$this->this_table_status_field = true;		
	}

	public function /*void*/ setCostGemNull()
	{
		$this->cost_gem = null;
		$this->cost_gem_status_field = true;		
		$this->this_table_status_field = true;
	}

	public function /*int*/ getLastCostGemTime()
	{
		return $this->last_cost_gem_time;
	}
	
	public function /*void*/ setLastCostGemTime(/*int*/ $last_cost_gem_time)
	{
		$this->last_cost_gem_time = intval($last_cost_gem_time);
		$this->last_cost_gem_time_status_field = true;		
		$this->this_table_status_field = true;		
	}

	public function /*void*/ setLastCostGemTimeNull()
	{
		$this->last_cost_gem_time = null;
		$this->last_cost_gem_time_status_field = true;		
		$this->this_table_status_field = true;
	}

	
	public function /*string*/ toDebugString()
	{
		$dbg = "(";
		
		$dbg .= ("user_id={$this->user_id},");
		$dbg .= ("time_zone={$this->time_zone},");
		$dbg .= ("last_login_reward_time={$this->last_login_reward_time},");
		$dbg .= ("cost_gem={$this->cost_gem},");
		$dbg .= ("last_cost_gem_time={$this->last_cost_gem_time},");

		$dbg .= ")";
				
		return str_replace(",)",")",$dbg);
	}
}

?>
