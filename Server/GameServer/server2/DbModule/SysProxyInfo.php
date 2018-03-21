<?php
require_once ($GLOBALS ['GAME_ROOT'] . "CMySQL.php");
require_once ("SQLUtil.php");
/**
 *  [The generated files]
 */

class SysProxyInfo {
	
	private /*string*/ $proxy_id; //PRIMARY KEY 
	private /*string*/ $address;
	private /*int*/ $status;
	private /*int*/ $onlinenum;
	private /*string*/ $last_update_time;
	private /*string*/ $last_report_time;
	private /*int*/ $last_report_status;

	
	private $this_table_status_field = false;
	private $proxy_id_status_field = false;
	private $address_status_field = false;
	private $status_status_field = false;
	private $onlinenum_status_field = false;
	private $last_update_time_status_field = false;
	private $last_report_time_status_field = false;
	private $last_report_status_status_field = false;


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
			$sql = "SELECT {$p} FROM `proxy_info`";
		}
		else
		{			
			$sql = "SELECT {$p} FROM `proxy_info` WHERE ".SQLUtil::parseCondition($condition);
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
			$tb = new SysProxyInfo();			
			if (isset($row['proxy_id'])) $tb->proxy_id = $row['proxy_id'];
			if (isset($row['address'])) $tb->address = $row['address'];
			if (isset($row['status'])) $tb->status = intval($row['status']);
			if (isset($row['onlinenum'])) $tb->onlinenum = intval($row['onlinenum']);
			if (isset($row['last_update_time'])) $tb->last_update_time = $row['last_update_time'];
			if (isset($row['last_report_time'])) $tb->last_report_time = $row['last_report_time'];
			if (isset($row['last_report_status'])) $tb->last_report_status = intval($row['last_report_status']);
		
			$result[] = $tb;
		}
		
		return $result;
	}	
	
	public static function insertSqlHeader($fields=NULL)
	{
		$result = array();				
		if(!empty($fields)){
			$where = SQLUtil::parseFields($fields);			
			$result[0] = "INSERT INTO `proxy_info` ({$where}) VALUES ";	
			$ar = array();
			foreach($fields as $key){
				$ar[$key]=1;
			}
			$result[1] = $ar;
		}else{
			$result[0]="INSERT INTO `proxy_info` (`proxy_id`,`address`,`status`,`onlinenum`,`last_update_time`,`last_report_time`,`last_report_status`) VALUES ";
			$result[1] = array('proxy_id'=>1,'address'=>1,'status'=>1,'onlinenum'=>1,'last_update_time'=>1,'last_report_time'=>1,'last_report_status'=>1);
		}				
		return $result;
	}
		
	public function  loaded( $fields=NULL,$condition=NULL)
	{

		if (empty($condition) && empty($this->proxy_id))
		{
			return false;
		}
		
		$p = "*";
		$where = "`proxy_id` = '{$this->proxy_id}'";
		
		if(!empty($fields))
		{
			$p = SQLUtil::parseFields($fields);			
		}
	    if (!empty($condition))
		{
			$where =SQLUtil::parseCondition($condition);
		}
		
		$sql = "SELECT {$p} FROM `proxy_info` WHERE {$where}";

		MySQL::selectDefaultDb();
		$qr = MySQL::getInstance()->RunQuery($sql);
		$ar = MySQL::getInstance()->FetchArray($qr);
		
		if (!$ar || count($ar)==0)
		{
			return false;
		}
		
		if (isset($ar['proxy_id'])) $this->proxy_id = $ar['proxy_id'];
		if (isset($ar['address'])) $this->address = $ar['address'];
		if (isset($ar['status'])) $this->status = intval($ar['status']);
		if (isset($ar['onlinenum'])) $this->onlinenum = intval($ar['onlinenum']);
		if (isset($ar['last_update_time'])) $this->last_update_time = $ar['last_update_time'];
		if (isset($ar['last_report_time'])) $this->last_report_time = $ar['last_report_time'];
		if (isset($ar['last_report_status'])) $this->last_report_status = intval($ar['last_report_status']);
		
		
		$this->clean();
		
		return true;
	}
	
	
	public function  loadedCount( $fields=NULL,$condition=NULL)
	{
	
		if (empty($condition) && empty($this->proxy_id))
		{
			return false;
		}
	
		$p = "*";
		$where = "`proxy_id` = '{$this->proxy_id}'";
	
		if(!empty($fields))
		{
			$p = SQLUtil::parseFields($fields);
		}
		if (!empty($condition))
		{
			$where =SQLUtil::parseCondition($condition);
		}
	
		$sql = "SELECT {$p} FROM `proxy_info` WHERE {$where}";
	
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
    	
    	if (!isset($this->proxy_id)){
    		$emptyFields = false;
    		$fields[] = 'proxy_id';
    	}else{
    		$emptyCondition = false; 
    		$condition['proxy_id']=$this->proxy_id;
    	}
    	if (!isset($this->address)){
    		$emptyFields = false;
    		$fields[] = 'address';
    	}else{
    		$emptyCondition = false; 
    		$condition['address']=$this->address;
    	}
    	if (!isset($this->status)){
    		$emptyFields = false;
    		$fields[] = 'status';
    	}else{
    		$emptyCondition = false; 
    		$condition['status']=$this->status;
    	}
    	if (!isset($this->onlinenum)){
    		$emptyFields = false;
    		$fields[] = 'onlinenum';
    	}else{
    		$emptyCondition = false; 
    		$condition['onlinenum']=$this->onlinenum;
    	}
    	if (!isset($this->last_update_time)){
    		$emptyFields = false;
    		$fields[] = 'last_update_time';
    	}else{
    		$emptyCondition = false; 
    		$condition['last_update_time']=$this->last_update_time;
    	}
    	if (!isset($this->last_report_time)){
    		$emptyFields = false;
    		$fields[] = 'last_report_time';
    	}else{
    		$emptyCondition = false; 
    		$condition['last_report_time']=$this->last_report_time;
    	}
    	if (!isset($this->last_report_status)){
    		$emptyFields = false;
    		$fields[] = 'last_report_status';
    	}else{
    		$emptyCondition = false; 
    		$condition['last_report_status']=$this->last_report_status;
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
				
		if (empty($this->proxy_id))
		{
			$this->proxy_id = MySQL::getInstance()->GetInsertId();
		}		
		
		$this->clean();
		
		return true;	
		
	}
	
	public function save($condition=NULL)
	{
		if (empty($condition))
		{
			$uc = "`proxy_id`='{$this->proxy_id}'";
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
		
		$sql = "DELETE FROM `proxy_info` WHERE ".SQLUtil::parseCondition($condition);
		
		$qr = MySQL::getInstance()->RunQuery($sql);
				
		return (boolean)$qr;
	}
	
	public function  delete()
	{
		if (!isset($this->proxy_id))
		{
			return false;
		}
		
		$sql = "DELETE FROM `proxy_info` WHERE `proxy_id`='{$this->proxy_id}'";
		
		MySQL::selectDefaultDb();
		$qr = MySQL::getInstance()->RunQuery($sql);
				
		return (boolean)$qr;
	}
	
	public function getInsertValue($fields)
	{
		$values = "(";		
		foreach($fields as $f => $k){
			if($f == 'proxy_id'){
 				$values .= "'{$this->proxy_id}',";
 			}else if($f == 'address'){
 				$values .= "'{$this->address}',";
 			}else if($f == 'status'){
 				$values .= "'{$this->status}',";
 			}else if($f == 'onlinenum'){
 				$values .= "'{$this->onlinenum}',";
 			}else if($f == 'last_update_time'){
 				$values .= "'{$this->last_update_time}',";
 			}else if($f == 'last_report_time'){
 				$values .= "'{$this->last_report_time}',";
 			}else if($f == 'last_report_status'){
 				$values .= "'{$this->last_report_status}',";
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

		if (isset($this->proxy_id))
		{
			$fields .= "`proxy_id`,";
			$values .= "'{$this->proxy_id}',";
		}
		if (isset($this->address))
		{
			$fields .= "`address`,";
			$values .= "'{$this->address}',";
		}
		if (isset($this->status))
		{
			$fields .= "`status`,";
			$values .= "'{$this->status}',";
		}
		if (isset($this->onlinenum))
		{
			$fields .= "`onlinenum`,";
			$values .= "'{$this->onlinenum}',";
		}
		if (isset($this->last_update_time))
		{
			$fields .= "`last_update_time`,";
			$values .= "'{$this->last_update_time}',";
		}
		if (isset($this->last_report_time))
		{
			$fields .= "`last_report_time`,";
			$values .= "'{$this->last_report_time}',";
		}
		if (isset($this->last_report_status))
		{
			$fields .= "`last_report_status`,";
			$values .= "'{$this->last_report_status}',";
		}

		
		$fields .= ")";
		$values .= ")";
		
		$sql = "INSERT INTO `proxy_info` ".$fields.$values;
		
		return str_replace(",)",")",$sql);
	}
	
	private function  getUpFields()
	{
		$update = "";
		
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
		if ($this->status_status_field)
		{			
			if (!isset($this->status))
			{
				$update .= ("`status`=null,");
			}
			else
			{
				$update .= ("`status`='{$this->status}',");
			}
		}
		if ($this->onlinenum_status_field)
		{			
			if (!isset($this->onlinenum))
			{
				$update .= ("`onlinenum`=null,");
			}
			else
			{
				$update .= ("`onlinenum`='{$this->onlinenum}',");
			}
		}
		if ($this->last_update_time_status_field)
		{			
			if (!isset($this->last_update_time))
			{
				$update .= ("`last_update_time`=null,");
			}
			else
			{
				$update .= ("`last_update_time`='{$this->last_update_time}',");
			}
		}
		if ($this->last_report_time_status_field)
		{			
			if (!isset($this->last_report_time))
			{
				$update .= ("`last_report_time`=null,");
			}
			else
			{
				$update .= ("`last_report_time`='{$this->last_report_time}',");
			}
		}
		if ($this->last_report_status_status_field)
		{			
			if (!isset($this->last_report_status))
			{
				$update .= ("`last_report_status`=null,");
			}
			else
			{
				$update .= ("`last_report_status`='{$this->last_report_status}',");
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
		
		$sql = "UPDATE `proxy_info` SET {$update} WHERE {$condition}";
		
		return $sql;
	}
	
	public function  add($fieldsValue,$condition=NULL)
	{				
		if (empty($condition))
		{
			$uc = "`proxy_id`='{$this->proxy_id}'";
		}
		else
		{			
			$uc = SQLUtil::parseCondition($condition);
		}
		
		$update = SQLUtil::parseASFieldValues($fieldsValue);
		
		$sql = "UPDATE `proxy_info` SET {$update} WHERE {$uc}";
		
		MySQL::selectDefaultDb();
		$qr = MySQL::getInstance()->RunQuery($sql);
				
		return (boolean)$qr;
	}	
	
	public function sub($fieldsVal,$condition=NULL)
	{
		if (empty($condition))
		{
			$uc = "`proxy_id`='{$this->proxy_id}'";
		}
		else
		{			
			$uc = SQLUtil::parseCondition($condition);
		}
		
		$update = SQLUtil::parseASFieldValues($fieldsVal,false);
		
		$sql = "UPDATE `proxy_info` SET {$update} WHERE {$uc}";
		
		MySQL::selectDefaultDb();
		$qr = MySQL::getInstance()->RunQuery($sql);
				
		return (boolean)$qr;
	}
	
	private function /*void*/ clean() 
	{
		$this->this_table_status_field = false;
		$this->proxy_id_status_field = false;
		$this->address_status_field = false;
		$this->status_status_field = false;
		$this->onlinenum_status_field = false;
		$this->last_update_time_status_field = false;
		$this->last_report_time_status_field = false;
		$this->last_report_status_status_field = false;

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

	public function /*int*/ getStatus()
	{
		return $this->status;
	}
	
	public function /*void*/ setStatus(/*int*/ $status)
	{
		$this->status = intval($status);
		$this->status_status_field = true;		
		$this->this_table_status_field = true;		
	}

	public function /*void*/ setStatusNull()
	{
		$this->status = null;
		$this->status_status_field = true;		
		$this->this_table_status_field = true;
	}

	public function /*int*/ getOnlinenum()
	{
		return $this->onlinenum;
	}
	
	public function /*void*/ setOnlinenum(/*int*/ $onlinenum)
	{
		$this->onlinenum = intval($onlinenum);
		$this->onlinenum_status_field = true;		
		$this->this_table_status_field = true;		
	}

	public function /*void*/ setOnlinenumNull()
	{
		$this->onlinenum = null;
		$this->onlinenum_status_field = true;		
		$this->this_table_status_field = true;
	}

	public function /*string*/ getLastUpdateTime()
	{
		return $this->last_update_time;
	}
	
	public function /*void*/ setLastUpdateTime(/*string*/ $last_update_time)
	{
		$this->last_update_time = SQLUtil::toSafeSQLString($last_update_time);
		$this->last_update_time_status_field = true;		
		$this->this_table_status_field = true;		
	}

	public function /*void*/ setLastUpdateTimeNull()
	{
		$this->last_update_time = null;
		$this->last_update_time_status_field = true;		
		$this->this_table_status_field = true;
	}

	public function /*string*/ getLastReportTime()
	{
		return $this->last_report_time;
	}
	
	public function /*void*/ setLastReportTime(/*string*/ $last_report_time)
	{
		$this->last_report_time = SQLUtil::toSafeSQLString($last_report_time);
		$this->last_report_time_status_field = true;		
		$this->this_table_status_field = true;		
	}

	public function /*void*/ setLastReportTimeNull()
	{
		$this->last_report_time = null;
		$this->last_report_time_status_field = true;		
		$this->this_table_status_field = true;
	}

	public function /*int*/ getLastReportStatus()
	{
		return $this->last_report_status;
	}
	
	public function /*void*/ setLastReportStatus(/*int*/ $last_report_status)
	{
		$this->last_report_status = intval($last_report_status);
		$this->last_report_status_status_field = true;		
		$this->this_table_status_field = true;		
	}

	public function /*void*/ setLastReportStatusNull()
	{
		$this->last_report_status = null;
		$this->last_report_status_status_field = true;		
		$this->this_table_status_field = true;
	}

	
	public function /*string*/ toDebugString()
	{
		$dbg = "(";
		
		$dbg .= ("proxy_id={$this->proxy_id},");
		$dbg .= ("address={$this->address},");
		$dbg .= ("status={$this->status},");
		$dbg .= ("onlinenum={$this->onlinenum},");
		$dbg .= ("last_update_time={$this->last_update_time},");
		$dbg .= ("last_report_time={$this->last_report_time},");
		$dbg .= ("last_report_status={$this->last_report_status},");

		$dbg .= ")";
				
		return str_replace(",)",")",$dbg);
	}
}

?>
