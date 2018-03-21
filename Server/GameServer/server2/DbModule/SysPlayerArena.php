<?php
require_once ($GLOBALS ['GAME_ROOT'] . "CMySQL.php");
require_once ("SQLUtil.php");
/**
 *  [The generated files]
 */

class SysPlayerArena {
	
	private /*string*/ $user_id; //PRIMARY KEY 
	private /*int*/ $zone_id;
	private /*int*/ $server_id;
	private /*int*/ $rank;
	private /*int*/ $best_rank;
	private /*string*/ $reward_rank_list;
	private /*int*/ $fight_count;
	private /*int*/ $last_fight_time;
	private /*int*/ $buy_count;
	private /*int*/ $last_buy_time;
	private /*int*/ $win_count;
	private /*string*/ $lineup;
	private /*int*/ $all_gs;
	private /*int*/ $is_robot;

	
	private $this_table_status_field = false;
	private $user_id_status_field = false;
	private $zone_id_status_field = false;
	private $server_id_status_field = false;
	private $rank_status_field = false;
	private $best_rank_status_field = false;
	private $reward_rank_list_status_field = false;
	private $fight_count_status_field = false;
	private $last_fight_time_status_field = false;
	private $buy_count_status_field = false;
	private $last_buy_time_status_field = false;
	private $win_count_status_field = false;
	private $lineup_status_field = false;
	private $all_gs_status_field = false;
	private $is_robot_status_field = false;


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
			$sql = "SELECT {$p} FROM `player_arena`";
		}
		else
		{			
			$sql = "SELECT {$p} FROM `player_arena` WHERE ".SQLUtil::parseCondition($condition);
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
			$tb = new SysPlayerArena();			
			if (isset($row['user_id'])) $tb->user_id = $row['user_id'];
			if (isset($row['zone_id'])) $tb->zone_id = intval($row['zone_id']);
			if (isset($row['server_id'])) $tb->server_id = intval($row['server_id']);
			if (isset($row['rank'])) $tb->rank = intval($row['rank']);
			if (isset($row['best_rank'])) $tb->best_rank = intval($row['best_rank']);
			if (isset($row['reward_rank_list'])) $tb->reward_rank_list = $row['reward_rank_list'];
			if (isset($row['fight_count'])) $tb->fight_count = intval($row['fight_count']);
			if (isset($row['last_fight_time'])) $tb->last_fight_time = intval($row['last_fight_time']);
			if (isset($row['buy_count'])) $tb->buy_count = intval($row['buy_count']);
			if (isset($row['last_buy_time'])) $tb->last_buy_time = intval($row['last_buy_time']);
			if (isset($row['win_count'])) $tb->win_count = intval($row['win_count']);
			if (isset($row['lineup'])) $tb->lineup = $row['lineup'];
			if (isset($row['all_gs'])) $tb->all_gs = intval($row['all_gs']);
			if (isset($row['is_robot'])) $tb->is_robot = intval($row['is_robot']);
		
			$result[] = $tb;
		}
		
		return $result;
	}	
	
	public static function insertSqlHeader($fields=NULL)
	{
		$result = array();				
		if(!empty($fields)){
			$where = SQLUtil::parseFields($fields);			
			$result[0] = "INSERT INTO `player_arena` ({$where}) VALUES ";	
			$ar = array();
			foreach($fields as $key){
				$ar[$key]=1;
			}
			$result[1] = $ar;
		}else{
			$result[0]="INSERT INTO `player_arena` (`user_id`,`zone_id`,`server_id`,`rank`,`best_rank`,`reward_rank_list`,`fight_count`,`last_fight_time`,`buy_count`,`last_buy_time`,`win_count`,`lineup`,`all_gs`,`is_robot`) VALUES ";
			$result[1] = array('user_id'=>1,'zone_id'=>1,'server_id'=>1,'rank'=>1,'best_rank'=>1,'reward_rank_list'=>1,'fight_count'=>1,'last_fight_time'=>1,'buy_count'=>1,'last_buy_time'=>1,'win_count'=>1,'lineup'=>1,'all_gs'=>1,'is_robot'=>1);
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
		
		$sql = "SELECT {$p} FROM `player_arena` WHERE {$where}";

		if(isset($this->user_id)){MySQL::selectDbForUser($this->user_id);}else{MySQL::selectDbForUser($GLOBALS['USER_ID']);}
		$qr = MySQL::getInstance()->RunQuery($sql);
		$ar = MySQL::getInstance()->FetchArray($qr);
		
		if (!$ar || count($ar)==0)
		{
			return false;
		}
		
		if (isset($ar['user_id'])) $this->user_id = $ar['user_id'];
		if (isset($ar['zone_id'])) $this->zone_id = intval($ar['zone_id']);
		if (isset($ar['server_id'])) $this->server_id = intval($ar['server_id']);
		if (isset($ar['rank'])) $this->rank = intval($ar['rank']);
		if (isset($ar['best_rank'])) $this->best_rank = intval($ar['best_rank']);
		if (isset($ar['reward_rank_list'])) $this->reward_rank_list = $ar['reward_rank_list'];
		if (isset($ar['fight_count'])) $this->fight_count = intval($ar['fight_count']);
		if (isset($ar['last_fight_time'])) $this->last_fight_time = intval($ar['last_fight_time']);
		if (isset($ar['buy_count'])) $this->buy_count = intval($ar['buy_count']);
		if (isset($ar['last_buy_time'])) $this->last_buy_time = intval($ar['last_buy_time']);
		if (isset($ar['win_count'])) $this->win_count = intval($ar['win_count']);
		if (isset($ar['lineup'])) $this->lineup = $ar['lineup'];
		if (isset($ar['all_gs'])) $this->all_gs = intval($ar['all_gs']);
		if (isset($ar['is_robot'])) $this->is_robot = intval($ar['is_robot']);
		
		
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
	
		$sql = "SELECT {$p} FROM `player_arena` WHERE {$where}";
	
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
    	if (!isset($this->zone_id)){
    		$emptyFields = false;
    		$fields[] = 'zone_id';
    	}else{
    		$emptyCondition = false; 
    		$condition['zone_id']=$this->zone_id;
    	}
    	if (!isset($this->server_id)){
    		$emptyFields = false;
    		$fields[] = 'server_id';
    	}else{
    		$emptyCondition = false; 
    		$condition['server_id']=$this->server_id;
    	}
    	if (!isset($this->rank)){
    		$emptyFields = false;
    		$fields[] = 'rank';
    	}else{
    		$emptyCondition = false; 
    		$condition['rank']=$this->rank;
    	}
    	if (!isset($this->best_rank)){
    		$emptyFields = false;
    		$fields[] = 'best_rank';
    	}else{
    		$emptyCondition = false; 
    		$condition['best_rank']=$this->best_rank;
    	}
    	if (!isset($this->reward_rank_list)){
    		$emptyFields = false;
    		$fields[] = 'reward_rank_list';
    	}else{
    		$emptyCondition = false; 
    		$condition['reward_rank_list']=$this->reward_rank_list;
    	}
    	if (!isset($this->fight_count)){
    		$emptyFields = false;
    		$fields[] = 'fight_count';
    	}else{
    		$emptyCondition = false; 
    		$condition['fight_count']=$this->fight_count;
    	}
    	if (!isset($this->last_fight_time)){
    		$emptyFields = false;
    		$fields[] = 'last_fight_time';
    	}else{
    		$emptyCondition = false; 
    		$condition['last_fight_time']=$this->last_fight_time;
    	}
    	if (!isset($this->buy_count)){
    		$emptyFields = false;
    		$fields[] = 'buy_count';
    	}else{
    		$emptyCondition = false; 
    		$condition['buy_count']=$this->buy_count;
    	}
    	if (!isset($this->last_buy_time)){
    		$emptyFields = false;
    		$fields[] = 'last_buy_time';
    	}else{
    		$emptyCondition = false; 
    		$condition['last_buy_time']=$this->last_buy_time;
    	}
    	if (!isset($this->win_count)){
    		$emptyFields = false;
    		$fields[] = 'win_count';
    	}else{
    		$emptyCondition = false; 
    		$condition['win_count']=$this->win_count;
    	}
    	if (!isset($this->lineup)){
    		$emptyFields = false;
    		$fields[] = 'lineup';
    	}else{
    		$emptyCondition = false; 
    		$condition['lineup']=$this->lineup;
    	}
    	if (!isset($this->all_gs)){
    		$emptyFields = false;
    		$fields[] = 'all_gs';
    	}else{
    		$emptyCondition = false; 
    		$condition['all_gs']=$this->all_gs;
    	}
    	if (!isset($this->is_robot)){
    		$emptyFields = false;
    		$fields[] = 'is_robot';
    	}else{
    		$emptyCondition = false; 
    		$condition['is_robot']=$this->is_robot;
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
		
		$sql = "DELETE FROM `player_arena` WHERE ".SQLUtil::parseCondition($condition);
		
		$qr = MySQL::getInstance()->RunQuery($sql);
				
		return (boolean)$qr;
	}
	
	public function  delete()
	{
		if (!isset($this->user_id))
		{
			return false;
		}
		
		$sql = "DELETE FROM `player_arena` WHERE `user_id`='{$this->user_id}'";
		
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
 			}else if($f == 'zone_id'){
 				$values .= "'{$this->zone_id}',";
 			}else if($f == 'server_id'){
 				$values .= "'{$this->server_id}',";
 			}else if($f == 'rank'){
 				$values .= "'{$this->rank}',";
 			}else if($f == 'best_rank'){
 				$values .= "'{$this->best_rank}',";
 			}else if($f == 'reward_rank_list'){
 				$values .= "'{$this->reward_rank_list}',";
 			}else if($f == 'fight_count'){
 				$values .= "'{$this->fight_count}',";
 			}else if($f == 'last_fight_time'){
 				$values .= "'{$this->last_fight_time}',";
 			}else if($f == 'buy_count'){
 				$values .= "'{$this->buy_count}',";
 			}else if($f == 'last_buy_time'){
 				$values .= "'{$this->last_buy_time}',";
 			}else if($f == 'win_count'){
 				$values .= "'{$this->win_count}',";
 			}else if($f == 'lineup'){
 				$values .= "'{$this->lineup}',";
 			}else if($f == 'all_gs'){
 				$values .= "'{$this->all_gs}',";
 			}else if($f == 'is_robot'){
 				$values .= "'{$this->is_robot}',";
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
		if (isset($this->zone_id))
		{
			$fields .= "`zone_id`,";
			$values .= "'{$this->zone_id}',";
		}
		if (isset($this->server_id))
		{
			$fields .= "`server_id`,";
			$values .= "'{$this->server_id}',";
		}
		if (isset($this->rank))
		{
			$fields .= "`rank`,";
			$values .= "'{$this->rank}',";
		}
		if (isset($this->best_rank))
		{
			$fields .= "`best_rank`,";
			$values .= "'{$this->best_rank}',";
		}
		if (isset($this->reward_rank_list))
		{
			$fields .= "`reward_rank_list`,";
			$values .= "'{$this->reward_rank_list}',";
		}
		if (isset($this->fight_count))
		{
			$fields .= "`fight_count`,";
			$values .= "'{$this->fight_count}',";
		}
		if (isset($this->last_fight_time))
		{
			$fields .= "`last_fight_time`,";
			$values .= "'{$this->last_fight_time}',";
		}
		if (isset($this->buy_count))
		{
			$fields .= "`buy_count`,";
			$values .= "'{$this->buy_count}',";
		}
		if (isset($this->last_buy_time))
		{
			$fields .= "`last_buy_time`,";
			$values .= "'{$this->last_buy_time}',";
		}
		if (isset($this->win_count))
		{
			$fields .= "`win_count`,";
			$values .= "'{$this->win_count}',";
		}
		if (isset($this->lineup))
		{
			$fields .= "`lineup`,";
			$values .= "'{$this->lineup}',";
		}
		if (isset($this->all_gs))
		{
			$fields .= "`all_gs`,";
			$values .= "'{$this->all_gs}',";
		}
		if (isset($this->is_robot))
		{
			$fields .= "`is_robot`,";
			$values .= "'{$this->is_robot}',";
		}

		
		$fields .= ")";
		$values .= ")";
		
		$sql = "INSERT INTO `player_arena` ".$fields.$values;
		
		return str_replace(",)",")",$sql);
	}
	
	private function  getUpFields()
	{
		$update = "";
		
		if ($this->zone_id_status_field)
		{			
			if (!isset($this->zone_id))
			{
				$update .= ("`zone_id`=null,");
			}
			else
			{
				$update .= ("`zone_id`='{$this->zone_id}',");
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
		if ($this->rank_status_field)
		{			
			if (!isset($this->rank))
			{
				$update .= ("`rank`=null,");
			}
			else
			{
				$update .= ("`rank`='{$this->rank}',");
			}
		}
		if ($this->best_rank_status_field)
		{			
			if (!isset($this->best_rank))
			{
				$update .= ("`best_rank`=null,");
			}
			else
			{
				$update .= ("`best_rank`='{$this->best_rank}',");
			}
		}
		if ($this->reward_rank_list_status_field)
		{			
			if (!isset($this->reward_rank_list))
			{
				$update .= ("`reward_rank_list`=null,");
			}
			else
			{
				$update .= ("`reward_rank_list`='{$this->reward_rank_list}',");
			}
		}
		if ($this->fight_count_status_field)
		{			
			if (!isset($this->fight_count))
			{
				$update .= ("`fight_count`=null,");
			}
			else
			{
				$update .= ("`fight_count`='{$this->fight_count}',");
			}
		}
		if ($this->last_fight_time_status_field)
		{			
			if (!isset($this->last_fight_time))
			{
				$update .= ("`last_fight_time`=null,");
			}
			else
			{
				$update .= ("`last_fight_time`='{$this->last_fight_time}',");
			}
		}
		if ($this->buy_count_status_field)
		{			
			if (!isset($this->buy_count))
			{
				$update .= ("`buy_count`=null,");
			}
			else
			{
				$update .= ("`buy_count`='{$this->buy_count}',");
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
		if ($this->win_count_status_field)
		{			
			if (!isset($this->win_count))
			{
				$update .= ("`win_count`=null,");
			}
			else
			{
				$update .= ("`win_count`='{$this->win_count}',");
			}
		}
		if ($this->lineup_status_field)
		{			
			if (!isset($this->lineup))
			{
				$update .= ("`lineup`=null,");
			}
			else
			{
				$update .= ("`lineup`='{$this->lineup}',");
			}
		}
		if ($this->all_gs_status_field)
		{			
			if (!isset($this->all_gs))
			{
				$update .= ("`all_gs`=null,");
			}
			else
			{
				$update .= ("`all_gs`='{$this->all_gs}',");
			}
		}
		if ($this->is_robot_status_field)
		{			
			if (!isset($this->is_robot))
			{
				$update .= ("`is_robot`=null,");
			}
			else
			{
				$update .= ("`is_robot`='{$this->is_robot}',");
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
		
		$sql = "UPDATE `player_arena` SET {$update} WHERE {$condition}";
		
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
		
		$sql = "UPDATE `player_arena` SET {$update} WHERE {$uc}";
		
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
		
		$sql = "UPDATE `player_arena` SET {$update} WHERE {$uc}";
		
		if(isset($this->user_id)){MySQL::selectDbForUser($this->user_id);}else{MySQL::selectDbForUser($GLOBALS['USER_ID']);}
		$qr = MySQL::getInstance()->RunQuery($sql);
				
		return (boolean)$qr;
	}
	
	private function /*void*/ clean() 
	{
		$this->this_table_status_field = false;
		$this->user_id_status_field = false;
		$this->zone_id_status_field = false;
		$this->server_id_status_field = false;
		$this->rank_status_field = false;
		$this->best_rank_status_field = false;
		$this->reward_rank_list_status_field = false;
		$this->fight_count_status_field = false;
		$this->last_fight_time_status_field = false;
		$this->buy_count_status_field = false;
		$this->last_buy_time_status_field = false;
		$this->win_count_status_field = false;
		$this->lineup_status_field = false;
		$this->all_gs_status_field = false;
		$this->is_robot_status_field = false;

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

	public function /*int*/ getZoneId()
	{
		return $this->zone_id;
	}
	
	public function /*void*/ setZoneId(/*int*/ $zone_id)
	{
		$this->zone_id = intval($zone_id);
		$this->zone_id_status_field = true;		
		$this->this_table_status_field = true;		
	}

	public function /*void*/ setZoneIdNull()
	{
		$this->zone_id = null;
		$this->zone_id_status_field = true;		
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

	public function /*int*/ getRank()
	{
		return $this->rank;
	}
	
	public function /*void*/ setRank(/*int*/ $rank)
	{
		$this->rank = intval($rank);
		$this->rank_status_field = true;		
		$this->this_table_status_field = true;		
	}

	public function /*void*/ setRankNull()
	{
		$this->rank = null;
		$this->rank_status_field = true;		
		$this->this_table_status_field = true;
	}

	public function /*int*/ getBestRank()
	{
		return $this->best_rank;
	}
	
	public function /*void*/ setBestRank(/*int*/ $best_rank)
	{
		$this->best_rank = intval($best_rank);
		$this->best_rank_status_field = true;		
		$this->this_table_status_field = true;		
	}

	public function /*void*/ setBestRankNull()
	{
		$this->best_rank = null;
		$this->best_rank_status_field = true;		
		$this->this_table_status_field = true;
	}

	public function /*string*/ getRewardRankList()
	{
		return $this->reward_rank_list;
	}
	
	public function /*void*/ setRewardRankList(/*string*/ $reward_rank_list)
	{
		$this->reward_rank_list = SQLUtil::toSafeSQLString($reward_rank_list);
		$this->reward_rank_list_status_field = true;		
		$this->this_table_status_field = true;		
	}

	public function /*void*/ setRewardRankListNull()
	{
		$this->reward_rank_list = null;
		$this->reward_rank_list_status_field = true;		
		$this->this_table_status_field = true;
	}

	public function /*int*/ getFightCount()
	{
		return $this->fight_count;
	}
	
	public function /*void*/ setFightCount(/*int*/ $fight_count)
	{
		$this->fight_count = intval($fight_count);
		$this->fight_count_status_field = true;		
		$this->this_table_status_field = true;		
	}

	public function /*void*/ setFightCountNull()
	{
		$this->fight_count = null;
		$this->fight_count_status_field = true;		
		$this->this_table_status_field = true;
	}

	public function /*int*/ getLastFightTime()
	{
		return $this->last_fight_time;
	}
	
	public function /*void*/ setLastFightTime(/*int*/ $last_fight_time)
	{
		$this->last_fight_time = intval($last_fight_time);
		$this->last_fight_time_status_field = true;		
		$this->this_table_status_field = true;		
	}

	public function /*void*/ setLastFightTimeNull()
	{
		$this->last_fight_time = null;
		$this->last_fight_time_status_field = true;		
		$this->this_table_status_field = true;
	}

	public function /*int*/ getBuyCount()
	{
		return $this->buy_count;
	}
	
	public function /*void*/ setBuyCount(/*int*/ $buy_count)
	{
		$this->buy_count = intval($buy_count);
		$this->buy_count_status_field = true;		
		$this->this_table_status_field = true;		
	}

	public function /*void*/ setBuyCountNull()
	{
		$this->buy_count = null;
		$this->buy_count_status_field = true;		
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

	public function /*int*/ getWinCount()
	{
		return $this->win_count;
	}
	
	public function /*void*/ setWinCount(/*int*/ $win_count)
	{
		$this->win_count = intval($win_count);
		$this->win_count_status_field = true;		
		$this->this_table_status_field = true;		
	}

	public function /*void*/ setWinCountNull()
	{
		$this->win_count = null;
		$this->win_count_status_field = true;		
		$this->this_table_status_field = true;
	}

	public function /*string*/ getLineup()
	{
		return $this->lineup;
	}
	
	public function /*void*/ setLineup(/*string*/ $lineup)
	{
		$this->lineup = SQLUtil::toSafeSQLString($lineup);
		$this->lineup_status_field = true;		
		$this->this_table_status_field = true;		
	}

	public function /*void*/ setLineupNull()
	{
		$this->lineup = null;
		$this->lineup_status_field = true;		
		$this->this_table_status_field = true;
	}

	public function /*int*/ getAllGs()
	{
		return $this->all_gs;
	}
	
	public function /*void*/ setAllGs(/*int*/ $all_gs)
	{
		$this->all_gs = intval($all_gs);
		$this->all_gs_status_field = true;		
		$this->this_table_status_field = true;		
	}

	public function /*void*/ setAllGsNull()
	{
		$this->all_gs = null;
		$this->all_gs_status_field = true;		
		$this->this_table_status_field = true;
	}

	public function /*int*/ getIsRobot()
	{
		return $this->is_robot;
	}
	
	public function /*void*/ setIsRobot(/*int*/ $is_robot)
	{
		$this->is_robot = intval($is_robot);
		$this->is_robot_status_field = true;		
		$this->this_table_status_field = true;		
	}

	public function /*void*/ setIsRobotNull()
	{
		$this->is_robot = null;
		$this->is_robot_status_field = true;		
		$this->this_table_status_field = true;
	}

	
	public function /*string*/ toDebugString()
	{
		$dbg = "(";
		
		$dbg .= ("user_id={$this->user_id},");
		$dbg .= ("zone_id={$this->zone_id},");
		$dbg .= ("server_id={$this->server_id},");
		$dbg .= ("rank={$this->rank},");
		$dbg .= ("best_rank={$this->best_rank},");
		$dbg .= ("reward_rank_list={$this->reward_rank_list},");
		$dbg .= ("fight_count={$this->fight_count},");
		$dbg .= ("last_fight_time={$this->last_fight_time},");
		$dbg .= ("buy_count={$this->buy_count},");
		$dbg .= ("last_buy_time={$this->last_buy_time},");
		$dbg .= ("win_count={$this->win_count},");
		$dbg .= ("lineup={$this->lineup},");
		$dbg .= ("all_gs={$this->all_gs},");
		$dbg .= ("is_robot={$this->is_robot},");

		$dbg .= ")";
				
		return str_replace(",)",")",$dbg);
	}
}

?>
