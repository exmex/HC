<?php
require_once ($GLOBALS ['GAME_ROOT'] . "CMySQL.php");
require_once ("SQLUtil.php");
/**
 *  [The generated files]
 */

class SysDeviceId {
	
	private /*string*/ $device_id; //PRIMARY KEY 
	private /*string*/ $uuid;
	private /*string*/ $uin;
	private /*string*/ $reg_ip;
	private /*string*/ $last_login_ip;
	private /*int*/ $link_num;
	private /*int*/ $platform_id;

	
	private $this_table_status_field = false;
	private $device_id_status_field = false;
	private $uuid_status_field = false;
	private $uin_status_field = false;
	private $reg_ip_status_field = false;
	private $last_login_ip_status_field = false;
	private $link_num_status_field = false;
	private $platform_id_status_field = false;


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
			$sql = "SELECT {$p} FROM `device_id`";
		}
		else
		{			
			$sql = "SELECT {$p} FROM `device_id` WHERE ".SQLUtil::parseCondition($condition);
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
			$tb = new SysDeviceId();			
			if (isset($row['device_id'])) $tb->device_id = $row['device_id'];
			if (isset($row['uuid'])) $tb->uuid = $row['uuid'];
			if (isset($row['uin'])) $tb->uin = $row['uin'];
			if (isset($row['reg_ip'])) $tb->reg_ip = $row['reg_ip'];
			if (isset($row['last_login_ip'])) $tb->last_login_ip = $row['last_login_ip'];
			if (isset($row['link_num'])) $tb->link_num = intval($row['link_num']);
			if (isset($row['platform_id'])) $tb->platform_id = intval($row['platform_id']);
		
			$result[] = $tb;
		}
		
		return $result;
	}	
	
	public static function insertSqlHeader($fields=NULL)
	{
		$result = array();				
		if(!empty($fields)){
			$where = SQLUtil::parseFields($fields);			
			$result[0] = "INSERT INTO `device_id` ({$where}) VALUES ";	
			$ar = array();
			foreach($fields as $key){
				$ar[$key]=1;
			}
			$result[1] = $ar;
		}else{
			$result[0]="INSERT INTO `device_id` (`device_id`,`uuid`,`uin`,`reg_ip`,`last_login_ip`,`link_num`,`platform_id`) VALUES ";
			$result[1] = array('device_id'=>1,'uuid'=>1,'uin'=>1,'reg_ip'=>1,'last_login_ip'=>1,'link_num'=>1,'platform_id'=>1);
		}				
		return $result;
	}
		
	public function  loaded( $fields=NULL,$condition=NULL)
	{

		if (empty($condition) && empty($this->device_id))
		{
			return false;
		}
		
		$p = "*";
		$where = "`device_id` = '{$this->device_id}'";
		
		if(!empty($fields))
		{
			$p = SQLUtil::parseFields($fields);			
		}
	    if (!empty($condition))
		{
			$where =SQLUtil::parseCondition($condition);
		}
		
		$sql = "SELECT {$p} FROM `device_id` WHERE {$where}";

		MySQL::selectDefaultDb();
		$qr = MySQL::getInstance()->RunQuery($sql);
		$ar = MySQL::getInstance()->FetchArray($qr);
		
		if (!$ar || count($ar)==0)
		{
			return false;
		}
		
		if (isset($ar['device_id'])) $this->device_id = $ar['device_id'];
		if (isset($ar['uuid'])) $this->uuid = $ar['uuid'];
		if (isset($ar['uin'])) $this->uin = $ar['uin'];
		if (isset($ar['reg_ip'])) $this->reg_ip = $ar['reg_ip'];
		if (isset($ar['last_login_ip'])) $this->last_login_ip = $ar['last_login_ip'];
		if (isset($ar['link_num'])) $this->link_num = intval($ar['link_num']);
		if (isset($ar['platform_id'])) $this->platform_id = intval($ar['platform_id']);
		
		
		$this->clean();
		
		return true;
	}
	
	
	public function  loadedCount( $fields=NULL,$condition=NULL)
	{
	
		if (empty($condition) && empty($this->device_id))
		{
			return false;
		}
	
		$p = "*";
		$where = "`device_id` = '{$this->device_id}'";
	
		if(!empty($fields))
		{
			$p = SQLUtil::parseFields($fields);
		}
		if (!empty($condition))
		{
			$where =SQLUtil::parseCondition($condition);
		}
	
		$sql = "SELECT {$p} FROM `device_id` WHERE {$where}";
	
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
    	
    	if (!isset($this->device_id)){
    		$emptyFields = false;
    		$fields[] = 'device_id';
    	}else{
    		$emptyCondition = false; 
    		$condition['device_id']=$this->device_id;
    	}
    	if (!isset($this->uuid)){
    		$emptyFields = false;
    		$fields[] = 'uuid';
    	}else{
    		$emptyCondition = false; 
    		$condition['uuid']=$this->uuid;
    	}
    	if (!isset($this->uin)){
    		$emptyFields = false;
    		$fields[] = 'uin';
    	}else{
    		$emptyCondition = false; 
    		$condition['uin']=$this->uin;
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
    	if (!isset($this->link_num)){
    		$emptyFields = false;
    		$fields[] = 'link_num';
    	}else{
    		$emptyCondition = false; 
    		$condition['link_num']=$this->link_num;
    	}
    	if (!isset($this->platform_id)){
    		$emptyFields = false;
    		$fields[] = 'platform_id';
    	}else{
    		$emptyCondition = false; 
    		$condition['platform_id']=$this->platform_id;
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
				
		if (empty($this->device_id))
		{
			$this->device_id = MySQL::getInstance()->GetInsertId();
		}		
		
		$this->clean();
		
		return true;	
		
	}
	
	public function save($condition=NULL)
	{
		if (empty($condition))
		{
			$uc = "`device_id`='{$this->device_id}'";
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
		
		$sql = "DELETE FROM `device_id` WHERE ".SQLUtil::parseCondition($condition);
		
		$qr = MySQL::getInstance()->RunQuery($sql);
				
		return (boolean)$qr;
	}
	
	public function  delete()
	{
		if (!isset($this->device_id))
		{
			return false;
		}
		
		$sql = "DELETE FROM `device_id` WHERE `device_id`='{$this->device_id}'";
		
		MySQL::selectDefaultDb();
		$qr = MySQL::getInstance()->RunQuery($sql);
				
		return (boolean)$qr;
	}
	
	public function getInsertValue($fields)
	{
		$values = "(";		
		foreach($fields as $f => $k){
			if($f == 'device_id'){
 				$values .= "'{$this->device_id}',";
 			}else if($f == 'uuid'){
 				$values .= "'{$this->uuid}',";
 			}else if($f == 'uin'){
 				$values .= "'{$this->uin}',";
 			}else if($f == 'reg_ip'){
 				$values .= "'{$this->reg_ip}',";
 			}else if($f == 'last_login_ip'){
 				$values .= "'{$this->last_login_ip}',";
 			}else if($f == 'link_num'){
 				$values .= "'{$this->link_num}',";
 			}else if($f == 'platform_id'){
 				$values .= "'{$this->platform_id}',";
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

		if (isset($this->device_id))
		{
			$fields .= "`device_id`,";
			$values .= "'{$this->device_id}',";
		}
		if (isset($this->uuid))
		{
			$fields .= "`uuid`,";
			$values .= "'{$this->uuid}',";
		}
		if (isset($this->uin))
		{
			$fields .= "`uin`,";
			$values .= "'{$this->uin}',";
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
		if (isset($this->link_num))
		{
			$fields .= "`link_num`,";
			$values .= "'{$this->link_num}',";
		}
		if (isset($this->platform_id))
		{
			$fields .= "`platform_id`,";
			$values .= "'{$this->platform_id}',";
		}

		
		$fields .= ")";
		$values .= ")";
		
		$sql = "INSERT INTO `device_id` ".$fields.$values;
		
		return str_replace(",)",")",$sql);
	}
	
	private function  getUpFields()
	{
		$update = "";
		
		if ($this->uuid_status_field)
		{			
			if (!isset($this->uuid))
			{
				$update .= ("`uuid`=null,");
			}
			else
			{
				$update .= ("`uuid`='{$this->uuid}',");
			}
		}
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
		if ($this->link_num_status_field)
		{			
			if (!isset($this->link_num))
			{
				$update .= ("`link_num`=null,");
			}
			else
			{
				$update .= ("`link_num`='{$this->link_num}',");
			}
		}
		if ($this->platform_id_status_field)
		{			
			if (!isset($this->platform_id))
			{
				$update .= ("`platform_id`=null,");
			}
			else
			{
				$update .= ("`platform_id`='{$this->platform_id}',");
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
		
		$sql = "UPDATE `device_id` SET {$update} WHERE {$condition}";
		
		return $sql;
	}
	
	public function  add($fieldsValue,$condition=NULL)
	{				
		if (empty($condition))
		{
			$uc = "`device_id`='{$this->device_id}'";
		}
		else
		{			
			$uc = SQLUtil::parseCondition($condition);
		}
		
		$update = SQLUtil::parseASFieldValues($fieldsValue);
		
		$sql = "UPDATE `device_id` SET {$update} WHERE {$uc}";
		
		MySQL::selectDefaultDb();
		$qr = MySQL::getInstance()->RunQuery($sql);
				
		return (boolean)$qr;
	}	
	
	public function sub($fieldsVal,$condition=NULL)
	{
		if (empty($condition))
		{
			$uc = "`device_id`='{$this->device_id}'";
		}
		else
		{			
			$uc = SQLUtil::parseCondition($condition);
		}
		
		$update = SQLUtil::parseASFieldValues($fieldsVal,false);
		
		$sql = "UPDATE `device_id` SET {$update} WHERE {$uc}";
		
		MySQL::selectDefaultDb();
		$qr = MySQL::getInstance()->RunQuery($sql);
				
		return (boolean)$qr;
	}
	
	private function /*void*/ clean() 
	{
		$this->this_table_status_field = false;
		$this->device_id_status_field = false;
		$this->uuid_status_field = false;
		$this->uin_status_field = false;
		$this->reg_ip_status_field = false;
		$this->last_login_ip_status_field = false;
		$this->link_num_status_field = false;
		$this->platform_id_status_field = false;

	}
	
	public function /*string*/ getDeviceId()
	{
		return $this->device_id;
	}
	
	public function /*void*/ setDeviceId(/*string*/ $device_id)
	{
		$this->device_id = SQLUtil::toSafeSQLString($device_id);
		$this->device_id_status_field = true;		
		$this->this_table_status_field = true;		
	}

	public function /*void*/ setDeviceIdNull()
	{
		$this->device_id = null;
		$this->device_id_status_field = true;		
		$this->this_table_status_field = true;
	}

	public function /*string*/ getUuid()
	{
		return $this->uuid;
	}
	
	public function /*void*/ setUuid(/*string*/ $uuid)
	{
		$this->uuid = SQLUtil::toSafeSQLString($uuid);
		$this->uuid_status_field = true;		
		$this->this_table_status_field = true;		
	}

	public function /*void*/ setUuidNull()
	{
		$this->uuid = null;
		$this->uuid_status_field = true;		
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

	public function /*int*/ getLinkNum()
	{
		return $this->link_num;
	}
	
	public function /*void*/ setLinkNum(/*int*/ $link_num)
	{
		$this->link_num = intval($link_num);
		$this->link_num_status_field = true;		
		$this->this_table_status_field = true;		
	}

	public function /*void*/ setLinkNumNull()
	{
		$this->link_num = null;
		$this->link_num_status_field = true;		
		$this->this_table_status_field = true;
	}

	public function /*int*/ getPlatformId()
	{
		return $this->platform_id;
	}
	
	public function /*void*/ setPlatformId(/*int*/ $platform_id)
	{
		$this->platform_id = intval($platform_id);
		$this->platform_id_status_field = true;		
		$this->this_table_status_field = true;		
	}

	public function /*void*/ setPlatformIdNull()
	{
		$this->platform_id = null;
		$this->platform_id_status_field = true;		
		$this->this_table_status_field = true;
	}

	
	public function /*string*/ toDebugString()
	{
		$dbg = "(";
		
		$dbg .= ("device_id={$this->device_id},");
		$dbg .= ("uuid={$this->uuid},");
		$dbg .= ("uin={$this->uin},");
		$dbg .= ("reg_ip={$this->reg_ip},");
		$dbg .= ("last_login_ip={$this->last_login_ip},");
		$dbg .= ("link_num={$this->link_num},");
		$dbg .= ("platform_id={$this->platform_id},");

		$dbg .= ")";
				
		return str_replace(",)",")",$dbg);
	}
}

?>
