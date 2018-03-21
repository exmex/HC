<?php
require_once ($GLOBALS ['GAME_ROOT'] . "CMySQL.php");
require_once ("SQLUtil.php");
/**
 *  [The generated files]
 */

class SysPlayerVip {
	
	private /*string*/ $user_id; //PRIMARY KEY 
	private /*int*/ $vip;
	private /*int*/ $recharge;
	private /*string*/ $recharge_limit;
	private /*int*/ $first_pay_reward;
	private /*int*/ $activity_day;
	private /*string*/ $activity_desc;

	
	private $this_table_status_field = false;
	private $user_id_status_field = false;
	private $vip_status_field = false;
	private $recharge_status_field = false;
	private $recharge_limit_status_field = false;
	private $first_pay_reward_status_field = false;
	private $activity_day_status_field = false;
	private $activity_desc_status_field = false;


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
			$sql = "SELECT {$p} FROM `player_vip`";
		}
		else
		{			
			$sql = "SELECT {$p} FROM `player_vip` WHERE ".SQLUtil::parseCondition($condition);
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
			$tb = new SysPlayerVip();			
			if (isset($row['user_id'])) $tb->user_id = $row['user_id'];
			if (isset($row['vip'])) $tb->vip = intval($row['vip']);
			if (isset($row['recharge'])) $tb->recharge = intval($row['recharge']);
			if (isset($row['recharge_limit'])) $tb->recharge_limit = $row['recharge_limit'];
			if (isset($row['first_pay_reward'])) $tb->first_pay_reward = intval($row['first_pay_reward']);
			if (isset($row['activity_day'])) $tb->activity_day = intval($row['activity_day']);
			if (isset($row['activity_desc'])) $tb->activity_desc = $row['activity_desc'];
		
			$result[] = $tb;
		}
		
		return $result;
	}	
	
	public static function insertSqlHeader($fields=NULL)
	{
		$result = array();				
		if(!empty($fields)){
			$where = SQLUtil::parseFields($fields);			
			$result[0] = "INSERT INTO `player_vip` ({$where}) VALUES ";	
			$ar = array();
			foreach($fields as $key){
				$ar[$key]=1;
			}
			$result[1] = $ar;
		}else{
			$result[0]="INSERT INTO `player_vip` (`user_id`,`vip`,`recharge`,`recharge_limit`,`first_pay_reward`,`activity_day`,`activity_desc`) VALUES ";
			$result[1] = array('user_id'=>1,'vip'=>1,'recharge'=>1,'recharge_limit'=>1,'first_pay_reward'=>1,'activity_day'=>1,'activity_desc'=>1);
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
		
		$sql = "SELECT {$p} FROM `player_vip` WHERE {$where}";

		if(isset($this->user_id)){MySQL::selectDbForUser($this->user_id);}else{MySQL::selectDbForUser($GLOBALS['USER_ID']);}
		$qr = MySQL::getInstance()->RunQuery($sql);
		$ar = MySQL::getInstance()->FetchArray($qr);
		
		if (!$ar || count($ar)==0)
		{
			return false;
		}
		
		if (isset($ar['user_id'])) $this->user_id = $ar['user_id'];
		if (isset($ar['vip'])) $this->vip = intval($ar['vip']);
		if (isset($ar['recharge'])) $this->recharge = intval($ar['recharge']);
		if (isset($ar['recharge_limit'])) $this->recharge_limit = $ar['recharge_limit'];
		if (isset($ar['first_pay_reward'])) $this->first_pay_reward = intval($ar['first_pay_reward']);
		if (isset($ar['activity_day'])) $this->activity_day = intval($ar['activity_day']);
		if (isset($ar['activity_desc'])) $this->activity_desc = $ar['activity_desc'];
		
		
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
	
		$sql = "SELECT {$p} FROM `player_vip` WHERE {$where}";
	
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
    	if (!isset($this->vip)){
    		$emptyFields = false;
    		$fields[] = 'vip';
    	}else{
    		$emptyCondition = false; 
    		$condition['vip']=$this->vip;
    	}
    	if (!isset($this->recharge)){
    		$emptyFields = false;
    		$fields[] = 'recharge';
    	}else{
    		$emptyCondition = false; 
    		$condition['recharge']=$this->recharge;
    	}
    	if (!isset($this->recharge_limit)){
    		$emptyFields = false;
    		$fields[] = 'recharge_limit';
    	}else{
    		$emptyCondition = false; 
    		$condition['recharge_limit']=$this->recharge_limit;
    	}
    	if (!isset($this->first_pay_reward)){
    		$emptyFields = false;
    		$fields[] = 'first_pay_reward';
    	}else{
    		$emptyCondition = false; 
    		$condition['first_pay_reward']=$this->first_pay_reward;
    	}
    	if (!isset($this->activity_day)){
    		$emptyFields = false;
    		$fields[] = 'activity_day';
    	}else{
    		$emptyCondition = false; 
    		$condition['activity_day']=$this->activity_day;
    	}
    	if (!isset($this->activity_desc)){
    		$emptyFields = false;
    		$fields[] = 'activity_desc';
    	}else{
    		$emptyCondition = false; 
    		$condition['activity_desc']=$this->activity_desc;
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
		
		$sql = "DELETE FROM `player_vip` WHERE ".SQLUtil::parseCondition($condition);
		
		$qr = MySQL::getInstance()->RunQuery($sql);
				
		return (boolean)$qr;
	}
	
	public function  delete()
	{
		if (!isset($this->user_id))
		{
			return false;
		}
		
		$sql = "DELETE FROM `player_vip` WHERE `user_id`='{$this->user_id}'";
		
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
 			}else if($f == 'vip'){
 				$values .= "'{$this->vip}',";
 			}else if($f == 'recharge'){
 				$values .= "'{$this->recharge}',";
 			}else if($f == 'recharge_limit'){
 				$values .= "'{$this->recharge_limit}',";
 			}else if($f == 'first_pay_reward'){
 				$values .= "'{$this->first_pay_reward}',";
 			}else if($f == 'activity_day'){
 				$values .= "'{$this->activity_day}',";
 			}else if($f == 'activity_desc'){
 				$values .= "'{$this->activity_desc}',";
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
		if (isset($this->vip))
		{
			$fields .= "`vip`,";
			$values .= "'{$this->vip}',";
		}
		if (isset($this->recharge))
		{
			$fields .= "`recharge`,";
			$values .= "'{$this->recharge}',";
		}
		if (isset($this->recharge_limit))
		{
			$fields .= "`recharge_limit`,";
			$values .= "'{$this->recharge_limit}',";
		}
		if (isset($this->first_pay_reward))
		{
			$fields .= "`first_pay_reward`,";
			$values .= "'{$this->first_pay_reward}',";
		}
		if (isset($this->activity_day))
		{
			$fields .= "`activity_day`,";
			$values .= "'{$this->activity_day}',";
		}
		if (isset($this->activity_desc))
		{
			$fields .= "`activity_desc`,";
			$values .= "'{$this->activity_desc}',";
		}

		
		$fields .= ")";
		$values .= ")";
		
		$sql = "INSERT INTO `player_vip` ".$fields.$values;
		
		return str_replace(",)",")",$sql);
	}
	
	private function  getUpFields()
	{
		$update = "";
		
		if ($this->vip_status_field)
		{			
			if (!isset($this->vip))
			{
				$update .= ("`vip`=null,");
			}
			else
			{
				$update .= ("`vip`='{$this->vip}',");
			}
		}
		if ($this->recharge_status_field)
		{			
			if (!isset($this->recharge))
			{
				$update .= ("`recharge`=null,");
			}
			else
			{
				$update .= ("`recharge`='{$this->recharge}',");
			}
		}
		if ($this->recharge_limit_status_field)
		{			
			if (!isset($this->recharge_limit))
			{
				$update .= ("`recharge_limit`=null,");
			}
			else
			{
				$update .= ("`recharge_limit`='{$this->recharge_limit}',");
			}
		}
		if ($this->first_pay_reward_status_field)
		{			
			if (!isset($this->first_pay_reward))
			{
				$update .= ("`first_pay_reward`=null,");
			}
			else
			{
				$update .= ("`first_pay_reward`='{$this->first_pay_reward}',");
			}
		}
		if ($this->activity_day_status_field)
		{			
			if (!isset($this->activity_day))
			{
				$update .= ("`activity_day`=null,");
			}
			else
			{
				$update .= ("`activity_day`='{$this->activity_day}',");
			}
		}
		if ($this->activity_desc_status_field)
		{			
			if (!isset($this->activity_desc))
			{
				$update .= ("`activity_desc`=null,");
			}
			else
			{
				$update .= ("`activity_desc`='{$this->activity_desc}',");
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
		
		$sql = "UPDATE `player_vip` SET {$update} WHERE {$condition}";
		
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
		
		$sql = "UPDATE `player_vip` SET {$update} WHERE {$uc}";
		
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
		
		$sql = "UPDATE `player_vip` SET {$update} WHERE {$uc}";
		
		if(isset($this->user_id)){MySQL::selectDbForUser($this->user_id);}else{MySQL::selectDbForUser($GLOBALS['USER_ID']);}
		$qr = MySQL::getInstance()->RunQuery($sql);
				
		return (boolean)$qr;
	}
	
	private function /*void*/ clean() 
	{
		$this->this_table_status_field = false;
		$this->user_id_status_field = false;
		$this->vip_status_field = false;
		$this->recharge_status_field = false;
		$this->recharge_limit_status_field = false;
		$this->first_pay_reward_status_field = false;
		$this->activity_day_status_field = false;
		$this->activity_desc_status_field = false;

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

	public function /*int*/ getVip()
	{
		return $this->vip;
	}
	
	public function /*void*/ setVip(/*int*/ $vip)
	{
		$this->vip = intval($vip);
		$this->vip_status_field = true;		
		$this->this_table_status_field = true;		
	}

	public function /*void*/ setVipNull()
	{
		$this->vip = null;
		$this->vip_status_field = true;		
		$this->this_table_status_field = true;
	}

	public function /*int*/ getRecharge()
	{
		return $this->recharge;
	}
	
	public function /*void*/ setRecharge(/*int*/ $recharge)
	{
		$this->recharge = intval($recharge);
		$this->recharge_status_field = true;		
		$this->this_table_status_field = true;		
	}

	public function /*void*/ setRechargeNull()
	{
		$this->recharge = null;
		$this->recharge_status_field = true;		
		$this->this_table_status_field = true;
	}

	public function /*string*/ getRechargeLimit()
	{
		return $this->recharge_limit;
	}
	
	public function /*void*/ setRechargeLimit(/*string*/ $recharge_limit)
	{
		$this->recharge_limit = SQLUtil::toSafeSQLString($recharge_limit);
		$this->recharge_limit_status_field = true;		
		$this->this_table_status_field = true;		
	}

	public function /*void*/ setRechargeLimitNull()
	{
		$this->recharge_limit = null;
		$this->recharge_limit_status_field = true;		
		$this->this_table_status_field = true;
	}

	public function /*int*/ getFirstPayReward()
	{
		return $this->first_pay_reward;
	}
	
	public function /*void*/ setFirstPayReward(/*int*/ $first_pay_reward)
	{
		$this->first_pay_reward = intval($first_pay_reward);
		$this->first_pay_reward_status_field = true;		
		$this->this_table_status_field = true;		
	}

	public function /*void*/ setFirstPayRewardNull()
	{
		$this->first_pay_reward = null;
		$this->first_pay_reward_status_field = true;		
		$this->this_table_status_field = true;
	}

	public function /*int*/ getActivityDay()
	{
		return $this->activity_day;
	}
	
	public function /*void*/ setActivityDay(/*int*/ $activity_day)
	{
		$this->activity_day = intval($activity_day);
		$this->activity_day_status_field = true;		
		$this->this_table_status_field = true;		
	}

	public function /*void*/ setActivityDayNull()
	{
		$this->activity_day = null;
		$this->activity_day_status_field = true;		
		$this->this_table_status_field = true;
	}

	public function /*string*/ getActivityDesc()
	{
		return $this->activity_desc;
	}
	
	public function /*void*/ setActivityDesc(/*string*/ $activity_desc)
	{
		$this->activity_desc = SQLUtil::toSafeSQLString($activity_desc);
		$this->activity_desc_status_field = true;		
		$this->this_table_status_field = true;		
	}

	public function /*void*/ setActivityDescNull()
	{
		$this->activity_desc = null;
		$this->activity_desc_status_field = true;		
		$this->this_table_status_field = true;
	}

	
	public function /*string*/ toDebugString()
	{
		$dbg = "(";
		
		$dbg .= ("user_id={$this->user_id},");
		$dbg .= ("vip={$this->vip},");
		$dbg .= ("recharge={$this->recharge},");
		$dbg .= ("recharge_limit={$this->recharge_limit},");
		$dbg .= ("first_pay_reward={$this->first_pay_reward},");
		$dbg .= ("activity_day={$this->activity_day},");
		$dbg .= ("activity_desc={$this->activity_desc},");

		$dbg .= ")";
				
		return str_replace(",)",")",$dbg);
	}
}

?>
