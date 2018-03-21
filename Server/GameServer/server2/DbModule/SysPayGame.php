<?php
require_once ($GLOBALS ['GAME_ROOT'] . "CMySQL.php");
require_once ("SQLUtil.php");
/**
 *  [The generated files]
 */

class SysPayGame {
	
	private /*string*/ $pay_game_id; //PRIMARY KEY 
	private /*string*/ $pay_id;
	private /*string*/ $user_id;
	private /*int*/ $pay_type;
	private /*int*/ $transaction_type;
	private /*int*/ $state;
	private /*double*/ $pay_money;
	private /*int*/ $gold_num;
	private /*string*/ $pay_date;
	private /*string*/ $remark;
	private /*string*/ $server_unique_flag;
	private /*int*/ $try_nums;

	
	private $this_table_status_field = false;
	private $pay_game_id_status_field = false;
	private $pay_id_status_field = false;
	private $user_id_status_field = false;
	private $pay_type_status_field = false;
	private $transaction_type_status_field = false;
	private $state_status_field = false;
	private $pay_money_status_field = false;
	private $gold_num_status_field = false;
	private $pay_date_status_field = false;
	private $remark_status_field = false;
	private $server_unique_flag_status_field = false;
	private $try_nums_status_field = false;


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
			$sql = "SELECT {$p} FROM `pay_game`";
		}
		else
		{			
			$sql = "SELECT {$p} FROM `pay_game` WHERE ".SQLUtil::parseCondition($condition);
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
			$tb = new SysPayGame();			
			if (isset($row['pay_game_id'])) $tb->pay_game_id = $row['pay_game_id'];
			if (isset($row['pay_id'])) $tb->pay_id = $row['pay_id'];
			if (isset($row['user_id'])) $tb->user_id = $row['user_id'];
			if (isset($row['pay_type'])) $tb->pay_type = intval($row['pay_type']);
			if (isset($row['transaction_type'])) $tb->transaction_type = intval($row['transaction_type']);
			if (isset($row['state'])) $tb->state = intval($row['state']);
			if (isset($row['pay_money'])) $tb->pay_money = $row['pay_money'];
			if (isset($row['gold_num'])) $tb->gold_num = intval($row['gold_num']);
			if (isset($row['pay_date'])) $tb->pay_date = $row['pay_date'];
			if (isset($row['remark'])) $tb->remark = $row['remark'];
			if (isset($row['server_unique_flag'])) $tb->server_unique_flag = $row['server_unique_flag'];
			if (isset($row['try_nums'])) $tb->try_nums = intval($row['try_nums']);
		
			$result[] = $tb;
		}
		
		return $result;
	}	
	
	public static function insertSqlHeader($fields=NULL)
	{
		$result = array();				
		if(!empty($fields)){
			$where = SQLUtil::parseFields($fields);			
			$result[0] = "INSERT INTO `pay_game` ({$where}) VALUES ";	
			$ar = array();
			foreach($fields as $key){
				$ar[$key]=1;
			}
			$result[1] = $ar;
		}else{
			$result[0]="INSERT INTO `pay_game` (`pay_game_id`,`pay_id`,`user_id`,`pay_type`,`transaction_type`,`state`,`pay_money`,`gold_num`,`pay_date`,`remark`,`server_unique_flag`,`try_nums`) VALUES ";
			$result[1] = array('pay_game_id'=>1,'pay_id'=>1,'user_id'=>1,'pay_type'=>1,'transaction_type'=>1,'state'=>1,'pay_money'=>1,'gold_num'=>1,'pay_date'=>1,'remark'=>1,'server_unique_flag'=>1,'try_nums'=>1);
		}				
		return $result;
	}
		
	public function  loaded( $fields=NULL,$condition=NULL)
	{

		if (empty($condition) && empty($this->pay_game_id))
		{
			return false;
		}
		
		$p = "*";
		$where = "`pay_game_id` = '{$this->pay_game_id}'";
		
		if(!empty($fields))
		{
			$p = SQLUtil::parseFields($fields);			
		}
	    if (!empty($condition))
		{
			$where =SQLUtil::parseCondition($condition);
		}
		
		$sql = "SELECT {$p} FROM `pay_game` WHERE {$where}";

		MySQL::selectDefaultDb();
		$qr = MySQL::getInstance()->RunQuery($sql);
		$ar = MySQL::getInstance()->FetchArray($qr);
		
		if (!$ar || count($ar)==0)
		{
			return false;
		}
		
		if (isset($ar['pay_game_id'])) $this->pay_game_id = $ar['pay_game_id'];
		if (isset($ar['pay_id'])) $this->pay_id = $ar['pay_id'];
		if (isset($ar['user_id'])) $this->user_id = $ar['user_id'];
		if (isset($ar['pay_type'])) $this->pay_type = intval($ar['pay_type']);
		if (isset($ar['transaction_type'])) $this->transaction_type = intval($ar['transaction_type']);
		if (isset($ar['state'])) $this->state = intval($ar['state']);
		if (isset($ar['pay_money'])) $this->pay_money = $ar['pay_money'];
		if (isset($ar['gold_num'])) $this->gold_num = intval($ar['gold_num']);
		if (isset($ar['pay_date'])) $this->pay_date = $ar['pay_date'];
		if (isset($ar['remark'])) $this->remark = $ar['remark'];
		if (isset($ar['server_unique_flag'])) $this->server_unique_flag = $ar['server_unique_flag'];
		if (isset($ar['try_nums'])) $this->try_nums = intval($ar['try_nums']);
		
		
		$this->clean();
		
		return true;
	}
	
	
	public function  loadedCount( $fields=NULL,$condition=NULL)
	{
	
		if (empty($condition) && empty($this->pay_game_id))
		{
			return false;
		}
	
		$p = "*";
		$where = "`pay_game_id` = '{$this->pay_game_id}'";
	
		if(!empty($fields))
		{
			$p = SQLUtil::parseFields($fields);
		}
		if (!empty($condition))
		{
			$where =SQLUtil::parseCondition($condition);
		}
	
		$sql = "SELECT {$p} FROM `pay_game` WHERE {$where}";
	
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
    	
    	if (!isset($this->pay_game_id)){
    		$emptyFields = false;
    		$fields[] = 'pay_game_id';
    	}else{
    		$emptyCondition = false; 
    		$condition['pay_game_id']=$this->pay_game_id;
    	}
    	if (!isset($this->pay_id)){
    		$emptyFields = false;
    		$fields[] = 'pay_id';
    	}else{
    		$emptyCondition = false; 
    		$condition['pay_id']=$this->pay_id;
    	}
    	if (!isset($this->user_id)){
    		$emptyFields = false;
    		$fields[] = 'user_id';
    	}else{
    		$emptyCondition = false; 
    		$condition['user_id']=$this->user_id;
    	}
    	if (!isset($this->pay_type)){
    		$emptyFields = false;
    		$fields[] = 'pay_type';
    	}else{
    		$emptyCondition = false; 
    		$condition['pay_type']=$this->pay_type;
    	}
    	if (!isset($this->transaction_type)){
    		$emptyFields = false;
    		$fields[] = 'transaction_type';
    	}else{
    		$emptyCondition = false; 
    		$condition['transaction_type']=$this->transaction_type;
    	}
    	if (!isset($this->state)){
    		$emptyFields = false;
    		$fields[] = 'state';
    	}else{
    		$emptyCondition = false; 
    		$condition['state']=$this->state;
    	}
    	if (!isset($this->pay_money)){
    		$emptyFields = false;
    		$fields[] = 'pay_money';
    	}else{
    		$emptyCondition = false; 
    		$condition['pay_money']=$this->pay_money;
    	}
    	if (!isset($this->gold_num)){
    		$emptyFields = false;
    		$fields[] = 'gold_num';
    	}else{
    		$emptyCondition = false; 
    		$condition['gold_num']=$this->gold_num;
    	}
    	if (!isset($this->pay_date)){
    		$emptyFields = false;
    		$fields[] = 'pay_date';
    	}else{
    		$emptyCondition = false; 
    		$condition['pay_date']=$this->pay_date;
    	}
    	if (!isset($this->remark)){
    		$emptyFields = false;
    		$fields[] = 'remark';
    	}else{
    		$emptyCondition = false; 
    		$condition['remark']=$this->remark;
    	}
    	if (!isset($this->server_unique_flag)){
    		$emptyFields = false;
    		$fields[] = 'server_unique_flag';
    	}else{
    		$emptyCondition = false; 
    		$condition['server_unique_flag']=$this->server_unique_flag;
    	}
    	if (!isset($this->try_nums)){
    		$emptyFields = false;
    		$fields[] = 'try_nums';
    	}else{
    		$emptyCondition = false; 
    		$condition['try_nums']=$this->try_nums;
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
				
		if (empty($this->pay_game_id))
		{
			$this->pay_game_id = MySQL::getInstance()->GetInsertId();
		}		
		
		$this->clean();
		
		return true;	
		
	}
	
	public function save($condition=NULL)
	{
		if (empty($condition))
		{
			$uc = "`pay_game_id`='{$this->pay_game_id}'";
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
		
		$sql = "DELETE FROM `pay_game` WHERE ".SQLUtil::parseCondition($condition);
		
		$qr = MySQL::getInstance()->RunQuery($sql);
				
		return (boolean)$qr;
	}
	
	public function  delete()
	{
		if (!isset($this->pay_game_id))
		{
			return false;
		}
		
		$sql = "DELETE FROM `pay_game` WHERE `pay_game_id`='{$this->pay_game_id}'";
		
		MySQL::selectDefaultDb();
		$qr = MySQL::getInstance()->RunQuery($sql);
				
		return (boolean)$qr;
	}
	
	public function getInsertValue($fields)
	{
		$values = "(";		
		foreach($fields as $f => $k){
			if($f == 'pay_game_id'){
 				$values .= "'{$this->pay_game_id}',";
 			}else if($f == 'pay_id'){
 				$values .= "'{$this->pay_id}',";
 			}else if($f == 'user_id'){
 				$values .= "'{$this->user_id}',";
 			}else if($f == 'pay_type'){
 				$values .= "'{$this->pay_type}',";
 			}else if($f == 'transaction_type'){
 				$values .= "'{$this->transaction_type}',";
 			}else if($f == 'state'){
 				$values .= "'{$this->state}',";
 			}else if($f == 'pay_money'){
 				$values .= "'{$this->pay_money}',";
 			}else if($f == 'gold_num'){
 				$values .= "'{$this->gold_num}',";
 			}else if($f == 'pay_date'){
 				$values .= "'{$this->pay_date}',";
 			}else if($f == 'remark'){
 				$values .= "'{$this->remark}',";
 			}else if($f == 'server_unique_flag'){
 				$values .= "'{$this->server_unique_flag}',";
 			}else if($f == 'try_nums'){
 				$values .= "'{$this->try_nums}',";
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

		if (isset($this->pay_game_id))
		{
			$fields .= "`pay_game_id`,";
			$values .= "'{$this->pay_game_id}',";
		}
		if (isset($this->pay_id))
		{
			$fields .= "`pay_id`,";
			$values .= "'{$this->pay_id}',";
		}
		if (isset($this->user_id))
		{
			$fields .= "`user_id`,";
			$values .= "'{$this->user_id}',";
		}
		if (isset($this->pay_type))
		{
			$fields .= "`pay_type`,";
			$values .= "'{$this->pay_type}',";
		}
		if (isset($this->transaction_type))
		{
			$fields .= "`transaction_type`,";
			$values .= "'{$this->transaction_type}',";
		}
		if (isset($this->state))
		{
			$fields .= "`state`,";
			$values .= "'{$this->state}',";
		}
		if (isset($this->pay_money))
		{
			$fields .= "`pay_money`,";
			$values .= "'{$this->pay_money}',";
		}
		if (isset($this->gold_num))
		{
			$fields .= "`gold_num`,";
			$values .= "'{$this->gold_num}',";
		}
		if (isset($this->pay_date))
		{
			$fields .= "`pay_date`,";
			$values .= "'{$this->pay_date}',";
		}
		if (isset($this->remark))
		{
			$fields .= "`remark`,";
			$values .= "'{$this->remark}',";
		}
		if (isset($this->server_unique_flag))
		{
			$fields .= "`server_unique_flag`,";
			$values .= "'{$this->server_unique_flag}',";
		}
		if (isset($this->try_nums))
		{
			$fields .= "`try_nums`,";
			$values .= "'{$this->try_nums}',";
		}

		
		$fields .= ")";
		$values .= ")";
		
		$sql = "INSERT INTO `pay_game` ".$fields.$values;
		
		return str_replace(",)",")",$sql);
	}
	
	private function  getUpFields()
	{
		$update = "";
		
		if ($this->pay_id_status_field)
		{			
			if (!isset($this->pay_id))
			{
				$update .= ("`pay_id`=null,");
			}
			else
			{
				$update .= ("`pay_id`='{$this->pay_id}',");
			}
		}
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
		if ($this->pay_type_status_field)
		{			
			if (!isset($this->pay_type))
			{
				$update .= ("`pay_type`=null,");
			}
			else
			{
				$update .= ("`pay_type`='{$this->pay_type}',");
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
		if ($this->pay_money_status_field)
		{			
			if (!isset($this->pay_money))
			{
				$update .= ("`pay_money`=null,");
			}
			else
			{
				$update .= ("`pay_money`='{$this->pay_money}',");
			}
		}
		if ($this->gold_num_status_field)
		{			
			if (!isset($this->gold_num))
			{
				$update .= ("`gold_num`=null,");
			}
			else
			{
				$update .= ("`gold_num`='{$this->gold_num}',");
			}
		}
		if ($this->pay_date_status_field)
		{			
			if (!isset($this->pay_date))
			{
				$update .= ("`pay_date`=null,");
			}
			else
			{
				$update .= ("`pay_date`='{$this->pay_date}',");
			}
		}
		if ($this->remark_status_field)
		{			
			if (!isset($this->remark))
			{
				$update .= ("`remark`=null,");
			}
			else
			{
				$update .= ("`remark`='{$this->remark}',");
			}
		}
		if ($this->server_unique_flag_status_field)
		{			
			if (!isset($this->server_unique_flag))
			{
				$update .= ("`server_unique_flag`=null,");
			}
			else
			{
				$update .= ("`server_unique_flag`='{$this->server_unique_flag}',");
			}
		}
		if ($this->try_nums_status_field)
		{			
			if (!isset($this->try_nums))
			{
				$update .= ("`try_nums`=null,");
			}
			else
			{
				$update .= ("`try_nums`='{$this->try_nums}',");
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
		
		$sql = "UPDATE `pay_game` SET {$update} WHERE {$condition}";
		
		return $sql;
	}
	
	public function  add($fieldsValue,$condition=NULL)
	{				
		if (empty($condition))
		{
			$uc = "`pay_game_id`='{$this->pay_game_id}'";
		}
		else
		{			
			$uc = SQLUtil::parseCondition($condition);
		}
		
		$update = SQLUtil::parseASFieldValues($fieldsValue);
		
		$sql = "UPDATE `pay_game` SET {$update} WHERE {$uc}";
		
		MySQL::selectDefaultDb();
		$qr = MySQL::getInstance()->RunQuery($sql);
				
		return (boolean)$qr;
	}	
	
	public function sub($fieldsVal,$condition=NULL)
	{
		if (empty($condition))
		{
			$uc = "`pay_game_id`='{$this->pay_game_id}'";
		}
		else
		{			
			$uc = SQLUtil::parseCondition($condition);
		}
		
		$update = SQLUtil::parseASFieldValues($fieldsVal,false);
		
		$sql = "UPDATE `pay_game` SET {$update} WHERE {$uc}";
		
		MySQL::selectDefaultDb();
		$qr = MySQL::getInstance()->RunQuery($sql);
				
		return (boolean)$qr;
	}
	
	private function /*void*/ clean() 
	{
		$this->this_table_status_field = false;
		$this->pay_game_id_status_field = false;
		$this->pay_id_status_field = false;
		$this->user_id_status_field = false;
		$this->pay_type_status_field = false;
		$this->transaction_type_status_field = false;
		$this->state_status_field = false;
		$this->pay_money_status_field = false;
		$this->gold_num_status_field = false;
		$this->pay_date_status_field = false;
		$this->remark_status_field = false;
		$this->server_unique_flag_status_field = false;
		$this->try_nums_status_field = false;

	}
	
	public function /*string*/ getPayGameId()
	{
		return $this->pay_game_id;
	}
	
	public function /*void*/ setPayGameId(/*string*/ $pay_game_id)
	{
		$this->pay_game_id = SQLUtil::toSafeSQLString($pay_game_id);
		$this->pay_game_id_status_field = true;		
		$this->this_table_status_field = true;		
	}

	public function /*void*/ setPayGameIdNull()
	{
		$this->pay_game_id = null;
		$this->pay_game_id_status_field = true;		
		$this->this_table_status_field = true;
	}

	public function /*string*/ getPayId()
	{
		return $this->pay_id;
	}
	
	public function /*void*/ setPayId(/*string*/ $pay_id)
	{
		$this->pay_id = SQLUtil::toSafeSQLString($pay_id);
		$this->pay_id_status_field = true;		
		$this->this_table_status_field = true;		
	}

	public function /*void*/ setPayIdNull()
	{
		$this->pay_id = null;
		$this->pay_id_status_field = true;		
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

	public function /*int*/ getPayType()
	{
		return $this->pay_type;
	}
	
	public function /*void*/ setPayType(/*int*/ $pay_type)
	{
		$this->pay_type = intval($pay_type);
		$this->pay_type_status_field = true;		
		$this->this_table_status_field = true;		
	}

	public function /*void*/ setPayTypeNull()
	{
		$this->pay_type = null;
		$this->pay_type_status_field = true;		
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

	public function /*double*/ getPayMoney()
	{
		return $this->pay_money;
	}
	
	public function /*void*/ setPayMoney(/*double*/ $pay_money)
	{
		$this->pay_money = SQLUtil::toSafeSQLString($pay_money);
		$this->pay_money_status_field = true;		
		$this->this_table_status_field = true;		
	}

	public function /*void*/ setPayMoneyNull()
	{
		$this->pay_money = null;
		$this->pay_money_status_field = true;		
		$this->this_table_status_field = true;
	}

	public function /*int*/ getGoldNum()
	{
		return $this->gold_num;
	}
	
	public function /*void*/ setGoldNum(/*int*/ $gold_num)
	{
		$this->gold_num = intval($gold_num);
		$this->gold_num_status_field = true;		
		$this->this_table_status_field = true;		
	}

	public function /*void*/ setGoldNumNull()
	{
		$this->gold_num = null;
		$this->gold_num_status_field = true;		
		$this->this_table_status_field = true;
	}

	public function /*string*/ getPayDate()
	{
		return $this->pay_date;
	}
	
	public function /*void*/ setPayDate(/*string*/ $pay_date)
	{
		$this->pay_date = SQLUtil::toSafeSQLString($pay_date);
		$this->pay_date_status_field = true;		
		$this->this_table_status_field = true;		
	}

	public function /*void*/ setPayDateNull()
	{
		$this->pay_date = null;
		$this->pay_date_status_field = true;		
		$this->this_table_status_field = true;
	}

	public function /*string*/ getRemark()
	{
		return $this->remark;
	}
	
	public function /*void*/ setRemark(/*string*/ $remark)
	{
		$this->remark = SQLUtil::toSafeSQLString($remark);
		$this->remark_status_field = true;		
		$this->this_table_status_field = true;		
	}

	public function /*void*/ setRemarkNull()
	{
		$this->remark = null;
		$this->remark_status_field = true;		
		$this->this_table_status_field = true;
	}

	public function /*string*/ getServerUniqueFlag()
	{
		return $this->server_unique_flag;
	}
	
	public function /*void*/ setServerUniqueFlag(/*string*/ $server_unique_flag)
	{
		$this->server_unique_flag = SQLUtil::toSafeSQLString($server_unique_flag);
		$this->server_unique_flag_status_field = true;		
		$this->this_table_status_field = true;		
	}

	public function /*void*/ setServerUniqueFlagNull()
	{
		$this->server_unique_flag = null;
		$this->server_unique_flag_status_field = true;		
		$this->this_table_status_field = true;
	}

	public function /*int*/ getTryNums()
	{
		return $this->try_nums;
	}
	
	public function /*void*/ setTryNums(/*int*/ $try_nums)
	{
		$this->try_nums = intval($try_nums);
		$this->try_nums_status_field = true;		
		$this->this_table_status_field = true;		
	}

	public function /*void*/ setTryNumsNull()
	{
		$this->try_nums = null;
		$this->try_nums_status_field = true;		
		$this->this_table_status_field = true;
	}

	
	public function /*string*/ toDebugString()
	{
		$dbg = "(";
		
		$dbg .= ("pay_game_id={$this->pay_game_id},");
		$dbg .= ("pay_id={$this->pay_id},");
		$dbg .= ("user_id={$this->user_id},");
		$dbg .= ("pay_type={$this->pay_type},");
		$dbg .= ("transaction_type={$this->transaction_type},");
		$dbg .= ("state={$this->state},");
		$dbg .= ("pay_money={$this->pay_money},");
		$dbg .= ("gold_num={$this->gold_num},");
		$dbg .= ("pay_date={$this->pay_date},");
		$dbg .= ("remark={$this->remark},");
		$dbg .= ("server_unique_flag={$this->server_unique_flag},");
		$dbg .= ("try_nums={$this->try_nums},");

		$dbg .= ")";
				
		return str_replace(",)",")",$dbg);
	}
}

?>
