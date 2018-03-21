<?php
require_once ($GLOBALS ['GAME_ROOT'] . "CMySQL.php");
require_once ("SQLUtil.php");
/**
 *  [The generated files]
 */

class SysExcavateHistory {
	
	private /*string*/ $id; //PRIMARY KEY 
	private /*string*/ $user_id;
	private /*int*/ $excavate_id;
	private /*string*/ $enemy_name;
	private /*int*/ $enemy_svrid;
	private /*string*/ $enemy_svrname;
	private /*string*/ $def_result;
	private /*int*/ $time;
	private /*int*/ $bread;
	private /*string*/ $reward;

	
	private $this_table_status_field = false;
	private $id_status_field = false;
	private $user_id_status_field = false;
	private $excavate_id_status_field = false;
	private $enemy_name_status_field = false;
	private $enemy_svrid_status_field = false;
	private $enemy_svrname_status_field = false;
	private $def_result_status_field = false;
	private $time_status_field = false;
	private $bread_status_field = false;
	private $reward_status_field = false;


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
			$sql = "SELECT {$p} FROM `excavate_history`";
		}
		else
		{			
			$sql = "SELECT {$p} FROM `excavate_history` WHERE ".SQLUtil::parseCondition($condition);
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
			$tb = new SysExcavateHistory();			
			if (isset($row['id'])) $tb->id = $row['id'];
			if (isset($row['user_id'])) $tb->user_id = $row['user_id'];
			if (isset($row['excavate_id'])) $tb->excavate_id = intval($row['excavate_id']);
			if (isset($row['enemy_name'])) $tb->enemy_name = $row['enemy_name'];
			if (isset($row['enemy_svrid'])) $tb->enemy_svrid = intval($row['enemy_svrid']);
			if (isset($row['enemy_svrname'])) $tb->enemy_svrname = $row['enemy_svrname'];
			if (isset($row['def_result'])) $tb->def_result = $row['def_result'];
			if (isset($row['time'])) $tb->time = intval($row['time']);
			if (isset($row['bread'])) $tb->bread = intval($row['bread']);
			if (isset($row['reward'])) $tb->reward = $row['reward'];
		
			$result[] = $tb;
		}
		
		return $result;
	}	
	
	public static function insertSqlHeader($fields=NULL)
	{
		$result = array();				
		if(!empty($fields)){
			$where = SQLUtil::parseFields($fields);			
			$result[0] = "INSERT INTO `excavate_history` ({$where}) VALUES ";	
			$ar = array();
			foreach($fields as $key){
				$ar[$key]=1;
			}
			$result[1] = $ar;
		}else{
			$result[0]="INSERT INTO `excavate_history` (`id`,`user_id`,`excavate_id`,`enemy_name`,`enemy_svrid`,`enemy_svrname`,`def_result`,`time`,`bread`,`reward`) VALUES ";
			$result[1] = array('id'=>1,'user_id'=>1,'excavate_id'=>1,'enemy_name'=>1,'enemy_svrid'=>1,'enemy_svrname'=>1,'def_result'=>1,'time'=>1,'bread'=>1,'reward'=>1);
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
		
		$sql = "SELECT {$p} FROM `excavate_history` WHERE {$where}";

		MySQL::selectDefaultDb();
		$qr = MySQL::getInstance()->RunQuery($sql);
		$ar = MySQL::getInstance()->FetchArray($qr);
		
		if (!$ar || count($ar)==0)
		{
			return false;
		}
		
		if (isset($ar['id'])) $this->id = $ar['id'];
		if (isset($ar['user_id'])) $this->user_id = $ar['user_id'];
		if (isset($ar['excavate_id'])) $this->excavate_id = intval($ar['excavate_id']);
		if (isset($ar['enemy_name'])) $this->enemy_name = $ar['enemy_name'];
		if (isset($ar['enemy_svrid'])) $this->enemy_svrid = intval($ar['enemy_svrid']);
		if (isset($ar['enemy_svrname'])) $this->enemy_svrname = $ar['enemy_svrname'];
		if (isset($ar['def_result'])) $this->def_result = $ar['def_result'];
		if (isset($ar['time'])) $this->time = intval($ar['time']);
		if (isset($ar['bread'])) $this->bread = intval($ar['bread']);
		if (isset($ar['reward'])) $this->reward = $ar['reward'];
		
		
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
	
		$sql = "SELECT {$p} FROM `excavate_history` WHERE {$where}";
	
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
    	if (!isset($this->excavate_id)){
    		$emptyFields = false;
    		$fields[] = 'excavate_id';
    	}else{
    		$emptyCondition = false; 
    		$condition['excavate_id']=$this->excavate_id;
    	}
    	if (!isset($this->enemy_name)){
    		$emptyFields = false;
    		$fields[] = 'enemy_name';
    	}else{
    		$emptyCondition = false; 
    		$condition['enemy_name']=$this->enemy_name;
    	}
    	if (!isset($this->enemy_svrid)){
    		$emptyFields = false;
    		$fields[] = 'enemy_svrid';
    	}else{
    		$emptyCondition = false; 
    		$condition['enemy_svrid']=$this->enemy_svrid;
    	}
    	if (!isset($this->enemy_svrname)){
    		$emptyFields = false;
    		$fields[] = 'enemy_svrname';
    	}else{
    		$emptyCondition = false; 
    		$condition['enemy_svrname']=$this->enemy_svrname;
    	}
    	if (!isset($this->def_result)){
    		$emptyFields = false;
    		$fields[] = 'def_result';
    	}else{
    		$emptyCondition = false; 
    		$condition['def_result']=$this->def_result;
    	}
    	if (!isset($this->time)){
    		$emptyFields = false;
    		$fields[] = 'time';
    	}else{
    		$emptyCondition = false; 
    		$condition['time']=$this->time;
    	}
    	if (!isset($this->bread)){
    		$emptyFields = false;
    		$fields[] = 'bread';
    	}else{
    		$emptyCondition = false; 
    		$condition['bread']=$this->bread;
    	}
    	if (!isset($this->reward)){
    		$emptyFields = false;
    		$fields[] = 'reward';
    	}else{
    		$emptyCondition = false; 
    		$condition['reward']=$this->reward;
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
		
		$sql = "DELETE FROM `excavate_history` WHERE ".SQLUtil::parseCondition($condition);
		
		$qr = MySQL::getInstance()->RunQuery($sql);
				
		return (boolean)$qr;
	}
	
	public function  delete()
	{
		if (!isset($this->id))
		{
			return false;
		}
		
		$sql = "DELETE FROM `excavate_history` WHERE `id`='{$this->id}'";
		
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
 			}else if($f == 'excavate_id'){
 				$values .= "'{$this->excavate_id}',";
 			}else if($f == 'enemy_name'){
 				$values .= "'{$this->enemy_name}',";
 			}else if($f == 'enemy_svrid'){
 				$values .= "'{$this->enemy_svrid}',";
 			}else if($f == 'enemy_svrname'){
 				$values .= "'{$this->enemy_svrname}',";
 			}else if($f == 'def_result'){
 				$values .= "'{$this->def_result}',";
 			}else if($f == 'time'){
 				$values .= "'{$this->time}',";
 			}else if($f == 'bread'){
 				$values .= "'{$this->bread}',";
 			}else if($f == 'reward'){
 				$values .= "'{$this->reward}',";
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
		if (isset($this->excavate_id))
		{
			$fields .= "`excavate_id`,";
			$values .= "'{$this->excavate_id}',";
		}
		if (isset($this->enemy_name))
		{
			$fields .= "`enemy_name`,";
			$values .= "'{$this->enemy_name}',";
		}
		if (isset($this->enemy_svrid))
		{
			$fields .= "`enemy_svrid`,";
			$values .= "'{$this->enemy_svrid}',";
		}
		if (isset($this->enemy_svrname))
		{
			$fields .= "`enemy_svrname`,";
			$values .= "'{$this->enemy_svrname}',";
		}
		if (isset($this->def_result))
		{
			$fields .= "`def_result`,";
			$values .= "'{$this->def_result}',";
		}
		if (isset($this->time))
		{
			$fields .= "`time`,";
			$values .= "'{$this->time}',";
		}
		if (isset($this->bread))
		{
			$fields .= "`bread`,";
			$values .= "'{$this->bread}',";
		}
		if (isset($this->reward))
		{
			$fields .= "`reward`,";
			$values .= "'{$this->reward}',";
		}

		
		$fields .= ")";
		$values .= ")";
		
		$sql = "INSERT INTO `excavate_history` ".$fields.$values;
		
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
		if ($this->excavate_id_status_field)
		{			
			if (!isset($this->excavate_id))
			{
				$update .= ("`excavate_id`=null,");
			}
			else
			{
				$update .= ("`excavate_id`='{$this->excavate_id}',");
			}
		}
		if ($this->enemy_name_status_field)
		{			
			if (!isset($this->enemy_name))
			{
				$update .= ("`enemy_name`=null,");
			}
			else
			{
				$update .= ("`enemy_name`='{$this->enemy_name}',");
			}
		}
		if ($this->enemy_svrid_status_field)
		{			
			if (!isset($this->enemy_svrid))
			{
				$update .= ("`enemy_svrid`=null,");
			}
			else
			{
				$update .= ("`enemy_svrid`='{$this->enemy_svrid}',");
			}
		}
		if ($this->enemy_svrname_status_field)
		{			
			if (!isset($this->enemy_svrname))
			{
				$update .= ("`enemy_svrname`=null,");
			}
			else
			{
				$update .= ("`enemy_svrname`='{$this->enemy_svrname}',");
			}
		}
		if ($this->def_result_status_field)
		{			
			if (!isset($this->def_result))
			{
				$update .= ("`def_result`=null,");
			}
			else
			{
				$update .= ("`def_result`='{$this->def_result}',");
			}
		}
		if ($this->time_status_field)
		{			
			if (!isset($this->time))
			{
				$update .= ("`time`=null,");
			}
			else
			{
				$update .= ("`time`='{$this->time}',");
			}
		}
		if ($this->bread_status_field)
		{			
			if (!isset($this->bread))
			{
				$update .= ("`bread`=null,");
			}
			else
			{
				$update .= ("`bread`='{$this->bread}',");
			}
		}
		if ($this->reward_status_field)
		{			
			if (!isset($this->reward))
			{
				$update .= ("`reward`=null,");
			}
			else
			{
				$update .= ("`reward`='{$this->reward}',");
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
		
		$sql = "UPDATE `excavate_history` SET {$update} WHERE {$condition}";
		
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
		
		$sql = "UPDATE `excavate_history` SET {$update} WHERE {$uc}";
		
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
		
		$sql = "UPDATE `excavate_history` SET {$update} WHERE {$uc}";
		
		MySQL::selectDefaultDb();
		$qr = MySQL::getInstance()->RunQuery($sql);
				
		return (boolean)$qr;
	}
	
	private function /*void*/ clean() 
	{
		$this->this_table_status_field = false;
		$this->id_status_field = false;
		$this->user_id_status_field = false;
		$this->excavate_id_status_field = false;
		$this->enemy_name_status_field = false;
		$this->enemy_svrid_status_field = false;
		$this->enemy_svrname_status_field = false;
		$this->def_result_status_field = false;
		$this->time_status_field = false;
		$this->bread_status_field = false;
		$this->reward_status_field = false;

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

	public function /*int*/ getExcavateId()
	{
		return $this->excavate_id;
	}
	
	public function /*void*/ setExcavateId(/*int*/ $excavate_id)
	{
		$this->excavate_id = intval($excavate_id);
		$this->excavate_id_status_field = true;		
		$this->this_table_status_field = true;		
	}

	public function /*void*/ setExcavateIdNull()
	{
		$this->excavate_id = null;
		$this->excavate_id_status_field = true;		
		$this->this_table_status_field = true;
	}

	public function /*string*/ getEnemyName()
	{
		return $this->enemy_name;
	}
	
	public function /*void*/ setEnemyName(/*string*/ $enemy_name)
	{
		$this->enemy_name = SQLUtil::toSafeSQLString($enemy_name);
		$this->enemy_name_status_field = true;		
		$this->this_table_status_field = true;		
	}

	public function /*void*/ setEnemyNameNull()
	{
		$this->enemy_name = null;
		$this->enemy_name_status_field = true;		
		$this->this_table_status_field = true;
	}

	public function /*int*/ getEnemySvrid()
	{
		return $this->enemy_svrid;
	}
	
	public function /*void*/ setEnemySvrid(/*int*/ $enemy_svrid)
	{
		$this->enemy_svrid = intval($enemy_svrid);
		$this->enemy_svrid_status_field = true;		
		$this->this_table_status_field = true;		
	}

	public function /*void*/ setEnemySvridNull()
	{
		$this->enemy_svrid = null;
		$this->enemy_svrid_status_field = true;		
		$this->this_table_status_field = true;
	}

	public function /*string*/ getEnemySvrname()
	{
		return $this->enemy_svrname;
	}
	
	public function /*void*/ setEnemySvrname(/*string*/ $enemy_svrname)
	{
		$this->enemy_svrname = SQLUtil::toSafeSQLString($enemy_svrname);
		$this->enemy_svrname_status_field = true;		
		$this->this_table_status_field = true;		
	}

	public function /*void*/ setEnemySvrnameNull()
	{
		$this->enemy_svrname = null;
		$this->enemy_svrname_status_field = true;		
		$this->this_table_status_field = true;
	}

	public function /*string*/ getDefResult()
	{
		return $this->def_result;
	}
	
	public function /*void*/ setDefResult(/*string*/ $def_result)
	{
		$this->def_result = SQLUtil::toSafeSQLString($def_result);
		$this->def_result_status_field = true;		
		$this->this_table_status_field = true;		
	}

	public function /*void*/ setDefResultNull()
	{
		$this->def_result = null;
		$this->def_result_status_field = true;		
		$this->this_table_status_field = true;
	}

	public function /*int*/ getTime()
	{
		return $this->time;
	}
	
	public function /*void*/ setTime(/*int*/ $time)
	{
		$this->time = intval($time);
		$this->time_status_field = true;		
		$this->this_table_status_field = true;		
	}

	public function /*void*/ setTimeNull()
	{
		$this->time = null;
		$this->time_status_field = true;		
		$this->this_table_status_field = true;
	}

	public function /*int*/ getBread()
	{
		return $this->bread;
	}
	
	public function /*void*/ setBread(/*int*/ $bread)
	{
		$this->bread = intval($bread);
		$this->bread_status_field = true;		
		$this->this_table_status_field = true;		
	}

	public function /*void*/ setBreadNull()
	{
		$this->bread = null;
		$this->bread_status_field = true;		
		$this->this_table_status_field = true;
	}

	public function /*string*/ getReward()
	{
		return $this->reward;
	}
	
	public function /*void*/ setReward(/*string*/ $reward)
	{
		$this->reward = SQLUtil::toSafeSQLString($reward);
		$this->reward_status_field = true;		
		$this->this_table_status_field = true;		
	}

	public function /*void*/ setRewardNull()
	{
		$this->reward = null;
		$this->reward_status_field = true;		
		$this->this_table_status_field = true;
	}

	
	public function /*string*/ toDebugString()
	{
		$dbg = "(";
		
		$dbg .= ("id={$this->id},");
		$dbg .= ("user_id={$this->user_id},");
		$dbg .= ("excavate_id={$this->excavate_id},");
		$dbg .= ("enemy_name={$this->enemy_name},");
		$dbg .= ("enemy_svrid={$this->enemy_svrid},");
		$dbg .= ("enemy_svrname={$this->enemy_svrname},");
		$dbg .= ("def_result={$this->def_result},");
		$dbg .= ("time={$this->time},");
		$dbg .= ("bread={$this->bread},");
		$dbg .= ("reward={$this->reward},");

		$dbg .= ")";
				
		return str_replace(",)",")",$dbg);
	}
}

?>
