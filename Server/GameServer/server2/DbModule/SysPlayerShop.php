<?php
require_once ($GLOBALS ['GAME_ROOT'] . "CMySQL.php");
require_once ("SQLUtil.php");
/**
 *  [The generated files]
 */

class SysPlayerShop {
	
	private /*string*/ $id; //PRIMARY KEY 
	private /*string*/ $user_id;
	private /*int*/ $shop_tid;
	private /*int*/ $last_auto_refresh_time;
	private /*int*/ $expire_time;
	private /*int*/ $last_manual_refresh_time;
	private /*int*/ $today_times;
	private /*string*/ $cur_goods;

	
	private $this_table_status_field = false;
	private $id_status_field = false;
	private $user_id_status_field = false;
	private $shop_tid_status_field = false;
	private $last_auto_refresh_time_status_field = false;
	private $expire_time_status_field = false;
	private $last_manual_refresh_time_status_field = false;
	private $today_times_status_field = false;
	private $cur_goods_status_field = false;


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
			$sql = "SELECT {$p} FROM `player_shop`";
		}
		else
		{			
			$sql = "SELECT {$p} FROM `player_shop` WHERE ".SQLUtil::parseCondition($condition);
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
			$tb = new SysPlayerShop();			
			if (isset($row['id'])) $tb->id = $row['id'];
			if (isset($row['user_id'])) $tb->user_id = $row['user_id'];
			if (isset($row['shop_tid'])) $tb->shop_tid = intval($row['shop_tid']);
			if (isset($row['last_auto_refresh_time'])) $tb->last_auto_refresh_time = intval($row['last_auto_refresh_time']);
			if (isset($row['expire_time'])) $tb->expire_time = intval($row['expire_time']);
			if (isset($row['last_manual_refresh_time'])) $tb->last_manual_refresh_time = intval($row['last_manual_refresh_time']);
			if (isset($row['today_times'])) $tb->today_times = intval($row['today_times']);
			if (isset($row['cur_goods'])) $tb->cur_goods = $row['cur_goods'];
		
			$result[] = $tb;
		}
		
		return $result;
	}	
	
	public static function insertSqlHeader($fields=NULL)
	{
		$result = array();				
		if(!empty($fields)){
			$where = SQLUtil::parseFields($fields);			
			$result[0] = "INSERT INTO `player_shop` ({$where}) VALUES ";	
			$ar = array();
			foreach($fields as $key){
				$ar[$key]=1;
			}
			$result[1] = $ar;
		}else{
			$result[0]="INSERT INTO `player_shop` (`id`,`user_id`,`shop_tid`,`last_auto_refresh_time`,`expire_time`,`last_manual_refresh_time`,`today_times`,`cur_goods`) VALUES ";
			$result[1] = array('id'=>1,'user_id'=>1,'shop_tid'=>1,'last_auto_refresh_time'=>1,'expire_time'=>1,'last_manual_refresh_time'=>1,'today_times'=>1,'cur_goods'=>1);
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
		
		$sql = "SELECT {$p} FROM `player_shop` WHERE {$where}";

		if(isset($this->user_id)){MySQL::selectDbForUser($this->user_id);}else{MySQL::selectDbForUser($GLOBALS['USER_ID']);}
		$qr = MySQL::getInstance()->RunQuery($sql);
		$ar = MySQL::getInstance()->FetchArray($qr);
		
		if (!$ar || count($ar)==0)
		{
			return false;
		}
		
		if (isset($ar['id'])) $this->id = $ar['id'];
		if (isset($ar['user_id'])) $this->user_id = $ar['user_id'];
		if (isset($ar['shop_tid'])) $this->shop_tid = intval($ar['shop_tid']);
		if (isset($ar['last_auto_refresh_time'])) $this->last_auto_refresh_time = intval($ar['last_auto_refresh_time']);
		if (isset($ar['expire_time'])) $this->expire_time = intval($ar['expire_time']);
		if (isset($ar['last_manual_refresh_time'])) $this->last_manual_refresh_time = intval($ar['last_manual_refresh_time']);
		if (isset($ar['today_times'])) $this->today_times = intval($ar['today_times']);
		if (isset($ar['cur_goods'])) $this->cur_goods = $ar['cur_goods'];
		
		
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
	
		$sql = "SELECT {$p} FROM `player_shop` WHERE {$where}";
	
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
    	if (!isset($this->shop_tid)){
    		$emptyFields = false;
    		$fields[] = 'shop_tid';
    	}else{
    		$emptyCondition = false; 
    		$condition['shop_tid']=$this->shop_tid;
    	}
    	if (!isset($this->last_auto_refresh_time)){
    		$emptyFields = false;
    		$fields[] = 'last_auto_refresh_time';
    	}else{
    		$emptyCondition = false; 
    		$condition['last_auto_refresh_time']=$this->last_auto_refresh_time;
    	}
    	if (!isset($this->expire_time)){
    		$emptyFields = false;
    		$fields[] = 'expire_time';
    	}else{
    		$emptyCondition = false; 
    		$condition['expire_time']=$this->expire_time;
    	}
    	if (!isset($this->last_manual_refresh_time)){
    		$emptyFields = false;
    		$fields[] = 'last_manual_refresh_time';
    	}else{
    		$emptyCondition = false; 
    		$condition['last_manual_refresh_time']=$this->last_manual_refresh_time;
    	}
    	if (!isset($this->today_times)){
    		$emptyFields = false;
    		$fields[] = 'today_times';
    	}else{
    		$emptyCondition = false; 
    		$condition['today_times']=$this->today_times;
    	}
    	if (!isset($this->cur_goods)){
    		$emptyFields = false;
    		$fields[] = 'cur_goods';
    	}else{
    		$emptyCondition = false; 
    		$condition['cur_goods']=$this->cur_goods;
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
		
		$sql = "DELETE FROM `player_shop` WHERE ".SQLUtil::parseCondition($condition);
		
		$qr = MySQL::getInstance()->RunQuery($sql);
				
		return (boolean)$qr;
	}
	
	public function  delete()
	{
		if (!isset($this->id))
		{
			return false;
		}
		
		$sql = "DELETE FROM `player_shop` WHERE `id`='{$this->id}'";
		
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
 			}else if($f == 'shop_tid'){
 				$values .= "'{$this->shop_tid}',";
 			}else if($f == 'last_auto_refresh_time'){
 				$values .= "'{$this->last_auto_refresh_time}',";
 			}else if($f == 'expire_time'){
 				$values .= "'{$this->expire_time}',";
 			}else if($f == 'last_manual_refresh_time'){
 				$values .= "'{$this->last_manual_refresh_time}',";
 			}else if($f == 'today_times'){
 				$values .= "'{$this->today_times}',";
 			}else if($f == 'cur_goods'){
 				$values .= "'{$this->cur_goods}',";
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
		if (isset($this->shop_tid))
		{
			$fields .= "`shop_tid`,";
			$values .= "'{$this->shop_tid}',";
		}
		if (isset($this->last_auto_refresh_time))
		{
			$fields .= "`last_auto_refresh_time`,";
			$values .= "'{$this->last_auto_refresh_time}',";
		}
		if (isset($this->expire_time))
		{
			$fields .= "`expire_time`,";
			$values .= "'{$this->expire_time}',";
		}
		if (isset($this->last_manual_refresh_time))
		{
			$fields .= "`last_manual_refresh_time`,";
			$values .= "'{$this->last_manual_refresh_time}',";
		}
		if (isset($this->today_times))
		{
			$fields .= "`today_times`,";
			$values .= "'{$this->today_times}',";
		}
		if (isset($this->cur_goods))
		{
			$fields .= "`cur_goods`,";
			$values .= "'{$this->cur_goods}',";
		}

		
		$fields .= ")";
		$values .= ")";
		
		$sql = "INSERT INTO `player_shop` ".$fields.$values;
		
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
		if ($this->shop_tid_status_field)
		{			
			if (!isset($this->shop_tid))
			{
				$update .= ("`shop_tid`=null,");
			}
			else
			{
				$update .= ("`shop_tid`='{$this->shop_tid}',");
			}
		}
		if ($this->last_auto_refresh_time_status_field)
		{			
			if (!isset($this->last_auto_refresh_time))
			{
				$update .= ("`last_auto_refresh_time`=null,");
			}
			else
			{
				$update .= ("`last_auto_refresh_time`='{$this->last_auto_refresh_time}',");
			}
		}
		if ($this->expire_time_status_field)
		{			
			if (!isset($this->expire_time))
			{
				$update .= ("`expire_time`=null,");
			}
			else
			{
				$update .= ("`expire_time`='{$this->expire_time}',");
			}
		}
		if ($this->last_manual_refresh_time_status_field)
		{			
			if (!isset($this->last_manual_refresh_time))
			{
				$update .= ("`last_manual_refresh_time`=null,");
			}
			else
			{
				$update .= ("`last_manual_refresh_time`='{$this->last_manual_refresh_time}',");
			}
		}
		if ($this->today_times_status_field)
		{			
			if (!isset($this->today_times))
			{
				$update .= ("`today_times`=null,");
			}
			else
			{
				$update .= ("`today_times`='{$this->today_times}',");
			}
		}
		if ($this->cur_goods_status_field)
		{			
			if (!isset($this->cur_goods))
			{
				$update .= ("`cur_goods`=null,");
			}
			else
			{
				$update .= ("`cur_goods`='{$this->cur_goods}',");
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
		
		$sql = "UPDATE `player_shop` SET {$update} WHERE {$condition}";
		
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
		
		$sql = "UPDATE `player_shop` SET {$update} WHERE {$uc}";
		
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
		
		$sql = "UPDATE `player_shop` SET {$update} WHERE {$uc}";
		
		if(isset($this->user_id)){MySQL::selectDbForUser($this->user_id);}else{MySQL::selectDbForUser($GLOBALS['USER_ID']);}
		$qr = MySQL::getInstance()->RunQuery($sql);
				
		return (boolean)$qr;
	}
	
	private function /*void*/ clean() 
	{
		$this->this_table_status_field = false;
		$this->id_status_field = false;
		$this->user_id_status_field = false;
		$this->shop_tid_status_field = false;
		$this->last_auto_refresh_time_status_field = false;
		$this->expire_time_status_field = false;
		$this->last_manual_refresh_time_status_field = false;
		$this->today_times_status_field = false;
		$this->cur_goods_status_field = false;

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

	public function /*int*/ getShopTid()
	{
		return $this->shop_tid;
	}
	
	public function /*void*/ setShopTid(/*int*/ $shop_tid)
	{
		$this->shop_tid = intval($shop_tid);
		$this->shop_tid_status_field = true;		
		$this->this_table_status_field = true;		
	}

	public function /*void*/ setShopTidNull()
	{
		$this->shop_tid = null;
		$this->shop_tid_status_field = true;		
		$this->this_table_status_field = true;
	}

	public function /*int*/ getLastAutoRefreshTime()
	{
		return $this->last_auto_refresh_time;
	}
	
	public function /*void*/ setLastAutoRefreshTime(/*int*/ $last_auto_refresh_time)
	{
		$this->last_auto_refresh_time = intval($last_auto_refresh_time);
		$this->last_auto_refresh_time_status_field = true;		
		$this->this_table_status_field = true;		
	}

	public function /*void*/ setLastAutoRefreshTimeNull()
	{
		$this->last_auto_refresh_time = null;
		$this->last_auto_refresh_time_status_field = true;		
		$this->this_table_status_field = true;
	}

	public function /*int*/ getExpireTime()
	{
		return $this->expire_time;
	}
	
	public function /*void*/ setExpireTime(/*int*/ $expire_time)
	{
		$this->expire_time = intval($expire_time);
		$this->expire_time_status_field = true;		
		$this->this_table_status_field = true;		
	}

	public function /*void*/ setExpireTimeNull()
	{
		$this->expire_time = null;
		$this->expire_time_status_field = true;		
		$this->this_table_status_field = true;
	}

	public function /*int*/ getLastManualRefreshTime()
	{
		return $this->last_manual_refresh_time;
	}
	
	public function /*void*/ setLastManualRefreshTime(/*int*/ $last_manual_refresh_time)
	{
		$this->last_manual_refresh_time = intval($last_manual_refresh_time);
		$this->last_manual_refresh_time_status_field = true;		
		$this->this_table_status_field = true;		
	}

	public function /*void*/ setLastManualRefreshTimeNull()
	{
		$this->last_manual_refresh_time = null;
		$this->last_manual_refresh_time_status_field = true;		
		$this->this_table_status_field = true;
	}

	public function /*int*/ getTodayTimes()
	{
		return $this->today_times;
	}
	
	public function /*void*/ setTodayTimes(/*int*/ $today_times)
	{
		$this->today_times = intval($today_times);
		$this->today_times_status_field = true;		
		$this->this_table_status_field = true;		
	}

	public function /*void*/ setTodayTimesNull()
	{
		$this->today_times = null;
		$this->today_times_status_field = true;		
		$this->this_table_status_field = true;
	}

	public function /*string*/ getCurGoods()
	{
		return $this->cur_goods;
	}
	
	public function /*void*/ setCurGoods(/*string*/ $cur_goods)
	{
		$this->cur_goods = SQLUtil::toSafeSQLString($cur_goods);
		$this->cur_goods_status_field = true;		
		$this->this_table_status_field = true;		
	}

	public function /*void*/ setCurGoodsNull()
	{
		$this->cur_goods = null;
		$this->cur_goods_status_field = true;		
		$this->this_table_status_field = true;
	}

	
	public function /*string*/ toDebugString()
	{
		$dbg = "(";
		
		$dbg .= ("id={$this->id},");
		$dbg .= ("user_id={$this->user_id},");
		$dbg .= ("shop_tid={$this->shop_tid},");
		$dbg .= ("last_auto_refresh_time={$this->last_auto_refresh_time},");
		$dbg .= ("expire_time={$this->expire_time},");
		$dbg .= ("last_manual_refresh_time={$this->last_manual_refresh_time},");
		$dbg .= ("today_times={$this->today_times},");
		$dbg .= ("cur_goods={$this->cur_goods},");

		$dbg .= ")";
				
		return str_replace(",)",")",$dbg);
	}
}

?>
