<?php
require_once ($GLOBALS ['GAME_ROOT'] . "CMySQL.php");
require_once ("SQLUtil.php");
/**
 *  [The generated files]
 */

class SysExcavateInfo {
	
	private /*string*/ $id; //PRIMARY KEY 
	private /*int*/ $owner;
	private /*string*/ $user_id;
	private /*int*/ $type_id;
	private /*int*/ $state;
	private /*int*/ $state_end_ts;
	private /*int*/ $create_time;
	private /*int*/ $server_id;
	private /*int*/ $team_id;
	private /*int*/ $id_help1;
	private /*int*/ $id_help2;
	private /*int*/ $robbed;
	private /*int*/ $team_gs;

	
	private $this_table_status_field = false;
	private $id_status_field = false;
	private $owner_status_field = false;
	private $user_id_status_field = false;
	private $type_id_status_field = false;
	private $state_status_field = false;
	private $state_end_ts_status_field = false;
	private $create_time_status_field = false;
	private $server_id_status_field = false;
	private $team_id_status_field = false;
	private $id_help1_status_field = false;
	private $id_help2_status_field = false;
	private $robbed_status_field = false;
	private $team_gs_status_field = false;


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
			$sql = "SELECT {$p} FROM `excavate_info`";
		}
		else
		{			
			$sql = "SELECT {$p} FROM `excavate_info` WHERE ".SQLUtil::parseCondition($condition);
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
			$tb = new SysExcavateInfo();			
			if (isset($row['id'])) $tb->id = $row['id'];
			if (isset($row['owner'])) $tb->owner = intval($row['owner']);
			if (isset($row['user_id'])) $tb->user_id = $row['user_id'];
			if (isset($row['type_id'])) $tb->type_id = intval($row['type_id']);
			if (isset($row['state'])) $tb->state = intval($row['state']);
			if (isset($row['state_end_ts'])) $tb->state_end_ts = intval($row['state_end_ts']);
			if (isset($row['create_time'])) $tb->create_time = intval($row['create_time']);
			if (isset($row['server_id'])) $tb->server_id = intval($row['server_id']);
			if (isset($row['team_id'])) $tb->team_id = intval($row['team_id']);
			if (isset($row['id_help1'])) $tb->id_help1 = intval($row['id_help1']);
			if (isset($row['id_help2'])) $tb->id_help2 = intval($row['id_help2']);
			if (isset($row['robbed'])) $tb->robbed = intval($row['robbed']);
			if (isset($row['team_gs'])) $tb->team_gs = intval($row['team_gs']);
		
			$result[] = $tb;
		}
		
		return $result;
	}	
	
	public static function insertSqlHeader($fields=NULL)
	{
		$result = array();				
		if(!empty($fields)){
			$where = SQLUtil::parseFields($fields);			
			$result[0] = "INSERT INTO `excavate_info` ({$where}) VALUES ";	
			$ar = array();
			foreach($fields as $key){
				$ar[$key]=1;
			}
			$result[1] = $ar;
		}else{
			$result[0]="INSERT INTO `excavate_info` (`id`,`owner`,`user_id`,`type_id`,`state`,`state_end_ts`,`create_time`,`server_id`,`team_id`,`id_help1`,`id_help2`,`robbed`,`team_gs`) VALUES ";
			$result[1] = array('id'=>1,'owner'=>1,'user_id'=>1,'type_id'=>1,'state'=>1,'state_end_ts'=>1,'create_time'=>1,'server_id'=>1,'team_id'=>1,'id_help1'=>1,'id_help2'=>1,'robbed'=>1,'team_gs'=>1);
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
		
		$sql = "SELECT {$p} FROM `excavate_info` WHERE {$where}";

		MySQL::selectDefaultDb();
		$qr = MySQL::getInstance()->RunQuery($sql);
		$ar = MySQL::getInstance()->FetchArray($qr);
		
		if (!$ar || count($ar)==0)
		{
			return false;
		}
		
		if (isset($ar['id'])) $this->id = $ar['id'];
		if (isset($ar['owner'])) $this->owner = intval($ar['owner']);
		if (isset($ar['user_id'])) $this->user_id = $ar['user_id'];
		if (isset($ar['type_id'])) $this->type_id = intval($ar['type_id']);
		if (isset($ar['state'])) $this->state = intval($ar['state']);
		if (isset($ar['state_end_ts'])) $this->state_end_ts = intval($ar['state_end_ts']);
		if (isset($ar['create_time'])) $this->create_time = intval($ar['create_time']);
		if (isset($ar['server_id'])) $this->server_id = intval($ar['server_id']);
		if (isset($ar['team_id'])) $this->team_id = intval($ar['team_id']);
		if (isset($ar['id_help1'])) $this->id_help1 = intval($ar['id_help1']);
		if (isset($ar['id_help2'])) $this->id_help2 = intval($ar['id_help2']);
		if (isset($ar['robbed'])) $this->robbed = intval($ar['robbed']);
		if (isset($ar['team_gs'])) $this->team_gs = intval($ar['team_gs']);
		
		
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
	
		$sql = "SELECT {$p} FROM `excavate_info` WHERE {$where}";
	
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
    	if (!isset($this->owner)){
    		$emptyFields = false;
    		$fields[] = 'owner';
    	}else{
    		$emptyCondition = false; 
    		$condition['owner']=$this->owner;
    	}
    	if (!isset($this->user_id)){
    		$emptyFields = false;
    		$fields[] = 'user_id';
    	}else{
    		$emptyCondition = false; 
    		$condition['user_id']=$this->user_id;
    	}
    	if (!isset($this->type_id)){
    		$emptyFields = false;
    		$fields[] = 'type_id';
    	}else{
    		$emptyCondition = false; 
    		$condition['type_id']=$this->type_id;
    	}
    	if (!isset($this->state)){
    		$emptyFields = false;
    		$fields[] = 'state';
    	}else{
    		$emptyCondition = false; 
    		$condition['state']=$this->state;
    	}
    	if (!isset($this->state_end_ts)){
    		$emptyFields = false;
    		$fields[] = 'state_end_ts';
    	}else{
    		$emptyCondition = false; 
    		$condition['state_end_ts']=$this->state_end_ts;
    	}
    	if (!isset($this->create_time)){
    		$emptyFields = false;
    		$fields[] = 'create_time';
    	}else{
    		$emptyCondition = false; 
    		$condition['create_time']=$this->create_time;
    	}
    	if (!isset($this->server_id)){
    		$emptyFields = false;
    		$fields[] = 'server_id';
    	}else{
    		$emptyCondition = false; 
    		$condition['server_id']=$this->server_id;
    	}
    	if (!isset($this->team_id)){
    		$emptyFields = false;
    		$fields[] = 'team_id';
    	}else{
    		$emptyCondition = false; 
    		$condition['team_id']=$this->team_id;
    	}
    	if (!isset($this->id_help1)){
    		$emptyFields = false;
    		$fields[] = 'id_help1';
    	}else{
    		$emptyCondition = false; 
    		$condition['id_help1']=$this->id_help1;
    	}
    	if (!isset($this->id_help2)){
    		$emptyFields = false;
    		$fields[] = 'id_help2';
    	}else{
    		$emptyCondition = false; 
    		$condition['id_help2']=$this->id_help2;
    	}
    	if (!isset($this->robbed)){
    		$emptyFields = false;
    		$fields[] = 'robbed';
    	}else{
    		$emptyCondition = false; 
    		$condition['robbed']=$this->robbed;
    	}
    	if (!isset($this->team_gs)){
    		$emptyFields = false;
    		$fields[] = 'team_gs';
    	}else{
    		$emptyCondition = false; 
    		$condition['team_gs']=$this->team_gs;
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
		
		$sql = "DELETE FROM `excavate_info` WHERE ".SQLUtil::parseCondition($condition);
		
		$qr = MySQL::getInstance()->RunQuery($sql);
				
		return (boolean)$qr;
	}
	
	public function  delete()
	{
		if (!isset($this->id))
		{
			return false;
		}
		
		$sql = "DELETE FROM `excavate_info` WHERE `id`='{$this->id}'";
		
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
 			}else if($f == 'owner'){
 				$values .= "'{$this->owner}',";
 			}else if($f == 'user_id'){
 				$values .= "'{$this->user_id}',";
 			}else if($f == 'type_id'){
 				$values .= "'{$this->type_id}',";
 			}else if($f == 'state'){
 				$values .= "'{$this->state}',";
 			}else if($f == 'state_end_ts'){
 				$values .= "'{$this->state_end_ts}',";
 			}else if($f == 'create_time'){
 				$values .= "'{$this->create_time}',";
 			}else if($f == 'server_id'){
 				$values .= "'{$this->server_id}',";
 			}else if($f == 'team_id'){
 				$values .= "'{$this->team_id}',";
 			}else if($f == 'id_help1'){
 				$values .= "'{$this->id_help1}',";
 			}else if($f == 'id_help2'){
 				$values .= "'{$this->id_help2}',";
 			}else if($f == 'robbed'){
 				$values .= "'{$this->robbed}',";
 			}else if($f == 'team_gs'){
 				$values .= "'{$this->team_gs}',";
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
		if (isset($this->owner))
		{
			$fields .= "`owner`,";
			$values .= "'{$this->owner}',";
		}
		if (isset($this->user_id))
		{
			$fields .= "`user_id`,";
			$values .= "'{$this->user_id}',";
		}
		if (isset($this->type_id))
		{
			$fields .= "`type_id`,";
			$values .= "'{$this->type_id}',";
		}
		if (isset($this->state))
		{
			$fields .= "`state`,";
			$values .= "'{$this->state}',";
		}
		if (isset($this->state_end_ts))
		{
			$fields .= "`state_end_ts`,";
			$values .= "'{$this->state_end_ts}',";
		}
		if (isset($this->create_time))
		{
			$fields .= "`create_time`,";
			$values .= "'{$this->create_time}',";
		}
		if (isset($this->server_id))
		{
			$fields .= "`server_id`,";
			$values .= "'{$this->server_id}',";
		}
		if (isset($this->team_id))
		{
			$fields .= "`team_id`,";
			$values .= "'{$this->team_id}',";
		}
		if (isset($this->id_help1))
		{
			$fields .= "`id_help1`,";
			$values .= "'{$this->id_help1}',";
		}
		if (isset($this->id_help2))
		{
			$fields .= "`id_help2`,";
			$values .= "'{$this->id_help2}',";
		}
		if (isset($this->robbed))
		{
			$fields .= "`robbed`,";
			$values .= "'{$this->robbed}',";
		}
		if (isset($this->team_gs))
		{
			$fields .= "`team_gs`,";
			$values .= "'{$this->team_gs}',";
		}

		
		$fields .= ")";
		$values .= ")";
		
		$sql = "INSERT INTO `excavate_info` ".$fields.$values;
		
		return str_replace(",)",")",$sql);
	}
	
	private function  getUpFields()
	{
		$update = "";
		
		if ($this->owner_status_field)
		{			
			if (!isset($this->owner))
			{
				$update .= ("`owner`=null,");
			}
			else
			{
				$update .= ("`owner`='{$this->owner}',");
			}
		}
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
		if ($this->type_id_status_field)
		{			
			if (!isset($this->type_id))
			{
				$update .= ("`type_id`=null,");
			}
			else
			{
				$update .= ("`type_id`='{$this->type_id}',");
			}
		}
		if ($this->state_status_field)
		{			
			if (!isset($this->state))
			{
				$update .= ("`state`=null,");
			}
			else
			{
				$update .= ("`state`='{$this->state}',");
			}
		}
		if ($this->state_end_ts_status_field)
		{			
			if (!isset($this->state_end_ts))
			{
				$update .= ("`state_end_ts`=null,");
			}
			else
			{
				$update .= ("`state_end_ts`='{$this->state_end_ts}',");
			}
		}
		if ($this->create_time_status_field)
		{			
			if (!isset($this->create_time))
			{
				$update .= ("`create_time`=null,");
			}
			else
			{
				$update .= ("`create_time`='{$this->create_time}',");
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
		if ($this->id_help1_status_field)
		{			
			if (!isset($this->id_help1))
			{
				$update .= ("`id_help1`=null,");
			}
			else
			{
				$update .= ("`id_help1`='{$this->id_help1}',");
			}
		}
		if ($this->id_help2_status_field)
		{			
			if (!isset($this->id_help2))
			{
				$update .= ("`id_help2`=null,");
			}
			else
			{
				$update .= ("`id_help2`='{$this->id_help2}',");
			}
		}
		if ($this->robbed_status_field)
		{			
			if (!isset($this->robbed))
			{
				$update .= ("`robbed`=null,");
			}
			else
			{
				$update .= ("`robbed`='{$this->robbed}',");
			}
		}
		if ($this->team_gs_status_field)
		{			
			if (!isset($this->team_gs))
			{
				$update .= ("`team_gs`=null,");
			}
			else
			{
				$update .= ("`team_gs`='{$this->team_gs}',");
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
		
		$sql = "UPDATE `excavate_info` SET {$update} WHERE {$condition}";
		
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
		
		$sql = "UPDATE `excavate_info` SET {$update} WHERE {$uc}";
		
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
		
		$sql = "UPDATE `excavate_info` SET {$update} WHERE {$uc}";
		
		MySQL::selectDefaultDb();
		$qr = MySQL::getInstance()->RunQuery($sql);
				
		return (boolean)$qr;
	}
	
	private function /*void*/ clean() 
	{
		$this->this_table_status_field = false;
		$this->id_status_field = false;
		$this->owner_status_field = false;
		$this->user_id_status_field = false;
		$this->type_id_status_field = false;
		$this->state_status_field = false;
		$this->state_end_ts_status_field = false;
		$this->create_time_status_field = false;
		$this->server_id_status_field = false;
		$this->team_id_status_field = false;
		$this->id_help1_status_field = false;
		$this->id_help2_status_field = false;
		$this->robbed_status_field = false;
		$this->team_gs_status_field = false;

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

	public function /*int*/ getOwner()
	{
		return $this->owner;
	}
	
	public function /*void*/ setOwner(/*int*/ $owner)
	{
		$this->owner = intval($owner);
		$this->owner_status_field = true;		
		$this->this_table_status_field = true;		
	}

	public function /*void*/ setOwnerNull()
	{
		$this->owner = null;
		$this->owner_status_field = true;		
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

	public function /*int*/ getTypeId()
	{
		return $this->type_id;
	}
	
	public function /*void*/ setTypeId(/*int*/ $type_id)
	{
		$this->type_id = intval($type_id);
		$this->type_id_status_field = true;		
		$this->this_table_status_field = true;		
	}

	public function /*void*/ setTypeIdNull()
	{
		$this->type_id = null;
		$this->type_id_status_field = true;		
		$this->this_table_status_field = true;
	}

	public function /*int*/ getState()
	{
		return $this->state;
	}
	
	public function /*void*/ setState(/*int*/ $state)
	{
		$this->state = intval($state);
		$this->state_status_field = true;		
		$this->this_table_status_field = true;		
	}

	public function /*void*/ setStateNull()
	{
		$this->state = null;
		$this->state_status_field = true;		
		$this->this_table_status_field = true;
	}

	public function /*int*/ getStateEndTs()
	{
		return $this->state_end_ts;
	}
	
	public function /*void*/ setStateEndTs(/*int*/ $state_end_ts)
	{
		$this->state_end_ts = intval($state_end_ts);
		$this->state_end_ts_status_field = true;		
		$this->this_table_status_field = true;		
	}

	public function /*void*/ setStateEndTsNull()
	{
		$this->state_end_ts = null;
		$this->state_end_ts_status_field = true;		
		$this->this_table_status_field = true;
	}

	public function /*int*/ getCreateTime()
	{
		return $this->create_time;
	}
	
	public function /*void*/ setCreateTime(/*int*/ $create_time)
	{
		$this->create_time = intval($create_time);
		$this->create_time_status_field = true;		
		$this->this_table_status_field = true;		
	}

	public function /*void*/ setCreateTimeNull()
	{
		$this->create_time = null;
		$this->create_time_status_field = true;		
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

	public function /*int*/ getTeamId()
	{
		return $this->team_id;
	}
	
	public function /*void*/ setTeamId(/*int*/ $team_id)
	{
		$this->team_id = intval($team_id);
		$this->team_id_status_field = true;		
		$this->this_table_status_field = true;		
	}

	public function /*void*/ setTeamIdNull()
	{
		$this->team_id = null;
		$this->team_id_status_field = true;		
		$this->this_table_status_field = true;
	}

	public function /*int*/ getIdHelp1()
	{
		return $this->id_help1;
	}
	
	public function /*void*/ setIdHelp1(/*int*/ $id_help1)
	{
		$this->id_help1 = intval($id_help1);
		$this->id_help1_status_field = true;		
		$this->this_table_status_field = true;		
	}

	public function /*void*/ setIdHelp1Null()
	{
		$this->id_help1 = null;
		$this->id_help1_status_field = true;		
		$this->this_table_status_field = true;
	}

	public function /*int*/ getIdHelp2()
	{
		return $this->id_help2;
	}
	
	public function /*void*/ setIdHelp2(/*int*/ $id_help2)
	{
		$this->id_help2 = intval($id_help2);
		$this->id_help2_status_field = true;		
		$this->this_table_status_field = true;		
	}

	public function /*void*/ setIdHelp2Null()
	{
		$this->id_help2 = null;
		$this->id_help2_status_field = true;		
		$this->this_table_status_field = true;
	}

	public function /*int*/ getRobbed()
	{
		return $this->robbed;
	}
	
	public function /*void*/ setRobbed(/*int*/ $robbed)
	{
		$this->robbed = intval($robbed);
		$this->robbed_status_field = true;		
		$this->this_table_status_field = true;		
	}

	public function /*void*/ setRobbedNull()
	{
		$this->robbed = null;
		$this->robbed_status_field = true;		
		$this->this_table_status_field = true;
	}

	public function /*int*/ getTeamGs()
	{
		return $this->team_gs;
	}
	
	public function /*void*/ setTeamGs(/*int*/ $team_gs)
	{
		$this->team_gs = intval($team_gs);
		$this->team_gs_status_field = true;		
		$this->this_table_status_field = true;		
	}

	public function /*void*/ setTeamGsNull()
	{
		$this->team_gs = null;
		$this->team_gs_status_field = true;		
		$this->this_table_status_field = true;
	}

	
	public function /*string*/ toDebugString()
	{
		$dbg = "(";
		
		$dbg .= ("id={$this->id},");
		$dbg .= ("owner={$this->owner},");
		$dbg .= ("user_id={$this->user_id},");
		$dbg .= ("type_id={$this->type_id},");
		$dbg .= ("state={$this->state},");
		$dbg .= ("state_end_ts={$this->state_end_ts},");
		$dbg .= ("create_time={$this->create_time},");
		$dbg .= ("server_id={$this->server_id},");
		$dbg .= ("team_id={$this->team_id},");
		$dbg .= ("id_help1={$this->id_help1},");
		$dbg .= ("id_help2={$this->id_help2},");
		$dbg .= ("robbed={$this->robbed},");
		$dbg .= ("team_gs={$this->team_gs},");

		$dbg .= ")";
				
		return str_replace(",)",")",$dbg);
	}
}

?>
