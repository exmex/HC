<?php
require_once ($GLOBALS ['GAME_ROOT'] . "CMySQL.php");
require_once ("SQLUtil.php");
/**
 *  [The generated files]
 */

class SysPlayerHireHero {
	
	private /*string*/ $id; //PRIMARY KEY 
	private /*string*/ $user_id;
	private /*string*/ $guild_id;
	private /*int*/ $hire_time;
	private /*string*/ $hire_user_id;
	private /*string*/ $hire_hero_tid;
	private /*int*/ $hire_from;
	private /*int*/ $is_use;

	
	private $this_table_status_field = false;
	private $id_status_field = false;
	private $user_id_status_field = false;
	private $guild_id_status_field = false;
	private $hire_time_status_field = false;
	private $hire_user_id_status_field = false;
	private $hire_hero_tid_status_field = false;
	private $hire_from_status_field = false;
	private $is_use_status_field = false;


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
			$sql = "SELECT {$p} FROM `player_hire_hero`";
		}
		else
		{			
			$sql = "SELECT {$p} FROM `player_hire_hero` WHERE ".SQLUtil::parseCondition($condition);
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
			$tb = new SysPlayerHireHero();			
			if (isset($row['id'])) $tb->id = $row['id'];
			if (isset($row['user_id'])) $tb->user_id = $row['user_id'];
			if (isset($row['guild_id'])) $tb->guild_id = $row['guild_id'];
			if (isset($row['hire_time'])) $tb->hire_time = intval($row['hire_time']);
			if (isset($row['hire_user_id'])) $tb->hire_user_id = $row['hire_user_id'];
			if (isset($row['hire_hero_tid'])) $tb->hire_hero_tid = $row['hire_hero_tid'];
			if (isset($row['hire_from'])) $tb->hire_from = intval($row['hire_from']);
			if (isset($row['is_use'])) $tb->is_use = intval($row['is_use']);
		
			$result[] = $tb;
		}
		
		return $result;
	}	
	
	public static function insertSqlHeader($fields=NULL)
	{
		$result = array();				
		if(!empty($fields)){
			$where = SQLUtil::parseFields($fields);			
			$result[0] = "INSERT INTO `player_hire_hero` ({$where}) VALUES ";	
			$ar = array();
			foreach($fields as $key){
				$ar[$key]=1;
			}
			$result[1] = $ar;
		}else{
			$result[0]="INSERT INTO `player_hire_hero` (`id`,`user_id`,`guild_id`,`hire_time`,`hire_user_id`,`hire_hero_tid`,`hire_from`,`is_use`) VALUES ";
			$result[1] = array('id'=>1,'user_id'=>1,'guild_id'=>1,'hire_time'=>1,'hire_user_id'=>1,'hire_hero_tid'=>1,'hire_from'=>1,'is_use'=>1);
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
		
		$sql = "SELECT {$p} FROM `player_hire_hero` WHERE {$where}";

		if(isset($this->user_id)){MySQL::selectDbForUser($this->user_id);}else{MySQL::selectDbForUser($GLOBALS['USER_ID']);}
		$qr = MySQL::getInstance()->RunQuery($sql);
		$ar = MySQL::getInstance()->FetchArray($qr);
		
		if (!$ar || count($ar)==0)
		{
			return false;
		}
		
		if (isset($ar['id'])) $this->id = $ar['id'];
		if (isset($ar['user_id'])) $this->user_id = $ar['user_id'];
		if (isset($ar['guild_id'])) $this->guild_id = $ar['guild_id'];
		if (isset($ar['hire_time'])) $this->hire_time = intval($ar['hire_time']);
		if (isset($ar['hire_user_id'])) $this->hire_user_id = $ar['hire_user_id'];
		if (isset($ar['hire_hero_tid'])) $this->hire_hero_tid = $ar['hire_hero_tid'];
		if (isset($ar['hire_from'])) $this->hire_from = intval($ar['hire_from']);
		if (isset($ar['is_use'])) $this->is_use = intval($ar['is_use']);
		
		
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
	
		$sql = "SELECT {$p} FROM `player_hire_hero` WHERE {$where}";
	
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
    	if (!isset($this->guild_id)){
    		$emptyFields = false;
    		$fields[] = 'guild_id';
    	}else{
    		$emptyCondition = false; 
    		$condition['guild_id']=$this->guild_id;
    	}
    	if (!isset($this->hire_time)){
    		$emptyFields = false;
    		$fields[] = 'hire_time';
    	}else{
    		$emptyCondition = false; 
    		$condition['hire_time']=$this->hire_time;
    	}
    	if (!isset($this->hire_user_id)){
    		$emptyFields = false;
    		$fields[] = 'hire_user_id';
    	}else{
    		$emptyCondition = false; 
    		$condition['hire_user_id']=$this->hire_user_id;
    	}
    	if (!isset($this->hire_hero_tid)){
    		$emptyFields = false;
    		$fields[] = 'hire_hero_tid';
    	}else{
    		$emptyCondition = false; 
    		$condition['hire_hero_tid']=$this->hire_hero_tid;
    	}
    	if (!isset($this->hire_from)){
    		$emptyFields = false;
    		$fields[] = 'hire_from';
    	}else{
    		$emptyCondition = false; 
    		$condition['hire_from']=$this->hire_from;
    	}
    	if (!isset($this->is_use)){
    		$emptyFields = false;
    		$fields[] = 'is_use';
    	}else{
    		$emptyCondition = false; 
    		$condition['is_use']=$this->is_use;
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
		
		$sql = "DELETE FROM `player_hire_hero` WHERE ".SQLUtil::parseCondition($condition);
		
		$qr = MySQL::getInstance()->RunQuery($sql);
				
		return (boolean)$qr;
	}
	
	public function  delete()
	{
		if (!isset($this->id))
		{
			return false;
		}
		
		$sql = "DELETE FROM `player_hire_hero` WHERE `id`='{$this->id}'";
		
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
 			}else if($f == 'guild_id'){
 				$values .= "'{$this->guild_id}',";
 			}else if($f == 'hire_time'){
 				$values .= "'{$this->hire_time}',";
 			}else if($f == 'hire_user_id'){
 				$values .= "'{$this->hire_user_id}',";
 			}else if($f == 'hire_hero_tid'){
 				$values .= "'{$this->hire_hero_tid}',";
 			}else if($f == 'hire_from'){
 				$values .= "'{$this->hire_from}',";
 			}else if($f == 'is_use'){
 				$values .= "'{$this->is_use}',";
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
		if (isset($this->guild_id))
		{
			$fields .= "`guild_id`,";
			$values .= "'{$this->guild_id}',";
		}
		if (isset($this->hire_time))
		{
			$fields .= "`hire_time`,";
			$values .= "'{$this->hire_time}',";
		}
		if (isset($this->hire_user_id))
		{
			$fields .= "`hire_user_id`,";
			$values .= "'{$this->hire_user_id}',";
		}
		if (isset($this->hire_hero_tid))
		{
			$fields .= "`hire_hero_tid`,";
			$values .= "'{$this->hire_hero_tid}',";
		}
		if (isset($this->hire_from))
		{
			$fields .= "`hire_from`,";
			$values .= "'{$this->hire_from}',";
		}
		if (isset($this->is_use))
		{
			$fields .= "`is_use`,";
			$values .= "'{$this->is_use}',";
		}

		
		$fields .= ")";
		$values .= ")";
		
		$sql = "INSERT INTO `player_hire_hero` ".$fields.$values;
		
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
		if ($this->hire_time_status_field)
		{			
			if (!isset($this->hire_time))
			{
				$update .= ("`hire_time`=null,");
			}
			else
			{
				$update .= ("`hire_time`='{$this->hire_time}',");
			}
		}
		if ($this->hire_user_id_status_field)
		{			
			if (!isset($this->hire_user_id))
			{
				$update .= ("`hire_user_id`=null,");
			}
			else
			{
				$update .= ("`hire_user_id`='{$this->hire_user_id}',");
			}
		}
		if ($this->hire_hero_tid_status_field)
		{			
			if (!isset($this->hire_hero_tid))
			{
				$update .= ("`hire_hero_tid`=null,");
			}
			else
			{
				$update .= ("`hire_hero_tid`='{$this->hire_hero_tid}',");
			}
		}
		if ($this->hire_from_status_field)
		{			
			if (!isset($this->hire_from))
			{
				$update .= ("`hire_from`=null,");
			}
			else
			{
				$update .= ("`hire_from`='{$this->hire_from}',");
			}
		}
		if ($this->is_use_status_field)
		{			
			if (!isset($this->is_use))
			{
				$update .= ("`is_use`=null,");
			}
			else
			{
				$update .= ("`is_use`='{$this->is_use}',");
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
		
		$sql = "UPDATE `player_hire_hero` SET {$update} WHERE {$condition}";
		
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
		
		$sql = "UPDATE `player_hire_hero` SET {$update} WHERE {$uc}";
		
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
		
		$sql = "UPDATE `player_hire_hero` SET {$update} WHERE {$uc}";
		
		if(isset($this->user_id)){MySQL::selectDbForUser($this->user_id);}else{MySQL::selectDbForUser($GLOBALS['USER_ID']);}
		$qr = MySQL::getInstance()->RunQuery($sql);
				
		return (boolean)$qr;
	}
	
	private function /*void*/ clean() 
	{
		$this->this_table_status_field = false;
		$this->id_status_field = false;
		$this->user_id_status_field = false;
		$this->guild_id_status_field = false;
		$this->hire_time_status_field = false;
		$this->hire_user_id_status_field = false;
		$this->hire_hero_tid_status_field = false;
		$this->hire_from_status_field = false;
		$this->is_use_status_field = false;

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

	public function /*int*/ getHireTime()
	{
		return $this->hire_time;
	}
	
	public function /*void*/ setHireTime(/*int*/ $hire_time)
	{
		$this->hire_time = intval($hire_time);
		$this->hire_time_status_field = true;		
		$this->this_table_status_field = true;		
	}

	public function /*void*/ setHireTimeNull()
	{
		$this->hire_time = null;
		$this->hire_time_status_field = true;		
		$this->this_table_status_field = true;
	}

	public function /*string*/ getHireUserId()
	{
		return $this->hire_user_id;
	}
	
	public function /*void*/ setHireUserId(/*string*/ $hire_user_id)
	{
		$this->hire_user_id = SQLUtil::toSafeSQLString($hire_user_id);
		$this->hire_user_id_status_field = true;		
		$this->this_table_status_field = true;		
	}

	public function /*void*/ setHireUserIdNull()
	{
		$this->hire_user_id = null;
		$this->hire_user_id_status_field = true;		
		$this->this_table_status_field = true;
	}

	public function /*string*/ getHireHeroTid()
	{
		return $this->hire_hero_tid;
	}
	
	public function /*void*/ setHireHeroTid(/*string*/ $hire_hero_tid)
	{
		$this->hire_hero_tid = SQLUtil::toSafeSQLString($hire_hero_tid);
		$this->hire_hero_tid_status_field = true;		
		$this->this_table_status_field = true;		
	}

	public function /*void*/ setHireHeroTidNull()
	{
		$this->hire_hero_tid = null;
		$this->hire_hero_tid_status_field = true;		
		$this->this_table_status_field = true;
	}

	public function /*int*/ getHireFrom()
	{
		return $this->hire_from;
	}
	
	public function /*void*/ setHireFrom(/*int*/ $hire_from)
	{
		$this->hire_from = intval($hire_from);
		$this->hire_from_status_field = true;		
		$this->this_table_status_field = true;		
	}

	public function /*void*/ setHireFromNull()
	{
		$this->hire_from = null;
		$this->hire_from_status_field = true;		
		$this->this_table_status_field = true;
	}

	public function /*int*/ getIsUse()
	{
		return $this->is_use;
	}
	
	public function /*void*/ setIsUse(/*int*/ $is_use)
	{
		$this->is_use = intval($is_use);
		$this->is_use_status_field = true;		
		$this->this_table_status_field = true;		
	}

	public function /*void*/ setIsUseNull()
	{
		$this->is_use = null;
		$this->is_use_status_field = true;		
		$this->this_table_status_field = true;
	}

	
	public function /*string*/ toDebugString()
	{
		$dbg = "(";
		
		$dbg .= ("id={$this->id},");
		$dbg .= ("user_id={$this->user_id},");
		$dbg .= ("guild_id={$this->guild_id},");
		$dbg .= ("hire_time={$this->hire_time},");
		$dbg .= ("hire_user_id={$this->hire_user_id},");
		$dbg .= ("hire_hero_tid={$this->hire_hero_tid},");
		$dbg .= ("hire_from={$this->hire_from},");
		$dbg .= ("is_use={$this->is_use},");

		$dbg .= ")";
				
		return str_replace(",)",")",$dbg);
	}
}

?>
