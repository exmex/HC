<?php
require_once ($GLOBALS ['GAME_ROOT'] . "CMySQL.php");
require_once ("SQLUtil.php");
/**
 *  [The generated files]
 */

class SysPayInfo {
	
	private /*string*/ $pay_id; //PRIMARY KEY 
	private /*string*/ $buyer_id;
	private /*string*/ $receiver_id;
	private /*int*/ $pay_type;
	private /*string*/ $order_id;
	private /*string*/ $transaction_id;
	private /*int*/ $order_state;
	private /*double*/ $pay_money;
	private /*double*/ $order_money;
	private /*int*/ $gold_num;
	private /*string*/ $order_date;
	private /*string*/ $pay_date;
	private /*string*/ $remark;
	private /*string*/ $order_ip;
	private /*string*/ $country;
	private /*int*/ $transaction_type;
	private /*string*/ $paypal_preapprovalkey;
	private /*string*/ $paypal_paykey;
	private /*string*/ $paypal_email;
	private /*string*/ $paypal_date;
	private /*string*/ $server_unique_flag;
	private /*string*/ $check_date;
	private /*double*/ $paypal_fee;
	private /*int*/ $order_time;
	private /*int*/ $pay_time;
	private /*string*/ $game_center_id;
	private /*int*/ $level;
	private /*int*/ $vip_level;
	private /*int*/ $is_first;
	private /*string*/ $device_id;

	
	private $this_table_status_field = false;
	private $pay_id_status_field = false;
	private $buyer_id_status_field = false;
	private $receiver_id_status_field = false;
	private $pay_type_status_field = false;
	private $order_id_status_field = false;
	private $transaction_id_status_field = false;
	private $order_state_status_field = false;
	private $pay_money_status_field = false;
	private $order_money_status_field = false;
	private $gold_num_status_field = false;
	private $order_date_status_field = false;
	private $pay_date_status_field = false;
	private $remark_status_field = false;
	private $order_ip_status_field = false;
	private $country_status_field = false;
	private $transaction_type_status_field = false;
	private $paypal_preapprovalkey_status_field = false;
	private $paypal_paykey_status_field = false;
	private $paypal_email_status_field = false;
	private $paypal_date_status_field = false;
	private $server_unique_flag_status_field = false;
	private $check_date_status_field = false;
	private $paypal_fee_status_field = false;
	private $order_time_status_field = false;
	private $pay_time_status_field = false;
	private $game_center_id_status_field = false;
	private $level_status_field = false;
	private $vip_level_status_field = false;
	private $is_first_status_field = false;
	private $device_id_status_field = false;


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
			$sql = "SELECT {$p} FROM `pay_info`";
		}
		else
		{			
			$sql = "SELECT {$p} FROM `pay_info` WHERE ".SQLUtil::parseCondition($condition);
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
			$tb = new SysPayInfo();			
			if (isset($row['pay_id'])) $tb->pay_id = $row['pay_id'];
			if (isset($row['buyer_id'])) $tb->buyer_id = $row['buyer_id'];
			if (isset($row['receiver_id'])) $tb->receiver_id = $row['receiver_id'];
			if (isset($row['pay_type'])) $tb->pay_type = intval($row['pay_type']);
			if (isset($row['order_id'])) $tb->order_id = $row['order_id'];
			if (isset($row['transaction_id'])) $tb->transaction_id = $row['transaction_id'];
			if (isset($row['order_state'])) $tb->order_state = intval($row['order_state']);
			if (isset($row['pay_money'])) $tb->pay_money = $row['pay_money'];
			if (isset($row['order_money'])) $tb->order_money = $row['order_money'];
			if (isset($row['gold_num'])) $tb->gold_num = intval($row['gold_num']);
			if (isset($row['order_date'])) $tb->order_date = $row['order_date'];
			if (isset($row['pay_date'])) $tb->pay_date = $row['pay_date'];
			if (isset($row['remark'])) $tb->remark = $row['remark'];
			if (isset($row['order_ip'])) $tb->order_ip = $row['order_ip'];
			if (isset($row['country'])) $tb->country = $row['country'];
			if (isset($row['transaction_type'])) $tb->transaction_type = intval($row['transaction_type']);
			if (isset($row['paypal_preapprovalkey'])) $tb->paypal_preapprovalkey = $row['paypal_preapprovalkey'];
			if (isset($row['paypal_paykey'])) $tb->paypal_paykey = $row['paypal_paykey'];
			if (isset($row['paypal_email'])) $tb->paypal_email = $row['paypal_email'];
			if (isset($row['paypal_date'])) $tb->paypal_date = $row['paypal_date'];
			if (isset($row['server_unique_flag'])) $tb->server_unique_flag = $row['server_unique_flag'];
			if (isset($row['check_date'])) $tb->check_date = $row['check_date'];
			if (isset($row['paypal_fee'])) $tb->paypal_fee = $row['paypal_fee'];
			if (isset($row['order_time'])) $tb->order_time = intval($row['order_time']);
			if (isset($row['pay_time'])) $tb->pay_time = intval($row['pay_time']);
			if (isset($row['game_center_id'])) $tb->game_center_id = $row['game_center_id'];
			if (isset($row['level'])) $tb->level = intval($row['level']);
			if (isset($row['vip_level'])) $tb->vip_level = intval($row['vip_level']);
			if (isset($row['is_first'])) $tb->is_first = intval($row['is_first']);
			if (isset($row['device_id'])) $tb->device_id = $row['device_id'];
		
			$result[] = $tb;
		}
		
		return $result;
	}	
	
	public static function insertSqlHeader($fields=NULL)
	{
		$result = array();				
		if(!empty($fields)){
			$where = SQLUtil::parseFields($fields);			
			$result[0] = "INSERT INTO `pay_info` ({$where}) VALUES ";	
			$ar = array();
			foreach($fields as $key){
				$ar[$key]=1;
			}
			$result[1] = $ar;
		}else{
			$result[0]="INSERT INTO `pay_info` (`pay_id`,`buyer_id`,`receiver_id`,`pay_type`,`order_id`,`transaction_id`,`order_state`,`pay_money`,`order_money`,`gold_num`,`order_date`,`pay_date`,`remark`,`order_ip`,`country`,`transaction_type`,`paypal_preapprovalkey`,`paypal_paykey`,`paypal_email`,`paypal_date`,`server_unique_flag`,`check_date`,`paypal_fee`,`order_time`,`pay_time`,`game_center_id`,`level`,`vip_level`,`is_first`,`device_id`) VALUES ";
			$result[1] = array('pay_id'=>1,'buyer_id'=>1,'receiver_id'=>1,'pay_type'=>1,'order_id'=>1,'transaction_id'=>1,'order_state'=>1,'pay_money'=>1,'order_money'=>1,'gold_num'=>1,'order_date'=>1,'pay_date'=>1,'remark'=>1,'order_ip'=>1,'country'=>1,'transaction_type'=>1,'paypal_preapprovalkey'=>1,'paypal_paykey'=>1,'paypal_email'=>1,'paypal_date'=>1,'server_unique_flag'=>1,'check_date'=>1,'paypal_fee'=>1,'order_time'=>1,'pay_time'=>1,'game_center_id'=>1,'level'=>1,'vip_level'=>1,'is_first'=>1,'device_id'=>1);
		}				
		return $result;
	}
		
	public function  loaded( $fields=NULL,$condition=NULL)
	{

		if (empty($condition) && empty($this->pay_id))
		{
			return false;
		}
		
		$p = "*";
		$where = "`pay_id` = '{$this->pay_id}'";
		
		if(!empty($fields))
		{
			$p = SQLUtil::parseFields($fields);			
		}
	    if (!empty($condition))
		{
			$where =SQLUtil::parseCondition($condition);
		}
		
		$sql = "SELECT {$p} FROM `pay_info` WHERE {$where}";

		MySQL::selectDefaultDb();
		$qr = MySQL::getInstance()->RunQuery($sql);
		$ar = MySQL::getInstance()->FetchArray($qr);
		
		if (!$ar || count($ar)==0)
		{
			return false;
		}
		
		if (isset($ar['pay_id'])) $this->pay_id = $ar['pay_id'];
		if (isset($ar['buyer_id'])) $this->buyer_id = $ar['buyer_id'];
		if (isset($ar['receiver_id'])) $this->receiver_id = $ar['receiver_id'];
		if (isset($ar['pay_type'])) $this->pay_type = intval($ar['pay_type']);
		if (isset($ar['order_id'])) $this->order_id = $ar['order_id'];
		if (isset($ar['transaction_id'])) $this->transaction_id = $ar['transaction_id'];
		if (isset($ar['order_state'])) $this->order_state = intval($ar['order_state']);
		if (isset($ar['pay_money'])) $this->pay_money = $ar['pay_money'];
		if (isset($ar['order_money'])) $this->order_money = $ar['order_money'];
		if (isset($ar['gold_num'])) $this->gold_num = intval($ar['gold_num']);
		if (isset($ar['order_date'])) $this->order_date = $ar['order_date'];
		if (isset($ar['pay_date'])) $this->pay_date = $ar['pay_date'];
		if (isset($ar['remark'])) $this->remark = $ar['remark'];
		if (isset($ar['order_ip'])) $this->order_ip = $ar['order_ip'];
		if (isset($ar['country'])) $this->country = $ar['country'];
		if (isset($ar['transaction_type'])) $this->transaction_type = intval($ar['transaction_type']);
		if (isset($ar['paypal_preapprovalkey'])) $this->paypal_preapprovalkey = $ar['paypal_preapprovalkey'];
		if (isset($ar['paypal_paykey'])) $this->paypal_paykey = $ar['paypal_paykey'];
		if (isset($ar['paypal_email'])) $this->paypal_email = $ar['paypal_email'];
		if (isset($ar['paypal_date'])) $this->paypal_date = $ar['paypal_date'];
		if (isset($ar['server_unique_flag'])) $this->server_unique_flag = $ar['server_unique_flag'];
		if (isset($ar['check_date'])) $this->check_date = $ar['check_date'];
		if (isset($ar['paypal_fee'])) $this->paypal_fee = $ar['paypal_fee'];
		if (isset($ar['order_time'])) $this->order_time = intval($ar['order_time']);
		if (isset($ar['pay_time'])) $this->pay_time = intval($ar['pay_time']);
		if (isset($ar['game_center_id'])) $this->game_center_id = $ar['game_center_id'];
		if (isset($ar['level'])) $this->level = intval($ar['level']);
		if (isset($ar['vip_level'])) $this->vip_level = intval($ar['vip_level']);
		if (isset($ar['is_first'])) $this->is_first = intval($ar['is_first']);
		if (isset($ar['device_id'])) $this->device_id = $ar['device_id'];
		
		
		$this->clean();
		
		return true;
	}
	
	
	public function  loadedCount( $fields=NULL,$condition=NULL)
	{
	
		if (empty($condition) && empty($this->pay_id))
		{
			return false;
		}
	
		$p = "*";
		$where = "`pay_id` = '{$this->pay_id}'";
	
		if(!empty($fields))
		{
			$p = SQLUtil::parseFields($fields);
		}
		if (!empty($condition))
		{
			$where =SQLUtil::parseCondition($condition);
		}
	
		$sql = "SELECT {$p} FROM `pay_info` WHERE {$where}";
	
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
    	
    	if (!isset($this->pay_id)){
    		$emptyFields = false;
    		$fields[] = 'pay_id';
    	}else{
    		$emptyCondition = false; 
    		$condition['pay_id']=$this->pay_id;
    	}
    	if (!isset($this->buyer_id)){
    		$emptyFields = false;
    		$fields[] = 'buyer_id';
    	}else{
    		$emptyCondition = false; 
    		$condition['buyer_id']=$this->buyer_id;
    	}
    	if (!isset($this->receiver_id)){
    		$emptyFields = false;
    		$fields[] = 'receiver_id';
    	}else{
    		$emptyCondition = false; 
    		$condition['receiver_id']=$this->receiver_id;
    	}
    	if (!isset($this->pay_type)){
    		$emptyFields = false;
    		$fields[] = 'pay_type';
    	}else{
    		$emptyCondition = false; 
    		$condition['pay_type']=$this->pay_type;
    	}
    	if (!isset($this->order_id)){
    		$emptyFields = false;
    		$fields[] = 'order_id';
    	}else{
    		$emptyCondition = false; 
    		$condition['order_id']=$this->order_id;
    	}
    	if (!isset($this->transaction_id)){
    		$emptyFields = false;
    		$fields[] = 'transaction_id';
    	}else{
    		$emptyCondition = false; 
    		$condition['transaction_id']=$this->transaction_id;
    	}
    	if (!isset($this->order_state)){
    		$emptyFields = false;
    		$fields[] = 'order_state';
    	}else{
    		$emptyCondition = false; 
    		$condition['order_state']=$this->order_state;
    	}
    	if (!isset($this->pay_money)){
    		$emptyFields = false;
    		$fields[] = 'pay_money';
    	}else{
    		$emptyCondition = false; 
    		$condition['pay_money']=$this->pay_money;
    	}
    	if (!isset($this->order_money)){
    		$emptyFields = false;
    		$fields[] = 'order_money';
    	}else{
    		$emptyCondition = false; 
    		$condition['order_money']=$this->order_money;
    	}
    	if (!isset($this->gold_num)){
    		$emptyFields = false;
    		$fields[] = 'gold_num';
    	}else{
    		$emptyCondition = false; 
    		$condition['gold_num']=$this->gold_num;
    	}
    	if (!isset($this->order_date)){
    		$emptyFields = false;
    		$fields[] = 'order_date';
    	}else{
    		$emptyCondition = false; 
    		$condition['order_date']=$this->order_date;
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
    	if (!isset($this->order_ip)){
    		$emptyFields = false;
    		$fields[] = 'order_ip';
    	}else{
    		$emptyCondition = false; 
    		$condition['order_ip']=$this->order_ip;
    	}
    	if (!isset($this->country)){
    		$emptyFields = false;
    		$fields[] = 'country';
    	}else{
    		$emptyCondition = false; 
    		$condition['country']=$this->country;
    	}
    	if (!isset($this->transaction_type)){
    		$emptyFields = false;
    		$fields[] = 'transaction_type';
    	}else{
    		$emptyCondition = false; 
    		$condition['transaction_type']=$this->transaction_type;
    	}
    	if (!isset($this->paypal_preapprovalkey)){
    		$emptyFields = false;
    		$fields[] = 'paypal_preapprovalkey';
    	}else{
    		$emptyCondition = false; 
    		$condition['paypal_preapprovalkey']=$this->paypal_preapprovalkey;
    	}
    	if (!isset($this->paypal_paykey)){
    		$emptyFields = false;
    		$fields[] = 'paypal_paykey';
    	}else{
    		$emptyCondition = false; 
    		$condition['paypal_paykey']=$this->paypal_paykey;
    	}
    	if (!isset($this->paypal_email)){
    		$emptyFields = false;
    		$fields[] = 'paypal_email';
    	}else{
    		$emptyCondition = false; 
    		$condition['paypal_email']=$this->paypal_email;
    	}
    	if (!isset($this->paypal_date)){
    		$emptyFields = false;
    		$fields[] = 'paypal_date';
    	}else{
    		$emptyCondition = false; 
    		$condition['paypal_date']=$this->paypal_date;
    	}
    	if (!isset($this->server_unique_flag)){
    		$emptyFields = false;
    		$fields[] = 'server_unique_flag';
    	}else{
    		$emptyCondition = false; 
    		$condition['server_unique_flag']=$this->server_unique_flag;
    	}
    	if (!isset($this->check_date)){
    		$emptyFields = false;
    		$fields[] = 'check_date';
    	}else{
    		$emptyCondition = false; 
    		$condition['check_date']=$this->check_date;
    	}
    	if (!isset($this->paypal_fee)){
    		$emptyFields = false;
    		$fields[] = 'paypal_fee';
    	}else{
    		$emptyCondition = false; 
    		$condition['paypal_fee']=$this->paypal_fee;
    	}
    	if (!isset($this->order_time)){
    		$emptyFields = false;
    		$fields[] = 'order_time';
    	}else{
    		$emptyCondition = false; 
    		$condition['order_time']=$this->order_time;
    	}
    	if (!isset($this->pay_time)){
    		$emptyFields = false;
    		$fields[] = 'pay_time';
    	}else{
    		$emptyCondition = false; 
    		$condition['pay_time']=$this->pay_time;
    	}
    	if (!isset($this->game_center_id)){
    		$emptyFields = false;
    		$fields[] = 'game_center_id';
    	}else{
    		$emptyCondition = false; 
    		$condition['game_center_id']=$this->game_center_id;
    	}
    	if (!isset($this->level)){
    		$emptyFields = false;
    		$fields[] = 'level';
    	}else{
    		$emptyCondition = false; 
    		$condition['level']=$this->level;
    	}
    	if (!isset($this->vip_level)){
    		$emptyFields = false;
    		$fields[] = 'vip_level';
    	}else{
    		$emptyCondition = false; 
    		$condition['vip_level']=$this->vip_level;
    	}
    	if (!isset($this->is_first)){
    		$emptyFields = false;
    		$fields[] = 'is_first';
    	}else{
    		$emptyCondition = false; 
    		$condition['is_first']=$this->is_first;
    	}
    	if (!isset($this->device_id)){
    		$emptyFields = false;
    		$fields[] = 'device_id';
    	}else{
    		$emptyCondition = false; 
    		$condition['device_id']=$this->device_id;
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
				
		if (empty($this->pay_id))
		{
			$this->pay_id = MySQL::getInstance()->GetInsertId();
		}		
		
		$this->clean();
		
		return true;	
		
	}
	
	public function save($condition=NULL)
	{
		if (empty($condition))
		{
			$uc = "`pay_id`='{$this->pay_id}'";
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
		
		$sql = "DELETE FROM `pay_info` WHERE ".SQLUtil::parseCondition($condition);
		
		$qr = MySQL::getInstance()->RunQuery($sql);
				
		return (boolean)$qr;
	}
	
	public function  delete()
	{
		if (!isset($this->pay_id))
		{
			return false;
		}
		
		$sql = "DELETE FROM `pay_info` WHERE `pay_id`='{$this->pay_id}'";
		
		MySQL::selectDefaultDb();
		$qr = MySQL::getInstance()->RunQuery($sql);
				
		return (boolean)$qr;
	}
	
	public function getInsertValue($fields)
	{
		$values = "(";		
		foreach($fields as $f => $k){
			if($f == 'pay_id'){
 				$values .= "'{$this->pay_id}',";
 			}else if($f == 'buyer_id'){
 				$values .= "'{$this->buyer_id}',";
 			}else if($f == 'receiver_id'){
 				$values .= "'{$this->receiver_id}',";
 			}else if($f == 'pay_type'){
 				$values .= "'{$this->pay_type}',";
 			}else if($f == 'order_id'){
 				$values .= "'{$this->order_id}',";
 			}else if($f == 'transaction_id'){
 				$values .= "'{$this->transaction_id}',";
 			}else if($f == 'order_state'){
 				$values .= "'{$this->order_state}',";
 			}else if($f == 'pay_money'){
 				$values .= "'{$this->pay_money}',";
 			}else if($f == 'order_money'){
 				$values .= "'{$this->order_money}',";
 			}else if($f == 'gold_num'){
 				$values .= "'{$this->gold_num}',";
 			}else if($f == 'order_date'){
 				$values .= "'{$this->order_date}',";
 			}else if($f == 'pay_date'){
 				$values .= "'{$this->pay_date}',";
 			}else if($f == 'remark'){
 				$values .= "'{$this->remark}',";
 			}else if($f == 'order_ip'){
 				$values .= "'{$this->order_ip}',";
 			}else if($f == 'country'){
 				$values .= "'{$this->country}',";
 			}else if($f == 'transaction_type'){
 				$values .= "'{$this->transaction_type}',";
 			}else if($f == 'paypal_preapprovalkey'){
 				$values .= "'{$this->paypal_preapprovalkey}',";
 			}else if($f == 'paypal_paykey'){
 				$values .= "'{$this->paypal_paykey}',";
 			}else if($f == 'paypal_email'){
 				$values .= "'{$this->paypal_email}',";
 			}else if($f == 'paypal_date'){
 				$values .= "'{$this->paypal_date}',";
 			}else if($f == 'server_unique_flag'){
 				$values .= "'{$this->server_unique_flag}',";
 			}else if($f == 'check_date'){
 				$values .= "'{$this->check_date}',";
 			}else if($f == 'paypal_fee'){
 				$values .= "'{$this->paypal_fee}',";
 			}else if($f == 'order_time'){
 				$values .= "'{$this->order_time}',";
 			}else if($f == 'pay_time'){
 				$values .= "'{$this->pay_time}',";
 			}else if($f == 'game_center_id'){
 				$values .= "'{$this->game_center_id}',";
 			}else if($f == 'level'){
 				$values .= "'{$this->level}',";
 			}else if($f == 'vip_level'){
 				$values .= "'{$this->vip_level}',";
 			}else if($f == 'is_first'){
 				$values .= "'{$this->is_first}',";
 			}else if($f == 'device_id'){
 				$values .= "'{$this->device_id}',";
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

		if (isset($this->pay_id))
		{
			$fields .= "`pay_id`,";
			$values .= "'{$this->pay_id}',";
		}
		if (isset($this->buyer_id))
		{
			$fields .= "`buyer_id`,";
			$values .= "'{$this->buyer_id}',";
		}
		if (isset($this->receiver_id))
		{
			$fields .= "`receiver_id`,";
			$values .= "'{$this->receiver_id}',";
		}
		if (isset($this->pay_type))
		{
			$fields .= "`pay_type`,";
			$values .= "'{$this->pay_type}',";
		}
		if (isset($this->order_id))
		{
			$fields .= "`order_id`,";
			$values .= "'{$this->order_id}',";
		}
		if (isset($this->transaction_id))
		{
			$fields .= "`transaction_id`,";
			$values .= "'{$this->transaction_id}',";
		}
		if (isset($this->order_state))
		{
			$fields .= "`order_state`,";
			$values .= "'{$this->order_state}',";
		}
		if (isset($this->pay_money))
		{
			$fields .= "`pay_money`,";
			$values .= "'{$this->pay_money}',";
		}
		if (isset($this->order_money))
		{
			$fields .= "`order_money`,";
			$values .= "'{$this->order_money}',";
		}
		if (isset($this->gold_num))
		{
			$fields .= "`gold_num`,";
			$values .= "'{$this->gold_num}',";
		}
		if (isset($this->order_date))
		{
			$fields .= "`order_date`,";
			$values .= "'{$this->order_date}',";
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
		if (isset($this->order_ip))
		{
			$fields .= "`order_ip`,";
			$values .= "'{$this->order_ip}',";
		}
		if (isset($this->country))
		{
			$fields .= "`country`,";
			$values .= "'{$this->country}',";
		}
		if (isset($this->transaction_type))
		{
			$fields .= "`transaction_type`,";
			$values .= "'{$this->transaction_type}',";
		}
		if (isset($this->paypal_preapprovalkey))
		{
			$fields .= "`paypal_preapprovalkey`,";
			$values .= "'{$this->paypal_preapprovalkey}',";
		}
		if (isset($this->paypal_paykey))
		{
			$fields .= "`paypal_paykey`,";
			$values .= "'{$this->paypal_paykey}',";
		}
		if (isset($this->paypal_email))
		{
			$fields .= "`paypal_email`,";
			$values .= "'{$this->paypal_email}',";
		}
		if (isset($this->paypal_date))
		{
			$fields .= "`paypal_date`,";
			$values .= "'{$this->paypal_date}',";
		}
		if (isset($this->server_unique_flag))
		{
			$fields .= "`server_unique_flag`,";
			$values .= "'{$this->server_unique_flag}',";
		}
		if (isset($this->check_date))
		{
			$fields .= "`check_date`,";
			$values .= "'{$this->check_date}',";
		}
		if (isset($this->paypal_fee))
		{
			$fields .= "`paypal_fee`,";
			$values .= "'{$this->paypal_fee}',";
		}
		if (isset($this->order_time))
		{
			$fields .= "`order_time`,";
			$values .= "'{$this->order_time}',";
		}
		if (isset($this->pay_time))
		{
			$fields .= "`pay_time`,";
			$values .= "'{$this->pay_time}',";
		}
		if (isset($this->game_center_id))
		{
			$fields .= "`game_center_id`,";
			$values .= "'{$this->game_center_id}',";
		}
		if (isset($this->level))
		{
			$fields .= "`level`,";
			$values .= "'{$this->level}',";
		}
		if (isset($this->vip_level))
		{
			$fields .= "`vip_level`,";
			$values .= "'{$this->vip_level}',";
		}
		if (isset($this->is_first))
		{
			$fields .= "`is_first`,";
			$values .= "'{$this->is_first}',";
		}
		if (isset($this->device_id))
		{
			$fields .= "`device_id`,";
			$values .= "'{$this->device_id}',";
		}

		
		$fields .= ")";
		$values .= ")";
		
		$sql = "INSERT INTO `pay_info` ".$fields.$values;
		
		return str_replace(",)",")",$sql);
	}
	
	private function  getUpFields()
	{
		$update = "";
		
		if ($this->buyer_id_status_field)
		{			
			if (!isset($this->buyer_id))
			{
				$update .= ("`buyer_id`=null,");
			}
			else
			{
				$update .= ("`buyer_id`='{$this->buyer_id}',");
			}
		}
		if ($this->receiver_id_status_field)
		{			
			if (!isset($this->receiver_id))
			{
				$update .= ("`receiver_id`=null,");
			}
			else
			{
				$update .= ("`receiver_id`='{$this->receiver_id}',");
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
		if ($this->order_id_status_field)
		{			
			if (!isset($this->order_id))
			{
				$update .= ("`order_id`=null,");
			}
			else
			{
				$update .= ("`order_id`='{$this->order_id}',");
			}
		}
		if ($this->transaction_id_status_field)
		{			
			if (!isset($this->transaction_id))
			{
				$update .= ("`transaction_id`=null,");
			}
			else
			{
				$update .= ("`transaction_id`='{$this->transaction_id}',");
			}
		}
		if ($this->order_state_status_field)
		{			
			if (!isset($this->order_state))
			{
				$update .= ("`order_state`=null,");
			}
			else
			{
				$update .= ("`order_state`='{$this->order_state}',");
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
		if ($this->order_money_status_field)
		{			
			if (!isset($this->order_money))
			{
				$update .= ("`order_money`=null,");
			}
			else
			{
				$update .= ("`order_money`='{$this->order_money}',");
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
		if ($this->order_date_status_field)
		{			
			if (!isset($this->order_date))
			{
				$update .= ("`order_date`=null,");
			}
			else
			{
				$update .= ("`order_date`='{$this->order_date}',");
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
		if ($this->order_ip_status_field)
		{			
			if (!isset($this->order_ip))
			{
				$update .= ("`order_ip`=null,");
			}
			else
			{
				$update .= ("`order_ip`='{$this->order_ip}',");
			}
		}
		if ($this->country_status_field)
		{			
			if (!isset($this->country))
			{
				$update .= ("`country`=null,");
			}
			else
			{
				$update .= ("`country`='{$this->country}',");
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
		if ($this->paypal_preapprovalkey_status_field)
		{			
			if (!isset($this->paypal_preapprovalkey))
			{
				$update .= ("`paypal_preapprovalkey`=null,");
			}
			else
			{
				$update .= ("`paypal_preapprovalkey`='{$this->paypal_preapprovalkey}',");
			}
		}
		if ($this->paypal_paykey_status_field)
		{			
			if (!isset($this->paypal_paykey))
			{
				$update .= ("`paypal_paykey`=null,");
			}
			else
			{
				$update .= ("`paypal_paykey`='{$this->paypal_paykey}',");
			}
		}
		if ($this->paypal_email_status_field)
		{			
			if (!isset($this->paypal_email))
			{
				$update .= ("`paypal_email`=null,");
			}
			else
			{
				$update .= ("`paypal_email`='{$this->paypal_email}',");
			}
		}
		if ($this->paypal_date_status_field)
		{			
			if (!isset($this->paypal_date))
			{
				$update .= ("`paypal_date`=null,");
			}
			else
			{
				$update .= ("`paypal_date`='{$this->paypal_date}',");
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
		if ($this->check_date_status_field)
		{			
			if (!isset($this->check_date))
			{
				$update .= ("`check_date`=null,");
			}
			else
			{
				$update .= ("`check_date`='{$this->check_date}',");
			}
		}
		if ($this->paypal_fee_status_field)
		{			
			if (!isset($this->paypal_fee))
			{
				$update .= ("`paypal_fee`=null,");
			}
			else
			{
				$update .= ("`paypal_fee`='{$this->paypal_fee}',");
			}
		}
		if ($this->order_time_status_field)
		{			
			if (!isset($this->order_time))
			{
				$update .= ("`order_time`=null,");
			}
			else
			{
				$update .= ("`order_time`='{$this->order_time}',");
			}
		}
		if ($this->pay_time_status_field)
		{			
			if (!isset($this->pay_time))
			{
				$update .= ("`pay_time`=null,");
			}
			else
			{
				$update .= ("`pay_time`='{$this->pay_time}',");
			}
		}
		if ($this->game_center_id_status_field)
		{			
			if (!isset($this->game_center_id))
			{
				$update .= ("`game_center_id`=null,");
			}
			else
			{
				$update .= ("`game_center_id`='{$this->game_center_id}',");
			}
		}
		if ($this->level_status_field)
		{			
			if (!isset($this->level))
			{
				$update .= ("`level`=null,");
			}
			else
			{
				$update .= ("`level`='{$this->level}',");
			}
		}
		if ($this->vip_level_status_field)
		{			
			if (!isset($this->vip_level))
			{
				$update .= ("`vip_level`=null,");
			}
			else
			{
				$update .= ("`vip_level`='{$this->vip_level}',");
			}
		}
		if ($this->is_first_status_field)
		{			
			if (!isset($this->is_first))
			{
				$update .= ("`is_first`=null,");
			}
			else
			{
				$update .= ("`is_first`='{$this->is_first}',");
			}
		}
		if ($this->device_id_status_field)
		{			
			if (!isset($this->device_id))
			{
				$update .= ("`device_id`=null,");
			}
			else
			{
				$update .= ("`device_id`='{$this->device_id}',");
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
		
		$sql = "UPDATE `pay_info` SET {$update} WHERE {$condition}";
		
		return $sql;
	}
	
	public function  add($fieldsValue,$condition=NULL)
	{				
		if (empty($condition))
		{
			$uc = "`pay_id`='{$this->pay_id}'";
		}
		else
		{			
			$uc = SQLUtil::parseCondition($condition);
		}
		
		$update = SQLUtil::parseASFieldValues($fieldsValue);
		
		$sql = "UPDATE `pay_info` SET {$update} WHERE {$uc}";
		
		MySQL::selectDefaultDb();
		$qr = MySQL::getInstance()->RunQuery($sql);
				
		return (boolean)$qr;
	}	
	
	public function sub($fieldsVal,$condition=NULL)
	{
		if (empty($condition))
		{
			$uc = "`pay_id`='{$this->pay_id}'";
		}
		else
		{			
			$uc = SQLUtil::parseCondition($condition);
		}
		
		$update = SQLUtil::parseASFieldValues($fieldsVal,false);
		
		$sql = "UPDATE `pay_info` SET {$update} WHERE {$uc}";
		
		MySQL::selectDefaultDb();
		$qr = MySQL::getInstance()->RunQuery($sql);
				
		return (boolean)$qr;
	}
	
	private function /*void*/ clean() 
	{
		$this->this_table_status_field = false;
		$this->pay_id_status_field = false;
		$this->buyer_id_status_field = false;
		$this->receiver_id_status_field = false;
		$this->pay_type_status_field = false;
		$this->order_id_status_field = false;
		$this->transaction_id_status_field = false;
		$this->order_state_status_field = false;
		$this->pay_money_status_field = false;
		$this->order_money_status_field = false;
		$this->gold_num_status_field = false;
		$this->order_date_status_field = false;
		$this->pay_date_status_field = false;
		$this->remark_status_field = false;
		$this->order_ip_status_field = false;
		$this->country_status_field = false;
		$this->transaction_type_status_field = false;
		$this->paypal_preapprovalkey_status_field = false;
		$this->paypal_paykey_status_field = false;
		$this->paypal_email_status_field = false;
		$this->paypal_date_status_field = false;
		$this->server_unique_flag_status_field = false;
		$this->check_date_status_field = false;
		$this->paypal_fee_status_field = false;
		$this->order_time_status_field = false;
		$this->pay_time_status_field = false;
		$this->game_center_id_status_field = false;
		$this->level_status_field = false;
		$this->vip_level_status_field = false;
		$this->is_first_status_field = false;
		$this->device_id_status_field = false;

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

	public function /*string*/ getBuyerId()
	{
		return $this->buyer_id;
	}
	
	public function /*void*/ setBuyerId(/*string*/ $buyer_id)
	{
		$this->buyer_id = SQLUtil::toSafeSQLString($buyer_id);
		$this->buyer_id_status_field = true;		
		$this->this_table_status_field = true;		
	}

	public function /*void*/ setBuyerIdNull()
	{
		$this->buyer_id = null;
		$this->buyer_id_status_field = true;		
		$this->this_table_status_field = true;
	}

	public function /*string*/ getReceiverId()
	{
		return $this->receiver_id;
	}
	
	public function /*void*/ setReceiverId(/*string*/ $receiver_id)
	{
		$this->receiver_id = SQLUtil::toSafeSQLString($receiver_id);
		$this->receiver_id_status_field = true;		
		$this->this_table_status_field = true;		
	}

	public function /*void*/ setReceiverIdNull()
	{
		$this->receiver_id = null;
		$this->receiver_id_status_field = true;		
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

	public function /*string*/ getOrderId()
	{
		return $this->order_id;
	}
	
	public function /*void*/ setOrderId(/*string*/ $order_id)
	{
		$this->order_id = SQLUtil::toSafeSQLString($order_id);
		$this->order_id_status_field = true;		
		$this->this_table_status_field = true;		
	}

	public function /*void*/ setOrderIdNull()
	{
		$this->order_id = null;
		$this->order_id_status_field = true;		
		$this->this_table_status_field = true;
	}

	public function /*string*/ getTransactionId()
	{
		return $this->transaction_id;
	}
	
	public function /*void*/ setTransactionId(/*string*/ $transaction_id)
	{
		$this->transaction_id = SQLUtil::toSafeSQLString($transaction_id);
		$this->transaction_id_status_field = true;		
		$this->this_table_status_field = true;		
	}

	public function /*void*/ setTransactionIdNull()
	{
		$this->transaction_id = null;
		$this->transaction_id_status_field = true;		
		$this->this_table_status_field = true;
	}

	public function /*int*/ getOrderState()
	{
		return $this->order_state;
	}
	
	public function /*void*/ setOrderState(/*int*/ $order_state)
	{
		$this->order_state = intval($order_state);
		$this->order_state_status_field = true;		
		$this->this_table_status_field = true;		
	}

	public function /*void*/ setOrderStateNull()
	{
		$this->order_state = null;
		$this->order_state_status_field = true;		
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

	public function /*double*/ getOrderMoney()
	{
		return $this->order_money;
	}
	
	public function /*void*/ setOrderMoney(/*double*/ $order_money)
	{
		$this->order_money = SQLUtil::toSafeSQLString($order_money);
		$this->order_money_status_field = true;		
		$this->this_table_status_field = true;		
	}

	public function /*void*/ setOrderMoneyNull()
	{
		$this->order_money = null;
		$this->order_money_status_field = true;		
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

	public function /*string*/ getOrderDate()
	{
		return $this->order_date;
	}
	
	public function /*void*/ setOrderDate(/*string*/ $order_date)
	{
		$this->order_date = SQLUtil::toSafeSQLString($order_date);
		$this->order_date_status_field = true;		
		$this->this_table_status_field = true;		
	}

	public function /*void*/ setOrderDateNull()
	{
		$this->order_date = null;
		$this->order_date_status_field = true;		
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

	public function /*string*/ getOrderIp()
	{
		return $this->order_ip;
	}
	
	public function /*void*/ setOrderIp(/*string*/ $order_ip)
	{
		$this->order_ip = SQLUtil::toSafeSQLString($order_ip);
		$this->order_ip_status_field = true;		
		$this->this_table_status_field = true;		
	}

	public function /*void*/ setOrderIpNull()
	{
		$this->order_ip = null;
		$this->order_ip_status_field = true;		
		$this->this_table_status_field = true;
	}

	public function /*string*/ getCountry()
	{
		return $this->country;
	}
	
	public function /*void*/ setCountry(/*string*/ $country)
	{
		$this->country = SQLUtil::toSafeSQLString($country);
		$this->country_status_field = true;		
		$this->this_table_status_field = true;		
	}

	public function /*void*/ setCountryNull()
	{
		$this->country = null;
		$this->country_status_field = true;		
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

	public function /*string*/ getPaypalPreapprovalkey()
	{
		return $this->paypal_preapprovalkey;
	}
	
	public function /*void*/ setPaypalPreapprovalkey(/*string*/ $paypal_preapprovalkey)
	{
		$this->paypal_preapprovalkey = SQLUtil::toSafeSQLString($paypal_preapprovalkey);
		$this->paypal_preapprovalkey_status_field = true;		
		$this->this_table_status_field = true;		
	}

	public function /*void*/ setPaypalPreapprovalkeyNull()
	{
		$this->paypal_preapprovalkey = null;
		$this->paypal_preapprovalkey_status_field = true;		
		$this->this_table_status_field = true;
	}

	public function /*string*/ getPaypalPaykey()
	{
		return $this->paypal_paykey;
	}
	
	public function /*void*/ setPaypalPaykey(/*string*/ $paypal_paykey)
	{
		$this->paypal_paykey = SQLUtil::toSafeSQLString($paypal_paykey);
		$this->paypal_paykey_status_field = true;		
		$this->this_table_status_field = true;		
	}

	public function /*void*/ setPaypalPaykeyNull()
	{
		$this->paypal_paykey = null;
		$this->paypal_paykey_status_field = true;		
		$this->this_table_status_field = true;
	}

	public function /*string*/ getPaypalEmail()
	{
		return $this->paypal_email;
	}
	
	public function /*void*/ setPaypalEmail(/*string*/ $paypal_email)
	{
		$this->paypal_email = SQLUtil::toSafeSQLString($paypal_email);
		$this->paypal_email_status_field = true;		
		$this->this_table_status_field = true;		
	}

	public function /*void*/ setPaypalEmailNull()
	{
		$this->paypal_email = null;
		$this->paypal_email_status_field = true;		
		$this->this_table_status_field = true;
	}

	public function /*string*/ getPaypalDate()
	{
		return $this->paypal_date;
	}
	
	public function /*void*/ setPaypalDate(/*string*/ $paypal_date)
	{
		$this->paypal_date = SQLUtil::toSafeSQLString($paypal_date);
		$this->paypal_date_status_field = true;		
		$this->this_table_status_field = true;		
	}

	public function /*void*/ setPaypalDateNull()
	{
		$this->paypal_date = null;
		$this->paypal_date_status_field = true;		
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

	public function /*string*/ getCheckDate()
	{
		return $this->check_date;
	}
	
	public function /*void*/ setCheckDate(/*string*/ $check_date)
	{
		$this->check_date = SQLUtil::toSafeSQLString($check_date);
		$this->check_date_status_field = true;		
		$this->this_table_status_field = true;		
	}

	public function /*void*/ setCheckDateNull()
	{
		$this->check_date = null;
		$this->check_date_status_field = true;		
		$this->this_table_status_field = true;
	}

	public function /*double*/ getPaypalFee()
	{
		return $this->paypal_fee;
	}
	
	public function /*void*/ setPaypalFee(/*double*/ $paypal_fee)
	{
		$this->paypal_fee = SQLUtil::toSafeSQLString($paypal_fee);
		$this->paypal_fee_status_field = true;		
		$this->this_table_status_field = true;		
	}

	public function /*void*/ setPaypalFeeNull()
	{
		$this->paypal_fee = null;
		$this->paypal_fee_status_field = true;		
		$this->this_table_status_field = true;
	}

	public function /*int*/ getOrderTime()
	{
		return $this->order_time;
	}
	
	public function /*void*/ setOrderTime(/*int*/ $order_time)
	{
		$this->order_time = intval($order_time);
		$this->order_time_status_field = true;		
		$this->this_table_status_field = true;		
	}

	public function /*void*/ setOrderTimeNull()
	{
		$this->order_time = null;
		$this->order_time_status_field = true;		
		$this->this_table_status_field = true;
	}

	public function /*int*/ getPayTime()
	{
		return $this->pay_time;
	}
	
	public function /*void*/ setPayTime(/*int*/ $pay_time)
	{
		$this->pay_time = intval($pay_time);
		$this->pay_time_status_field = true;		
		$this->this_table_status_field = true;		
	}

	public function /*void*/ setPayTimeNull()
	{
		$this->pay_time = null;
		$this->pay_time_status_field = true;		
		$this->this_table_status_field = true;
	}

	public function /*string*/ getGameCenterId()
	{
		return $this->game_center_id;
	}
	
	public function /*void*/ setGameCenterId(/*string*/ $game_center_id)
	{
		$this->game_center_id = SQLUtil::toSafeSQLString($game_center_id);
		$this->game_center_id_status_field = true;		
		$this->this_table_status_field = true;		
	}

	public function /*void*/ setGameCenterIdNull()
	{
		$this->game_center_id = null;
		$this->game_center_id_status_field = true;		
		$this->this_table_status_field = true;
	}

	public function /*int*/ getLevel()
	{
		return $this->level;
	}
	
	public function /*void*/ setLevel(/*int*/ $level)
	{
		$this->level = intval($level);
		$this->level_status_field = true;		
		$this->this_table_status_field = true;		
	}

	public function /*void*/ setLevelNull()
	{
		$this->level = null;
		$this->level_status_field = true;		
		$this->this_table_status_field = true;
	}

	public function /*int*/ getVipLevel()
	{
		return $this->vip_level;
	}
	
	public function /*void*/ setVipLevel(/*int*/ $vip_level)
	{
		$this->vip_level = intval($vip_level);
		$this->vip_level_status_field = true;		
		$this->this_table_status_field = true;		
	}

	public function /*void*/ setVipLevelNull()
	{
		$this->vip_level = null;
		$this->vip_level_status_field = true;		
		$this->this_table_status_field = true;
	}

	public function /*int*/ getIsFirst()
	{
		return $this->is_first;
	}
	
	public function /*void*/ setIsFirst(/*int*/ $is_first)
	{
		$this->is_first = intval($is_first);
		$this->is_first_status_field = true;		
		$this->this_table_status_field = true;		
	}

	public function /*void*/ setIsFirstNull()
	{
		$this->is_first = null;
		$this->is_first_status_field = true;		
		$this->this_table_status_field = true;
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

	
	public function /*string*/ toDebugString()
	{
		$dbg = "(";
		
		$dbg .= ("pay_id={$this->pay_id},");
		$dbg .= ("buyer_id={$this->buyer_id},");
		$dbg .= ("receiver_id={$this->receiver_id},");
		$dbg .= ("pay_type={$this->pay_type},");
		$dbg .= ("order_id={$this->order_id},");
		$dbg .= ("transaction_id={$this->transaction_id},");
		$dbg .= ("order_state={$this->order_state},");
		$dbg .= ("pay_money={$this->pay_money},");
		$dbg .= ("order_money={$this->order_money},");
		$dbg .= ("gold_num={$this->gold_num},");
		$dbg .= ("order_date={$this->order_date},");
		$dbg .= ("pay_date={$this->pay_date},");
		$dbg .= ("remark={$this->remark},");
		$dbg .= ("order_ip={$this->order_ip},");
		$dbg .= ("country={$this->country},");
		$dbg .= ("transaction_type={$this->transaction_type},");
		$dbg .= ("paypal_preapprovalkey={$this->paypal_preapprovalkey},");
		$dbg .= ("paypal_paykey={$this->paypal_paykey},");
		$dbg .= ("paypal_email={$this->paypal_email},");
		$dbg .= ("paypal_date={$this->paypal_date},");
		$dbg .= ("server_unique_flag={$this->server_unique_flag},");
		$dbg .= ("check_date={$this->check_date},");
		$dbg .= ("paypal_fee={$this->paypal_fee},");
		$dbg .= ("order_time={$this->order_time},");
		$dbg .= ("pay_time={$this->pay_time},");
		$dbg .= ("game_center_id={$this->game_center_id},");
		$dbg .= ("level={$this->level},");
		$dbg .= ("vip_level={$this->vip_level},");
		$dbg .= ("is_first={$this->is_first},");
		$dbg .= ("device_id={$this->device_id},");

		$dbg .= ")";
				
		return str_replace(",)",")",$dbg);
	}
}

?>
