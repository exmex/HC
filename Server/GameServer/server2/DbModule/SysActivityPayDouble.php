<?php
require_once ($GLOBALS ['GAME_ROOT'] . "CMySQL.php");
require_once ("SQLUtil.php");
/**
 *  [The generated files]
 */

class SysActivityPayDouble {
	
	private /*int*/ $id; //PRIMARY KEY 
	private /*int*/ $user_id;
	private /*int*/ $pay_times;
	private /*int*/ $createtime;
	private /*int*/ $updatetime;
	private /*int*/ $during_time;

	
	private $this_table_status_field = false;
	private $id_status_field = false;
	private $user_id_status_field = false;
	private $pay_times_status_field = false;
	private $createtime_status_field = false;
	private $updatetime_status_field = false;
	private $during_time_status_field = false;


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
			$sql = "SELECT {$p} FROM `activity_pay_double`";
		}
		else
		{			
			$sql = "SELECT {$p} FROM `activity_pay_double` WHERE ".SQLUtil::parseCondition($condition);
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
			$tb = new SysActivityPayDouble();			
			if (isset($row['id'])) $tb->id = intval($row['id']);
			if (isset($row['user_id'])) $tb->user_id = intval($row['user_id']);
			if (isset($row['pay_times'])) $tb->pay_times = intval($row['pay_times']);
			if (isset($row['createtime'])) $tb->createtime = intval($row['createtime']);
			if (isset($row['updatetime'])) $tb->updatetime = intval($row['updatetime']);
			if (isset($row['during_time'])) $tb->during_time = intval($row['during_time']);
		
			$result[] = $tb;
		}
		
		return $result;
	}	
	
	public static function insertSqlHeader($fields=NULL)
	{
		$result = array();				
		if(!empty($fields)){
			$where = SQLUtil::parseFields($fields);			
			$result[0] = "INSERT INTO `activity_pay_double` ({$where}) VALUES ";	
			$ar = array();
			foreach($fields as $key){
				$ar[$key]=1;
			}
			$result[1] = $ar;
		}else{
			$result[0]="INSERT INTO `activity_pay_double` (`id`,`user_id`,`pay_times`,`createtime`,`updatetime`,`during_time`) VALUES ";
			$result[1] = array('id'=>1,'user_id'=>1,'pay_times'=>1,'createtime'=>1,'updatetime'=>1,'during_time'=>1);
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
		
		$sql = "SELECT {$p} FROM `activity_pay_double` WHERE {$where}";

		MySQL::selectDefaultDb();
		$qr = MySQL::getInstance()->RunQuery($sql);
		$ar = MySQL::getInstance()->FetchArray($qr);
		
		if (!$ar || count($ar)==0)
		{
			return false;
		}
		
		if (isset($ar['id'])) $this->id = intval($ar['id']);
		if (isset($ar['user_id'])) $this->user_id = intval($ar['user_id']);
		if (isset($ar['pay_times'])) $this->pay_times = intval($ar['pay_times']);
		if (isset($ar['createtime'])) $this->createtime = intval($ar['createtime']);
		if (isset($ar['updatetime'])) $this->updatetime = intval($ar['updatetime']);
		if (isset($ar['during_time'])) $this->during_time = intval($ar['during_time']);
		
		
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
	
		$sql = "SELECT {$p} FROM `activity_pay_double` WHERE {$where}";
	
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
    	if (!isset($this->pay_times)){
    		$emptyFields = false;
    		$fields[] = 'pay_times';
    	}else{
    		$emptyCondition = false; 
    		$condition['pay_times']=$this->pay_times;
    	}
    	if (!isset($this->createtime)){
    		$emptyFields = false;
    		$fields[] = 'createtime';
    	}else{
    		$emptyCondition = false; 
    		$condition['createtime']=$this->createtime;
    	}
    	if (!isset($this->updatetime)){
    		$emptyFields = false;
    		$fields[] = 'updatetime';
    	}else{
    		$emptyCondition = false; 
    		$condition['updatetime']=$this->updatetime;
    	}
    	if (!isset($this->during_time)){
    		$emptyFields = false;
    		$fields[] = 'during_time';
    	}else{
    		$emptyCondition = false; 
    		$condition['during_time']=$this->during_time;
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
		
		$sql = "DELETE FROM `activity_pay_double` WHERE ".SQLUtil::parseCondition($condition);
		
		$qr = MySQL::getInstance()->RunQuery($sql);
				
		return (boolean)$qr;
	}
	
	public function  delete()
	{
		if (!isset($this->id))
		{
			return false;
		}
		
		$sql = "DELETE FROM `activity_pay_double` WHERE `id`='{$this->id}'";
		
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
 			}else if($f == 'pay_times'){
 				$values .= "'{$this->pay_times}',";
 			}else if($f == 'createtime'){
 				$values .= "'{$this->createtime}',";
 			}else if($f == 'updatetime'){
 				$values .= "'{$this->updatetime}',";
 			}else if($f == 'during_time'){
 				$values .= "'{$this->during_time}',";
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
		if (isset($this->pay_times))
		{
			$fields .= "`pay_times`,";
			$values .= "'{$this->pay_times}',";
		}
		if (isset($this->createtime))
		{
			$fields .= "`createtime`,";
			$values .= "'{$this->createtime}',";
		}
		if (isset($this->updatetime))
		{
			$fields .= "`updatetime`,";
			$values .= "'{$this->updatetime}',";
		}
		if (isset($this->during_time))
		{
			$fields .= "`during_time`,";
			$values .= "'{$this->during_time}',";
		}

		
		$fields .= ")";
		$values .= ")";
		
		$sql = "INSERT INTO `activity_pay_double` ".$fields.$values;
		
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
		if ($this->pay_times_status_field)
		{			
			if (!isset($this->pay_times))
			{
				$update .= ("`pay_times`=null,");
			}
			else
			{
				$update .= ("`pay_times`='{$this->pay_times}',");
			}
		}
		if ($this->createtime_status_field)
		{			
			if (!isset($this->createtime))
			{
				$update .= ("`createtime`=null,");
			}
			else
			{
				$update .= ("`createtime`='{$this->createtime}',");
			}
		}
		if ($this->updatetime_status_field)
		{			
			if (!isset($this->updatetime))
			{
				$update .= ("`updatetime`=null,");
			}
			else
			{
				$update .= ("`updatetime`='{$this->updatetime}',");
			}
		}
		if ($this->during_time_status_field)
		{			
			if (!isset($this->during_time))
			{
				$update .= ("`during_time`=null,");
			}
			else
			{
				$update .= ("`during_time`='{$this->during_time}',");
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
		
		$sql = "UPDATE `activity_pay_double` SET {$update} WHERE {$condition}";
		
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
		
		$sql = "UPDATE `activity_pay_double` SET {$update} WHERE {$uc}";
		
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
		
		$sql = "UPDATE `activity_pay_double` SET {$update} WHERE {$uc}";
		
		MySQL::selectDefaultDb();
		$qr = MySQL::getInstance()->RunQuery($sql);
				
		return (boolean)$qr;
	}
	
	private function /*void*/ clean() 
	{
		$this->this_table_status_field = false;
		$this->id_status_field = false;
		$this->user_id_status_field = false;
		$this->pay_times_status_field = false;
		$this->createtime_status_field = false;
		$this->updatetime_status_field = false;
		$this->during_time_status_field = false;

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

	public function /*int*/ getPayTimes()
	{
		return $this->pay_times;
	}
	
	public function /*void*/ setPayTimes(/*int*/ $pay_times)
	{
		$this->pay_times = intval($pay_times);
		$this->pay_times_status_field = true;		
		$this->this_table_status_field = true;		
	}

	public function /*void*/ setPayTimesNull()
	{
		$this->pay_times = null;
		$this->pay_times_status_field = true;		
		$this->this_table_status_field = true;
	}

	public function /*int*/ getCreatetime()
	{
		return $this->createtime;
	}
	
	public function /*void*/ setCreatetime(/*int*/ $createtime)
	{
		$this->createtime = intval($createtime);
		$this->createtime_status_field = true;		
		$this->this_table_status_field = true;		
	}

	public function /*void*/ setCreatetimeNull()
	{
		$this->createtime = null;
		$this->createtime_status_field = true;		
		$this->this_table_status_field = true;
	}

	public function /*int*/ getUpdatetime()
	{
		return $this->updatetime;
	}
	
	public function /*void*/ setUpdatetime(/*int*/ $updatetime)
	{
		$this->updatetime = intval($updatetime);
		$this->updatetime_status_field = true;		
		$this->this_table_status_field = true;		
	}

	public function /*void*/ setUpdatetimeNull()
	{
		$this->updatetime = null;
		$this->updatetime_status_field = true;		
		$this->this_table_status_field = true;
	}

	public function /*int*/ getDuringTime()
	{
		return $this->during_time;
	}
	
	public function /*void*/ setDuringTime(/*int*/ $during_time)
	{
		$this->during_time = intval($during_time);
		$this->during_time_status_field = true;		
		$this->this_table_status_field = true;		
	}

	public function /*void*/ setDuringTimeNull()
	{
		$this->during_time = null;
		$this->during_time_status_field = true;		
		$this->this_table_status_field = true;
	}

	
	public function /*string*/ toDebugString()
	{
		$dbg = "(";
		
		$dbg .= ("id={$this->id},");
		$dbg .= ("user_id={$this->user_id},");
		$dbg .= ("pay_times={$this->pay_times},");
		$dbg .= ("createtime={$this->createtime},");
		$dbg .= ("updatetime={$this->updatetime},");
		$dbg .= ("during_time={$this->during_time},");

		$dbg .= ")";
				
		return str_replace(",)",")",$dbg);
	}
}

?>
