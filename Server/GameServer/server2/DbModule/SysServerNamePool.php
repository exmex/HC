<?php
require_once ($GLOBALS ['GAME_ROOT'] . "CMySQL.php");
require_once ("SQLUtil.php");
/**
 *  [The generated files]
 */

class SysServerNamePool {
	
	private /*int*/ $id; //PRIMARY KEY 
	private /*string*/ $server_name; //服务器名称
	private /*string*/ $server_name_zh; //服务器中文名称
	private /*int*/ $sort; //排序, 优先取小的
	private /*int*/ $is_used; //是否已经被使用
	private /*int*/ $use_time; //使用时间
	private /*int*/ $state; //是否可用

	
	private $this_table_status_field = false;
	private $id_status_field = false;
	private $server_name_status_field = false;
	private $server_name_zh_status_field = false;
	private $sort_status_field = false;
	private $is_used_status_field = false;
	private $use_time_status_field = false;
	private $state_status_field = false;


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
			$sql = "SELECT {$p} FROM `server_name_pool`";
		}
		else
		{			
			$sql = "SELECT {$p} FROM `server_name_pool` WHERE ".SQLUtil::parseCondition($condition);
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
			$tb = new SysServerNamePool();			
			if (isset($row['id'])) $tb->id = intval($row['id']);
			if (isset($row['server_name'])) $tb->server_name = $row['server_name'];
			if (isset($row['server_name_zh'])) $tb->server_name_zh = $row['server_name_zh'];
			if (isset($row['sort'])) $tb->sort = intval($row['sort']);
			if (isset($row['is_used'])) $tb->is_used = intval($row['is_used']);
			if (isset($row['use_time'])) $tb->use_time = intval($row['use_time']);
			if (isset($row['state'])) $tb->state = intval($row['state']);
		
			$result[] = $tb;
		}
		
		return $result;
	}	
	
	public static function insertSqlHeader($fields=NULL)
	{
		$result = array();				
		if(!empty($fields)){
			$where = SQLUtil::parseFields($fields);			
			$result[0] = "INSERT INTO `server_name_pool` ({$where}) VALUES ";	
			$ar = array();
			foreach($fields as $key){
				$ar[$key]=1;
			}
			$result[1] = $ar;
		}else{
			$result[0]="INSERT INTO `server_name_pool` (`id`,`server_name`,`server_name_zh`,`sort`,`is_used`,`use_time`,`state`) VALUES ";
			$result[1] = array('id'=>1,'server_name'=>1,'server_name_zh'=>1,'sort'=>1,'is_used'=>1,'use_time'=>1,'state'=>1);
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
		
		$sql = "SELECT {$p} FROM `server_name_pool` WHERE {$where}";

		MySQL::selectDefaultDb();
		$qr = MySQL::getInstance()->RunQuery($sql);
		$ar = MySQL::getInstance()->FetchArray($qr);
		
		if (!$ar || count($ar)==0)
		{
			return false;
		}
		
		if (isset($ar['id'])) $this->id = intval($ar['id']);
		if (isset($ar['server_name'])) $this->server_name = $ar['server_name'];
		if (isset($ar['server_name_zh'])) $this->server_name_zh = $ar['server_name_zh'];
		if (isset($ar['sort'])) $this->sort = intval($ar['sort']);
		if (isset($ar['is_used'])) $this->is_used = intval($ar['is_used']);
		if (isset($ar['use_time'])) $this->use_time = intval($ar['use_time']);
		if (isset($ar['state'])) $this->state = intval($ar['state']);
		
		
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
	
		$sql = "SELECT {$p} FROM `server_name_pool` WHERE {$where}";
	
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
    	if (!isset($this->server_name)){
    		$emptyFields = false;
    		$fields[] = 'server_name';
    	}else{
    		$emptyCondition = false; 
    		$condition['server_name']=$this->server_name;
    	}
    	if (!isset($this->server_name_zh)){
    		$emptyFields = false;
    		$fields[] = 'server_name_zh';
    	}else{
    		$emptyCondition = false; 
    		$condition['server_name_zh']=$this->server_name_zh;
    	}
    	if (!isset($this->sort)){
    		$emptyFields = false;
    		$fields[] = 'sort';
    	}else{
    		$emptyCondition = false; 
    		$condition['sort']=$this->sort;
    	}
    	if (!isset($this->is_used)){
    		$emptyFields = false;
    		$fields[] = 'is_used';
    	}else{
    		$emptyCondition = false; 
    		$condition['is_used']=$this->is_used;
    	}
    	if (!isset($this->use_time)){
    		$emptyFields = false;
    		$fields[] = 'use_time';
    	}else{
    		$emptyCondition = false; 
    		$condition['use_time']=$this->use_time;
    	}
    	if (!isset($this->state)){
    		$emptyFields = false;
    		$fields[] = 'state';
    	}else{
    		$emptyCondition = false; 
    		$condition['state']=$this->state;
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
		
		$sql = "DELETE FROM `server_name_pool` WHERE ".SQLUtil::parseCondition($condition);
		
		$qr = MySQL::getInstance()->RunQuery($sql);
				
		return (boolean)$qr;
	}
	
	public function  delete()
	{
		if (!isset($this->id))
		{
			return false;
		}
		
		$sql = "DELETE FROM `server_name_pool` WHERE `id`='{$this->id}'";
		
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
 			}else if($f == 'server_name'){
 				$values .= "'{$this->server_name}',";
 			}else if($f == 'server_name_zh'){
 				$values .= "'{$this->server_name_zh}',";
 			}else if($f == 'sort'){
 				$values .= "'{$this->sort}',";
 			}else if($f == 'is_used'){
 				$values .= "'{$this->is_used}',";
 			}else if($f == 'use_time'){
 				$values .= "'{$this->use_time}',";
 			}else if($f == 'state'){
 				$values .= "'{$this->state}',";
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
		if (isset($this->server_name))
		{
			$fields .= "`server_name`,";
			$values .= "'{$this->server_name}',";
		}
		if (isset($this->server_name_zh))
		{
			$fields .= "`server_name_zh`,";
			$values .= "'{$this->server_name_zh}',";
		}
		if (isset($this->sort))
		{
			$fields .= "`sort`,";
			$values .= "'{$this->sort}',";
		}
		if (isset($this->is_used))
		{
			$fields .= "`is_used`,";
			$values .= "'{$this->is_used}',";
		}
		if (isset($this->use_time))
		{
			$fields .= "`use_time`,";
			$values .= "'{$this->use_time}',";
		}
		if (isset($this->state))
		{
			$fields .= "`state`,";
			$values .= "'{$this->state}',";
		}

		
		$fields .= ")";
		$values .= ")";
		
		$sql = "INSERT INTO `server_name_pool` ".$fields.$values;
		
		return str_replace(",)",")",$sql);
	}
	
	private function  getUpFields()
	{
		$update = "";
		
		if ($this->server_name_status_field)
		{			
			if (!isset($this->server_name))
			{
				$update .= ("`server_name`=null,");
			}
			else
			{
				$update .= ("`server_name`='{$this->server_name}',");
			}
		}
		if ($this->server_name_zh_status_field)
		{			
			if (!isset($this->server_name_zh))
			{
				$update .= ("`server_name_zh`=null,");
			}
			else
			{
				$update .= ("`server_name_zh`='{$this->server_name_zh}',");
			}
		}
		if ($this->sort_status_field)
		{			
			if (!isset($this->sort))
			{
				$update .= ("`sort`=null,");
			}
			else
			{
				$update .= ("`sort`='{$this->sort}',");
			}
		}
		if ($this->is_used_status_field)
		{			
			if (!isset($this->is_used))
			{
				$update .= ("`is_used`=null,");
			}
			else
			{
				$update .= ("`is_used`='{$this->is_used}',");
			}
		}
		if ($this->use_time_status_field)
		{			
			if (!isset($this->use_time))
			{
				$update .= ("`use_time`=null,");
			}
			else
			{
				$update .= ("`use_time`='{$this->use_time}',");
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
		
		$sql = "UPDATE `server_name_pool` SET {$update} WHERE {$condition}";
		
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
		
		$sql = "UPDATE `server_name_pool` SET {$update} WHERE {$uc}";
		
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
		
		$sql = "UPDATE `server_name_pool` SET {$update} WHERE {$uc}";
		
		MySQL::selectDefaultDb();
		$qr = MySQL::getInstance()->RunQuery($sql);
				
		return (boolean)$qr;
	}
	
	private function /*void*/ clean() 
	{
		$this->this_table_status_field = false;
		$this->id_status_field = false;
		$this->server_name_status_field = false;
		$this->server_name_zh_status_field = false;
		$this->sort_status_field = false;
		$this->is_used_status_field = false;
		$this->use_time_status_field = false;
		$this->state_status_field = false;

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

	public function /*string*/ getServerName()
	{
		return $this->server_name;
	}
	
	public function /*void*/ setServerName(/*string*/ $server_name)
	{
		$this->server_name = SQLUtil::toSafeSQLString($server_name);
		$this->server_name_status_field = true;		
		$this->this_table_status_field = true;		
	}

	public function /*void*/ setServerNameNull()
	{
		$this->server_name = null;
		$this->server_name_status_field = true;		
		$this->this_table_status_field = true;
	}

	public function /*string*/ getServerNameZh()
	{
		return $this->server_name_zh;
	}
	
	public function /*void*/ setServerNameZh(/*string*/ $server_name_zh)
	{
		$this->server_name_zh = SQLUtil::toSafeSQLString($server_name_zh);
		$this->server_name_zh_status_field = true;		
		$this->this_table_status_field = true;		
	}

	public function /*void*/ setServerNameZhNull()
	{
		$this->server_name_zh = null;
		$this->server_name_zh_status_field = true;		
		$this->this_table_status_field = true;
	}

	public function /*int*/ getSort()
	{
		return $this->sort;
	}
	
	public function /*void*/ setSort(/*int*/ $sort)
	{
		$this->sort = intval($sort);
		$this->sort_status_field = true;		
		$this->this_table_status_field = true;		
	}

	public function /*void*/ setSortNull()
	{
		$this->sort = null;
		$this->sort_status_field = true;		
		$this->this_table_status_field = true;
	}

	public function /*int*/ getIsUsed()
	{
		return $this->is_used;
	}
	
	public function /*void*/ setIsUsed(/*int*/ $is_used)
	{
		$this->is_used = intval($is_used);
		$this->is_used_status_field = true;		
		$this->this_table_status_field = true;		
	}

	public function /*void*/ setIsUsedNull()
	{
		$this->is_used = null;
		$this->is_used_status_field = true;		
		$this->this_table_status_field = true;
	}

	public function /*int*/ getUseTime()
	{
		return $this->use_time;
	}
	
	public function /*void*/ setUseTime(/*int*/ $use_time)
	{
		$this->use_time = intval($use_time);
		$this->use_time_status_field = true;		
		$this->this_table_status_field = true;		
	}

	public function /*void*/ setUseTimeNull()
	{
		$this->use_time = null;
		$this->use_time_status_field = true;		
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

	
	public function /*string*/ toDebugString()
	{
		$dbg = "(";
		
		$dbg .= ("id={$this->id},");
		$dbg .= ("server_name={$this->server_name},");
		$dbg .= ("server_name_zh={$this->server_name_zh},");
		$dbg .= ("sort={$this->sort},");
		$dbg .= ("is_used={$this->is_used},");
		$dbg .= ("use_time={$this->use_time},");
		$dbg .= ("state={$this->state},");

		$dbg .= ")";
				
		return str_replace(",)",")",$dbg);
	}
}

?>
