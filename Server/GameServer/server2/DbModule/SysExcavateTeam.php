<?php
require_once ($GLOBALS ['GAME_ROOT'] . "CMySQL.php");
require_once ("SQLUtil.php");
/**
 *  [The generated files]
 */

class SysExcavateTeam {
	
	private /*string*/ $team_id; //PRIMARY KEY 
	private /*string*/ $user_id;
	private /*string*/ $hero_bases;
	private /*string*/ $hero_dynas;
	private /*int*/ $res_got;
	private /*int*/ $server_id;
	private /*int*/ $display_server_id;
	private /*int*/ $team_gs;
	private /*string*/ $server_name;
	private /*int*/ $create_time;
	private /*int*/ $replace_time;
	private /*string*/ $excavate_id;

	
	private $this_table_status_field = false;
	private $team_id_status_field = false;
	private $user_id_status_field = false;
	private $hero_bases_status_field = false;
	private $hero_dynas_status_field = false;
	private $res_got_status_field = false;
	private $server_id_status_field = false;
	private $display_server_id_status_field = false;
	private $team_gs_status_field = false;
	private $server_name_status_field = false;
	private $create_time_status_field = false;
	private $replace_time_status_field = false;
	private $excavate_id_status_field = false;


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
			$sql = "SELECT {$p} FROM `excavate_team`";
		}
		else
		{			
			$sql = "SELECT {$p} FROM `excavate_team` WHERE ".SQLUtil::parseCondition($condition);
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
			$tb = new SysExcavateTeam();			
			if (isset($row['team_id'])) $tb->team_id = $row['team_id'];
			if (isset($row['user_id'])) $tb->user_id = $row['user_id'];
			if (isset($row['hero_bases'])) $tb->hero_bases = $row['hero_bases'];
			if (isset($row['hero_dynas'])) $tb->hero_dynas = $row['hero_dynas'];
			if (isset($row['res_got'])) $tb->res_got = intval($row['res_got']);
			if (isset($row['server_id'])) $tb->server_id = intval($row['server_id']);
			if (isset($row['display_server_id'])) $tb->display_server_id = intval($row['display_server_id']);
			if (isset($row['team_gs'])) $tb->team_gs = intval($row['team_gs']);
			if (isset($row['server_name'])) $tb->server_name = $row['server_name'];
			if (isset($row['create_time'])) $tb->create_time = intval($row['create_time']);
			if (isset($row['replace_time'])) $tb->replace_time = intval($row['replace_time']);
			if (isset($row['excavate_id'])) $tb->excavate_id = $row['excavate_id'];
		
			$result[] = $tb;
		}
		
		return $result;
	}	
	
	public static function insertSqlHeader($fields=NULL)
	{
		$result = array();				
		if(!empty($fields)){
			$where = SQLUtil::parseFields($fields);			
			$result[0] = "INSERT INTO `excavate_team` ({$where}) VALUES ";	
			$ar = array();
			foreach($fields as $key){
				$ar[$key]=1;
			}
			$result[1] = $ar;
		}else{
			$result[0]="INSERT INTO `excavate_team` (`team_id`,`user_id`,`hero_bases`,`hero_dynas`,`res_got`,`server_id`,`display_server_id`,`team_gs`,`server_name`,`create_time`,`replace_time`,`excavate_id`) VALUES ";
			$result[1] = array('team_id'=>1,'user_id'=>1,'hero_bases'=>1,'hero_dynas'=>1,'res_got'=>1,'server_id'=>1,'display_server_id'=>1,'team_gs'=>1,'server_name'=>1,'create_time'=>1,'replace_time'=>1,'excavate_id'=>1);
		}				
		return $result;
	}
		
	public function  loaded( $fields=NULL,$condition=NULL)
	{

		if (empty($condition) && empty($this->team_id))
		{
			return false;
		}
		
		$p = "*";
		$where = "`team_id` = '{$this->team_id}'";
		
		if(!empty($fields))
		{
			$p = SQLUtil::parseFields($fields);			
		}
	    if (!empty($condition))
		{
			$where =SQLUtil::parseCondition($condition);
		}
		
		$sql = "SELECT {$p} FROM `excavate_team` WHERE {$where}";

		MySQL::selectDefaultDb();
		$qr = MySQL::getInstance()->RunQuery($sql);
		$ar = MySQL::getInstance()->FetchArray($qr);
		
		if (!$ar || count($ar)==0)
		{
			return false;
		}
		
		if (isset($ar['team_id'])) $this->team_id = $ar['team_id'];
		if (isset($ar['user_id'])) $this->user_id = $ar['user_id'];
		if (isset($ar['hero_bases'])) $this->hero_bases = $ar['hero_bases'];
		if (isset($ar['hero_dynas'])) $this->hero_dynas = $ar['hero_dynas'];
		if (isset($ar['res_got'])) $this->res_got = intval($ar['res_got']);
		if (isset($ar['server_id'])) $this->server_id = intval($ar['server_id']);
		if (isset($ar['display_server_id'])) $this->display_server_id = intval($ar['display_server_id']);
		if (isset($ar['team_gs'])) $this->team_gs = intval($ar['team_gs']);
		if (isset($ar['server_name'])) $this->server_name = $ar['server_name'];
		if (isset($ar['create_time'])) $this->create_time = intval($ar['create_time']);
		if (isset($ar['replace_time'])) $this->replace_time = intval($ar['replace_time']);
		if (isset($ar['excavate_id'])) $this->excavate_id = $ar['excavate_id'];
		
		
		$this->clean();
		
		return true;
	}
	
	
	public function  loadedCount( $fields=NULL,$condition=NULL)
	{
	
		if (empty($condition) && empty($this->team_id))
		{
			return false;
		}
	
		$p = "*";
		$where = "`team_id` = '{$this->team_id}'";
	
		if(!empty($fields))
		{
			$p = SQLUtil::parseFields($fields);
		}
		if (!empty($condition))
		{
			$where =SQLUtil::parseCondition($condition);
		}
	
		$sql = "SELECT {$p} FROM `excavate_team` WHERE {$where}";
	
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
    	
    	if (!isset($this->team_id)){
    		$emptyFields = false;
    		$fields[] = 'team_id';
    	}else{
    		$emptyCondition = false; 
    		$condition['team_id']=$this->team_id;
    	}
    	if (!isset($this->user_id)){
    		$emptyFields = false;
    		$fields[] = 'user_id';
    	}else{
    		$emptyCondition = false; 
    		$condition['user_id']=$this->user_id;
    	}
    	if (!isset($this->hero_bases)){
    		$emptyFields = false;
    		$fields[] = 'hero_bases';
    	}else{
    		$emptyCondition = false; 
    		$condition['hero_bases']=$this->hero_bases;
    	}
    	if (!isset($this->hero_dynas)){
    		$emptyFields = false;
    		$fields[] = 'hero_dynas';
    	}else{
    		$emptyCondition = false; 
    		$condition['hero_dynas']=$this->hero_dynas;
    	}
    	if (!isset($this->res_got)){
    		$emptyFields = false;
    		$fields[] = 'res_got';
    	}else{
    		$emptyCondition = false; 
    		$condition['res_got']=$this->res_got;
    	}
    	if (!isset($this->server_id)){
    		$emptyFields = false;
    		$fields[] = 'server_id';
    	}else{
    		$emptyCondition = false; 
    		$condition['server_id']=$this->server_id;
    	}
    	if (!isset($this->display_server_id)){
    		$emptyFields = false;
    		$fields[] = 'display_server_id';
    	}else{
    		$emptyCondition = false; 
    		$condition['display_server_id']=$this->display_server_id;
    	}
    	if (!isset($this->team_gs)){
    		$emptyFields = false;
    		$fields[] = 'team_gs';
    	}else{
    		$emptyCondition = false; 
    		$condition['team_gs']=$this->team_gs;
    	}
    	if (!isset($this->server_name)){
    		$emptyFields = false;
    		$fields[] = 'server_name';
    	}else{
    		$emptyCondition = false; 
    		$condition['server_name']=$this->server_name;
    	}
    	if (!isset($this->create_time)){
    		$emptyFields = false;
    		$fields[] = 'create_time';
    	}else{
    		$emptyCondition = false; 
    		$condition['create_time']=$this->create_time;
    	}
    	if (!isset($this->replace_time)){
    		$emptyFields = false;
    		$fields[] = 'replace_time';
    	}else{
    		$emptyCondition = false; 
    		$condition['replace_time']=$this->replace_time;
    	}
    	if (!isset($this->excavate_id)){
    		$emptyFields = false;
    		$fields[] = 'excavate_id';
    	}else{
    		$emptyCondition = false; 
    		$condition['excavate_id']=$this->excavate_id;
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
				
		if (empty($this->team_id))
		{
			$this->team_id = MySQL::getInstance()->GetInsertId();
		}		
		
		$this->clean();
		
		return true;	
		
	}
	
	public function save($condition=NULL)
	{
		if (empty($condition))
		{
			$uc = "`team_id`='{$this->team_id}'";
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
		
		$sql = "DELETE FROM `excavate_team` WHERE ".SQLUtil::parseCondition($condition);
		
		$qr = MySQL::getInstance()->RunQuery($sql);
				
		return (boolean)$qr;
	}
	
	public function  delete()
	{
		if (!isset($this->team_id))
		{
			return false;
		}
		
		$sql = "DELETE FROM `excavate_team` WHERE `team_id`='{$this->team_id}'";
		
		MySQL::selectDefaultDb();
		$qr = MySQL::getInstance()->RunQuery($sql);
				
		return (boolean)$qr;
	}
	
	public function getInsertValue($fields)
	{
		$values = "(";		
		foreach($fields as $f => $k){
			if($f == 'team_id'){
 				$values .= "'{$this->team_id}',";
 			}else if($f == 'user_id'){
 				$values .= "'{$this->user_id}',";
 			}else if($f == 'hero_bases'){
 				$values .= "'{$this->hero_bases}',";
 			}else if($f == 'hero_dynas'){
 				$values .= "'{$this->hero_dynas}',";
 			}else if($f == 'res_got'){
 				$values .= "'{$this->res_got}',";
 			}else if($f == 'server_id'){
 				$values .= "'{$this->server_id}',";
 			}else if($f == 'display_server_id'){
 				$values .= "'{$this->display_server_id}',";
 			}else if($f == 'team_gs'){
 				$values .= "'{$this->team_gs}',";
 			}else if($f == 'server_name'){
 				$values .= "'{$this->server_name}',";
 			}else if($f == 'create_time'){
 				$values .= "'{$this->create_time}',";
 			}else if($f == 'replace_time'){
 				$values .= "'{$this->replace_time}',";
 			}else if($f == 'excavate_id'){
 				$values .= "'{$this->excavate_id}',";
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

		if (isset($this->team_id))
		{
			$fields .= "`team_id`,";
			$values .= "'{$this->team_id}',";
		}
		if (isset($this->user_id))
		{
			$fields .= "`user_id`,";
			$values .= "'{$this->user_id}',";
		}
		if (isset($this->hero_bases))
		{
			$fields .= "`hero_bases`,";
			$values .= "'{$this->hero_bases}',";
		}
		if (isset($this->hero_dynas))
		{
			$fields .= "`hero_dynas`,";
			$values .= "'{$this->hero_dynas}',";
		}
		if (isset($this->res_got))
		{
			$fields .= "`res_got`,";
			$values .= "'{$this->res_got}',";
		}
		if (isset($this->server_id))
		{
			$fields .= "`server_id`,";
			$values .= "'{$this->server_id}',";
		}
		if (isset($this->display_server_id))
		{
			$fields .= "`display_server_id`,";
			$values .= "'{$this->display_server_id}',";
		}
		if (isset($this->team_gs))
		{
			$fields .= "`team_gs`,";
			$values .= "'{$this->team_gs}',";
		}
		if (isset($this->server_name))
		{
			$fields .= "`server_name`,";
			$values .= "'{$this->server_name}',";
		}
		if (isset($this->create_time))
		{
			$fields .= "`create_time`,";
			$values .= "'{$this->create_time}',";
		}
		if (isset($this->replace_time))
		{
			$fields .= "`replace_time`,";
			$values .= "'{$this->replace_time}',";
		}
		if (isset($this->excavate_id))
		{
			$fields .= "`excavate_id`,";
			$values .= "'{$this->excavate_id}',";
		}

		
		$fields .= ")";
		$values .= ")";
		
		$sql = "INSERT INTO `excavate_team` ".$fields.$values;
		
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
		if ($this->hero_bases_status_field)
		{			
			if (!isset($this->hero_bases))
			{
				$update .= ("`hero_bases`=null,");
			}
			else
			{
				$update .= ("`hero_bases`='{$this->hero_bases}',");
			}
		}
		if ($this->hero_dynas_status_field)
		{			
			if (!isset($this->hero_dynas))
			{
				$update .= ("`hero_dynas`=null,");
			}
			else
			{
				$update .= ("`hero_dynas`='{$this->hero_dynas}',");
			}
		}
		if ($this->res_got_status_field)
		{			
			if (!isset($this->res_got))
			{
				$update .= ("`res_got`=null,");
			}
			else
			{
				$update .= ("`res_got`='{$this->res_got}',");
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
		if ($this->display_server_id_status_field)
		{			
			if (!isset($this->display_server_id))
			{
				$update .= ("`display_server_id`=null,");
			}
			else
			{
				$update .= ("`display_server_id`='{$this->display_server_id}',");
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
		if ($this->replace_time_status_field)
		{			
			if (!isset($this->replace_time))
			{
				$update .= ("`replace_time`=null,");
			}
			else
			{
				$update .= ("`replace_time`='{$this->replace_time}',");
			}
		}
		if ($this->excavate_id_status_field)
		{			
			if (!isset($this->excavate_id))
			{
				$update .= ("`excavate_id`=null,");
			}
			else
			{
				$update .= ("`excavate_id`='{$this->excavate_id}',");
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
		
		$sql = "UPDATE `excavate_team` SET {$update} WHERE {$condition}";
		
		return $sql;
	}
	
	public function  add($fieldsValue,$condition=NULL)
	{				
		if (empty($condition))
		{
			$uc = "`team_id`='{$this->team_id}'";
		}
		else
		{			
			$uc = SQLUtil::parseCondition($condition);
		}
		
		$update = SQLUtil::parseASFieldValues($fieldsValue);
		
		$sql = "UPDATE `excavate_team` SET {$update} WHERE {$uc}";
		
		MySQL::selectDefaultDb();
		$qr = MySQL::getInstance()->RunQuery($sql);
				
		return (boolean)$qr;
	}	
	
	public function sub($fieldsVal,$condition=NULL)
	{
		if (empty($condition))
		{
			$uc = "`team_id`='{$this->team_id}'";
		}
		else
		{			
			$uc = SQLUtil::parseCondition($condition);
		}
		
		$update = SQLUtil::parseASFieldValues($fieldsVal,false);
		
		$sql = "UPDATE `excavate_team` SET {$update} WHERE {$uc}";
		
		MySQL::selectDefaultDb();
		$qr = MySQL::getInstance()->RunQuery($sql);
				
		return (boolean)$qr;
	}
	
	private function /*void*/ clean() 
	{
		$this->this_table_status_field = false;
		$this->team_id_status_field = false;
		$this->user_id_status_field = false;
		$this->hero_bases_status_field = false;
		$this->hero_dynas_status_field = false;
		$this->res_got_status_field = false;
		$this->server_id_status_field = false;
		$this->display_server_id_status_field = false;
		$this->team_gs_status_field = false;
		$this->server_name_status_field = false;
		$this->create_time_status_field = false;
		$this->replace_time_status_field = false;
		$this->excavate_id_status_field = false;

	}
	
	public function /*string*/ getTeamId()
	{
		return $this->team_id;
	}
	
	public function /*void*/ setTeamId(/*string*/ $team_id)
	{
		$this->team_id = SQLUtil::toSafeSQLString($team_id);
		$this->team_id_status_field = true;		
		$this->this_table_status_field = true;		
	}

	public function /*void*/ setTeamIdNull()
	{
		$this->team_id = null;
		$this->team_id_status_field = true;		
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

	public function /*string*/ getHeroBases()
	{
		return $this->hero_bases;
	}
	
	public function /*void*/ setHeroBases(/*string*/ $hero_bases)
	{
		$this->hero_bases = SQLUtil::toSafeSQLString($hero_bases);
		$this->hero_bases_status_field = true;		
		$this->this_table_status_field = true;		
	}

	public function /*void*/ setHeroBasesNull()
	{
		$this->hero_bases = null;
		$this->hero_bases_status_field = true;		
		$this->this_table_status_field = true;
	}

	public function /*string*/ getHeroDynas()
	{
		return $this->hero_dynas;
	}
	
	public function /*void*/ setHeroDynas(/*string*/ $hero_dynas)
	{
		$this->hero_dynas = SQLUtil::toSafeSQLString($hero_dynas);
		$this->hero_dynas_status_field = true;		
		$this->this_table_status_field = true;		
	}

	public function /*void*/ setHeroDynasNull()
	{
		$this->hero_dynas = null;
		$this->hero_dynas_status_field = true;		
		$this->this_table_status_field = true;
	}

	public function /*int*/ getResGot()
	{
		return $this->res_got;
	}
	
	public function /*void*/ setResGot(/*int*/ $res_got)
	{
		$this->res_got = intval($res_got);
		$this->res_got_status_field = true;		
		$this->this_table_status_field = true;		
	}

	public function /*void*/ setResGotNull()
	{
		$this->res_got = null;
		$this->res_got_status_field = true;		
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

	public function /*int*/ getDisplayServerId()
	{
		return $this->display_server_id;
	}
	
	public function /*void*/ setDisplayServerId(/*int*/ $display_server_id)
	{
		$this->display_server_id = intval($display_server_id);
		$this->display_server_id_status_field = true;		
		$this->this_table_status_field = true;		
	}

	public function /*void*/ setDisplayServerIdNull()
	{
		$this->display_server_id = null;
		$this->display_server_id_status_field = true;		
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

	public function /*int*/ getReplaceTime()
	{
		return $this->replace_time;
	}
	
	public function /*void*/ setReplaceTime(/*int*/ $replace_time)
	{
		$this->replace_time = intval($replace_time);
		$this->replace_time_status_field = true;		
		$this->this_table_status_field = true;		
	}

	public function /*void*/ setReplaceTimeNull()
	{
		$this->replace_time = null;
		$this->replace_time_status_field = true;		
		$this->this_table_status_field = true;
	}

	public function /*string*/ getExcavateId()
	{
		return $this->excavate_id;
	}
	
	public function /*void*/ setExcavateId(/*string*/ $excavate_id)
	{
		$this->excavate_id = SQLUtil::toSafeSQLString($excavate_id);
		$this->excavate_id_status_field = true;		
		$this->this_table_status_field = true;		
	}

	public function /*void*/ setExcavateIdNull()
	{
		$this->excavate_id = null;
		$this->excavate_id_status_field = true;		
		$this->this_table_status_field = true;
	}

	
	public function /*string*/ toDebugString()
	{
		$dbg = "(";
		
		$dbg .= ("team_id={$this->team_id},");
		$dbg .= ("user_id={$this->user_id},");
		$dbg .= ("hero_bases={$this->hero_bases},");
		$dbg .= ("hero_dynas={$this->hero_dynas},");
		$dbg .= ("res_got={$this->res_got},");
		$dbg .= ("server_id={$this->server_id},");
		$dbg .= ("display_server_id={$this->display_server_id},");
		$dbg .= ("team_gs={$this->team_gs},");
		$dbg .= ("server_name={$this->server_name},");
		$dbg .= ("create_time={$this->create_time},");
		$dbg .= ("replace_time={$this->replace_time},");
		$dbg .= ("excavate_id={$this->excavate_id},");

		$dbg .= ")";
				
		return str_replace(",)",")",$dbg);
	}
}

?>
