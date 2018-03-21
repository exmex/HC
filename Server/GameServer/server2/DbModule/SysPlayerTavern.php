<?php
require_once ($GLOBALS ['GAME_ROOT'] . "CMySQL.php");
require_once ("SQLUtil.php");
/**
 *  [The generated files]
 */

class SysPlayerTavern {
	
	private /*string*/ $id; //PRIMARY KEY 
	private /*string*/ $user_id;
	private /*int*/ $box_type;
	private /*int*/ $left_count;
	private /*int*/ $last_claim_time;
	private /*int*/ $first_draw;
	private /*int*/ $free_claim_time;
	private /*int*/ $pay_num;
	private /*int*/ $fate_id;
	private /*int*/ $fate;
	private /*int*/ $double_rate;

	
	private $this_table_status_field = false;
	private $id_status_field = false;
	private $user_id_status_field = false;
	private $box_type_status_field = false;
	private $left_count_status_field = false;
	private $last_claim_time_status_field = false;
	private $first_draw_status_field = false;
	private $free_claim_time_status_field = false;
	private $pay_num_status_field = false;
	private $fate_id_status_field = false;
	private $fate_status_field = false;
	private $double_rate_status_field = false;


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
			$sql = "SELECT {$p} FROM `player_tavern`";
		}
		else
		{			
			$sql = "SELECT {$p} FROM `player_tavern` WHERE ".SQLUtil::parseCondition($condition);
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
			$tb = new SysPlayerTavern();			
			if (isset($row['id'])) $tb->id = $row['id'];
			if (isset($row['user_id'])) $tb->user_id = $row['user_id'];
			if (isset($row['box_type'])) $tb->box_type = intval($row['box_type']);
			if (isset($row['left_count'])) $tb->left_count = intval($row['left_count']);
			if (isset($row['last_claim_time'])) $tb->last_claim_time = intval($row['last_claim_time']);
			if (isset($row['first_draw'])) $tb->first_draw = intval($row['first_draw']);
			if (isset($row['free_claim_time'])) $tb->free_claim_time = intval($row['free_claim_time']);
			if (isset($row['pay_num'])) $tb->pay_num = intval($row['pay_num']);
			if (isset($row['fate_id'])) $tb->fate_id = intval($row['fate_id']);
			if (isset($row['fate'])) $tb->fate = intval($row['fate']);
			if (isset($row['double_rate'])) $tb->double_rate = intval($row['double_rate']);
		
			$result[] = $tb;
		}
		
		return $result;
	}	
	
	public static function insertSqlHeader($fields=NULL)
	{
		$result = array();				
		if(!empty($fields)){
			$where = SQLUtil::parseFields($fields);			
			$result[0] = "INSERT INTO `player_tavern` ({$where}) VALUES ";	
			$ar = array();
			foreach($fields as $key){
				$ar[$key]=1;
			}
			$result[1] = $ar;
		}else{
			$result[0]="INSERT INTO `player_tavern` (`id`,`user_id`,`box_type`,`left_count`,`last_claim_time`,`first_draw`,`free_claim_time`,`pay_num`,`fate_id`,`fate`,`double_rate`) VALUES ";
			$result[1] = array('id'=>1,'user_id'=>1,'box_type'=>1,'left_count'=>1,'last_claim_time'=>1,'first_draw'=>1,'free_claim_time'=>1,'pay_num'=>1,'fate_id'=>1,'fate'=>1,'double_rate'=>1);
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
		
		$sql = "SELECT {$p} FROM `player_tavern` WHERE {$where}";

		if(isset($this->user_id)){MySQL::selectDbForUser($this->user_id);}else{MySQL::selectDbForUser($GLOBALS['USER_ID']);}
		$qr = MySQL::getInstance()->RunQuery($sql);
		$ar = MySQL::getInstance()->FetchArray($qr);
		
		if (!$ar || count($ar)==0)
		{
			return false;
		}
		
		if (isset($ar['id'])) $this->id = $ar['id'];
		if (isset($ar['user_id'])) $this->user_id = $ar['user_id'];
		if (isset($ar['box_type'])) $this->box_type = intval($ar['box_type']);
		if (isset($ar['left_count'])) $this->left_count = intval($ar['left_count']);
		if (isset($ar['last_claim_time'])) $this->last_claim_time = intval($ar['last_claim_time']);
		if (isset($ar['first_draw'])) $this->first_draw = intval($ar['first_draw']);
		if (isset($ar['free_claim_time'])) $this->free_claim_time = intval($ar['free_claim_time']);
		if (isset($ar['pay_num'])) $this->pay_num = intval($ar['pay_num']);
		if (isset($ar['fate_id'])) $this->fate_id = intval($ar['fate_id']);
		if (isset($ar['fate'])) $this->fate = intval($ar['fate']);
		if (isset($ar['double_rate'])) $this->double_rate = intval($ar['double_rate']);
		
		
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
	
		$sql = "SELECT {$p} FROM `player_tavern` WHERE {$where}";
	
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
    	if (!isset($this->box_type)){
    		$emptyFields = false;
    		$fields[] = 'box_type';
    	}else{
    		$emptyCondition = false; 
    		$condition['box_type']=$this->box_type;
    	}
    	if (!isset($this->left_count)){
    		$emptyFields = false;
    		$fields[] = 'left_count';
    	}else{
    		$emptyCondition = false; 
    		$condition['left_count']=$this->left_count;
    	}
    	if (!isset($this->last_claim_time)){
    		$emptyFields = false;
    		$fields[] = 'last_claim_time';
    	}else{
    		$emptyCondition = false; 
    		$condition['last_claim_time']=$this->last_claim_time;
    	}
    	if (!isset($this->first_draw)){
    		$emptyFields = false;
    		$fields[] = 'first_draw';
    	}else{
    		$emptyCondition = false; 
    		$condition['first_draw']=$this->first_draw;
    	}
    	if (!isset($this->free_claim_time)){
    		$emptyFields = false;
    		$fields[] = 'free_claim_time';
    	}else{
    		$emptyCondition = false; 
    		$condition['free_claim_time']=$this->free_claim_time;
    	}
    	if (!isset($this->pay_num)){
    		$emptyFields = false;
    		$fields[] = 'pay_num';
    	}else{
    		$emptyCondition = false; 
    		$condition['pay_num']=$this->pay_num;
    	}
    	if (!isset($this->fate_id)){
    		$emptyFields = false;
    		$fields[] = 'fate_id';
    	}else{
    		$emptyCondition = false; 
    		$condition['fate_id']=$this->fate_id;
    	}
    	if (!isset($this->fate)){
    		$emptyFields = false;
    		$fields[] = 'fate';
    	}else{
    		$emptyCondition = false; 
    		$condition['fate']=$this->fate;
    	}
    	if (!isset($this->double_rate)){
    		$emptyFields = false;
    		$fields[] = 'double_rate';
    	}else{
    		$emptyCondition = false; 
    		$condition['double_rate']=$this->double_rate;
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
		
		$sql = "DELETE FROM `player_tavern` WHERE ".SQLUtil::parseCondition($condition);
		
		$qr = MySQL::getInstance()->RunQuery($sql);
				
		return (boolean)$qr;
	}
	
	public function  delete()
	{
		if (!isset($this->id))
		{
			return false;
		}
		
		$sql = "DELETE FROM `player_tavern` WHERE `id`='{$this->id}'";
		
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
 			}else if($f == 'box_type'){
 				$values .= "'{$this->box_type}',";
 			}else if($f == 'left_count'){
 				$values .= "'{$this->left_count}',";
 			}else if($f == 'last_claim_time'){
 				$values .= "'{$this->last_claim_time}',";
 			}else if($f == 'first_draw'){
 				$values .= "'{$this->first_draw}',";
 			}else if($f == 'free_claim_time'){
 				$values .= "'{$this->free_claim_time}',";
 			}else if($f == 'pay_num'){
 				$values .= "'{$this->pay_num}',";
 			}else if($f == 'fate_id'){
 				$values .= "'{$this->fate_id}',";
 			}else if($f == 'fate'){
 				$values .= "'{$this->fate}',";
 			}else if($f == 'double_rate'){
 				$values .= "'{$this->double_rate}',";
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
		if (isset($this->box_type))
		{
			$fields .= "`box_type`,";
			$values .= "'{$this->box_type}',";
		}
		if (isset($this->left_count))
		{
			$fields .= "`left_count`,";
			$values .= "'{$this->left_count}',";
		}
		if (isset($this->last_claim_time))
		{
			$fields .= "`last_claim_time`,";
			$values .= "'{$this->last_claim_time}',";
		}
		if (isset($this->first_draw))
		{
			$fields .= "`first_draw`,";
			$values .= "'{$this->first_draw}',";
		}
		if (isset($this->free_claim_time))
		{
			$fields .= "`free_claim_time`,";
			$values .= "'{$this->free_claim_time}',";
		}
		if (isset($this->pay_num))
		{
			$fields .= "`pay_num`,";
			$values .= "'{$this->pay_num}',";
		}
		if (isset($this->fate_id))
		{
			$fields .= "`fate_id`,";
			$values .= "'{$this->fate_id}',";
		}
		if (isset($this->fate))
		{
			$fields .= "`fate`,";
			$values .= "'{$this->fate}',";
		}
		if (isset($this->double_rate))
		{
			$fields .= "`double_rate`,";
			$values .= "'{$this->double_rate}',";
		}

		
		$fields .= ")";
		$values .= ")";
		
		$sql = "INSERT INTO `player_tavern` ".$fields.$values;
		
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
		if ($this->box_type_status_field)
		{			
			if (!isset($this->box_type))
			{
				$update .= ("`box_type`=null,");
			}
			else
			{
				$update .= ("`box_type`='{$this->box_type}',");
			}
		}
		if ($this->left_count_status_field)
		{			
			if (!isset($this->left_count))
			{
				$update .= ("`left_count`=null,");
			}
			else
			{
				$update .= ("`left_count`='{$this->left_count}',");
			}
		}
		if ($this->last_claim_time_status_field)
		{			
			if (!isset($this->last_claim_time))
			{
				$update .= ("`last_claim_time`=null,");
			}
			else
			{
				$update .= ("`last_claim_time`='{$this->last_claim_time}',");
			}
		}
		if ($this->first_draw_status_field)
		{			
			if (!isset($this->first_draw))
			{
				$update .= ("`first_draw`=null,");
			}
			else
			{
				$update .= ("`first_draw`='{$this->first_draw}',");
			}
		}
		if ($this->free_claim_time_status_field)
		{			
			if (!isset($this->free_claim_time))
			{
				$update .= ("`free_claim_time`=null,");
			}
			else
			{
				$update .= ("`free_claim_time`='{$this->free_claim_time}',");
			}
		}
		if ($this->pay_num_status_field)
		{			
			if (!isset($this->pay_num))
			{
				$update .= ("`pay_num`=null,");
			}
			else
			{
				$update .= ("`pay_num`='{$this->pay_num}',");
			}
		}
		if ($this->fate_id_status_field)
		{			
			if (!isset($this->fate_id))
			{
				$update .= ("`fate_id`=null,");
			}
			else
			{
				$update .= ("`fate_id`='{$this->fate_id}',");
			}
		}
		if ($this->fate_status_field)
		{			
			if (!isset($this->fate))
			{
				$update .= ("`fate`=null,");
			}
			else
			{
				$update .= ("`fate`='{$this->fate}',");
			}
		}
		if ($this->double_rate_status_field)
		{			
			if (!isset($this->double_rate))
			{
				$update .= ("`double_rate`=null,");
			}
			else
			{
				$update .= ("`double_rate`='{$this->double_rate}',");
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
		
		$sql = "UPDATE `player_tavern` SET {$update} WHERE {$condition}";
		
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
		
		$sql = "UPDATE `player_tavern` SET {$update} WHERE {$uc}";
		
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
		
		$sql = "UPDATE `player_tavern` SET {$update} WHERE {$uc}";
		
		if(isset($this->user_id)){MySQL::selectDbForUser($this->user_id);}else{MySQL::selectDbForUser($GLOBALS['USER_ID']);}
		$qr = MySQL::getInstance()->RunQuery($sql);
				
		return (boolean)$qr;
	}
	
	private function /*void*/ clean() 
	{
		$this->this_table_status_field = false;
		$this->id_status_field = false;
		$this->user_id_status_field = false;
		$this->box_type_status_field = false;
		$this->left_count_status_field = false;
		$this->last_claim_time_status_field = false;
		$this->first_draw_status_field = false;
		$this->free_claim_time_status_field = false;
		$this->pay_num_status_field = false;
		$this->fate_id_status_field = false;
		$this->fate_status_field = false;
		$this->double_rate_status_field = false;

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

	public function /*int*/ getBoxType()
	{
		return $this->box_type;
	}
	
	public function /*void*/ setBoxType(/*int*/ $box_type)
	{
		$this->box_type = intval($box_type);
		$this->box_type_status_field = true;		
		$this->this_table_status_field = true;		
	}

	public function /*void*/ setBoxTypeNull()
	{
		$this->box_type = null;
		$this->box_type_status_field = true;		
		$this->this_table_status_field = true;
	}

	public function /*int*/ getLeftCount()
	{
		return $this->left_count;
	}
	
	public function /*void*/ setLeftCount(/*int*/ $left_count)
	{
		$this->left_count = intval($left_count);
		$this->left_count_status_field = true;		
		$this->this_table_status_field = true;		
	}

	public function /*void*/ setLeftCountNull()
	{
		$this->left_count = null;
		$this->left_count_status_field = true;		
		$this->this_table_status_field = true;
	}

	public function /*int*/ getLastClaimTime()
	{
		return $this->last_claim_time;
	}
	
	public function /*void*/ setLastClaimTime(/*int*/ $last_claim_time)
	{
		$this->last_claim_time = intval($last_claim_time);
		$this->last_claim_time_status_field = true;		
		$this->this_table_status_field = true;		
	}

	public function /*void*/ setLastClaimTimeNull()
	{
		$this->last_claim_time = null;
		$this->last_claim_time_status_field = true;		
		$this->this_table_status_field = true;
	}

	public function /*int*/ getFirstDraw()
	{
		return $this->first_draw;
	}
	
	public function /*void*/ setFirstDraw(/*int*/ $first_draw)
	{
		$this->first_draw = intval($first_draw);
		$this->first_draw_status_field = true;		
		$this->this_table_status_field = true;		
	}

	public function /*void*/ setFirstDrawNull()
	{
		$this->first_draw = null;
		$this->first_draw_status_field = true;		
		$this->this_table_status_field = true;
	}

	public function /*int*/ getFreeClaimTime()
	{
		return $this->free_claim_time;
	}
	
	public function /*void*/ setFreeClaimTime(/*int*/ $free_claim_time)
	{
		$this->free_claim_time = intval($free_claim_time);
		$this->free_claim_time_status_field = true;		
		$this->this_table_status_field = true;		
	}

	public function /*void*/ setFreeClaimTimeNull()
	{
		$this->free_claim_time = null;
		$this->free_claim_time_status_field = true;		
		$this->this_table_status_field = true;
	}

	public function /*int*/ getPayNum()
	{
		return $this->pay_num;
	}
	
	public function /*void*/ setPayNum(/*int*/ $pay_num)
	{
		$this->pay_num = intval($pay_num);
		$this->pay_num_status_field = true;		
		$this->this_table_status_field = true;		
	}

	public function /*void*/ setPayNumNull()
	{
		$this->pay_num = null;
		$this->pay_num_status_field = true;		
		$this->this_table_status_field = true;
	}

	public function /*int*/ getFateId()
	{
		return $this->fate_id;
	}
	
	public function /*void*/ setFateId(/*int*/ $fate_id)
	{
		$this->fate_id = intval($fate_id);
		$this->fate_id_status_field = true;		
		$this->this_table_status_field = true;		
	}

	public function /*void*/ setFateIdNull()
	{
		$this->fate_id = null;
		$this->fate_id_status_field = true;		
		$this->this_table_status_field = true;
	}

	public function /*int*/ getFate()
	{
		return $this->fate;
	}
	
	public function /*void*/ setFate(/*int*/ $fate)
	{
		$this->fate = intval($fate);
		$this->fate_status_field = true;		
		$this->this_table_status_field = true;		
	}

	public function /*void*/ setFateNull()
	{
		$this->fate = null;
		$this->fate_status_field = true;		
		$this->this_table_status_field = true;
	}

	public function /*int*/ getDoubleRate()
	{
		return $this->double_rate;
	}
	
	public function /*void*/ setDoubleRate(/*int*/ $double_rate)
	{
		$this->double_rate = intval($double_rate);
		$this->double_rate_status_field = true;		
		$this->this_table_status_field = true;		
	}

	public function /*void*/ setDoubleRateNull()
	{
		$this->double_rate = null;
		$this->double_rate_status_field = true;		
		$this->this_table_status_field = true;
	}

	
	public function /*string*/ toDebugString()
	{
		$dbg = "(";
		
		$dbg .= ("id={$this->id},");
		$dbg .= ("user_id={$this->user_id},");
		$dbg .= ("box_type={$this->box_type},");
		$dbg .= ("left_count={$this->left_count},");
		$dbg .= ("last_claim_time={$this->last_claim_time},");
		$dbg .= ("first_draw={$this->first_draw},");
		$dbg .= ("free_claim_time={$this->free_claim_time},");
		$dbg .= ("pay_num={$this->pay_num},");
		$dbg .= ("fate_id={$this->fate_id},");
		$dbg .= ("fate={$this->fate},");
		$dbg .= ("double_rate={$this->double_rate},");

		$dbg .= ")";
				
		return str_replace(",)",")",$dbg);
	}
}

?>
