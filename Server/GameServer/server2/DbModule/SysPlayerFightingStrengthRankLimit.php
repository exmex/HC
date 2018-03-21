<?php
require_once ($GLOBALS ['GAME_ROOT'] . "CMySQL.php");
require_once ("SQLUtil.php");
/**
 *  [The generated files]
 */

class SysPlayerFightingStrengthRankLimit {
	
	private /*string*/ $user_id; //PRIMARY KEY 
	private /*int*/ $server_id;
	private /*string*/ $gs;
	private /*int*/ $rank;
	private /*int*/ $last_rank;
	private /*string*/ $query_time;
	private /*int*/ $is_robot;

	
	private $this_table_status_field = false;
	private $user_id_status_field = false;
	private $server_id_status_field = false;
	private $gs_status_field = false;
	private $rank_status_field = false;
	private $last_rank_status_field = false;
	private $query_time_status_field = false;
	private $is_robot_status_field = false;


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
			$sql = "SELECT {$p} FROM `player_fighting_strength_rank_limit`";
		}
		else
		{			
			$sql = "SELECT {$p} FROM `player_fighting_strength_rank_limit` WHERE ".SQLUtil::parseCondition($condition);
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
			$tb = new SysPlayerFightingStrengthRankLimit();			
			if (isset($row['user_id'])) $tb->user_id = $row['user_id'];
			if (isset($row['server_id'])) $tb->server_id = intval($row['server_id']);
			if (isset($row['gs'])) $tb->gs = $row['gs'];
			if (isset($row['rank'])) $tb->rank = intval($row['rank']);
			if (isset($row['last_rank'])) $tb->last_rank = intval($row['last_rank']);
			if (isset($row['query_time'])) $tb->query_time = $row['query_time'];
			if (isset($row['is_robot'])) $tb->is_robot = intval($row['is_robot']);
		
			$result[] = $tb;
		}
		
		return $result;
	}	
	
	public static function insertSqlHeader($fields=NULL)
	{
		$result = array();				
		if(!empty($fields)){
			$where = SQLUtil::parseFields($fields);			
			$result[0] = "INSERT INTO `player_fighting_strength_rank_limit` ({$where}) VALUES ";	
			$ar = array();
			foreach($fields as $key){
				$ar[$key]=1;
			}
			$result[1] = $ar;
		}else{
			$result[0]="INSERT INTO `player_fighting_strength_rank_limit` (`user_id`,`server_id`,`gs`,`rank`,`last_rank`,`query_time`,`is_robot`) VALUES ";
			$result[1] = array('user_id'=>1,'server_id'=>1,'gs'=>1,'rank'=>1,'last_rank'=>1,'query_time'=>1,'is_robot'=>1);
		}				
		return $result;
	}
		
	public function  loaded( $fields=NULL,$condition=NULL)
	{

		if (empty($condition) && empty($this->user_id))
		{
			return false;
		}
		
		$p = "*";
		$where = "`user_id` = '{$this->user_id}'";
		
		if(!empty($fields))
		{
			$p = SQLUtil::parseFields($fields);			
		}
	    if (!empty($condition))
		{
			$where =SQLUtil::parseCondition($condition);
		}
		
		$sql = "SELECT {$p} FROM `player_fighting_strength_rank_limit` WHERE {$where}";

		if(isset($this->user_id)){MySQL::selectDbForUser($this->user_id);}else{MySQL::selectDbForUser($GLOBALS['USER_ID']);}
		$qr = MySQL::getInstance()->RunQuery($sql);
		$ar = MySQL::getInstance()->FetchArray($qr);
		
		if (!$ar || count($ar)==0)
		{
			return false;
		}
		
		if (isset($ar['user_id'])) $this->user_id = $ar['user_id'];
		if (isset($ar['server_id'])) $this->server_id = intval($ar['server_id']);
		if (isset($ar['gs'])) $this->gs = $ar['gs'];
		if (isset($ar['rank'])) $this->rank = intval($ar['rank']);
		if (isset($ar['last_rank'])) $this->last_rank = intval($ar['last_rank']);
		if (isset($ar['query_time'])) $this->query_time = $ar['query_time'];
		if (isset($ar['is_robot'])) $this->is_robot = intval($ar['is_robot']);
		
		
		$this->clean();
		
		return true;
	}
	
	
	public function  loadedCount( $fields=NULL,$condition=NULL)
	{
	
		if (empty($condition) && empty($this->user_id))
		{
			return false;
		}
	
		$p = "*";
		$where = "`user_id` = '{$this->user_id}'";
	
		if(!empty($fields))
		{
			$p = SQLUtil::parseFields($fields);
		}
		if (!empty($condition))
		{
			$where =SQLUtil::parseCondition($condition);
		}
	
		$sql = "SELECT {$p} FROM `player_fighting_strength_rank_limit` WHERE {$where}";
	
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
    	
    	if (!isset($this->user_id)){
    		$emptyFields = false;
    		$fields[] = 'user_id';
    	}else{
    		$emptyCondition = false; 
    		$condition['user_id']=$this->user_id;
    	}
    	if (!isset($this->server_id)){
    		$emptyFields = false;
    		$fields[] = 'server_id';
    	}else{
    		$emptyCondition = false; 
    		$condition['server_id']=$this->server_id;
    	}
    	if (!isset($this->gs)){
    		$emptyFields = false;
    		$fields[] = 'gs';
    	}else{
    		$emptyCondition = false; 
    		$condition['gs']=$this->gs;
    	}
    	if (!isset($this->rank)){
    		$emptyFields = false;
    		$fields[] = 'rank';
    	}else{
    		$emptyCondition = false; 
    		$condition['rank']=$this->rank;
    	}
    	if (!isset($this->last_rank)){
    		$emptyFields = false;
    		$fields[] = 'last_rank';
    	}else{
    		$emptyCondition = false; 
    		$condition['last_rank']=$this->last_rank;
    	}
    	if (!isset($this->query_time)){
    		$emptyFields = false;
    		$fields[] = 'query_time';
    	}else{
    		$emptyCondition = false; 
    		$condition['query_time']=$this->query_time;
    	}
    	if (!isset($this->is_robot)){
    		$emptyFields = false;
    		$fields[] = 'is_robot';
    	}else{
    		$emptyCondition = false; 
    		$condition['is_robot']=$this->is_robot;
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
				
		if (empty($this->user_id))
		{
			$this->user_id = MySQL::getInstance()->GetInsertId();
		}		
		
		$this->clean();
		
		return true;	
		
	}
	
	public function save($condition=NULL)
	{
		if (empty($condition))
		{
			$uc = "`user_id`='{$this->user_id}'";
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
		
		$sql = "DELETE FROM `player_fighting_strength_rank_limit` WHERE ".SQLUtil::parseCondition($condition);
		
		$qr = MySQL::getInstance()->RunQuery($sql);
				
		return (boolean)$qr;
	}
	
	public function  delete()
	{
		if (!isset($this->user_id))
		{
			return false;
		}
		
		$sql = "DELETE FROM `player_fighting_strength_rank_limit` WHERE `user_id`='{$this->user_id}'";
		
		if(isset($this->user_id)){MySQL::selectDbForUser($this->user_id);}else{MySQL::selectDbForUser($GLOBALS['USER_ID']);}
		$qr = MySQL::getInstance()->RunQuery($sql);
				
		return (boolean)$qr;
	}
	
	public function getInsertValue($fields)
	{
		$values = "(";		
		foreach($fields as $f => $k){
			if($f == 'user_id'){
 				$values .= "'{$this->user_id}',";
 			}else if($f == 'server_id'){
 				$values .= "'{$this->server_id}',";
 			}else if($f == 'gs'){
 				$values .= "'{$this->gs}',";
 			}else if($f == 'rank'){
 				$values .= "'{$this->rank}',";
 			}else if($f == 'last_rank'){
 				$values .= "'{$this->last_rank}',";
 			}else if($f == 'query_time'){
 				$values .= "'{$this->query_time}',";
 			}else if($f == 'is_robot'){
 				$values .= "'{$this->is_robot}',";
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

		if (isset($this->user_id))
		{
			$fields .= "`user_id`,";
			$values .= "'{$this->user_id}',";
		}
		if (isset($this->server_id))
		{
			$fields .= "`server_id`,";
			$values .= "'{$this->server_id}',";
		}
		if (isset($this->gs))
		{
			$fields .= "`gs`,";
			$values .= "'{$this->gs}',";
		}
		if (isset($this->rank))
		{
			$fields .= "`rank`,";
			$values .= "'{$this->rank}',";
		}
		if (isset($this->last_rank))
		{
			$fields .= "`last_rank`,";
			$values .= "'{$this->last_rank}',";
		}
		if (isset($this->query_time))
		{
			$fields .= "`query_time`,";
			$values .= "'{$this->query_time}',";
		}
		if (isset($this->is_robot))
		{
			$fields .= "`is_robot`,";
			$values .= "'{$this->is_robot}',";
		}

		
		$fields .= ")";
		$values .= ")";
		
		$sql = "INSERT INTO `player_fighting_strength_rank_limit` ".$fields.$values;
		
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
		if ($this->gs_status_field)
		{			
			if (!isset($this->gs))
			{
				$update .= ("`gs`=null,");
			}
			else
			{
				$update .= ("`gs`='{$this->gs}',");
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
		if ($this->is_robot_status_field)
		{			
			if (!isset($this->is_robot))
			{
				$update .= ("`is_robot`=null,");
			}
			else
			{
				$update .= ("`is_robot`='{$this->is_robot}',");
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
		
		$sql = "UPDATE `player_fighting_strength_rank_limit` SET {$update} WHERE {$condition}";
		
		return $sql;
	}
	
	public function  add($fieldsValue,$condition=NULL)
	{				
		if (empty($condition))
		{
			$uc = "`user_id`='{$this->user_id}'";
		}
		else
		{			
			$uc = SQLUtil::parseCondition($condition);
		}
		
		$update = SQLUtil::parseASFieldValues($fieldsValue);
		
		$sql = "UPDATE `player_fighting_strength_rank_limit` SET {$update} WHERE {$uc}";
		
		if(isset($this->user_id)){MySQL::selectDbForUser($this->user_id);}else{MySQL::selectDbForUser($GLOBALS['USER_ID']);}
		$qr = MySQL::getInstance()->RunQuery($sql);
				
		return (boolean)$qr;
	}	
	
	public function sub($fieldsVal,$condition=NULL)
	{
		if (empty($condition))
		{
			$uc = "`user_id`='{$this->user_id}'";
		}
		else
		{			
			$uc = SQLUtil::parseCondition($condition);
		}
		
		$update = SQLUtil::parseASFieldValues($fieldsVal,false);
		
		$sql = "UPDATE `player_fighting_strength_rank_limit` SET {$update} WHERE {$uc}";
		
		if(isset($this->user_id)){MySQL::selectDbForUser($this->user_id);}else{MySQL::selectDbForUser($GLOBALS['USER_ID']);}
		$qr = MySQL::getInstance()->RunQuery($sql);
				
		return (boolean)$qr;
	}
	
	private function /*void*/ clean() 
	{
		$this->this_table_status_field = false;
		$this->user_id_status_field = false;
		$this->server_id_status_field = false;
		$this->gs_status_field = false;
		$this->rank_status_field = false;
		$this->last_rank_status_field = false;
		$this->query_time_status_field = false;
		$this->is_robot_status_field = false;

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

	public function /*string*/ getGs()
	{
		return $this->gs;
	}
	
	public function /*void*/ setGs(/*string*/ $gs)
	{
		$this->gs = SQLUtil::toSafeSQLString($gs);
		$this->gs_status_field = true;		
		$this->this_table_status_field = true;		
	}

	public function /*void*/ setGsNull()
	{
		$this->gs = null;
		$this->gs_status_field = true;		
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

	public function /*int*/ getIsRobot()
	{
		return $this->is_robot;
	}
	
	public function /*void*/ setIsRobot(/*int*/ $is_robot)
	{
		$this->is_robot = intval($is_robot);
		$this->is_robot_status_field = true;		
		$this->this_table_status_field = true;		
	}

	public function /*void*/ setIsRobotNull()
	{
		$this->is_robot = null;
		$this->is_robot_status_field = true;		
		$this->this_table_status_field = true;
	}

	
	public function /*string*/ toDebugString()
	{
		$dbg = "(";
		
		$dbg .= ("user_id={$this->user_id},");
		$dbg .= ("server_id={$this->server_id},");
		$dbg .= ("gs={$this->gs},");
		$dbg .= ("rank={$this->rank},");
		$dbg .= ("last_rank={$this->last_rank},");
		$dbg .= ("query_time={$this->query_time},");
		$dbg .= ("is_robot={$this->is_robot},");

		$dbg .= ")";
				
		return str_replace(",)",")",$dbg);
	}
}

?>
