<?php
require_once ($GLOBALS ['GAME_ROOT'] . "CMySQL.php");
require_once ("SQLUtil.php");
/**
 *  [The generated files]
 */

class SysGuildInfo {
	
	private /*string*/ $id; //PRIMARY KEY 
	private /*string*/ $guild_name;
	private /*string*/ $host_id;
	private /*string*/ $host_name;
	private /*int*/ $level;
	private /*int*/ $exp;
	private /*int*/ $resource;
	private /*string*/ $message;
	private /*string*/ $intro;
	private /*int*/ $funds;
	private /*int*/ $max_funds;
	private /*int*/ $server_id;
	private /*int*/ $activity;
	private /*int*/ $disband_time;
	private /*int*/ $gift_level;
	private /*int*/ $gift_exp;
	private /*int*/ $state;
	private /*int*/ $can_jump;
	private /*int*/ $user_number;
	private /*int*/ $avatar;
	private /*int*/ $avatar_frame;
	private /*int*/ $join_type;
	private /*int*/ $min_level_limit;
	private /*int*/ $vitality;
	private /*int*/ $distribute_time;
	private /*int*/ $distribute_num;
	private /*int*/ $drop_give_time;
	private /*int*/ $drop_give_count;
	private /*int*/ $drop_give_item;
	private /*string*/ $drop_give_user_id;

	
	private $this_table_status_field = false;
	private $id_status_field = false;
	private $guild_name_status_field = false;
	private $host_id_status_field = false;
	private $host_name_status_field = false;
	private $level_status_field = false;
	private $exp_status_field = false;
	private $resource_status_field = false;
	private $message_status_field = false;
	private $intro_status_field = false;
	private $funds_status_field = false;
	private $max_funds_status_field = false;
	private $server_id_status_field = false;
	private $activity_status_field = false;
	private $disband_time_status_field = false;
	private $gift_level_status_field = false;
	private $gift_exp_status_field = false;
	private $state_status_field = false;
	private $can_jump_status_field = false;
	private $user_number_status_field = false;
	private $avatar_status_field = false;
	private $avatar_frame_status_field = false;
	private $join_type_status_field = false;
	private $min_level_limit_status_field = false;
	private $vitality_status_field = false;
	private $distribute_time_status_field = false;
	private $distribute_num_status_field = false;
	private $drop_give_time_status_field = false;
	private $drop_give_count_status_field = false;
	private $drop_give_item_status_field = false;
	private $drop_give_user_id_status_field = false;


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
			$sql = "SELECT {$p} FROM `guild_info`";
		}
		else
		{			
			$sql = "SELECT {$p} FROM `guild_info` WHERE ".SQLUtil::parseCondition($condition);
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
			$tb = new SysGuildInfo();			
			if (isset($row['id'])) $tb->id = $row['id'];
			if (isset($row['guild_name'])) $tb->guild_name = $row['guild_name'];
			if (isset($row['host_id'])) $tb->host_id = $row['host_id'];
			if (isset($row['host_name'])) $tb->host_name = $row['host_name'];
			if (isset($row['level'])) $tb->level = intval($row['level']);
			if (isset($row['exp'])) $tb->exp = intval($row['exp']);
			if (isset($row['resource'])) $tb->resource = intval($row['resource']);
			if (isset($row['message'])) $tb->message = $row['message'];
			if (isset($row['intro'])) $tb->intro = $row['intro'];
			if (isset($row['funds'])) $tb->funds = intval($row['funds']);
			if (isset($row['max_funds'])) $tb->max_funds = intval($row['max_funds']);
			if (isset($row['server_id'])) $tb->server_id = intval($row['server_id']);
			if (isset($row['activity'])) $tb->activity = intval($row['activity']);
			if (isset($row['disband_time'])) $tb->disband_time = intval($row['disband_time']);
			if (isset($row['gift_level'])) $tb->gift_level = intval($row['gift_level']);
			if (isset($row['gift_exp'])) $tb->gift_exp = intval($row['gift_exp']);
			if (isset($row['state'])) $tb->state = intval($row['state']);
			if (isset($row['can_jump'])) $tb->can_jump = intval($row['can_jump']);
			if (isset($row['user_number'])) $tb->user_number = intval($row['user_number']);
			if (isset($row['avatar'])) $tb->avatar = intval($row['avatar']);
			if (isset($row['avatar_frame'])) $tb->avatar_frame = intval($row['avatar_frame']);
			if (isset($row['join_type'])) $tb->join_type = intval($row['join_type']);
			if (isset($row['min_level_limit'])) $tb->min_level_limit = intval($row['min_level_limit']);
			if (isset($row['vitality'])) $tb->vitality = intval($row['vitality']);
			if (isset($row['distribute_time'])) $tb->distribute_time = intval($row['distribute_time']);
			if (isset($row['distribute_num'])) $tb->distribute_num = intval($row['distribute_num']);
			if (isset($row['drop_give_time'])) $tb->drop_give_time = intval($row['drop_give_time']);
			if (isset($row['drop_give_count'])) $tb->drop_give_count = intval($row['drop_give_count']);
			if (isset($row['drop_give_item'])) $tb->drop_give_item = intval($row['drop_give_item']);
			if (isset($row['drop_give_user_id'])) $tb->drop_give_user_id = $row['drop_give_user_id'];
		
			$result[] = $tb;
		}
		
		return $result;
	}	
	
	public static function insertSqlHeader($fields=NULL)
	{
		$result = array();				
		if(!empty($fields)){
			$where = SQLUtil::parseFields($fields);			
			$result[0] = "INSERT INTO `guild_info` ({$where}) VALUES ";	
			$ar = array();
			foreach($fields as $key){
				$ar[$key]=1;
			}
			$result[1] = $ar;
		}else{
			$result[0]="INSERT INTO `guild_info` (`id`,`guild_name`,`host_id`,`host_name`,`level`,`exp`,`resource`,`message`,`intro`,`funds`,`max_funds`,`server_id`,`activity`,`disband_time`,`gift_level`,`gift_exp`,`state`,`can_jump`,`user_number`,`avatar`,`avatar_frame`,`join_type`,`min_level_limit`,`vitality`,`distribute_time`,`distribute_num`,`drop_give_time`,`drop_give_count`,`drop_give_item`,`drop_give_user_id`) VALUES ";
			$result[1] = array('id'=>1,'guild_name'=>1,'host_id'=>1,'host_name'=>1,'level'=>1,'exp'=>1,'resource'=>1,'message'=>1,'intro'=>1,'funds'=>1,'max_funds'=>1,'server_id'=>1,'activity'=>1,'disband_time'=>1,'gift_level'=>1,'gift_exp'=>1,'state'=>1,'can_jump'=>1,'user_number'=>1,'avatar'=>1,'avatar_frame'=>1,'join_type'=>1,'min_level_limit'=>1,'vitality'=>1,'distribute_time'=>1,'distribute_num'=>1,'drop_give_time'=>1,'drop_give_count'=>1,'drop_give_item'=>1,'drop_give_user_id'=>1);
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
		
		$sql = "SELECT {$p} FROM `guild_info` WHERE {$where}";

		MySQL::selectDefaultDb();
		$qr = MySQL::getInstance()->RunQuery($sql);
		$ar = MySQL::getInstance()->FetchArray($qr);
		
		if (!$ar || count($ar)==0)
		{
			return false;
		}
		
		if (isset($ar['id'])) $this->id = $ar['id'];
		if (isset($ar['guild_name'])) $this->guild_name = $ar['guild_name'];
		if (isset($ar['host_id'])) $this->host_id = $ar['host_id'];
		if (isset($ar['host_name'])) $this->host_name = $ar['host_name'];
		if (isset($ar['level'])) $this->level = intval($ar['level']);
		if (isset($ar['exp'])) $this->exp = intval($ar['exp']);
		if (isset($ar['resource'])) $this->resource = intval($ar['resource']);
		if (isset($ar['message'])) $this->message = $ar['message'];
		if (isset($ar['intro'])) $this->intro = $ar['intro'];
		if (isset($ar['funds'])) $this->funds = intval($ar['funds']);
		if (isset($ar['max_funds'])) $this->max_funds = intval($ar['max_funds']);
		if (isset($ar['server_id'])) $this->server_id = intval($ar['server_id']);
		if (isset($ar['activity'])) $this->activity = intval($ar['activity']);
		if (isset($ar['disband_time'])) $this->disband_time = intval($ar['disband_time']);
		if (isset($ar['gift_level'])) $this->gift_level = intval($ar['gift_level']);
		if (isset($ar['gift_exp'])) $this->gift_exp = intval($ar['gift_exp']);
		if (isset($ar['state'])) $this->state = intval($ar['state']);
		if (isset($ar['can_jump'])) $this->can_jump = intval($ar['can_jump']);
		if (isset($ar['user_number'])) $this->user_number = intval($ar['user_number']);
		if (isset($ar['avatar'])) $this->avatar = intval($ar['avatar']);
		if (isset($ar['avatar_frame'])) $this->avatar_frame = intval($ar['avatar_frame']);
		if (isset($ar['join_type'])) $this->join_type = intval($ar['join_type']);
		if (isset($ar['min_level_limit'])) $this->min_level_limit = intval($ar['min_level_limit']);
		if (isset($ar['vitality'])) $this->vitality = intval($ar['vitality']);
		if (isset($ar['distribute_time'])) $this->distribute_time = intval($ar['distribute_time']);
		if (isset($ar['distribute_num'])) $this->distribute_num = intval($ar['distribute_num']);
		if (isset($ar['drop_give_time'])) $this->drop_give_time = intval($ar['drop_give_time']);
		if (isset($ar['drop_give_count'])) $this->drop_give_count = intval($ar['drop_give_count']);
		if (isset($ar['drop_give_item'])) $this->drop_give_item = intval($ar['drop_give_item']);
		if (isset($ar['drop_give_user_id'])) $this->drop_give_user_id = $ar['drop_give_user_id'];
		
		
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
	
		$sql = "SELECT {$p} FROM `guild_info` WHERE {$where}";
	
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
    	if (!isset($this->guild_name)){
    		$emptyFields = false;
    		$fields[] = 'guild_name';
    	}else{
    		$emptyCondition = false; 
    		$condition['guild_name']=$this->guild_name;
    	}
    	if (!isset($this->host_id)){
    		$emptyFields = false;
    		$fields[] = 'host_id';
    	}else{
    		$emptyCondition = false; 
    		$condition['host_id']=$this->host_id;
    	}
    	if (!isset($this->host_name)){
    		$emptyFields = false;
    		$fields[] = 'host_name';
    	}else{
    		$emptyCondition = false; 
    		$condition['host_name']=$this->host_name;
    	}
    	if (!isset($this->level)){
    		$emptyFields = false;
    		$fields[] = 'level';
    	}else{
    		$emptyCondition = false; 
    		$condition['level']=$this->level;
    	}
    	if (!isset($this->exp)){
    		$emptyFields = false;
    		$fields[] = 'exp';
    	}else{
    		$emptyCondition = false; 
    		$condition['exp']=$this->exp;
    	}
    	if (!isset($this->resource)){
    		$emptyFields = false;
    		$fields[] = 'resource';
    	}else{
    		$emptyCondition = false; 
    		$condition['resource']=$this->resource;
    	}
    	if (!isset($this->message)){
    		$emptyFields = false;
    		$fields[] = 'message';
    	}else{
    		$emptyCondition = false; 
    		$condition['message']=$this->message;
    	}
    	if (!isset($this->intro)){
    		$emptyFields = false;
    		$fields[] = 'intro';
    	}else{
    		$emptyCondition = false; 
    		$condition['intro']=$this->intro;
    	}
    	if (!isset($this->funds)){
    		$emptyFields = false;
    		$fields[] = 'funds';
    	}else{
    		$emptyCondition = false; 
    		$condition['funds']=$this->funds;
    	}
    	if (!isset($this->max_funds)){
    		$emptyFields = false;
    		$fields[] = 'max_funds';
    	}else{
    		$emptyCondition = false; 
    		$condition['max_funds']=$this->max_funds;
    	}
    	if (!isset($this->server_id)){
    		$emptyFields = false;
    		$fields[] = 'server_id';
    	}else{
    		$emptyCondition = false; 
    		$condition['server_id']=$this->server_id;
    	}
    	if (!isset($this->activity)){
    		$emptyFields = false;
    		$fields[] = 'activity';
    	}else{
    		$emptyCondition = false; 
    		$condition['activity']=$this->activity;
    	}
    	if (!isset($this->disband_time)){
    		$emptyFields = false;
    		$fields[] = 'disband_time';
    	}else{
    		$emptyCondition = false; 
    		$condition['disband_time']=$this->disband_time;
    	}
    	if (!isset($this->gift_level)){
    		$emptyFields = false;
    		$fields[] = 'gift_level';
    	}else{
    		$emptyCondition = false; 
    		$condition['gift_level']=$this->gift_level;
    	}
    	if (!isset($this->gift_exp)){
    		$emptyFields = false;
    		$fields[] = 'gift_exp';
    	}else{
    		$emptyCondition = false; 
    		$condition['gift_exp']=$this->gift_exp;
    	}
    	if (!isset($this->state)){
    		$emptyFields = false;
    		$fields[] = 'state';
    	}else{
    		$emptyCondition = false; 
    		$condition['state']=$this->state;
    	}
    	if (!isset($this->can_jump)){
    		$emptyFields = false;
    		$fields[] = 'can_jump';
    	}else{
    		$emptyCondition = false; 
    		$condition['can_jump']=$this->can_jump;
    	}
    	if (!isset($this->user_number)){
    		$emptyFields = false;
    		$fields[] = 'user_number';
    	}else{
    		$emptyCondition = false; 
    		$condition['user_number']=$this->user_number;
    	}
    	if (!isset($this->avatar)){
    		$emptyFields = false;
    		$fields[] = 'avatar';
    	}else{
    		$emptyCondition = false; 
    		$condition['avatar']=$this->avatar;
    	}
    	if (!isset($this->avatar_frame)){
    		$emptyFields = false;
    		$fields[] = 'avatar_frame';
    	}else{
    		$emptyCondition = false; 
    		$condition['avatar_frame']=$this->avatar_frame;
    	}
    	if (!isset($this->join_type)){
    		$emptyFields = false;
    		$fields[] = 'join_type';
    	}else{
    		$emptyCondition = false; 
    		$condition['join_type']=$this->join_type;
    	}
    	if (!isset($this->min_level_limit)){
    		$emptyFields = false;
    		$fields[] = 'min_level_limit';
    	}else{
    		$emptyCondition = false; 
    		$condition['min_level_limit']=$this->min_level_limit;
    	}
    	if (!isset($this->vitality)){
    		$emptyFields = false;
    		$fields[] = 'vitality';
    	}else{
    		$emptyCondition = false; 
    		$condition['vitality']=$this->vitality;
    	}
    	if (!isset($this->distribute_time)){
    		$emptyFields = false;
    		$fields[] = 'distribute_time';
    	}else{
    		$emptyCondition = false; 
    		$condition['distribute_time']=$this->distribute_time;
    	}
    	if (!isset($this->distribute_num)){
    		$emptyFields = false;
    		$fields[] = 'distribute_num';
    	}else{
    		$emptyCondition = false; 
    		$condition['distribute_num']=$this->distribute_num;
    	}
    	if (!isset($this->drop_give_time)){
    		$emptyFields = false;
    		$fields[] = 'drop_give_time';
    	}else{
    		$emptyCondition = false; 
    		$condition['drop_give_time']=$this->drop_give_time;
    	}
    	if (!isset($this->drop_give_count)){
    		$emptyFields = false;
    		$fields[] = 'drop_give_count';
    	}else{
    		$emptyCondition = false; 
    		$condition['drop_give_count']=$this->drop_give_count;
    	}
    	if (!isset($this->drop_give_item)){
    		$emptyFields = false;
    		$fields[] = 'drop_give_item';
    	}else{
    		$emptyCondition = false; 
    		$condition['drop_give_item']=$this->drop_give_item;
    	}
    	if (!isset($this->drop_give_user_id)){
    		$emptyFields = false;
    		$fields[] = 'drop_give_user_id';
    	}else{
    		$emptyCondition = false; 
    		$condition['drop_give_user_id']=$this->drop_give_user_id;
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
		
		$sql = "DELETE FROM `guild_info` WHERE ".SQLUtil::parseCondition($condition);
		
		$qr = MySQL::getInstance()->RunQuery($sql);
				
		return (boolean)$qr;
	}
	
	public function  delete()
	{
		if (!isset($this->id))
		{
			return false;
		}
		
		$sql = "DELETE FROM `guild_info` WHERE `id`='{$this->id}'";
		
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
 			}else if($f == 'guild_name'){
 				$values .= "'{$this->guild_name}',";
 			}else if($f == 'host_id'){
 				$values .= "'{$this->host_id}',";
 			}else if($f == 'host_name'){
 				$values .= "'{$this->host_name}',";
 			}else if($f == 'level'){
 				$values .= "'{$this->level}',";
 			}else if($f == 'exp'){
 				$values .= "'{$this->exp}',";
 			}else if($f == 'resource'){
 				$values .= "'{$this->resource}',";
 			}else if($f == 'message'){
 				$values .= "'{$this->message}',";
 			}else if($f == 'intro'){
 				$values .= "'{$this->intro}',";
 			}else if($f == 'funds'){
 				$values .= "'{$this->funds}',";
 			}else if($f == 'max_funds'){
 				$values .= "'{$this->max_funds}',";
 			}else if($f == 'server_id'){
 				$values .= "'{$this->server_id}',";
 			}else if($f == 'activity'){
 				$values .= "'{$this->activity}',";
 			}else if($f == 'disband_time'){
 				$values .= "'{$this->disband_time}',";
 			}else if($f == 'gift_level'){
 				$values .= "'{$this->gift_level}',";
 			}else if($f == 'gift_exp'){
 				$values .= "'{$this->gift_exp}',";
 			}else if($f == 'state'){
 				$values .= "'{$this->state}',";
 			}else if($f == 'can_jump'){
 				$values .= "'{$this->can_jump}',";
 			}else if($f == 'user_number'){
 				$values .= "'{$this->user_number}',";
 			}else if($f == 'avatar'){
 				$values .= "'{$this->avatar}',";
 			}else if($f == 'avatar_frame'){
 				$values .= "'{$this->avatar_frame}',";
 			}else if($f == 'join_type'){
 				$values .= "'{$this->join_type}',";
 			}else if($f == 'min_level_limit'){
 				$values .= "'{$this->min_level_limit}',";
 			}else if($f == 'vitality'){
 				$values .= "'{$this->vitality}',";
 			}else if($f == 'distribute_time'){
 				$values .= "'{$this->distribute_time}',";
 			}else if($f == 'distribute_num'){
 				$values .= "'{$this->distribute_num}',";
 			}else if($f == 'drop_give_time'){
 				$values .= "'{$this->drop_give_time}',";
 			}else if($f == 'drop_give_count'){
 				$values .= "'{$this->drop_give_count}',";
 			}else if($f == 'drop_give_item'){
 				$values .= "'{$this->drop_give_item}',";
 			}else if($f == 'drop_give_user_id'){
 				$values .= "'{$this->drop_give_user_id}',";
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
		if (isset($this->guild_name))
		{
			$fields .= "`guild_name`,";
			$values .= "'{$this->guild_name}',";
		}
		if (isset($this->host_id))
		{
			$fields .= "`host_id`,";
			$values .= "'{$this->host_id}',";
		}
		if (isset($this->host_name))
		{
			$fields .= "`host_name`,";
			$values .= "'{$this->host_name}',";
		}
		if (isset($this->level))
		{
			$fields .= "`level`,";
			$values .= "'{$this->level}',";
		}
		if (isset($this->exp))
		{
			$fields .= "`exp`,";
			$values .= "'{$this->exp}',";
		}
		if (isset($this->resource))
		{
			$fields .= "`resource`,";
			$values .= "'{$this->resource}',";
		}
		if (isset($this->message))
		{
			$fields .= "`message`,";
			$values .= "'{$this->message}',";
		}
		if (isset($this->intro))
		{
			$fields .= "`intro`,";
			$values .= "'{$this->intro}',";
		}
		if (isset($this->funds))
		{
			$fields .= "`funds`,";
			$values .= "'{$this->funds}',";
		}
		if (isset($this->max_funds))
		{
			$fields .= "`max_funds`,";
			$values .= "'{$this->max_funds}',";
		}
		if (isset($this->server_id))
		{
			$fields .= "`server_id`,";
			$values .= "'{$this->server_id}',";
		}
		if (isset($this->activity))
		{
			$fields .= "`activity`,";
			$values .= "'{$this->activity}',";
		}
		if (isset($this->disband_time))
		{
			$fields .= "`disband_time`,";
			$values .= "'{$this->disband_time}',";
		}
		if (isset($this->gift_level))
		{
			$fields .= "`gift_level`,";
			$values .= "'{$this->gift_level}',";
		}
		if (isset($this->gift_exp))
		{
			$fields .= "`gift_exp`,";
			$values .= "'{$this->gift_exp}',";
		}
		if (isset($this->state))
		{
			$fields .= "`state`,";
			$values .= "'{$this->state}',";
		}
		if (isset($this->can_jump))
		{
			$fields .= "`can_jump`,";
			$values .= "'{$this->can_jump}',";
		}
		if (isset($this->user_number))
		{
			$fields .= "`user_number`,";
			$values .= "'{$this->user_number}',";
		}
		if (isset($this->avatar))
		{
			$fields .= "`avatar`,";
			$values .= "'{$this->avatar}',";
		}
		if (isset($this->avatar_frame))
		{
			$fields .= "`avatar_frame`,";
			$values .= "'{$this->avatar_frame}',";
		}
		if (isset($this->join_type))
		{
			$fields .= "`join_type`,";
			$values .= "'{$this->join_type}',";
		}
		if (isset($this->min_level_limit))
		{
			$fields .= "`min_level_limit`,";
			$values .= "'{$this->min_level_limit}',";
		}
		if (isset($this->vitality))
		{
			$fields .= "`vitality`,";
			$values .= "'{$this->vitality}',";
		}
		if (isset($this->distribute_time))
		{
			$fields .= "`distribute_time`,";
			$values .= "'{$this->distribute_time}',";
		}
		if (isset($this->distribute_num))
		{
			$fields .= "`distribute_num`,";
			$values .= "'{$this->distribute_num}',";
		}
		if (isset($this->drop_give_time))
		{
			$fields .= "`drop_give_time`,";
			$values .= "'{$this->drop_give_time}',";
		}
		if (isset($this->drop_give_count))
		{
			$fields .= "`drop_give_count`,";
			$values .= "'{$this->drop_give_count}',";
		}
		if (isset($this->drop_give_item))
		{
			$fields .= "`drop_give_item`,";
			$values .= "'{$this->drop_give_item}',";
		}
		if (isset($this->drop_give_user_id))
		{
			$fields .= "`drop_give_user_id`,";
			$values .= "'{$this->drop_give_user_id}',";
		}

		
		$fields .= ")";
		$values .= ")";
		
		$sql = "INSERT INTO `guild_info` ".$fields.$values;
		
		return str_replace(",)",")",$sql);
	}
	
	private function  getUpFields()
	{
		$update = "";
		
		if ($this->guild_name_status_field)
		{			
			if (!isset($this->guild_name))
			{
				$update .= ("`guild_name`=null,");
			}
			else
			{
				$update .= ("`guild_name`='{$this->guild_name}',");
			}
		}
		if ($this->host_id_status_field)
		{			
			if (!isset($this->host_id))
			{
				$update .= ("`host_id`=null,");
			}
			else
			{
				$update .= ("`host_id`='{$this->host_id}',");
			}
		}
		if ($this->host_name_status_field)
		{			
			if (!isset($this->host_name))
			{
				$update .= ("`host_name`=null,");
			}
			else
			{
				$update .= ("`host_name`='{$this->host_name}',");
			}
		}
		if ($this->level_status_field)
		{			
			if (!isset($this->level))
			{
				$update .= ("`level`=null,");
			}
			else
			{
				$update .= ("`level`='{$this->level}',");
			}
		}
		if ($this->exp_status_field)
		{			
			if (!isset($this->exp))
			{
				$update .= ("`exp`=null,");
			}
			else
			{
				$update .= ("`exp`='{$this->exp}',");
			}
		}
		if ($this->resource_status_field)
		{			
			if (!isset($this->resource))
			{
				$update .= ("`resource`=null,");
			}
			else
			{
				$update .= ("`resource`='{$this->resource}',");
			}
		}
		if ($this->message_status_field)
		{			
			if (!isset($this->message))
			{
				$update .= ("`message`=null,");
			}
			else
			{
				$update .= ("`message`='{$this->message}',");
			}
		}
		if ($this->intro_status_field)
		{			
			if (!isset($this->intro))
			{
				$update .= ("`intro`=null,");
			}
			else
			{
				$update .= ("`intro`='{$this->intro}',");
			}
		}
		if ($this->funds_status_field)
		{			
			if (!isset($this->funds))
			{
				$update .= ("`funds`=null,");
			}
			else
			{
				$update .= ("`funds`='{$this->funds}',");
			}
		}
		if ($this->max_funds_status_field)
		{			
			if (!isset($this->max_funds))
			{
				$update .= ("`max_funds`=null,");
			}
			else
			{
				$update .= ("`max_funds`='{$this->max_funds}',");
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
		if ($this->activity_status_field)
		{			
			if (!isset($this->activity))
			{
				$update .= ("`activity`=null,");
			}
			else
			{
				$update .= ("`activity`='{$this->activity}',");
			}
		}
		if ($this->disband_time_status_field)
		{			
			if (!isset($this->disband_time))
			{
				$update .= ("`disband_time`=null,");
			}
			else
			{
				$update .= ("`disband_time`='{$this->disband_time}',");
			}
		}
		if ($this->gift_level_status_field)
		{			
			if (!isset($this->gift_level))
			{
				$update .= ("`gift_level`=null,");
			}
			else
			{
				$update .= ("`gift_level`='{$this->gift_level}',");
			}
		}
		if ($this->gift_exp_status_field)
		{			
			if (!isset($this->gift_exp))
			{
				$update .= ("`gift_exp`=null,");
			}
			else
			{
				$update .= ("`gift_exp`='{$this->gift_exp}',");
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
		if ($this->can_jump_status_field)
		{			
			if (!isset($this->can_jump))
			{
				$update .= ("`can_jump`=null,");
			}
			else
			{
				$update .= ("`can_jump`='{$this->can_jump}',");
			}
		}
		if ($this->user_number_status_field)
		{			
			if (!isset($this->user_number))
			{
				$update .= ("`user_number`=null,");
			}
			else
			{
				$update .= ("`user_number`='{$this->user_number}',");
			}
		}
		if ($this->avatar_status_field)
		{			
			if (!isset($this->avatar))
			{
				$update .= ("`avatar`=null,");
			}
			else
			{
				$update .= ("`avatar`='{$this->avatar}',");
			}
		}
		if ($this->avatar_frame_status_field)
		{			
			if (!isset($this->avatar_frame))
			{
				$update .= ("`avatar_frame`=null,");
			}
			else
			{
				$update .= ("`avatar_frame`='{$this->avatar_frame}',");
			}
		}
		if ($this->join_type_status_field)
		{			
			if (!isset($this->join_type))
			{
				$update .= ("`join_type`=null,");
			}
			else
			{
				$update .= ("`join_type`='{$this->join_type}',");
			}
		}
		if ($this->min_level_limit_status_field)
		{			
			if (!isset($this->min_level_limit))
			{
				$update .= ("`min_level_limit`=null,");
			}
			else
			{
				$update .= ("`min_level_limit`='{$this->min_level_limit}',");
			}
		}
		if ($this->vitality_status_field)
		{			
			if (!isset($this->vitality))
			{
				$update .= ("`vitality`=null,");
			}
			else
			{
				$update .= ("`vitality`='{$this->vitality}',");
			}
		}
		if ($this->distribute_time_status_field)
		{			
			if (!isset($this->distribute_time))
			{
				$update .= ("`distribute_time`=null,");
			}
			else
			{
				$update .= ("`distribute_time`='{$this->distribute_time}',");
			}
		}
		if ($this->distribute_num_status_field)
		{			
			if (!isset($this->distribute_num))
			{
				$update .= ("`distribute_num`=null,");
			}
			else
			{
				$update .= ("`distribute_num`='{$this->distribute_num}',");
			}
		}
		if ($this->drop_give_time_status_field)
		{			
			if (!isset($this->drop_give_time))
			{
				$update .= ("`drop_give_time`=null,");
			}
			else
			{
				$update .= ("`drop_give_time`='{$this->drop_give_time}',");
			}
		}
		if ($this->drop_give_count_status_field)
		{			
			if (!isset($this->drop_give_count))
			{
				$update .= ("`drop_give_count`=null,");
			}
			else
			{
				$update .= ("`drop_give_count`='{$this->drop_give_count}',");
			}
		}
		if ($this->drop_give_item_status_field)
		{			
			if (!isset($this->drop_give_item))
			{
				$update .= ("`drop_give_item`=null,");
			}
			else
			{
				$update .= ("`drop_give_item`='{$this->drop_give_item}',");
			}
		}
		if ($this->drop_give_user_id_status_field)
		{			
			if (!isset($this->drop_give_user_id))
			{
				$update .= ("`drop_give_user_id`=null,");
			}
			else
			{
				$update .= ("`drop_give_user_id`='{$this->drop_give_user_id}',");
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
		
		$sql = "UPDATE `guild_info` SET {$update} WHERE {$condition}";
		
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
		
		$sql = "UPDATE `guild_info` SET {$update} WHERE {$uc}";
		
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
		
		$sql = "UPDATE `guild_info` SET {$update} WHERE {$uc}";
		
		MySQL::selectDefaultDb();
		$qr = MySQL::getInstance()->RunQuery($sql);
				
		return (boolean)$qr;
	}
	
	private function /*void*/ clean() 
	{
		$this->this_table_status_field = false;
		$this->id_status_field = false;
		$this->guild_name_status_field = false;
		$this->host_id_status_field = false;
		$this->host_name_status_field = false;
		$this->level_status_field = false;
		$this->exp_status_field = false;
		$this->resource_status_field = false;
		$this->message_status_field = false;
		$this->intro_status_field = false;
		$this->funds_status_field = false;
		$this->max_funds_status_field = false;
		$this->server_id_status_field = false;
		$this->activity_status_field = false;
		$this->disband_time_status_field = false;
		$this->gift_level_status_field = false;
		$this->gift_exp_status_field = false;
		$this->state_status_field = false;
		$this->can_jump_status_field = false;
		$this->user_number_status_field = false;
		$this->avatar_status_field = false;
		$this->avatar_frame_status_field = false;
		$this->join_type_status_field = false;
		$this->min_level_limit_status_field = false;
		$this->vitality_status_field = false;
		$this->distribute_time_status_field = false;
		$this->distribute_num_status_field = false;
		$this->drop_give_time_status_field = false;
		$this->drop_give_count_status_field = false;
		$this->drop_give_item_status_field = false;
		$this->drop_give_user_id_status_field = false;

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

	public function /*string*/ getGuildName()
	{
		return $this->guild_name;
	}
	
	public function /*void*/ setGuildName(/*string*/ $guild_name)
	{
		$this->guild_name = SQLUtil::toSafeSQLString($guild_name);
		$this->guild_name_status_field = true;		
		$this->this_table_status_field = true;		
	}

	public function /*void*/ setGuildNameNull()
	{
		$this->guild_name = null;
		$this->guild_name_status_field = true;		
		$this->this_table_status_field = true;
	}

	public function /*string*/ getHostId()
	{
		return $this->host_id;
	}
	
	public function /*void*/ setHostId(/*string*/ $host_id)
	{
		$this->host_id = SQLUtil::toSafeSQLString($host_id);
		$this->host_id_status_field = true;		
		$this->this_table_status_field = true;		
	}

	public function /*void*/ setHostIdNull()
	{
		$this->host_id = null;
		$this->host_id_status_field = true;		
		$this->this_table_status_field = true;
	}

	public function /*string*/ getHostName()
	{
		return $this->host_name;
	}
	
	public function /*void*/ setHostName(/*string*/ $host_name)
	{
		$this->host_name = SQLUtil::toSafeSQLString($host_name);
		$this->host_name_status_field = true;		
		$this->this_table_status_field = true;		
	}

	public function /*void*/ setHostNameNull()
	{
		$this->host_name = null;
		$this->host_name_status_field = true;		
		$this->this_table_status_field = true;
	}

	public function /*int*/ getLevel()
	{
		return $this->level;
	}
	
	public function /*void*/ setLevel(/*int*/ $level)
	{
		$this->level = intval($level);
		$this->level_status_field = true;		
		$this->this_table_status_field = true;		
	}

	public function /*void*/ setLevelNull()
	{
		$this->level = null;
		$this->level_status_field = true;		
		$this->this_table_status_field = true;
	}

	public function /*int*/ getExp()
	{
		return $this->exp;
	}
	
	public function /*void*/ setExp(/*int*/ $exp)
	{
		$this->exp = intval($exp);
		$this->exp_status_field = true;		
		$this->this_table_status_field = true;		
	}

	public function /*void*/ setExpNull()
	{
		$this->exp = null;
		$this->exp_status_field = true;		
		$this->this_table_status_field = true;
	}

	public function /*int*/ getResource()
	{
		return $this->resource;
	}
	
	public function /*void*/ setResource(/*int*/ $resource)
	{
		$this->resource = intval($resource);
		$this->resource_status_field = true;		
		$this->this_table_status_field = true;		
	}

	public function /*void*/ setResourceNull()
	{
		$this->resource = null;
		$this->resource_status_field = true;		
		$this->this_table_status_field = true;
	}

	public function /*string*/ getMessage()
	{
		return $this->message;
	}
	
	public function /*void*/ setMessage(/*string*/ $message)
	{
		$this->message = SQLUtil::toSafeSQLString($message);
		$this->message_status_field = true;		
		$this->this_table_status_field = true;		
	}

	public function /*void*/ setMessageNull()
	{
		$this->message = null;
		$this->message_status_field = true;		
		$this->this_table_status_field = true;
	}

	public function /*string*/ getIntro()
	{
		return $this->intro;
	}
	
	public function /*void*/ setIntro(/*string*/ $intro)
	{
		$this->intro = SQLUtil::toSafeSQLString($intro);
		$this->intro_status_field = true;		
		$this->this_table_status_field = true;		
	}

	public function /*void*/ setIntroNull()
	{
		$this->intro = null;
		$this->intro_status_field = true;		
		$this->this_table_status_field = true;
	}

	public function /*int*/ getFunds()
	{
		return $this->funds;
	}
	
	public function /*void*/ setFunds(/*int*/ $funds)
	{
		$this->funds = intval($funds);
		$this->funds_status_field = true;		
		$this->this_table_status_field = true;		
	}

	public function /*void*/ setFundsNull()
	{
		$this->funds = null;
		$this->funds_status_field = true;		
		$this->this_table_status_field = true;
	}

	public function /*int*/ getMaxFunds()
	{
		return $this->max_funds;
	}
	
	public function /*void*/ setMaxFunds(/*int*/ $max_funds)
	{
		$this->max_funds = intval($max_funds);
		$this->max_funds_status_field = true;		
		$this->this_table_status_field = true;		
	}

	public function /*void*/ setMaxFundsNull()
	{
		$this->max_funds = null;
		$this->max_funds_status_field = true;		
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

	public function /*int*/ getActivity()
	{
		return $this->activity;
	}
	
	public function /*void*/ setActivity(/*int*/ $activity)
	{
		$this->activity = intval($activity);
		$this->activity_status_field = true;		
		$this->this_table_status_field = true;		
	}

	public function /*void*/ setActivityNull()
	{
		$this->activity = null;
		$this->activity_status_field = true;		
		$this->this_table_status_field = true;
	}

	public function /*int*/ getDisbandTime()
	{
		return $this->disband_time;
	}
	
	public function /*void*/ setDisbandTime(/*int*/ $disband_time)
	{
		$this->disband_time = intval($disband_time);
		$this->disband_time_status_field = true;		
		$this->this_table_status_field = true;		
	}

	public function /*void*/ setDisbandTimeNull()
	{
		$this->disband_time = null;
		$this->disband_time_status_field = true;		
		$this->this_table_status_field = true;
	}

	public function /*int*/ getGiftLevel()
	{
		return $this->gift_level;
	}
	
	public function /*void*/ setGiftLevel(/*int*/ $gift_level)
	{
		$this->gift_level = intval($gift_level);
		$this->gift_level_status_field = true;		
		$this->this_table_status_field = true;		
	}

	public function /*void*/ setGiftLevelNull()
	{
		$this->gift_level = null;
		$this->gift_level_status_field = true;		
		$this->this_table_status_field = true;
	}

	public function /*int*/ getGiftExp()
	{
		return $this->gift_exp;
	}
	
	public function /*void*/ setGiftExp(/*int*/ $gift_exp)
	{
		$this->gift_exp = intval($gift_exp);
		$this->gift_exp_status_field = true;		
		$this->this_table_status_field = true;		
	}

	public function /*void*/ setGiftExpNull()
	{
		$this->gift_exp = null;
		$this->gift_exp_status_field = true;		
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

	public function /*int*/ getCanJump()
	{
		return $this->can_jump;
	}
	
	public function /*void*/ setCanJump(/*int*/ $can_jump)
	{
		$this->can_jump = intval($can_jump);
		$this->can_jump_status_field = true;		
		$this->this_table_status_field = true;		
	}

	public function /*void*/ setCanJumpNull()
	{
		$this->can_jump = null;
		$this->can_jump_status_field = true;		
		$this->this_table_status_field = true;
	}

	public function /*int*/ getUserNumber()
	{
		return $this->user_number;
	}
	
	public function /*void*/ setUserNumber(/*int*/ $user_number)
	{
		$this->user_number = intval($user_number);
		$this->user_number_status_field = true;		
		$this->this_table_status_field = true;		
	}

	public function /*void*/ setUserNumberNull()
	{
		$this->user_number = null;
		$this->user_number_status_field = true;		
		$this->this_table_status_field = true;
	}

	public function /*int*/ getAvatar()
	{
		return $this->avatar;
	}
	
	public function /*void*/ setAvatar(/*int*/ $avatar)
	{
		$this->avatar = intval($avatar);
		$this->avatar_status_field = true;		
		$this->this_table_status_field = true;		
	}

	public function /*void*/ setAvatarNull()
	{
		$this->avatar = null;
		$this->avatar_status_field = true;		
		$this->this_table_status_field = true;
	}

	public function /*int*/ getAvatarFrame()
	{
		return $this->avatar_frame;
	}
	
	public function /*void*/ setAvatarFrame(/*int*/ $avatar_frame)
	{
		$this->avatar_frame = intval($avatar_frame);
		$this->avatar_frame_status_field = true;		
		$this->this_table_status_field = true;		
	}

	public function /*void*/ setAvatarFrameNull()
	{
		$this->avatar_frame = null;
		$this->avatar_frame_status_field = true;		
		$this->this_table_status_field = true;
	}

	public function /*int*/ getJoinType()
	{
		return $this->join_type;
	}
	
	public function /*void*/ setJoinType(/*int*/ $join_type)
	{
		$this->join_type = intval($join_type);
		$this->join_type_status_field = true;		
		$this->this_table_status_field = true;		
	}

	public function /*void*/ setJoinTypeNull()
	{
		$this->join_type = null;
		$this->join_type_status_field = true;		
		$this->this_table_status_field = true;
	}

	public function /*int*/ getMinLevelLimit()
	{
		return $this->min_level_limit;
	}
	
	public function /*void*/ setMinLevelLimit(/*int*/ $min_level_limit)
	{
		$this->min_level_limit = intval($min_level_limit);
		$this->min_level_limit_status_field = true;		
		$this->this_table_status_field = true;		
	}

	public function /*void*/ setMinLevelLimitNull()
	{
		$this->min_level_limit = null;
		$this->min_level_limit_status_field = true;		
		$this->this_table_status_field = true;
	}

	public function /*int*/ getVitality()
	{
		return $this->vitality;
	}
	
	public function /*void*/ setVitality(/*int*/ $vitality)
	{
		$this->vitality = intval($vitality);
		$this->vitality_status_field = true;		
		$this->this_table_status_field = true;		
	}

	public function /*void*/ setVitalityNull()
	{
		$this->vitality = null;
		$this->vitality_status_field = true;		
		$this->this_table_status_field = true;
	}

	public function /*int*/ getDistributeTime()
	{
		return $this->distribute_time;
	}
	
	public function /*void*/ setDistributeTime(/*int*/ $distribute_time)
	{
		$this->distribute_time = intval($distribute_time);
		$this->distribute_time_status_field = true;		
		$this->this_table_status_field = true;		
	}

	public function /*void*/ setDistributeTimeNull()
	{
		$this->distribute_time = null;
		$this->distribute_time_status_field = true;		
		$this->this_table_status_field = true;
	}

	public function /*int*/ getDistributeNum()
	{
		return $this->distribute_num;
	}
	
	public function /*void*/ setDistributeNum(/*int*/ $distribute_num)
	{
		$this->distribute_num = intval($distribute_num);
		$this->distribute_num_status_field = true;		
		$this->this_table_status_field = true;		
	}

	public function /*void*/ setDistributeNumNull()
	{
		$this->distribute_num = null;
		$this->distribute_num_status_field = true;		
		$this->this_table_status_field = true;
	}

	public function /*int*/ getDropGiveTime()
	{
		return $this->drop_give_time;
	}
	
	public function /*void*/ setDropGiveTime(/*int*/ $drop_give_time)
	{
		$this->drop_give_time = intval($drop_give_time);
		$this->drop_give_time_status_field = true;		
		$this->this_table_status_field = true;		
	}

	public function /*void*/ setDropGiveTimeNull()
	{
		$this->drop_give_time = null;
		$this->drop_give_time_status_field = true;		
		$this->this_table_status_field = true;
	}

	public function /*int*/ getDropGiveCount()
	{
		return $this->drop_give_count;
	}
	
	public function /*void*/ setDropGiveCount(/*int*/ $drop_give_count)
	{
		$this->drop_give_count = intval($drop_give_count);
		$this->drop_give_count_status_field = true;		
		$this->this_table_status_field = true;		
	}

	public function /*void*/ setDropGiveCountNull()
	{
		$this->drop_give_count = null;
		$this->drop_give_count_status_field = true;		
		$this->this_table_status_field = true;
	}

	public function /*int*/ getDropGiveItem()
	{
		return $this->drop_give_item;
	}
	
	public function /*void*/ setDropGiveItem(/*int*/ $drop_give_item)
	{
		$this->drop_give_item = intval($drop_give_item);
		$this->drop_give_item_status_field = true;		
		$this->this_table_status_field = true;		
	}

	public function /*void*/ setDropGiveItemNull()
	{
		$this->drop_give_item = null;
		$this->drop_give_item_status_field = true;		
		$this->this_table_status_field = true;
	}

	public function /*string*/ getDropGiveUserId()
	{
		return $this->drop_give_user_id;
	}
	
	public function /*void*/ setDropGiveUserId(/*string*/ $drop_give_user_id)
	{
		$this->drop_give_user_id = SQLUtil::toSafeSQLString($drop_give_user_id);
		$this->drop_give_user_id_status_field = true;		
		$this->this_table_status_field = true;		
	}

	public function /*void*/ setDropGiveUserIdNull()
	{
		$this->drop_give_user_id = null;
		$this->drop_give_user_id_status_field = true;		
		$this->this_table_status_field = true;
	}

	
	public function /*string*/ toDebugString()
	{
		$dbg = "(";
		
		$dbg .= ("id={$this->id},");
		$dbg .= ("guild_name={$this->guild_name},");
		$dbg .= ("host_id={$this->host_id},");
		$dbg .= ("host_name={$this->host_name},");
		$dbg .= ("level={$this->level},");
		$dbg .= ("exp={$this->exp},");
		$dbg .= ("resource={$this->resource},");
		$dbg .= ("message={$this->message},");
		$dbg .= ("intro={$this->intro},");
		$dbg .= ("funds={$this->funds},");
		$dbg .= ("max_funds={$this->max_funds},");
		$dbg .= ("server_id={$this->server_id},");
		$dbg .= ("activity={$this->activity},");
		$dbg .= ("disband_time={$this->disband_time},");
		$dbg .= ("gift_level={$this->gift_level},");
		$dbg .= ("gift_exp={$this->gift_exp},");
		$dbg .= ("state={$this->state},");
		$dbg .= ("can_jump={$this->can_jump},");
		$dbg .= ("user_number={$this->user_number},");
		$dbg .= ("avatar={$this->avatar},");
		$dbg .= ("avatar_frame={$this->avatar_frame},");
		$dbg .= ("join_type={$this->join_type},");
		$dbg .= ("min_level_limit={$this->min_level_limit},");
		$dbg .= ("vitality={$this->vitality},");
		$dbg .= ("distribute_time={$this->distribute_time},");
		$dbg .= ("distribute_num={$this->distribute_num},");
		$dbg .= ("drop_give_time={$this->drop_give_time},");
		$dbg .= ("drop_give_count={$this->drop_give_count},");
		$dbg .= ("drop_give_item={$this->drop_give_item},");
		$dbg .= ("drop_give_user_id={$this->drop_give_user_id},");

		$dbg .= ")";
				
		return str_replace(",)",")",$dbg);
	}
}

?>
