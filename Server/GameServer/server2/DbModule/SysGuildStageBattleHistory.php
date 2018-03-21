<?php
require_once ($GLOBALS ['GAME_ROOT'] . "CMySQL.php");
require_once ("SQLUtil.php");
/**
 *  [The generated files]
 */

class SysGuildStageBattleHistory {
	
	private /*string*/ $id; //PRIMARY KEY 
	private /*string*/ $user_id;
	private /*string*/ $user_name;
	private /*int*/ $damage;
	private /*int*/ $battle_time;
	private /*int*/ $raid_id;
	private /*int*/ $stage_id;
	private /*int*/ $wave;
	private /*string*/ $guild_id;
	private /*int*/ $server_id;
	private /*int*/ $is_kill;
	private /*string*/ $heros;

	
	private $this_table_status_field = false;
	private $id_status_field = false;
	private $user_id_status_field = false;
	private $user_name_status_field = false;
	private $damage_status_field = false;
	private $battle_time_status_field = false;
	private $raid_id_status_field = false;
	private $stage_id_status_field = false;
	private $wave_status_field = false;
	private $guild_id_status_field = false;
	private $server_id_status_field = false;
	private $is_kill_status_field = false;
	private $heros_status_field = false;


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
			$sql = "SELECT {$p} FROM `guild_stage_battle_history`";
		}
		else
		{			
			$sql = "SELECT {$p} FROM `guild_stage_battle_history` WHERE ".SQLUtil::parseCondition($condition);
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
			$tb = new SysGuildStageBattleHistory();			
			if (isset($row['id'])) $tb->id = $row['id'];
			if (isset($row['user_id'])) $tb->user_id = $row['user_id'];
			if (isset($row['user_name'])) $tb->user_name = $row['user_name'];
			if (isset($row['damage'])) $tb->damage = intval($row['damage']);
			if (isset($row['battle_time'])) $tb->battle_time = intval($row['battle_time']);
			if (isset($row['raid_id'])) $tb->raid_id = intval($row['raid_id']);
			if (isset($row['stage_id'])) $tb->stage_id = intval($row['stage_id']);
			if (isset($row['wave'])) $tb->wave = intval($row['wave']);
			if (isset($row['guild_id'])) $tb->guild_id = $row['guild_id'];
			if (isset($row['server_id'])) $tb->server_id = intval($row['server_id']);
			if (isset($row['is_kill'])) $tb->is_kill = intval($row['is_kill']);
			if (isset($row['heros'])) $tb->heros = $row['heros'];
		
			$result[] = $tb;
		}
		
		return $result;
	}	
	
	public static function insertSqlHeader($fields=NULL)
	{
		$result = array();				
		if(!empty($fields)){
			$where = SQLUtil::parseFields($fields);			
			$result[0] = "INSERT INTO `guild_stage_battle_history` ({$where}) VALUES ";	
			$ar = array();
			foreach($fields as $key){
				$ar[$key]=1;
			}
			$result[1] = $ar;
		}else{
			$result[0]="INSERT INTO `guild_stage_battle_history` (`id`,`user_id`,`user_name`,`damage`,`battle_time`,`raid_id`,`stage_id`,`wave`,`guild_id`,`server_id`,`is_kill`,`heros`) VALUES ";
			$result[1] = array('id'=>1,'user_id'=>1,'user_name'=>1,'damage'=>1,'battle_time'=>1,'raid_id'=>1,'stage_id'=>1,'wave'=>1,'guild_id'=>1,'server_id'=>1,'is_kill'=>1,'heros'=>1);
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
		
		$sql = "SELECT {$p} FROM `guild_stage_battle_history` WHERE {$where}";

		MySQL::selectDefaultDb();
		$qr = MySQL::getInstance()->RunQuery($sql);
		$ar = MySQL::getInstance()->FetchArray($qr);
		
		if (!$ar || count($ar)==0)
		{
			return false;
		}
		
		if (isset($ar['id'])) $this->id = $ar['id'];
		if (isset($ar['user_id'])) $this->user_id = $ar['user_id'];
		if (isset($ar['user_name'])) $this->user_name = $ar['user_name'];
		if (isset($ar['damage'])) $this->damage = intval($ar['damage']);
		if (isset($ar['battle_time'])) $this->battle_time = intval($ar['battle_time']);
		if (isset($ar['raid_id'])) $this->raid_id = intval($ar['raid_id']);
		if (isset($ar['stage_id'])) $this->stage_id = intval($ar['stage_id']);
		if (isset($ar['wave'])) $this->wave = intval($ar['wave']);
		if (isset($ar['guild_id'])) $this->guild_id = $ar['guild_id'];
		if (isset($ar['server_id'])) $this->server_id = intval($ar['server_id']);
		if (isset($ar['is_kill'])) $this->is_kill = intval($ar['is_kill']);
		if (isset($ar['heros'])) $this->heros = $ar['heros'];
		
		
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
	
		$sql = "SELECT {$p} FROM `guild_stage_battle_history` WHERE {$where}";
	
				MySQL::selectDefaultDb();
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
    	if (!isset($this->user_name)){
    		$emptyFields = false;
    		$fields[] = 'user_name';
    	}else{
    		$emptyCondition = false; 
    		$condition['user_name']=$this->user_name;
    	}
    	if (!isset($this->damage)){
    		$emptyFields = false;
    		$fields[] = 'damage';
    	}else{
    		$emptyCondition = false; 
    		$condition['damage']=$this->damage;
    	}
    	if (!isset($this->battle_time)){
    		$emptyFields = false;
    		$fields[] = 'battle_time';
    	}else{
    		$emptyCondition = false; 
    		$condition['battle_time']=$this->battle_time;
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
    	if (!isset($this->wave)){
    		$emptyFields = false;
    		$fields[] = 'wave';
    	}else{
    		$emptyCondition = false; 
    		$condition['wave']=$this->wave;
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
    	if (!isset($this->is_kill)){
    		$emptyFields = false;
    		$fields[] = 'is_kill';
    	}else{
    		$emptyCondition = false; 
    		$condition['is_kill']=$this->is_kill;
    	}
    	if (!isset($this->heros)){
    		$emptyFields = false;
    		$fields[] = 'heros';
    	}else{
    		$emptyCondition = false; 
    		$condition['heros']=$this->heros;
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
		
		MySQL::selectDefaultDb();
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
		
		MySQL::selectDefaultDb();

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
		
		$sql = "DELETE FROM `guild_stage_battle_history` WHERE ".SQLUtil::parseCondition($condition);
		
		$qr = MySQL::getInstance()->RunQuery($sql);
				
		return (boolean)$qr;
	}
	
	public function  delete()
	{
		if (!isset($this->id))
		{
			return false;
		}
		
		$sql = "DELETE FROM `guild_stage_battle_history` WHERE `id`='{$this->id}'";
		
		MySQL::selectDefaultDb();
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
 			}else if($f == 'user_name'){
 				$values .= "'{$this->user_name}',";
 			}else if($f == 'damage'){
 				$values .= "'{$this->damage}',";
 			}else if($f == 'battle_time'){
 				$values .= "'{$this->battle_time}',";
 			}else if($f == 'raid_id'){
 				$values .= "'{$this->raid_id}',";
 			}else if($f == 'stage_id'){
 				$values .= "'{$this->stage_id}',";
 			}else if($f == 'wave'){
 				$values .= "'{$this->wave}',";
 			}else if($f == 'guild_id'){
 				$values .= "'{$this->guild_id}',";
 			}else if($f == 'server_id'){
 				$values .= "'{$this->server_id}',";
 			}else if($f == 'is_kill'){
 				$values .= "'{$this->is_kill}',";
 			}else if($f == 'heros'){
 				$values .= "'{$this->heros}',";
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
		if (isset($this->user_name))
		{
			$fields .= "`user_name`,";
			$values .= "'{$this->user_name}',";
		}
		if (isset($this->damage))
		{
			$fields .= "`damage`,";
			$values .= "'{$this->damage}',";
		}
		if (isset($this->battle_time))
		{
			$fields .= "`battle_time`,";
			$values .= "'{$this->battle_time}',";
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
		if (isset($this->wave))
		{
			$fields .= "`wave`,";
			$values .= "'{$this->wave}',";
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
		if (isset($this->is_kill))
		{
			$fields .= "`is_kill`,";
			$values .= "'{$this->is_kill}',";
		}
		if (isset($this->heros))
		{
			$fields .= "`heros`,";
			$values .= "'{$this->heros}',";
		}

		
		$fields .= ")";
		$values .= ")";
		
		$sql = "INSERT INTO `guild_stage_battle_history` ".$fields.$values;
		
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
		if ($this->user_name_status_field)
		{			
			if (!isset($this->user_name))
			{
				$update .= ("`user_name`=null,");
			}
			else
			{
				$update .= ("`user_name`='{$this->user_name}',");
			}
		}
		if ($this->damage_status_field)
		{			
			if (!isset($this->damage))
			{
				$update .= ("`damage`=null,");
			}
			else
			{
				$update .= ("`damage`='{$this->damage}',");
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
		if ($this->wave_status_field)
		{			
			if (!isset($this->wave))
			{
				$update .= ("`wave`=null,");
			}
			else
			{
				$update .= ("`wave`='{$this->wave}',");
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
		if ($this->is_kill_status_field)
		{			
			if (!isset($this->is_kill))
			{
				$update .= ("`is_kill`=null,");
			}
			else
			{
				$update .= ("`is_kill`='{$this->is_kill}',");
			}
		}
		if ($this->heros_status_field)
		{			
			if (!isset($this->heros))
			{
				$update .= ("`heros`=null,");
			}
			else
			{
				$update .= ("`heros`='{$this->heros}',");
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
		
		$sql = "UPDATE `guild_stage_battle_history` SET {$update} WHERE {$condition}";
		
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
		
		$sql = "UPDATE `guild_stage_battle_history` SET {$update} WHERE {$uc}";
		
		MySQL::selectDefaultDb();
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
		
		$sql = "UPDATE `guild_stage_battle_history` SET {$update} WHERE {$uc}";
		
		MySQL::selectDefaultDb();
		$qr = MySQL::getInstance()->RunQuery($sql);
				
		return (boolean)$qr;
	}
	
	private function /*void*/ clean() 
	{
		$this->this_table_status_field = false;
		$this->id_status_field = false;
		$this->user_id_status_field = false;
		$this->user_name_status_field = false;
		$this->damage_status_field = false;
		$this->battle_time_status_field = false;
		$this->raid_id_status_field = false;
		$this->stage_id_status_field = false;
		$this->wave_status_field = false;
		$this->guild_id_status_field = false;
		$this->server_id_status_field = false;
		$this->is_kill_status_field = false;
		$this->heros_status_field = false;

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

	public function /*string*/ getUserName()
	{
		return $this->user_name;
	}
	
	public function /*void*/ setUserName(/*string*/ $user_name)
	{
		$this->user_name = SQLUtil::toSafeSQLString($user_name);
		$this->user_name_status_field = true;		
		$this->this_table_status_field = true;		
	}

	public function /*void*/ setUserNameNull()
	{
		$this->user_name = null;
		$this->user_name_status_field = true;		
		$this->this_table_status_field = true;
	}

	public function /*int*/ getDamage()
	{
		return $this->damage;
	}
	
	public function /*void*/ setDamage(/*int*/ $damage)
	{
		$this->damage = intval($damage);
		$this->damage_status_field = true;		
		$this->this_table_status_field = true;		
	}

	public function /*void*/ setDamageNull()
	{
		$this->damage = null;
		$this->damage_status_field = true;		
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

	public function /*int*/ getWave()
	{
		return $this->wave;
	}
	
	public function /*void*/ setWave(/*int*/ $wave)
	{
		$this->wave = intval($wave);
		$this->wave_status_field = true;		
		$this->this_table_status_field = true;		
	}

	public function /*void*/ setWaveNull()
	{
		$this->wave = null;
		$this->wave_status_field = true;		
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

	public function /*int*/ getIsKill()
	{
		return $this->is_kill;
	}
	
	public function /*void*/ setIsKill(/*int*/ $is_kill)
	{
		$this->is_kill = intval($is_kill);
		$this->is_kill_status_field = true;		
		$this->this_table_status_field = true;		
	}

	public function /*void*/ setIsKillNull()
	{
		$this->is_kill = null;
		$this->is_kill_status_field = true;		
		$this->this_table_status_field = true;
	}

	public function /*string*/ getHeros()
	{
		return $this->heros;
	}
	
	public function /*void*/ setHeros(/*string*/ $heros)
	{
		$this->heros = SQLUtil::toSafeSQLString($heros);
		$this->heros_status_field = true;		
		$this->this_table_status_field = true;		
	}

	public function /*void*/ setHerosNull()
	{
		$this->heros = null;
		$this->heros_status_field = true;		
		$this->this_table_status_field = true;
	}

	
	public function /*string*/ toDebugString()
	{
		$dbg = "(";
		
		$dbg .= ("id={$this->id},");
		$dbg .= ("user_id={$this->user_id},");
		$dbg .= ("user_name={$this->user_name},");
		$dbg .= ("damage={$this->damage},");
		$dbg .= ("battle_time={$this->battle_time},");
		$dbg .= ("raid_id={$this->raid_id},");
		$dbg .= ("stage_id={$this->stage_id},");
		$dbg .= ("wave={$this->wave},");
		$dbg .= ("guild_id={$this->guild_id},");
		$dbg .= ("server_id={$this->server_id},");
		$dbg .= ("is_kill={$this->is_kill},");
		$dbg .= ("heros={$this->heros},");

		$dbg .= ")";
				
		return str_replace(",)",")",$dbg);
	}
}

?>
