<?php
require_once ($GLOBALS ['GAME_ROOT'] . "CMySQL.php");
require_once ("SQLUtil.php");
/**
 *  [The generated files]
 */

class SysGuildStageItemsHistory {
	
	private /*string*/ $id; //PRIMARY KEY 
	private /*string*/ $user_id;
	private /*string*/ $user_name;
	private /*int*/ $item_id;
	private /*int*/ $sender_user_id;
	private /*string*/ $sender_user_name;
	private /*int*/ $send_time;
	private /*int*/ $type;
	private /*int*/ $raid_id;
	private /*string*/ $guild_id;

	
	private $this_table_status_field = false;
	private $id_status_field = false;
	private $user_id_status_field = false;
	private $user_name_status_field = false;
	private $item_id_status_field = false;
	private $sender_user_id_status_field = false;
	private $sender_user_name_status_field = false;
	private $send_time_status_field = false;
	private $type_status_field = false;
	private $raid_id_status_field = false;
	private $guild_id_status_field = false;


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
			$sql = "SELECT {$p} FROM `guild_stage_items_history`";
		}
		else
		{			
			$sql = "SELECT {$p} FROM `guild_stage_items_history` WHERE ".SQLUtil::parseCondition($condition);
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
			$tb = new SysGuildStageItemsHistory();			
			if (isset($row['id'])) $tb->id = $row['id'];
			if (isset($row['user_id'])) $tb->user_id = $row['user_id'];
			if (isset($row['user_name'])) $tb->user_name = $row['user_name'];
			if (isset($row['item_id'])) $tb->item_id = intval($row['item_id']);
			if (isset($row['sender_user_id'])) $tb->sender_user_id = intval($row['sender_user_id']);
			if (isset($row['sender_user_name'])) $tb->sender_user_name = $row['sender_user_name'];
			if (isset($row['send_time'])) $tb->send_time = intval($row['send_time']);
			if (isset($row['type'])) $tb->type = intval($row['type']);
			if (isset($row['raid_id'])) $tb->raid_id = intval($row['raid_id']);
			if (isset($row['guild_id'])) $tb->guild_id = $row['guild_id'];
		
			$result[] = $tb;
		}
		
		return $result;
	}	
	
	public static function insertSqlHeader($fields=NULL)
	{
		$result = array();				
		if(!empty($fields)){
			$where = SQLUtil::parseFields($fields);			
			$result[0] = "INSERT INTO `guild_stage_items_history` ({$where}) VALUES ";	
			$ar = array();
			foreach($fields as $key){
				$ar[$key]=1;
			}
			$result[1] = $ar;
		}else{
			$result[0]="INSERT INTO `guild_stage_items_history` (`id`,`user_id`,`user_name`,`item_id`,`sender_user_id`,`sender_user_name`,`send_time`,`type`,`raid_id`,`guild_id`) VALUES ";
			$result[1] = array('id'=>1,'user_id'=>1,'user_name'=>1,'item_id'=>1,'sender_user_id'=>1,'sender_user_name'=>1,'send_time'=>1,'type'=>1,'raid_id'=>1,'guild_id'=>1);
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
		
		$sql = "SELECT {$p} FROM `guild_stage_items_history` WHERE {$where}";

		MySQL::selectDefaultDb();
		$qr = MySQL::getInstance()->RunQuery($sql);
		$ar = MySQL::getInstance()->FetchArray($qr);
		
		if (!$ar || count($ar)==0)
		{
			return false;
		}
		
		if (isset($ar['id'])) $this->id = $ar['id'];
		if (isset($ar['user_id'])) $this->user_id = $ar['user_id'];
		if (isset($ar['user_name'])) $this->user_name = $ar['user_name'];
		if (isset($ar['item_id'])) $this->item_id = intval($ar['item_id']);
		if (isset($ar['sender_user_id'])) $this->sender_user_id = intval($ar['sender_user_id']);
		if (isset($ar['sender_user_name'])) $this->sender_user_name = $ar['sender_user_name'];
		if (isset($ar['send_time'])) $this->send_time = intval($ar['send_time']);
		if (isset($ar['type'])) $this->type = intval($ar['type']);
		if (isset($ar['raid_id'])) $this->raid_id = intval($ar['raid_id']);
		if (isset($ar['guild_id'])) $this->guild_id = $ar['guild_id'];
		
		
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
	
		$sql = "SELECT {$p} FROM `guild_stage_items_history` WHERE {$where}";
	
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
    	if (!isset($this->user_name)){
    		$emptyFields = false;
    		$fields[] = 'user_name';
    	}else{
    		$emptyCondition = false; 
    		$condition['user_name']=$this->user_name;
    	}
    	if (!isset($this->item_id)){
    		$emptyFields = false;
    		$fields[] = 'item_id';
    	}else{
    		$emptyCondition = false; 
    		$condition['item_id']=$this->item_id;
    	}
    	if (!isset($this->sender_user_id)){
    		$emptyFields = false;
    		$fields[] = 'sender_user_id';
    	}else{
    		$emptyCondition = false; 
    		$condition['sender_user_id']=$this->sender_user_id;
    	}
    	if (!isset($this->sender_user_name)){
    		$emptyFields = false;
    		$fields[] = 'sender_user_name';
    	}else{
    		$emptyCondition = false; 
    		$condition['sender_user_name']=$this->sender_user_name;
    	}
    	if (!isset($this->send_time)){
    		$emptyFields = false;
    		$fields[] = 'send_time';
    	}else{
    		$emptyCondition = false; 
    		$condition['send_time']=$this->send_time;
    	}
    	if (!isset($this->type)){
    		$emptyFields = false;
    		$fields[] = 'type';
    	}else{
    		$emptyCondition = false; 
    		$condition['type']=$this->type;
    	}
    	if (!isset($this->raid_id)){
    		$emptyFields = false;
    		$fields[] = 'raid_id';
    	}else{
    		$emptyCondition = false; 
    		$condition['raid_id']=$this->raid_id;
    	}
    	if (!isset($this->guild_id)){
    		$emptyFields = false;
    		$fields[] = 'guild_id';
    	}else{
    		$emptyCondition = false; 
    		$condition['guild_id']=$this->guild_id;
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
		
		$sql = "DELETE FROM `guild_stage_items_history` WHERE ".SQLUtil::parseCondition($condition);
		
		$qr = MySQL::getInstance()->RunQuery($sql);
				
		return (boolean)$qr;
	}
	
	public function  delete()
	{
		if (!isset($this->id))
		{
			return false;
		}
		
		$sql = "DELETE FROM `guild_stage_items_history` WHERE `id`='{$this->id}'";
		
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
 			}else if($f == 'user_name'){
 				$values .= "'{$this->user_name}',";
 			}else if($f == 'item_id'){
 				$values .= "'{$this->item_id}',";
 			}else if($f == 'sender_user_id'){
 				$values .= "'{$this->sender_user_id}',";
 			}else if($f == 'sender_user_name'){
 				$values .= "'{$this->sender_user_name}',";
 			}else if($f == 'send_time'){
 				$values .= "'{$this->send_time}',";
 			}else if($f == 'type'){
 				$values .= "'{$this->type}',";
 			}else if($f == 'raid_id'){
 				$values .= "'{$this->raid_id}',";
 			}else if($f == 'guild_id'){
 				$values .= "'{$this->guild_id}',";
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
		if (isset($this->user_name))
		{
			$fields .= "`user_name`,";
			$values .= "'{$this->user_name}',";
		}
		if (isset($this->item_id))
		{
			$fields .= "`item_id`,";
			$values .= "'{$this->item_id}',";
		}
		if (isset($this->sender_user_id))
		{
			$fields .= "`sender_user_id`,";
			$values .= "'{$this->sender_user_id}',";
		}
		if (isset($this->sender_user_name))
		{
			$fields .= "`sender_user_name`,";
			$values .= "'{$this->sender_user_name}',";
		}
		if (isset($this->send_time))
		{
			$fields .= "`send_time`,";
			$values .= "'{$this->send_time}',";
		}
		if (isset($this->type))
		{
			$fields .= "`type`,";
			$values .= "'{$this->type}',";
		}
		if (isset($this->raid_id))
		{
			$fields .= "`raid_id`,";
			$values .= "'{$this->raid_id}',";
		}
		if (isset($this->guild_id))
		{
			$fields .= "`guild_id`,";
			$values .= "'{$this->guild_id}',";
		}

		
		$fields .= ")";
		$values .= ")";
		
		$sql = "INSERT INTO `guild_stage_items_history` ".$fields.$values;
		
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
		if ($this->user_name_status_field)
		{			
			if (!isset($this->user_name))
			{
				$update .= ("`user_name`=null,");
			}
			else
			{
				$update .= ("`user_name`='{$this->user_name}',");
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
		if ($this->sender_user_id_status_field)
		{			
			if (!isset($this->sender_user_id))
			{
				$update .= ("`sender_user_id`=null,");
			}
			else
			{
				$update .= ("`sender_user_id`='{$this->sender_user_id}',");
			}
		}
		if ($this->sender_user_name_status_field)
		{			
			if (!isset($this->sender_user_name))
			{
				$update .= ("`sender_user_name`=null,");
			}
			else
			{
				$update .= ("`sender_user_name`='{$this->sender_user_name}',");
			}
		}
		if ($this->send_time_status_field)
		{			
			if (!isset($this->send_time))
			{
				$update .= ("`send_time`=null,");
			}
			else
			{
				$update .= ("`send_time`='{$this->send_time}',");
			}
		}
		if ($this->type_status_field)
		{			
			if (!isset($this->type))
			{
				$update .= ("`type`=null,");
			}
			else
			{
				$update .= ("`type`='{$this->type}',");
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
		
		$sql = "UPDATE `guild_stage_items_history` SET {$update} WHERE {$condition}";
		
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
		
		$sql = "UPDATE `guild_stage_items_history` SET {$update} WHERE {$uc}";
		
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
		
		$sql = "UPDATE `guild_stage_items_history` SET {$update} WHERE {$uc}";
		
		MySQL::selectDefaultDb();
		$qr = MySQL::getInstance()->RunQuery($sql);
				
		return (boolean)$qr;
	}
	
	private function /*void*/ clean() 
	{
		$this->this_table_status_field = false;
		$this->id_status_field = false;
		$this->user_id_status_field = false;
		$this->user_name_status_field = false;
		$this->item_id_status_field = false;
		$this->sender_user_id_status_field = false;
		$this->sender_user_name_status_field = false;
		$this->send_time_status_field = false;
		$this->type_status_field = false;
		$this->raid_id_status_field = false;
		$this->guild_id_status_field = false;

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

	public function /*string*/ getUserName()
	{
		return $this->user_name;
	}
	
	public function /*void*/ setUserName(/*string*/ $user_name)
	{
		$this->user_name = SQLUtil::toSafeSQLString($user_name);
		$this->user_name_status_field = true;		
		$this->this_table_status_field = true;		
	}

	public function /*void*/ setUserNameNull()
	{
		$this->user_name = null;
		$this->user_name_status_field = true;		
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

	public function /*int*/ getSenderUserId()
	{
		return $this->sender_user_id;
	}
	
	public function /*void*/ setSenderUserId(/*int*/ $sender_user_id)
	{
		$this->sender_user_id = intval($sender_user_id);
		$this->sender_user_id_status_field = true;		
		$this->this_table_status_field = true;		
	}

	public function /*void*/ setSenderUserIdNull()
	{
		$this->sender_user_id = null;
		$this->sender_user_id_status_field = true;		
		$this->this_table_status_field = true;
	}

	public function /*string*/ getSenderUserName()
	{
		return $this->sender_user_name;
	}
	
	public function /*void*/ setSenderUserName(/*string*/ $sender_user_name)
	{
		$this->sender_user_name = SQLUtil::toSafeSQLString($sender_user_name);
		$this->sender_user_name_status_field = true;		
		$this->this_table_status_field = true;		
	}

	public function /*void*/ setSenderUserNameNull()
	{
		$this->sender_user_name = null;
		$this->sender_user_name_status_field = true;		
		$this->this_table_status_field = true;
	}

	public function /*int*/ getSendTime()
	{
		return $this->send_time;
	}
	
	public function /*void*/ setSendTime(/*int*/ $send_time)
	{
		$this->send_time = intval($send_time);
		$this->send_time_status_field = true;		
		$this->this_table_status_field = true;		
	}

	public function /*void*/ setSendTimeNull()
	{
		$this->send_time = null;
		$this->send_time_status_field = true;		
		$this->this_table_status_field = true;
	}

	public function /*int*/ getType()
	{
		return $this->type;
	}
	
	public function /*void*/ setType(/*int*/ $type)
	{
		$this->type = intval($type);
		$this->type_status_field = true;		
		$this->this_table_status_field = true;		
	}

	public function /*void*/ setTypeNull()
	{
		$this->type = null;
		$this->type_status_field = true;		
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

	
	public function /*string*/ toDebugString()
	{
		$dbg = "(";
		
		$dbg .= ("id={$this->id},");
		$dbg .= ("user_id={$this->user_id},");
		$dbg .= ("user_name={$this->user_name},");
		$dbg .= ("item_id={$this->item_id},");
		$dbg .= ("sender_user_id={$this->sender_user_id},");
		$dbg .= ("sender_user_name={$this->sender_user_name},");
		$dbg .= ("send_time={$this->send_time},");
		$dbg .= ("type={$this->type},");
		$dbg .= ("raid_id={$this->raid_id},");
		$dbg .= ("guild_id={$this->guild_id},");

		$dbg .= ")";
				
		return str_replace(",)",")",$dbg);
	}
}

?>
