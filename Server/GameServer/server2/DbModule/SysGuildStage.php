<?php
require_once ($GLOBALS ['GAME_ROOT'] . "CMySQL.php");
require_once ("SQLUtil.php");
/**
 *  [The generated files]
 */

class SysGuildStage {
	
	private /*string*/ $id; //PRIMARY KEY 
	private /*int*/ $server_id;
	private /*string*/ $guild_id;
	private /*int*/ $raid_id;
	private /*int*/ $stage_id;
	private /*int*/ $wave_index;
	private /*int*/ $begin_time;
	private /*string*/ $challenger;
	private /*int*/ $challenger_begin_time;
	private /*int*/ $challenger_status;
	private /*string*/ $detail;
	private /*int*/ $progress;
	private /*int*/ $stage_progress;
	private /*int*/ $first_pass_timestamp;
	private /*int*/ $fast_pass_time;
	private /*string*/ $loot;
	private /*string*/ $special_loot;
	private /*string*/ $special_get;

	
	private $this_table_status_field = false;
	private $id_status_field = false;
	private $server_id_status_field = false;
	private $guild_id_status_field = false;
	private $raid_id_status_field = false;
	private $stage_id_status_field = false;
	private $wave_index_status_field = false;
	private $begin_time_status_field = false;
	private $challenger_status_field = false;
	private $challenger_begin_time_status_field = false;
	private $challenger_status_status_field = false;
	private $detail_status_field = false;
	private $progress_status_field = false;
	private $stage_progress_status_field = false;
	private $first_pass_timestamp_status_field = false;
	private $fast_pass_time_status_field = false;
	private $loot_status_field = false;
	private $special_loot_status_field = false;
	private $special_get_status_field = false;


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
			$sql = "SELECT {$p} FROM `guild_stage`";
		}
		else
		{			
			$sql = "SELECT {$p} FROM `guild_stage` WHERE ".SQLUtil::parseCondition($condition);
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
			$tb = new SysGuildStage();			
			if (isset($row['id'])) $tb->id = $row['id'];
			if (isset($row['server_id'])) $tb->server_id = intval($row['server_id']);
			if (isset($row['guild_id'])) $tb->guild_id = $row['guild_id'];
			if (isset($row['raid_id'])) $tb->raid_id = intval($row['raid_id']);
			if (isset($row['stage_id'])) $tb->stage_id = intval($row['stage_id']);
			if (isset($row['wave_index'])) $tb->wave_index = intval($row['wave_index']);
			if (isset($row['begin_time'])) $tb->begin_time = intval($row['begin_time']);
			if (isset($row['challenger'])) $tb->challenger = $row['challenger'];
			if (isset($row['challenger_begin_time'])) $tb->challenger_begin_time = intval($row['challenger_begin_time']);
			if (isset($row['challenger_status'])) $tb->challenger_status = intval($row['challenger_status']);
			if (isset($row['detail'])) $tb->detail = $row['detail'];
			if (isset($row['progress'])) $tb->progress = intval($row['progress']);
			if (isset($row['stage_progress'])) $tb->stage_progress = intval($row['stage_progress']);
			if (isset($row['first_pass_timestamp'])) $tb->first_pass_timestamp = intval($row['first_pass_timestamp']);
			if (isset($row['fast_pass_time'])) $tb->fast_pass_time = intval($row['fast_pass_time']);
			if (isset($row['loot'])) $tb->loot = $row['loot'];
			if (isset($row['special_loot'])) $tb->special_loot = $row['special_loot'];
			if (isset($row['special_get'])) $tb->special_get = $row['special_get'];
		
			$result[] = $tb;
		}
		
		return $result;
	}	
	
	public static function insertSqlHeader($fields=NULL)
	{
		$result = array();				
		if(!empty($fields)){
			$where = SQLUtil::parseFields($fields);			
			$result[0] = "INSERT INTO `guild_stage` ({$where}) VALUES ";	
			$ar = array();
			foreach($fields as $key){
				$ar[$key]=1;
			}
			$result[1] = $ar;
		}else{
			$result[0]="INSERT INTO `guild_stage` (`id`,`server_id`,`guild_id`,`raid_id`,`stage_id`,`wave_index`,`begin_time`,`challenger`,`challenger_begin_time`,`challenger_status`,`detail`,`progress`,`stage_progress`,`first_pass_timestamp`,`fast_pass_time`,`loot`,`special_loot`,`special_get`) VALUES ";
			$result[1] = array('id'=>1,'server_id'=>1,'guild_id'=>1,'raid_id'=>1,'stage_id'=>1,'wave_index'=>1,'begin_time'=>1,'challenger'=>1,'challenger_begin_time'=>1,'challenger_status'=>1,'detail'=>1,'progress'=>1,'stage_progress'=>1,'first_pass_timestamp'=>1,'fast_pass_time'=>1,'loot'=>1,'special_loot'=>1,'special_get'=>1);
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
		
		$sql = "SELECT {$p} FROM `guild_stage` WHERE {$where}";

		MySQL::selectDefaultDb();
		$qr = MySQL::getInstance()->RunQuery($sql);
		$ar = MySQL::getInstance()->FetchArray($qr);
		
		if (!$ar || count($ar)==0)
		{
			return false;
		}
		
		if (isset($ar['id'])) $this->id = $ar['id'];
		if (isset($ar['server_id'])) $this->server_id = intval($ar['server_id']);
		if (isset($ar['guild_id'])) $this->guild_id = $ar['guild_id'];
		if (isset($ar['raid_id'])) $this->raid_id = intval($ar['raid_id']);
		if (isset($ar['stage_id'])) $this->stage_id = intval($ar['stage_id']);
		if (isset($ar['wave_index'])) $this->wave_index = intval($ar['wave_index']);
		if (isset($ar['begin_time'])) $this->begin_time = intval($ar['begin_time']);
		if (isset($ar['challenger'])) $this->challenger = $ar['challenger'];
		if (isset($ar['challenger_begin_time'])) $this->challenger_begin_time = intval($ar['challenger_begin_time']);
		if (isset($ar['challenger_status'])) $this->challenger_status = intval($ar['challenger_status']);
		if (isset($ar['detail'])) $this->detail = $ar['detail'];
		if (isset($ar['progress'])) $this->progress = intval($ar['progress']);
		if (isset($ar['stage_progress'])) $this->stage_progress = intval($ar['stage_progress']);
		if (isset($ar['first_pass_timestamp'])) $this->first_pass_timestamp = intval($ar['first_pass_timestamp']);
		if (isset($ar['fast_pass_time'])) $this->fast_pass_time = intval($ar['fast_pass_time']);
		if (isset($ar['loot'])) $this->loot = $ar['loot'];
		if (isset($ar['special_loot'])) $this->special_loot = $ar['special_loot'];
		if (isset($ar['special_get'])) $this->special_get = $ar['special_get'];
		
		
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
	
		$sql = "SELECT {$p} FROM `guild_stage` WHERE {$where}";
	
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
    	if (!isset($this->begin_time)){
    		$emptyFields = false;
    		$fields[] = 'begin_time';
    	}else{
    		$emptyCondition = false; 
    		$condition['begin_time']=$this->begin_time;
    	}
    	if (!isset($this->challenger)){
    		$emptyFields = false;
    		$fields[] = 'challenger';
    	}else{
    		$emptyCondition = false; 
    		$condition['challenger']=$this->challenger;
    	}
    	if (!isset($this->challenger_begin_time)){
    		$emptyFields = false;
    		$fields[] = 'challenger_begin_time';
    	}else{
    		$emptyCondition = false; 
    		$condition['challenger_begin_time']=$this->challenger_begin_time;
    	}
    	if (!isset($this->challenger_status)){
    		$emptyFields = false;
    		$fields[] = 'challenger_status';
    	}else{
    		$emptyCondition = false; 
    		$condition['challenger_status']=$this->challenger_status;
    	}
    	if (!isset($this->detail)){
    		$emptyFields = false;
    		$fields[] = 'detail';
    	}else{
    		$emptyCondition = false; 
    		$condition['detail']=$this->detail;
    	}
    	if (!isset($this->progress)){
    		$emptyFields = false;
    		$fields[] = 'progress';
    	}else{
    		$emptyCondition = false; 
    		$condition['progress']=$this->progress;
    	}
    	if (!isset($this->stage_progress)){
    		$emptyFields = false;
    		$fields[] = 'stage_progress';
    	}else{
    		$emptyCondition = false; 
    		$condition['stage_progress']=$this->stage_progress;
    	}
    	if (!isset($this->first_pass_timestamp)){
    		$emptyFields = false;
    		$fields[] = 'first_pass_timestamp';
    	}else{
    		$emptyCondition = false; 
    		$condition['first_pass_timestamp']=$this->first_pass_timestamp;
    	}
    	if (!isset($this->fast_pass_time)){
    		$emptyFields = false;
    		$fields[] = 'fast_pass_time';
    	}else{
    		$emptyCondition = false; 
    		$condition['fast_pass_time']=$this->fast_pass_time;
    	}
    	if (!isset($this->loot)){
    		$emptyFields = false;
    		$fields[] = 'loot';
    	}else{
    		$emptyCondition = false; 
    		$condition['loot']=$this->loot;
    	}
    	if (!isset($this->special_loot)){
    		$emptyFields = false;
    		$fields[] = 'special_loot';
    	}else{
    		$emptyCondition = false; 
    		$condition['special_loot']=$this->special_loot;
    	}
    	if (!isset($this->special_get)){
    		$emptyFields = false;
    		$fields[] = 'special_get';
    	}else{
    		$emptyCondition = false; 
    		$condition['special_get']=$this->special_get;
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
		
		$sql = "DELETE FROM `guild_stage` WHERE ".SQLUtil::parseCondition($condition);
		
		$qr = MySQL::getInstance()->RunQuery($sql);
				
		return (boolean)$qr;
	}
	
	public function  delete()
	{
		if (!isset($this->id))
		{
			return false;
		}
		
		$sql = "DELETE FROM `guild_stage` WHERE `id`='{$this->id}'";
		
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
 			}else if($f == 'server_id'){
 				$values .= "'{$this->server_id}',";
 			}else if($f == 'guild_id'){
 				$values .= "'{$this->guild_id}',";
 			}else if($f == 'raid_id'){
 				$values .= "'{$this->raid_id}',";
 			}else if($f == 'stage_id'){
 				$values .= "'{$this->stage_id}',";
 			}else if($f == 'wave_index'){
 				$values .= "'{$this->wave_index}',";
 			}else if($f == 'begin_time'){
 				$values .= "'{$this->begin_time}',";
 			}else if($f == 'challenger'){
 				$values .= "'{$this->challenger}',";
 			}else if($f == 'challenger_begin_time'){
 				$values .= "'{$this->challenger_begin_time}',";
 			}else if($f == 'challenger_status'){
 				$values .= "'{$this->challenger_status}',";
 			}else if($f == 'detail'){
 				$values .= "'{$this->detail}',";
 			}else if($f == 'progress'){
 				$values .= "'{$this->progress}',";
 			}else if($f == 'stage_progress'){
 				$values .= "'{$this->stage_progress}',";
 			}else if($f == 'first_pass_timestamp'){
 				$values .= "'{$this->first_pass_timestamp}',";
 			}else if($f == 'fast_pass_time'){
 				$values .= "'{$this->fast_pass_time}',";
 			}else if($f == 'loot'){
 				$values .= "'{$this->loot}',";
 			}else if($f == 'special_loot'){
 				$values .= "'{$this->special_loot}',";
 			}else if($f == 'special_get'){
 				$values .= "'{$this->special_get}',";
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
		if (isset($this->begin_time))
		{
			$fields .= "`begin_time`,";
			$values .= "'{$this->begin_time}',";
		}
		if (isset($this->challenger))
		{
			$fields .= "`challenger`,";
			$values .= "'{$this->challenger}',";
		}
		if (isset($this->challenger_begin_time))
		{
			$fields .= "`challenger_begin_time`,";
			$values .= "'{$this->challenger_begin_time}',";
		}
		if (isset($this->challenger_status))
		{
			$fields .= "`challenger_status`,";
			$values .= "'{$this->challenger_status}',";
		}
		if (isset($this->detail))
		{
			$fields .= "`detail`,";
			$values .= "'{$this->detail}',";
		}
		if (isset($this->progress))
		{
			$fields .= "`progress`,";
			$values .= "'{$this->progress}',";
		}
		if (isset($this->stage_progress))
		{
			$fields .= "`stage_progress`,";
			$values .= "'{$this->stage_progress}',";
		}
		if (isset($this->first_pass_timestamp))
		{
			$fields .= "`first_pass_timestamp`,";
			$values .= "'{$this->first_pass_timestamp}',";
		}
		if (isset($this->fast_pass_time))
		{
			$fields .= "`fast_pass_time`,";
			$values .= "'{$this->fast_pass_time}',";
		}
		if (isset($this->loot))
		{
			$fields .= "`loot`,";
			$values .= "'{$this->loot}',";
		}
		if (isset($this->special_loot))
		{
			$fields .= "`special_loot`,";
			$values .= "'{$this->special_loot}',";
		}
		if (isset($this->special_get))
		{
			$fields .= "`special_get`,";
			$values .= "'{$this->special_get}',";
		}

		
		$fields .= ")";
		$values .= ")";
		
		$sql = "INSERT INTO `guild_stage` ".$fields.$values;
		
		return str_replace(",)",")",$sql);
	}
	
	private function  getUpFields()
	{
		$update = "";
		
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
		if ($this->begin_time_status_field)
		{			
			if (!isset($this->begin_time))
			{
				$update .= ("`begin_time`=null,");
			}
			else
			{
				$update .= ("`begin_time`='{$this->begin_time}',");
			}
		}
		if ($this->challenger_status_field)
		{			
			if (!isset($this->challenger))
			{
				$update .= ("`challenger`=null,");
			}
			else
			{
				$update .= ("`challenger`='{$this->challenger}',");
			}
		}
		if ($this->challenger_begin_time_status_field)
		{			
			if (!isset($this->challenger_begin_time))
			{
				$update .= ("`challenger_begin_time`=null,");
			}
			else
			{
				$update .= ("`challenger_begin_time`='{$this->challenger_begin_time}',");
			}
		}
		if ($this->challenger_status_status_field)
		{			
			if (!isset($this->challenger_status))
			{
				$update .= ("`challenger_status`=null,");
			}
			else
			{
				$update .= ("`challenger_status`='{$this->challenger_status}',");
			}
		}
		if ($this->detail_status_field)
		{			
			if (!isset($this->detail))
			{
				$update .= ("`detail`=null,");
			}
			else
			{
				$update .= ("`detail`='{$this->detail}',");
			}
		}
		if ($this->progress_status_field)
		{			
			if (!isset($this->progress))
			{
				$update .= ("`progress`=null,");
			}
			else
			{
				$update .= ("`progress`='{$this->progress}',");
			}
		}
		if ($this->stage_progress_status_field)
		{			
			if (!isset($this->stage_progress))
			{
				$update .= ("`stage_progress`=null,");
			}
			else
			{
				$update .= ("`stage_progress`='{$this->stage_progress}',");
			}
		}
		if ($this->first_pass_timestamp_status_field)
		{			
			if (!isset($this->first_pass_timestamp))
			{
				$update .= ("`first_pass_timestamp`=null,");
			}
			else
			{
				$update .= ("`first_pass_timestamp`='{$this->first_pass_timestamp}',");
			}
		}
		if ($this->fast_pass_time_status_field)
		{			
			if (!isset($this->fast_pass_time))
			{
				$update .= ("`fast_pass_time`=null,");
			}
			else
			{
				$update .= ("`fast_pass_time`='{$this->fast_pass_time}',");
			}
		}
		if ($this->loot_status_field)
		{			
			if (!isset($this->loot))
			{
				$update .= ("`loot`=null,");
			}
			else
			{
				$update .= ("`loot`='{$this->loot}',");
			}
		}
		if ($this->special_loot_status_field)
		{			
			if (!isset($this->special_loot))
			{
				$update .= ("`special_loot`=null,");
			}
			else
			{
				$update .= ("`special_loot`='{$this->special_loot}',");
			}
		}
		if ($this->special_get_status_field)
		{			
			if (!isset($this->special_get))
			{
				$update .= ("`special_get`=null,");
			}
			else
			{
				$update .= ("`special_get`='{$this->special_get}',");
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
		
		$sql = "UPDATE `guild_stage` SET {$update} WHERE {$condition}";
		
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
		
		$sql = "UPDATE `guild_stage` SET {$update} WHERE {$uc}";
		
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
		
		$sql = "UPDATE `guild_stage` SET {$update} WHERE {$uc}";
		
		MySQL::selectDefaultDb();
		$qr = MySQL::getInstance()->RunQuery($sql);
				
		return (boolean)$qr;
	}
	
	private function /*void*/ clean() 
	{
		$this->this_table_status_field = false;
		$this->id_status_field = false;
		$this->server_id_status_field = false;
		$this->guild_id_status_field = false;
		$this->raid_id_status_field = false;
		$this->stage_id_status_field = false;
		$this->wave_index_status_field = false;
		$this->begin_time_status_field = false;
		$this->challenger_status_field = false;
		$this->challenger_begin_time_status_field = false;
		$this->challenger_status_status_field = false;
		$this->detail_status_field = false;
		$this->progress_status_field = false;
		$this->stage_progress_status_field = false;
		$this->first_pass_timestamp_status_field = false;
		$this->fast_pass_time_status_field = false;
		$this->loot_status_field = false;
		$this->special_loot_status_field = false;
		$this->special_get_status_field = false;

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

	public function /*int*/ getBeginTime()
	{
		return $this->begin_time;
	}
	
	public function /*void*/ setBeginTime(/*int*/ $begin_time)
	{
		$this->begin_time = intval($begin_time);
		$this->begin_time_status_field = true;		
		$this->this_table_status_field = true;		
	}

	public function /*void*/ setBeginTimeNull()
	{
		$this->begin_time = null;
		$this->begin_time_status_field = true;		
		$this->this_table_status_field = true;
	}

	public function /*string*/ getChallenger()
	{
		return $this->challenger;
	}
	
	public function /*void*/ setChallenger(/*string*/ $challenger)
	{
		$this->challenger = SQLUtil::toSafeSQLString($challenger);
		$this->challenger_status_field = true;		
		$this->this_table_status_field = true;		
	}

	public function /*void*/ setChallengerNull()
	{
		$this->challenger = null;
		$this->challenger_status_field = true;		
		$this->this_table_status_field = true;
	}

	public function /*int*/ getChallengerBeginTime()
	{
		return $this->challenger_begin_time;
	}
	
	public function /*void*/ setChallengerBeginTime(/*int*/ $challenger_begin_time)
	{
		$this->challenger_begin_time = intval($challenger_begin_time);
		$this->challenger_begin_time_status_field = true;		
		$this->this_table_status_field = true;		
	}

	public function /*void*/ setChallengerBeginTimeNull()
	{
		$this->challenger_begin_time = null;
		$this->challenger_begin_time_status_field = true;		
		$this->this_table_status_field = true;
	}

	public function /*int*/ getChallengerStatus()
	{
		return $this->challenger_status;
	}
	
	public function /*void*/ setChallengerStatus(/*int*/ $challenger_status)
	{
		$this->challenger_status = intval($challenger_status);
		$this->challenger_status_status_field = true;		
		$this->this_table_status_field = true;		
	}

	public function /*void*/ setChallengerStatusNull()
	{
		$this->challenger_status = null;
		$this->challenger_status_status_field = true;		
		$this->this_table_status_field = true;
	}

	public function /*string*/ getDetail()
	{
		return $this->detail;
	}
	
	public function /*void*/ setDetail(/*string*/ $detail)
	{
		$this->detail = SQLUtil::toSafeSQLString($detail);
		$this->detail_status_field = true;		
		$this->this_table_status_field = true;		
	}

	public function /*void*/ setDetailNull()
	{
		$this->detail = null;
		$this->detail_status_field = true;		
		$this->this_table_status_field = true;
	}

	public function /*int*/ getProgress()
	{
		return $this->progress;
	}
	
	public function /*void*/ setProgress(/*int*/ $progress)
	{
		$this->progress = intval($progress);
		$this->progress_status_field = true;		
		$this->this_table_status_field = true;		
	}

	public function /*void*/ setProgressNull()
	{
		$this->progress = null;
		$this->progress_status_field = true;		
		$this->this_table_status_field = true;
	}

	public function /*int*/ getStageProgress()
	{
		return $this->stage_progress;
	}
	
	public function /*void*/ setStageProgress(/*int*/ $stage_progress)
	{
		$this->stage_progress = intval($stage_progress);
		$this->stage_progress_status_field = true;		
		$this->this_table_status_field = true;		
	}

	public function /*void*/ setStageProgressNull()
	{
		$this->stage_progress = null;
		$this->stage_progress_status_field = true;		
		$this->this_table_status_field = true;
	}

	public function /*int*/ getFirstPassTimestamp()
	{
		return $this->first_pass_timestamp;
	}
	
	public function /*void*/ setFirstPassTimestamp(/*int*/ $first_pass_timestamp)
	{
		$this->first_pass_timestamp = intval($first_pass_timestamp);
		$this->first_pass_timestamp_status_field = true;		
		$this->this_table_status_field = true;		
	}

	public function /*void*/ setFirstPassTimestampNull()
	{
		$this->first_pass_timestamp = null;
		$this->first_pass_timestamp_status_field = true;		
		$this->this_table_status_field = true;
	}

	public function /*int*/ getFastPassTime()
	{
		return $this->fast_pass_time;
	}
	
	public function /*void*/ setFastPassTime(/*int*/ $fast_pass_time)
	{
		$this->fast_pass_time = intval($fast_pass_time);
		$this->fast_pass_time_status_field = true;		
		$this->this_table_status_field = true;		
	}

	public function /*void*/ setFastPassTimeNull()
	{
		$this->fast_pass_time = null;
		$this->fast_pass_time_status_field = true;		
		$this->this_table_status_field = true;
	}

	public function /*string*/ getLoot()
	{
		return $this->loot;
	}
	
	public function /*void*/ setLoot(/*string*/ $loot)
	{
		$this->loot = SQLUtil::toSafeSQLString($loot);
		$this->loot_status_field = true;		
		$this->this_table_status_field = true;		
	}

	public function /*void*/ setLootNull()
	{
		$this->loot = null;
		$this->loot_status_field = true;		
		$this->this_table_status_field = true;
	}

	public function /*string*/ getSpecialLoot()
	{
		return $this->special_loot;
	}
	
	public function /*void*/ setSpecialLoot(/*string*/ $special_loot)
	{
		$this->special_loot = SQLUtil::toSafeSQLString($special_loot);
		$this->special_loot_status_field = true;		
		$this->this_table_status_field = true;		
	}

	public function /*void*/ setSpecialLootNull()
	{
		$this->special_loot = null;
		$this->special_loot_status_field = true;		
		$this->this_table_status_field = true;
	}

	public function /*string*/ getSpecialGet()
	{
		return $this->special_get;
	}
	
	public function /*void*/ setSpecialGet(/*string*/ $special_get)
	{
		$this->special_get = SQLUtil::toSafeSQLString($special_get);
		$this->special_get_status_field = true;		
		$this->this_table_status_field = true;		
	}

	public function /*void*/ setSpecialGetNull()
	{
		$this->special_get = null;
		$this->special_get_status_field = true;		
		$this->this_table_status_field = true;
	}

	
	public function /*string*/ toDebugString()
	{
		$dbg = "(";
		
		$dbg .= ("id={$this->id},");
		$dbg .= ("server_id={$this->server_id},");
		$dbg .= ("guild_id={$this->guild_id},");
		$dbg .= ("raid_id={$this->raid_id},");
		$dbg .= ("stage_id={$this->stage_id},");
		$dbg .= ("wave_index={$this->wave_index},");
		$dbg .= ("begin_time={$this->begin_time},");
		$dbg .= ("challenger={$this->challenger},");
		$dbg .= ("challenger_begin_time={$this->challenger_begin_time},");
		$dbg .= ("challenger_status={$this->challenger_status},");
		$dbg .= ("detail={$this->detail},");
		$dbg .= ("progress={$this->progress},");
		$dbg .= ("stage_progress={$this->stage_progress},");
		$dbg .= ("first_pass_timestamp={$this->first_pass_timestamp},");
		$dbg .= ("fast_pass_time={$this->fast_pass_time},");
		$dbg .= ("loot={$this->loot},");
		$dbg .= ("special_loot={$this->special_loot},");
		$dbg .= ("special_get={$this->special_get},");

		$dbg .= ")";
				
		return str_replace(",)",")",$dbg);
	}
}

?>
