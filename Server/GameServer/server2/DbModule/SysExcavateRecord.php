<?php
require_once ($GLOBALS ['GAME_ROOT'] . "CMySQL.php");
require_once ("SQLUtil.php");
/**
 *  [The generated files]
 */

class SysExcavateRecord {
	
	private /*string*/ $id; //PRIMARY KEY 
	private /*string*/ $user_id;
	private /*string*/ $user_name;
	private /*int*/ $user_avatar;
	private /*int*/ $user_level;
	private /*int*/ $user_robot;
	private /*string*/ $oppo_id;
	private /*string*/ $oppo_name;
	private /*int*/ $oppo_avatar;
	private /*int*/ $oppo_level;
	private /*int*/ $oppo_robot;
	private /*int*/ $bt_result;
	private /*int*/ $bt_time;
	private /*string*/ $history_id;

	
	private $this_table_status_field = false;
	private $id_status_field = false;
	private $user_id_status_field = false;
	private $user_name_status_field = false;
	private $user_avatar_status_field = false;
	private $user_level_status_field = false;
	private $user_robot_status_field = false;
	private $oppo_id_status_field = false;
	private $oppo_name_status_field = false;
	private $oppo_avatar_status_field = false;
	private $oppo_level_status_field = false;
	private $oppo_robot_status_field = false;
	private $bt_result_status_field = false;
	private $bt_time_status_field = false;
	private $history_id_status_field = false;


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
			$sql = "SELECT {$p} FROM `excavate_record`";
		}
		else
		{			
			$sql = "SELECT {$p} FROM `excavate_record` WHERE ".SQLUtil::parseCondition($condition);
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
			$tb = new SysExcavateRecord();			
			if (isset($row['id'])) $tb->id = $row['id'];
			if (isset($row['user_id'])) $tb->user_id = $row['user_id'];
			if (isset($row['user_name'])) $tb->user_name = $row['user_name'];
			if (isset($row['user_avatar'])) $tb->user_avatar = intval($row['user_avatar']);
			if (isset($row['user_level'])) $tb->user_level = intval($row['user_level']);
			if (isset($row['user_robot'])) $tb->user_robot = intval($row['user_robot']);
			if (isset($row['oppo_id'])) $tb->oppo_id = $row['oppo_id'];
			if (isset($row['oppo_name'])) $tb->oppo_name = $row['oppo_name'];
			if (isset($row['oppo_avatar'])) $tb->oppo_avatar = intval($row['oppo_avatar']);
			if (isset($row['oppo_level'])) $tb->oppo_level = intval($row['oppo_level']);
			if (isset($row['oppo_robot'])) $tb->oppo_robot = intval($row['oppo_robot']);
			if (isset($row['bt_result'])) $tb->bt_result = intval($row['bt_result']);
			if (isset($row['bt_time'])) $tb->bt_time = intval($row['bt_time']);
			if (isset($row['history_id'])) $tb->history_id = $row['history_id'];
		
			$result[] = $tb;
		}
		
		return $result;
	}	
	
	public static function insertSqlHeader($fields=NULL)
	{
		$result = array();				
		if(!empty($fields)){
			$where = SQLUtil::parseFields($fields);			
			$result[0] = "INSERT INTO `excavate_record` ({$where}) VALUES ";	
			$ar = array();
			foreach($fields as $key){
				$ar[$key]=1;
			}
			$result[1] = $ar;
		}else{
			$result[0]="INSERT INTO `excavate_record` (`id`,`user_id`,`user_name`,`user_avatar`,`user_level`,`user_robot`,`oppo_id`,`oppo_name`,`oppo_avatar`,`oppo_level`,`oppo_robot`,`bt_result`,`bt_time`,`history_id`) VALUES ";
			$result[1] = array('id'=>1,'user_id'=>1,'user_name'=>1,'user_avatar'=>1,'user_level'=>1,'user_robot'=>1,'oppo_id'=>1,'oppo_name'=>1,'oppo_avatar'=>1,'oppo_level'=>1,'oppo_robot'=>1,'bt_result'=>1,'bt_time'=>1,'history_id'=>1);
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
		
		$sql = "SELECT {$p} FROM `excavate_record` WHERE {$where}";

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
		if (isset($ar['user_avatar'])) $this->user_avatar = intval($ar['user_avatar']);
		if (isset($ar['user_level'])) $this->user_level = intval($ar['user_level']);
		if (isset($ar['user_robot'])) $this->user_robot = intval($ar['user_robot']);
		if (isset($ar['oppo_id'])) $this->oppo_id = $ar['oppo_id'];
		if (isset($ar['oppo_name'])) $this->oppo_name = $ar['oppo_name'];
		if (isset($ar['oppo_avatar'])) $this->oppo_avatar = intval($ar['oppo_avatar']);
		if (isset($ar['oppo_level'])) $this->oppo_level = intval($ar['oppo_level']);
		if (isset($ar['oppo_robot'])) $this->oppo_robot = intval($ar['oppo_robot']);
		if (isset($ar['bt_result'])) $this->bt_result = intval($ar['bt_result']);
		if (isset($ar['bt_time'])) $this->bt_time = intval($ar['bt_time']);
		if (isset($ar['history_id'])) $this->history_id = $ar['history_id'];
		
		
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
	
		$sql = "SELECT {$p} FROM `excavate_record` WHERE {$where}";
	
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
    	if (!isset($this->user_avatar)){
    		$emptyFields = false;
    		$fields[] = 'user_avatar';
    	}else{
    		$emptyCondition = false; 
    		$condition['user_avatar']=$this->user_avatar;
    	}
    	if (!isset($this->user_level)){
    		$emptyFields = false;
    		$fields[] = 'user_level';
    	}else{
    		$emptyCondition = false; 
    		$condition['user_level']=$this->user_level;
    	}
    	if (!isset($this->user_robot)){
    		$emptyFields = false;
    		$fields[] = 'user_robot';
    	}else{
    		$emptyCondition = false; 
    		$condition['user_robot']=$this->user_robot;
    	}
    	if (!isset($this->oppo_id)){
    		$emptyFields = false;
    		$fields[] = 'oppo_id';
    	}else{
    		$emptyCondition = false; 
    		$condition['oppo_id']=$this->oppo_id;
    	}
    	if (!isset($this->oppo_name)){
    		$emptyFields = false;
    		$fields[] = 'oppo_name';
    	}else{
    		$emptyCondition = false; 
    		$condition['oppo_name']=$this->oppo_name;
    	}
    	if (!isset($this->oppo_avatar)){
    		$emptyFields = false;
    		$fields[] = 'oppo_avatar';
    	}else{
    		$emptyCondition = false; 
    		$condition['oppo_avatar']=$this->oppo_avatar;
    	}
    	if (!isset($this->oppo_level)){
    		$emptyFields = false;
    		$fields[] = 'oppo_level';
    	}else{
    		$emptyCondition = false; 
    		$condition['oppo_level']=$this->oppo_level;
    	}
    	if (!isset($this->oppo_robot)){
    		$emptyFields = false;
    		$fields[] = 'oppo_robot';
    	}else{
    		$emptyCondition = false; 
    		$condition['oppo_robot']=$this->oppo_robot;
    	}
    	if (!isset($this->bt_result)){
    		$emptyFields = false;
    		$fields[] = 'bt_result';
    	}else{
    		$emptyCondition = false; 
    		$condition['bt_result']=$this->bt_result;
    	}
    	if (!isset($this->bt_time)){
    		$emptyFields = false;
    		$fields[] = 'bt_time';
    	}else{
    		$emptyCondition = false; 
    		$condition['bt_time']=$this->bt_time;
    	}
    	if (!isset($this->history_id)){
    		$emptyFields = false;
    		$fields[] = 'history_id';
    	}else{
    		$emptyCondition = false; 
    		$condition['history_id']=$this->history_id;
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
		
		$sql = "DELETE FROM `excavate_record` WHERE ".SQLUtil::parseCondition($condition);
		
		$qr = MySQL::getInstance()->RunQuery($sql);
				
		return (boolean)$qr;
	}
	
	public function  delete()
	{
		if (!isset($this->id))
		{
			return false;
		}
		
		$sql = "DELETE FROM `excavate_record` WHERE `id`='{$this->id}'";
		
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
 			}else if($f == 'user_avatar'){
 				$values .= "'{$this->user_avatar}',";
 			}else if($f == 'user_level'){
 				$values .= "'{$this->user_level}',";
 			}else if($f == 'user_robot'){
 				$values .= "'{$this->user_robot}',";
 			}else if($f == 'oppo_id'){
 				$values .= "'{$this->oppo_id}',";
 			}else if($f == 'oppo_name'){
 				$values .= "'{$this->oppo_name}',";
 			}else if($f == 'oppo_avatar'){
 				$values .= "'{$this->oppo_avatar}',";
 			}else if($f == 'oppo_level'){
 				$values .= "'{$this->oppo_level}',";
 			}else if($f == 'oppo_robot'){
 				$values .= "'{$this->oppo_robot}',";
 			}else if($f == 'bt_result'){
 				$values .= "'{$this->bt_result}',";
 			}else if($f == 'bt_time'){
 				$values .= "'{$this->bt_time}',";
 			}else if($f == 'history_id'){
 				$values .= "'{$this->history_id}',";
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
		if (isset($this->user_avatar))
		{
			$fields .= "`user_avatar`,";
			$values .= "'{$this->user_avatar}',";
		}
		if (isset($this->user_level))
		{
			$fields .= "`user_level`,";
			$values .= "'{$this->user_level}',";
		}
		if (isset($this->user_robot))
		{
			$fields .= "`user_robot`,";
			$values .= "'{$this->user_robot}',";
		}
		if (isset($this->oppo_id))
		{
			$fields .= "`oppo_id`,";
			$values .= "'{$this->oppo_id}',";
		}
		if (isset($this->oppo_name))
		{
			$fields .= "`oppo_name`,";
			$values .= "'{$this->oppo_name}',";
		}
		if (isset($this->oppo_avatar))
		{
			$fields .= "`oppo_avatar`,";
			$values .= "'{$this->oppo_avatar}',";
		}
		if (isset($this->oppo_level))
		{
			$fields .= "`oppo_level`,";
			$values .= "'{$this->oppo_level}',";
		}
		if (isset($this->oppo_robot))
		{
			$fields .= "`oppo_robot`,";
			$values .= "'{$this->oppo_robot}',";
		}
		if (isset($this->bt_result))
		{
			$fields .= "`bt_result`,";
			$values .= "'{$this->bt_result}',";
		}
		if (isset($this->bt_time))
		{
			$fields .= "`bt_time`,";
			$values .= "'{$this->bt_time}',";
		}
		if (isset($this->history_id))
		{
			$fields .= "`history_id`,";
			$values .= "'{$this->history_id}',";
		}

		
		$fields .= ")";
		$values .= ")";
		
		$sql = "INSERT INTO `excavate_record` ".$fields.$values;
		
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
		if ($this->user_avatar_status_field)
		{			
			if (!isset($this->user_avatar))
			{
				$update .= ("`user_avatar`=null,");
			}
			else
			{
				$update .= ("`user_avatar`='{$this->user_avatar}',");
			}
		}
		if ($this->user_level_status_field)
		{			
			if (!isset($this->user_level))
			{
				$update .= ("`user_level`=null,");
			}
			else
			{
				$update .= ("`user_level`='{$this->user_level}',");
			}
		}
		if ($this->user_robot_status_field)
		{			
			if (!isset($this->user_robot))
			{
				$update .= ("`user_robot`=null,");
			}
			else
			{
				$update .= ("`user_robot`='{$this->user_robot}',");
			}
		}
		if ($this->oppo_id_status_field)
		{			
			if (!isset($this->oppo_id))
			{
				$update .= ("`oppo_id`=null,");
			}
			else
			{
				$update .= ("`oppo_id`='{$this->oppo_id}',");
			}
		}
		if ($this->oppo_name_status_field)
		{			
			if (!isset($this->oppo_name))
			{
				$update .= ("`oppo_name`=null,");
			}
			else
			{
				$update .= ("`oppo_name`='{$this->oppo_name}',");
			}
		}
		if ($this->oppo_avatar_status_field)
		{			
			if (!isset($this->oppo_avatar))
			{
				$update .= ("`oppo_avatar`=null,");
			}
			else
			{
				$update .= ("`oppo_avatar`='{$this->oppo_avatar}',");
			}
		}
		if ($this->oppo_level_status_field)
		{			
			if (!isset($this->oppo_level))
			{
				$update .= ("`oppo_level`=null,");
			}
			else
			{
				$update .= ("`oppo_level`='{$this->oppo_level}',");
			}
		}
		if ($this->oppo_robot_status_field)
		{			
			if (!isset($this->oppo_robot))
			{
				$update .= ("`oppo_robot`=null,");
			}
			else
			{
				$update .= ("`oppo_robot`='{$this->oppo_robot}',");
			}
		}
		if ($this->bt_result_status_field)
		{			
			if (!isset($this->bt_result))
			{
				$update .= ("`bt_result`=null,");
			}
			else
			{
				$update .= ("`bt_result`='{$this->bt_result}',");
			}
		}
		if ($this->bt_time_status_field)
		{			
			if (!isset($this->bt_time))
			{
				$update .= ("`bt_time`=null,");
			}
			else
			{
				$update .= ("`bt_time`='{$this->bt_time}',");
			}
		}
		if ($this->history_id_status_field)
		{			
			if (!isset($this->history_id))
			{
				$update .= ("`history_id`=null,");
			}
			else
			{
				$update .= ("`history_id`='{$this->history_id}',");
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
		
		$sql = "UPDATE `excavate_record` SET {$update} WHERE {$condition}";
		
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
		
		$sql = "UPDATE `excavate_record` SET {$update} WHERE {$uc}";
		
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
		
		$sql = "UPDATE `excavate_record` SET {$update} WHERE {$uc}";
		
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
		$this->user_avatar_status_field = false;
		$this->user_level_status_field = false;
		$this->user_robot_status_field = false;
		$this->oppo_id_status_field = false;
		$this->oppo_name_status_field = false;
		$this->oppo_avatar_status_field = false;
		$this->oppo_level_status_field = false;
		$this->oppo_robot_status_field = false;
		$this->bt_result_status_field = false;
		$this->bt_time_status_field = false;
		$this->history_id_status_field = false;

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

	public function /*int*/ getUserAvatar()
	{
		return $this->user_avatar;
	}
	
	public function /*void*/ setUserAvatar(/*int*/ $user_avatar)
	{
		$this->user_avatar = intval($user_avatar);
		$this->user_avatar_status_field = true;		
		$this->this_table_status_field = true;		
	}

	public function /*void*/ setUserAvatarNull()
	{
		$this->user_avatar = null;
		$this->user_avatar_status_field = true;		
		$this->this_table_status_field = true;
	}

	public function /*int*/ getUserLevel()
	{
		return $this->user_level;
	}
	
	public function /*void*/ setUserLevel(/*int*/ $user_level)
	{
		$this->user_level = intval($user_level);
		$this->user_level_status_field = true;		
		$this->this_table_status_field = true;		
	}

	public function /*void*/ setUserLevelNull()
	{
		$this->user_level = null;
		$this->user_level_status_field = true;		
		$this->this_table_status_field = true;
	}

	public function /*int*/ getUserRobot()
	{
		return $this->user_robot;
	}
	
	public function /*void*/ setUserRobot(/*int*/ $user_robot)
	{
		$this->user_robot = intval($user_robot);
		$this->user_robot_status_field = true;		
		$this->this_table_status_field = true;		
	}

	public function /*void*/ setUserRobotNull()
	{
		$this->user_robot = null;
		$this->user_robot_status_field = true;		
		$this->this_table_status_field = true;
	}

	public function /*string*/ getOppoId()
	{
		return $this->oppo_id;
	}
	
	public function /*void*/ setOppoId(/*string*/ $oppo_id)
	{
		$this->oppo_id = SQLUtil::toSafeSQLString($oppo_id);
		$this->oppo_id_status_field = true;		
		$this->this_table_status_field = true;		
	}

	public function /*void*/ setOppoIdNull()
	{
		$this->oppo_id = null;
		$this->oppo_id_status_field = true;		
		$this->this_table_status_field = true;
	}

	public function /*string*/ getOppoName()
	{
		return $this->oppo_name;
	}
	
	public function /*void*/ setOppoName(/*string*/ $oppo_name)
	{
		$this->oppo_name = SQLUtil::toSafeSQLString($oppo_name);
		$this->oppo_name_status_field = true;		
		$this->this_table_status_field = true;		
	}

	public function /*void*/ setOppoNameNull()
	{
		$this->oppo_name = null;
		$this->oppo_name_status_field = true;		
		$this->this_table_status_field = true;
	}

	public function /*int*/ getOppoAvatar()
	{
		return $this->oppo_avatar;
	}
	
	public function /*void*/ setOppoAvatar(/*int*/ $oppo_avatar)
	{
		$this->oppo_avatar = intval($oppo_avatar);
		$this->oppo_avatar_status_field = true;		
		$this->this_table_status_field = true;		
	}

	public function /*void*/ setOppoAvatarNull()
	{
		$this->oppo_avatar = null;
		$this->oppo_avatar_status_field = true;		
		$this->this_table_status_field = true;
	}

	public function /*int*/ getOppoLevel()
	{
		return $this->oppo_level;
	}
	
	public function /*void*/ setOppoLevel(/*int*/ $oppo_level)
	{
		$this->oppo_level = intval($oppo_level);
		$this->oppo_level_status_field = true;		
		$this->this_table_status_field = true;		
	}

	public function /*void*/ setOppoLevelNull()
	{
		$this->oppo_level = null;
		$this->oppo_level_status_field = true;		
		$this->this_table_status_field = true;
	}

	public function /*int*/ getOppoRobot()
	{
		return $this->oppo_robot;
	}
	
	public function /*void*/ setOppoRobot(/*int*/ $oppo_robot)
	{
		$this->oppo_robot = intval($oppo_robot);
		$this->oppo_robot_status_field = true;		
		$this->this_table_status_field = true;		
	}

	public function /*void*/ setOppoRobotNull()
	{
		$this->oppo_robot = null;
		$this->oppo_robot_status_field = true;		
		$this->this_table_status_field = true;
	}

	public function /*int*/ getBtResult()
	{
		return $this->bt_result;
	}
	
	public function /*void*/ setBtResult(/*int*/ $bt_result)
	{
		$this->bt_result = intval($bt_result);
		$this->bt_result_status_field = true;		
		$this->this_table_status_field = true;		
	}

	public function /*void*/ setBtResultNull()
	{
		$this->bt_result = null;
		$this->bt_result_status_field = true;		
		$this->this_table_status_field = true;
	}

	public function /*int*/ getBtTime()
	{
		return $this->bt_time;
	}
	
	public function /*void*/ setBtTime(/*int*/ $bt_time)
	{
		$this->bt_time = intval($bt_time);
		$this->bt_time_status_field = true;		
		$this->this_table_status_field = true;		
	}

	public function /*void*/ setBtTimeNull()
	{
		$this->bt_time = null;
		$this->bt_time_status_field = true;		
		$this->this_table_status_field = true;
	}

	public function /*string*/ getHistoryId()
	{
		return $this->history_id;
	}
	
	public function /*void*/ setHistoryId(/*string*/ $history_id)
	{
		$this->history_id = SQLUtil::toSafeSQLString($history_id);
		$this->history_id_status_field = true;		
		$this->this_table_status_field = true;		
	}

	public function /*void*/ setHistoryIdNull()
	{
		$this->history_id = null;
		$this->history_id_status_field = true;		
		$this->this_table_status_field = true;
	}

	
	public function /*string*/ toDebugString()
	{
		$dbg = "(";
		
		$dbg .= ("id={$this->id},");
		$dbg .= ("user_id={$this->user_id},");
		$dbg .= ("user_name={$this->user_name},");
		$dbg .= ("user_avatar={$this->user_avatar},");
		$dbg .= ("user_level={$this->user_level},");
		$dbg .= ("user_robot={$this->user_robot},");
		$dbg .= ("oppo_id={$this->oppo_id},");
		$dbg .= ("oppo_name={$this->oppo_name},");
		$dbg .= ("oppo_avatar={$this->oppo_avatar},");
		$dbg .= ("oppo_level={$this->oppo_level},");
		$dbg .= ("oppo_robot={$this->oppo_robot},");
		$dbg .= ("bt_result={$this->bt_result},");
		$dbg .= ("bt_time={$this->bt_time},");
		$dbg .= ("history_id={$this->history_id},");

		$dbg .= ")";
				
		return str_replace(",)",")",$dbg);
	}
}

?>
