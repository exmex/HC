<?php
require_once ($GLOBALS ['GAME_ROOT'] . "CMySQL.php");
require_once ("SQLUtil.php");
/**
 *  [The generated files]
 */

class SysActivityLog {
	
	private /*int*/ $id; //PRIMARY KEY 
	private /*string*/ $user_id;
	private /*int*/ $activity_score; //活动分数
	private /*int*/ $amount; //剩余次数
	private /*int*/ $buynum; //购买次数
	private /*string*/ $datetime; //时间
	private /*int*/ $server_id; //服务器id
	private /*string*/ $last_buy_time;
	private /*int*/ $redward_status; //是否领奖
	private /*int*/ $version; //活动时间段
	private /*string*/ $gift_id; //礼品id

	
	private $this_table_status_field = false;
	private $id_status_field = false;
	private $user_id_status_field = false;
	private $activity_score_status_field = false;
	private $amount_status_field = false;
	private $buynum_status_field = false;
	private $datetime_status_field = false;
	private $server_id_status_field = false;
	private $last_buy_time_status_field = false;
	private $redward_status_status_field = false;
	private $version_status_field = false;
	private $gift_id_status_field = false;


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
			$sql = "SELECT {$p} FROM `activity_log`";
		}
		else
		{			
			$sql = "SELECT {$p} FROM `activity_log` WHERE ".SQLUtil::parseCondition($condition);
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
			$tb = new SysActivityLog();			
			if (isset($row['id'])) $tb->id = intval($row['id']);
			if (isset($row['user_id'])) $tb->user_id = $row['user_id'];
			if (isset($row['activity_score'])) $tb->activity_score = intval($row['activity_score']);
			if (isset($row['amount'])) $tb->amount = intval($row['amount']);
			if (isset($row['buynum'])) $tb->buynum = intval($row['buynum']);
			if (isset($row['datetime'])) $tb->datetime = $row['datetime'];
			if (isset($row['server_id'])) $tb->server_id = intval($row['server_id']);
			if (isset($row['last_buy_time'])) $tb->last_buy_time = $row['last_buy_time'];
			if (isset($row['redward_status'])) $tb->redward_status = intval($row['redward_status']);
			if (isset($row['version'])) $tb->version = intval($row['version']);
			if (isset($row['gift_id'])) $tb->gift_id = $row['gift_id'];
		
			$result[] = $tb;
		}
		
		return $result;
	}	
	
	public static function insertSqlHeader($fields=NULL)
	{
		$result = array();				
		if(!empty($fields)){
			$where = SQLUtil::parseFields($fields);			
			$result[0] = "INSERT INTO `activity_log` ({$where}) VALUES ";	
			$ar = array();
			foreach($fields as $key){
				$ar[$key]=1;
			}
			$result[1] = $ar;
		}else{
			$result[0]="INSERT INTO `activity_log` (`id`,`user_id`,`activity_score`,`amount`,`buynum`,`datetime`,`server_id`,`last_buy_time`,`redward_status`,`version`,`gift_id`) VALUES ";
			$result[1] = array('id'=>1,'user_id'=>1,'activity_score'=>1,'amount'=>1,'buynum'=>1,'datetime'=>1,'server_id'=>1,'last_buy_time'=>1,'redward_status'=>1,'version'=>1,'gift_id'=>1);
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
		
		$sql = "SELECT {$p} FROM `activity_log` WHERE {$where}";

		MySQL::selectDefaultDb();
		$qr = MySQL::getInstance()->RunQuery($sql);
		$ar = MySQL::getInstance()->FetchArray($qr);
		
		if (!$ar || count($ar)==0)
		{
			return false;
		}
		
		if (isset($ar['id'])) $this->id = intval($ar['id']);
		if (isset($ar['user_id'])) $this->user_id = $ar['user_id'];
		if (isset($ar['activity_score'])) $this->activity_score = intval($ar['activity_score']);
		if (isset($ar['amount'])) $this->amount = intval($ar['amount']);
		if (isset($ar['buynum'])) $this->buynum = intval($ar['buynum']);
		if (isset($ar['datetime'])) $this->datetime = $ar['datetime'];
		if (isset($ar['server_id'])) $this->server_id = intval($ar['server_id']);
		if (isset($ar['last_buy_time'])) $this->last_buy_time = $ar['last_buy_time'];
		if (isset($ar['redward_status'])) $this->redward_status = intval($ar['redward_status']);
		if (isset($ar['version'])) $this->version = intval($ar['version']);
		if (isset($ar['gift_id'])) $this->gift_id = $ar['gift_id'];
		
		
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
	
		$sql = "SELECT {$p} FROM `activity_log` WHERE {$where}";
	
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
    	if (!isset($this->activity_score)){
    		$emptyFields = false;
    		$fields[] = 'activity_score';
    	}else{
    		$emptyCondition = false; 
    		$condition['activity_score']=$this->activity_score;
    	}
    	if (!isset($this->amount)){
    		$emptyFields = false;
    		$fields[] = 'amount';
    	}else{
    		$emptyCondition = false; 
    		$condition['amount']=$this->amount;
    	}
    	if (!isset($this->buynum)){
    		$emptyFields = false;
    		$fields[] = 'buynum';
    	}else{
    		$emptyCondition = false; 
    		$condition['buynum']=$this->buynum;
    	}
    	if (!isset($this->datetime)){
    		$emptyFields = false;
    		$fields[] = 'datetime';
    	}else{
    		$emptyCondition = false; 
    		$condition['datetime']=$this->datetime;
    	}
    	if (!isset($this->server_id)){
    		$emptyFields = false;
    		$fields[] = 'server_id';
    	}else{
    		$emptyCondition = false; 
    		$condition['server_id']=$this->server_id;
    	}
    	if (!isset($this->last_buy_time)){
    		$emptyFields = false;
    		$fields[] = 'last_buy_time';
    	}else{
    		$emptyCondition = false; 
    		$condition['last_buy_time']=$this->last_buy_time;
    	}
    	if (!isset($this->redward_status)){
    		$emptyFields = false;
    		$fields[] = 'redward_status';
    	}else{
    		$emptyCondition = false; 
    		$condition['redward_status']=$this->redward_status;
    	}
    	if (!isset($this->version)){
    		$emptyFields = false;
    		$fields[] = 'version';
    	}else{
    		$emptyCondition = false; 
    		$condition['version']=$this->version;
    	}
    	if (!isset($this->gift_id)){
    		$emptyFields = false;
    		$fields[] = 'gift_id';
    	}else{
    		$emptyCondition = false; 
    		$condition['gift_id']=$this->gift_id;
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
		
		$sql = "DELETE FROM `activity_log` WHERE ".SQLUtil::parseCondition($condition);
		
		$qr = MySQL::getInstance()->RunQuery($sql);
				
		return (boolean)$qr;
	}
	
	public function  delete()
	{
		if (!isset($this->id))
		{
			return false;
		}
		
		$sql = "DELETE FROM `activity_log` WHERE `id`='{$this->id}'";
		
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
 			}else if($f == 'activity_score'){
 				$values .= "'{$this->activity_score}',";
 			}else if($f == 'amount'){
 				$values .= "'{$this->amount}',";
 			}else if($f == 'buynum'){
 				$values .= "'{$this->buynum}',";
 			}else if($f == 'datetime'){
 				$values .= "'{$this->datetime}',";
 			}else if($f == 'server_id'){
 				$values .= "'{$this->server_id}',";
 			}else if($f == 'last_buy_time'){
 				$values .= "'{$this->last_buy_time}',";
 			}else if($f == 'redward_status'){
 				$values .= "'{$this->redward_status}',";
 			}else if($f == 'version'){
 				$values .= "'{$this->version}',";
 			}else if($f == 'gift_id'){
 				$values .= "'{$this->gift_id}',";
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
		if (isset($this->activity_score))
		{
			$fields .= "`activity_score`,";
			$values .= "'{$this->activity_score}',";
		}
		if (isset($this->amount))
		{
			$fields .= "`amount`,";
			$values .= "'{$this->amount}',";
		}
		if (isset($this->buynum))
		{
			$fields .= "`buynum`,";
			$values .= "'{$this->buynum}',";
		}
		if (isset($this->datetime))
		{
			$fields .= "`datetime`,";
			$values .= "'{$this->datetime}',";
		}
		if (isset($this->server_id))
		{
			$fields .= "`server_id`,";
			$values .= "'{$this->server_id}',";
		}
		if (isset($this->last_buy_time))
		{
			$fields .= "`last_buy_time`,";
			$values .= "'{$this->last_buy_time}',";
		}
		if (isset($this->redward_status))
		{
			$fields .= "`redward_status`,";
			$values .= "'{$this->redward_status}',";
		}
		if (isset($this->version))
		{
			$fields .= "`version`,";
			$values .= "'{$this->version}',";
		}
		if (isset($this->gift_id))
		{
			$fields .= "`gift_id`,";
			$values .= "'{$this->gift_id}',";
		}

		
		$fields .= ")";
		$values .= ")";
		
		$sql = "INSERT INTO `activity_log` ".$fields.$values;
		
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
		if ($this->activity_score_status_field)
		{			
			if (!isset($this->activity_score))
			{
				$update .= ("`activity_score`=null,");
			}
			else
			{
				$update .= ("`activity_score`='{$this->activity_score}',");
			}
		}
		if ($this->amount_status_field)
		{			
			if (!isset($this->amount))
			{
				$update .= ("`amount`=null,");
			}
			else
			{
				$update .= ("`amount`='{$this->amount}',");
			}
		}
		if ($this->buynum_status_field)
		{			
			if (!isset($this->buynum))
			{
				$update .= ("`buynum`=null,");
			}
			else
			{
				$update .= ("`buynum`='{$this->buynum}',");
			}
		}
		if ($this->datetime_status_field)
		{			
			if (!isset($this->datetime))
			{
				$update .= ("`datetime`=null,");
			}
			else
			{
				$update .= ("`datetime`='{$this->datetime}',");
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
		if ($this->last_buy_time_status_field)
		{			
			if (!isset($this->last_buy_time))
			{
				$update .= ("`last_buy_time`=null,");
			}
			else
			{
				$update .= ("`last_buy_time`='{$this->last_buy_time}',");
			}
		}
		if ($this->redward_status_status_field)
		{			
			if (!isset($this->redward_status))
			{
				$update .= ("`redward_status`=null,");
			}
			else
			{
				$update .= ("`redward_status`='{$this->redward_status}',");
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
		if ($this->gift_id_status_field)
		{			
			if (!isset($this->gift_id))
			{
				$update .= ("`gift_id`=null,");
			}
			else
			{
				$update .= ("`gift_id`='{$this->gift_id}',");
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
		
		$sql = "UPDATE `activity_log` SET {$update} WHERE {$condition}";
		
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
		
		$sql = "UPDATE `activity_log` SET {$update} WHERE {$uc}";
		
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
		
		$sql = "UPDATE `activity_log` SET {$update} WHERE {$uc}";
		
		MySQL::selectDefaultDb();
		$qr = MySQL::getInstance()->RunQuery($sql);
				
		return (boolean)$qr;
	}
	
	private function /*void*/ clean() 
	{
		$this->this_table_status_field = false;
		$this->id_status_field = false;
		$this->user_id_status_field = false;
		$this->activity_score_status_field = false;
		$this->amount_status_field = false;
		$this->buynum_status_field = false;
		$this->datetime_status_field = false;
		$this->server_id_status_field = false;
		$this->last_buy_time_status_field = false;
		$this->redward_status_status_field = false;
		$this->version_status_field = false;
		$this->gift_id_status_field = false;

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

	public function /*int*/ getActivityScore()
	{
		return $this->activity_score;
	}
	
	public function /*void*/ setActivityScore(/*int*/ $activity_score)
	{
		$this->activity_score = intval($activity_score);
		$this->activity_score_status_field = true;		
		$this->this_table_status_field = true;		
	}

	public function /*void*/ setActivityScoreNull()
	{
		$this->activity_score = null;
		$this->activity_score_status_field = true;		
		$this->this_table_status_field = true;
	}

	public function /*int*/ getAmount()
	{
		return $this->amount;
	}
	
	public function /*void*/ setAmount(/*int*/ $amount)
	{
		$this->amount = intval($amount);
		$this->amount_status_field = true;		
		$this->this_table_status_field = true;		
	}

	public function /*void*/ setAmountNull()
	{
		$this->amount = null;
		$this->amount_status_field = true;		
		$this->this_table_status_field = true;
	}

	public function /*int*/ getBuynum()
	{
		return $this->buynum;
	}
	
	public function /*void*/ setBuynum(/*int*/ $buynum)
	{
		$this->buynum = intval($buynum);
		$this->buynum_status_field = true;		
		$this->this_table_status_field = true;		
	}

	public function /*void*/ setBuynumNull()
	{
		$this->buynum = null;
		$this->buynum_status_field = true;		
		$this->this_table_status_field = true;
	}

	public function /*string*/ getDatetime()
	{
		return $this->datetime;
	}
	
	public function /*void*/ setDatetime(/*string*/ $datetime)
	{
		$this->datetime = SQLUtil::toSafeSQLString($datetime);
		$this->datetime_status_field = true;		
		$this->this_table_status_field = true;		
	}

	public function /*void*/ setDatetimeNull()
	{
		$this->datetime = null;
		$this->datetime_status_field = true;		
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

	public function /*string*/ getLastBuyTime()
	{
		return $this->last_buy_time;
	}
	
	public function /*void*/ setLastBuyTime(/*string*/ $last_buy_time)
	{
		$this->last_buy_time = SQLUtil::toSafeSQLString($last_buy_time);
		$this->last_buy_time_status_field = true;		
		$this->this_table_status_field = true;		
	}

	public function /*void*/ setLastBuyTimeNull()
	{
		$this->last_buy_time = null;
		$this->last_buy_time_status_field = true;		
		$this->this_table_status_field = true;
	}

	public function /*int*/ getRedwardStatus()
	{
		return $this->redward_status;
	}
	
	public function /*void*/ setRedwardStatus(/*int*/ $redward_status)
	{
		$this->redward_status = intval($redward_status);
		$this->redward_status_status_field = true;		
		$this->this_table_status_field = true;		
	}

	public function /*void*/ setRedwardStatusNull()
	{
		$this->redward_status = null;
		$this->redward_status_status_field = true;		
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

	public function /*string*/ getGiftId()
	{
		return $this->gift_id;
	}
	
	public function /*void*/ setGiftId(/*string*/ $gift_id)
	{
		$this->gift_id = SQLUtil::toSafeSQLString($gift_id);
		$this->gift_id_status_field = true;		
		$this->this_table_status_field = true;		
	}

	public function /*void*/ setGiftIdNull()
	{
		$this->gift_id = null;
		$this->gift_id_status_field = true;		
		$this->this_table_status_field = true;
	}

	
	public function /*string*/ toDebugString()
	{
		$dbg = "(";
		
		$dbg .= ("id={$this->id},");
		$dbg .= ("user_id={$this->user_id},");
		$dbg .= ("activity_score={$this->activity_score},");
		$dbg .= ("amount={$this->amount},");
		$dbg .= ("buynum={$this->buynum},");
		$dbg .= ("datetime={$this->datetime},");
		$dbg .= ("server_id={$this->server_id},");
		$dbg .= ("last_buy_time={$this->last_buy_time},");
		$dbg .= ("redward_status={$this->redward_status},");
		$dbg .= ("version={$this->version},");
		$dbg .= ("gift_id={$this->gift_id},");

		$dbg .= ")";
				
		return str_replace(",)",")",$dbg);
	}
}

?>
