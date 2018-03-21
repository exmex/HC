<?php
require_once ($GLOBALS ['GAME_ROOT'] . "CMySQL.php");
require_once ("SQLUtil.php");
/**
 *  [The generated files]
 */

class SysPlayerBread {
	
	private /*string*/ $user_id; //PRIMARY KEY 
	private /*int*/ $cur_vitality;
	private /*int*/ $last_change_time;
	private /*int*/ $today_buy;
	private /*int*/ $last_buy_time;
	private /*int*/ $today_receive;
	private /*int*/ $last_receive_time;

	
	private $this_table_status_field = false;
	private $user_id_status_field = false;
	private $cur_vitality_status_field = false;
	private $last_change_time_status_field = false;
	private $today_buy_status_field = false;
	private $last_buy_time_status_field = false;
	private $today_receive_status_field = false;
	private $last_receive_time_status_field = false;


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
			$sql = "SELECT {$p} FROM `player_bread`";
		}
		else
		{			
			$sql = "SELECT {$p} FROM `player_bread` WHERE ".SQLUtil::parseCondition($condition);
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
			$tb = new SysPlayerBread();			
			if (isset($row['user_id'])) $tb->user_id = $row['user_id'];
			if (isset($row['cur_vitality'])) $tb->cur_vitality = intval($row['cur_vitality']);
			if (isset($row['last_change_time'])) $tb->last_change_time = intval($row['last_change_time']);
			if (isset($row['today_buy'])) $tb->today_buy = intval($row['today_buy']);
			if (isset($row['last_buy_time'])) $tb->last_buy_time = intval($row['last_buy_time']);
			if (isset($row['today_receive'])) $tb->today_receive = intval($row['today_receive']);
			if (isset($row['last_receive_time'])) $tb->last_receive_time = intval($row['last_receive_time']);
		
			$result[] = $tb;
		}
		
		return $result;
	}	
	
	public static function insertSqlHeader($fields=NULL)
	{
		$result = array();				
		if(!empty($fields)){
			$where = SQLUtil::parseFields($fields);			
			$result[0] = "INSERT INTO `player_bread` ({$where}) VALUES ";	
			$ar = array();
			foreach($fields as $key){
				$ar[$key]=1;
			}
			$result[1] = $ar;
		}else{
			$result[0]="INSERT INTO `player_bread` (`user_id`,`cur_vitality`,`last_change_time`,`today_buy`,`last_buy_time`,`today_receive`,`last_receive_time`) VALUES ";
			$result[1] = array('user_id'=>1,'cur_vitality'=>1,'last_change_time'=>1,'today_buy'=>1,'last_buy_time'=>1,'today_receive'=>1,'last_receive_time'=>1);
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
		
		$sql = "SELECT {$p} FROM `player_bread` WHERE {$where}";

		if(isset($this->user_id)){MySQL::selectDbForUser($this->user_id);}else{MySQL::selectDbForUser($GLOBALS['USER_ID']);}
		$qr = MySQL::getInstance()->RunQuery($sql);
		$ar = MySQL::getInstance()->FetchArray($qr);
		
		if (!$ar || count($ar)==0)
		{
			return false;
		}
		
		if (isset($ar['user_id'])) $this->user_id = $ar['user_id'];
		if (isset($ar['cur_vitality'])) $this->cur_vitality = intval($ar['cur_vitality']);
		if (isset($ar['last_change_time'])) $this->last_change_time = intval($ar['last_change_time']);
		if (isset($ar['today_buy'])) $this->today_buy = intval($ar['today_buy']);
		if (isset($ar['last_buy_time'])) $this->last_buy_time = intval($ar['last_buy_time']);
		if (isset($ar['today_receive'])) $this->today_receive = intval($ar['today_receive']);
		if (isset($ar['last_receive_time'])) $this->last_receive_time = intval($ar['last_receive_time']);
		
		
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
	
		$sql = "SELECT {$p} FROM `player_bread` WHERE {$where}";
	
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
    	if (!isset($this->cur_vitality)){
    		$emptyFields = false;
    		$fields[] = 'cur_vitality';
    	}else{
    		$emptyCondition = false; 
    		$condition['cur_vitality']=$this->cur_vitality;
    	}
    	if (!isset($this->last_change_time)){
    		$emptyFields = false;
    		$fields[] = 'last_change_time';
    	}else{
    		$emptyCondition = false; 
    		$condition['last_change_time']=$this->last_change_time;
    	}
    	if (!isset($this->today_buy)){
    		$emptyFields = false;
    		$fields[] = 'today_buy';
    	}else{
    		$emptyCondition = false; 
    		$condition['today_buy']=$this->today_buy;
    	}
    	if (!isset($this->last_buy_time)){
    		$emptyFields = false;
    		$fields[] = 'last_buy_time';
    	}else{
    		$emptyCondition = false; 
    		$condition['last_buy_time']=$this->last_buy_time;
    	}
    	if (!isset($this->today_receive)){
    		$emptyFields = false;
    		$fields[] = 'today_receive';
    	}else{
    		$emptyCondition = false; 
    		$condition['today_receive']=$this->today_receive;
    	}
    	if (!isset($this->last_receive_time)){
    		$emptyFields = false;
    		$fields[] = 'last_receive_time';
    	}else{
    		$emptyCondition = false; 
    		$condition['last_receive_time']=$this->last_receive_time;
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
		
		$sql = "DELETE FROM `player_bread` WHERE ".SQLUtil::parseCondition($condition);
		
		$qr = MySQL::getInstance()->RunQuery($sql);
				
		return (boolean)$qr;
	}
	
	public function  delete()
	{
		if (!isset($this->user_id))
		{
			return false;
		}
		
		$sql = "DELETE FROM `player_bread` WHERE `user_id`='{$this->user_id}'";
		
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
 			}else if($f == 'cur_vitality'){
 				$values .= "'{$this->cur_vitality}',";
 			}else if($f == 'last_change_time'){
 				$values .= "'{$this->last_change_time}',";
 			}else if($f == 'today_buy'){
 				$values .= "'{$this->today_buy}',";
 			}else if($f == 'last_buy_time'){
 				$values .= "'{$this->last_buy_time}',";
 			}else if($f == 'today_receive'){
 				$values .= "'{$this->today_receive}',";
 			}else if($f == 'last_receive_time'){
 				$values .= "'{$this->last_receive_time}',";
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
		if (isset($this->cur_vitality))
		{
			$fields .= "`cur_vitality`,";
			$values .= "'{$this->cur_vitality}',";
		}
		if (isset($this->last_change_time))
		{
			$fields .= "`last_change_time`,";
			$values .= "'{$this->last_change_time}',";
		}
		if (isset($this->today_buy))
		{
			$fields .= "`today_buy`,";
			$values .= "'{$this->today_buy}',";
		}
		if (isset($this->last_buy_time))
		{
			$fields .= "`last_buy_time`,";
			$values .= "'{$this->last_buy_time}',";
		}
		if (isset($this->today_receive))
		{
			$fields .= "`today_receive`,";
			$values .= "'{$this->today_receive}',";
		}
		if (isset($this->last_receive_time))
		{
			$fields .= "`last_receive_time`,";
			$values .= "'{$this->last_receive_time}',";
		}

		
		$fields .= ")";
		$values .= ")";
		
		$sql = "INSERT INTO `player_bread` ".$fields.$values;
		
		return str_replace(",)",")",$sql);
	}
	
	private function  getUpFields()
	{
		$update = "";
		
		if ($this->cur_vitality_status_field)
		{			
			if (!isset($this->cur_vitality))
			{
				$update .= ("`cur_vitality`=null,");
			}
			else
			{
				$update .= ("`cur_vitality`='{$this->cur_vitality}',");
			}
		}
		if ($this->last_change_time_status_field)
		{			
			if (!isset($this->last_change_time))
			{
				$update .= ("`last_change_time`=null,");
			}
			else
			{
				$update .= ("`last_change_time`='{$this->last_change_time}',");
			}
		}
		if ($this->today_buy_status_field)
		{			
			if (!isset($this->today_buy))
			{
				$update .= ("`today_buy`=null,");
			}
			else
			{
				$update .= ("`today_buy`='{$this->today_buy}',");
			}
		}
		if ($this->last_buy_time_status_field)
		{			
			if (!isset($this->last_buy_time))
			{
				$update .= ("`last_buy_time`=null,");
			}
			else
			{
				$update .= ("`last_buy_time`='{$this->last_buy_time}',");
			}
		}
		if ($this->today_receive_status_field)
		{			
			if (!isset($this->today_receive))
			{
				$update .= ("`today_receive`=null,");
			}
			else
			{
				$update .= ("`today_receive`='{$this->today_receive}',");
			}
		}
		if ($this->last_receive_time_status_field)
		{			
			if (!isset($this->last_receive_time))
			{
				$update .= ("`last_receive_time`=null,");
			}
			else
			{
				$update .= ("`last_receive_time`='{$this->last_receive_time}',");
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
		
		$sql = "UPDATE `player_bread` SET {$update} WHERE {$condition}";
		
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
		
		$sql = "UPDATE `player_bread` SET {$update} WHERE {$uc}";
		
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
		
		$sql = "UPDATE `player_bread` SET {$update} WHERE {$uc}";
		
		if(isset($this->user_id)){MySQL::selectDbForUser($this->user_id);}else{MySQL::selectDbForUser($GLOBALS['USER_ID']);}
		$qr = MySQL::getInstance()->RunQuery($sql);
				
		return (boolean)$qr;
	}
	
	private function /*void*/ clean() 
	{
		$this->this_table_status_field = false;
		$this->user_id_status_field = false;
		$this->cur_vitality_status_field = false;
		$this->last_change_time_status_field = false;
		$this->today_buy_status_field = false;
		$this->last_buy_time_status_field = false;
		$this->today_receive_status_field = false;
		$this->last_receive_time_status_field = false;

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

	public function /*int*/ getCurVitality()
	{
		return $this->cur_vitality;
	}
	
	public function /*void*/ setCurVitality(/*int*/ $cur_vitality)
	{
		$this->cur_vitality = intval($cur_vitality);
		$this->cur_vitality_status_field = true;		
		$this->this_table_status_field = true;		
	}

	public function /*void*/ setCurVitalityNull()
	{
		$this->cur_vitality = null;
		$this->cur_vitality_status_field = true;		
		$this->this_table_status_field = true;
	}

	public function /*int*/ getLastChangeTime()
	{
		return $this->last_change_time;
	}
	
	public function /*void*/ setLastChangeTime(/*int*/ $last_change_time)
	{
		$this->last_change_time = intval($last_change_time);
		$this->last_change_time_status_field = true;		
		$this->this_table_status_field = true;		
	}

	public function /*void*/ setLastChangeTimeNull()
	{
		$this->last_change_time = null;
		$this->last_change_time_status_field = true;		
		$this->this_table_status_field = true;
	}

	public function /*int*/ getTodayBuy()
	{
		return $this->today_buy;
	}
	
	public function /*void*/ setTodayBuy(/*int*/ $today_buy)
	{
		$this->today_buy = intval($today_buy);
		$this->today_buy_status_field = true;		
		$this->this_table_status_field = true;		
	}

	public function /*void*/ setTodayBuyNull()
	{
		$this->today_buy = null;
		$this->today_buy_status_field = true;		
		$this->this_table_status_field = true;
	}

	public function /*int*/ getLastBuyTime()
	{
		return $this->last_buy_time;
	}
	
	public function /*void*/ setLastBuyTime(/*int*/ $last_buy_time)
	{
		$this->last_buy_time = intval($last_buy_time);
		$this->last_buy_time_status_field = true;		
		$this->this_table_status_field = true;		
	}

	public function /*void*/ setLastBuyTimeNull()
	{
		$this->last_buy_time = null;
		$this->last_buy_time_status_field = true;		
		$this->this_table_status_field = true;
	}

	public function /*int*/ getTodayReceive()
	{
		return $this->today_receive;
	}
	
	public function /*void*/ setTodayReceive(/*int*/ $today_receive)
	{
		$this->today_receive = intval($today_receive);
		$this->today_receive_status_field = true;		
		$this->this_table_status_field = true;		
	}

	public function /*void*/ setTodayReceiveNull()
	{
		$this->today_receive = null;
		$this->today_receive_status_field = true;		
		$this->this_table_status_field = true;
	}

	public function /*int*/ getLastReceiveTime()
	{
		return $this->last_receive_time;
	}
	
	public function /*void*/ setLastReceiveTime(/*int*/ $last_receive_time)
	{
		$this->last_receive_time = intval($last_receive_time);
		$this->last_receive_time_status_field = true;		
		$this->this_table_status_field = true;		
	}

	public function /*void*/ setLastReceiveTimeNull()
	{
		$this->last_receive_time = null;
		$this->last_receive_time_status_field = true;		
		$this->this_table_status_field = true;
	}

	
	public function /*string*/ toDebugString()
	{
		$dbg = "(";
		
		$dbg .= ("user_id={$this->user_id},");
		$dbg .= ("cur_vitality={$this->cur_vitality},");
		$dbg .= ("last_change_time={$this->last_change_time},");
		$dbg .= ("today_buy={$this->today_buy},");
		$dbg .= ("last_buy_time={$this->last_buy_time},");
		$dbg .= ("today_receive={$this->today_receive},");
		$dbg .= ("last_receive_time={$this->last_receive_time},");

		$dbg .= ")";
				
		return str_replace(",)",")",$dbg);
	}
}

?>
