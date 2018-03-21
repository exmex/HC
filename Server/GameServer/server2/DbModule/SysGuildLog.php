<?php
require_once ($GLOBALS ['GAME_ROOT'] . "CMySQL.php");
require_once ("SQLUtil.php");
/**
 *  [The generated files]
 */

class SysGuildLog {
	
	private /*int*/ $id; //PRIMARY KEY 
	private /*int*/ $logtime;
	private /*string*/ $message;
	private /*int*/ $guild_id;

	
	private $this_table_status_field = false;
	private $id_status_field = false;
	private $logtime_status_field = false;
	private $message_status_field = false;
	private $guild_id_status_field = false;


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
			$sql = "SELECT {$p} FROM `guild_log`";
		}
		else
		{			
			$sql = "SELECT {$p} FROM `guild_log` WHERE ".SQLUtil::parseCondition($condition);
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
			$tb = new SysGuildLog();			
			if (isset($row['id'])) $tb->id = intval($row['id']);
			if (isset($row['logtime'])) $tb->logtime = intval($row['logtime']);
			if (isset($row['message'])) $tb->message = $row['message'];
			if (isset($row['guild_id'])) $tb->guild_id = intval($row['guild_id']);
		
			$result[] = $tb;
		}
		
		return $result;
	}	
	
	public static function insertSqlHeader($fields=NULL)
	{
		$result = array();				
		if(!empty($fields)){
			$where = SQLUtil::parseFields($fields);			
			$result[0] = "INSERT INTO `guild_log` ({$where}) VALUES ";	
			$ar = array();
			foreach($fields as $key){
				$ar[$key]=1;
			}
			$result[1] = $ar;
		}else{
			$result[0]="INSERT INTO `guild_log` (`id`,`logtime`,`message`,`guild_id`) VALUES ";
			$result[1] = array('id'=>1,'logtime'=>1,'message'=>1,'guild_id'=>1);
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
		
		$sql = "SELECT {$p} FROM `guild_log` WHERE {$where}";

		MySQL::selectDefaultDb();
		$qr = MySQL::getInstance()->RunQuery($sql);
		$ar = MySQL::getInstance()->FetchArray($qr);
		
		if (!$ar || count($ar)==0)
		{
			return false;
		}
		
		if (isset($ar['id'])) $this->id = intval($ar['id']);
		if (isset($ar['logtime'])) $this->logtime = intval($ar['logtime']);
		if (isset($ar['message'])) $this->message = $ar['message'];
		if (isset($ar['guild_id'])) $this->guild_id = intval($ar['guild_id']);
		
		
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
	
		$sql = "SELECT {$p} FROM `guild_log` WHERE {$where}";
	
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
    	if (!isset($this->logtime)){
    		$emptyFields = false;
    		$fields[] = 'logtime';
    	}else{
    		$emptyCondition = false; 
    		$condition['logtime']=$this->logtime;
    	}
    	if (!isset($this->message)){
    		$emptyFields = false;
    		$fields[] = 'message';
    	}else{
    		$emptyCondition = false; 
    		$condition['message']=$this->message;
    	}
    	if (!isset($this->guild_id)){
    		$emptyFields = false;
    		$fields[] = 'guild_id';
    	}else{
    		$emptyCondition = false; 
    		$condition['guild_id']=$this->guild_id;
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
		
		$sql = "DELETE FROM `guild_log` WHERE ".SQLUtil::parseCondition($condition);
		
		$qr = MySQL::getInstance()->RunQuery($sql);
				
		return (boolean)$qr;
	}
	
	public function  delete()
	{
		if (!isset($this->id))
		{
			return false;
		}
		
		$sql = "DELETE FROM `guild_log` WHERE `id`='{$this->id}'";
		
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
 			}else if($f == 'logtime'){
 				$values .= "'{$this->logtime}',";
 			}else if($f == 'message'){
 				$values .= "'{$this->message}',";
 			}else if($f == 'guild_id'){
 				$values .= "'{$this->guild_id}',";
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
		if (isset($this->logtime))
		{
			$fields .= "`logtime`,";
			$values .= "'{$this->logtime}',";
		}
		if (isset($this->message))
		{
			$fields .= "`message`,";
			$values .= "'{$this->message}',";
		}
		if (isset($this->guild_id))
		{
			$fields .= "`guild_id`,";
			$values .= "'{$this->guild_id}',";
		}

		
		$fields .= ")";
		$values .= ")";
		
		$sql = "INSERT INTO `guild_log` ".$fields.$values;
		
		return str_replace(",)",")",$sql);
	}
	
	private function  getUpFields()
	{
		$update = "";
		
		if ($this->logtime_status_field)
		{			
			if (!isset($this->logtime))
			{
				$update .= ("`logtime`=null,");
			}
			else
			{
				$update .= ("`logtime`='{$this->logtime}',");
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
		
		$sql = "UPDATE `guild_log` SET {$update} WHERE {$condition}";
		
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
		
		$sql = "UPDATE `guild_log` SET {$update} WHERE {$uc}";
		
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
		
		$sql = "UPDATE `guild_log` SET {$update} WHERE {$uc}";
		
		MySQL::selectDefaultDb();
		$qr = MySQL::getInstance()->RunQuery($sql);
				
		return (boolean)$qr;
	}
	
	private function /*void*/ clean() 
	{
		$this->this_table_status_field = false;
		$this->id_status_field = false;
		$this->logtime_status_field = false;
		$this->message_status_field = false;
		$this->guild_id_status_field = false;

	}
	
	public function /*int*/ getId()
	{
		return $this->id;
	}
	
	public function /*void*/ setId(/*int*/ $id)
	{
		$this->id = intval($id);
		$this->id_status_field = true;		
		$this->this_table_status_field = true;		
	}

	public function /*void*/ setIdNull()
	{
		$this->id = null;
		$this->id_status_field = true;		
		$this->this_table_status_field = true;
	}

	public function /*int*/ getLogtime()
	{
		return $this->logtime;
	}
	
	public function /*void*/ setLogtime(/*int*/ $logtime)
	{
		$this->logtime = intval($logtime);
		$this->logtime_status_field = true;		
		$this->this_table_status_field = true;		
	}

	public function /*void*/ setLogtimeNull()
	{
		$this->logtime = null;
		$this->logtime_status_field = true;		
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

	public function /*int*/ getGuildId()
	{
		return $this->guild_id;
	}
	
	public function /*void*/ setGuildId(/*int*/ $guild_id)
	{
		$this->guild_id = intval($guild_id);
		$this->guild_id_status_field = true;		
		$this->this_table_status_field = true;		
	}

	public function /*void*/ setGuildIdNull()
	{
		$this->guild_id = null;
		$this->guild_id_status_field = true;		
		$this->this_table_status_field = true;
	}

	
	public function /*string*/ toDebugString()
	{
		$dbg = "(";
		
		$dbg .= ("id={$this->id},");
		$dbg .= ("logtime={$this->logtime},");
		$dbg .= ("message={$this->message},");
		$dbg .= ("guild_id={$this->guild_id},");

		$dbg .= ")";
				
		return str_replace(",)",")",$dbg);
	}
}

?>
