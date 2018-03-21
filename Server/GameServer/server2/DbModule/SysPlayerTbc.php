<?php
require_once ($GLOBALS ['GAME_ROOT'] . "CMySQL.php");
require_once ("SQLUtil.php");
/**
 *  [The generated files]
 */

class SysPlayerTbc {
	
	private /*string*/ $id; //PRIMARY KEY 
	private /*string*/ $user_id;
	private /*int*/ $cur_stage;
	private /*int*/ $reset_times;
	private /*string*/ $self_heros;
	private /*string*/ $stages;
	private /*string*/ $oppo_heros;
	private /*string*/ $hire_heros;
	private /*string*/ $battle_heros;
	private /*int*/ $rand_seed;
	private /*int*/ $last_reset_time;

	
	private $this_table_status_field = false;
	private $id_status_field = false;
	private $user_id_status_field = false;
	private $cur_stage_status_field = false;
	private $reset_times_status_field = false;
	private $self_heros_status_field = false;
	private $stages_status_field = false;
	private $oppo_heros_status_field = false;
	private $hire_heros_status_field = false;
	private $battle_heros_status_field = false;
	private $rand_seed_status_field = false;
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
			$sql = "SELECT {$p} FROM `player_tbc`";
		}
		else
		{			
			$sql = "SELECT {$p} FROM `player_tbc` WHERE ".SQLUtil::parseCondition($condition);
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
			$tb = new SysPlayerTbc();			
			if (isset($row['id'])) $tb->id = $row['id'];
			if (isset($row['user_id'])) $tb->user_id = $row['user_id'];
			if (isset($row['cur_stage'])) $tb->cur_stage = intval($row['cur_stage']);
			if (isset($row['reset_times'])) $tb->reset_times = intval($row['reset_times']);
			if (isset($row['self_heros'])) $tb->self_heros = $row['self_heros'];
			if (isset($row['stages'])) $tb->stages = $row['stages'];
			if (isset($row['oppo_heros'])) $tb->oppo_heros = $row['oppo_heros'];
			if (isset($row['hire_heros'])) $tb->hire_heros = $row['hire_heros'];
			if (isset($row['battle_heros'])) $tb->battle_heros = $row['battle_heros'];
			if (isset($row['rand_seed'])) $tb->rand_seed = intval($row['rand_seed']);
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
			$result[0] = "INSERT INTO `player_tbc` ({$where}) VALUES ";	
			$ar = array();
			foreach($fields as $key){
				$ar[$key]=1;
			}
			$result[1] = $ar;
		}else{
			$result[0]="INSERT INTO `player_tbc` (`id`,`user_id`,`cur_stage`,`reset_times`,`self_heros`,`stages`,`oppo_heros`,`hire_heros`,`battle_heros`,`rand_seed`,`last_reset_time`) VALUES ";
			$result[1] = array('id'=>1,'user_id'=>1,'cur_stage'=>1,'reset_times'=>1,'self_heros'=>1,'stages'=>1,'oppo_heros'=>1,'hire_heros'=>1,'battle_heros'=>1,'rand_seed'=>1,'last_reset_time'=>1);
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
		
		$sql = "SELECT {$p} FROM `player_tbc` WHERE {$where}";

		if(isset($this->user_id)){MySQL::selectDbForUser($this->user_id);}else{MySQL::selectDbForUser($GLOBALS['USER_ID']);}
		$qr = MySQL::getInstance()->RunQuery($sql);
		$ar = MySQL::getInstance()->FetchArray($qr);
		
		if (!$ar || count($ar)==0)
		{
			return false;
		}
		
		if (isset($ar['id'])) $this->id = $ar['id'];
		if (isset($ar['user_id'])) $this->user_id = $ar['user_id'];
		if (isset($ar['cur_stage'])) $this->cur_stage = intval($ar['cur_stage']);
		if (isset($ar['reset_times'])) $this->reset_times = intval($ar['reset_times']);
		if (isset($ar['self_heros'])) $this->self_heros = $ar['self_heros'];
		if (isset($ar['stages'])) $this->stages = $ar['stages'];
		if (isset($ar['oppo_heros'])) $this->oppo_heros = $ar['oppo_heros'];
		if (isset($ar['hire_heros'])) $this->hire_heros = $ar['hire_heros'];
		if (isset($ar['battle_heros'])) $this->battle_heros = $ar['battle_heros'];
		if (isset($ar['rand_seed'])) $this->rand_seed = intval($ar['rand_seed']);
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
	
		$sql = "SELECT {$p} FROM `player_tbc` WHERE {$where}";
	
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
    	if (!isset($this->cur_stage)){
    		$emptyFields = false;
    		$fields[] = 'cur_stage';
    	}else{
    		$emptyCondition = false; 
    		$condition['cur_stage']=$this->cur_stage;
    	}
    	if (!isset($this->reset_times)){
    		$emptyFields = false;
    		$fields[] = 'reset_times';
    	}else{
    		$emptyCondition = false; 
    		$condition['reset_times']=$this->reset_times;
    	}
    	if (!isset($this->self_heros)){
    		$emptyFields = false;
    		$fields[] = 'self_heros';
    	}else{
    		$emptyCondition = false; 
    		$condition['self_heros']=$this->self_heros;
    	}
    	if (!isset($this->stages)){
    		$emptyFields = false;
    		$fields[] = 'stages';
    	}else{
    		$emptyCondition = false; 
    		$condition['stages']=$this->stages;
    	}
    	if (!isset($this->oppo_heros)){
    		$emptyFields = false;
    		$fields[] = 'oppo_heros';
    	}else{
    		$emptyCondition = false; 
    		$condition['oppo_heros']=$this->oppo_heros;
    	}
    	if (!isset($this->hire_heros)){
    		$emptyFields = false;
    		$fields[] = 'hire_heros';
    	}else{
    		$emptyCondition = false; 
    		$condition['hire_heros']=$this->hire_heros;
    	}
    	if (!isset($this->battle_heros)){
    		$emptyFields = false;
    		$fields[] = 'battle_heros';
    	}else{
    		$emptyCondition = false; 
    		$condition['battle_heros']=$this->battle_heros;
    	}
    	if (!isset($this->rand_seed)){
    		$emptyFields = false;
    		$fields[] = 'rand_seed';
    	}else{
    		$emptyCondition = false; 
    		$condition['rand_seed']=$this->rand_seed;
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
		
		$sql = "DELETE FROM `player_tbc` WHERE ".SQLUtil::parseCondition($condition);
		
		$qr = MySQL::getInstance()->RunQuery($sql);
				
		return (boolean)$qr;
	}
	
	public function  delete()
	{
		if (!isset($this->id))
		{
			return false;
		}
		
		$sql = "DELETE FROM `player_tbc` WHERE `id`='{$this->id}'";
		
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
 			}else if($f == 'cur_stage'){
 				$values .= "'{$this->cur_stage}',";
 			}else if($f == 'reset_times'){
 				$values .= "'{$this->reset_times}',";
 			}else if($f == 'self_heros'){
 				$values .= "'{$this->self_heros}',";
 			}else if($f == 'stages'){
 				$values .= "'{$this->stages}',";
 			}else if($f == 'oppo_heros'){
 				$values .= "'{$this->oppo_heros}',";
 			}else if($f == 'hire_heros'){
 				$values .= "'{$this->hire_heros}',";
 			}else if($f == 'battle_heros'){
 				$values .= "'{$this->battle_heros}',";
 			}else if($f == 'rand_seed'){
 				$values .= "'{$this->rand_seed}',";
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
		if (isset($this->cur_stage))
		{
			$fields .= "`cur_stage`,";
			$values .= "'{$this->cur_stage}',";
		}
		if (isset($this->reset_times))
		{
			$fields .= "`reset_times`,";
			$values .= "'{$this->reset_times}',";
		}
		if (isset($this->self_heros))
		{
			$fields .= "`self_heros`,";
			$values .= "'{$this->self_heros}',";
		}
		if (isset($this->stages))
		{
			$fields .= "`stages`,";
			$values .= "'{$this->stages}',";
		}
		if (isset($this->oppo_heros))
		{
			$fields .= "`oppo_heros`,";
			$values .= "'{$this->oppo_heros}',";
		}
		if (isset($this->hire_heros))
		{
			$fields .= "`hire_heros`,";
			$values .= "'{$this->hire_heros}',";
		}
		if (isset($this->battle_heros))
		{
			$fields .= "`battle_heros`,";
			$values .= "'{$this->battle_heros}',";
		}
		if (isset($this->rand_seed))
		{
			$fields .= "`rand_seed`,";
			$values .= "'{$this->rand_seed}',";
		}
		if (isset($this->last_reset_time))
		{
			$fields .= "`last_reset_time`,";
			$values .= "'{$this->last_reset_time}',";
		}

		
		$fields .= ")";
		$values .= ")";
		
		$sql = "INSERT INTO `player_tbc` ".$fields.$values;
		
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
		if ($this->cur_stage_status_field)
		{			
			if (!isset($this->cur_stage))
			{
				$update .= ("`cur_stage`=null,");
			}
			else
			{
				$update .= ("`cur_stage`='{$this->cur_stage}',");
			}
		}
		if ($this->reset_times_status_field)
		{			
			if (!isset($this->reset_times))
			{
				$update .= ("`reset_times`=null,");
			}
			else
			{
				$update .= ("`reset_times`='{$this->reset_times}',");
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
		if ($this->stages_status_field)
		{			
			if (!isset($this->stages))
			{
				$update .= ("`stages`=null,");
			}
			else
			{
				$update .= ("`stages`='{$this->stages}',");
			}
		}
		if ($this->oppo_heros_status_field)
		{			
			if (!isset($this->oppo_heros))
			{
				$update .= ("`oppo_heros`=null,");
			}
			else
			{
				$update .= ("`oppo_heros`='{$this->oppo_heros}',");
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
		if ($this->battle_heros_status_field)
		{			
			if (!isset($this->battle_heros))
			{
				$update .= ("`battle_heros`=null,");
			}
			else
			{
				$update .= ("`battle_heros`='{$this->battle_heros}',");
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
		
		$sql = "UPDATE `player_tbc` SET {$update} WHERE {$condition}";
		
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
		
		$sql = "UPDATE `player_tbc` SET {$update} WHERE {$uc}";
		
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
		
		$sql = "UPDATE `player_tbc` SET {$update} WHERE {$uc}";
		
		if(isset($this->user_id)){MySQL::selectDbForUser($this->user_id);}else{MySQL::selectDbForUser($GLOBALS['USER_ID']);}
		$qr = MySQL::getInstance()->RunQuery($sql);
				
		return (boolean)$qr;
	}
	
	private function /*void*/ clean() 
	{
		$this->this_table_status_field = false;
		$this->id_status_field = false;
		$this->user_id_status_field = false;
		$this->cur_stage_status_field = false;
		$this->reset_times_status_field = false;
		$this->self_heros_status_field = false;
		$this->stages_status_field = false;
		$this->oppo_heros_status_field = false;
		$this->hire_heros_status_field = false;
		$this->battle_heros_status_field = false;
		$this->rand_seed_status_field = false;
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

	public function /*int*/ getCurStage()
	{
		return $this->cur_stage;
	}
	
	public function /*void*/ setCurStage(/*int*/ $cur_stage)
	{
		$this->cur_stage = intval($cur_stage);
		$this->cur_stage_status_field = true;		
		$this->this_table_status_field = true;		
	}

	public function /*void*/ setCurStageNull()
	{
		$this->cur_stage = null;
		$this->cur_stage_status_field = true;		
		$this->this_table_status_field = true;
	}

	public function /*int*/ getResetTimes()
	{
		return $this->reset_times;
	}
	
	public function /*void*/ setResetTimes(/*int*/ $reset_times)
	{
		$this->reset_times = intval($reset_times);
		$this->reset_times_status_field = true;		
		$this->this_table_status_field = true;		
	}

	public function /*void*/ setResetTimesNull()
	{
		$this->reset_times = null;
		$this->reset_times_status_field = true;		
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

	public function /*string*/ getStages()
	{
		return $this->stages;
	}
	
	public function /*void*/ setStages(/*string*/ $stages)
	{
		$this->stages = SQLUtil::toSafeSQLString($stages);
		$this->stages_status_field = true;		
		$this->this_table_status_field = true;		
	}

	public function /*void*/ setStagesNull()
	{
		$this->stages = null;
		$this->stages_status_field = true;		
		$this->this_table_status_field = true;
	}

	public function /*string*/ getOppoHeros()
	{
		return $this->oppo_heros;
	}
	
	public function /*void*/ setOppoHeros(/*string*/ $oppo_heros)
	{
		$this->oppo_heros = SQLUtil::toSafeSQLString($oppo_heros);
		$this->oppo_heros_status_field = true;		
		$this->this_table_status_field = true;		
	}

	public function /*void*/ setOppoHerosNull()
	{
		$this->oppo_heros = null;
		$this->oppo_heros_status_field = true;		
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

	public function /*string*/ getBattleHeros()
	{
		return $this->battle_heros;
	}
	
	public function /*void*/ setBattleHeros(/*string*/ $battle_heros)
	{
		$this->battle_heros = SQLUtil::toSafeSQLString($battle_heros);
		$this->battle_heros_status_field = true;		
		$this->this_table_status_field = true;		
	}

	public function /*void*/ setBattleHerosNull()
	{
		$this->battle_heros = null;
		$this->battle_heros_status_field = true;		
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
		$dbg .= ("cur_stage={$this->cur_stage},");
		$dbg .= ("reset_times={$this->reset_times},");
		$dbg .= ("self_heros={$this->self_heros},");
		$dbg .= ("stages={$this->stages},");
		$dbg .= ("oppo_heros={$this->oppo_heros},");
		$dbg .= ("hire_heros={$this->hire_heros},");
		$dbg .= ("battle_heros={$this->battle_heros},");
		$dbg .= ("rand_seed={$this->rand_seed},");
		$dbg .= ("last_reset_time={$this->last_reset_time},");

		$dbg .= ")";
				
		return str_replace(",)",")",$dbg);
	}
}

?>
