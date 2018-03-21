<?php
require_once ($GLOBALS ['GAME_ROOT'] . "CMySQL.php");
require_once ("SQLUtil.php");
/**
 *  [The generated files]
 */

class SysPlayerGuildStage {
	
	private /*string*/ $id; //PRIMARY KEY 
	private /*string*/ $user_id;
	private /*int*/ $raid_id;
	private /*int*/ $stage_id;
	private /*int*/ $wave_index;
	private /*int*/ $battle_time;
	private /*int*/ $count;
	private /*int*/ $total_damage;
	private /*int*/ $server_id;
	private /*string*/ $guild_id;
	private /*int*/ $max_damage;

	
	private $this_table_status_field = false;
	private $id_status_field = false;
	private $user_id_status_field = false;
	private $raid_id_status_field = false;
	private $stage_id_status_field = false;
	private $wave_index_status_field = false;
	private $battle_time_status_field = false;
	private $count_status_field = false;
	private $total_damage_status_field = false;
	private $server_id_status_field = false;
	private $guild_id_status_field = false;
	private $max_damage_status_field = false;


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
			$sql = "SELECT {$p} FROM `player_guild_stage`";
		}
		else
		{			
			$sql = "SELECT {$p} FROM `player_guild_stage` WHERE ".SQLUtil::parseCondition($condition);
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
			$tb = new SysPlayerGuildStage();			
			if (isset($row['id'])) $tb->id = $row['id'];
			if (isset($row['user_id'])) $tb->user_id = $row['user_id'];
			if (isset($row['raid_id'])) $tb->raid_id = intval($row['raid_id']);
			if (isset($row['stage_id'])) $tb->stage_id = intval($row['stage_id']);
			if (isset($row['wave_index'])) $tb->wave_index = intval($row['wave_index']);
			if (isset($row['battle_time'])) $tb->battle_time = intval($row['battle_time']);
			if (isset($row['count'])) $tb->count = intval($row['count']);
			if (isset($row['total_damage'])) $tb->total_damage = intval($row['total_damage']);
			if (isset($row['server_id'])) $tb->server_id = intval($row['server_id']);
			if (isset($row['guild_id'])) $tb->guild_id = $row['guild_id'];
			if (isset($row['max_damage'])) $tb->max_damage = intval($row['max_damage']);
		
			$result[] = $tb;
		}
		
		return $result;
	}	
	
	public static function insertSqlHeader($fields=NULL)
	{
		$result = array();				
		if(!empty($fields)){
			$where = SQLUtil::parseFields($fields);			
			$result[0] = "INSERT INTO `player_guild_stage` ({$where}) VALUES ";	
			$ar = array();
			foreach($fields as $key){
				$ar[$key]=1;
			}
			$result[1] = $ar;
		}else{
			$result[0]="INSERT INTO `player_guild_stage` (`id`,`user_id`,`raid_id`,`stage_id`,`wave_index`,`battle_time`,`count`,`total_damage`,`server_id`,`guild_id`,`max_damage`) VALUES ";
			$result[1] = array('id'=>1,'user_id'=>1,'raid_id'=>1,'stage_id'=>1,'wave_index'=>1,'battle_time'=>1,'count'=>1,'total_damage'=>1,'server_id'=>1,'guild_id'=>1,'max_damage'=>1);
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
		
		$sql = "SELECT {$p} FROM `player_guild_stage` WHERE {$where}";

		if(isset($this->user_id)){MySQL::selectDbForUser($this->user_id);}else{MySQL::selectDbForUser($GLOBALS['USER_ID']);}
		$qr = MySQL::getInstance()->RunQuery($sql);
		$ar = MySQL::getInstance()->FetchArray($qr);
		
		if (!$ar || count($ar)==0)
		{
			return false;
		}
		
		if (isset($ar['id'])) $this->id = $ar['id'];
		if (isset($ar['user_id'])) $this->user_id = $ar['user_id'];
		if (isset($ar['raid_id'])) $this->raid_id = intval($ar['raid_id']);
		if (isset($ar['stage_id'])) $this->stage_id = intval($ar['stage_id']);
		if (isset($ar['wave_index'])) $this->wave_index = intval($ar['wave_index']);
		if (isset($ar['battle_time'])) $this->battle_time = intval($ar['battle_time']);
		if (isset($ar['count'])) $this->count = intval($ar['count']);
		if (isset($ar['total_damage'])) $this->total_damage = intval($ar['total_damage']);
		if (isset($ar['server_id'])) $this->server_id = intval($ar['server_id']);
		if (isset($ar['guild_id'])) $this->guild_id = $ar['guild_id'];
		if (isset($ar['max_damage'])) $this->max_damage = intval($ar['max_damage']);
		
		
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
	
		$sql = "SELECT {$p} FROM `player_guild_stage` WHERE {$where}";
	
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
    	if (!isset($this->raid_id)){
    		$emptyFields = false;
    		$fields[] = 'raid_id';
    	}else{
    		$emptyCondition = false; 
    		$condition['raid_id']=$this->raid_id;
    	}
    	if (!isset($this->stage_id)){
    		$emptyFields = false;
    		$fields[] = 'stage_id';
    	}else{
    		$emptyCondition = false; 
    		$condition['stage_id']=$this->stage_id;
    	}
    	if (!isset($this->wave_index)){
    		$emptyFields = false;
    		$fields[] = 'wave_index';
    	}else{
    		$emptyCondition = false; 
    		$condition['wave_index']=$this->wave_index;
    	}
    	if (!isset($this->battle_time)){
    		$emptyFields = false;
    		$fields[] = 'battle_time';
    	}else{
    		$emptyCondition = false; 
    		$condition['battle_time']=$this->battle_time;
    	}
    	if (!isset($this->count)){
    		$emptyFields = false;
    		$fields[] = 'count';
    	}else{
    		$emptyCondition = false; 
    		$condition['count']=$this->count;
    	}
    	if (!isset($this->total_damage)){
    		$emptyFields = false;
    		$fields[] = 'total_damage';
    	}else{
    		$emptyCondition = false; 
    		$condition['total_damage']=$this->total_damage;
    	}
    	if (!isset($this->server_id)){
    		$emptyFields = false;
    		$fields[] = 'server_id';
    	}else{
    		$emptyCondition = false; 
    		$condition['server_id']=$this->server_id;
    	}
    	if (!isset($this->guild_id)){
    		$emptyFields = false;
    		$fields[] = 'guild_id';
    	}else{
    		$emptyCondition = false; 
    		$condition['guild_id']=$this->guild_id;
    	}
    	if (!isset($this->max_damage)){
    		$emptyFields = false;
    		$fields[] = 'max_damage';
    	}else{
    		$emptyCondition = false; 
    		$condition['max_damage']=$this->max_damage;
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
		
		$sql = "DELETE FROM `player_guild_stage` WHERE ".SQLUtil::parseCondition($condition);
		
		$qr = MySQL::getInstance()->RunQuery($sql);
				
		return (boolean)$qr;
	}
	
	public function  delete()
	{
		if (!isset($this->id))
		{
			return false;
		}
		
		$sql = "DELETE FROM `player_guild_stage` WHERE `id`='{$this->id}'";
		
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
 			}else if($f == 'raid_id'){
 				$values .= "'{$this->raid_id}',";
 			}else if($f == 'stage_id'){
 				$values .= "'{$this->stage_id}',";
 			}else if($f == 'wave_index'){
 				$values .= "'{$this->wave_index}',";
 			}else if($f == 'battle_time'){
 				$values .= "'{$this->battle_time}',";
 			}else if($f == 'count'){
 				$values .= "'{$this->count}',";
 			}else if($f == 'total_damage'){
 				$values .= "'{$this->total_damage}',";
 			}else if($f == 'server_id'){
 				$values .= "'{$this->server_id}',";
 			}else if($f == 'guild_id'){
 				$values .= "'{$this->guild_id}',";
 			}else if($f == 'max_damage'){
 				$values .= "'{$this->max_damage}',";
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
		if (isset($this->raid_id))
		{
			$fields .= "`raid_id`,";
			$values .= "'{$this->raid_id}',";
		}
		if (isset($this->stage_id))
		{
			$fields .= "`stage_id`,";
			$values .= "'{$this->stage_id}',";
		}
		if (isset($this->wave_index))
		{
			$fields .= "`wave_index`,";
			$values .= "'{$this->wave_index}',";
		}
		if (isset($this->battle_time))
		{
			$fields .= "`battle_time`,";
			$values .= "'{$this->battle_time}',";
		}
		if (isset($this->count))
		{
			$fields .= "`count`,";
			$values .= "'{$this->count}',";
		}
		if (isset($this->total_damage))
		{
			$fields .= "`total_damage`,";
			$values .= "'{$this->total_damage}',";
		}
		if (isset($this->server_id))
		{
			$fields .= "`server_id`,";
			$values .= "'{$this->server_id}',";
		}
		if (isset($this->guild_id))
		{
			$fields .= "`guild_id`,";
			$values .= "'{$this->guild_id}',";
		}
		if (isset($this->max_damage))
		{
			$fields .= "`max_damage`,";
			$values .= "'{$this->max_damage}',";
		}

		
		$fields .= ")";
		$values .= ")";
		
		$sql = "INSERT INTO `player_guild_stage` ".$fields.$values;
		
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
		if ($this->stage_id_status_field)
		{			
			if (!isset($this->stage_id))
			{
				$update .= ("`stage_id`=null,");
			}
			else
			{
				$update .= ("`stage_id`='{$this->stage_id}',");
			}
		}
		if ($this->wave_index_status_field)
		{			
			if (!isset($this->wave_index))
			{
				$update .= ("`wave_index`=null,");
			}
			else
			{
				$update .= ("`wave_index`='{$this->wave_index}',");
			}
		}
		if ($this->battle_time_status_field)
		{			
			if (!isset($this->battle_time))
			{
				$update .= ("`battle_time`=null,");
			}
			else
			{
				$update .= ("`battle_time`='{$this->battle_time}',");
			}
		}
		if ($this->count_status_field)
		{			
			if (!isset($this->count))
			{
				$update .= ("`count`=null,");
			}
			else
			{
				$update .= ("`count`='{$this->count}',");
			}
		}
		if ($this->total_damage_status_field)
		{			
			if (!isset($this->total_damage))
			{
				$update .= ("`total_damage`=null,");
			}
			else
			{
				$update .= ("`total_damage`='{$this->total_damage}',");
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
		if ($this->max_damage_status_field)
		{			
			if (!isset($this->max_damage))
			{
				$update .= ("`max_damage`=null,");
			}
			else
			{
				$update .= ("`max_damage`='{$this->max_damage}',");
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
		
		$sql = "UPDATE `player_guild_stage` SET {$update} WHERE {$condition}";
		
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
		
		$sql = "UPDATE `player_guild_stage` SET {$update} WHERE {$uc}";
		
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
		
		$sql = "UPDATE `player_guild_stage` SET {$update} WHERE {$uc}";
		
		if(isset($this->user_id)){MySQL::selectDbForUser($this->user_id);}else{MySQL::selectDbForUser($GLOBALS['USER_ID']);}
		$qr = MySQL::getInstance()->RunQuery($sql);
				
		return (boolean)$qr;
	}
	
	private function /*void*/ clean() 
	{
		$this->this_table_status_field = false;
		$this->id_status_field = false;
		$this->user_id_status_field = false;
		$this->raid_id_status_field = false;
		$this->stage_id_status_field = false;
		$this->wave_index_status_field = false;
		$this->battle_time_status_field = false;
		$this->count_status_field = false;
		$this->total_damage_status_field = false;
		$this->server_id_status_field = false;
		$this->guild_id_status_field = false;
		$this->max_damage_status_field = false;

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

	public function /*int*/ getStageId()
	{
		return $this->stage_id;
	}
	
	public function /*void*/ setStageId(/*int*/ $stage_id)
	{
		$this->stage_id = intval($stage_id);
		$this->stage_id_status_field = true;		
		$this->this_table_status_field = true;		
	}

	public function /*void*/ setStageIdNull()
	{
		$this->stage_id = null;
		$this->stage_id_status_field = true;		
		$this->this_table_status_field = true;
	}

	public function /*int*/ getWaveIndex()
	{
		return $this->wave_index;
	}
	
	public function /*void*/ setWaveIndex(/*int*/ $wave_index)
	{
		$this->wave_index = intval($wave_index);
		$this->wave_index_status_field = true;		
		$this->this_table_status_field = true;		
	}

	public function /*void*/ setWaveIndexNull()
	{
		$this->wave_index = null;
		$this->wave_index_status_field = true;		
		$this->this_table_status_field = true;
	}

	public function /*int*/ getBattleTime()
	{
		return $this->battle_time;
	}
	
	public function /*void*/ setBattleTime(/*int*/ $battle_time)
	{
		$this->battle_time = intval($battle_time);
		$this->battle_time_status_field = true;		
		$this->this_table_status_field = true;		
	}

	public function /*void*/ setBattleTimeNull()
	{
		$this->battle_time = null;
		$this->battle_time_status_field = true;		
		$this->this_table_status_field = true;
	}

	public function /*int*/ getCount()
	{
		return $this->count;
	}
	
	public function /*void*/ setCount(/*int*/ $count)
	{
		$this->count = intval($count);
		$this->count_status_field = true;		
		$this->this_table_status_field = true;		
	}

	public function /*void*/ setCountNull()
	{
		$this->count = null;
		$this->count_status_field = true;		
		$this->this_table_status_field = true;
	}

	public function /*int*/ getTotalDamage()
	{
		return $this->total_damage;
	}
	
	public function /*void*/ setTotalDamage(/*int*/ $total_damage)
	{
		$this->total_damage = intval($total_damage);
		$this->total_damage_status_field = true;		
		$this->this_table_status_field = true;		
	}

	public function /*void*/ setTotalDamageNull()
	{
		$this->total_damage = null;
		$this->total_damage_status_field = true;		
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

	public function /*int*/ getMaxDamage()
	{
		return $this->max_damage;
	}
	
	public function /*void*/ setMaxDamage(/*int*/ $max_damage)
	{
		$this->max_damage = intval($max_damage);
		$this->max_damage_status_field = true;		
		$this->this_table_status_field = true;		
	}

	public function /*void*/ setMaxDamageNull()
	{
		$this->max_damage = null;
		$this->max_damage_status_field = true;		
		$this->this_table_status_field = true;
	}

	
	public function /*string*/ toDebugString()
	{
		$dbg = "(";
		
		$dbg .= ("id={$this->id},");
		$dbg .= ("user_id={$this->user_id},");
		$dbg .= ("raid_id={$this->raid_id},");
		$dbg .= ("stage_id={$this->stage_id},");
		$dbg .= ("wave_index={$this->wave_index},");
		$dbg .= ("battle_time={$this->battle_time},");
		$dbg .= ("count={$this->count},");
		$dbg .= ("total_damage={$this->total_damage},");
		$dbg .= ("server_id={$this->server_id},");
		$dbg .= ("guild_id={$this->guild_id},");
		$dbg .= ("max_damage={$this->max_damage},");

		$dbg .= ")";
				
		return str_replace(",)",")",$dbg);
	}
}

?>
