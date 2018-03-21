<?php
require_once ($GLOBALS ['GAME_ROOT'] . "CMySQL.php");
require_once ("SQLUtil.php");
/**
 *  [The generated files]
 */

class SysUserServer {
	
	private /*string*/ $user_id; //PRIMARY KEY 
	private /*string*/ $uin;
	private /*int*/ $server_id;
	private /*string*/ $reg_ip;
	private /*string*/ $last_login_ip;
	private /*int*/ $reg_time;
	private /*int*/ $last_login_time;
	private /*int*/ $login_nums;
	private /*string*/ $new_server_id;
	private /*int*/ $new_server_time;
	private /*int*/ $STATUS;
	private /*string*/ $sid;
	private /*string*/ $parent;
	private /*string*/ $ticket;
	private /*string*/ $zone_flag;
	private /*int*/ $platform; //1: iphone, 2:ipad, 3:android

	
	private $this_table_status_field = false;
	private $user_id_status_field = false;
	private $uin_status_field = false;
	private $server_id_status_field = false;
	private $reg_ip_status_field = false;
	private $last_login_ip_status_field = false;
	private $reg_time_status_field = false;
	private $last_login_time_status_field = false;
	private $login_nums_status_field = false;
	private $new_server_id_status_field = false;
	private $new_server_time_status_field = false;
	private $STATUS_status_field = false;
	private $sid_status_field = false;
	private $parent_status_field = false;
	private $ticket_status_field = false;
	private $zone_flag_status_field = false;
	private $platform_status_field = false;


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
			$sql = "SELECT {$p} FROM `user_server`";
		}
		else
		{			
			$sql = "SELECT {$p} FROM `user_server` WHERE ".SQLUtil::parseCondition($condition);
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
			$tb = new SysUserServer();			
			if (isset($row['user_id'])) $tb->user_id = $row['user_id'];
			if (isset($row['uin'])) $tb->uin = $row['uin'];
			if (isset($row['server_id'])) $tb->server_id = intval($row['server_id']);
			if (isset($row['reg_ip'])) $tb->reg_ip = $row['reg_ip'];
			if (isset($row['last_login_ip'])) $tb->last_login_ip = $row['last_login_ip'];
			if (isset($row['reg_time'])) $tb->reg_time = intval($row['reg_time']);
			if (isset($row['last_login_time'])) $tb->last_login_time = intval($row['last_login_time']);
			if (isset($row['login_nums'])) $tb->login_nums = intval($row['login_nums']);
			if (isset($row['new_server_id'])) $tb->new_server_id = $row['new_server_id'];
			if (isset($row['new_server_time'])) $tb->new_server_time = intval($row['new_server_time']);
			if (isset($row['STATUS'])) $tb->STATUS = intval($row['STATUS']);
			if (isset($row['sid'])) $tb->sid = $row['sid'];
			if (isset($row['parent'])) $tb->parent = $row['parent'];
			if (isset($row['ticket'])) $tb->ticket = $row['ticket'];
			if (isset($row['zone_flag'])) $tb->zone_flag = $row['zone_flag'];
			if (isset($row['platform'])) $tb->platform = intval($row['platform']);
		
			$result[] = $tb;
		}
		
		return $result;
	}	
	
	public static function insertSqlHeader($fields=NULL)
	{
		$result = array();				
		if(!empty($fields)){
			$where = SQLUtil::parseFields($fields);			
			$result[0] = "INSERT INTO `user_server` ({$where}) VALUES ";	
			$ar = array();
			foreach($fields as $key){
				$ar[$key]=1;
			}
			$result[1] = $ar;
		}else{
			$result[0]="INSERT INTO `user_server` (`user_id`,`uin`,`server_id`,`reg_ip`,`last_login_ip`,`reg_time`,`last_login_time`,`login_nums`,`new_server_id`,`new_server_time`,`STATUS`,`sid`,`parent`,`ticket`,`zone_flag`,`platform`) VALUES ";
			$result[1] = array('user_id'=>1,'uin'=>1,'server_id'=>1,'reg_ip'=>1,'last_login_ip'=>1,'reg_time'=>1,'last_login_time'=>1,'login_nums'=>1,'new_server_id'=>1,'new_server_time'=>1,'STATUS'=>1,'sid'=>1,'parent'=>1,'ticket'=>1,'zone_flag'=>1,'platform'=>1);
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
		
		$sql = "SELECT {$p} FROM `user_server` WHERE {$where}";

		MySQL::selectDefaultDb();
		$qr = MySQL::getInstance()->RunQuery($sql);
		$ar = MySQL::getInstance()->FetchArray($qr);
		
		if (!$ar || count($ar)==0)
		{
			return false;
		}
		
		if (isset($ar['user_id'])) $this->user_id = $ar['user_id'];
		if (isset($ar['uin'])) $this->uin = $ar['uin'];
		if (isset($ar['server_id'])) $this->server_id = intval($ar['server_id']);
		if (isset($ar['reg_ip'])) $this->reg_ip = $ar['reg_ip'];
		if (isset($ar['last_login_ip'])) $this->last_login_ip = $ar['last_login_ip'];
		if (isset($ar['reg_time'])) $this->reg_time = intval($ar['reg_time']);
		if (isset($ar['last_login_time'])) $this->last_login_time = intval($ar['last_login_time']);
		if (isset($ar['login_nums'])) $this->login_nums = intval($ar['login_nums']);
		if (isset($ar['new_server_id'])) $this->new_server_id = $ar['new_server_id'];
		if (isset($ar['new_server_time'])) $this->new_server_time = intval($ar['new_server_time']);
		if (isset($ar['STATUS'])) $this->STATUS = intval($ar['STATUS']);
		if (isset($ar['sid'])) $this->sid = $ar['sid'];
		if (isset($ar['parent'])) $this->parent = $ar['parent'];
		if (isset($ar['ticket'])) $this->ticket = $ar['ticket'];
		if (isset($ar['zone_flag'])) $this->zone_flag = $ar['zone_flag'];
		if (isset($ar['platform'])) $this->platform = intval($ar['platform']);
		
		
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
	
		$sql = "SELECT {$p} FROM `user_server` WHERE {$where}";
	
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
    	
    	if (!isset($this->user_id)){
    		$emptyFields = false;
    		$fields[] = 'user_id';
    	}else{
    		$emptyCondition = false; 
    		$condition['user_id']=$this->user_id;
    	}
    	if (!isset($this->uin)){
    		$emptyFields = false;
    		$fields[] = 'uin';
    	}else{
    		$emptyCondition = false; 
    		$condition['uin']=$this->uin;
    	}
    	if (!isset($this->server_id)){
    		$emptyFields = false;
    		$fields[] = 'server_id';
    	}else{
    		$emptyCondition = false; 
    		$condition['server_id']=$this->server_id;
    	}
    	if (!isset($this->reg_ip)){
    		$emptyFields = false;
    		$fields[] = 'reg_ip';
    	}else{
    		$emptyCondition = false; 
    		$condition['reg_ip']=$this->reg_ip;
    	}
    	if (!isset($this->last_login_ip)){
    		$emptyFields = false;
    		$fields[] = 'last_login_ip';
    	}else{
    		$emptyCondition = false; 
    		$condition['last_login_ip']=$this->last_login_ip;
    	}
    	if (!isset($this->reg_time)){
    		$emptyFields = false;
    		$fields[] = 'reg_time';
    	}else{
    		$emptyCondition = false; 
    		$condition['reg_time']=$this->reg_time;
    	}
    	if (!isset($this->last_login_time)){
    		$emptyFields = false;
    		$fields[] = 'last_login_time';
    	}else{
    		$emptyCondition = false; 
    		$condition['last_login_time']=$this->last_login_time;
    	}
    	if (!isset($this->login_nums)){
    		$emptyFields = false;
    		$fields[] = 'login_nums';
    	}else{
    		$emptyCondition = false; 
    		$condition['login_nums']=$this->login_nums;
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
    	if (!isset($this->STATUS)){
    		$emptyFields = false;
    		$fields[] = 'STATUS';
    	}else{
    		$emptyCondition = false; 
    		$condition['STATUS']=$this->STATUS;
    	}
    	if (!isset($this->sid)){
    		$emptyFields = false;
    		$fields[] = 'sid';
    	}else{
    		$emptyCondition = false; 
    		$condition['sid']=$this->sid;
    	}
    	if (!isset($this->parent)){
    		$emptyFields = false;
    		$fields[] = 'parent';
    	}else{
    		$emptyCondition = false; 
    		$condition['parent']=$this->parent;
    	}
    	if (!isset($this->ticket)){
    		$emptyFields = false;
    		$fields[] = 'ticket';
    	}else{
    		$emptyCondition = false; 
    		$condition['ticket']=$this->ticket;
    	}
    	if (!isset($this->zone_flag)){
    		$emptyFields = false;
    		$fields[] = 'zone_flag';
    	}else{
    		$emptyCondition = false; 
    		$condition['zone_flag']=$this->zone_flag;
    	}
    	if (!isset($this->platform)){
    		$emptyFields = false;
    		$fields[] = 'platform';
    	}else{
    		$emptyCondition = false; 
    		$condition['platform']=$this->platform;
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
		
		$sql = "DELETE FROM `user_server` WHERE ".SQLUtil::parseCondition($condition);
		
		$qr = MySQL::getInstance()->RunQuery($sql);
				
		return (boolean)$qr;
	}
	
	public function  delete()
	{
		if (!isset($this->user_id))
		{
			return false;
		}
		
		$sql = "DELETE FROM `user_server` WHERE `user_id`='{$this->user_id}'";
		
		MySQL::selectDefaultDb();
		$qr = MySQL::getInstance()->RunQuery($sql);
				
		return (boolean)$qr;
	}
	
	public function getInsertValue($fields)
	{
		$values = "(";		
		foreach($fields as $f => $k){
			if($f == 'user_id'){
 				$values .= "'{$this->user_id}',";
 			}else if($f == 'uin'){
 				$values .= "'{$this->uin}',";
 			}else if($f == 'server_id'){
 				$values .= "'{$this->server_id}',";
 			}else if($f == 'reg_ip'){
 				$values .= "'{$this->reg_ip}',";
 			}else if($f == 'last_login_ip'){
 				$values .= "'{$this->last_login_ip}',";
 			}else if($f == 'reg_time'){
 				$values .= "'{$this->reg_time}',";
 			}else if($f == 'last_login_time'){
 				$values .= "'{$this->last_login_time}',";
 			}else if($f == 'login_nums'){
 				$values .= "'{$this->login_nums}',";
 			}else if($f == 'new_server_id'){
 				$values .= "'{$this->new_server_id}',";
 			}else if($f == 'new_server_time'){
 				$values .= "'{$this->new_server_time}',";
 			}else if($f == 'STATUS'){
 				$values .= "'{$this->STATUS}',";
 			}else if($f == 'sid'){
 				$values .= "'{$this->sid}',";
 			}else if($f == 'parent'){
 				$values .= "'{$this->parent}',";
 			}else if($f == 'ticket'){
 				$values .= "'{$this->ticket}',";
 			}else if($f == 'zone_flag'){
 				$values .= "'{$this->zone_flag}',";
 			}else if($f == 'platform'){
 				$values .= "'{$this->platform}',";
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
		if (isset($this->uin))
		{
			$fields .= "`uin`,";
			$values .= "'{$this->uin}',";
		}
		if (isset($this->server_id))
		{
			$fields .= "`server_id`,";
			$values .= "'{$this->server_id}',";
		}
		if (isset($this->reg_ip))
		{
			$fields .= "`reg_ip`,";
			$values .= "'{$this->reg_ip}',";
		}
		if (isset($this->last_login_ip))
		{
			$fields .= "`last_login_ip`,";
			$values .= "'{$this->last_login_ip}',";
		}
		if (isset($this->reg_time))
		{
			$fields .= "`reg_time`,";
			$values .= "'{$this->reg_time}',";
		}
		if (isset($this->last_login_time))
		{
			$fields .= "`last_login_time`,";
			$values .= "'{$this->last_login_time}',";
		}
		if (isset($this->login_nums))
		{
			$fields .= "`login_nums`,";
			$values .= "'{$this->login_nums}',";
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
		if (isset($this->STATUS))
		{
			$fields .= "`STATUS`,";
			$values .= "'{$this->STATUS}',";
		}
		if (isset($this->sid))
		{
			$fields .= "`sid`,";
			$values .= "'{$this->sid}',";
		}
		if (isset($this->parent))
		{
			$fields .= "`parent`,";
			$values .= "'{$this->parent}',";
		}
		if (isset($this->ticket))
		{
			$fields .= "`ticket`,";
			$values .= "'{$this->ticket}',";
		}
		if (isset($this->zone_flag))
		{
			$fields .= "`zone_flag`,";
			$values .= "'{$this->zone_flag}',";
		}
		if (isset($this->platform))
		{
			$fields .= "`platform`,";
			$values .= "'{$this->platform}',";
		}

		
		$fields .= ")";
		$values .= ")";
		
		$sql = "INSERT INTO `user_server` ".$fields.$values;
		
		return str_replace(",)",")",$sql);
	}
	
	private function  getUpFields()
	{
		$update = "";
		
		if ($this->uin_status_field)
		{			
			if (!isset($this->uin))
			{
				$update .= ("`uin`=null,");
			}
			else
			{
				$update .= ("`uin`='{$this->uin}',");
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
		if ($this->reg_ip_status_field)
		{			
			if (!isset($this->reg_ip))
			{
				$update .= ("`reg_ip`=null,");
			}
			else
			{
				$update .= ("`reg_ip`='{$this->reg_ip}',");
			}
		}
		if ($this->last_login_ip_status_field)
		{			
			if (!isset($this->last_login_ip))
			{
				$update .= ("`last_login_ip`=null,");
			}
			else
			{
				$update .= ("`last_login_ip`='{$this->last_login_ip}',");
			}
		}
		if ($this->reg_time_status_field)
		{			
			if (!isset($this->reg_time))
			{
				$update .= ("`reg_time`=null,");
			}
			else
			{
				$update .= ("`reg_time`='{$this->reg_time}',");
			}
		}
		if ($this->last_login_time_status_field)
		{			
			if (!isset($this->last_login_time))
			{
				$update .= ("`last_login_time`=null,");
			}
			else
			{
				$update .= ("`last_login_time`='{$this->last_login_time}',");
			}
		}
		if ($this->login_nums_status_field)
		{			
			if (!isset($this->login_nums))
			{
				$update .= ("`login_nums`=null,");
			}
			else
			{
				$update .= ("`login_nums`='{$this->login_nums}',");
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
		if ($this->STATUS_status_field)
		{			
			if (!isset($this->STATUS))
			{
				$update .= ("`STATUS`=null,");
			}
			else
			{
				$update .= ("`STATUS`='{$this->STATUS}',");
			}
		}
		if ($this->sid_status_field)
		{			
			if (!isset($this->sid))
			{
				$update .= ("`sid`=null,");
			}
			else
			{
				$update .= ("`sid`='{$this->sid}',");
			}
		}
		if ($this->parent_status_field)
		{			
			if (!isset($this->parent))
			{
				$update .= ("`parent`=null,");
			}
			else
			{
				$update .= ("`parent`='{$this->parent}',");
			}
		}
		if ($this->ticket_status_field)
		{			
			if (!isset($this->ticket))
			{
				$update .= ("`ticket`=null,");
			}
			else
			{
				$update .= ("`ticket`='{$this->ticket}',");
			}
		}
		if ($this->zone_flag_status_field)
		{			
			if (!isset($this->zone_flag))
			{
				$update .= ("`zone_flag`=null,");
			}
			else
			{
				$update .= ("`zone_flag`='{$this->zone_flag}',");
			}
		}
		if ($this->platform_status_field)
		{			
			if (!isset($this->platform))
			{
				$update .= ("`platform`=null,");
			}
			else
			{
				$update .= ("`platform`='{$this->platform}',");
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
		
		$sql = "UPDATE `user_server` SET {$update} WHERE {$condition}";
		
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
		
		$sql = "UPDATE `user_server` SET {$update} WHERE {$uc}";
		
		MySQL::selectDefaultDb();
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
		
		$sql = "UPDATE `user_server` SET {$update} WHERE {$uc}";
		
		MySQL::selectDefaultDb();
		$qr = MySQL::getInstance()->RunQuery($sql);
				
		return (boolean)$qr;
	}
	
	private function /*void*/ clean() 
	{
		$this->this_table_status_field = false;
		$this->user_id_status_field = false;
		$this->uin_status_field = false;
		$this->server_id_status_field = false;
		$this->reg_ip_status_field = false;
		$this->last_login_ip_status_field = false;
		$this->reg_time_status_field = false;
		$this->last_login_time_status_field = false;
		$this->login_nums_status_field = false;
		$this->new_server_id_status_field = false;
		$this->new_server_time_status_field = false;
		$this->STATUS_status_field = false;
		$this->sid_status_field = false;
		$this->parent_status_field = false;
		$this->ticket_status_field = false;
		$this->zone_flag_status_field = false;
		$this->platform_status_field = false;

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

	public function /*string*/ getUin()
	{
		return $this->uin;
	}
	
	public function /*void*/ setUin(/*string*/ $uin)
	{
		$this->uin = SQLUtil::toSafeSQLString($uin);
		$this->uin_status_field = true;		
		$this->this_table_status_field = true;		
	}

	public function /*void*/ setUinNull()
	{
		$this->uin = null;
		$this->uin_status_field = true;		
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

	public function /*string*/ getRegIp()
	{
		return $this->reg_ip;
	}
	
	public function /*void*/ setRegIp(/*string*/ $reg_ip)
	{
		$this->reg_ip = SQLUtil::toSafeSQLString($reg_ip);
		$this->reg_ip_status_field = true;		
		$this->this_table_status_field = true;		
	}

	public function /*void*/ setRegIpNull()
	{
		$this->reg_ip = null;
		$this->reg_ip_status_field = true;		
		$this->this_table_status_field = true;
	}

	public function /*string*/ getLastLoginIp()
	{
		return $this->last_login_ip;
	}
	
	public function /*void*/ setLastLoginIp(/*string*/ $last_login_ip)
	{
		$this->last_login_ip = SQLUtil::toSafeSQLString($last_login_ip);
		$this->last_login_ip_status_field = true;		
		$this->this_table_status_field = true;		
	}

	public function /*void*/ setLastLoginIpNull()
	{
		$this->last_login_ip = null;
		$this->last_login_ip_status_field = true;		
		$this->this_table_status_field = true;
	}

	public function /*int*/ getRegTime()
	{
		return $this->reg_time;
	}
	
	public function /*void*/ setRegTime(/*int*/ $reg_time)
	{
		$this->reg_time = intval($reg_time);
		$this->reg_time_status_field = true;		
		$this->this_table_status_field = true;		
	}

	public function /*void*/ setRegTimeNull()
	{
		$this->reg_time = null;
		$this->reg_time_status_field = true;		
		$this->this_table_status_field = true;
	}

	public function /*int*/ getLastLoginTime()
	{
		return $this->last_login_time;
	}
	
	public function /*void*/ setLastLoginTime(/*int*/ $last_login_time)
	{
		$this->last_login_time = intval($last_login_time);
		$this->last_login_time_status_field = true;		
		$this->this_table_status_field = true;		
	}

	public function /*void*/ setLastLoginTimeNull()
	{
		$this->last_login_time = null;
		$this->last_login_time_status_field = true;		
		$this->this_table_status_field = true;
	}

	public function /*int*/ getLoginNums()
	{
		return $this->login_nums;
	}
	
	public function /*void*/ setLoginNums(/*int*/ $login_nums)
	{
		$this->login_nums = intval($login_nums);
		$this->login_nums_status_field = true;		
		$this->this_table_status_field = true;		
	}

	public function /*void*/ setLoginNumsNull()
	{
		$this->login_nums = null;
		$this->login_nums_status_field = true;		
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

	public function /*int*/ getSTATUS()
	{
		return $this->STATUS;
	}
	
	public function /*void*/ setSTATUS(/*int*/ $STATUS)
	{
		$this->STATUS = intval($STATUS);
		$this->STATUS_status_field = true;		
		$this->this_table_status_field = true;		
	}

	public function /*void*/ setSTATUSNull()
	{
		$this->STATUS = null;
		$this->STATUS_status_field = true;		
		$this->this_table_status_field = true;
	}

	public function /*string*/ getSid()
	{
		return $this->sid;
	}
	
	public function /*void*/ setSid(/*string*/ $sid)
	{
		$this->sid = SQLUtil::toSafeSQLString($sid);
		$this->sid_status_field = true;		
		$this->this_table_status_field = true;		
	}

	public function /*void*/ setSidNull()
	{
		$this->sid = null;
		$this->sid_status_field = true;		
		$this->this_table_status_field = true;
	}

	public function /*string*/ getParent()
	{
		return $this->parent;
	}
	
	public function /*void*/ setParent(/*string*/ $parent)
	{
		$this->parent = SQLUtil::toSafeSQLString($parent);
		$this->parent_status_field = true;		
		$this->this_table_status_field = true;		
	}

	public function /*void*/ setParentNull()
	{
		$this->parent = null;
		$this->parent_status_field = true;		
		$this->this_table_status_field = true;
	}

	public function /*string*/ getTicket()
	{
		return $this->ticket;
	}
	
	public function /*void*/ setTicket(/*string*/ $ticket)
	{
		$this->ticket = SQLUtil::toSafeSQLString($ticket);
		$this->ticket_status_field = true;		
		$this->this_table_status_field = true;		
	}

	public function /*void*/ setTicketNull()
	{
		$this->ticket = null;
		$this->ticket_status_field = true;		
		$this->this_table_status_field = true;
	}

	public function /*string*/ getZoneFlag()
	{
		return $this->zone_flag;
	}
	
	public function /*void*/ setZoneFlag(/*string*/ $zone_flag)
	{
		$this->zone_flag = SQLUtil::toSafeSQLString($zone_flag);
		$this->zone_flag_status_field = true;		
		$this->this_table_status_field = true;		
	}

	public function /*void*/ setZoneFlagNull()
	{
		$this->zone_flag = null;
		$this->zone_flag_status_field = true;		
		$this->this_table_status_field = true;
	}

	public function /*int*/ getPlatform()
	{
		return $this->platform;
	}
	
	public function /*void*/ setPlatform(/*int*/ $platform)
	{
		$this->platform = intval($platform);
		$this->platform_status_field = true;		
		$this->this_table_status_field = true;		
	}

	public function /*void*/ setPlatformNull()
	{
		$this->platform = null;
		$this->platform_status_field = true;		
		$this->this_table_status_field = true;
	}

	
	public function /*string*/ toDebugString()
	{
		$dbg = "(";
		
		$dbg .= ("user_id={$this->user_id},");
		$dbg .= ("uin={$this->uin},");
		$dbg .= ("server_id={$this->server_id},");
		$dbg .= ("reg_ip={$this->reg_ip},");
		$dbg .= ("last_login_ip={$this->last_login_ip},");
		$dbg .= ("reg_time={$this->reg_time},");
		$dbg .= ("last_login_time={$this->last_login_time},");
		$dbg .= ("login_nums={$this->login_nums},");
		$dbg .= ("new_server_id={$this->new_server_id},");
		$dbg .= ("new_server_time={$this->new_server_time},");
		$dbg .= ("STATUS={$this->STATUS},");
		$dbg .= ("sid={$this->sid},");
		$dbg .= ("parent={$this->parent},");
		$dbg .= ("ticket={$this->ticket},");
		$dbg .= ("zone_flag={$this->zone_flag},");
		$dbg .= ("platform={$this->platform},");

		$dbg .= ")";
				
		return str_replace(",)",")",$dbg);
	}
}

?>
