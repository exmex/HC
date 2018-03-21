<?php
require_once ($GLOBALS ['GAME_ROOT'] . "CMySQL.php");
require_once ("SQLUtil.php");
/**
 *  [The generated files]
 */

class SysGuildVitalityRank {
	
	private /*string*/ $guild_id; //PRIMARY KEY 
	private /*int*/ $server_id;
	private /*string*/ $vitality0;
	private /*string*/ $vitality1;
	private /*string*/ $vitality2;
	private /*string*/ $vitality3;
	private /*int*/ $rank;
	private /*string*/ $query_time;
	private /*int*/ $last_rank;

	
	private $this_table_status_field = false;
	private $guild_id_status_field = false;
	private $server_id_status_field = false;
	private $vitality0_status_field = false;
	private $vitality1_status_field = false;
	private $vitality2_status_field = false;
	private $vitality3_status_field = false;
	private $rank_status_field = false;
	private $query_time_status_field = false;
	private $last_rank_status_field = false;


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
			$sql = "SELECT {$p} FROM `guild_vitality_rank`";
		}
		else
		{			
			$sql = "SELECT {$p} FROM `guild_vitality_rank` WHERE ".SQLUtil::parseCondition($condition);
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
			$tb = new SysGuildVitalityRank();			
			if (isset($row['guild_id'])) $tb->guild_id = $row['guild_id'];
			if (isset($row['server_id'])) $tb->server_id = intval($row['server_id']);
			if (isset($row['vitality0'])) $tb->vitality0 = $row['vitality0'];
			if (isset($row['vitality1'])) $tb->vitality1 = $row['vitality1'];
			if (isset($row['vitality2'])) $tb->vitality2 = $row['vitality2'];
			if (isset($row['vitality3'])) $tb->vitality3 = $row['vitality3'];
			if (isset($row['rank'])) $tb->rank = intval($row['rank']);
			if (isset($row['query_time'])) $tb->query_time = $row['query_time'];
			if (isset($row['last_rank'])) $tb->last_rank = intval($row['last_rank']);
		
			$result[] = $tb;
		}
		
		return $result;
	}	
	
	public static function insertSqlHeader($fields=NULL)
	{
		$result = array();				
		if(!empty($fields)){
			$where = SQLUtil::parseFields($fields);			
			$result[0] = "INSERT INTO `guild_vitality_rank` ({$where}) VALUES ";	
			$ar = array();
			foreach($fields as $key){
				$ar[$key]=1;
			}
			$result[1] = $ar;
		}else{
			$result[0]="INSERT INTO `guild_vitality_rank` (`guild_id`,`server_id`,`vitality0`,`vitality1`,`vitality2`,`vitality3`,`rank`,`query_time`,`last_rank`) VALUES ";
			$result[1] = array('guild_id'=>1,'server_id'=>1,'vitality0'=>1,'vitality1'=>1,'vitality2'=>1,'vitality3'=>1,'rank'=>1,'query_time'=>1,'last_rank'=>1);
		}				
		return $result;
	}
		
	public function  loaded( $fields=NULL,$condition=NULL)
	{

		if (empty($condition) && empty($this->guild_id))
		{
			return false;
		}
		
		$p = "*";
		$where = "`guild_id` = '{$this->guild_id}'";
		
		if(!empty($fields))
		{
			$p = SQLUtil::parseFields($fields);			
		}
	    if (!empty($condition))
		{
			$where =SQLUtil::parseCondition($condition);
		}
		
		$sql = "SELECT {$p} FROM `guild_vitality_rank` WHERE {$where}";

		MySQL::selectDefaultDb();
		$qr = MySQL::getInstance()->RunQuery($sql);
		$ar = MySQL::getInstance()->FetchArray($qr);
		
		if (!$ar || count($ar)==0)
		{
			return false;
		}
		
		if (isset($ar['guild_id'])) $this->guild_id = $ar['guild_id'];
		if (isset($ar['server_id'])) $this->server_id = intval($ar['server_id']);
		if (isset($ar['vitality0'])) $this->vitality0 = $ar['vitality0'];
		if (isset($ar['vitality1'])) $this->vitality1 = $ar['vitality1'];
		if (isset($ar['vitality2'])) $this->vitality2 = $ar['vitality2'];
		if (isset($ar['vitality3'])) $this->vitality3 = $ar['vitality3'];
		if (isset($ar['rank'])) $this->rank = intval($ar['rank']);
		if (isset($ar['query_time'])) $this->query_time = $ar['query_time'];
		if (isset($ar['last_rank'])) $this->last_rank = intval($ar['last_rank']);
		
		
		$this->clean();
		
		return true;
	}
	
	
	public function  loadedCount( $fields=NULL,$condition=NULL)
	{
	
		if (empty($condition) && empty($this->guild_id))
		{
			return false;
		}
	
		$p = "*";
		$where = "`guild_id` = '{$this->guild_id}'";
	
		if(!empty($fields))
		{
			$p = SQLUtil::parseFields($fields);
		}
		if (!empty($condition))
		{
			$where =SQLUtil::parseCondition($condition);
		}
	
		$sql = "SELECT {$p} FROM `guild_vitality_rank` WHERE {$where}";
	
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
    	
    	if (!isset($this->guild_id)){
    		$emptyFields = false;
    		$fields[] = 'guild_id';
    	}else{
    		$emptyCondition = false; 
    		$condition['guild_id']=$this->guild_id;
    	}
    	if (!isset($this->server_id)){
    		$emptyFields = false;
    		$fields[] = 'server_id';
    	}else{
    		$emptyCondition = false; 
    		$condition['server_id']=$this->server_id;
    	}
    	if (!isset($this->vitality0)){
    		$emptyFields = false;
    		$fields[] = 'vitality0';
    	}else{
    		$emptyCondition = false; 
    		$condition['vitality0']=$this->vitality0;
    	}
    	if (!isset($this->vitality1)){
    		$emptyFields = false;
    		$fields[] = 'vitality1';
    	}else{
    		$emptyCondition = false; 
    		$condition['vitality1']=$this->vitality1;
    	}
    	if (!isset($this->vitality2)){
    		$emptyFields = false;
    		$fields[] = 'vitality2';
    	}else{
    		$emptyCondition = false; 
    		$condition['vitality2']=$this->vitality2;
    	}
    	if (!isset($this->vitality3)){
    		$emptyFields = false;
    		$fields[] = 'vitality3';
    	}else{
    		$emptyCondition = false; 
    		$condition['vitality3']=$this->vitality3;
    	}
    	if (!isset($this->rank)){
    		$emptyFields = false;
    		$fields[] = 'rank';
    	}else{
    		$emptyCondition = false; 
    		$condition['rank']=$this->rank;
    	}
    	if (!isset($this->query_time)){
    		$emptyFields = false;
    		$fields[] = 'query_time';
    	}else{
    		$emptyCondition = false; 
    		$condition['query_time']=$this->query_time;
    	}
    	if (!isset($this->last_rank)){
    		$emptyFields = false;
    		$fields[] = 'last_rank';
    	}else{
    		$emptyCondition = false; 
    		$condition['last_rank']=$this->last_rank;
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
				
		if (empty($this->guild_id))
		{
			$this->guild_id = MySQL::getInstance()->GetInsertId();
		}		
		
		$this->clean();
		
		return true;	
		
	}
	
	public function save($condition=NULL)
	{
		if (empty($condition))
		{
			$uc = "`guild_id`='{$this->guild_id}'";
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
		
		$sql = "DELETE FROM `guild_vitality_rank` WHERE ".SQLUtil::parseCondition($condition);
		
		$qr = MySQL::getInstance()->RunQuery($sql);
				
		return (boolean)$qr;
	}
	
	public function  delete()
	{
		if (!isset($this->guild_id))
		{
			return false;
		}
		
		$sql = "DELETE FROM `guild_vitality_rank` WHERE `guild_id`='{$this->guild_id}'";
		
		MySQL::selectDefaultDb();
		$qr = MySQL::getInstance()->RunQuery($sql);
				
		return (boolean)$qr;
	}
	
	public function getInsertValue($fields)
	{
		$values = "(";		
		foreach($fields as $f => $k){
			if($f == 'guild_id'){
 				$values .= "'{$this->guild_id}',";
 			}else if($f == 'server_id'){
 				$values .= "'{$this->server_id}',";
 			}else if($f == 'vitality0'){
 				$values .= "'{$this->vitality0}',";
 			}else if($f == 'vitality1'){
 				$values .= "'{$this->vitality1}',";
 			}else if($f == 'vitality2'){
 				$values .= "'{$this->vitality2}',";
 			}else if($f == 'vitality3'){
 				$values .= "'{$this->vitality3}',";
 			}else if($f == 'rank'){
 				$values .= "'{$this->rank}',";
 			}else if($f == 'query_time'){
 				$values .= "'{$this->query_time}',";
 			}else if($f == 'last_rank'){
 				$values .= "'{$this->last_rank}',";
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

		if (isset($this->guild_id))
		{
			$fields .= "`guild_id`,";
			$values .= "'{$this->guild_id}',";
		}
		if (isset($this->server_id))
		{
			$fields .= "`server_id`,";
			$values .= "'{$this->server_id}',";
		}
		if (isset($this->vitality0))
		{
			$fields .= "`vitality0`,";
			$values .= "'{$this->vitality0}',";
		}
		if (isset($this->vitality1))
		{
			$fields .= "`vitality1`,";
			$values .= "'{$this->vitality1}',";
		}
		if (isset($this->vitality2))
		{
			$fields .= "`vitality2`,";
			$values .= "'{$this->vitality2}',";
		}
		if (isset($this->vitality3))
		{
			$fields .= "`vitality3`,";
			$values .= "'{$this->vitality3}',";
		}
		if (isset($this->rank))
		{
			$fields .= "`rank`,";
			$values .= "'{$this->rank}',";
		}
		if (isset($this->query_time))
		{
			$fields .= "`query_time`,";
			$values .= "'{$this->query_time}',";
		}
		if (isset($this->last_rank))
		{
			$fields .= "`last_rank`,";
			$values .= "'{$this->last_rank}',";
		}

		
		$fields .= ")";
		$values .= ")";
		
		$sql = "INSERT INTO `guild_vitality_rank` ".$fields.$values;
		
		return str_replace(",)",")",$sql);
	}
	
	private function  getUpFields()
	{
		$update = "";
		
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
		if ($this->vitality0_status_field)
		{			
			if (!isset($this->vitality0))
			{
				$update .= ("`vitality0`=null,");
			}
			else
			{
				$update .= ("`vitality0`='{$this->vitality0}',");
			}
		}
		if ($this->vitality1_status_field)
		{			
			if (!isset($this->vitality1))
			{
				$update .= ("`vitality1`=null,");
			}
			else
			{
				$update .= ("`vitality1`='{$this->vitality1}',");
			}
		}
		if ($this->vitality2_status_field)
		{			
			if (!isset($this->vitality2))
			{
				$update .= ("`vitality2`=null,");
			}
			else
			{
				$update .= ("`vitality2`='{$this->vitality2}',");
			}
		}
		if ($this->vitality3_status_field)
		{			
			if (!isset($this->vitality3))
			{
				$update .= ("`vitality3`=null,");
			}
			else
			{
				$update .= ("`vitality3`='{$this->vitality3}',");
			}
		}
		if ($this->rank_status_field)
		{			
			if (!isset($this->rank))
			{
				$update .= ("`rank`=null,");
			}
			else
			{
				$update .= ("`rank`='{$this->rank}',");
			}
		}
		if ($this->query_time_status_field)
		{			
			if (!isset($this->query_time))
			{
				$update .= ("`query_time`=null,");
			}
			else
			{
				$update .= ("`query_time`='{$this->query_time}',");
			}
		}
		if ($this->last_rank_status_field)
		{			
			if (!isset($this->last_rank))
			{
				$update .= ("`last_rank`=null,");
			}
			else
			{
				$update .= ("`last_rank`='{$this->last_rank}',");
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
		
		$sql = "UPDATE `guild_vitality_rank` SET {$update} WHERE {$condition}";
		
		return $sql;
	}
	
	public function  add($fieldsValue,$condition=NULL)
	{				
		if (empty($condition))
		{
			$uc = "`guild_id`='{$this->guild_id}'";
		}
		else
		{			
			$uc = SQLUtil::parseCondition($condition);
		}
		
		$update = SQLUtil::parseASFieldValues($fieldsValue);
		
		$sql = "UPDATE `guild_vitality_rank` SET {$update} WHERE {$uc}";
		
		MySQL::selectDefaultDb();
		$qr = MySQL::getInstance()->RunQuery($sql);
				
		return (boolean)$qr;
	}	
	
	public function sub($fieldsVal,$condition=NULL)
	{
		if (empty($condition))
		{
			$uc = "`guild_id`='{$this->guild_id}'";
		}
		else
		{			
			$uc = SQLUtil::parseCondition($condition);
		}
		
		$update = SQLUtil::parseASFieldValues($fieldsVal,false);
		
		$sql = "UPDATE `guild_vitality_rank` SET {$update} WHERE {$uc}";
		
		MySQL::selectDefaultDb();
		$qr = MySQL::getInstance()->RunQuery($sql);
				
		return (boolean)$qr;
	}
	
	private function /*void*/ clean() 
	{
		$this->this_table_status_field = false;
		$this->guild_id_status_field = false;
		$this->server_id_status_field = false;
		$this->vitality0_status_field = false;
		$this->vitality1_status_field = false;
		$this->vitality2_status_field = false;
		$this->vitality3_status_field = false;
		$this->rank_status_field = false;
		$this->query_time_status_field = false;
		$this->last_rank_status_field = false;

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

	public function /*string*/ getVitality0()
	{
		return $this->vitality0;
	}
	
	public function /*void*/ setVitality0(/*string*/ $vitality0)
	{
		$this->vitality0 = SQLUtil::toSafeSQLString($vitality0);
		$this->vitality0_status_field = true;		
		$this->this_table_status_field = true;		
	}

	public function /*void*/ setVitality0Null()
	{
		$this->vitality0 = null;
		$this->vitality0_status_field = true;		
		$this->this_table_status_field = true;
	}

	public function /*string*/ getVitality1()
	{
		return $this->vitality1;
	}
	
	public function /*void*/ setVitality1(/*string*/ $vitality1)
	{
		$this->vitality1 = SQLUtil::toSafeSQLString($vitality1);
		$this->vitality1_status_field = true;		
		$this->this_table_status_field = true;		
	}

	public function /*void*/ setVitality1Null()
	{
		$this->vitality1 = null;
		$this->vitality1_status_field = true;		
		$this->this_table_status_field = true;
	}

	public function /*string*/ getVitality2()
	{
		return $this->vitality2;
	}
	
	public function /*void*/ setVitality2(/*string*/ $vitality2)
	{
		$this->vitality2 = SQLUtil::toSafeSQLString($vitality2);
		$this->vitality2_status_field = true;		
		$this->this_table_status_field = true;		
	}

	public function /*void*/ setVitality2Null()
	{
		$this->vitality2 = null;
		$this->vitality2_status_field = true;		
		$this->this_table_status_field = true;
	}

	public function /*string*/ getVitality3()
	{
		return $this->vitality3;
	}
	
	public function /*void*/ setVitality3(/*string*/ $vitality3)
	{
		$this->vitality3 = SQLUtil::toSafeSQLString($vitality3);
		$this->vitality3_status_field = true;		
		$this->this_table_status_field = true;		
	}

	public function /*void*/ setVitality3Null()
	{
		$this->vitality3 = null;
		$this->vitality3_status_field = true;		
		$this->this_table_status_field = true;
	}

	public function /*int*/ getRank()
	{
		return $this->rank;
	}
	
	public function /*void*/ setRank(/*int*/ $rank)
	{
		$this->rank = intval($rank);
		$this->rank_status_field = true;		
		$this->this_table_status_field = true;		
	}

	public function /*void*/ setRankNull()
	{
		$this->rank = null;
		$this->rank_status_field = true;		
		$this->this_table_status_field = true;
	}

	public function /*string*/ getQueryTime()
	{
		return $this->query_time;
	}
	
	public function /*void*/ setQueryTime(/*string*/ $query_time)
	{
		$this->query_time = SQLUtil::toSafeSQLString($query_time);
		$this->query_time_status_field = true;		
		$this->this_table_status_field = true;		
	}

	public function /*void*/ setQueryTimeNull()
	{
		$this->query_time = null;
		$this->query_time_status_field = true;		
		$this->this_table_status_field = true;
	}

	public function /*int*/ getLastRank()
	{
		return $this->last_rank;
	}
	
	public function /*void*/ setLastRank(/*int*/ $last_rank)
	{
		$this->last_rank = intval($last_rank);
		$this->last_rank_status_field = true;		
		$this->this_table_status_field = true;		
	}

	public function /*void*/ setLastRankNull()
	{
		$this->last_rank = null;
		$this->last_rank_status_field = true;		
		$this->this_table_status_field = true;
	}

	
	public function /*string*/ toDebugString()
	{
		$dbg = "(";
		
		$dbg .= ("guild_id={$this->guild_id},");
		$dbg .= ("server_id={$this->server_id},");
		$dbg .= ("vitality0={$this->vitality0},");
		$dbg .= ("vitality1={$this->vitality1},");
		$dbg .= ("vitality2={$this->vitality2},");
		$dbg .= ("vitality3={$this->vitality3},");
		$dbg .= ("rank={$this->rank},");
		$dbg .= ("query_time={$this->query_time},");
		$dbg .= ("last_rank={$this->last_rank},");

		$dbg .= ")";
				
		return str_replace(",)",")",$dbg);
	}
}

?>
