<?php
require_once ($GLOBALS ['GAME_ROOT'] . "CMySQL.php");
require_once ("SQLUtil.php");
/**
 *  [The generated files]
 */

class SysCumulativeRecharge {
	
	private /*int*/ $id; //PRIMARY KEY 
	private /*int*/ $user_id; //用户id
	private /*int*/ $gem; //充值钻石
	private /*string*/ $updateTime; //更新时间
	private /*string*/ $status; //领取状态
	private /*string*/ $number; //领取次数
	private /*int*/ $version; //版本

	
	private $this_table_status_field = false;
	private $id_status_field = false;
	private $user_id_status_field = false;
	private $gem_status_field = false;
	private $updateTime_status_field = false;
	private $status_status_field = false;
	private $number_status_field = false;
	private $version_status_field = false;


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
			$sql = "SELECT {$p} FROM `cumulative_recharge`";
		}
		else
		{			
			$sql = "SELECT {$p} FROM `cumulative_recharge` WHERE ".SQLUtil::parseCondition($condition);
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
			$tb = new SysCumulativeRecharge();			
			if (isset($row['id'])) $tb->id = intval($row['id']);
			if (isset($row['user_id'])) $tb->user_id = intval($row['user_id']);
			if (isset($row['gem'])) $tb->gem = intval($row['gem']);
			if (isset($row['updateTime'])) $tb->updateTime = $row['updateTime'];
			if (isset($row['status'])) $tb->status = $row['status'];
			if (isset($row['number'])) $tb->number = $row['number'];
			if (isset($row['version'])) $tb->version = intval($row['version']);
		
			$result[] = $tb;
		}
		
		return $result;
	}	
	
	public static function insertSqlHeader($fields=NULL)
	{
		$result = array();				
		if(!empty($fields)){
			$where = SQLUtil::parseFields($fields);			
			$result[0] = "INSERT INTO `cumulative_recharge` ({$where}) VALUES ";	
			$ar = array();
			foreach($fields as $key){
				$ar[$key]=1;
			}
			$result[1] = $ar;
		}else{
			$result[0]="INSERT INTO `cumulative_recharge` (`id`,`user_id`,`gem`,`updateTime`,`status`,`number`,`version`) VALUES ";
			$result[1] = array('id'=>1,'user_id'=>1,'gem'=>1,'updateTime'=>1,'status'=>1,'number'=>1,'version'=>1);
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
		
		$sql = "SELECT {$p} FROM `cumulative_recharge` WHERE {$where}";

		MySQL::selectDefaultDb();
		$qr = MySQL::getInstance()->RunQuery($sql);
		$ar = MySQL::getInstance()->FetchArray($qr);
		
		if (!$ar || count($ar)==0)
		{
			return false;
		}
		
		if (isset($ar['id'])) $this->id = intval($ar['id']);
		if (isset($ar['user_id'])) $this->user_id = intval($ar['user_id']);
		if (isset($ar['gem'])) $this->gem = intval($ar['gem']);
		if (isset($ar['updateTime'])) $this->updateTime = $ar['updateTime'];
		if (isset($ar['status'])) $this->status = $ar['status'];
		if (isset($ar['number'])) $this->number = $ar['number'];
		if (isset($ar['version'])) $this->version = intval($ar['version']);
		
		
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
	
		$sql = "SELECT {$p} FROM `cumulative_recharge` WHERE {$where}";
	
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
    	if (!isset($this->gem)){
    		$emptyFields = false;
    		$fields[] = 'gem';
    	}else{
    		$emptyCondition = false; 
    		$condition['gem']=$this->gem;
    	}
    	if (!isset($this->updateTime)){
    		$emptyFields = false;
    		$fields[] = 'updateTime';
    	}else{
    		$emptyCondition = false; 
    		$condition['updateTime']=$this->updateTime;
    	}
    	if (!isset($this->status)){
    		$emptyFields = false;
    		$fields[] = 'status';
    	}else{
    		$emptyCondition = false; 
    		$condition['status']=$this->status;
    	}
    	if (!isset($this->number)){
    		$emptyFields = false;
    		$fields[] = 'number';
    	}else{
    		$emptyCondition = false; 
    		$condition['number']=$this->number;
    	}
    	if (!isset($this->version)){
    		$emptyFields = false;
    		$fields[] = 'version';
    	}else{
    		$emptyCondition = false; 
    		$condition['version']=$this->version;
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
		
		$sql = "DELETE FROM `cumulative_recharge` WHERE ".SQLUtil::parseCondition($condition);
		
		$qr = MySQL::getInstance()->RunQuery($sql);
				
		return (boolean)$qr;
	}
	
	public function  delete()
	{
		if (!isset($this->id))
		{
			return false;
		}
		
		$sql = "DELETE FROM `cumulative_recharge` WHERE `id`='{$this->id}'";
		
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
 			}else if($f == 'gem'){
 				$values .= "'{$this->gem}',";
 			}else if($f == 'updateTime'){
 				$values .= "'{$this->updateTime}',";
 			}else if($f == 'status'){
 				$values .= "'{$this->status}',";
 			}else if($f == 'number'){
 				$values .= "'{$this->number}',";
 			}else if($f == 'version'){
 				$values .= "'{$this->version}',";
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
		if (isset($this->gem))
		{
			$fields .= "`gem`,";
			$values .= "'{$this->gem}',";
		}
		if (isset($this->updateTime))
		{
			$fields .= "`updateTime`,";
			$values .= "'{$this->updateTime}',";
		}
		if (isset($this->status))
		{
			$fields .= "`status`,";
			$values .= "'{$this->status}',";
		}
		if (isset($this->number))
		{
			$fields .= "`number`,";
			$values .= "'{$this->number}',";
		}
		if (isset($this->version))
		{
			$fields .= "`version`,";
			$values .= "'{$this->version}',";
		}

		
		$fields .= ")";
		$values .= ")";
		
		$sql = "INSERT INTO `cumulative_recharge` ".$fields.$values;
		
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
		if ($this->gem_status_field)
		{			
			if (!isset($this->gem))
			{
				$update .= ("`gem`=null,");
			}
			else
			{
				$update .= ("`gem`='{$this->gem}',");
			}
		}
		if ($this->updateTime_status_field)
		{			
			if (!isset($this->updateTime))
			{
				$update .= ("`updateTime`=null,");
			}
			else
			{
				$update .= ("`updateTime`='{$this->updateTime}',");
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
		if ($this->number_status_field)
		{			
			if (!isset($this->number))
			{
				$update .= ("`number`=null,");
			}
			else
			{
				$update .= ("`number`='{$this->number}',");
			}
		}
		if ($this->version_status_field)
		{			
			if (!isset($this->version))
			{
				$update .= ("`version`=null,");
			}
			else
			{
				$update .= ("`version`='{$this->version}',");
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
		
		$sql = "UPDATE `cumulative_recharge` SET {$update} WHERE {$condition}";
		
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
		
		$sql = "UPDATE `cumulative_recharge` SET {$update} WHERE {$uc}";
		
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
		
		$sql = "UPDATE `cumulative_recharge` SET {$update} WHERE {$uc}";
		
		MySQL::selectDefaultDb();
		$qr = MySQL::getInstance()->RunQuery($sql);
				
		return (boolean)$qr;
	}
	
	private function /*void*/ clean() 
	{
		$this->this_table_status_field = false;
		$this->id_status_field = false;
		$this->user_id_status_field = false;
		$this->gem_status_field = false;
		$this->updateTime_status_field = false;
		$this->status_status_field = false;
		$this->number_status_field = false;
		$this->version_status_field = false;

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

	public function /*int*/ getUserId()
	{
		return $this->user_id;
	}
	
	public function /*void*/ setUserId(/*int*/ $user_id)
	{
		$this->user_id = intval($user_id);
		$this->user_id_status_field = true;		
		$this->this_table_status_field = true;		
	}

	public function /*void*/ setUserIdNull()
	{
		$this->user_id = null;
		$this->user_id_status_field = true;		
		$this->this_table_status_field = true;
	}

	public function /*int*/ getGem()
	{
		return $this->gem;
	}
	
	public function /*void*/ setGem(/*int*/ $gem)
	{
		$this->gem = intval($gem);
		$this->gem_status_field = true;		
		$this->this_table_status_field = true;		
	}

	public function /*void*/ setGemNull()
	{
		$this->gem = null;
		$this->gem_status_field = true;		
		$this->this_table_status_field = true;
	}

	public function /*string*/ getUpdateTime()
	{
		return $this->updateTime;
	}
	
	public function /*void*/ setUpdateTime(/*string*/ $updateTime)
	{
		$this->updateTime = SQLUtil::toSafeSQLString($updateTime);
		$this->updateTime_status_field = true;		
		$this->this_table_status_field = true;		
	}

	public function /*void*/ setUpdateTimeNull()
	{
		$this->updateTime = null;
		$this->updateTime_status_field = true;		
		$this->this_table_status_field = true;
	}

	public function /*string*/ getStatus()
	{
		return $this->status;
	}
	
	public function /*void*/ setStatus(/*string*/ $status)
	{
		$this->status = SQLUtil::toSafeSQLString($status);
		$this->status_status_field = true;		
		$this->this_table_status_field = true;		
	}

	public function /*void*/ setStatusNull()
	{
		$this->status = null;
		$this->status_status_field = true;		
		$this->this_table_status_field = true;
	}

	public function /*string*/ getNumber()
	{
		return $this->number;
	}
	
	public function /*void*/ setNumber(/*string*/ $number)
	{
		$this->number = SQLUtil::toSafeSQLString($number);
		$this->number_status_field = true;		
		$this->this_table_status_field = true;		
	}

	public function /*void*/ setNumberNull()
	{
		$this->number = null;
		$this->number_status_field = true;		
		$this->this_table_status_field = true;
	}

	public function /*int*/ getVersion()
	{
		return $this->version;
	}
	
	public function /*void*/ setVersion(/*int*/ $version)
	{
		$this->version = intval($version);
		$this->version_status_field = true;		
		$this->this_table_status_field = true;		
	}

	public function /*void*/ setVersionNull()
	{
		$this->version = null;
		$this->version_status_field = true;		
		$this->this_table_status_field = true;
	}

	
	public function /*string*/ toDebugString()
	{
		$dbg = "(";
		
		$dbg .= ("id={$this->id},");
		$dbg .= ("user_id={$this->user_id},");
		$dbg .= ("gem={$this->gem},");
		$dbg .= ("updateTime={$this->updateTime},");
		$dbg .= ("status={$this->status},");
		$dbg .= ("number={$this->number},");
		$dbg .= ("version={$this->version},");

		$dbg .= ")";
				
		return str_replace(",)",")",$dbg);
	}
}

?>
