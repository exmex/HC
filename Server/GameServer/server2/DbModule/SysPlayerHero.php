<?php
require_once ($GLOBALS ['GAME_ROOT'] . "CMySQL.php");
require_once ("SQLUtil.php");
/**
 *  [The generated files]
 */

class SysPlayerHero {
	
	private /*string*/ $id; //PRIMARY KEY 
	private /*string*/ $user_id;
	private /*int*/ $tid;
	private /*int*/ $level;
	private /*string*/ $exp;
	private /*int*/ $rank;
	private /*int*/ $stars;
	private /*string*/ $gs;
	private /*int*/ $state;
	private /*int*/ $skill1_level;
	private /*int*/ $skill2_level;
	private /*int*/ $skill3_level;
	private /*int*/ $skill4_level;
	private /*string*/ $hero_equip;

	
	private $this_table_status_field = false;
	private $id_status_field = false;
	private $user_id_status_field = false;
	private $tid_status_field = false;
	private $level_status_field = false;
	private $exp_status_field = false;
	private $rank_status_field = false;
	private $stars_status_field = false;
	private $gs_status_field = false;
	private $state_status_field = false;
	private $skill1_level_status_field = false;
	private $skill2_level_status_field = false;
	private $skill3_level_status_field = false;
	private $skill4_level_status_field = false;
	private $hero_equip_status_field = false;


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
			$sql = "SELECT {$p} FROM `player_hero`";
		}
		else
		{			
			$sql = "SELECT {$p} FROM `player_hero` WHERE ".SQLUtil::parseCondition($condition);
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
			$tb = new SysPlayerHero();			
			if (isset($row['id'])) $tb->id = $row['id'];
			if (isset($row['user_id'])) $tb->user_id = $row['user_id'];
			if (isset($row['tid'])) $tb->tid = intval($row['tid']);
			if (isset($row['level'])) $tb->level = intval($row['level']);
			if (isset($row['exp'])) $tb->exp = $row['exp'];
			if (isset($row['rank'])) $tb->rank = intval($row['rank']);
			if (isset($row['stars'])) $tb->stars = intval($row['stars']);
			if (isset($row['gs'])) $tb->gs = $row['gs'];
			if (isset($row['state'])) $tb->state = intval($row['state']);
			if (isset($row['skill1_level'])) $tb->skill1_level = intval($row['skill1_level']);
			if (isset($row['skill2_level'])) $tb->skill2_level = intval($row['skill2_level']);
			if (isset($row['skill3_level'])) $tb->skill3_level = intval($row['skill3_level']);
			if (isset($row['skill4_level'])) $tb->skill4_level = intval($row['skill4_level']);
			if (isset($row['hero_equip'])) $tb->hero_equip = $row['hero_equip'];
		
			$result[] = $tb;
		}
		
		return $result;
	}	
	
	public static function insertSqlHeader($fields=NULL)
	{
		$result = array();				
		if(!empty($fields)){
			$where = SQLUtil::parseFields($fields);			
			$result[0] = "INSERT INTO `player_hero` ({$where}) VALUES ";	
			$ar = array();
			foreach($fields as $key){
				$ar[$key]=1;
			}
			$result[1] = $ar;
		}else{
			$result[0]="INSERT INTO `player_hero` (`id`,`user_id`,`tid`,`level`,`exp`,`rank`,`stars`,`gs`,`state`,`skill1_level`,`skill2_level`,`skill3_level`,`skill4_level`,`hero_equip`) VALUES ";
			$result[1] = array('id'=>1,'user_id'=>1,'tid'=>1,'level'=>1,'exp'=>1,'rank'=>1,'stars'=>1,'gs'=>1,'state'=>1,'skill1_level'=>1,'skill2_level'=>1,'skill3_level'=>1,'skill4_level'=>1,'hero_equip'=>1);
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
		
		$sql = "SELECT {$p} FROM `player_hero` WHERE {$where}";

		if(isset($this->user_id)){MySQL::selectDbForUser($this->user_id);}else{MySQL::selectDbForUser($GLOBALS['USER_ID']);}
		$qr = MySQL::getInstance()->RunQuery($sql);
		$ar = MySQL::getInstance()->FetchArray($qr);
		
		if (!$ar || count($ar)==0)
		{
			return false;
		}
		
		if (isset($ar['id'])) $this->id = $ar['id'];
		if (isset($ar['user_id'])) $this->user_id = $ar['user_id'];
		if (isset($ar['tid'])) $this->tid = intval($ar['tid']);
		if (isset($ar['level'])) $this->level = intval($ar['level']);
		if (isset($ar['exp'])) $this->exp = $ar['exp'];
		if (isset($ar['rank'])) $this->rank = intval($ar['rank']);
		if (isset($ar['stars'])) $this->stars = intval($ar['stars']);
		if (isset($ar['gs'])) $this->gs = $ar['gs'];
		if (isset($ar['state'])) $this->state = intval($ar['state']);
		if (isset($ar['skill1_level'])) $this->skill1_level = intval($ar['skill1_level']);
		if (isset($ar['skill2_level'])) $this->skill2_level = intval($ar['skill2_level']);
		if (isset($ar['skill3_level'])) $this->skill3_level = intval($ar['skill3_level']);
		if (isset($ar['skill4_level'])) $this->skill4_level = intval($ar['skill4_level']);
		if (isset($ar['hero_equip'])) $this->hero_equip = $ar['hero_equip'];
		
		
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
	
		$sql = "SELECT {$p} FROM `player_hero` WHERE {$where}";
	
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
    	if (!isset($this->tid)){
    		$emptyFields = false;
    		$fields[] = 'tid';
    	}else{
    		$emptyCondition = false; 
    		$condition['tid']=$this->tid;
    	}
    	if (!isset($this->level)){
    		$emptyFields = false;
    		$fields[] = 'level';
    	}else{
    		$emptyCondition = false; 
    		$condition['level']=$this->level;
    	}
    	if (!isset($this->exp)){
    		$emptyFields = false;
    		$fields[] = 'exp';
    	}else{
    		$emptyCondition = false; 
    		$condition['exp']=$this->exp;
    	}
    	if (!isset($this->rank)){
    		$emptyFields = false;
    		$fields[] = 'rank';
    	}else{
    		$emptyCondition = false; 
    		$condition['rank']=$this->rank;
    	}
    	if (!isset($this->stars)){
    		$emptyFields = false;
    		$fields[] = 'stars';
    	}else{
    		$emptyCondition = false; 
    		$condition['stars']=$this->stars;
    	}
    	if (!isset($this->gs)){
    		$emptyFields = false;
    		$fields[] = 'gs';
    	}else{
    		$emptyCondition = false; 
    		$condition['gs']=$this->gs;
    	}
    	if (!isset($this->state)){
    		$emptyFields = false;
    		$fields[] = 'state';
    	}else{
    		$emptyCondition = false; 
    		$condition['state']=$this->state;
    	}
    	if (!isset($this->skill1_level)){
    		$emptyFields = false;
    		$fields[] = 'skill1_level';
    	}else{
    		$emptyCondition = false; 
    		$condition['skill1_level']=$this->skill1_level;
    	}
    	if (!isset($this->skill2_level)){
    		$emptyFields = false;
    		$fields[] = 'skill2_level';
    	}else{
    		$emptyCondition = false; 
    		$condition['skill2_level']=$this->skill2_level;
    	}
    	if (!isset($this->skill3_level)){
    		$emptyFields = false;
    		$fields[] = 'skill3_level';
    	}else{
    		$emptyCondition = false; 
    		$condition['skill3_level']=$this->skill3_level;
    	}
    	if (!isset($this->skill4_level)){
    		$emptyFields = false;
    		$fields[] = 'skill4_level';
    	}else{
    		$emptyCondition = false; 
    		$condition['skill4_level']=$this->skill4_level;
    	}
    	if (!isset($this->hero_equip)){
    		$emptyFields = false;
    		$fields[] = 'hero_equip';
    	}else{
    		$emptyCondition = false; 
    		$condition['hero_equip']=$this->hero_equip;
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
		
		$sql = "DELETE FROM `player_hero` WHERE ".SQLUtil::parseCondition($condition);
		
		$qr = MySQL::getInstance()->RunQuery($sql);
				
		return (boolean)$qr;
	}
	
	public function  delete()
	{
		if (!isset($this->id))
		{
			return false;
		}
		
		$sql = "DELETE FROM `player_hero` WHERE `id`='{$this->id}'";
		
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
 			}else if($f == 'tid'){
 				$values .= "'{$this->tid}',";
 			}else if($f == 'level'){
 				$values .= "'{$this->level}',";
 			}else if($f == 'exp'){
 				$values .= "'{$this->exp}',";
 			}else if($f == 'rank'){
 				$values .= "'{$this->rank}',";
 			}else if($f == 'stars'){
 				$values .= "'{$this->stars}',";
 			}else if($f == 'gs'){
 				$values .= "'{$this->gs}',";
 			}else if($f == 'state'){
 				$values .= "'{$this->state}',";
 			}else if($f == 'skill1_level'){
 				$values .= "'{$this->skill1_level}',";
 			}else if($f == 'skill2_level'){
 				$values .= "'{$this->skill2_level}',";
 			}else if($f == 'skill3_level'){
 				$values .= "'{$this->skill3_level}',";
 			}else if($f == 'skill4_level'){
 				$values .= "'{$this->skill4_level}',";
 			}else if($f == 'hero_equip'){
 				$values .= "'{$this->hero_equip}',";
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
		if (isset($this->tid))
		{
			$fields .= "`tid`,";
			$values .= "'{$this->tid}',";
		}
		if (isset($this->level))
		{
			$fields .= "`level`,";
			$values .= "'{$this->level}',";
		}
		if (isset($this->exp))
		{
			$fields .= "`exp`,";
			$values .= "'{$this->exp}',";
		}
		if (isset($this->rank))
		{
			$fields .= "`rank`,";
			$values .= "'{$this->rank}',";
		}
		if (isset($this->stars))
		{
			$fields .= "`stars`,";
			$values .= "'{$this->stars}',";
		}
		if (isset($this->gs))
		{
			$fields .= "`gs`,";
			$values .= "'{$this->gs}',";
		}
		if (isset($this->state))
		{
			$fields .= "`state`,";
			$values .= "'{$this->state}',";
		}
		if (isset($this->skill1_level))
		{
			$fields .= "`skill1_level`,";
			$values .= "'{$this->skill1_level}',";
		}
		if (isset($this->skill2_level))
		{
			$fields .= "`skill2_level`,";
			$values .= "'{$this->skill2_level}',";
		}
		if (isset($this->skill3_level))
		{
			$fields .= "`skill3_level`,";
			$values .= "'{$this->skill3_level}',";
		}
		if (isset($this->skill4_level))
		{
			$fields .= "`skill4_level`,";
			$values .= "'{$this->skill4_level}',";
		}
		if (isset($this->hero_equip))
		{
			$fields .= "`hero_equip`,";
			$values .= "'{$this->hero_equip}',";
		}

		
		$fields .= ")";
		$values .= ")";
		
		$sql = "INSERT INTO `player_hero` ".$fields.$values;
		
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
		if ($this->tid_status_field)
		{			
			if (!isset($this->tid))
			{
				$update .= ("`tid`=null,");
			}
			else
			{
				$update .= ("`tid`='{$this->tid}',");
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
		if ($this->exp_status_field)
		{			
			if (!isset($this->exp))
			{
				$update .= ("`exp`=null,");
			}
			else
			{
				$update .= ("`exp`='{$this->exp}',");
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
		if ($this->stars_status_field)
		{			
			if (!isset($this->stars))
			{
				$update .= ("`stars`=null,");
			}
			else
			{
				$update .= ("`stars`='{$this->stars}',");
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
		if ($this->skill1_level_status_field)
		{			
			if (!isset($this->skill1_level))
			{
				$update .= ("`skill1_level`=null,");
			}
			else
			{
				$update .= ("`skill1_level`='{$this->skill1_level}',");
			}
		}
		if ($this->skill2_level_status_field)
		{			
			if (!isset($this->skill2_level))
			{
				$update .= ("`skill2_level`=null,");
			}
			else
			{
				$update .= ("`skill2_level`='{$this->skill2_level}',");
			}
		}
		if ($this->skill3_level_status_field)
		{			
			if (!isset($this->skill3_level))
			{
				$update .= ("`skill3_level`=null,");
			}
			else
			{
				$update .= ("`skill3_level`='{$this->skill3_level}',");
			}
		}
		if ($this->skill4_level_status_field)
		{			
			if (!isset($this->skill4_level))
			{
				$update .= ("`skill4_level`=null,");
			}
			else
			{
				$update .= ("`skill4_level`='{$this->skill4_level}',");
			}
		}
		if ($this->hero_equip_status_field)
		{			
			if (!isset($this->hero_equip))
			{
				$update .= ("`hero_equip`=null,");
			}
			else
			{
				$update .= ("`hero_equip`='{$this->hero_equip}',");
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
		
		$sql = "UPDATE `player_hero` SET {$update} WHERE {$condition}";
		
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
		
		$sql = "UPDATE `player_hero` SET {$update} WHERE {$uc}";
		
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
		
		$sql = "UPDATE `player_hero` SET {$update} WHERE {$uc}";
		
		if(isset($this->user_id)){MySQL::selectDbForUser($this->user_id);}else{MySQL::selectDbForUser($GLOBALS['USER_ID']);}
		$qr = MySQL::getInstance()->RunQuery($sql);
				
		return (boolean)$qr;
	}
	
	private function /*void*/ clean() 
	{
		$this->this_table_status_field = false;
		$this->id_status_field = false;
		$this->user_id_status_field = false;
		$this->tid_status_field = false;
		$this->level_status_field = false;
		$this->exp_status_field = false;
		$this->rank_status_field = false;
		$this->stars_status_field = false;
		$this->gs_status_field = false;
		$this->state_status_field = false;
		$this->skill1_level_status_field = false;
		$this->skill2_level_status_field = false;
		$this->skill3_level_status_field = false;
		$this->skill4_level_status_field = false;
		$this->hero_equip_status_field = false;

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

	public function /*int*/ getTid()
	{
		return $this->tid;
	}
	
	public function /*void*/ setTid(/*int*/ $tid)
	{
		$this->tid = intval($tid);
		$this->tid_status_field = true;		
		$this->this_table_status_field = true;		
	}

	public function /*void*/ setTidNull()
	{
		$this->tid = null;
		$this->tid_status_field = true;		
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

	public function /*string*/ getExp()
	{
		return $this->exp;
	}
	
	public function /*void*/ setExp(/*string*/ $exp)
	{
		$this->exp = SQLUtil::toSafeSQLString($exp);
		$this->exp_status_field = true;		
		$this->this_table_status_field = true;		
	}

	public function /*void*/ setExpNull()
	{
		$this->exp = null;
		$this->exp_status_field = true;		
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

	public function /*int*/ getStars()
	{
		return $this->stars;
	}
	
	public function /*void*/ setStars(/*int*/ $stars)
	{
		$this->stars = intval($stars);
		$this->stars_status_field = true;		
		$this->this_table_status_field = true;		
	}

	public function /*void*/ setStarsNull()
	{
		$this->stars = null;
		$this->stars_status_field = true;		
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

	public function /*int*/ getSkill1Level()
	{
		return $this->skill1_level;
	}
	
	public function /*void*/ setSkill1Level(/*int*/ $skill1_level)
	{
		$this->skill1_level = intval($skill1_level);
		$this->skill1_level_status_field = true;		
		$this->this_table_status_field = true;		
	}

	public function /*void*/ setSkill1LevelNull()
	{
		$this->skill1_level = null;
		$this->skill1_level_status_field = true;		
		$this->this_table_status_field = true;
	}

	public function /*int*/ getSkill2Level()
	{
		return $this->skill2_level;
	}
	
	public function /*void*/ setSkill2Level(/*int*/ $skill2_level)
	{
		$this->skill2_level = intval($skill2_level);
		$this->skill2_level_status_field = true;		
		$this->this_table_status_field = true;		
	}

	public function /*void*/ setSkill2LevelNull()
	{
		$this->skill2_level = null;
		$this->skill2_level_status_field = true;		
		$this->this_table_status_field = true;
	}

	public function /*int*/ getSkill3Level()
	{
		return $this->skill3_level;
	}
	
	public function /*void*/ setSkill3Level(/*int*/ $skill3_level)
	{
		$this->skill3_level = intval($skill3_level);
		$this->skill3_level_status_field = true;		
		$this->this_table_status_field = true;		
	}

	public function /*void*/ setSkill3LevelNull()
	{
		$this->skill3_level = null;
		$this->skill3_level_status_field = true;		
		$this->this_table_status_field = true;
	}

	public function /*int*/ getSkill4Level()
	{
		return $this->skill4_level;
	}
	
	public function /*void*/ setSkill4Level(/*int*/ $skill4_level)
	{
		$this->skill4_level = intval($skill4_level);
		$this->skill4_level_status_field = true;		
		$this->this_table_status_field = true;		
	}

	public function /*void*/ setSkill4LevelNull()
	{
		$this->skill4_level = null;
		$this->skill4_level_status_field = true;		
		$this->this_table_status_field = true;
	}

	public function /*string*/ getHeroEquip()
	{
		return $this->hero_equip;
	}
	
	public function /*void*/ setHeroEquip(/*string*/ $hero_equip)
	{
		$this->hero_equip = SQLUtil::toSafeSQLString($hero_equip);
		$this->hero_equip_status_field = true;		
		$this->this_table_status_field = true;		
	}

	public function /*void*/ setHeroEquipNull()
	{
		$this->hero_equip = null;
		$this->hero_equip_status_field = true;		
		$this->this_table_status_field = true;
	}

	
	public function /*string*/ toDebugString()
	{
		$dbg = "(";
		
		$dbg .= ("id={$this->id},");
		$dbg .= ("user_id={$this->user_id},");
		$dbg .= ("tid={$this->tid},");
		$dbg .= ("level={$this->level},");
		$dbg .= ("exp={$this->exp},");
		$dbg .= ("rank={$this->rank},");
		$dbg .= ("stars={$this->stars},");
		$dbg .= ("gs={$this->gs},");
		$dbg .= ("state={$this->state},");
		$dbg .= ("skill1_level={$this->skill1_level},");
		$dbg .= ("skill2_level={$this->skill2_level},");
		$dbg .= ("skill3_level={$this->skill3_level},");
		$dbg .= ("skill4_level={$this->skill4_level},");
		$dbg .= ("hero_equip={$this->hero_equip},");

		$dbg .= ")";
				
		return str_replace(",)",")",$dbg);
	}
}

?>
