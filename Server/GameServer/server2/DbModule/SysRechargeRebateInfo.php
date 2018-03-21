<?php
require_once ($GLOBALS ['GAME_ROOT'] . "CMySQL.php");
require_once ("SQLUtil.php");
/**
 *  [The generated files]
 */

class SysRechargeRebateInfo {
	
	private /*string*/ $id; //PRIMARY KEY 
	private /*string*/ $user_id;
	private /*int*/ $get_count;
	private /*int*/ $star_time;
	private /*string*/ $query_time;

	
	private $this_table_status_field = false;
	private $id_status_field = false;
	private $user_id_status_field = false;
	private $get_count_status_field = false;
	private $star_time_status_field = false;
	private $query_time_status_field = false;


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
			$sql = "SELECT {$p} FROM `recharge_rebate_info`";
		}
		else
		{			
			$sql = "SELECT {$p} FROM `recharge_rebate_info` WHERE ".SQLUtil::parseCondition($condition);
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
			$tb = new SysRechargeRebateInfo();			
			if (isset($row['id'])) $tb->id = $row['id'];
			if (isset($row['user_id'])) $tb->user_id = $row['user_id'];
			if (isset($row['get_count'])) $tb->get_count = intval($row['get_count']);
			if (isset($row['star_time'])) $tb->star_time = intval($row['star_time']);
			if (isset($row['query_time'])) $tb->query_time = $row['query_time'];
		
			$result[] = $tb;
		}
		
		return $result;
	}	
	
	public static function insertSqlHeader($fields=NULL)
	{
		$result = array();				
		if(!empty($fields)){
			$where = SQLUtil::parseFields($fields);			
			$result[0] = "INSERT INTO `recharge_rebate_info` ({$where}) VALUES ";	
			$ar = array();
			foreach($fields as $key){
				$ar[$key]=1;
			}
			$result[1] = $ar;
		}else{
			$result[0]="INSERT INTO `recharge_rebate_info` (`id`,`user_id`,`get_count`,`star_time`,`query_time`) VALUES ";
			$result[1] = array('id'=>1,'user_id'=>1,'get_count'=>1,'star_time'=>1,'query_time'=>1);
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
		
		$sql = "SELECT {$p} FROM `recharge_rebate_info` WHERE {$where}";

		MySQL::selectDefaultDb();
		$qr = MySQL::getInstance()->RunQuery($sql);
		$ar = MySQL::getInstance()->FetchArray($qr);
		
		if (!$ar || count($ar)==0)
		{
			return false;
		}
		
		if (isset($ar['id'])) $this->id = $ar['id'];
		if (isset($ar['user_id'])) $this->user_id = $ar['user_id'];
		if (isset($ar['get_count'])) $this->get_count = intval($ar['get_count']);
		if (isset($ar['star_time'])) $this->star_time = intval($ar['star_time']);
		if (isset($ar['query_time'])) $this->query_time = $ar['query_time'];
		
		
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
	
		$sql = "SELECT {$p} FROM `recharge_rebate_info` WHERE {$where}";
	
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
    	if (!isset($this->get_count)){
    		$emptyFields = false;
    		$fields[] = 'get_count';
    	}else{
    		$emptyCondition = false; 
    		$condition['get_count']=$this->get_count;
    	}
    	if (!isset($this->star_time)){
    		$emptyFields = false;
    		$fields[] = 'star_time';
    	}else{
    		$emptyCondition = false; 
    		$condition['star_time']=$this->star_time;
    	}
    	if (!isset($this->query_time)){
    		$emptyFields = false;
    		$fields[] = 'query_time';
    	}else{
    		$emptyCondition = false; 
    		$condition['query_time']=$this->query_time;
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
		
		$sql = "DELETE FROM `recharge_rebate_info` WHERE ".SQLUtil::parseCondition($condition);
		
		$qr = MySQL::getInstance()->RunQuery($sql);
				
		return (boolean)$qr;
	}
	
	public function  delete()
	{
		if (!isset($this->id))
		{
			return false;
		}
		
		$sql = "DELETE FROM `recharge_rebate_info` WHERE `id`='{$this->id}'";
		
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
 			}else if($f == 'get_count'){
 				$values .= "'{$this->get_count}',";
 			}else if($f == 'star_time'){
 				$values .= "'{$this->star_time}',";
 			}else if($f == 'query_time'){
 				$values .= "'{$this->query_time}',";
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
		if (isset($this->get_count))
		{
			$fields .= "`get_count`,";
			$values .= "'{$this->get_count}',";
		}
		if (isset($this->star_time))
		{
			$fields .= "`star_time`,";
			$values .= "'{$this->star_time}',";
		}
		if (isset($this->query_time))
		{
			$fields .= "`query_time`,";
			$values .= "'{$this->query_time}',";
		}

		
		$fields .= ")";
		$values .= ")";
		
		$sql = "INSERT INTO `recharge_rebate_info` ".$fields.$values;
		
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
		if ($this->get_count_status_field)
		{			
			if (!isset($this->get_count))
			{
				$update .= ("`get_count`=null,");
			}
			else
			{
				$update .= ("`get_count`='{$this->get_count}',");
			}
		}
		if ($this->star_time_status_field)
		{			
			if (!isset($this->star_time))
			{
				$update .= ("`star_time`=null,");
			}
			else
			{
				$update .= ("`star_time`='{$this->star_time}',");
			}
		}
		if ($this->query_time_status_field)
		{			
			if (!isset($this->query_time))
			{
				$update .= ("`query_time`=null,");
			}
			else
			{
				$update .= ("`query_time`='{$this->query_time}',");
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
		
		$sql = "UPDATE `recharge_rebate_info` SET {$update} WHERE {$condition}";
		
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
		
		$sql = "UPDATE `recharge_rebate_info` SET {$update} WHERE {$uc}";
		
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
		
		$sql = "UPDATE `recharge_rebate_info` SET {$update} WHERE {$uc}";
		
		MySQL::selectDefaultDb();
		$qr = MySQL::getInstance()->RunQuery($sql);
				
		return (boolean)$qr;
	}
	
	private function /*void*/ clean() 
	{
		$this->this_table_status_field = false;
		$this->id_status_field = false;
		$this->user_id_status_field = false;
		$this->get_count_status_field = false;
		$this->star_time_status_field = false;
		$this->query_time_status_field = false;

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

	public function /*int*/ getGetCount()
	{
		return $this->get_count;
	}
	
	public function /*void*/ setGetCount(/*int*/ $get_count)
	{
		$this->get_count = intval($get_count);
		$this->get_count_status_field = true;		
		$this->this_table_status_field = true;		
	}

	public function /*void*/ setGetCountNull()
	{
		$this->get_count = null;
		$this->get_count_status_field = true;		
		$this->this_table_status_field = true;
	}

	public function /*int*/ getStarTime()
	{
		return $this->star_time;
	}
	
	public function /*void*/ setStarTime(/*int*/ $star_time)
	{
		$this->star_time = intval($star_time);
		$this->star_time_status_field = true;		
		$this->this_table_status_field = true;		
	}

	public function /*void*/ setStarTimeNull()
	{
		$this->star_time = null;
		$this->star_time_status_field = true;		
		$this->this_table_status_field = true;
	}

	public function /*string*/ getQueryTime()
	{
		return $this->query_time;
	}
	
	public function /*void*/ setQueryTime(/*string*/ $query_time)
	{
		$this->query_time = SQLUtil::toSafeSQLString($query_time);
		$this->query_time_status_field = true;		
		$this->this_table_status_field = true;		
	}

	public function /*void*/ setQueryTimeNull()
	{
		$this->query_time = null;
		$this->query_time_status_field = true;		
		$this->this_table_status_field = true;
	}

	
	public function /*string*/ toDebugString()
	{
		$dbg = "(";
		
		$dbg .= ("id={$this->id},");
		$dbg .= ("user_id={$this->user_id},");
		$dbg .= ("get_count={$this->get_count},");
		$dbg .= ("star_time={$this->star_time},");
		$dbg .= ("query_time={$this->query_time},");

		$dbg .= ")";
				
		return str_replace(",)",")",$dbg);
	}
}

?>
