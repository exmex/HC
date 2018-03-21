<?php
require_once ($GLOBALS ['GAME_ROOT'] . "CMySQL.php");
require_once ("SQLUtil.php");
/**
 *  [The generated files]
 */

class SysPlayerMonthCard {
	
	private /*string*/ $id; //PRIMARY KEY 
	private /*string*/ $user_id;
	private /*int*/ $start_time;
	private /*int*/ $end_time;
	private /*int*/ $update_time;
	private /*int*/ $update_num;
	private /*int*/ $transaction_type;

	
	private $this_table_status_field = false;
	private $id_status_field = false;
	private $user_id_status_field = false;
	private $start_time_status_field = false;
	private $end_time_status_field = false;
	private $update_time_status_field = false;
	private $update_num_status_field = false;
	private $transaction_type_status_field = false;


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
			$sql = "SELECT {$p} FROM `player_month_card`";
		}
		else
		{			
			$sql = "SELECT {$p} FROM `player_month_card` WHERE ".SQLUtil::parseCondition($condition);
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
			$tb = new SysPlayerMonthCard();			
			if (isset($row['id'])) $tb->id = $row['id'];
			if (isset($row['user_id'])) $tb->user_id = $row['user_id'];
			if (isset($row['start_time'])) $tb->start_time = intval($row['start_time']);
			if (isset($row['end_time'])) $tb->end_time = intval($row['end_time']);
			if (isset($row['update_time'])) $tb->update_time = intval($row['update_time']);
			if (isset($row['update_num'])) $tb->update_num = intval($row['update_num']);
			if (isset($row['transaction_type'])) $tb->transaction_type = intval($row['transaction_type']);
		
			$result[] = $tb;
		}
		
		return $result;
	}	
	
	public static function insertSqlHeader($fields=NULL)
	{
		$result = array();				
		if(!empty($fields)){
			$where = SQLUtil::parseFields($fields);			
			$result[0] = "INSERT INTO `player_month_card` ({$where}) VALUES ";	
			$ar = array();
			foreach($fields as $key){
				$ar[$key]=1;
			}
			$result[1] = $ar;
		}else{
			$result[0]="INSERT INTO `player_month_card` (`id`,`user_id`,`start_time`,`end_time`,`update_time`,`update_num`,`transaction_type`) VALUES ";
			$result[1] = array('id'=>1,'user_id'=>1,'start_time'=>1,'end_time'=>1,'update_time'=>1,'update_num'=>1,'transaction_type'=>1);
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
		
		$sql = "SELECT {$p} FROM `player_month_card` WHERE {$where}";

		if(isset($this->user_id)){MySQL::selectDbForUser($this->user_id);}else{MySQL::selectDbForUser($GLOBALS['USER_ID']);}
		$qr = MySQL::getInstance()->RunQuery($sql);
		$ar = MySQL::getInstance()->FetchArray($qr);
		
		if (!$ar || count($ar)==0)
		{
			return false;
		}
		
		if (isset($ar['id'])) $this->id = $ar['id'];
		if (isset($ar['user_id'])) $this->user_id = $ar['user_id'];
		if (isset($ar['start_time'])) $this->start_time = intval($ar['start_time']);
		if (isset($ar['end_time'])) $this->end_time = intval($ar['end_time']);
		if (isset($ar['update_time'])) $this->update_time = intval($ar['update_time']);
		if (isset($ar['update_num'])) $this->update_num = intval($ar['update_num']);
		if (isset($ar['transaction_type'])) $this->transaction_type = intval($ar['transaction_type']);
		
		
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
	
		$sql = "SELECT {$p} FROM `player_month_card` WHERE {$where}";
	
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
    	if (!isset($this->start_time)){
    		$emptyFields = false;
    		$fields[] = 'start_time';
    	}else{
    		$emptyCondition = false; 
    		$condition['start_time']=$this->start_time;
    	}
    	if (!isset($this->end_time)){
    		$emptyFields = false;
    		$fields[] = 'end_time';
    	}else{
    		$emptyCondition = false; 
    		$condition['end_time']=$this->end_time;
    	}
    	if (!isset($this->update_time)){
    		$emptyFields = false;
    		$fields[] = 'update_time';
    	}else{
    		$emptyCondition = false; 
    		$condition['update_time']=$this->update_time;
    	}
    	if (!isset($this->update_num)){
    		$emptyFields = false;
    		$fields[] = 'update_num';
    	}else{
    		$emptyCondition = false; 
    		$condition['update_num']=$this->update_num;
    	}
    	if (!isset($this->transaction_type)){
    		$emptyFields = false;
    		$fields[] = 'transaction_type';
    	}else{
    		$emptyCondition = false; 
    		$condition['transaction_type']=$this->transaction_type;
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
		
		$sql = "DELETE FROM `player_month_card` WHERE ".SQLUtil::parseCondition($condition);
		
		$qr = MySQL::getInstance()->RunQuery($sql);
				
		return (boolean)$qr;
	}
	
	public function  delete()
	{
		if (!isset($this->id))
		{
			return false;
		}
		
		$sql = "DELETE FROM `player_month_card` WHERE `id`='{$this->id}'";
		
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
 			}else if($f == 'start_time'){
 				$values .= "'{$this->start_time}',";
 			}else if($f == 'end_time'){
 				$values .= "'{$this->end_time}',";
 			}else if($f == 'update_time'){
 				$values .= "'{$this->update_time}',";
 			}else if($f == 'update_num'){
 				$values .= "'{$this->update_num}',";
 			}else if($f == 'transaction_type'){
 				$values .= "'{$this->transaction_type}',";
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
		if (isset($this->start_time))
		{
			$fields .= "`start_time`,";
			$values .= "'{$this->start_time}',";
		}
		if (isset($this->end_time))
		{
			$fields .= "`end_time`,";
			$values .= "'{$this->end_time}',";
		}
		if (isset($this->update_time))
		{
			$fields .= "`update_time`,";
			$values .= "'{$this->update_time}',";
		}
		if (isset($this->update_num))
		{
			$fields .= "`update_num`,";
			$values .= "'{$this->update_num}',";
		}
		if (isset($this->transaction_type))
		{
			$fields .= "`transaction_type`,";
			$values .= "'{$this->transaction_type}',";
		}

		
		$fields .= ")";
		$values .= ")";
		
		$sql = "INSERT INTO `player_month_card` ".$fields.$values;
		
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
		if ($this->start_time_status_field)
		{			
			if (!isset($this->start_time))
			{
				$update .= ("`start_time`=null,");
			}
			else
			{
				$update .= ("`start_time`='{$this->start_time}',");
			}
		}
		if ($this->end_time_status_field)
		{			
			if (!isset($this->end_time))
			{
				$update .= ("`end_time`=null,");
			}
			else
			{
				$update .= ("`end_time`='{$this->end_time}',");
			}
		}
		if ($this->update_time_status_field)
		{			
			if (!isset($this->update_time))
			{
				$update .= ("`update_time`=null,");
			}
			else
			{
				$update .= ("`update_time`='{$this->update_time}',");
			}
		}
		if ($this->update_num_status_field)
		{			
			if (!isset($this->update_num))
			{
				$update .= ("`update_num`=null,");
			}
			else
			{
				$update .= ("`update_num`='{$this->update_num}',");
			}
		}
		if ($this->transaction_type_status_field)
		{			
			if (!isset($this->transaction_type))
			{
				$update .= ("`transaction_type`=null,");
			}
			else
			{
				$update .= ("`transaction_type`='{$this->transaction_type}',");
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
		
		$sql = "UPDATE `player_month_card` SET {$update} WHERE {$condition}";
		
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
		
		$sql = "UPDATE `player_month_card` SET {$update} WHERE {$uc}";
		
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
		
		$sql = "UPDATE `player_month_card` SET {$update} WHERE {$uc}";
		
		if(isset($this->user_id)){MySQL::selectDbForUser($this->user_id);}else{MySQL::selectDbForUser($GLOBALS['USER_ID']);}
		$qr = MySQL::getInstance()->RunQuery($sql);
				
		return (boolean)$qr;
	}
	
	private function /*void*/ clean() 
	{
		$this->this_table_status_field = false;
		$this->id_status_field = false;
		$this->user_id_status_field = false;
		$this->start_time_status_field = false;
		$this->end_time_status_field = false;
		$this->update_time_status_field = false;
		$this->update_num_status_field = false;
		$this->transaction_type_status_field = false;

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

	public function /*int*/ getStartTime()
	{
		return $this->start_time;
	}
	
	public function /*void*/ setStartTime(/*int*/ $start_time)
	{
		$this->start_time = intval($start_time);
		$this->start_time_status_field = true;		
		$this->this_table_status_field = true;		
	}

	public function /*void*/ setStartTimeNull()
	{
		$this->start_time = null;
		$this->start_time_status_field = true;		
		$this->this_table_status_field = true;
	}

	public function /*int*/ getEndTime()
	{
		return $this->end_time;
	}
	
	public function /*void*/ setEndTime(/*int*/ $end_time)
	{
		$this->end_time = intval($end_time);
		$this->end_time_status_field = true;		
		$this->this_table_status_field = true;		
	}

	public function /*void*/ setEndTimeNull()
	{
		$this->end_time = null;
		$this->end_time_status_field = true;		
		$this->this_table_status_field = true;
	}

	public function /*int*/ getUpdateTime()
	{
		return $this->update_time;
	}
	
	public function /*void*/ setUpdateTime(/*int*/ $update_time)
	{
		$this->update_time = intval($update_time);
		$this->update_time_status_field = true;		
		$this->this_table_status_field = true;		
	}

	public function /*void*/ setUpdateTimeNull()
	{
		$this->update_time = null;
		$this->update_time_status_field = true;		
		$this->this_table_status_field = true;
	}

	public function /*int*/ getUpdateNum()
	{
		return $this->update_num;
	}
	
	public function /*void*/ setUpdateNum(/*int*/ $update_num)
	{
		$this->update_num = intval($update_num);
		$this->update_num_status_field = true;		
		$this->this_table_status_field = true;		
	}

	public function /*void*/ setUpdateNumNull()
	{
		$this->update_num = null;
		$this->update_num_status_field = true;		
		$this->this_table_status_field = true;
	}

	public function /*int*/ getTransactionType()
	{
		return $this->transaction_type;
	}
	
	public function /*void*/ setTransactionType(/*int*/ $transaction_type)
	{
		$this->transaction_type = intval($transaction_type);
		$this->transaction_type_status_field = true;		
		$this->this_table_status_field = true;		
	}

	public function /*void*/ setTransactionTypeNull()
	{
		$this->transaction_type = null;
		$this->transaction_type_status_field = true;		
		$this->this_table_status_field = true;
	}

	
	public function /*string*/ toDebugString()
	{
		$dbg = "(";
		
		$dbg .= ("id={$this->id},");
		$dbg .= ("user_id={$this->user_id},");
		$dbg .= ("start_time={$this->start_time},");
		$dbg .= ("end_time={$this->end_time},");
		$dbg .= ("update_time={$this->update_time},");
		$dbg .= ("update_num={$this->update_num},");
		$dbg .= ("transaction_type={$this->transaction_type},");

		$dbg .= ")";
				
		return str_replace(",)",")",$dbg);
	}
}

?>
