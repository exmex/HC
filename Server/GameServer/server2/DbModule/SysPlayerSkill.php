<?php
require_once ($GLOBALS ['GAME_ROOT'] . "CMySQL.php");
require_once ("SQLUtil.php");
/**
 *  [The generated files]
 */

class SysPlayerSkill {
	
	private /*string*/ $user_id; //PRIMARY KEY 
	private /*int*/ $point;
	private /*int*/ $last_add_time;
	private /*int*/ $buy_times;
	private /*int*/ $last_buy_time;

	
	private $this_table_status_field = false;
	private $user_id_status_field = false;
	private $point_status_field = false;
	private $last_add_time_status_field = false;
	private $buy_times_status_field = false;
	private $last_buy_time_status_field = false;


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
			$sql = "SELECT {$p} FROM `player_skill`";
		}
		else
		{			
			$sql = "SELECT {$p} FROM `player_skill` WHERE ".SQLUtil::parseCondition($condition);
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
			$tb = new SysPlayerSkill();			
			if (isset($row['user_id'])) $tb->user_id = $row['user_id'];
			if (isset($row['point'])) $tb->point = intval($row['point']);
			if (isset($row['last_add_time'])) $tb->last_add_time = intval($row['last_add_time']);
			if (isset($row['buy_times'])) $tb->buy_times = intval($row['buy_times']);
			if (isset($row['last_buy_time'])) $tb->last_buy_time = intval($row['last_buy_time']);
		
			$result[] = $tb;
		}
		
		return $result;
	}	
	
	public static function insertSqlHeader($fields=NULL)
	{
		$result = array();				
		if(!empty($fields)){
			$where = SQLUtil::parseFields($fields);			
			$result[0] = "INSERT INTO `player_skill` ({$where}) VALUES ";	
			$ar = array();
			foreach($fields as $key){
				$ar[$key]=1;
			}
			$result[1] = $ar;
		}else{
			$result[0]="INSERT INTO `player_skill` (`user_id`,`point`,`last_add_time`,`buy_times`,`last_buy_time`) VALUES ";
			$result[1] = array('user_id'=>1,'point'=>1,'last_add_time'=>1,'buy_times'=>1,'last_buy_time'=>1);
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
		
		$sql = "SELECT {$p} FROM `player_skill` WHERE {$where}";

		if(isset($this->user_id)){MySQL::selectDbForUser($this->user_id);}else{MySQL::selectDbForUser($GLOBALS['USER_ID']);}
		$qr = MySQL::getInstance()->RunQuery($sql);
		$ar = MySQL::getInstance()->FetchArray($qr);
		
		if (!$ar || count($ar)==0)
		{
			return false;
		}
		
		if (isset($ar['user_id'])) $this->user_id = $ar['user_id'];
		if (isset($ar['point'])) $this->point = intval($ar['point']);
		if (isset($ar['last_add_time'])) $this->last_add_time = intval($ar['last_add_time']);
		if (isset($ar['buy_times'])) $this->buy_times = intval($ar['buy_times']);
		if (isset($ar['last_buy_time'])) $this->last_buy_time = intval($ar['last_buy_time']);
		
		
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
	
		$sql = "SELECT {$p} FROM `player_skill` WHERE {$where}";
	
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
    	if (!isset($this->point)){
    		$emptyFields = false;
    		$fields[] = 'point';
    	}else{
    		$emptyCondition = false; 
    		$condition['point']=$this->point;
    	}
    	if (!isset($this->last_add_time)){
    		$emptyFields = false;
    		$fields[] = 'last_add_time';
    	}else{
    		$emptyCondition = false; 
    		$condition['last_add_time']=$this->last_add_time;
    	}
    	if (!isset($this->buy_times)){
    		$emptyFields = false;
    		$fields[] = 'buy_times';
    	}else{
    		$emptyCondition = false; 
    		$condition['buy_times']=$this->buy_times;
    	}
    	if (!isset($this->last_buy_time)){
    		$emptyFields = false;
    		$fields[] = 'last_buy_time';
    	}else{
    		$emptyCondition = false; 
    		$condition['last_buy_time']=$this->last_buy_time;
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
		
		$sql = "DELETE FROM `player_skill` WHERE ".SQLUtil::parseCondition($condition);
		
		$qr = MySQL::getInstance()->RunQuery($sql);
				
		return (boolean)$qr;
	}
	
	public function  delete()
	{
		if (!isset($this->user_id))
		{
			return false;
		}
		
		$sql = "DELETE FROM `player_skill` WHERE `user_id`='{$this->user_id}'";
		
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
 			}else if($f == 'point'){
 				$values .= "'{$this->point}',";
 			}else if($f == 'last_add_time'){
 				$values .= "'{$this->last_add_time}',";
 			}else if($f == 'buy_times'){
 				$values .= "'{$this->buy_times}',";
 			}else if($f == 'last_buy_time'){
 				$values .= "'{$this->last_buy_time}',";
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
		if (isset($this->point))
		{
			$fields .= "`point`,";
			$values .= "'{$this->point}',";
		}
		if (isset($this->last_add_time))
		{
			$fields .= "`last_add_time`,";
			$values .= "'{$this->last_add_time}',";
		}
		if (isset($this->buy_times))
		{
			$fields .= "`buy_times`,";
			$values .= "'{$this->buy_times}',";
		}
		if (isset($this->last_buy_time))
		{
			$fields .= "`last_buy_time`,";
			$values .= "'{$this->last_buy_time}',";
		}

		
		$fields .= ")";
		$values .= ")";
		
		$sql = "INSERT INTO `player_skill` ".$fields.$values;
		
		return str_replace(",)",")",$sql);
	}
	
	private function  getUpFields()
	{
		$update = "";
		
		if ($this->point_status_field)
		{			
			if (!isset($this->point))
			{
				$update .= ("`point`=null,");
			}
			else
			{
				$update .= ("`point`='{$this->point}',");
			}
		}
		if ($this->last_add_time_status_field)
		{			
			if (!isset($this->last_add_time))
			{
				$update .= ("`last_add_time`=null,");
			}
			else
			{
				$update .= ("`last_add_time`='{$this->last_add_time}',");
			}
		}
		if ($this->buy_times_status_field)
		{			
			if (!isset($this->buy_times))
			{
				$update .= ("`buy_times`=null,");
			}
			else
			{
				$update .= ("`buy_times`='{$this->buy_times}',");
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
		
		$sql = "UPDATE `player_skill` SET {$update} WHERE {$condition}";
		
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
		
		$sql = "UPDATE `player_skill` SET {$update} WHERE {$uc}";
		
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
		
		$sql = "UPDATE `player_skill` SET {$update} WHERE {$uc}";
		
		if(isset($this->user_id)){MySQL::selectDbForUser($this->user_id);}else{MySQL::selectDbForUser($GLOBALS['USER_ID']);}
		$qr = MySQL::getInstance()->RunQuery($sql);
				
		return (boolean)$qr;
	}
	
	private function /*void*/ clean() 
	{
		$this->this_table_status_field = false;
		$this->user_id_status_field = false;
		$this->point_status_field = false;
		$this->last_add_time_status_field = false;
		$this->buy_times_status_field = false;
		$this->last_buy_time_status_field = false;

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

	public function /*int*/ getPoint()
	{
		return $this->point;
	}
	
	public function /*void*/ setPoint(/*int*/ $point)
	{
		$this->point = intval($point);
		$this->point_status_field = true;		
		$this->this_table_status_field = true;		
	}

	public function /*void*/ setPointNull()
	{
		$this->point = null;
		$this->point_status_field = true;		
		$this->this_table_status_field = true;
	}

	public function /*int*/ getLastAddTime()
	{
		return $this->last_add_time;
	}
	
	public function /*void*/ setLastAddTime(/*int*/ $last_add_time)
	{
		$this->last_add_time = intval($last_add_time);
		$this->last_add_time_status_field = true;		
		$this->this_table_status_field = true;		
	}

	public function /*void*/ setLastAddTimeNull()
	{
		$this->last_add_time = null;
		$this->last_add_time_status_field = true;		
		$this->this_table_status_field = true;
	}

	public function /*int*/ getBuyTimes()
	{
		return $this->buy_times;
	}
	
	public function /*void*/ setBuyTimes(/*int*/ $buy_times)
	{
		$this->buy_times = intval($buy_times);
		$this->buy_times_status_field = true;		
		$this->this_table_status_field = true;		
	}

	public function /*void*/ setBuyTimesNull()
	{
		$this->buy_times = null;
		$this->buy_times_status_field = true;		
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

	
	public function /*string*/ toDebugString()
	{
		$dbg = "(";
		
		$dbg .= ("user_id={$this->user_id},");
		$dbg .= ("point={$this->point},");
		$dbg .= ("last_add_time={$this->last_add_time},");
		$dbg .= ("buy_times={$this->buy_times},");
		$dbg .= ("last_buy_time={$this->last_buy_time},");

		$dbg .= ")";
				
		return str_replace(",)",")",$dbg);
	}
}

?>
