<?php
require_once ($GLOBALS ['GAME_ROOT'] . "CMySQL.php");
require_once ("SQLUtil.php");
/**
 *  [The generated files]
 */

class SysUser {
	
	private /*string*/ $uin; //PRIMARY KEY 
	private /*string*/ $game_center_id;
	private /*string*/ $email;
	private /*string*/ $password;
	private /*int*/ $email_state;
	private /*string*/ $reg_ip;
	private /*string*/ $last_login_ip;
	private /*int*/ $user_zone_id;
	private /*string*/ $user_zone;
	private /*string*/ $reg_time;
	private /*string*/ $last_login_time;
	private /*int*/ $reg_time_stamp;
	private /*int*/ $last_login_time_stamp;
	private /*int*/ $login_nums;
	private /*string*/ $country;
	private /*int*/ $STATUS;
	private /*string*/ $fbuid;
	private /*string*/ $fb_email;
	private /*int*/ $is_robot;
	private /*int*/ $is_master;
	private /*string*/ $parent;
	private /*int*/ $ticket;
	private /*string*/ $secondary_email;
	private /*string*/ $session_key;
	private /*int*/ $platform; //1: iphone, 2:ipad, 3:android
	private /*string*/ $language;
	private /*string*/ $model;
	private /*string*/ $OSVer;

	
	private $this_table_status_field = false;
	private $uin_status_field = false;
	private $game_center_id_status_field = false;
	private $email_status_field = false;
	private $password_status_field = false;
	private $email_state_status_field = false;
	private $reg_ip_status_field = false;
	private $last_login_ip_status_field = false;
	private $user_zone_id_status_field = false;
	private $user_zone_status_field = false;
	private $reg_time_status_field = false;
	private $last_login_time_status_field = false;
	private $reg_time_stamp_status_field = false;
	private $last_login_time_stamp_status_field = false;
	private $login_nums_status_field = false;
	private $country_status_field = false;
	private $STATUS_status_field = false;
	private $fbuid_status_field = false;
	private $fb_email_status_field = false;
	private $is_robot_status_field = false;
	private $is_master_status_field = false;
	private $parent_status_field = false;
	private $ticket_status_field = false;
	private $secondary_email_status_field = false;
	private $session_key_status_field = false;
	private $platform_status_field = false;
	private $language_status_field = false;
	private $model_status_field = false;
	private $OSVer_status_field = false;


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
			$sql = "SELECT {$p} FROM `user`";
		}
		else
		{			
			$sql = "SELECT {$p} FROM `user` WHERE ".SQLUtil::parseCondition($condition);
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
			$tb = new SysUser();			
			if (isset($row['uin'])) $tb->uin = $row['uin'];
			if (isset($row['game_center_id'])) $tb->game_center_id = $row['game_center_id'];
			if (isset($row['email'])) $tb->email = $row['email'];
			if (isset($row['password'])) $tb->password = $row['password'];
			if (isset($row['email_state'])) $tb->email_state = intval($row['email_state']);
			if (isset($row['reg_ip'])) $tb->reg_ip = $row['reg_ip'];
			if (isset($row['last_login_ip'])) $tb->last_login_ip = $row['last_login_ip'];
			if (isset($row['user_zone_id'])) $tb->user_zone_id = intval($row['user_zone_id']);
			if (isset($row['user_zone'])) $tb->user_zone = $row['user_zone'];
			if (isset($row['reg_time'])) $tb->reg_time = $row['reg_time'];
			if (isset($row['last_login_time'])) $tb->last_login_time = $row['last_login_time'];
			if (isset($row['reg_time_stamp'])) $tb->reg_time_stamp = intval($row['reg_time_stamp']);
			if (isset($row['last_login_time_stamp'])) $tb->last_login_time_stamp = intval($row['last_login_time_stamp']);
			if (isset($row['login_nums'])) $tb->login_nums = intval($row['login_nums']);
			if (isset($row['country'])) $tb->country = $row['country'];
			if (isset($row['STATUS'])) $tb->STATUS = intval($row['STATUS']);
			if (isset($row['fbuid'])) $tb->fbuid = $row['fbuid'];
			if (isset($row['fb_email'])) $tb->fb_email = $row['fb_email'];
			if (isset($row['is_robot'])) $tb->is_robot = intval($row['is_robot']);
			if (isset($row['is_master'])) $tb->is_master = intval($row['is_master']);
			if (isset($row['parent'])) $tb->parent = $row['parent'];
			if (isset($row['ticket'])) $tb->ticket = intval($row['ticket']);
			if (isset($row['secondary_email'])) $tb->secondary_email = $row['secondary_email'];
			if (isset($row['session_key'])) $tb->session_key = $row['session_key'];
			if (isset($row['platform'])) $tb->platform = intval($row['platform']);
			if (isset($row['language'])) $tb->language = $row['language'];
			if (isset($row['model'])) $tb->model = $row['model'];
			if (isset($row['OSVer'])) $tb->OSVer = $row['OSVer'];
		
			$result[] = $tb;
		}
		
		return $result;
	}	
	
	public static function insertSqlHeader($fields=NULL)
	{
		$result = array();				
		if(!empty($fields)){
			$where = SQLUtil::parseFields($fields);			
			$result[0] = "INSERT INTO `user` ({$where}) VALUES ";	
			$ar = array();
			foreach($fields as $key){
				$ar[$key]=1;
			}
			$result[1] = $ar;
		}else{
			$result[0]="INSERT INTO `user` (`uin`,`game_center_id`,`email`,`password`,`email_state`,`reg_ip`,`last_login_ip`,`user_zone_id`,`user_zone`,`reg_time`,`last_login_time`,`reg_time_stamp`,`last_login_time_stamp`,`login_nums`,`country`,`STATUS`,`fbuid`,`fb_email`,`is_robot`,`is_master`,`parent`,`ticket`,`secondary_email`,`session_key`,`platform`,`language`,`model`,`OSVer`) VALUES ";
			$result[1] = array('uin'=>1,'game_center_id'=>1,'email'=>1,'password'=>1,'email_state'=>1,'reg_ip'=>1,'last_login_ip'=>1,'user_zone_id'=>1,'user_zone'=>1,'reg_time'=>1,'last_login_time'=>1,'reg_time_stamp'=>1,'last_login_time_stamp'=>1,'login_nums'=>1,'country'=>1,'STATUS'=>1,'fbuid'=>1,'fb_email'=>1,'is_robot'=>1,'is_master'=>1,'parent'=>1,'ticket'=>1,'secondary_email'=>1,'session_key'=>1,'platform'=>1,'language'=>1,'model'=>1,'OSVer'=>1);
		}				
		return $result;
	}
		
	public function  loaded( $fields=NULL,$condition=NULL)
	{

		if (empty($condition) && empty($this->uin))
		{
			return false;
		}
		
		$p = "*";
		$where = "`uin` = '{$this->uin}'";
		
		if(!empty($fields))
		{
			$p = SQLUtil::parseFields($fields);			
		}
	    if (!empty($condition))
		{
			$where =SQLUtil::parseCondition($condition);
		}
		
		$sql = "SELECT {$p} FROM `user` WHERE {$where}";

		MySQL::selectDefaultDb();
		$qr = MySQL::getInstance()->RunQuery($sql);
		$ar = MySQL::getInstance()->FetchArray($qr);
		
		if (!$ar || count($ar)==0)
		{
			return false;
		}
		
		if (isset($ar['uin'])) $this->uin = $ar['uin'];
		if (isset($ar['game_center_id'])) $this->game_center_id = $ar['game_center_id'];
		if (isset($ar['email'])) $this->email = $ar['email'];
		if (isset($ar['password'])) $this->password = $ar['password'];
		if (isset($ar['email_state'])) $this->email_state = intval($ar['email_state']);
		if (isset($ar['reg_ip'])) $this->reg_ip = $ar['reg_ip'];
		if (isset($ar['last_login_ip'])) $this->last_login_ip = $ar['last_login_ip'];
		if (isset($ar['user_zone_id'])) $this->user_zone_id = intval($ar['user_zone_id']);
		if (isset($ar['user_zone'])) $this->user_zone = $ar['user_zone'];
		if (isset($ar['reg_time'])) $this->reg_time = $ar['reg_time'];
		if (isset($ar['last_login_time'])) $this->last_login_time = $ar['last_login_time'];
		if (isset($ar['reg_time_stamp'])) $this->reg_time_stamp = intval($ar['reg_time_stamp']);
		if (isset($ar['last_login_time_stamp'])) $this->last_login_time_stamp = intval($ar['last_login_time_stamp']);
		if (isset($ar['login_nums'])) $this->login_nums = intval($ar['login_nums']);
		if (isset($ar['country'])) $this->country = $ar['country'];
		if (isset($ar['STATUS'])) $this->STATUS = intval($ar['STATUS']);
		if (isset($ar['fbuid'])) $this->fbuid = $ar['fbuid'];
		if (isset($ar['fb_email'])) $this->fb_email = $ar['fb_email'];
		if (isset($ar['is_robot'])) $this->is_robot = intval($ar['is_robot']);
		if (isset($ar['is_master'])) $this->is_master = intval($ar['is_master']);
		if (isset($ar['parent'])) $this->parent = $ar['parent'];
		if (isset($ar['ticket'])) $this->ticket = intval($ar['ticket']);
		if (isset($ar['secondary_email'])) $this->secondary_email = $ar['secondary_email'];
		if (isset($ar['session_key'])) $this->session_key = $ar['session_key'];
		if (isset($ar['platform'])) $this->platform = intval($ar['platform']);
		if (isset($ar['language'])) $this->language = $ar['language'];
		if (isset($ar['model'])) $this->model = $ar['model'];
		if (isset($ar['OSVer'])) $this->OSVer = $ar['OSVer'];
		
		
		$this->clean();
		
		return true;
	}
	
	
	public function  loadedCount( $fields=NULL,$condition=NULL)
	{
	
		if (empty($condition) && empty($this->uin))
		{
			return false;
		}
	
		$p = "*";
		$where = "`uin` = '{$this->uin}'";
	
		if(!empty($fields))
		{
			$p = SQLUtil::parseFields($fields);
		}
		if (!empty($condition))
		{
			$where =SQLUtil::parseCondition($condition);
		}
	
		$sql = "SELECT {$p} FROM `user` WHERE {$where}";
	
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
    	
    	if (!isset($this->uin)){
    		$emptyFields = false;
    		$fields[] = 'uin';
    	}else{
    		$emptyCondition = false; 
    		$condition['uin']=$this->uin;
    	}
    	if (!isset($this->game_center_id)){
    		$emptyFields = false;
    		$fields[] = 'game_center_id';
    	}else{
    		$emptyCondition = false; 
    		$condition['game_center_id']=$this->game_center_id;
    	}
    	if (!isset($this->email)){
    		$emptyFields = false;
    		$fields[] = 'email';
    	}else{
    		$emptyCondition = false; 
    		$condition['email']=$this->email;
    	}
    	if (!isset($this->password)){
    		$emptyFields = false;
    		$fields[] = 'password';
    	}else{
    		$emptyCondition = false; 
    		$condition['password']=$this->password;
    	}
    	if (!isset($this->email_state)){
    		$emptyFields = false;
    		$fields[] = 'email_state';
    	}else{
    		$emptyCondition = false; 
    		$condition['email_state']=$this->email_state;
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
    	if (!isset($this->user_zone_id)){
    		$emptyFields = false;
    		$fields[] = 'user_zone_id';
    	}else{
    		$emptyCondition = false; 
    		$condition['user_zone_id']=$this->user_zone_id;
    	}
    	if (!isset($this->user_zone)){
    		$emptyFields = false;
    		$fields[] = 'user_zone';
    	}else{
    		$emptyCondition = false; 
    		$condition['user_zone']=$this->user_zone;
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
    	if (!isset($this->reg_time_stamp)){
    		$emptyFields = false;
    		$fields[] = 'reg_time_stamp';
    	}else{
    		$emptyCondition = false; 
    		$condition['reg_time_stamp']=$this->reg_time_stamp;
    	}
    	if (!isset($this->last_login_time_stamp)){
    		$emptyFields = false;
    		$fields[] = 'last_login_time_stamp';
    	}else{
    		$emptyCondition = false; 
    		$condition['last_login_time_stamp']=$this->last_login_time_stamp;
    	}
    	if (!isset($this->login_nums)){
    		$emptyFields = false;
    		$fields[] = 'login_nums';
    	}else{
    		$emptyCondition = false; 
    		$condition['login_nums']=$this->login_nums;
    	}
    	if (!isset($this->country)){
    		$emptyFields = false;
    		$fields[] = 'country';
    	}else{
    		$emptyCondition = false; 
    		$condition['country']=$this->country;
    	}
    	if (!isset($this->STATUS)){
    		$emptyFields = false;
    		$fields[] = 'STATUS';
    	}else{
    		$emptyCondition = false; 
    		$condition['STATUS']=$this->STATUS;
    	}
    	if (!isset($this->fbuid)){
    		$emptyFields = false;
    		$fields[] = 'fbuid';
    	}else{
    		$emptyCondition = false; 
    		$condition['fbuid']=$this->fbuid;
    	}
    	if (!isset($this->fb_email)){
    		$emptyFields = false;
    		$fields[] = 'fb_email';
    	}else{
    		$emptyCondition = false; 
    		$condition['fb_email']=$this->fb_email;
    	}
    	if (!isset($this->is_robot)){
    		$emptyFields = false;
    		$fields[] = 'is_robot';
    	}else{
    		$emptyCondition = false; 
    		$condition['is_robot']=$this->is_robot;
    	}
    	if (!isset($this->is_master)){
    		$emptyFields = false;
    		$fields[] = 'is_master';
    	}else{
    		$emptyCondition = false; 
    		$condition['is_master']=$this->is_master;
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
    	if (!isset($this->secondary_email)){
    		$emptyFields = false;
    		$fields[] = 'secondary_email';
    	}else{
    		$emptyCondition = false; 
    		$condition['secondary_email']=$this->secondary_email;
    	}
    	if (!isset($this->session_key)){
    		$emptyFields = false;
    		$fields[] = 'session_key';
    	}else{
    		$emptyCondition = false; 
    		$condition['session_key']=$this->session_key;
    	}
    	if (!isset($this->platform)){
    		$emptyFields = false;
    		$fields[] = 'platform';
    	}else{
    		$emptyCondition = false; 
    		$condition['platform']=$this->platform;
    	}
    	if (!isset($this->language)){
    		$emptyFields = false;
    		$fields[] = 'language';
    	}else{
    		$emptyCondition = false; 
    		$condition['language']=$this->language;
    	}
    	if (!isset($this->model)){
    		$emptyFields = false;
    		$fields[] = 'model';
    	}else{
    		$emptyCondition = false; 
    		$condition['model']=$this->model;
    	}
    	if (!isset($this->OSVer)){
    		$emptyFields = false;
    		$fields[] = 'OSVer';
    	}else{
    		$emptyCondition = false; 
    		$condition['OSVer']=$this->OSVer;
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
				
		if (empty($this->uin))
		{
			$this->uin = MySQL::getInstance()->GetInsertId();
		}		
		
		$this->clean();
		
		return true;	
		
	}
	
	public function save($condition=NULL)
	{
		if (empty($condition))
		{
			$uc = "`uin`='{$this->uin}'";
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
		
		$sql = "DELETE FROM `user` WHERE ".SQLUtil::parseCondition($condition);
		
		$qr = MySQL::getInstance()->RunQuery($sql);
				
		return (boolean)$qr;
	}
	
	public function  delete()
	{
		if (!isset($this->uin))
		{
			return false;
		}
		
		$sql = "DELETE FROM `user` WHERE `uin`='{$this->uin}'";
		
		MySQL::selectDefaultDb();
		$qr = MySQL::getInstance()->RunQuery($sql);
				
		return (boolean)$qr;
	}
	
	public function getInsertValue($fields)
	{
		$values = "(";		
		foreach($fields as $f => $k){
			if($f == 'uin'){
 				$values .= "'{$this->uin}',";
 			}else if($f == 'game_center_id'){
 				$values .= "'{$this->game_center_id}',";
 			}else if($f == 'email'){
 				$values .= "'{$this->email}',";
 			}else if($f == 'password'){
 				$values .= "'{$this->password}',";
 			}else if($f == 'email_state'){
 				$values .= "'{$this->email_state}',";
 			}else if($f == 'reg_ip'){
 				$values .= "'{$this->reg_ip}',";
 			}else if($f == 'last_login_ip'){
 				$values .= "'{$this->last_login_ip}',";
 			}else if($f == 'user_zone_id'){
 				$values .= "'{$this->user_zone_id}',";
 			}else if($f == 'user_zone'){
 				$values .= "'{$this->user_zone}',";
 			}else if($f == 'reg_time'){
 				$values .= "'{$this->reg_time}',";
 			}else if($f == 'last_login_time'){
 				$values .= "'{$this->last_login_time}',";
 			}else if($f == 'reg_time_stamp'){
 				$values .= "'{$this->reg_time_stamp}',";
 			}else if($f == 'last_login_time_stamp'){
 				$values .= "'{$this->last_login_time_stamp}',";
 			}else if($f == 'login_nums'){
 				$values .= "'{$this->login_nums}',";
 			}else if($f == 'country'){
 				$values .= "'{$this->country}',";
 			}else if($f == 'STATUS'){
 				$values .= "'{$this->STATUS}',";
 			}else if($f == 'fbuid'){
 				$values .= "'{$this->fbuid}',";
 			}else if($f == 'fb_email'){
 				$values .= "'{$this->fb_email}',";
 			}else if($f == 'is_robot'){
 				$values .= "'{$this->is_robot}',";
 			}else if($f == 'is_master'){
 				$values .= "'{$this->is_master}',";
 			}else if($f == 'parent'){
 				$values .= "'{$this->parent}',";
 			}else if($f == 'ticket'){
 				$values .= "'{$this->ticket}',";
 			}else if($f == 'secondary_email'){
 				$values .= "'{$this->secondary_email}',";
 			}else if($f == 'session_key'){
 				$values .= "'{$this->session_key}',";
 			}else if($f == 'platform'){
 				$values .= "'{$this->platform}',";
 			}else if($f == 'language'){
 				$values .= "'{$this->language}',";
 			}else if($f == 'model'){
 				$values .= "'{$this->model}',";
 			}else if($f == 'OSVer'){
 				$values .= "'{$this->OSVer}',";
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

		if (isset($this->uin))
		{
			$fields .= "`uin`,";
			$values .= "'{$this->uin}',";
		}
		if (isset($this->game_center_id))
		{
			$fields .= "`game_center_id`,";
			$values .= "'{$this->game_center_id}',";
		}
		if (isset($this->email))
		{
			$fields .= "`email`,";
			$values .= "'{$this->email}',";
		}
		if (isset($this->password))
		{
			$fields .= "`password`,";
			$values .= "'{$this->password}',";
		}
		if (isset($this->email_state))
		{
			$fields .= "`email_state`,";
			$values .= "'{$this->email_state}',";
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
		if (isset($this->user_zone_id))
		{
			$fields .= "`user_zone_id`,";
			$values .= "'{$this->user_zone_id}',";
		}
		if (isset($this->user_zone))
		{
			$fields .= "`user_zone`,";
			$values .= "'{$this->user_zone}',";
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
		if (isset($this->reg_time_stamp))
		{
			$fields .= "`reg_time_stamp`,";
			$values .= "'{$this->reg_time_stamp}',";
		}
		if (isset($this->last_login_time_stamp))
		{
			$fields .= "`last_login_time_stamp`,";
			$values .= "'{$this->last_login_time_stamp}',";
		}
		if (isset($this->login_nums))
		{
			$fields .= "`login_nums`,";
			$values .= "'{$this->login_nums}',";
		}
		if (isset($this->country))
		{
			$fields .= "`country`,";
			$values .= "'{$this->country}',";
		}
		if (isset($this->STATUS))
		{
			$fields .= "`STATUS`,";
			$values .= "'{$this->STATUS}',";
		}
		if (isset($this->fbuid))
		{
			$fields .= "`fbuid`,";
			$values .= "'{$this->fbuid}',";
		}
		if (isset($this->fb_email))
		{
			$fields .= "`fb_email`,";
			$values .= "'{$this->fb_email}',";
		}
		if (isset($this->is_robot))
		{
			$fields .= "`is_robot`,";
			$values .= "'{$this->is_robot}',";
		}
		if (isset($this->is_master))
		{
			$fields .= "`is_master`,";
			$values .= "'{$this->is_master}',";
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
		if (isset($this->secondary_email))
		{
			$fields .= "`secondary_email`,";
			$values .= "'{$this->secondary_email}',";
		}
		if (isset($this->session_key))
		{
			$fields .= "`session_key`,";
			$values .= "'{$this->session_key}',";
		}
		if (isset($this->platform))
		{
			$fields .= "`platform`,";
			$values .= "'{$this->platform}',";
		}
		if (isset($this->language))
		{
			$fields .= "`language`,";
			$values .= "'{$this->language}',";
		}
		if (isset($this->model))
		{
			$fields .= "`model`,";
			$values .= "'{$this->model}',";
		}
		if (isset($this->OSVer))
		{
			$fields .= "`OSVer`,";
			$values .= "'{$this->OSVer}',";
		}

		
		$fields .= ")";
		$values .= ")";
		
		$sql = "INSERT INTO `user` ".$fields.$values;
		
		return str_replace(",)",")",$sql);
	}
	
	private function  getUpFields()
	{
		$update = "";
		
		if ($this->game_center_id_status_field)
		{			
			if (!isset($this->game_center_id))
			{
				$update .= ("`game_center_id`=null,");
			}
			else
			{
				$update .= ("`game_center_id`='{$this->game_center_id}',");
			}
		}
		if ($this->email_status_field)
		{			
			if (!isset($this->email))
			{
				$update .= ("`email`=null,");
			}
			else
			{
				$update .= ("`email`='{$this->email}',");
			}
		}
		if ($this->password_status_field)
		{			
			if (!isset($this->password))
			{
				$update .= ("`password`=null,");
			}
			else
			{
				$update .= ("`password`='{$this->password}',");
			}
		}
		if ($this->email_state_status_field)
		{			
			if (!isset($this->email_state))
			{
				$update .= ("`email_state`=null,");
			}
			else
			{
				$update .= ("`email_state`='{$this->email_state}',");
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
		if ($this->user_zone_id_status_field)
		{			
			if (!isset($this->user_zone_id))
			{
				$update .= ("`user_zone_id`=null,");
			}
			else
			{
				$update .= ("`user_zone_id`='{$this->user_zone_id}',");
			}
		}
		if ($this->user_zone_status_field)
		{			
			if (!isset($this->user_zone))
			{
				$update .= ("`user_zone`=null,");
			}
			else
			{
				$update .= ("`user_zone`='{$this->user_zone}',");
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
		if ($this->reg_time_stamp_status_field)
		{			
			if (!isset($this->reg_time_stamp))
			{
				$update .= ("`reg_time_stamp`=null,");
			}
			else
			{
				$update .= ("`reg_time_stamp`='{$this->reg_time_stamp}',");
			}
		}
		if ($this->last_login_time_stamp_status_field)
		{			
			if (!isset($this->last_login_time_stamp))
			{
				$update .= ("`last_login_time_stamp`=null,");
			}
			else
			{
				$update .= ("`last_login_time_stamp`='{$this->last_login_time_stamp}',");
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
		if ($this->country_status_field)
		{			
			if (!isset($this->country))
			{
				$update .= ("`country`=null,");
			}
			else
			{
				$update .= ("`country`='{$this->country}',");
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
		if ($this->fbuid_status_field)
		{			
			if (!isset($this->fbuid))
			{
				$update .= ("`fbuid`=null,");
			}
			else
			{
				$update .= ("`fbuid`='{$this->fbuid}',");
			}
		}
		if ($this->fb_email_status_field)
		{			
			if (!isset($this->fb_email))
			{
				$update .= ("`fb_email`=null,");
			}
			else
			{
				$update .= ("`fb_email`='{$this->fb_email}',");
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
		if ($this->is_master_status_field)
		{			
			if (!isset($this->is_master))
			{
				$update .= ("`is_master`=null,");
			}
			else
			{
				$update .= ("`is_master`='{$this->is_master}',");
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
		if ($this->secondary_email_status_field)
		{			
			if (!isset($this->secondary_email))
			{
				$update .= ("`secondary_email`=null,");
			}
			else
			{
				$update .= ("`secondary_email`='{$this->secondary_email}',");
			}
		}
		if ($this->session_key_status_field)
		{			
			if (!isset($this->session_key))
			{
				$update .= ("`session_key`=null,");
			}
			else
			{
				$update .= ("`session_key`='{$this->session_key}',");
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
		if ($this->language_status_field)
		{			
			if (!isset($this->language))
			{
				$update .= ("`language`=null,");
			}
			else
			{
				$update .= ("`language`='{$this->language}',");
			}
		}
		if ($this->model_status_field)
		{			
			if (!isset($this->model))
			{
				$update .= ("`model`=null,");
			}
			else
			{
				$update .= ("`model`='{$this->model}',");
			}
		}
		if ($this->OSVer_status_field)
		{			
			if (!isset($this->OSVer))
			{
				$update .= ("`OSVer`=null,");
			}
			else
			{
				$update .= ("`OSVer`='{$this->OSVer}',");
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
		
		$sql = "UPDATE `user` SET {$update} WHERE {$condition}";
		
		return $sql;
	}
	
	public function  add($fieldsValue,$condition=NULL)
	{				
		if (empty($condition))
		{
			$uc = "`uin`='{$this->uin}'";
		}
		else
		{			
			$uc = SQLUtil::parseCondition($condition);
		}
		
		$update = SQLUtil::parseASFieldValues($fieldsValue);
		
		$sql = "UPDATE `user` SET {$update} WHERE {$uc}";
		
		MySQL::selectDefaultDb();
		$qr = MySQL::getInstance()->RunQuery($sql);
				
		return (boolean)$qr;
	}	
	
	public function sub($fieldsVal,$condition=NULL)
	{
		if (empty($condition))
		{
			$uc = "`uin`='{$this->uin}'";
		}
		else
		{			
			$uc = SQLUtil::parseCondition($condition);
		}
		
		$update = SQLUtil::parseASFieldValues($fieldsVal,false);
		
		$sql = "UPDATE `user` SET {$update} WHERE {$uc}";
		
		MySQL::selectDefaultDb();
		$qr = MySQL::getInstance()->RunQuery($sql);
				
		return (boolean)$qr;
	}
	
	private function /*void*/ clean() 
	{
		$this->this_table_status_field = false;
		$this->uin_status_field = false;
		$this->game_center_id_status_field = false;
		$this->email_status_field = false;
		$this->password_status_field = false;
		$this->email_state_status_field = false;
		$this->reg_ip_status_field = false;
		$this->last_login_ip_status_field = false;
		$this->user_zone_id_status_field = false;
		$this->user_zone_status_field = false;
		$this->reg_time_status_field = false;
		$this->last_login_time_status_field = false;
		$this->reg_time_stamp_status_field = false;
		$this->last_login_time_stamp_status_field = false;
		$this->login_nums_status_field = false;
		$this->country_status_field = false;
		$this->STATUS_status_field = false;
		$this->fbuid_status_field = false;
		$this->fb_email_status_field = false;
		$this->is_robot_status_field = false;
		$this->is_master_status_field = false;
		$this->parent_status_field = false;
		$this->ticket_status_field = false;
		$this->secondary_email_status_field = false;
		$this->session_key_status_field = false;
		$this->platform_status_field = false;
		$this->language_status_field = false;
		$this->model_status_field = false;
		$this->OSVer_status_field = false;

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

	public function /*string*/ getGameCenterId()
	{
		return $this->game_center_id;
	}
	
	public function /*void*/ setGameCenterId(/*string*/ $game_center_id)
	{
		$this->game_center_id = SQLUtil::toSafeSQLString($game_center_id);
		$this->game_center_id_status_field = true;		
		$this->this_table_status_field = true;		
	}

	public function /*void*/ setGameCenterIdNull()
	{
		$this->game_center_id = null;
		$this->game_center_id_status_field = true;		
		$this->this_table_status_field = true;
	}

	public function /*string*/ getEmail()
	{
		return $this->email;
	}
	
	public function /*void*/ setEmail(/*string*/ $email)
	{
		$this->email = SQLUtil::toSafeSQLString($email);
		$this->email_status_field = true;		
		$this->this_table_status_field = true;		
	}

	public function /*void*/ setEmailNull()
	{
		$this->email = null;
		$this->email_status_field = true;		
		$this->this_table_status_field = true;
	}

	public function /*string*/ getPassword()
	{
		return $this->password;
	}
	
	public function /*void*/ setPassword(/*string*/ $password)
	{
		$this->password = SQLUtil::toSafeSQLString($password);
		$this->password_status_field = true;		
		$this->this_table_status_field = true;		
	}

	public function /*void*/ setPasswordNull()
	{
		$this->password = null;
		$this->password_status_field = true;		
		$this->this_table_status_field = true;
	}

	public function /*int*/ getEmailState()
	{
		return $this->email_state;
	}
	
	public function /*void*/ setEmailState(/*int*/ $email_state)
	{
		$this->email_state = intval($email_state);
		$this->email_state_status_field = true;		
		$this->this_table_status_field = true;		
	}

	public function /*void*/ setEmailStateNull()
	{
		$this->email_state = null;
		$this->email_state_status_field = true;		
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

	public function /*int*/ getUserZoneId()
	{
		return $this->user_zone_id;
	}
	
	public function /*void*/ setUserZoneId(/*int*/ $user_zone_id)
	{
		$this->user_zone_id = intval($user_zone_id);
		$this->user_zone_id_status_field = true;		
		$this->this_table_status_field = true;		
	}

	public function /*void*/ setUserZoneIdNull()
	{
		$this->user_zone_id = null;
		$this->user_zone_id_status_field = true;		
		$this->this_table_status_field = true;
	}

	public function /*string*/ getUserZone()
	{
		return $this->user_zone;
	}
	
	public function /*void*/ setUserZone(/*string*/ $user_zone)
	{
		$this->user_zone = SQLUtil::toSafeSQLString($user_zone);
		$this->user_zone_status_field = true;		
		$this->this_table_status_field = true;		
	}

	public function /*void*/ setUserZoneNull()
	{
		$this->user_zone = null;
		$this->user_zone_status_field = true;		
		$this->this_table_status_field = true;
	}

	public function /*string*/ getRegTime()
	{
		return $this->reg_time;
	}
	
	public function /*void*/ setRegTime(/*string*/ $reg_time)
	{
		$this->reg_time = SQLUtil::toSafeSQLString($reg_time);
		$this->reg_time_status_field = true;		
		$this->this_table_status_field = true;		
	}

	public function /*void*/ setRegTimeNull()
	{
		$this->reg_time = null;
		$this->reg_time_status_field = true;		
		$this->this_table_status_field = true;
	}

	public function /*string*/ getLastLoginTime()
	{
		return $this->last_login_time;
	}
	
	public function /*void*/ setLastLoginTime(/*string*/ $last_login_time)
	{
		$this->last_login_time = SQLUtil::toSafeSQLString($last_login_time);
		$this->last_login_time_status_field = true;		
		$this->this_table_status_field = true;		
	}

	public function /*void*/ setLastLoginTimeNull()
	{
		$this->last_login_time = null;
		$this->last_login_time_status_field = true;		
		$this->this_table_status_field = true;
	}

	public function /*int*/ getRegTimeStamp()
	{
		return $this->reg_time_stamp;
	}
	
	public function /*void*/ setRegTimeStamp(/*int*/ $reg_time_stamp)
	{
		$this->reg_time_stamp = intval($reg_time_stamp);
		$this->reg_time_stamp_status_field = true;		
		$this->this_table_status_field = true;		
	}

	public function /*void*/ setRegTimeStampNull()
	{
		$this->reg_time_stamp = null;
		$this->reg_time_stamp_status_field = true;		
		$this->this_table_status_field = true;
	}

	public function /*int*/ getLastLoginTimeStamp()
	{
		return $this->last_login_time_stamp;
	}
	
	public function /*void*/ setLastLoginTimeStamp(/*int*/ $last_login_time_stamp)
	{
		$this->last_login_time_stamp = intval($last_login_time_stamp);
		$this->last_login_time_stamp_status_field = true;		
		$this->this_table_status_field = true;		
	}

	public function /*void*/ setLastLoginTimeStampNull()
	{
		$this->last_login_time_stamp = null;
		$this->last_login_time_stamp_status_field = true;		
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

	public function /*string*/ getCountry()
	{
		return $this->country;
	}
	
	public function /*void*/ setCountry(/*string*/ $country)
	{
		$this->country = SQLUtil::toSafeSQLString($country);
		$this->country_status_field = true;		
		$this->this_table_status_field = true;		
	}

	public function /*void*/ setCountryNull()
	{
		$this->country = null;
		$this->country_status_field = true;		
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

	public function /*string*/ getFbuid()
	{
		return $this->fbuid;
	}
	
	public function /*void*/ setFbuid(/*string*/ $fbuid)
	{
		$this->fbuid = SQLUtil::toSafeSQLString($fbuid);
		$this->fbuid_status_field = true;		
		$this->this_table_status_field = true;		
	}

	public function /*void*/ setFbuidNull()
	{
		$this->fbuid = null;
		$this->fbuid_status_field = true;		
		$this->this_table_status_field = true;
	}

	public function /*string*/ getFbEmail()
	{
		return $this->fb_email;
	}
	
	public function /*void*/ setFbEmail(/*string*/ $fb_email)
	{
		$this->fb_email = SQLUtil::toSafeSQLString($fb_email);
		$this->fb_email_status_field = true;		
		$this->this_table_status_field = true;		
	}

	public function /*void*/ setFbEmailNull()
	{
		$this->fb_email = null;
		$this->fb_email_status_field = true;		
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

	public function /*int*/ getIsMaster()
	{
		return $this->is_master;
	}
	
	public function /*void*/ setIsMaster(/*int*/ $is_master)
	{
		$this->is_master = intval($is_master);
		$this->is_master_status_field = true;		
		$this->this_table_status_field = true;		
	}

	public function /*void*/ setIsMasterNull()
	{
		$this->is_master = null;
		$this->is_master_status_field = true;		
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

	public function /*int*/ getTicket()
	{
		return $this->ticket;
	}
	
	public function /*void*/ setTicket(/*int*/ $ticket)
	{
		$this->ticket = intval($ticket);
		$this->ticket_status_field = true;		
		$this->this_table_status_field = true;		
	}

	public function /*void*/ setTicketNull()
	{
		$this->ticket = null;
		$this->ticket_status_field = true;		
		$this->this_table_status_field = true;
	}

	public function /*string*/ getSecondaryEmail()
	{
		return $this->secondary_email;
	}
	
	public function /*void*/ setSecondaryEmail(/*string*/ $secondary_email)
	{
		$this->secondary_email = SQLUtil::toSafeSQLString($secondary_email);
		$this->secondary_email_status_field = true;		
		$this->this_table_status_field = true;		
	}

	public function /*void*/ setSecondaryEmailNull()
	{
		$this->secondary_email = null;
		$this->secondary_email_status_field = true;		
		$this->this_table_status_field = true;
	}

	public function /*string*/ getSessionKey()
	{
		return $this->session_key;
	}
	
	public function /*void*/ setSessionKey(/*string*/ $session_key)
	{
		$this->session_key = SQLUtil::toSafeSQLString($session_key);
		$this->session_key_status_field = true;		
		$this->this_table_status_field = true;		
	}

	public function /*void*/ setSessionKeyNull()
	{
		$this->session_key = null;
		$this->session_key_status_field = true;		
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

	public function /*string*/ getLanguage()
	{
		return $this->language;
	}
	
	public function /*void*/ setLanguage(/*string*/ $language)
	{
		$this->language = SQLUtil::toSafeSQLString($language);
		$this->language_status_field = true;		
		$this->this_table_status_field = true;		
	}

	public function /*void*/ setLanguageNull()
	{
		$this->language = null;
		$this->language_status_field = true;		
		$this->this_table_status_field = true;
	}

	public function /*string*/ getModel()
	{
		return $this->model;
	}
	
	public function /*void*/ setModel(/*string*/ $model)
	{
		$this->model = SQLUtil::toSafeSQLString($model);
		$this->model_status_field = true;		
		$this->this_table_status_field = true;		
	}

	public function /*void*/ setModelNull()
	{
		$this->model = null;
		$this->model_status_field = true;		
		$this->this_table_status_field = true;
	}

	public function /*string*/ getOSVer()
	{
		return $this->OSVer;
	}
	
	public function /*void*/ setOSVer(/*string*/ $OSVer)
	{
		$this->OSVer = SQLUtil::toSafeSQLString($OSVer);
		$this->OSVer_status_field = true;		
		$this->this_table_status_field = true;		
	}

	public function /*void*/ setOSVerNull()
	{
		$this->OSVer = null;
		$this->OSVer_status_field = true;		
		$this->this_table_status_field = true;
	}

	
	public function /*string*/ toDebugString()
	{
		$dbg = "(";
		
		$dbg .= ("uin={$this->uin},");
		$dbg .= ("game_center_id={$this->game_center_id},");
		$dbg .= ("email={$this->email},");
		$dbg .= ("password={$this->password},");
		$dbg .= ("email_state={$this->email_state},");
		$dbg .= ("reg_ip={$this->reg_ip},");
		$dbg .= ("last_login_ip={$this->last_login_ip},");
		$dbg .= ("user_zone_id={$this->user_zone_id},");
		$dbg .= ("user_zone={$this->user_zone},");
		$dbg .= ("reg_time={$this->reg_time},");
		$dbg .= ("last_login_time={$this->last_login_time},");
		$dbg .= ("reg_time_stamp={$this->reg_time_stamp},");
		$dbg .= ("last_login_time_stamp={$this->last_login_time_stamp},");
		$dbg .= ("login_nums={$this->login_nums},");
		$dbg .= ("country={$this->country},");
		$dbg .= ("STATUS={$this->STATUS},");
		$dbg .= ("fbuid={$this->fbuid},");
		$dbg .= ("fb_email={$this->fb_email},");
		$dbg .= ("is_robot={$this->is_robot},");
		$dbg .= ("is_master={$this->is_master},");
		$dbg .= ("parent={$this->parent},");
		$dbg .= ("ticket={$this->ticket},");
		$dbg .= ("secondary_email={$this->secondary_email},");
		$dbg .= ("session_key={$this->session_key},");
		$dbg .= ("platform={$this->platform},");
		$dbg .= ("language={$this->language},");
		$dbg .= ("model={$this->model},");
		$dbg .= ("OSVer={$this->OSVer},");

		$dbg .= ")";
				
		return str_replace(",)",")",$dbg);
	}
}

?>
