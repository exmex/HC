<?php
require_once ($GLOBALS ['GAME_ROOT'] . "CMySQL.php");
require_once ("SQLUtil.php");
/**
 *  [The generated files]
 */

class SysPlayerExcavate {
	
	private /*string*/ $user_id; //PRIMARY KEY 
	private /*string*/ $excavate_id;
	private /*int*/ $search_times;
	private /*string*/ $attacking_id;
	private /*int*/ $last_search_ts;
	private /*string*/ $hero_dynas;
	private /*int*/ $rand_seed;
	private /*string*/ $self_heros;
	private /*int*/ $last_reset_time;
	private /*string*/ $hire_heros;
	private /*string*/ $team_id;
	private /*string*/ $reward_winning;
	private /*string*/ $searched_id;

	
	private $this_table_status_field = false;
	private $user_id_status_field = false;
	private $excavate_id_status_field = false;
	private $search_times_status_field = false;
	private $attacking_id_status_field = false;
	private $last_search_ts_status_field = false;
	private $hero_dynas_status_field = false;
	private $rand_seed_status_field = false;
	private $self_heros_status_field = false;
	private $last_reset_time_status_field = false;
	private $hire_heros_status_field = false;
	private $team_id_status_field = false;
	private $reward_winning_status_field = false;
	private $searched_id_status_field = false;


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
			$sql = "SELECT {$p} FROM `player_excavate`";
		}
		else
		{			
			$sql = "SELECT {$p} FROM `player_excavate` WHERE ".SQLUtil::parseCondition($condition);
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
			$tb = new SysPlayerExcavate();			
			if (isset($row['user_id'])) $tb->user_id = $row['user_id'];
			if (isset($row['excavate_id'])) $tb->excavate_id = $row['excavate_id'];
			if (isset($row['search_times'])) $tb->search_times = intval($row['search_times']);
			if (isset($row['attacking_id'])) $tb->attacking_id = $row['attacking_id'];
			if (isset($row['last_search_ts'])) $tb->last_search_ts = intval($row['last_search_ts']);
			if (isset($row['hero_dynas'])) $tb->hero_dynas = $row['hero_dynas'];
			if (isset($row['rand_seed'])) $tb->rand_seed = intval($row['rand_seed']);
			if (isset($row['self_heros'])) $tb->self_heros = $row['self_heros'];
			if (isset($row['last_reset_time'])) $tb->last_reset_time = intval($row['last_reset_time']);
			if (isset($row['hire_heros'])) $tb->hire_heros = $row['hire_heros'];
			if (isset($row['team_id'])) $tb->team_id = $row['team_id'];
			if (isset($row['reward_winning'])) $tb->reward_winning = $row['reward_winning'];
			if (isset($row['searched_id'])) $tb->searched_id = $row['searched_id'];
		
			$result[] = $tb;
		}
		
		return $result;
	}	
	
	public static function insertSqlHeader($fields=NULL)
	{
		$result = array();				
		if(!empty($fields)){
			$where = SQLUtil::parseFields($fields);			
			$result[0] = "INSERT INTO `player_excavate` ({$where}) VALUES ";	
			$ar = array();
			foreach($fields as $key){
				$ar[$key]=1;
			}
			$result[1] = $ar;
		}else{
			$result[0]="INSERT INTO `player_excavate` (`user_id`,`excavate_id`,`search_times`,`attacking_id`,`last_search_ts`,`hero_dynas`,`rand_seed`,`self_heros`,`last_reset_time`,`hire_heros`,`team_id`,`reward_winning`,`searched_id`) VALUES ";
			$result[1] = array('user_id'=>1,'excavate_id'=>1,'search_times'=>1,'attacking_id'=>1,'last_search_ts'=>1,'hero_dynas'=>1,'rand_seed'=>1,'self_heros'=>1,'last_reset_time'=>1,'hire_heros'=>1,'team_id'=>1,'reward_winning'=>1,'searched_id'=>1);
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
		
		$sql = "SELECT {$p} FROM `player_excavate` WHERE {$where}";

		if(isset($this->user_id)){MySQL::selectDbForUser($this->user_id);}else{MySQL::selectDbForUser($GLOBALS['USER_ID']);}
		$qr = MySQL::getInstance()->RunQuery($sql);
		$ar = MySQL::getInstance()->FetchArray($qr);
		
		if (!$ar || count($ar)==0)
		{
			return false;
		}
		
		if (isset($ar['user_id'])) $this->user_id = $ar['user_id'];
		if (isset($ar['excavate_id'])) $this->excavate_id = $ar['excavate_id'];
		if (isset($ar['search_times'])) $this->search_times = intval($ar['search_times']);
		if (isset($ar['attacking_id'])) $this->attacking_id = $ar['attacking_id'];
		if (isset($ar['last_search_ts'])) $this->last_search_ts = intval($ar['last_search_ts']);
		if (isset($ar['hero_dynas'])) $this->hero_dynas = $ar['hero_dynas'];
		if (isset($ar['rand_seed'])) $this->rand_seed = intval($ar['rand_seed']);
		if (isset($ar['self_heros'])) $this->self_heros = $ar['self_heros'];
		if (isset($ar['last_reset_time'])) $this->last_reset_time = intval($ar['last_reset_time']);
		if (isset($ar['hire_heros'])) $this->hire_heros = $ar['hire_heros'];
		if (isset($ar['team_id'])) $this->team_id = $ar['team_id'];
		if (isset($ar['reward_winning'])) $this->reward_winning = $ar['reward_winning'];
		if (isset($ar['searched_id'])) $this->searched_id = $ar['searched_id'];
		
		
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
	
		$sql = "SELECT {$p} FROM `player_excavate` WHERE {$where}";
	
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
    	if (!isset($this->excavate_id)){
    		$emptyFields = false;
    		$fields[] = 'excavate_id';
    	}else{
    		$emptyCondition = false; 
    		$condition['excavate_id']=$this->excavate_id;
    	}
    	if (!isset($this->search_times)){
    		$emptyFields = false;
    		$fields[] = 'search_times';
    	}else{
    		$emptyCondition = false; 
    		$condition['search_times']=$this->search_times;
    	}
    	if (!isset($this->attacking_id)){
    		$emptyFields = false;
    		$fields[] = 'attacking_id';
    	}else{
    		$emptyCondition = false; 
    		$condition['attacking_id']=$this->attacking_id;
    	}
    	if (!isset($this->last_search_ts)){
    		$emptyFields = false;
    		$fields[] = 'last_search_ts';
    	}else{
    		$emptyCondition = false; 
    		$condition['last_search_ts']=$this->last_search_ts;
    	}
    	if (!isset($this->hero_dynas)){
    		$emptyFields = false;
    		$fields[] = 'hero_dynas';
    	}else{
    		$emptyCondition = false; 
    		$condition['hero_dynas']=$this->hero_dynas;
    	}
    	if (!isset($this->rand_seed)){
    		$emptyFields = false;
    		$fields[] = 'rand_seed';
    	}else{
    		$emptyCondition = false; 
    		$condition['rand_seed']=$this->rand_seed;
    	}
    	if (!isset($this->self_heros)){
    		$emptyFields = false;
    		$fields[] = 'self_heros';
    	}else{
    		$emptyCondition = false; 
    		$condition['self_heros']=$this->self_heros;
    	}
    	if (!isset($this->last_reset_time)){
    		$emptyFields = false;
    		$fields[] = 'last_reset_time';
    	}else{
    		$emptyCondition = false; 
    		$condition['last_reset_time']=$this->last_reset_time;
    	}
    	if (!isset($this->hire_heros)){
    		$emptyFields = false;
    		$fields[] = 'hire_heros';
    	}else{
    		$emptyCondition = false; 
    		$condition['hire_heros']=$this->hire_heros;
    	}
    	if (!isset($this->team_id)){
    		$emptyFields = false;
    		$fields[] = 'team_id';
    	}else{
    		$emptyCondition = false; 
    		$condition['team_id']=$this->team_id;
    	}
    	if (!isset($this->reward_winning)){
    		$emptyFields = false;
    		$fields[] = 'reward_winning';
    	}else{
    		$emptyCondition = false; 
    		$condition['reward_winning']=$this->reward_winning;
    	}
    	if (!isset($this->searched_id)){
    		$emptyFields = false;
    		$fields[] = 'searched_id';
    	}else{
    		$emptyCondition = false; 
    		$condition['searched_id']=$this->searched_id;
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
		
		$sql = "DELETE FROM `player_excavate` WHERE ".SQLUtil::parseCondition($condition);
		
		$qr = MySQL::getInstance()->RunQuery($sql);
				
		return (boolean)$qr;
	}
	
	public function  delete()
	{
		if (!isset($this->user_id))
		{
			return false;
		}
		
		$sql = "DELETE FROM `player_excavate` WHERE `user_id`='{$this->user_id}'";
		
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
 			}else if($f == 'excavate_id'){
 				$values .= "'{$this->excavate_id}',";
 			}else if($f == 'search_times'){
 				$values .= "'{$this->search_times}',";
 			}else if($f == 'attacking_id'){
 				$values .= "'{$this->attacking_id}',";
 			}else if($f == 'last_search_ts'){
 				$values .= "'{$this->last_search_ts}',";
 			}else if($f == 'hero_dynas'){
 				$values .= "'{$this->hero_dynas}',";
 			}else if($f == 'rand_seed'){
 				$values .= "'{$this->rand_seed}',";
 			}else if($f == 'self_heros'){
 				$values .= "'{$this->self_heros}',";
 			}else if($f == 'last_reset_time'){
 				$values .= "'{$this->last_reset_time}',";
 			}else if($f == 'hire_heros'){
 				$values .= "'{$this->hire_heros}',";
 			}else if($f == 'team_id'){
 				$values .= "'{$this->team_id}',";
 			}else if($f == 'reward_winning'){
 				$values .= "'{$this->reward_winning}',";
 			}else if($f == 'searched_id'){
 				$values .= "'{$this->searched_id}',";
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
		if (isset($this->excavate_id))
		{
			$fields .= "`excavate_id`,";
			$values .= "'{$this->excavate_id}',";
		}
		if (isset($this->search_times))
		{
			$fields .= "`search_times`,";
			$values .= "'{$this->search_times}',";
		}
		if (isset($this->attacking_id))
		{
			$fields .= "`attacking_id`,";
			$values .= "'{$this->attacking_id}',";
		}
		if (isset($this->last_search_ts))
		{
			$fields .= "`last_search_ts`,";
			$values .= "'{$this->last_search_ts}',";
		}
		if (isset($this->hero_dynas))
		{
			$fields .= "`hero_dynas`,";
			$values .= "'{$this->hero_dynas}',";
		}
		if (isset($this->rand_seed))
		{
			$fields .= "`rand_seed`,";
			$values .= "'{$this->rand_seed}',";
		}
		if (isset($this->self_heros))
		{
			$fields .= "`self_heros`,";
			$values .= "'{$this->self_heros}',";
		}
		if (isset($this->last_reset_time))
		{
			$fields .= "`last_reset_time`,";
			$values .= "'{$this->last_reset_time}',";
		}
		if (isset($this->hire_heros))
		{
			$fields .= "`hire_heros`,";
			$values .= "'{$this->hire_heros}',";
		}
		if (isset($this->team_id))
		{
			$fields .= "`team_id`,";
			$values .= "'{$this->team_id}',";
		}
		if (isset($this->reward_winning))
		{
			$fields .= "`reward_winning`,";
			$values .= "'{$this->reward_winning}',";
		}
		if (isset($this->searched_id))
		{
			$fields .= "`searched_id`,";
			$values .= "'{$this->searched_id}',";
		}

		
		$fields .= ")";
		$values .= ")";
		
		$sql = "INSERT INTO `player_excavate` ".$fields.$values;
		
		return str_replace(",)",")",$sql);
	}
	
	private function  getUpFields()
	{
		$update = "";
		
		if ($this->excavate_id_status_field)
		{			
			if (!isset($this->excavate_id))
			{
				$update .= ("`excavate_id`=null,");
			}
			else
			{
				$update .= ("`excavate_id`='{$this->excavate_id}',");
			}
		}
		if ($this->search_times_status_field)
		{			
			if (!isset($this->search_times))
			{
				$update .= ("`search_times`=null,");
			}
			else
			{
				$update .= ("`search_times`='{$this->search_times}',");
			}
		}
		if ($this->attacking_id_status_field)
		{			
			if (!isset($this->attacking_id))
			{
				$update .= ("`attacking_id`=null,");
			}
			else
			{
				$update .= ("`attacking_id`='{$this->attacking_id}',");
			}
		}
		if ($this->last_search_ts_status_field)
		{			
			if (!isset($this->last_search_ts))
			{
				$update .= ("`last_search_ts`=null,");
			}
			else
			{
				$update .= ("`last_search_ts`='{$this->last_search_ts}',");
			}
		}
		if ($this->hero_dynas_status_field)
		{			
			if (!isset($this->hero_dynas))
			{
				$update .= ("`hero_dynas`=null,");
			}
			else
			{
				$update .= ("`hero_dynas`='{$this->hero_dynas}',");
			}
		}
		if ($this->rand_seed_status_field)
		{			
			if (!isset($this->rand_seed))
			{
				$update .= ("`rand_seed`=null,");
			}
			else
			{
				$update .= ("`rand_seed`='{$this->rand_seed}',");
			}
		}
		if ($this->self_heros_status_field)
		{			
			if (!isset($this->self_heros))
			{
				$update .= ("`self_heros`=null,");
			}
			else
			{
				$update .= ("`self_heros`='{$this->self_heros}',");
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
		if ($this->hire_heros_status_field)
		{			
			if (!isset($this->hire_heros))
			{
				$update .= ("`hire_heros`=null,");
			}
			else
			{
				$update .= ("`hire_heros`='{$this->hire_heros}',");
			}
		}
		if ($this->team_id_status_field)
		{			
			if (!isset($this->team_id))
			{
				$update .= ("`team_id`=null,");
			}
			else
			{
				$update .= ("`team_id`='{$this->team_id}',");
			}
		}
		if ($this->reward_winning_status_field)
		{			
			if (!isset($this->reward_winning))
			{
				$update .= ("`reward_winning`=null,");
			}
			else
			{
				$update .= ("`reward_winning`='{$this->reward_winning}',");
			}
		}
		if ($this->searched_id_status_field)
		{			
			if (!isset($this->searched_id))
			{
				$update .= ("`searched_id`=null,");
			}
			else
			{
				$update .= ("`searched_id`='{$this->searched_id}',");
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
		
		$sql = "UPDATE `player_excavate` SET {$update} WHERE {$condition}";
		
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
		
		$sql = "UPDATE `player_excavate` SET {$update} WHERE {$uc}";
		
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
		
		$sql = "UPDATE `player_excavate` SET {$update} WHERE {$uc}";
		
		if(isset($this->user_id)){MySQL::selectDbForUser($this->user_id);}else{MySQL::selectDbForUser($GLOBALS['USER_ID']);}
		$qr = MySQL::getInstance()->RunQuery($sql);
				
		return (boolean)$qr;
	}
	
	private function /*void*/ clean() 
	{
		$this->this_table_status_field = false;
		$this->user_id_status_field = false;
		$this->excavate_id_status_field = false;
		$this->search_times_status_field = false;
		$this->attacking_id_status_field = false;
		$this->last_search_ts_status_field = false;
		$this->hero_dynas_status_field = false;
		$this->rand_seed_status_field = false;
		$this->self_heros_status_field = false;
		$this->last_reset_time_status_field = false;
		$this->hire_heros_status_field = false;
		$this->team_id_status_field = false;
		$this->reward_winning_status_field = false;
		$this->searched_id_status_field = false;

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

	public function /*string*/ getExcavateId()
	{
		return $this->excavate_id;
	}
	
	public function /*void*/ setExcavateId(/*string*/ $excavate_id)
	{
		$this->excavate_id = SQLUtil::toSafeSQLString($excavate_id);
		$this->excavate_id_status_field = true;		
		$this->this_table_status_field = true;		
	}

	public function /*void*/ setExcavateIdNull()
	{
		$this->excavate_id = null;
		$this->excavate_id_status_field = true;		
		$this->this_table_status_field = true;
	}

	public function /*int*/ getSearchTimes()
	{
		return $this->search_times;
	}
	
	public function /*void*/ setSearchTimes(/*int*/ $search_times)
	{
		$this->search_times = intval($search_times);
		$this->search_times_status_field = true;		
		$this->this_table_status_field = true;		
	}

	public function /*void*/ setSearchTimesNull()
	{
		$this->search_times = null;
		$this->search_times_status_field = true;		
		$this->this_table_status_field = true;
	}

	public function /*string*/ getAttackingId()
	{
		return $this->attacking_id;
	}
	
	public function /*void*/ setAttackingId(/*string*/ $attacking_id)
	{
		$this->attacking_id = SQLUtil::toSafeSQLString($attacking_id);
		$this->attacking_id_status_field = true;		
		$this->this_table_status_field = true;		
	}

	public function /*void*/ setAttackingIdNull()
	{
		$this->attacking_id = null;
		$this->attacking_id_status_field = true;		
		$this->this_table_status_field = true;
	}

	public function /*int*/ getLastSearchTs()
	{
		return $this->last_search_ts;
	}
	
	public function /*void*/ setLastSearchTs(/*int*/ $last_search_ts)
	{
		$this->last_search_ts = intval($last_search_ts);
		$this->last_search_ts_status_field = true;		
		$this->this_table_status_field = true;		
	}

	public function /*void*/ setLastSearchTsNull()
	{
		$this->last_search_ts = null;
		$this->last_search_ts_status_field = true;		
		$this->this_table_status_field = true;
	}

	public function /*string*/ getHeroDynas()
	{
		return $this->hero_dynas;
	}
	
	public function /*void*/ setHeroDynas(/*string*/ $hero_dynas)
	{
		$this->hero_dynas = SQLUtil::toSafeSQLString($hero_dynas);
		$this->hero_dynas_status_field = true;		
		$this->this_table_status_field = true;		
	}

	public function /*void*/ setHeroDynasNull()
	{
		$this->hero_dynas = null;
		$this->hero_dynas_status_field = true;		
		$this->this_table_status_field = true;
	}

	public function /*int*/ getRandSeed()
	{
		return $this->rand_seed;
	}
	
	public function /*void*/ setRandSeed(/*int*/ $rand_seed)
	{
		$this->rand_seed = intval($rand_seed);
		$this->rand_seed_status_field = true;		
		$this->this_table_status_field = true;		
	}

	public function /*void*/ setRandSeedNull()
	{
		$this->rand_seed = null;
		$this->rand_seed_status_field = true;		
		$this->this_table_status_field = true;
	}

	public function /*string*/ getSelfHeros()
	{
		return $this->self_heros;
	}
	
	public function /*void*/ setSelfHeros(/*string*/ $self_heros)
	{
		$this->self_heros = SQLUtil::toSafeSQLString($self_heros);
		$this->self_heros_status_field = true;		
		$this->this_table_status_field = true;		
	}

	public function /*void*/ setSelfHerosNull()
	{
		$this->self_heros = null;
		$this->self_heros_status_field = true;		
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

	public function /*string*/ getHireHeros()
	{
		return $this->hire_heros;
	}
	
	public function /*void*/ setHireHeros(/*string*/ $hire_heros)
	{
		$this->hire_heros = SQLUtil::toSafeSQLString($hire_heros);
		$this->hire_heros_status_field = true;		
		$this->this_table_status_field = true;		
	}

	public function /*void*/ setHireHerosNull()
	{
		$this->hire_heros = null;
		$this->hire_heros_status_field = true;		
		$this->this_table_status_field = true;
	}

	public function /*string*/ getTeamId()
	{
		return $this->team_id;
	}
	
	public function /*void*/ setTeamId(/*string*/ $team_id)
	{
		$this->team_id = SQLUtil::toSafeSQLString($team_id);
		$this->team_id_status_field = true;		
		$this->this_table_status_field = true;		
	}

	public function /*void*/ setTeamIdNull()
	{
		$this->team_id = null;
		$this->team_id_status_field = true;		
		$this->this_table_status_field = true;
	}

	public function /*string*/ getRewardWinning()
	{
		return $this->reward_winning;
	}
	
	public function /*void*/ setRewardWinning(/*string*/ $reward_winning)
	{
		$this->reward_winning = SQLUtil::toSafeSQLString($reward_winning);
		$this->reward_winning_status_field = true;		
		$this->this_table_status_field = true;		
	}

	public function /*void*/ setRewardWinningNull()
	{
		$this->reward_winning = null;
		$this->reward_winning_status_field = true;		
		$this->this_table_status_field = true;
	}

	public function /*string*/ getSearchedId()
	{
		return $this->searched_id;
	}
	
	public function /*void*/ setSearchedId(/*string*/ $searched_id)
	{
		$this->searched_id = SQLUtil::toSafeSQLString($searched_id);
		$this->searched_id_status_field = true;		
		$this->this_table_status_field = true;		
	}

	public function /*void*/ setSearchedIdNull()
	{
		$this->searched_id = null;
		$this->searched_id_status_field = true;		
		$this->this_table_status_field = true;
	}

	
	public function /*string*/ toDebugString()
	{
		$dbg = "(";
		
		$dbg .= ("user_id={$this->user_id},");
		$dbg .= ("excavate_id={$this->excavate_id},");
		$dbg .= ("search_times={$this->search_times},");
		$dbg .= ("attacking_id={$this->attacking_id},");
		$dbg .= ("last_search_ts={$this->last_search_ts},");
		$dbg .= ("hero_dynas={$this->hero_dynas},");
		$dbg .= ("rand_seed={$this->rand_seed},");
		$dbg .= ("self_heros={$this->self_heros},");
		$dbg .= ("last_reset_time={$this->last_reset_time},");
		$dbg .= ("hire_heros={$this->hire_heros},");
		$dbg .= ("team_id={$this->team_id},");
		$dbg .= ("reward_winning={$this->reward_winning},");
		$dbg .= ("searched_id={$this->searched_id},");

		$dbg .= ")";
				
		return str_replace(",)",")",$dbg);
	}
}

?>
