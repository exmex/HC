<?php
require_once ($GLOBALS ['GAME_ROOT'] . "CMySQL.php");
require_once ("SQLUtil.php");
/**
 *  [The generated files]
 */

class SysPlayerGuild {
	
	private /*string*/ $user_id; //PRIMARY KEY 
	private /*string*/ $guild_id;
	private /*int*/ $guild_position;
	private /*int*/ $last_quit_time;
	private /*int*/ $contribution;
	private /*int*/ $daily_contribution;
	private /*int*/ $total_contribution;
	private /*int*/ $last_refresh_daily_contribution_time;
	private /*int*/ $last_guild_contribution;
	private /*int*/ $last_donation_time;
	private /*int*/ $claim_time;
	private /*int*/ $claim_chest_time;
	private /*int*/ $claim_chest_num;
	private /*string*/ $last_guild_id;
	private /*int*/ $worship_last_time;
	private /*int*/ $worship_number;
	private /*string*/ $worship_uid;
	private /*int*/ $worship_reward_number;
	private /*int*/ $worship_reward_last_time;
	private /*int*/ $worship_reward_claim_time;
	private /*string*/ $worship_reward_info;
	private /*int*/ $vitality;
	private /*int*/ $vitality_time;
	private /*int*/ $join_time;
	private /*int*/ $stage_max_damage;

	
	private $this_table_status_field = false;
	private $user_id_status_field = false;
	private $guild_id_status_field = false;
	private $guild_position_status_field = false;
	private $last_quit_time_status_field = false;
	private $contribution_status_field = false;
	private $daily_contribution_status_field = false;
	private $total_contribution_status_field = false;
	private $last_refresh_daily_contribution_time_status_field = false;
	private $last_guild_contribution_status_field = false;
	private $last_donation_time_status_field = false;
	private $claim_time_status_field = false;
	private $claim_chest_time_status_field = false;
	private $claim_chest_num_status_field = false;
	private $last_guild_id_status_field = false;
	private $worship_last_time_status_field = false;
	private $worship_number_status_field = false;
	private $worship_uid_status_field = false;
	private $worship_reward_number_status_field = false;
	private $worship_reward_last_time_status_field = false;
	private $worship_reward_claim_time_status_field = false;
	private $worship_reward_info_status_field = false;
	private $vitality_status_field = false;
	private $vitality_time_status_field = false;
	private $join_time_status_field = false;
	private $stage_max_damage_status_field = false;


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
			$sql = "SELECT {$p} FROM `player_guild`";
		}
		else
		{			
			$sql = "SELECT {$p} FROM `player_guild` WHERE ".SQLUtil::parseCondition($condition);
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
			$tb = new SysPlayerGuild();			
			if (isset($row['user_id'])) $tb->user_id = $row['user_id'];
			if (isset($row['guild_id'])) $tb->guild_id = $row['guild_id'];
			if (isset($row['guild_position'])) $tb->guild_position = intval($row['guild_position']);
			if (isset($row['last_quit_time'])) $tb->last_quit_time = intval($row['last_quit_time']);
			if (isset($row['contribution'])) $tb->contribution = intval($row['contribution']);
			if (isset($row['daily_contribution'])) $tb->daily_contribution = intval($row['daily_contribution']);
			if (isset($row['total_contribution'])) $tb->total_contribution = intval($row['total_contribution']);
			if (isset($row['last_refresh_daily_contribution_time'])) $tb->last_refresh_daily_contribution_time = intval($row['last_refresh_daily_contribution_time']);
			if (isset($row['last_guild_contribution'])) $tb->last_guild_contribution = intval($row['last_guild_contribution']);
			if (isset($row['last_donation_time'])) $tb->last_donation_time = intval($row['last_donation_time']);
			if (isset($row['claim_time'])) $tb->claim_time = intval($row['claim_time']);
			if (isset($row['claim_chest_time'])) $tb->claim_chest_time = intval($row['claim_chest_time']);
			if (isset($row['claim_chest_num'])) $tb->claim_chest_num = intval($row['claim_chest_num']);
			if (isset($row['last_guild_id'])) $tb->last_guild_id = $row['last_guild_id'];
			if (isset($row['worship_last_time'])) $tb->worship_last_time = intval($row['worship_last_time']);
			if (isset($row['worship_number'])) $tb->worship_number = intval($row['worship_number']);
			if (isset($row['worship_uid'])) $tb->worship_uid = $row['worship_uid'];
			if (isset($row['worship_reward_number'])) $tb->worship_reward_number = intval($row['worship_reward_number']);
			if (isset($row['worship_reward_last_time'])) $tb->worship_reward_last_time = intval($row['worship_reward_last_time']);
			if (isset($row['worship_reward_claim_time'])) $tb->worship_reward_claim_time = intval($row['worship_reward_claim_time']);
			if (isset($row['worship_reward_info'])) $tb->worship_reward_info = $row['worship_reward_info'];
			if (isset($row['vitality'])) $tb->vitality = intval($row['vitality']);
			if (isset($row['vitality_time'])) $tb->vitality_time = intval($row['vitality_time']);
			if (isset($row['join_time'])) $tb->join_time = intval($row['join_time']);
			if (isset($row['stage_max_damage'])) $tb->stage_max_damage = intval($row['stage_max_damage']);
		
			$result[] = $tb;
		}
		
		return $result;
	}	
	
	public static function insertSqlHeader($fields=NULL)
	{
		$result = array();				
		if(!empty($fields)){
			$where = SQLUtil::parseFields($fields);			
			$result[0] = "INSERT INTO `player_guild` ({$where}) VALUES ";	
			$ar = array();
			foreach($fields as $key){
				$ar[$key]=1;
			}
			$result[1] = $ar;
		}else{
			$result[0]="INSERT INTO `player_guild` (`user_id`,`guild_id`,`guild_position`,`last_quit_time`,`contribution`,`daily_contribution`,`total_contribution`,`last_refresh_daily_contribution_time`,`last_guild_contribution`,`last_donation_time`,`claim_time`,`claim_chest_time`,`claim_chest_num`,`last_guild_id`,`worship_last_time`,`worship_number`,`worship_uid`,`worship_reward_number`,`worship_reward_last_time`,`worship_reward_claim_time`,`worship_reward_info`,`vitality`,`vitality_time`,`join_time`,`stage_max_damage`) VALUES ";
			$result[1] = array('user_id'=>1,'guild_id'=>1,'guild_position'=>1,'last_quit_time'=>1,'contribution'=>1,'daily_contribution'=>1,'total_contribution'=>1,'last_refresh_daily_contribution_time'=>1,'last_guild_contribution'=>1,'last_donation_time'=>1,'claim_time'=>1,'claim_chest_time'=>1,'claim_chest_num'=>1,'last_guild_id'=>1,'worship_last_time'=>1,'worship_number'=>1,'worship_uid'=>1,'worship_reward_number'=>1,'worship_reward_last_time'=>1,'worship_reward_claim_time'=>1,'worship_reward_info'=>1,'vitality'=>1,'vitality_time'=>1,'join_time'=>1,'stage_max_damage'=>1);
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
		
		$sql = "SELECT {$p} FROM `player_guild` WHERE {$where}";

		if(isset($this->user_id)){MySQL::selectDbForUser($this->user_id);}else{MySQL::selectDbForUser($GLOBALS['USER_ID']);}
		$qr = MySQL::getInstance()->RunQuery($sql);
		$ar = MySQL::getInstance()->FetchArray($qr);
		
		if (!$ar || count($ar)==0)
		{
			return false;
		}
		
		if (isset($ar['user_id'])) $this->user_id = $ar['user_id'];
		if (isset($ar['guild_id'])) $this->guild_id = $ar['guild_id'];
		if (isset($ar['guild_position'])) $this->guild_position = intval($ar['guild_position']);
		if (isset($ar['last_quit_time'])) $this->last_quit_time = intval($ar['last_quit_time']);
		if (isset($ar['contribution'])) $this->contribution = intval($ar['contribution']);
		if (isset($ar['daily_contribution'])) $this->daily_contribution = intval($ar['daily_contribution']);
		if (isset($ar['total_contribution'])) $this->total_contribution = intval($ar['total_contribution']);
		if (isset($ar['last_refresh_daily_contribution_time'])) $this->last_refresh_daily_contribution_time = intval($ar['last_refresh_daily_contribution_time']);
		if (isset($ar['last_guild_contribution'])) $this->last_guild_contribution = intval($ar['last_guild_contribution']);
		if (isset($ar['last_donation_time'])) $this->last_donation_time = intval($ar['last_donation_time']);
		if (isset($ar['claim_time'])) $this->claim_time = intval($ar['claim_time']);
		if (isset($ar['claim_chest_time'])) $this->claim_chest_time = intval($ar['claim_chest_time']);
		if (isset($ar['claim_chest_num'])) $this->claim_chest_num = intval($ar['claim_chest_num']);
		if (isset($ar['last_guild_id'])) $this->last_guild_id = $ar['last_guild_id'];
		if (isset($ar['worship_last_time'])) $this->worship_last_time = intval($ar['worship_last_time']);
		if (isset($ar['worship_number'])) $this->worship_number = intval($ar['worship_number']);
		if (isset($ar['worship_uid'])) $this->worship_uid = $ar['worship_uid'];
		if (isset($ar['worship_reward_number'])) $this->worship_reward_number = intval($ar['worship_reward_number']);
		if (isset($ar['worship_reward_last_time'])) $this->worship_reward_last_time = intval($ar['worship_reward_last_time']);
		if (isset($ar['worship_reward_claim_time'])) $this->worship_reward_claim_time = intval($ar['worship_reward_claim_time']);
		if (isset($ar['worship_reward_info'])) $this->worship_reward_info = $ar['worship_reward_info'];
		if (isset($ar['vitality'])) $this->vitality = intval($ar['vitality']);
		if (isset($ar['vitality_time'])) $this->vitality_time = intval($ar['vitality_time']);
		if (isset($ar['join_time'])) $this->join_time = intval($ar['join_time']);
		if (isset($ar['stage_max_damage'])) $this->stage_max_damage = intval($ar['stage_max_damage']);
		
		
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
	
		$sql = "SELECT {$p} FROM `player_guild` WHERE {$where}";
	
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
    	if (!isset($this->guild_id)){
    		$emptyFields = false;
    		$fields[] = 'guild_id';
    	}else{
    		$emptyCondition = false; 
    		$condition['guild_id']=$this->guild_id;
    	}
    	if (!isset($this->guild_position)){
    		$emptyFields = false;
    		$fields[] = 'guild_position';
    	}else{
    		$emptyCondition = false; 
    		$condition['guild_position']=$this->guild_position;
    	}
    	if (!isset($this->last_quit_time)){
    		$emptyFields = false;
    		$fields[] = 'last_quit_time';
    	}else{
    		$emptyCondition = false; 
    		$condition['last_quit_time']=$this->last_quit_time;
    	}
    	if (!isset($this->contribution)){
    		$emptyFields = false;
    		$fields[] = 'contribution';
    	}else{
    		$emptyCondition = false; 
    		$condition['contribution']=$this->contribution;
    	}
    	if (!isset($this->daily_contribution)){
    		$emptyFields = false;
    		$fields[] = 'daily_contribution';
    	}else{
    		$emptyCondition = false; 
    		$condition['daily_contribution']=$this->daily_contribution;
    	}
    	if (!isset($this->total_contribution)){
    		$emptyFields = false;
    		$fields[] = 'total_contribution';
    	}else{
    		$emptyCondition = false; 
    		$condition['total_contribution']=$this->total_contribution;
    	}
    	if (!isset($this->last_refresh_daily_contribution_time)){
    		$emptyFields = false;
    		$fields[] = 'last_refresh_daily_contribution_time';
    	}else{
    		$emptyCondition = false; 
    		$condition['last_refresh_daily_contribution_time']=$this->last_refresh_daily_contribution_time;
    	}
    	if (!isset($this->last_guild_contribution)){
    		$emptyFields = false;
    		$fields[] = 'last_guild_contribution';
    	}else{
    		$emptyCondition = false; 
    		$condition['last_guild_contribution']=$this->last_guild_contribution;
    	}
    	if (!isset($this->last_donation_time)){
    		$emptyFields = false;
    		$fields[] = 'last_donation_time';
    	}else{
    		$emptyCondition = false; 
    		$condition['last_donation_time']=$this->last_donation_time;
    	}
    	if (!isset($this->claim_time)){
    		$emptyFields = false;
    		$fields[] = 'claim_time';
    	}else{
    		$emptyCondition = false; 
    		$condition['claim_time']=$this->claim_time;
    	}
    	if (!isset($this->claim_chest_time)){
    		$emptyFields = false;
    		$fields[] = 'claim_chest_time';
    	}else{
    		$emptyCondition = false; 
    		$condition['claim_chest_time']=$this->claim_chest_time;
    	}
    	if (!isset($this->claim_chest_num)){
    		$emptyFields = false;
    		$fields[] = 'claim_chest_num';
    	}else{
    		$emptyCondition = false; 
    		$condition['claim_chest_num']=$this->claim_chest_num;
    	}
    	if (!isset($this->last_guild_id)){
    		$emptyFields = false;
    		$fields[] = 'last_guild_id';
    	}else{
    		$emptyCondition = false; 
    		$condition['last_guild_id']=$this->last_guild_id;
    	}
    	if (!isset($this->worship_last_time)){
    		$emptyFields = false;
    		$fields[] = 'worship_last_time';
    	}else{
    		$emptyCondition = false; 
    		$condition['worship_last_time']=$this->worship_last_time;
    	}
    	if (!isset($this->worship_number)){
    		$emptyFields = false;
    		$fields[] = 'worship_number';
    	}else{
    		$emptyCondition = false; 
    		$condition['worship_number']=$this->worship_number;
    	}
    	if (!isset($this->worship_uid)){
    		$emptyFields = false;
    		$fields[] = 'worship_uid';
    	}else{
    		$emptyCondition = false; 
    		$condition['worship_uid']=$this->worship_uid;
    	}
    	if (!isset($this->worship_reward_number)){
    		$emptyFields = false;
    		$fields[] = 'worship_reward_number';
    	}else{
    		$emptyCondition = false; 
    		$condition['worship_reward_number']=$this->worship_reward_number;
    	}
    	if (!isset($this->worship_reward_last_time)){
    		$emptyFields = false;
    		$fields[] = 'worship_reward_last_time';
    	}else{
    		$emptyCondition = false; 
    		$condition['worship_reward_last_time']=$this->worship_reward_last_time;
    	}
    	if (!isset($this->worship_reward_claim_time)){
    		$emptyFields = false;
    		$fields[] = 'worship_reward_claim_time';
    	}else{
    		$emptyCondition = false; 
    		$condition['worship_reward_claim_time']=$this->worship_reward_claim_time;
    	}
    	if (!isset($this->worship_reward_info)){
    		$emptyFields = false;
    		$fields[] = 'worship_reward_info';
    	}else{
    		$emptyCondition = false; 
    		$condition['worship_reward_info']=$this->worship_reward_info;
    	}
    	if (!isset($this->vitality)){
    		$emptyFields = false;
    		$fields[] = 'vitality';
    	}else{
    		$emptyCondition = false; 
    		$condition['vitality']=$this->vitality;
    	}
    	if (!isset($this->vitality_time)){
    		$emptyFields = false;
    		$fields[] = 'vitality_time';
    	}else{
    		$emptyCondition = false; 
    		$condition['vitality_time']=$this->vitality_time;
    	}
    	if (!isset($this->join_time)){
    		$emptyFields = false;
    		$fields[] = 'join_time';
    	}else{
    		$emptyCondition = false; 
    		$condition['join_time']=$this->join_time;
    	}
    	if (!isset($this->stage_max_damage)){
    		$emptyFields = false;
    		$fields[] = 'stage_max_damage';
    	}else{
    		$emptyCondition = false; 
    		$condition['stage_max_damage']=$this->stage_max_damage;
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
		
		$sql = "DELETE FROM `player_guild` WHERE ".SQLUtil::parseCondition($condition);
		
		$qr = MySQL::getInstance()->RunQuery($sql);
				
		return (boolean)$qr;
	}
	
	public function  delete()
	{
		if (!isset($this->user_id))
		{
			return false;
		}
		
		$sql = "DELETE FROM `player_guild` WHERE `user_id`='{$this->user_id}'";
		
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
 			}else if($f == 'guild_id'){
 				$values .= "'{$this->guild_id}',";
 			}else if($f == 'guild_position'){
 				$values .= "'{$this->guild_position}',";
 			}else if($f == 'last_quit_time'){
 				$values .= "'{$this->last_quit_time}',";
 			}else if($f == 'contribution'){
 				$values .= "'{$this->contribution}',";
 			}else if($f == 'daily_contribution'){
 				$values .= "'{$this->daily_contribution}',";
 			}else if($f == 'total_contribution'){
 				$values .= "'{$this->total_contribution}',";
 			}else if($f == 'last_refresh_daily_contribution_time'){
 				$values .= "'{$this->last_refresh_daily_contribution_time}',";
 			}else if($f == 'last_guild_contribution'){
 				$values .= "'{$this->last_guild_contribution}',";
 			}else if($f == 'last_donation_time'){
 				$values .= "'{$this->last_donation_time}',";
 			}else if($f == 'claim_time'){
 				$values .= "'{$this->claim_time}',";
 			}else if($f == 'claim_chest_time'){
 				$values .= "'{$this->claim_chest_time}',";
 			}else if($f == 'claim_chest_num'){
 				$values .= "'{$this->claim_chest_num}',";
 			}else if($f == 'last_guild_id'){
 				$values .= "'{$this->last_guild_id}',";
 			}else if($f == 'worship_last_time'){
 				$values .= "'{$this->worship_last_time}',";
 			}else if($f == 'worship_number'){
 				$values .= "'{$this->worship_number}',";
 			}else if($f == 'worship_uid'){
 				$values .= "'{$this->worship_uid}',";
 			}else if($f == 'worship_reward_number'){
 				$values .= "'{$this->worship_reward_number}',";
 			}else if($f == 'worship_reward_last_time'){
 				$values .= "'{$this->worship_reward_last_time}',";
 			}else if($f == 'worship_reward_claim_time'){
 				$values .= "'{$this->worship_reward_claim_time}',";
 			}else if($f == 'worship_reward_info'){
 				$values .= "'{$this->worship_reward_info}',";
 			}else if($f == 'vitality'){
 				$values .= "'{$this->vitality}',";
 			}else if($f == 'vitality_time'){
 				$values .= "'{$this->vitality_time}',";
 			}else if($f == 'join_time'){
 				$values .= "'{$this->join_time}',";
 			}else if($f == 'stage_max_damage'){
 				$values .= "'{$this->stage_max_damage}',";
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
		if (isset($this->guild_id))
		{
			$fields .= "`guild_id`,";
			$values .= "'{$this->guild_id}',";
		}
		if (isset($this->guild_position))
		{
			$fields .= "`guild_position`,";
			$values .= "'{$this->guild_position}',";
		}
		if (isset($this->last_quit_time))
		{
			$fields .= "`last_quit_time`,";
			$values .= "'{$this->last_quit_time}',";
		}
		if (isset($this->contribution))
		{
			$fields .= "`contribution`,";
			$values .= "'{$this->contribution}',";
		}
		if (isset($this->daily_contribution))
		{
			$fields .= "`daily_contribution`,";
			$values .= "'{$this->daily_contribution}',";
		}
		if (isset($this->total_contribution))
		{
			$fields .= "`total_contribution`,";
			$values .= "'{$this->total_contribution}',";
		}
		if (isset($this->last_refresh_daily_contribution_time))
		{
			$fields .= "`last_refresh_daily_contribution_time`,";
			$values .= "'{$this->last_refresh_daily_contribution_time}',";
		}
		if (isset($this->last_guild_contribution))
		{
			$fields .= "`last_guild_contribution`,";
			$values .= "'{$this->last_guild_contribution}',";
		}
		if (isset($this->last_donation_time))
		{
			$fields .= "`last_donation_time`,";
			$values .= "'{$this->last_donation_time}',";
		}
		if (isset($this->claim_time))
		{
			$fields .= "`claim_time`,";
			$values .= "'{$this->claim_time}',";
		}
		if (isset($this->claim_chest_time))
		{
			$fields .= "`claim_chest_time`,";
			$values .= "'{$this->claim_chest_time}',";
		}
		if (isset($this->claim_chest_num))
		{
			$fields .= "`claim_chest_num`,";
			$values .= "'{$this->claim_chest_num}',";
		}
		if (isset($this->last_guild_id))
		{
			$fields .= "`last_guild_id`,";
			$values .= "'{$this->last_guild_id}',";
		}
		if (isset($this->worship_last_time))
		{
			$fields .= "`worship_last_time`,";
			$values .= "'{$this->worship_last_time}',";
		}
		if (isset($this->worship_number))
		{
			$fields .= "`worship_number`,";
			$values .= "'{$this->worship_number}',";
		}
		if (isset($this->worship_uid))
		{
			$fields .= "`worship_uid`,";
			$values .= "'{$this->worship_uid}',";
		}
		if (isset($this->worship_reward_number))
		{
			$fields .= "`worship_reward_number`,";
			$values .= "'{$this->worship_reward_number}',";
		}
		if (isset($this->worship_reward_last_time))
		{
			$fields .= "`worship_reward_last_time`,";
			$values .= "'{$this->worship_reward_last_time}',";
		}
		if (isset($this->worship_reward_claim_time))
		{
			$fields .= "`worship_reward_claim_time`,";
			$values .= "'{$this->worship_reward_claim_time}',";
		}
		if (isset($this->worship_reward_info))
		{
			$fields .= "`worship_reward_info`,";
			$values .= "'{$this->worship_reward_info}',";
		}
		if (isset($this->vitality))
		{
			$fields .= "`vitality`,";
			$values .= "'{$this->vitality}',";
		}
		if (isset($this->vitality_time))
		{
			$fields .= "`vitality_time`,";
			$values .= "'{$this->vitality_time}',";
		}
		if (isset($this->join_time))
		{
			$fields .= "`join_time`,";
			$values .= "'{$this->join_time}',";
		}
		if (isset($this->stage_max_damage))
		{
			$fields .= "`stage_max_damage`,";
			$values .= "'{$this->stage_max_damage}',";
		}

		
		$fields .= ")";
		$values .= ")";
		
		$sql = "INSERT INTO `player_guild` ".$fields.$values;
		
		return str_replace(",)",")",$sql);
	}
	
	private function  getUpFields()
	{
		$update = "";
		
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
		if ($this->guild_position_status_field)
		{			
			if (!isset($this->guild_position))
			{
				$update .= ("`guild_position`=null,");
			}
			else
			{
				$update .= ("`guild_position`='{$this->guild_position}',");
			}
		}
		if ($this->last_quit_time_status_field)
		{			
			if (!isset($this->last_quit_time))
			{
				$update .= ("`last_quit_time`=null,");
			}
			else
			{
				$update .= ("`last_quit_time`='{$this->last_quit_time}',");
			}
		}
		if ($this->contribution_status_field)
		{			
			if (!isset($this->contribution))
			{
				$update .= ("`contribution`=null,");
			}
			else
			{
				$update .= ("`contribution`='{$this->contribution}',");
			}
		}
		if ($this->daily_contribution_status_field)
		{			
			if (!isset($this->daily_contribution))
			{
				$update .= ("`daily_contribution`=null,");
			}
			else
			{
				$update .= ("`daily_contribution`='{$this->daily_contribution}',");
			}
		}
		if ($this->total_contribution_status_field)
		{			
			if (!isset($this->total_contribution))
			{
				$update .= ("`total_contribution`=null,");
			}
			else
			{
				$update .= ("`total_contribution`='{$this->total_contribution}',");
			}
		}
		if ($this->last_refresh_daily_contribution_time_status_field)
		{			
			if (!isset($this->last_refresh_daily_contribution_time))
			{
				$update .= ("`last_refresh_daily_contribution_time`=null,");
			}
			else
			{
				$update .= ("`last_refresh_daily_contribution_time`='{$this->last_refresh_daily_contribution_time}',");
			}
		}
		if ($this->last_guild_contribution_status_field)
		{			
			if (!isset($this->last_guild_contribution))
			{
				$update .= ("`last_guild_contribution`=null,");
			}
			else
			{
				$update .= ("`last_guild_contribution`='{$this->last_guild_contribution}',");
			}
		}
		if ($this->last_donation_time_status_field)
		{			
			if (!isset($this->last_donation_time))
			{
				$update .= ("`last_donation_time`=null,");
			}
			else
			{
				$update .= ("`last_donation_time`='{$this->last_donation_time}',");
			}
		}
		if ($this->claim_time_status_field)
		{			
			if (!isset($this->claim_time))
			{
				$update .= ("`claim_time`=null,");
			}
			else
			{
				$update .= ("`claim_time`='{$this->claim_time}',");
			}
		}
		if ($this->claim_chest_time_status_field)
		{			
			if (!isset($this->claim_chest_time))
			{
				$update .= ("`claim_chest_time`=null,");
			}
			else
			{
				$update .= ("`claim_chest_time`='{$this->claim_chest_time}',");
			}
		}
		if ($this->claim_chest_num_status_field)
		{			
			if (!isset($this->claim_chest_num))
			{
				$update .= ("`claim_chest_num`=null,");
			}
			else
			{
				$update .= ("`claim_chest_num`='{$this->claim_chest_num}',");
			}
		}
		if ($this->last_guild_id_status_field)
		{			
			if (!isset($this->last_guild_id))
			{
				$update .= ("`last_guild_id`=null,");
			}
			else
			{
				$update .= ("`last_guild_id`='{$this->last_guild_id}',");
			}
		}
		if ($this->worship_last_time_status_field)
		{			
			if (!isset($this->worship_last_time))
			{
				$update .= ("`worship_last_time`=null,");
			}
			else
			{
				$update .= ("`worship_last_time`='{$this->worship_last_time}',");
			}
		}
		if ($this->worship_number_status_field)
		{			
			if (!isset($this->worship_number))
			{
				$update .= ("`worship_number`=null,");
			}
			else
			{
				$update .= ("`worship_number`='{$this->worship_number}',");
			}
		}
		if ($this->worship_uid_status_field)
		{			
			if (!isset($this->worship_uid))
			{
				$update .= ("`worship_uid`=null,");
			}
			else
			{
				$update .= ("`worship_uid`='{$this->worship_uid}',");
			}
		}
		if ($this->worship_reward_number_status_field)
		{			
			if (!isset($this->worship_reward_number))
			{
				$update .= ("`worship_reward_number`=null,");
			}
			else
			{
				$update .= ("`worship_reward_number`='{$this->worship_reward_number}',");
			}
		}
		if ($this->worship_reward_last_time_status_field)
		{			
			if (!isset($this->worship_reward_last_time))
			{
				$update .= ("`worship_reward_last_time`=null,");
			}
			else
			{
				$update .= ("`worship_reward_last_time`='{$this->worship_reward_last_time}',");
			}
		}
		if ($this->worship_reward_claim_time_status_field)
		{			
			if (!isset($this->worship_reward_claim_time))
			{
				$update .= ("`worship_reward_claim_time`=null,");
			}
			else
			{
				$update .= ("`worship_reward_claim_time`='{$this->worship_reward_claim_time}',");
			}
		}
		if ($this->worship_reward_info_status_field)
		{			
			if (!isset($this->worship_reward_info))
			{
				$update .= ("`worship_reward_info`=null,");
			}
			else
			{
				$update .= ("`worship_reward_info`='{$this->worship_reward_info}',");
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
		if ($this->vitality_time_status_field)
		{			
			if (!isset($this->vitality_time))
			{
				$update .= ("`vitality_time`=null,");
			}
			else
			{
				$update .= ("`vitality_time`='{$this->vitality_time}',");
			}
		}
		if ($this->join_time_status_field)
		{			
			if (!isset($this->join_time))
			{
				$update .= ("`join_time`=null,");
			}
			else
			{
				$update .= ("`join_time`='{$this->join_time}',");
			}
		}
		if ($this->stage_max_damage_status_field)
		{			
			if (!isset($this->stage_max_damage))
			{
				$update .= ("`stage_max_damage`=null,");
			}
			else
			{
				$update .= ("`stage_max_damage`='{$this->stage_max_damage}',");
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
		
		$sql = "UPDATE `player_guild` SET {$update} WHERE {$condition}";
		
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
		
		$sql = "UPDATE `player_guild` SET {$update} WHERE {$uc}";
		
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
		
		$sql = "UPDATE `player_guild` SET {$update} WHERE {$uc}";
		
		if(isset($this->user_id)){MySQL::selectDbForUser($this->user_id);}else{MySQL::selectDbForUser($GLOBALS['USER_ID']);}
		$qr = MySQL::getInstance()->RunQuery($sql);
				
		return (boolean)$qr;
	}
	
	private function /*void*/ clean() 
	{
		$this->this_table_status_field = false;
		$this->user_id_status_field = false;
		$this->guild_id_status_field = false;
		$this->guild_position_status_field = false;
		$this->last_quit_time_status_field = false;
		$this->contribution_status_field = false;
		$this->daily_contribution_status_field = false;
		$this->total_contribution_status_field = false;
		$this->last_refresh_daily_contribution_time_status_field = false;
		$this->last_guild_contribution_status_field = false;
		$this->last_donation_time_status_field = false;
		$this->claim_time_status_field = false;
		$this->claim_chest_time_status_field = false;
		$this->claim_chest_num_status_field = false;
		$this->last_guild_id_status_field = false;
		$this->worship_last_time_status_field = false;
		$this->worship_number_status_field = false;
		$this->worship_uid_status_field = false;
		$this->worship_reward_number_status_field = false;
		$this->worship_reward_last_time_status_field = false;
		$this->worship_reward_claim_time_status_field = false;
		$this->worship_reward_info_status_field = false;
		$this->vitality_status_field = false;
		$this->vitality_time_status_field = false;
		$this->join_time_status_field = false;
		$this->stage_max_damage_status_field = false;

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

	public function /*int*/ getGuildPosition()
	{
		return $this->guild_position;
	}
	
	public function /*void*/ setGuildPosition(/*int*/ $guild_position)
	{
		$this->guild_position = intval($guild_position);
		$this->guild_position_status_field = true;		
		$this->this_table_status_field = true;		
	}

	public function /*void*/ setGuildPositionNull()
	{
		$this->guild_position = null;
		$this->guild_position_status_field = true;		
		$this->this_table_status_field = true;
	}

	public function /*int*/ getLastQuitTime()
	{
		return $this->last_quit_time;
	}
	
	public function /*void*/ setLastQuitTime(/*int*/ $last_quit_time)
	{
		$this->last_quit_time = intval($last_quit_time);
		$this->last_quit_time_status_field = true;		
		$this->this_table_status_field = true;		
	}

	public function /*void*/ setLastQuitTimeNull()
	{
		$this->last_quit_time = null;
		$this->last_quit_time_status_field = true;		
		$this->this_table_status_field = true;
	}

	public function /*int*/ getContribution()
	{
		return $this->contribution;
	}
	
	public function /*void*/ setContribution(/*int*/ $contribution)
	{
		$this->contribution = intval($contribution);
		$this->contribution_status_field = true;		
		$this->this_table_status_field = true;		
	}

	public function /*void*/ setContributionNull()
	{
		$this->contribution = null;
		$this->contribution_status_field = true;		
		$this->this_table_status_field = true;
	}

	public function /*int*/ getDailyContribution()
	{
		return $this->daily_contribution;
	}
	
	public function /*void*/ setDailyContribution(/*int*/ $daily_contribution)
	{
		$this->daily_contribution = intval($daily_contribution);
		$this->daily_contribution_status_field = true;		
		$this->this_table_status_field = true;		
	}

	public function /*void*/ setDailyContributionNull()
	{
		$this->daily_contribution = null;
		$this->daily_contribution_status_field = true;		
		$this->this_table_status_field = true;
	}

	public function /*int*/ getTotalContribution()
	{
		return $this->total_contribution;
	}
	
	public function /*void*/ setTotalContribution(/*int*/ $total_contribution)
	{
		$this->total_contribution = intval($total_contribution);
		$this->total_contribution_status_field = true;		
		$this->this_table_status_field = true;		
	}

	public function /*void*/ setTotalContributionNull()
	{
		$this->total_contribution = null;
		$this->total_contribution_status_field = true;		
		$this->this_table_status_field = true;
	}

	public function /*int*/ getLastRefreshDailyContributionTime()
	{
		return $this->last_refresh_daily_contribution_time;
	}
	
	public function /*void*/ setLastRefreshDailyContributionTime(/*int*/ $last_refresh_daily_contribution_time)
	{
		$this->last_refresh_daily_contribution_time = intval($last_refresh_daily_contribution_time);
		$this->last_refresh_daily_contribution_time_status_field = true;		
		$this->this_table_status_field = true;		
	}

	public function /*void*/ setLastRefreshDailyContributionTimeNull()
	{
		$this->last_refresh_daily_contribution_time = null;
		$this->last_refresh_daily_contribution_time_status_field = true;		
		$this->this_table_status_field = true;
	}

	public function /*int*/ getLastGuildContribution()
	{
		return $this->last_guild_contribution;
	}
	
	public function /*void*/ setLastGuildContribution(/*int*/ $last_guild_contribution)
	{
		$this->last_guild_contribution = intval($last_guild_contribution);
		$this->last_guild_contribution_status_field = true;		
		$this->this_table_status_field = true;		
	}

	public function /*void*/ setLastGuildContributionNull()
	{
		$this->last_guild_contribution = null;
		$this->last_guild_contribution_status_field = true;		
		$this->this_table_status_field = true;
	}

	public function /*int*/ getLastDonationTime()
	{
		return $this->last_donation_time;
	}
	
	public function /*void*/ setLastDonationTime(/*int*/ $last_donation_time)
	{
		$this->last_donation_time = intval($last_donation_time);
		$this->last_donation_time_status_field = true;		
		$this->this_table_status_field = true;		
	}

	public function /*void*/ setLastDonationTimeNull()
	{
		$this->last_donation_time = null;
		$this->last_donation_time_status_field = true;		
		$this->this_table_status_field = true;
	}

	public function /*int*/ getClaimTime()
	{
		return $this->claim_time;
	}
	
	public function /*void*/ setClaimTime(/*int*/ $claim_time)
	{
		$this->claim_time = intval($claim_time);
		$this->claim_time_status_field = true;		
		$this->this_table_status_field = true;		
	}

	public function /*void*/ setClaimTimeNull()
	{
		$this->claim_time = null;
		$this->claim_time_status_field = true;		
		$this->this_table_status_field = true;
	}

	public function /*int*/ getClaimChestTime()
	{
		return $this->claim_chest_time;
	}
	
	public function /*void*/ setClaimChestTime(/*int*/ $claim_chest_time)
	{
		$this->claim_chest_time = intval($claim_chest_time);
		$this->claim_chest_time_status_field = true;		
		$this->this_table_status_field = true;		
	}

	public function /*void*/ setClaimChestTimeNull()
	{
		$this->claim_chest_time = null;
		$this->claim_chest_time_status_field = true;		
		$this->this_table_status_field = true;
	}

	public function /*int*/ getClaimChestNum()
	{
		return $this->claim_chest_num;
	}
	
	public function /*void*/ setClaimChestNum(/*int*/ $claim_chest_num)
	{
		$this->claim_chest_num = intval($claim_chest_num);
		$this->claim_chest_num_status_field = true;		
		$this->this_table_status_field = true;		
	}

	public function /*void*/ setClaimChestNumNull()
	{
		$this->claim_chest_num = null;
		$this->claim_chest_num_status_field = true;		
		$this->this_table_status_field = true;
	}

	public function /*string*/ getLastGuildId()
	{
		return $this->last_guild_id;
	}
	
	public function /*void*/ setLastGuildId(/*string*/ $last_guild_id)
	{
		$this->last_guild_id = SQLUtil::toSafeSQLString($last_guild_id);
		$this->last_guild_id_status_field = true;		
		$this->this_table_status_field = true;		
	}

	public function /*void*/ setLastGuildIdNull()
	{
		$this->last_guild_id = null;
		$this->last_guild_id_status_field = true;		
		$this->this_table_status_field = true;
	}

	public function /*int*/ getWorshipLastTime()
	{
		return $this->worship_last_time;
	}
	
	public function /*void*/ setWorshipLastTime(/*int*/ $worship_last_time)
	{
		$this->worship_last_time = intval($worship_last_time);
		$this->worship_last_time_status_field = true;		
		$this->this_table_status_field = true;		
	}

	public function /*void*/ setWorshipLastTimeNull()
	{
		$this->worship_last_time = null;
		$this->worship_last_time_status_field = true;		
		$this->this_table_status_field = true;
	}

	public function /*int*/ getWorshipNumber()
	{
		return $this->worship_number;
	}
	
	public function /*void*/ setWorshipNumber(/*int*/ $worship_number)
	{
		$this->worship_number = intval($worship_number);
		$this->worship_number_status_field = true;		
		$this->this_table_status_field = true;		
	}

	public function /*void*/ setWorshipNumberNull()
	{
		$this->worship_number = null;
		$this->worship_number_status_field = true;		
		$this->this_table_status_field = true;
	}

	public function /*string*/ getWorshipUid()
	{
		return $this->worship_uid;
	}
	
	public function /*void*/ setWorshipUid(/*string*/ $worship_uid)
	{
		$this->worship_uid = SQLUtil::toSafeSQLString($worship_uid);
		$this->worship_uid_status_field = true;		
		$this->this_table_status_field = true;		
	}

	public function /*void*/ setWorshipUidNull()
	{
		$this->worship_uid = null;
		$this->worship_uid_status_field = true;		
		$this->this_table_status_field = true;
	}

	public function /*int*/ getWorshipRewardNumber()
	{
		return $this->worship_reward_number;
	}
	
	public function /*void*/ setWorshipRewardNumber(/*int*/ $worship_reward_number)
	{
		$this->worship_reward_number = intval($worship_reward_number);
		$this->worship_reward_number_status_field = true;		
		$this->this_table_status_field = true;		
	}

	public function /*void*/ setWorshipRewardNumberNull()
	{
		$this->worship_reward_number = null;
		$this->worship_reward_number_status_field = true;		
		$this->this_table_status_field = true;
	}

	public function /*int*/ getWorshipRewardLastTime()
	{
		return $this->worship_reward_last_time;
	}
	
	public function /*void*/ setWorshipRewardLastTime(/*int*/ $worship_reward_last_time)
	{
		$this->worship_reward_last_time = intval($worship_reward_last_time);
		$this->worship_reward_last_time_status_field = true;		
		$this->this_table_status_field = true;		
	}

	public function /*void*/ setWorshipRewardLastTimeNull()
	{
		$this->worship_reward_last_time = null;
		$this->worship_reward_last_time_status_field = true;		
		$this->this_table_status_field = true;
	}

	public function /*int*/ getWorshipRewardClaimTime()
	{
		return $this->worship_reward_claim_time;
	}
	
	public function /*void*/ setWorshipRewardClaimTime(/*int*/ $worship_reward_claim_time)
	{
		$this->worship_reward_claim_time = intval($worship_reward_claim_time);
		$this->worship_reward_claim_time_status_field = true;		
		$this->this_table_status_field = true;		
	}

	public function /*void*/ setWorshipRewardClaimTimeNull()
	{
		$this->worship_reward_claim_time = null;
		$this->worship_reward_claim_time_status_field = true;		
		$this->this_table_status_field = true;
	}

	public function /*string*/ getWorshipRewardInfo()
	{
		return $this->worship_reward_info;
	}
	
	public function /*void*/ setWorshipRewardInfo(/*string*/ $worship_reward_info)
	{
		$this->worship_reward_info = SQLUtil::toSafeSQLString($worship_reward_info);
		$this->worship_reward_info_status_field = true;		
		$this->this_table_status_field = true;		
	}

	public function /*void*/ setWorshipRewardInfoNull()
	{
		$this->worship_reward_info = null;
		$this->worship_reward_info_status_field = true;		
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

	public function /*int*/ getVitalityTime()
	{
		return $this->vitality_time;
	}
	
	public function /*void*/ setVitalityTime(/*int*/ $vitality_time)
	{
		$this->vitality_time = intval($vitality_time);
		$this->vitality_time_status_field = true;		
		$this->this_table_status_field = true;		
	}

	public function /*void*/ setVitalityTimeNull()
	{
		$this->vitality_time = null;
		$this->vitality_time_status_field = true;		
		$this->this_table_status_field = true;
	}

	public function /*int*/ getJoinTime()
	{
		return $this->join_time;
	}
	
	public function /*void*/ setJoinTime(/*int*/ $join_time)
	{
		$this->join_time = intval($join_time);
		$this->join_time_status_field = true;		
		$this->this_table_status_field = true;		
	}

	public function /*void*/ setJoinTimeNull()
	{
		$this->join_time = null;
		$this->join_time_status_field = true;		
		$this->this_table_status_field = true;
	}

	public function /*int*/ getStageMaxDamage()
	{
		return $this->stage_max_damage;
	}
	
	public function /*void*/ setStageMaxDamage(/*int*/ $stage_max_damage)
	{
		$this->stage_max_damage = intval($stage_max_damage);
		$this->stage_max_damage_status_field = true;		
		$this->this_table_status_field = true;		
	}

	public function /*void*/ setStageMaxDamageNull()
	{
		$this->stage_max_damage = null;
		$this->stage_max_damage_status_field = true;		
		$this->this_table_status_field = true;
	}

	
	public function /*string*/ toDebugString()
	{
		$dbg = "(";
		
		$dbg .= ("user_id={$this->user_id},");
		$dbg .= ("guild_id={$this->guild_id},");
		$dbg .= ("guild_position={$this->guild_position},");
		$dbg .= ("last_quit_time={$this->last_quit_time},");
		$dbg .= ("contribution={$this->contribution},");
		$dbg .= ("daily_contribution={$this->daily_contribution},");
		$dbg .= ("total_contribution={$this->total_contribution},");
		$dbg .= ("last_refresh_daily_contribution_time={$this->last_refresh_daily_contribution_time},");
		$dbg .= ("last_guild_contribution={$this->last_guild_contribution},");
		$dbg .= ("last_donation_time={$this->last_donation_time},");
		$dbg .= ("claim_time={$this->claim_time},");
		$dbg .= ("claim_chest_time={$this->claim_chest_time},");
		$dbg .= ("claim_chest_num={$this->claim_chest_num},");
		$dbg .= ("last_guild_id={$this->last_guild_id},");
		$dbg .= ("worship_last_time={$this->worship_last_time},");
		$dbg .= ("worship_number={$this->worship_number},");
		$dbg .= ("worship_uid={$this->worship_uid},");
		$dbg .= ("worship_reward_number={$this->worship_reward_number},");
		$dbg .= ("worship_reward_last_time={$this->worship_reward_last_time},");
		$dbg .= ("worship_reward_claim_time={$this->worship_reward_claim_time},");
		$dbg .= ("worship_reward_info={$this->worship_reward_info},");
		$dbg .= ("vitality={$this->vitality},");
		$dbg .= ("vitality_time={$this->vitality_time},");
		$dbg .= ("join_time={$this->join_time},");
		$dbg .= ("stage_max_damage={$this->stage_max_damage},");

		$dbg .= ")";
				
		return str_replace(",)",")",$dbg);
	}
}

?>
