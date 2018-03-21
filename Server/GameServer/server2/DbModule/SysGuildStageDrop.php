<?php
require_once ($GLOBALS ['GAME_ROOT'] . "CMySQL.php");
require_once ("SQLUtil.php");
/**
 *  [The generated files]
 */

class SysGuildStageDrop {
	
	private /*string*/ $id; //PRIMARY KEY 
	private /*string*/ $guild_id;
	private /*int*/ $raid_id;
	private /*int*/ $item_id;
	private /*int*/ $drop_count;
	private /*string*/ $drop_user_id;
	private /*int*/ $drop_time;
	private /*int*/ $distribute_count;
	private /*int*/ $min_distribute_time;
	private /*int*/ $state;

	
	private $this_table_status_field = false;
	private $id_status_field = false;
	private $guild_id_status_field = false;
	private $raid_id_status_field = false;
	private $item_id_status_field = false;
	private $drop_count_status_field = false;
	private $drop_user_id_status_field = false;
	private $drop_time_status_field = false;
	private $distribute_count_status_field = false;
	private $min_distribute_time_status_field = false;
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
			$sql = "SELECT {$p} FROM `guild_stage_drop`";
		}
		else
		{			
			$sql = "SELECT {$p} FROM `guild_stage_drop` WHERE ".SQLUtil::parseCondition($condition);
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
			$tb = new SysGuildStageDrop();			
			if (isset($row['id'])) $tb->id = $row['id'];
			if (isset($row['guild_id'])) $tb->guild_id = $row['guild_id'];
			if (isset($row['raid_id'])) $tb->raid_id = intval($row['raid_id']);
			if (isset($row['item_id'])) $tb->item_id = intval($row['item_id']);
			if (isset($row['drop_count'])) $tb->drop_count = intval($row['drop_count']);
			if (isset($row['drop_user_id'])) $tb->drop_user_id = $row['drop_user_id'];
			if (isset($row['drop_time'])) $tb->drop_time = intval($row['drop_time']);
			if (isset($row['distribute_count'])) $tb->distribute_count = intval($row['distribute_count']);
			if (isset($row['min_distribute_time'])) $tb->min_distribute_time = intval($row['min_distribute_time']);
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
			$result[0] = "INSERT INTO `guild_stage_drop` ({$where}) VALUES ";	
			$ar = array();
			foreach($fields as $key){
				$ar[$key]=1;
			}
			$result[1] = $ar;
		}else{
			$result[0]="INSERT INTO `guild_stage_drop` (`id`,`guild_id`,`raid_id`,`item_id`,`drop_count`,`drop_user_id`,`drop_time`,`distribute_count`,`min_distribute_time`,`state`) VALUES ";
			$result[1] = array('id'=>1,'guild_id'=>1,'raid_id'=>1,'item_id'=>1,'drop_count'=>1,'drop_user_id'=>1,'drop_time'=>1,'distribute_count'=>1,'min_distribute_time'=>1,'state'=>1);
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
		
		$sql = "SELECT {$p} FROM `guild_stage_drop` WHERE {$where}";

		MySQL::selectDefaultDb();
		$qr = MySQL::getInstance()->RunQuery($sql);
		$ar = MySQL::getInstance()->FetchArray($qr);
		
		if (!$ar || count($ar)==0)
		{
			return false;
		}
		
		if (isset($ar['id'])) $this->id = $ar['id'];
		if (isset($ar['guild_id'])) $this->guild_id = $ar['guild_id'];
		if (isset($ar['raid_id'])) $this->raid_id = intval($ar['raid_id']);
		if (isset($ar['item_id'])) $this->item_id = intval($ar['item_id']);
		if (isset($ar['drop_count'])) $this->drop_count = intval($ar['drop_count']);
		if (isset($ar['drop_user_id'])) $this->drop_user_id = $ar['drop_user_id'];
		if (isset($ar['drop_time'])) $this->drop_time = intval($ar['drop_time']);
		if (isset($ar['distribute_count'])) $this->distribute_count = intval($ar['distribute_count']);
		if (isset($ar['min_distribute_time'])) $this->min_distribute_time = intval($ar['min_distribute_time']);
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
	
		$sql = "SELECT {$p} FROM `guild_stage_drop` WHERE {$where}";
	
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
    	if (!isset($this->guild_id)){
    		$emptyFields = false;
    		$fields[] = 'guild_id';
    	}else{
    		$emptyCondition = false; 
    		$condition['guild_id']=$this->guild_id;
    	}
    	if (!isset($this->raid_id)){
    		$emptyFields = false;
    		$fields[] = 'raid_id';
    	}else{
    		$emptyCondition = false; 
    		$condition['raid_id']=$this->raid_id;
    	}
    	if (!isset($this->item_id)){
    		$emptyFields = false;
    		$fields[] = 'item_id';
    	}else{
    		$emptyCondition = false; 
    		$condition['item_id']=$this->item_id;
    	}
    	if (!isset($this->drop_count)){
    		$emptyFields = false;
    		$fields[] = 'drop_count';
    	}else{
    		$emptyCondition = false; 
    		$condition['drop_count']=$this->drop_count;
    	}
    	if (!isset($this->drop_user_id)){
    		$emptyFields = false;
    		$fields[] = 'drop_user_id';
    	}else{
    		$emptyCondition = false; 
    		$condition['drop_user_id']=$this->drop_user_id;
    	}
    	if (!isset($this->drop_time)){
    		$emptyFields = false;
    		$fields[] = 'drop_time';
    	}else{
    		$emptyCondition = false; 
    		$condition['drop_time']=$this->drop_time;
    	}
    	if (!isset($this->distribute_count)){
    		$emptyFields = false;
    		$fields[] = 'distribute_count';
    	}else{
    		$emptyCondition = false; 
    		$condition['distribute_count']=$this->distribute_count;
    	}
    	if (!isset($this->min_distribute_time)){
    		$emptyFields = false;
    		$fields[] = 'min_distribute_time';
    	}else{
    		$emptyCondition = false; 
    		$condition['min_distribute_time']=$this->min_distribute_time;
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
		
		$sql = "DELETE FROM `guild_stage_drop` WHERE ".SQLUtil::parseCondition($condition);
		
		$qr = MySQL::getInstance()->RunQuery($sql);
				
		return (boolean)$qr;
	}
	
	public function  delete()
	{
		if (!isset($this->id))
		{
			return false;
		}
		
		$sql = "DELETE FROM `guild_stage_drop` WHERE `id`='{$this->id}'";
		
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
 			}else if($f == 'guild_id'){
 				$values .= "'{$this->guild_id}',";
 			}else if($f == 'raid_id'){
 				$values .= "'{$this->raid_id}',";
 			}else if($f == 'item_id'){
 				$values .= "'{$this->item_id}',";
 			}else if($f == 'drop_count'){
 				$values .= "'{$this->drop_count}',";
 			}else if($f == 'drop_user_id'){
 				$values .= "'{$this->drop_user_id}',";
 			}else if($f == 'drop_time'){
 				$values .= "'{$this->drop_time}',";
 			}else if($f == 'distribute_count'){
 				$values .= "'{$this->distribute_count}',";
 			}else if($f == 'min_distribute_time'){
 				$values .= "'{$this->min_distribute_time}',";
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
		if (isset($this->guild_id))
		{
			$fields .= "`guild_id`,";
			$values .= "'{$this->guild_id}',";
		}
		if (isset($this->raid_id))
		{
			$fields .= "`raid_id`,";
			$values .= "'{$this->raid_id}',";
		}
		if (isset($this->item_id))
		{
			$fields .= "`item_id`,";
			$values .= "'{$this->item_id}',";
		}
		if (isset($this->drop_count))
		{
			$fields .= "`drop_count`,";
			$values .= "'{$this->drop_count}',";
		}
		if (isset($this->drop_user_id))
		{
			$fields .= "`drop_user_id`,";
			$values .= "'{$this->drop_user_id}',";
		}
		if (isset($this->drop_time))
		{
			$fields .= "`drop_time`,";
			$values .= "'{$this->drop_time}',";
		}
		if (isset($this->distribute_count))
		{
			$fields .= "`distribute_count`,";
			$values .= "'{$this->distribute_count}',";
		}
		if (isset($this->min_distribute_time))
		{
			$fields .= "`min_distribute_time`,";
			$values .= "'{$this->min_distribute_time}',";
		}
		if (isset($this->state))
		{
			$fields .= "`state`,";
			$values .= "'{$this->state}',";
		}

		
		$fields .= ")";
		$values .= ")";
		
		$sql = "INSERT INTO `guild_stage_drop` ".$fields.$values;
		
		return str_replace(",)",")",$sql);
	}
	
	private function  getUpFields()
	{
		$update = "";
		
		if ($this->guild_id_status_field)
		{			
			if (!isset($this->guild_id))
			{
				$update .= ("`guild_id`=null,");
			}
			else
			{
				$update .= ("`guild_id`='{$this->guild_id}',");
			}
		}
		if ($this->raid_id_status_field)
		{			
			if (!isset($this->raid_id))
			{
				$update .= ("`raid_id`=null,");
			}
			else
			{
				$update .= ("`raid_id`='{$this->raid_id}',");
			}
		}
		if ($this->item_id_status_field)
		{			
			if (!isset($this->item_id))
			{
				$update .= ("`item_id`=null,");
			}
			else
			{
				$update .= ("`item_id`='{$this->item_id}',");
			}
		}
		if ($this->drop_count_status_field)
		{			
			if (!isset($this->drop_count))
			{
				$update .= ("`drop_count`=null,");
			}
			else
			{
				$update .= ("`drop_count`='{$this->drop_count}',");
			}
		}
		if ($this->drop_user_id_status_field)
		{			
			if (!isset($this->drop_user_id))
			{
				$update .= ("`drop_user_id`=null,");
			}
			else
			{
				$update .= ("`drop_user_id`='{$this->drop_user_id}',");
			}
		}
		if ($this->drop_time_status_field)
		{			
			if (!isset($this->drop_time))
			{
				$update .= ("`drop_time`=null,");
			}
			else
			{
				$update .= ("`drop_time`='{$this->drop_time}',");
			}
		}
		if ($this->distribute_count_status_field)
		{			
			if (!isset($this->distribute_count))
			{
				$update .= ("`distribute_count`=null,");
			}
			else
			{
				$update .= ("`distribute_count`='{$this->distribute_count}',");
			}
		}
		if ($this->min_distribute_time_status_field)
		{			
			if (!isset($this->min_distribute_time))
			{
				$update .= ("`min_distribute_time`=null,");
			}
			else
			{
				$update .= ("`min_distribute_time`='{$this->min_distribute_time}',");
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
		
		$sql = "UPDATE `guild_stage_drop` SET {$update} WHERE {$condition}";
		
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
		
		$sql = "UPDATE `guild_stage_drop` SET {$update} WHERE {$uc}";
		
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
		
		$sql = "UPDATE `guild_stage_drop` SET {$update} WHERE {$uc}";
		
		MySQL::selectDefaultDb();
		$qr = MySQL::getInstance()->RunQuery($sql);
				
		return (boolean)$qr;
	}
	
	private function /*void*/ clean() 
	{
		$this->this_table_status_field = false;
		$this->id_status_field = false;
		$this->guild_id_status_field = false;
		$this->raid_id_status_field = false;
		$this->item_id_status_field = false;
		$this->drop_count_status_field = false;
		$this->drop_user_id_status_field = false;
		$this->drop_time_status_field = false;
		$this->distribute_count_status_field = false;
		$this->min_distribute_time_status_field = false;
		$this->state_status_field = false;

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

	public function /*string*/ getGuildId()
	{
		return $this->guild_id;
	}
	
	public function /*void*/ setGuildId(/*string*/ $guild_id)
	{
		$this->guild_id = SQLUtil::toSafeSQLString($guild_id);
		$this->guild_id_status_field = true;		
		$this->this_table_status_field = true;		
	}

	public function /*void*/ setGuildIdNull()
	{
		$this->guild_id = null;
		$this->guild_id_status_field = true;		
		$this->this_table_status_field = true;
	}

	public function /*int*/ getRaidId()
	{
		return $this->raid_id;
	}
	
	public function /*void*/ setRaidId(/*int*/ $raid_id)
	{
		$this->raid_id = intval($raid_id);
		$this->raid_id_status_field = true;		
		$this->this_table_status_field = true;		
	}

	public function /*void*/ setRaidIdNull()
	{
		$this->raid_id = null;
		$this->raid_id_status_field = true;		
		$this->this_table_status_field = true;
	}

	public function /*int*/ getItemId()
	{
		return $this->item_id;
	}
	
	public function /*void*/ setItemId(/*int*/ $item_id)
	{
		$this->item_id = intval($item_id);
		$this->item_id_status_field = true;		
		$this->this_table_status_field = true;		
	}

	public function /*void*/ setItemIdNull()
	{
		$this->item_id = null;
		$this->item_id_status_field = true;		
		$this->this_table_status_field = true;
	}

	public function /*int*/ getDropCount()
	{
		return $this->drop_count;
	}
	
	public function /*void*/ setDropCount(/*int*/ $drop_count)
	{
		$this->drop_count = intval($drop_count);
		$this->drop_count_status_field = true;		
		$this->this_table_status_field = true;		
	}

	public function /*void*/ setDropCountNull()
	{
		$this->drop_count = null;
		$this->drop_count_status_field = true;		
		$this->this_table_status_field = true;
	}

	public function /*string*/ getDropUserId()
	{
		return $this->drop_user_id;
	}
	
	public function /*void*/ setDropUserId(/*string*/ $drop_user_id)
	{
		$this->drop_user_id = SQLUtil::toSafeSQLString($drop_user_id);
		$this->drop_user_id_status_field = true;		
		$this->this_table_status_field = true;		
	}

	public function /*void*/ setDropUserIdNull()
	{
		$this->drop_user_id = null;
		$this->drop_user_id_status_field = true;		
		$this->this_table_status_field = true;
	}

	public function /*int*/ getDropTime()
	{
		return $this->drop_time;
	}
	
	public function /*void*/ setDropTime(/*int*/ $drop_time)
	{
		$this->drop_time = intval($drop_time);
		$this->drop_time_status_field = true;		
		$this->this_table_status_field = true;		
	}

	public function /*void*/ setDropTimeNull()
	{
		$this->drop_time = null;
		$this->drop_time_status_field = true;		
		$this->this_table_status_field = true;
	}

	public function /*int*/ getDistributeCount()
	{
		return $this->distribute_count;
	}
	
	public function /*void*/ setDistributeCount(/*int*/ $distribute_count)
	{
		$this->distribute_count = intval($distribute_count);
		$this->distribute_count_status_field = true;		
		$this->this_table_status_field = true;		
	}

	public function /*void*/ setDistributeCountNull()
	{
		$this->distribute_count = null;
		$this->distribute_count_status_field = true;		
		$this->this_table_status_field = true;
	}

	public function /*int*/ getMinDistributeTime()
	{
		return $this->min_distribute_time;
	}
	
	public function /*void*/ setMinDistributeTime(/*int*/ $min_distribute_time)
	{
		$this->min_distribute_time = intval($min_distribute_time);
		$this->min_distribute_time_status_field = true;		
		$this->this_table_status_field = true;		
	}

	public function /*void*/ setMinDistributeTimeNull()
	{
		$this->min_distribute_time = null;
		$this->min_distribute_time_status_field = true;		
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
		$dbg .= ("guild_id={$this->guild_id},");
		$dbg .= ("raid_id={$this->raid_id},");
		$dbg .= ("item_id={$this->item_id},");
		$dbg .= ("drop_count={$this->drop_count},");
		$dbg .= ("drop_user_id={$this->drop_user_id},");
		$dbg .= ("drop_time={$this->drop_time},");
		$dbg .= ("distribute_count={$this->distribute_count},");
		$dbg .= ("min_distribute_time={$this->min_distribute_time},");
		$dbg .= ("state={$this->state},");

		$dbg .= ")";
				
		return str_replace(",)",")",$dbg);
	}
}

?>
