<?php
require_once ($GLOBALS ['GAME_ROOT'] . "CMySQL.php");
require_once ("SQLUtil.php");
/**
 *  [The generated files]
 */

class SysPlayerDailyLogin {
	
	private /*string*/ $user_id; //PRIMARY KEY 
	private /*int*/ $today_claim_status;
	private /*int*/ $cur_month_claim_times;
	private /*int*/ $last_claim_time;

	
	private $this_table_status_field = false;
	private $user_id_status_field = false;
	private $today_claim_status_status_field = false;
	private $cur_month_claim_times_status_field = false;
	private $last_claim_time_status_field = false;


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
			$sql = "SELECT {$p} FROM `player_daily_login`";
		}
		else
		{			
			$sql = "SELECT {$p} FROM `player_daily_login` WHERE ".SQLUtil::parseCondition($condition);
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
			$tb = new SysPlayerDailyLogin();			
			if (isset($row['user_id'])) $tb->user_id = $row['user_id'];
			if (isset($row['today_claim_status'])) $tb->today_claim_status = intval($row['today_claim_status']);
			if (isset($row['cur_month_claim_times'])) $tb->cur_month_claim_times = intval($row['cur_month_claim_times']);
			if (isset($row['last_claim_time'])) $tb->last_claim_time = intval($row['last_claim_time']);
		
			$result[] = $tb;
		}
		
		return $result;
	}	
	
	public static function insertSqlHeader($fields=NULL)
	{
		$result = array();				
		if(!empty($fields)){
			$where = SQLUtil::parseFields($fields);			
			$result[0] = "INSERT INTO `player_daily_login` ({$where}) VALUES ";	
			$ar = array();
			foreach($fields as $key){
				$ar[$key]=1;
			}
			$result[1] = $ar;
		}else{
			$result[0]="INSERT INTO `player_daily_login` (`user_id`,`today_claim_status`,`cur_month_claim_times`,`last_claim_time`) VALUES ";
			$result[1] = array('user_id'=>1,'today_claim_status'=>1,'cur_month_claim_times'=>1,'last_claim_time'=>1);
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
		
		$sql = "SELECT {$p} FROM `player_daily_login` WHERE {$where}";

		if(isset($this->user_id)){MySQL::selectDbForUser($this->user_id);}else{MySQL::selectDbForUser($GLOBALS['USER_ID']);}
		$qr = MySQL::getInstance()->RunQuery($sql);
		$ar = MySQL::getInstance()->FetchArray($qr);
		
		if (!$ar || count($ar)==0)
		{
			return false;
		}
		
		if (isset($ar['user_id'])) $this->user_id = $ar['user_id'];
		if (isset($ar['today_claim_status'])) $this->today_claim_status = intval($ar['today_claim_status']);
		if (isset($ar['cur_month_claim_times'])) $this->cur_month_claim_times = intval($ar['cur_month_claim_times']);
		if (isset($ar['last_claim_time'])) $this->last_claim_time = intval($ar['last_claim_time']);
		
		
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
	
		$sql = "SELECT {$p} FROM `player_daily_login` WHERE {$where}";
	
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
    	if (!isset($this->today_claim_status)){
    		$emptyFields = false;
    		$fields[] = 'today_claim_status';
    	}else{
    		$emptyCondition = false; 
    		$condition['today_claim_status']=$this->today_claim_status;
    	}
    	if (!isset($this->cur_month_claim_times)){
    		$emptyFields = false;
    		$fields[] = 'cur_month_claim_times';
    	}else{
    		$emptyCondition = false; 
    		$condition['cur_month_claim_times']=$this->cur_month_claim_times;
    	}
    	if (!isset($this->last_claim_time)){
    		$emptyFields = false;
    		$fields[] = 'last_claim_time';
    	}else{
    		$emptyCondition = false; 
    		$condition['last_claim_time']=$this->last_claim_time;
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
		
		$sql = "DELETE FROM `player_daily_login` WHERE ".SQLUtil::parseCondition($condition);
		
		$qr = MySQL::getInstance()->RunQuery($sql);
				
		return (boolean)$qr;
	}
	
	public function  delete()
	{
		if (!isset($this->user_id))
		{
			return false;
		}
		
		$sql = "DELETE FROM `player_daily_login` WHERE `user_id`='{$this->user_id}'";
		
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
 			}else if($f == 'today_claim_status'){
 				$values .= "'{$this->today_claim_status}',";
 			}else if($f == 'cur_month_claim_times'){
 				$values .= "'{$this->cur_month_claim_times}',";
 			}else if($f == 'last_claim_time'){
 				$values .= "'{$this->last_claim_time}',";
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
		if (isset($this->today_claim_status))
		{
			$fields .= "`today_claim_status`,";
			$values .= "'{$this->today_claim_status}',";
		}
		if (isset($this->cur_month_claim_times))
		{
			$fields .= "`cur_month_claim_times`,";
			$values .= "'{$this->cur_month_claim_times}',";
		}
		if (isset($this->last_claim_time))
		{
			$fields .= "`last_claim_time`,";
			$values .= "'{$this->last_claim_time}',";
		}

		
		$fields .= ")";
		$values .= ")";
		
		$sql = "INSERT INTO `player_daily_login` ".$fields.$values;
		
		return str_replace(",)",")",$sql);
	}
	
	private function  getUpFields()
	{
		$update = "";
		
		if ($this->today_claim_status_status_field)
		{			
			if (!isset($this->today_claim_status))
			{
				$update .= ("`today_claim_status`=null,");
			}
			else
			{
				$update .= ("`today_claim_status`='{$this->today_claim_status}',");
			}
		}
		if ($this->cur_month_claim_times_status_field)
		{			
			if (!isset($this->cur_month_claim_times))
			{
				$update .= ("`cur_month_claim_times`=null,");
			}
			else
			{
				$update .= ("`cur_month_claim_times`='{$this->cur_month_claim_times}',");
			}
		}
		if ($this->last_claim_time_status_field)
		{			
			if (!isset($this->last_claim_time))
			{
				$update .= ("`last_claim_time`=null,");
			}
			else
			{
				$update .= ("`last_claim_time`='{$this->last_claim_time}',");
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
		
		$sql = "UPDATE `player_daily_login` SET {$update} WHERE {$condition}";
		
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
		
		$sql = "UPDATE `player_daily_login` SET {$update} WHERE {$uc}";
		
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
		
		$sql = "UPDATE `player_daily_login` SET {$update} WHERE {$uc}";
		
		if(isset($this->user_id)){MySQL::selectDbForUser($this->user_id);}else{MySQL::selectDbForUser($GLOBALS['USER_ID']);}
		$qr = MySQL::getInstance()->RunQuery($sql);
				
		return (boolean)$qr;
	}
	
	private function /*void*/ clean() 
	{
		$this->this_table_status_field = false;
		$this->user_id_status_field = false;
		$this->today_claim_status_status_field = false;
		$this->cur_month_claim_times_status_field = false;
		$this->last_claim_time_status_field = false;

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

	public function /*int*/ getTodayClaimStatus()
	{
		return $this->today_claim_status;
	}
	
	public function /*void*/ setTodayClaimStatus(/*int*/ $today_claim_status)
	{
		$this->today_claim_status = intval($today_claim_status);
		$this->today_claim_status_status_field = true;		
		$this->this_table_status_field = true;		
	}

	public function /*void*/ setTodayClaimStatusNull()
	{
		$this->today_claim_status = null;
		$this->today_claim_status_status_field = true;		
		$this->this_table_status_field = true;
	}

	public function /*int*/ getCurMonthClaimTimes()
	{
		return $this->cur_month_claim_times;
	}
	
	public function /*void*/ setCurMonthClaimTimes(/*int*/ $cur_month_claim_times)
	{
		$this->cur_month_claim_times = intval($cur_month_claim_times);
		$this->cur_month_claim_times_status_field = true;		
		$this->this_table_status_field = true;		
	}

	public function /*void*/ setCurMonthClaimTimesNull()
	{
		$this->cur_month_claim_times = null;
		$this->cur_month_claim_times_status_field = true;		
		$this->this_table_status_field = true;
	}

	public function /*int*/ getLastClaimTime()
	{
		return $this->last_claim_time;
	}
	
	public function /*void*/ setLastClaimTime(/*int*/ $last_claim_time)
	{
		$this->last_claim_time = intval($last_claim_time);
		$this->last_claim_time_status_field = true;		
		$this->this_table_status_field = true;		
	}

	public function /*void*/ setLastClaimTimeNull()
	{
		$this->last_claim_time = null;
		$this->last_claim_time_status_field = true;		
		$this->this_table_status_field = true;
	}

	
	public function /*string*/ toDebugString()
	{
		$dbg = "(";
		
		$dbg .= ("user_id={$this->user_id},");
		$dbg .= ("today_claim_status={$this->today_claim_status},");
		$dbg .= ("cur_month_claim_times={$this->cur_month_claim_times},");
		$dbg .= ("last_claim_time={$this->last_claim_time},");

		$dbg .= ")";
				
		return str_replace(",)",")",$dbg);
	}
}

?>
