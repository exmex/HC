<?php
require_once ($GLOBALS ['GAME_ROOT'] . "CMySQL.php");
require_once ("SQLUtil.php");
/**
 *  [The generated files]
 */

class SysServerList {
	
	private /*int*/ $server_id; //PRIMARY KEY 
	private /*string*/ $server_name;
	private /*int*/ $server_state;
	private /*int*/ $server_start_date;
	private /*string*/ $server_zone_flag;
	private /*string*/ $new_server_id;
	private /*int*/ $new_server_time;
	private /*string*/ $server_config;
	private /*string*/ $server_rule;
	private /*string*/ $server_channel;
	private /*string*/ $server_key;
	private /*string*/ $server_ip;
	private /*string*/ $server_host;
	private /*string*/ $server_reamrk;
	private /*string*/ $server_alias;
	private /*int*/ $game_id;
	private /*int*/ $beta_flag;

	
	private $this_table_status_field = false;
	private $server_id_status_field = false;
	private $server_name_status_field = false;
	private $server_state_status_field = false;
	private $server_start_date_status_field = false;
	private $server_zone_flag_status_field = false;
	private $new_server_id_status_field = false;
	private $new_server_time_status_field = false;
	private $server_config_status_field = false;
	private $server_rule_status_field = false;
	private $server_channel_status_field = false;
	private $server_key_status_field = false;
	private $server_ip_status_field = false;
	private $server_host_status_field = false;
	private $server_reamrk_status_field = false;
	private $server_alias_status_field = false;
	private $game_id_status_field = false;
	private $beta_flag_status_field = false;


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
			$sql = "SELECT {$p} FROM `server_list`";
		}
		else
		{			
			$sql = "SELECT {$p} FROM `server_list` WHERE ".SQLUtil::parseCondition($condition);
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
			$tb = new SysServerList();			
			if (isset($row['server_id'])) $tb->server_id = intval($row['server_id']);
			if (isset($row['server_name'])) $tb->server_name = $row['server_name'];
			if (isset($row['server_state'])) $tb->server_state = intval($row['server_state']);
			if (isset($row['server_start_date'])) $tb->server_start_date = intval($row['server_start_date']);
			if (isset($row['server_zone_flag'])) $tb->server_zone_flag = $row['server_zone_flag'];
			if (isset($row['new_server_id'])) $tb->new_server_id = $row['new_server_id'];
			if (isset($row['new_server_time'])) $tb->new_server_time = intval($row['new_server_time']);
			if (isset($row['server_config'])) $tb->server_config = $row['server_config'];
			if (isset($row['server_rule'])) $tb->server_rule = $row['server_rule'];
			if (isset($row['server_channel'])) $tb->server_channel = $row['server_channel'];
			if (isset($row['server_key'])) $tb->server_key = $row['server_key'];
			if (isset($row['server_ip'])) $tb->server_ip = $row['server_ip'];
			if (isset($row['server_host'])) $tb->server_host = $row['server_host'];
			if (isset($row['server_reamrk'])) $tb->server_reamrk = $row['server_reamrk'];
			if (isset($row['server_alias'])) $tb->server_alias = $row['server_alias'];
			if (isset($row['game_id'])) $tb->game_id = intval($row['game_id']);
			if (isset($row['beta_flag'])) $tb->beta_flag = intval($row['beta_flag']);
		
			$result[] = $tb;
		}
		
		return $result;
	}	
	
	public static function insertSqlHeader($fields=NULL)
	{
		$result = array();				
		if(!empty($fields)){
			$where = SQLUtil::parseFields($fields);			
			$result[0] = "INSERT INTO `server_list` ({$where}) VALUES ";	
			$ar = array();
			foreach($fields as $key){
				$ar[$key]=1;
			}
			$result[1] = $ar;
		}else{
			$result[0]="INSERT INTO `server_list` (`server_id`,`server_name`,`server_state`,`server_start_date`,`server_zone_flag`,`new_server_id`,`new_server_time`,`server_config`,`server_rule`,`server_channel`,`server_key`,`server_ip`,`server_host`,`server_reamrk`,`server_alias`,`game_id`,`beta_flag`) VALUES ";
			$result[1] = array('server_id'=>1,'server_name'=>1,'server_state'=>1,'server_start_date'=>1,'server_zone_flag'=>1,'new_server_id'=>1,'new_server_time'=>1,'server_config'=>1,'server_rule'=>1,'server_channel'=>1,'server_key'=>1,'server_ip'=>1,'server_host'=>1,'server_reamrk'=>1,'server_alias'=>1,'game_id'=>1,'beta_flag'=>1);
		}				
		return $result;
	}
		
	public function  loaded( $fields=NULL,$condition=NULL)
	{

		if (empty($condition) && empty($this->server_id))
		{
			return false;
		}
		
		$p = "*";
		$where = "`server_id` = '{$this->server_id}'";
		
		if(!empty($fields))
		{
			$p = SQLUtil::parseFields($fields);			
		}
	    if (!empty($condition))
		{
			$where =SQLUtil::parseCondition($condition);
		}
		
		$sql = "SELECT {$p} FROM `server_list` WHERE {$where}";

		MySQL::selectDefaultDb();
		$qr = MySQL::getInstance()->RunQuery($sql);
		$ar = MySQL::getInstance()->FetchArray($qr);
		
		if (!$ar || count($ar)==0)
		{
			return false;
		}
		
		if (isset($ar['server_id'])) $this->server_id = intval($ar['server_id']);
		if (isset($ar['server_name'])) $this->server_name = $ar['server_name'];
		if (isset($ar['server_state'])) $this->server_state = intval($ar['server_state']);
		if (isset($ar['server_start_date'])) $this->server_start_date = intval($ar['server_start_date']);
		if (isset($ar['server_zone_flag'])) $this->server_zone_flag = $ar['server_zone_flag'];
		if (isset($ar['new_server_id'])) $this->new_server_id = $ar['new_server_id'];
		if (isset($ar['new_server_time'])) $this->new_server_time = intval($ar['new_server_time']);
		if (isset($ar['server_config'])) $this->server_config = $ar['server_config'];
		if (isset($ar['server_rule'])) $this->server_rule = $ar['server_rule'];
		if (isset($ar['server_channel'])) $this->server_channel = $ar['server_channel'];
		if (isset($ar['server_key'])) $this->server_key = $ar['server_key'];
		if (isset($ar['server_ip'])) $this->server_ip = $ar['server_ip'];
		if (isset($ar['server_host'])) $this->server_host = $ar['server_host'];
		if (isset($ar['server_reamrk'])) $this->server_reamrk = $ar['server_reamrk'];
		if (isset($ar['server_alias'])) $this->server_alias = $ar['server_alias'];
		if (isset($ar['game_id'])) $this->game_id = intval($ar['game_id']);
		if (isset($ar['beta_flag'])) $this->beta_flag = intval($ar['beta_flag']);
		
		
		$this->clean();
		
		return true;
	}
	
	
	public function  loadedCount( $fields=NULL,$condition=NULL)
	{
	
		if (empty($condition) && empty($this->server_id))
		{
			return false;
		}
	
		$p = "*";
		$where = "`server_id` = '{$this->server_id}'";
	
		if(!empty($fields))
		{
			$p = SQLUtil::parseFields($fields);
		}
		if (!empty($condition))
		{
			$where =SQLUtil::parseCondition($condition);
		}
	
		$sql = "SELECT {$p} FROM `server_list` WHERE {$where}";
	
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
    	
    	if (!isset($this->server_id)){
    		$emptyFields = false;
    		$fields[] = 'server_id';
    	}else{
    		$emptyCondition = false; 
    		$condition['server_id']=$this->server_id;
    	}
    	if (!isset($this->server_name)){
    		$emptyFields = false;
    		$fields[] = 'server_name';
    	}else{
    		$emptyCondition = false; 
    		$condition['server_name']=$this->server_name;
    	}
    	if (!isset($this->server_state)){
    		$emptyFields = false;
    		$fields[] = 'server_state';
    	}else{
    		$emptyCondition = false; 
    		$condition['server_state']=$this->server_state;
    	}
    	if (!isset($this->server_start_date)){
    		$emptyFields = false;
    		$fields[] = 'server_start_date';
    	}else{
    		$emptyCondition = false; 
    		$condition['server_start_date']=$this->server_start_date;
    	}
    	if (!isset($this->server_zone_flag)){
    		$emptyFields = false;
    		$fields[] = 'server_zone_flag';
    	}else{
    		$emptyCondition = false; 
    		$condition['server_zone_flag']=$this->server_zone_flag;
    	}
    	if (!isset($this->new_server_id)){
    		$emptyFields = false;
    		$fields[] = 'new_server_id';
    	}else{
    		$emptyCondition = false; 
    		$condition['new_server_id']=$this->new_server_id;
    	}
    	if (!isset($this->new_server_time)){
    		$emptyFields = false;
    		$fields[] = 'new_server_time';
    	}else{
    		$emptyCondition = false; 
    		$condition['new_server_time']=$this->new_server_time;
    	}
    	if (!isset($this->server_config)){
    		$emptyFields = false;
    		$fields[] = 'server_config';
    	}else{
    		$emptyCondition = false; 
    		$condition['server_config']=$this->server_config;
    	}
    	if (!isset($this->server_rule)){
    		$emptyFields = false;
    		$fields[] = 'server_rule';
    	}else{
    		$emptyCondition = false; 
    		$condition['server_rule']=$this->server_rule;
    	}
    	if (!isset($this->server_channel)){
    		$emptyFields = false;
    		$fields[] = 'server_channel';
    	}else{
    		$emptyCondition = false; 
    		$condition['server_channel']=$this->server_channel;
    	}
    	if (!isset($this->server_key)){
    		$emptyFields = false;
    		$fields[] = 'server_key';
    	}else{
    		$emptyCondition = false; 
    		$condition['server_key']=$this->server_key;
    	}
    	if (!isset($this->server_ip)){
    		$emptyFields = false;
    		$fields[] = 'server_ip';
    	}else{
    		$emptyCondition = false; 
    		$condition['server_ip']=$this->server_ip;
    	}
    	if (!isset($this->server_host)){
    		$emptyFields = false;
    		$fields[] = 'server_host';
    	}else{
    		$emptyCondition = false; 
    		$condition['server_host']=$this->server_host;
    	}
    	if (!isset($this->server_reamrk)){
    		$emptyFields = false;
    		$fields[] = 'server_reamrk';
    	}else{
    		$emptyCondition = false; 
    		$condition['server_reamrk']=$this->server_reamrk;
    	}
    	if (!isset($this->server_alias)){
    		$emptyFields = false;
    		$fields[] = 'server_alias';
    	}else{
    		$emptyCondition = false; 
    		$condition['server_alias']=$this->server_alias;
    	}
    	if (!isset($this->game_id)){
    		$emptyFields = false;
    		$fields[] = 'game_id';
    	}else{
    		$emptyCondition = false; 
    		$condition['game_id']=$this->game_id;
    	}
    	if (!isset($this->beta_flag)){
    		$emptyFields = false;
    		$fields[] = 'beta_flag';
    	}else{
    		$emptyCondition = false; 
    		$condition['beta_flag']=$this->beta_flag;
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
				
		if (empty($this->server_id))
		{
			$this->server_id = MySQL::getInstance()->GetInsertId();
		}		
		
		$this->clean();
		
		return true;	
		
	}
	
	public function save($condition=NULL)
	{
		if (empty($condition))
		{
			$uc = "`server_id`='{$this->server_id}'";
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
		
		$sql = "DELETE FROM `server_list` WHERE ".SQLUtil::parseCondition($condition);
		
		$qr = MySQL::getInstance()->RunQuery($sql);
				
		return (boolean)$qr;
	}
	
	public function  delete()
	{
		if (!isset($this->server_id))
		{
			return false;
		}
		
		$sql = "DELETE FROM `server_list` WHERE `server_id`='{$this->server_id}'";
		
		MySQL::selectDefaultDb();
		$qr = MySQL::getInstance()->RunQuery($sql);
				
		return (boolean)$qr;
	}
	
	public function getInsertValue($fields)
	{
		$values = "(";		
		foreach($fields as $f => $k){
			if($f == 'server_id'){
 				$values .= "'{$this->server_id}',";
 			}else if($f == 'server_name'){
 				$values .= "'{$this->server_name}',";
 			}else if($f == 'server_state'){
 				$values .= "'{$this->server_state}',";
 			}else if($f == 'server_start_date'){
 				$values .= "'{$this->server_start_date}',";
 			}else if($f == 'server_zone_flag'){
 				$values .= "'{$this->server_zone_flag}',";
 			}else if($f == 'new_server_id'){
 				$values .= "'{$this->new_server_id}',";
 			}else if($f == 'new_server_time'){
 				$values .= "'{$this->new_server_time}',";
 			}else if($f == 'server_config'){
 				$values .= "'{$this->server_config}',";
 			}else if($f == 'server_rule'){
 				$values .= "'{$this->server_rule}',";
 			}else if($f == 'server_channel'){
 				$values .= "'{$this->server_channel}',";
 			}else if($f == 'server_key'){
 				$values .= "'{$this->server_key}',";
 			}else if($f == 'server_ip'){
 				$values .= "'{$this->server_ip}',";
 			}else if($f == 'server_host'){
 				$values .= "'{$this->server_host}',";
 			}else if($f == 'server_reamrk'){
 				$values .= "'{$this->server_reamrk}',";
 			}else if($f == 'server_alias'){
 				$values .= "'{$this->server_alias}',";
 			}else if($f == 'game_id'){
 				$values .= "'{$this->game_id}',";
 			}else if($f == 'beta_flag'){
 				$values .= "'{$this->beta_flag}',";
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

		if (isset($this->server_id))
		{
			$fields .= "`server_id`,";
			$values .= "'{$this->server_id}',";
		}
		if (isset($this->server_name))
		{
			$fields .= "`server_name`,";
			$values .= "'{$this->server_name}',";
		}
		if (isset($this->server_state))
		{
			$fields .= "`server_state`,";
			$values .= "'{$this->server_state}',";
		}
		if (isset($this->server_start_date))
		{
			$fields .= "`server_start_date`,";
			$values .= "'{$this->server_start_date}',";
		}
		if (isset($this->server_zone_flag))
		{
			$fields .= "`server_zone_flag`,";
			$values .= "'{$this->server_zone_flag}',";
		}
		if (isset($this->new_server_id))
		{
			$fields .= "`new_server_id`,";
			$values .= "'{$this->new_server_id}',";
		}
		if (isset($this->new_server_time))
		{
			$fields .= "`new_server_time`,";
			$values .= "'{$this->new_server_time}',";
		}
		if (isset($this->server_config))
		{
			$fields .= "`server_config`,";
			$values .= "'{$this->server_config}',";
		}
		if (isset($this->server_rule))
		{
			$fields .= "`server_rule`,";
			$values .= "'{$this->server_rule}',";
		}
		if (isset($this->server_channel))
		{
			$fields .= "`server_channel`,";
			$values .= "'{$this->server_channel}',";
		}
		if (isset($this->server_key))
		{
			$fields .= "`server_key`,";
			$values .= "'{$this->server_key}',";
		}
		if (isset($this->server_ip))
		{
			$fields .= "`server_ip`,";
			$values .= "'{$this->server_ip}',";
		}
		if (isset($this->server_host))
		{
			$fields .= "`server_host`,";
			$values .= "'{$this->server_host}',";
		}
		if (isset($this->server_reamrk))
		{
			$fields .= "`server_reamrk`,";
			$values .= "'{$this->server_reamrk}',";
		}
		if (isset($this->server_alias))
		{
			$fields .= "`server_alias`,";
			$values .= "'{$this->server_alias}',";
		}
		if (isset($this->game_id))
		{
			$fields .= "`game_id`,";
			$values .= "'{$this->game_id}',";
		}
		if (isset($this->beta_flag))
		{
			$fields .= "`beta_flag`,";
			$values .= "'{$this->beta_flag}',";
		}

		
		$fields .= ")";
		$values .= ")";
		
		$sql = "INSERT INTO `server_list` ".$fields.$values;
		
		return str_replace(",)",")",$sql);
	}
	
	private function  getUpFields()
	{
		$update = "";
		
		if ($this->server_name_status_field)
		{			
			if (!isset($this->server_name))
			{
				$update .= ("`server_name`=null,");
			}
			else
			{
				$update .= ("`server_name`='{$this->server_name}',");
			}
		}
		if ($this->server_state_status_field)
		{			
			if (!isset($this->server_state))
			{
				$update .= ("`server_state`=null,");
			}
			else
			{
				$update .= ("`server_state`='{$this->server_state}',");
			}
		}
		if ($this->server_start_date_status_field)
		{			
			if (!isset($this->server_start_date))
			{
				$update .= ("`server_start_date`=null,");
			}
			else
			{
				$update .= ("`server_start_date`='{$this->server_start_date}',");
			}
		}
		if ($this->server_zone_flag_status_field)
		{			
			if (!isset($this->server_zone_flag))
			{
				$update .= ("`server_zone_flag`=null,");
			}
			else
			{
				$update .= ("`server_zone_flag`='{$this->server_zone_flag}',");
			}
		}
		if ($this->new_server_id_status_field)
		{			
			if (!isset($this->new_server_id))
			{
				$update .= ("`new_server_id`=null,");
			}
			else
			{
				$update .= ("`new_server_id`='{$this->new_server_id}',");
			}
		}
		if ($this->new_server_time_status_field)
		{			
			if (!isset($this->new_server_time))
			{
				$update .= ("`new_server_time`=null,");
			}
			else
			{
				$update .= ("`new_server_time`='{$this->new_server_time}',");
			}
		}
		if ($this->server_config_status_field)
		{			
			if (!isset($this->server_config))
			{
				$update .= ("`server_config`=null,");
			}
			else
			{
				$update .= ("`server_config`='{$this->server_config}',");
			}
		}
		if ($this->server_rule_status_field)
		{			
			if (!isset($this->server_rule))
			{
				$update .= ("`server_rule`=null,");
			}
			else
			{
				$update .= ("`server_rule`='{$this->server_rule}',");
			}
		}
		if ($this->server_channel_status_field)
		{			
			if (!isset($this->server_channel))
			{
				$update .= ("`server_channel`=null,");
			}
			else
			{
				$update .= ("`server_channel`='{$this->server_channel}',");
			}
		}
		if ($this->server_key_status_field)
		{			
			if (!isset($this->server_key))
			{
				$update .= ("`server_key`=null,");
			}
			else
			{
				$update .= ("`server_key`='{$this->server_key}',");
			}
		}
		if ($this->server_ip_status_field)
		{			
			if (!isset($this->server_ip))
			{
				$update .= ("`server_ip`=null,");
			}
			else
			{
				$update .= ("`server_ip`='{$this->server_ip}',");
			}
		}
		if ($this->server_host_status_field)
		{			
			if (!isset($this->server_host))
			{
				$update .= ("`server_host`=null,");
			}
			else
			{
				$update .= ("`server_host`='{$this->server_host}',");
			}
		}
		if ($this->server_reamrk_status_field)
		{			
			if (!isset($this->server_reamrk))
			{
				$update .= ("`server_reamrk`=null,");
			}
			else
			{
				$update .= ("`server_reamrk`='{$this->server_reamrk}',");
			}
		}
		if ($this->server_alias_status_field)
		{			
			if (!isset($this->server_alias))
			{
				$update .= ("`server_alias`=null,");
			}
			else
			{
				$update .= ("`server_alias`='{$this->server_alias}',");
			}
		}
		if ($this->game_id_status_field)
		{			
			if (!isset($this->game_id))
			{
				$update .= ("`game_id`=null,");
			}
			else
			{
				$update .= ("`game_id`='{$this->game_id}',");
			}
		}
		if ($this->beta_flag_status_field)
		{			
			if (!isset($this->beta_flag))
			{
				$update .= ("`beta_flag`=null,");
			}
			else
			{
				$update .= ("`beta_flag`='{$this->beta_flag}',");
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
		
		$sql = "UPDATE `server_list` SET {$update} WHERE {$condition}";
		
		return $sql;
	}
	
	public function  add($fieldsValue,$condition=NULL)
	{				
		if (empty($condition))
		{
			$uc = "`server_id`='{$this->server_id}'";
		}
		else
		{			
			$uc = SQLUtil::parseCondition($condition);
		}
		
		$update = SQLUtil::parseASFieldValues($fieldsValue);
		
		$sql = "UPDATE `server_list` SET {$update} WHERE {$uc}";
		
		MySQL::selectDefaultDb();
		$qr = MySQL::getInstance()->RunQuery($sql);
				
		return (boolean)$qr;
	}	
	
	public function sub($fieldsVal,$condition=NULL)
	{
		if (empty($condition))
		{
			$uc = "`server_id`='{$this->server_id}'";
		}
		else
		{			
			$uc = SQLUtil::parseCondition($condition);
		}
		
		$update = SQLUtil::parseASFieldValues($fieldsVal,false);
		
		$sql = "UPDATE `server_list` SET {$update} WHERE {$uc}";
		
		MySQL::selectDefaultDb();
		$qr = MySQL::getInstance()->RunQuery($sql);
				
		return (boolean)$qr;
	}
	
	private function /*void*/ clean() 
	{
		$this->this_table_status_field = false;
		$this->server_id_status_field = false;
		$this->server_name_status_field = false;
		$this->server_state_status_field = false;
		$this->server_start_date_status_field = false;
		$this->server_zone_flag_status_field = false;
		$this->new_server_id_status_field = false;
		$this->new_server_time_status_field = false;
		$this->server_config_status_field = false;
		$this->server_rule_status_field = false;
		$this->server_channel_status_field = false;
		$this->server_key_status_field = false;
		$this->server_ip_status_field = false;
		$this->server_host_status_field = false;
		$this->server_reamrk_status_field = false;
		$this->server_alias_status_field = false;
		$this->game_id_status_field = false;
		$this->beta_flag_status_field = false;

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

	public function /*string*/ getServerName()
	{
		return $this->server_name;
	}
	
	public function /*void*/ setServerName(/*string*/ $server_name)
	{
		$this->server_name = SQLUtil::toSafeSQLString($server_name);
		$this->server_name_status_field = true;		
		$this->this_table_status_field = true;		
	}

	public function /*void*/ setServerNameNull()
	{
		$this->server_name = null;
		$this->server_name_status_field = true;		
		$this->this_table_status_field = true;
	}

	public function /*int*/ getServerState()
	{
		return $this->server_state;
	}
	
	public function /*void*/ setServerState(/*int*/ $server_state)
	{
		$this->server_state = intval($server_state);
		$this->server_state_status_field = true;		
		$this->this_table_status_field = true;		
	}

	public function /*void*/ setServerStateNull()
	{
		$this->server_state = null;
		$this->server_state_status_field = true;		
		$this->this_table_status_field = true;
	}

	public function /*int*/ getServerStartDate()
	{
		return $this->server_start_date;
	}
	
	public function /*void*/ setServerStartDate(/*int*/ $server_start_date)
	{
		$this->server_start_date = intval($server_start_date);
		$this->server_start_date_status_field = true;		
		$this->this_table_status_field = true;		
	}

	public function /*void*/ setServerStartDateNull()
	{
		$this->server_start_date = null;
		$this->server_start_date_status_field = true;		
		$this->this_table_status_field = true;
	}

	public function /*string*/ getServerZoneFlag()
	{
		return $this->server_zone_flag;
	}
	
	public function /*void*/ setServerZoneFlag(/*string*/ $server_zone_flag)
	{
		$this->server_zone_flag = SQLUtil::toSafeSQLString($server_zone_flag);
		$this->server_zone_flag_status_field = true;		
		$this->this_table_status_field = true;		
	}

	public function /*void*/ setServerZoneFlagNull()
	{
		$this->server_zone_flag = null;
		$this->server_zone_flag_status_field = true;		
		$this->this_table_status_field = true;
	}

	public function /*string*/ getNewServerId()
	{
		return $this->new_server_id;
	}
	
	public function /*void*/ setNewServerId(/*string*/ $new_server_id)
	{
		$this->new_server_id = SQLUtil::toSafeSQLString($new_server_id);
		$this->new_server_id_status_field = true;		
		$this->this_table_status_field = true;		
	}

	public function /*void*/ setNewServerIdNull()
	{
		$this->new_server_id = null;
		$this->new_server_id_status_field = true;		
		$this->this_table_status_field = true;
	}

	public function /*int*/ getNewServerTime()
	{
		return $this->new_server_time;
	}
	
	public function /*void*/ setNewServerTime(/*int*/ $new_server_time)
	{
		$this->new_server_time = intval($new_server_time);
		$this->new_server_time_status_field = true;		
		$this->this_table_status_field = true;		
	}

	public function /*void*/ setNewServerTimeNull()
	{
		$this->new_server_time = null;
		$this->new_server_time_status_field = true;		
		$this->this_table_status_field = true;
	}

	public function /*string*/ getServerConfig()
	{
		return $this->server_config;
	}
	
	public function /*void*/ setServerConfig(/*string*/ $server_config)
	{
		$this->server_config = SQLUtil::toSafeSQLString($server_config);
		$this->server_config_status_field = true;		
		$this->this_table_status_field = true;		
	}

	public function /*void*/ setServerConfigNull()
	{
		$this->server_config = null;
		$this->server_config_status_field = true;		
		$this->this_table_status_field = true;
	}

	public function /*string*/ getServerRule()
	{
		return $this->server_rule;
	}
	
	public function /*void*/ setServerRule(/*string*/ $server_rule)
	{
		$this->server_rule = SQLUtil::toSafeSQLString($server_rule);
		$this->server_rule_status_field = true;		
		$this->this_table_status_field = true;		
	}

	public function /*void*/ setServerRuleNull()
	{
		$this->server_rule = null;
		$this->server_rule_status_field = true;		
		$this->this_table_status_field = true;
	}

	public function /*string*/ getServerChannel()
	{
		return $this->server_channel;
	}
	
	public function /*void*/ setServerChannel(/*string*/ $server_channel)
	{
		$this->server_channel = SQLUtil::toSafeSQLString($server_channel);
		$this->server_channel_status_field = true;		
		$this->this_table_status_field = true;		
	}

	public function /*void*/ setServerChannelNull()
	{
		$this->server_channel = null;
		$this->server_channel_status_field = true;		
		$this->this_table_status_field = true;
	}

	public function /*string*/ getServerKey()
	{
		return $this->server_key;
	}
	
	public function /*void*/ setServerKey(/*string*/ $server_key)
	{
		$this->server_key = SQLUtil::toSafeSQLString($server_key);
		$this->server_key_status_field = true;		
		$this->this_table_status_field = true;		
	}

	public function /*void*/ setServerKeyNull()
	{
		$this->server_key = null;
		$this->server_key_status_field = true;		
		$this->this_table_status_field = true;
	}

	public function /*string*/ getServerIp()
	{
		return $this->server_ip;
	}
	
	public function /*void*/ setServerIp(/*string*/ $server_ip)
	{
		$this->server_ip = SQLUtil::toSafeSQLString($server_ip);
		$this->server_ip_status_field = true;		
		$this->this_table_status_field = true;		
	}

	public function /*void*/ setServerIpNull()
	{
		$this->server_ip = null;
		$this->server_ip_status_field = true;		
		$this->this_table_status_field = true;
	}

	public function /*string*/ getServerHost()
	{
		return $this->server_host;
	}
	
	public function /*void*/ setServerHost(/*string*/ $server_host)
	{
		$this->server_host = SQLUtil::toSafeSQLString($server_host);
		$this->server_host_status_field = true;		
		$this->this_table_status_field = true;		
	}

	public function /*void*/ setServerHostNull()
	{
		$this->server_host = null;
		$this->server_host_status_field = true;		
		$this->this_table_status_field = true;
	}

	public function /*string*/ getServerReamrk()
	{
		return $this->server_reamrk;
	}
	
	public function /*void*/ setServerReamrk(/*string*/ $server_reamrk)
	{
		$this->server_reamrk = SQLUtil::toSafeSQLString($server_reamrk);
		$this->server_reamrk_status_field = true;		
		$this->this_table_status_field = true;		
	}

	public function /*void*/ setServerReamrkNull()
	{
		$this->server_reamrk = null;
		$this->server_reamrk_status_field = true;		
		$this->this_table_status_field = true;
	}

	public function /*string*/ getServerAlias()
	{
		return $this->server_alias;
	}
	
	public function /*void*/ setServerAlias(/*string*/ $server_alias)
	{
		$this->server_alias = SQLUtil::toSafeSQLString($server_alias);
		$this->server_alias_status_field = true;		
		$this->this_table_status_field = true;		
	}

	public function /*void*/ setServerAliasNull()
	{
		$this->server_alias = null;
		$this->server_alias_status_field = true;		
		$this->this_table_status_field = true;
	}

	public function /*int*/ getGameId()
	{
		return $this->game_id;
	}
	
	public function /*void*/ setGameId(/*int*/ $game_id)
	{
		$this->game_id = intval($game_id);
		$this->game_id_status_field = true;		
		$this->this_table_status_field = true;		
	}

	public function /*void*/ setGameIdNull()
	{
		$this->game_id = null;
		$this->game_id_status_field = true;		
		$this->this_table_status_field = true;
	}

	public function /*int*/ getBetaFlag()
	{
		return $this->beta_flag;
	}
	
	public function /*void*/ setBetaFlag(/*int*/ $beta_flag)
	{
		$this->beta_flag = intval($beta_flag);
		$this->beta_flag_status_field = true;		
		$this->this_table_status_field = true;		
	}

	public function /*void*/ setBetaFlagNull()
	{
		$this->beta_flag = null;
		$this->beta_flag_status_field = true;		
		$this->this_table_status_field = true;
	}

	
	public function /*string*/ toDebugString()
	{
		$dbg = "(";
		
		$dbg .= ("server_id={$this->server_id},");
		$dbg .= ("server_name={$this->server_name},");
		$dbg .= ("server_state={$this->server_state},");
		$dbg .= ("server_start_date={$this->server_start_date},");
		$dbg .= ("server_zone_flag={$this->server_zone_flag},");
		$dbg .= ("new_server_id={$this->new_server_id},");
		$dbg .= ("new_server_time={$this->new_server_time},");
		$dbg .= ("server_config={$this->server_config},");
		$dbg .= ("server_rule={$this->server_rule},");
		$dbg .= ("server_channel={$this->server_channel},");
		$dbg .= ("server_key={$this->server_key},");
		$dbg .= ("server_ip={$this->server_ip},");
		$dbg .= ("server_host={$this->server_host},");
		$dbg .= ("server_reamrk={$this->server_reamrk},");
		$dbg .= ("server_alias={$this->server_alias},");
		$dbg .= ("game_id={$this->game_id},");
		$dbg .= ("beta_flag={$this->beta_flag},");

		$dbg .= ")";
				
		return str_replace(",)",")",$dbg);
	}
}

?>
