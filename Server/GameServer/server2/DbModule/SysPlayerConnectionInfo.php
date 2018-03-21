<?php
require_once ($GLOBALS ['GAME_ROOT'] . "CMySQL.php");
require_once ("SQLUtil.php");
/**
 *  [The generated files]
 */

class SysPlayerConnectionInfo {
	
	private /*string*/ $id; //PRIMARY KEY 
	private /*string*/ $user_id;
	private /*int*/ $server_id;
	private /*string*/ $account;
	private /*string*/ $proxy_id;
	private /*string*/ $socket_id;
	private /*int*/ $type;
	private /*int*/ $state;
	private /*string*/ $address;
	private /*string*/ $create_time;

	
	private $this_table_status_field = false;
	private $id_status_field = false;
	private $user_id_status_field = false;
	private $server_id_status_field = false;
	private $account_status_field = false;
	private $proxy_id_status_field = false;
	private $socket_id_status_field = false;
	private $type_status_field = false;
	private $state_status_field = false;
	private $address_status_field = false;
	private $create_time_status_field = false;


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
			$sql = "SELECT {$p} FROM `player_connection_info`";
		}
		else
		{			
			$sql = "SELECT {$p} FROM `player_connection_info` WHERE ".SQLUtil::parseCondition($condition);
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
			$tb = new SysPlayerConnectionInfo();			
			if (isset($row['id'])) $tb->id = $row['id'];
			if (isset($row['user_id'])) $tb->user_id = $row['user_id'];
			if (isset($row['server_id'])) $tb->server_id = intval($row['server_id']);
			if (isset($row['account'])) $tb->account = $row['account'];
			if (isset($row['proxy_id'])) $tb->proxy_id = $row['proxy_id'];
			if (isset($row['socket_id'])) $tb->socket_id = $row['socket_id'];
			if (isset($row['type'])) $tb->type = intval($row['type']);
			if (isset($row['state'])) $tb->state = intval($row['state']);
			if (isset($row['address'])) $tb->address = $row['address'];
			if (isset($row['create_time'])) $tb->create_time = $row['create_time'];
		
			$result[] = $tb;
		}
		
		return $result;
	}	
	
	public static function insertSqlHeader($fields=NULL)
	{
		$result = array();				
		if(!empty($fields)){
			$where = SQLUtil::parseFields($fields);			
			$result[0] = "INSERT INTO `player_connection_info` ({$where}) VALUES ";	
			$ar = array();
			foreach($fields as $key){
				$ar[$key]=1;
			}
			$result[1] = $ar;
		}else{
			$result[0]="INSERT INTO `player_connection_info` (`id`,`user_id`,`server_id`,`account`,`proxy_id`,`socket_id`,`type`,`state`,`address`,`create_time`) VALUES ";
			$result[1] = array('id'=>1,'user_id'=>1,'server_id'=>1,'account'=>1,'proxy_id'=>1,'socket_id'=>1,'type'=>1,'state'=>1,'address'=>1,'create_time'=>1);
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
		
		$sql = "SELECT {$p} FROM `player_connection_info` WHERE {$where}";

		if(isset($this->user_id)){MySQL::selectDbForUser($this->user_id);}else{MySQL::selectDbForUser($GLOBALS['USER_ID']);}
		$qr = MySQL::getInstance()->RunQuery($sql);
		$ar = MySQL::getInstance()->FetchArray($qr);
		
		if (!$ar || count($ar)==0)
		{
			return false;
		}
		
		if (isset($ar['id'])) $this->id = $ar['id'];
		if (isset($ar['user_id'])) $this->user_id = $ar['user_id'];
		if (isset($ar['server_id'])) $this->server_id = intval($ar['server_id']);
		if (isset($ar['account'])) $this->account = $ar['account'];
		if (isset($ar['proxy_id'])) $this->proxy_id = $ar['proxy_id'];
		if (isset($ar['socket_id'])) $this->socket_id = $ar['socket_id'];
		if (isset($ar['type'])) $this->type = intval($ar['type']);
		if (isset($ar['state'])) $this->state = intval($ar['state']);
		if (isset($ar['address'])) $this->address = $ar['address'];
		if (isset($ar['create_time'])) $this->create_time = $ar['create_time'];
		
		
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
	
		$sql = "SELECT {$p} FROM `player_connection_info` WHERE {$where}";
	
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
    	if (!isset($this->server_id)){
    		$emptyFields = false;
    		$fields[] = 'server_id';
    	}else{
    		$emptyCondition = false; 
    		$condition['server_id']=$this->server_id;
    	}
    	if (!isset($this->account)){
    		$emptyFields = false;
    		$fields[] = 'account';
    	}else{
    		$emptyCondition = false; 
    		$condition['account']=$this->account;
    	}
    	if (!isset($this->proxy_id)){
    		$emptyFields = false;
    		$fields[] = 'proxy_id';
    	}else{
    		$emptyCondition = false; 
    		$condition['proxy_id']=$this->proxy_id;
    	}
    	if (!isset($this->socket_id)){
    		$emptyFields = false;
    		$fields[] = 'socket_id';
    	}else{
    		$emptyCondition = false; 
    		$condition['socket_id']=$this->socket_id;
    	}
    	if (!isset($this->type)){
    		$emptyFields = false;
    		$fields[] = 'type';
    	}else{
    		$emptyCondition = false; 
    		$condition['type']=$this->type;
    	}
    	if (!isset($this->state)){
    		$emptyFields = false;
    		$fields[] = 'state';
    	}else{
    		$emptyCondition = false; 
    		$condition['state']=$this->state;
    	}
    	if (!isset($this->address)){
    		$emptyFields = false;
    		$fields[] = 'address';
    	}else{
    		$emptyCondition = false; 
    		$condition['address']=$this->address;
    	}
    	if (!isset($this->create_time)){
    		$emptyFields = false;
    		$fields[] = 'create_time';
    	}else{
    		$emptyCondition = false; 
    		$condition['create_time']=$this->create_time;
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
		
		$sql = "DELETE FROM `player_connection_info` WHERE ".SQLUtil::parseCondition($condition);
		
		$qr = MySQL::getInstance()->RunQuery($sql);
				
		return (boolean)$qr;
	}
	
	public function  delete()
	{
		if (!isset($this->id))
		{
			return false;
		}
		
		$sql = "DELETE FROM `player_connection_info` WHERE `id`='{$this->id}'";
		
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
 			}else if($f == 'server_id'){
 				$values .= "'{$this->server_id}',";
 			}else if($f == 'account'){
 				$values .= "'{$this->account}',";
 			}else if($f == 'proxy_id'){
 				$values .= "'{$this->proxy_id}',";
 			}else if($f == 'socket_id'){
 				$values .= "'{$this->socket_id}',";
 			}else if($f == 'type'){
 				$values .= "'{$this->type}',";
 			}else if($f == 'state'){
 				$values .= "'{$this->state}',";
 			}else if($f == 'address'){
 				$values .= "'{$this->address}',";
 			}else if($f == 'create_time'){
 				$values .= "'{$this->create_time}',";
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
		if (isset($this->server_id))
		{
			$fields .= "`server_id`,";
			$values .= "'{$this->server_id}',";
		}
		if (isset($this->account))
		{
			$fields .= "`account`,";
			$values .= "'{$this->account}',";
		}
		if (isset($this->proxy_id))
		{
			$fields .= "`proxy_id`,";
			$values .= "'{$this->proxy_id}',";
		}
		if (isset($this->socket_id))
		{
			$fields .= "`socket_id`,";
			$values .= "'{$this->socket_id}',";
		}
		if (isset($this->type))
		{
			$fields .= "`type`,";
			$values .= "'{$this->type}',";
		}
		if (isset($this->state))
		{
			$fields .= "`state`,";
			$values .= "'{$this->state}',";
		}
		if (isset($this->address))
		{
			$fields .= "`address`,";
			$values .= "'{$this->address}',";
		}
		if (isset($this->create_time))
		{
			$fields .= "`create_time`,";
			$values .= "'{$this->create_time}',";
		}

		
		$fields .= ")";
		$values .= ")";
		
		$sql = "INSERT INTO `player_connection_info` ".$fields.$values;
		
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
		if ($this->account_status_field)
		{			
			if (!isset($this->account))
			{
				$update .= ("`account`=null,");
			}
			else
			{
				$update .= ("`account`='{$this->account}',");
			}
		}
		if ($this->proxy_id_status_field)
		{			
			if (!isset($this->proxy_id))
			{
				$update .= ("`proxy_id`=null,");
			}
			else
			{
				$update .= ("`proxy_id`='{$this->proxy_id}',");
			}
		}
		if ($this->socket_id_status_field)
		{			
			if (!isset($this->socket_id))
			{
				$update .= ("`socket_id`=null,");
			}
			else
			{
				$update .= ("`socket_id`='{$this->socket_id}',");
			}
		}
		if ($this->type_status_field)
		{			
			if (!isset($this->type))
			{
				$update .= ("`type`=null,");
			}
			else
			{
				$update .= ("`type`='{$this->type}',");
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
		if ($this->address_status_field)
		{			
			if (!isset($this->address))
			{
				$update .= ("`address`=null,");
			}
			else
			{
				$update .= ("`address`='{$this->address}',");
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
		
		$sql = "UPDATE `player_connection_info` SET {$update} WHERE {$condition}";
		
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
		
		$sql = "UPDATE `player_connection_info` SET {$update} WHERE {$uc}";
		
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
		
		$sql = "UPDATE `player_connection_info` SET {$update} WHERE {$uc}";
		
		if(isset($this->user_id)){MySQL::selectDbForUser($this->user_id);}else{MySQL::selectDbForUser($GLOBALS['USER_ID']);}
		$qr = MySQL::getInstance()->RunQuery($sql);
				
		return (boolean)$qr;
	}
	
	private function /*void*/ clean() 
	{
		$this->this_table_status_field = false;
		$this->id_status_field = false;
		$this->user_id_status_field = false;
		$this->server_id_status_field = false;
		$this->account_status_field = false;
		$this->proxy_id_status_field = false;
		$this->socket_id_status_field = false;
		$this->type_status_field = false;
		$this->state_status_field = false;
		$this->address_status_field = false;
		$this->create_time_status_field = false;

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

	public function /*string*/ getAccount()
	{
		return $this->account;
	}
	
	public function /*void*/ setAccount(/*string*/ $account)
	{
		$this->account = SQLUtil::toSafeSQLString($account);
		$this->account_status_field = true;		
		$this->this_table_status_field = true;		
	}

	public function /*void*/ setAccountNull()
	{
		$this->account = null;
		$this->account_status_field = true;		
		$this->this_table_status_field = true;
	}

	public function /*string*/ getProxyId()
	{
		return $this->proxy_id;
	}
	
	public function /*void*/ setProxyId(/*string*/ $proxy_id)
	{
		$this->proxy_id = SQLUtil::toSafeSQLString($proxy_id);
		$this->proxy_id_status_field = true;		
		$this->this_table_status_field = true;		
	}

	public function /*void*/ setProxyIdNull()
	{
		$this->proxy_id = null;
		$this->proxy_id_status_field = true;		
		$this->this_table_status_field = true;
	}

	public function /*string*/ getSocketId()
	{
		return $this->socket_id;
	}
	
	public function /*void*/ setSocketId(/*string*/ $socket_id)
	{
		$this->socket_id = SQLUtil::toSafeSQLString($socket_id);
		$this->socket_id_status_field = true;		
		$this->this_table_status_field = true;		
	}

	public function /*void*/ setSocketIdNull()
	{
		$this->socket_id = null;
		$this->socket_id_status_field = true;		
		$this->this_table_status_field = true;
	}

	public function /*int*/ getType()
	{
		return $this->type;
	}
	
	public function /*void*/ setType(/*int*/ $type)
	{
		$this->type = intval($type);
		$this->type_status_field = true;		
		$this->this_table_status_field = true;		
	}

	public function /*void*/ setTypeNull()
	{
		$this->type = null;
		$this->type_status_field = true;		
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

	public function /*string*/ getAddress()
	{
		return $this->address;
	}
	
	public function /*void*/ setAddress(/*string*/ $address)
	{
		$this->address = SQLUtil::toSafeSQLString($address);
		$this->address_status_field = true;		
		$this->this_table_status_field = true;		
	}

	public function /*void*/ setAddressNull()
	{
		$this->address = null;
		$this->address_status_field = true;		
		$this->this_table_status_field = true;
	}

	public function /*string*/ getCreateTime()
	{
		return $this->create_time;
	}
	
	public function /*void*/ setCreateTime(/*string*/ $create_time)
	{
		$this->create_time = SQLUtil::toSafeSQLString($create_time);
		$this->create_time_status_field = true;		
		$this->this_table_status_field = true;		
	}

	public function /*void*/ setCreateTimeNull()
	{
		$this->create_time = null;
		$this->create_time_status_field = true;		
		$this->this_table_status_field = true;
	}

	
	public function /*string*/ toDebugString()
	{
		$dbg = "(";
		
		$dbg .= ("id={$this->id},");
		$dbg .= ("user_id={$this->user_id},");
		$dbg .= ("server_id={$this->server_id},");
		$dbg .= ("account={$this->account},");
		$dbg .= ("proxy_id={$this->proxy_id},");
		$dbg .= ("socket_id={$this->socket_id},");
		$dbg .= ("type={$this->type},");
		$dbg .= ("state={$this->state},");
		$dbg .= ("address={$this->address},");
		$dbg .= ("create_time={$this->create_time},");

		$dbg .= ")";
				
		return str_replace(",)",")",$dbg);
	}
}

?>
