<?php
require_once ($GLOBALS ['GAME_ROOT'] . "CMySQL.php");
require_once ("SQLUtil.php");
/**
 *  [The generated files]
 */

class SysPlayerGuildAppQueue {
	
	private /*string*/ $user_id; //PRIMARY KEY 
	private /*int*/ $raid_id;
	private /*int*/ $item_id;
	private /*string*/ $guild_id;
	private /*int*/ $server_id;
	private /*int*/ $apply_time;
	private /*int*/ $jump_times;
	private /*int*/ $cost_money;
	private /*int*/ $sort;

	
	private $this_table_status_field = false;
	private $user_id_status_field = false;
	private $raid_id_status_field = false;
	private $item_id_status_field = false;
	private $guild_id_status_field = false;
	private $server_id_status_field = false;
	private $apply_time_status_field = false;
	private $jump_times_status_field = false;
	private $cost_money_status_field = false;
	private $sort_status_field = false;


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
			$sql = "SELECT {$p} FROM `player_guild_app_queue`";
		}
		else
		{			
			$sql = "SELECT {$p} FROM `player_guild_app_queue` WHERE ".SQLUtil::parseCondition($condition);
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
			$tb = new SysPlayerGuildAppQueue();			
			if (isset($row['user_id'])) $tb->user_id = $row['user_id'];
			if (isset($row['raid_id'])) $tb->raid_id = intval($row['raid_id']);
			if (isset($row['item_id'])) $tb->item_id = intval($row['item_id']);
			if (isset($row['guild_id'])) $tb->guild_id = $row['guild_id'];
			if (isset($row['server_id'])) $tb->server_id = intval($row['server_id']);
			if (isset($row['apply_time'])) $tb->apply_time = intval($row['apply_time']);
			if (isset($row['jump_times'])) $tb->jump_times = intval($row['jump_times']);
			if (isset($row['cost_money'])) $tb->cost_money = intval($row['cost_money']);
			if (isset($row['sort'])) $tb->sort = intval($row['sort']);
		
			$result[] = $tb;
		}
		
		return $result;
	}	
	
	public static function insertSqlHeader($fields=NULL)
	{
		$result = array();				
		if(!empty($fields)){
			$where = SQLUtil::parseFields($fields);			
			$result[0] = "INSERT INTO `player_guild_app_queue` ({$where}) VALUES ";	
			$ar = array();
			foreach($fields as $key){
				$ar[$key]=1;
			}
			$result[1] = $ar;
		}else{
			$result[0]="INSERT INTO `player_guild_app_queue` (`user_id`,`raid_id`,`item_id`,`guild_id`,`server_id`,`apply_time`,`jump_times`,`cost_money`,`sort`) VALUES ";
			$result[1] = array('user_id'=>1,'raid_id'=>1,'item_id'=>1,'guild_id'=>1,'server_id'=>1,'apply_time'=>1,'jump_times'=>1,'cost_money'=>1,'sort'=>1);
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
		
		$sql = "SELECT {$p} FROM `player_guild_app_queue` WHERE {$where}";

		if(isset($this->user_id)){MySQL::selectDbForUser($this->user_id);}else{MySQL::selectDbForUser($GLOBALS['USER_ID']);}
		$qr = MySQL::getInstance()->RunQuery($sql);
		$ar = MySQL::getInstance()->FetchArray($qr);
		
		if (!$ar || count($ar)==0)
		{
			return false;
		}
		
		if (isset($ar['user_id'])) $this->user_id = $ar['user_id'];
		if (isset($ar['raid_id'])) $this->raid_id = intval($ar['raid_id']);
		if (isset($ar['item_id'])) $this->item_id = intval($ar['item_id']);
		if (isset($ar['guild_id'])) $this->guild_id = $ar['guild_id'];
		if (isset($ar['server_id'])) $this->server_id = intval($ar['server_id']);
		if (isset($ar['apply_time'])) $this->apply_time = intval($ar['apply_time']);
		if (isset($ar['jump_times'])) $this->jump_times = intval($ar['jump_times']);
		if (isset($ar['cost_money'])) $this->cost_money = intval($ar['cost_money']);
		if (isset($ar['sort'])) $this->sort = intval($ar['sort']);
		
		
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
	
		$sql = "SELECT {$p} FROM `player_guild_app_queue` WHERE {$where}";
	
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
    	if (!isset($this->raid_id)){
    		$emptyFields = false;
    		$fields[] = 'raid_id';
    	}else{
    		$emptyCondition = false; 
    		$condition['raid_id']=$this->raid_id;
    	}
    	if (!isset($this->item_id)){
    		$emptyFields = false;
    		$fields[] = 'item_id';
    	}else{
    		$emptyCondition = false; 
    		$condition['item_id']=$this->item_id;
    	}
    	if (!isset($this->guild_id)){
    		$emptyFields = false;
    		$fields[] = 'guild_id';
    	}else{
    		$emptyCondition = false; 
    		$condition['guild_id']=$this->guild_id;
    	}
    	if (!isset($this->server_id)){
    		$emptyFields = false;
    		$fields[] = 'server_id';
    	}else{
    		$emptyCondition = false; 
    		$condition['server_id']=$this->server_id;
    	}
    	if (!isset($this->apply_time)){
    		$emptyFields = false;
    		$fields[] = 'apply_time';
    	}else{
    		$emptyCondition = false; 
    		$condition['apply_time']=$this->apply_time;
    	}
    	if (!isset($this->jump_times)){
    		$emptyFields = false;
    		$fields[] = 'jump_times';
    	}else{
    		$emptyCondition = false; 
    		$condition['jump_times']=$this->jump_times;
    	}
    	if (!isset($this->cost_money)){
    		$emptyFields = false;
    		$fields[] = 'cost_money';
    	}else{
    		$emptyCondition = false; 
    		$condition['cost_money']=$this->cost_money;
    	}
    	if (!isset($this->sort)){
    		$emptyFields = false;
    		$fields[] = 'sort';
    	}else{
    		$emptyCondition = false; 
    		$condition['sort']=$this->sort;
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
		
		$sql = "DELETE FROM `player_guild_app_queue` WHERE ".SQLUtil::parseCondition($condition);
		
		$qr = MySQL::getInstance()->RunQuery($sql);
				
		return (boolean)$qr;
	}
	
	public function  delete()
	{
		if (!isset($this->user_id))
		{
			return false;
		}
		
		$sql = "DELETE FROM `player_guild_app_queue` WHERE `user_id`='{$this->user_id}'";
		
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
 			}else if($f == 'raid_id'){
 				$values .= "'{$this->raid_id}',";
 			}else if($f == 'item_id'){
 				$values .= "'{$this->item_id}',";
 			}else if($f == 'guild_id'){
 				$values .= "'{$this->guild_id}',";
 			}else if($f == 'server_id'){
 				$values .= "'{$this->server_id}',";
 			}else if($f == 'apply_time'){
 				$values .= "'{$this->apply_time}',";
 			}else if($f == 'jump_times'){
 				$values .= "'{$this->jump_times}',";
 			}else if($f == 'cost_money'){
 				$values .= "'{$this->cost_money}',";
 			}else if($f == 'sort'){
 				$values .= "'{$this->sort}',";
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
		if (isset($this->raid_id))
		{
			$fields .= "`raid_id`,";
			$values .= "'{$this->raid_id}',";
		}
		if (isset($this->item_id))
		{
			$fields .= "`item_id`,";
			$values .= "'{$this->item_id}',";
		}
		if (isset($this->guild_id))
		{
			$fields .= "`guild_id`,";
			$values .= "'{$this->guild_id}',";
		}
		if (isset($this->server_id))
		{
			$fields .= "`server_id`,";
			$values .= "'{$this->server_id}',";
		}
		if (isset($this->apply_time))
		{
			$fields .= "`apply_time`,";
			$values .= "'{$this->apply_time}',";
		}
		if (isset($this->jump_times))
		{
			$fields .= "`jump_times`,";
			$values .= "'{$this->jump_times}',";
		}
		if (isset($this->cost_money))
		{
			$fields .= "`cost_money`,";
			$values .= "'{$this->cost_money}',";
		}
		if (isset($this->sort))
		{
			$fields .= "`sort`,";
			$values .= "'{$this->sort}',";
		}

		
		$fields .= ")";
		$values .= ")";
		
		$sql = "INSERT INTO `player_guild_app_queue` ".$fields.$values;
		
		return str_replace(",)",")",$sql);
	}
	
	private function  getUpFields()
	{
		$update = "";
		
		if ($this->raid_id_status_field)
		{			
			if (!isset($this->raid_id))
			{
				$update .= ("`raid_id`=null,");
			}
			else
			{
				$update .= ("`raid_id`='{$this->raid_id}',");
			}
		}
		if ($this->item_id_status_field)
		{			
			if (!isset($this->item_id))
			{
				$update .= ("`item_id`=null,");
			}
			else
			{
				$update .= ("`item_id`='{$this->item_id}',");
			}
		}
		if ($this->guild_id_status_field)
		{			
			if (!isset($this->guild_id))
			{
				$update .= ("`guild_id`=null,");
			}
			else
			{
				$update .= ("`guild_id`='{$this->guild_id}',");
			}
		}
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
		if ($this->apply_time_status_field)
		{			
			if (!isset($this->apply_time))
			{
				$update .= ("`apply_time`=null,");
			}
			else
			{
				$update .= ("`apply_time`='{$this->apply_time}',");
			}
		}
		if ($this->jump_times_status_field)
		{			
			if (!isset($this->jump_times))
			{
				$update .= ("`jump_times`=null,");
			}
			else
			{
				$update .= ("`jump_times`='{$this->jump_times}',");
			}
		}
		if ($this->cost_money_status_field)
		{			
			if (!isset($this->cost_money))
			{
				$update .= ("`cost_money`=null,");
			}
			else
			{
				$update .= ("`cost_money`='{$this->cost_money}',");
			}
		}
		if ($this->sort_status_field)
		{			
			if (!isset($this->sort))
			{
				$update .= ("`sort`=null,");
			}
			else
			{
				$update .= ("`sort`='{$this->sort}',");
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
		
		$sql = "UPDATE `player_guild_app_queue` SET {$update} WHERE {$condition}";
		
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
		
		$sql = "UPDATE `player_guild_app_queue` SET {$update} WHERE {$uc}";
		
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
		
		$sql = "UPDATE `player_guild_app_queue` SET {$update} WHERE {$uc}";
		
		if(isset($this->user_id)){MySQL::selectDbForUser($this->user_id);}else{MySQL::selectDbForUser($GLOBALS['USER_ID']);}
		$qr = MySQL::getInstance()->RunQuery($sql);
				
		return (boolean)$qr;
	}
	
	private function /*void*/ clean() 
	{
		$this->this_table_status_field = false;
		$this->user_id_status_field = false;
		$this->raid_id_status_field = false;
		$this->item_id_status_field = false;
		$this->guild_id_status_field = false;
		$this->server_id_status_field = false;
		$this->apply_time_status_field = false;
		$this->jump_times_status_field = false;
		$this->cost_money_status_field = false;
		$this->sort_status_field = false;

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

	public function /*int*/ getRaidId()
	{
		return $this->raid_id;
	}
	
	public function /*void*/ setRaidId(/*int*/ $raid_id)
	{
		$this->raid_id = intval($raid_id);
		$this->raid_id_status_field = true;		
		$this->this_table_status_field = true;		
	}

	public function /*void*/ setRaidIdNull()
	{
		$this->raid_id = null;
		$this->raid_id_status_field = true;		
		$this->this_table_status_field = true;
	}

	public function /*int*/ getItemId()
	{
		return $this->item_id;
	}
	
	public function /*void*/ setItemId(/*int*/ $item_id)
	{
		$this->item_id = intval($item_id);
		$this->item_id_status_field = true;		
		$this->this_table_status_field = true;		
	}

	public function /*void*/ setItemIdNull()
	{
		$this->item_id = null;
		$this->item_id_status_field = true;		
		$this->this_table_status_field = true;
	}

	public function /*string*/ getGuildId()
	{
		return $this->guild_id;
	}
	
	public function /*void*/ setGuildId(/*string*/ $guild_id)
	{
		$this->guild_id = SQLUtil::toSafeSQLString($guild_id);
		$this->guild_id_status_field = true;		
		$this->this_table_status_field = true;		
	}

	public function /*void*/ setGuildIdNull()
	{
		$this->guild_id = null;
		$this->guild_id_status_field = true;		
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

	public function /*int*/ getApplyTime()
	{
		return $this->apply_time;
	}
	
	public function /*void*/ setApplyTime(/*int*/ $apply_time)
	{
		$this->apply_time = intval($apply_time);
		$this->apply_time_status_field = true;		
		$this->this_table_status_field = true;		
	}

	public function /*void*/ setApplyTimeNull()
	{
		$this->apply_time = null;
		$this->apply_time_status_field = true;		
		$this->this_table_status_field = true;
	}

	public function /*int*/ getJumpTimes()
	{
		return $this->jump_times;
	}
	
	public function /*void*/ setJumpTimes(/*int*/ $jump_times)
	{
		$this->jump_times = intval($jump_times);
		$this->jump_times_status_field = true;		
		$this->this_table_status_field = true;		
	}

	public function /*void*/ setJumpTimesNull()
	{
		$this->jump_times = null;
		$this->jump_times_status_field = true;		
		$this->this_table_status_field = true;
	}

	public function /*int*/ getCostMoney()
	{
		return $this->cost_money;
	}
	
	public function /*void*/ setCostMoney(/*int*/ $cost_money)
	{
		$this->cost_money = intval($cost_money);
		$this->cost_money_status_field = true;		
		$this->this_table_status_field = true;		
	}

	public function /*void*/ setCostMoneyNull()
	{
		$this->cost_money = null;
		$this->cost_money_status_field = true;		
		$this->this_table_status_field = true;
	}

	public function /*int*/ getSort()
	{
		return $this->sort;
	}
	
	public function /*void*/ setSort(/*int*/ $sort)
	{
		$this->sort = intval($sort);
		$this->sort_status_field = true;		
		$this->this_table_status_field = true;		
	}

	public function /*void*/ setSortNull()
	{
		$this->sort = null;
		$this->sort_status_field = true;		
		$this->this_table_status_field = true;
	}

	
	public function /*string*/ toDebugString()
	{
		$dbg = "(";
		
		$dbg .= ("user_id={$this->user_id},");
		$dbg .= ("raid_id={$this->raid_id},");
		$dbg .= ("item_id={$this->item_id},");
		$dbg .= ("guild_id={$this->guild_id},");
		$dbg .= ("server_id={$this->server_id},");
		$dbg .= ("apply_time={$this->apply_time},");
		$dbg .= ("jump_times={$this->jump_times},");
		$dbg .= ("cost_money={$this->cost_money},");
		$dbg .= ("sort={$this->sort},");

		$dbg .= ")";
				
		return str_replace(",)",")",$dbg);
	}
}

?>
