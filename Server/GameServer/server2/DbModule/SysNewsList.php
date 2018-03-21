<?php
require_once ($GLOBALS ['GAME_ROOT'] . "CMySQL.php");
require_once ("SQLUtil.php");
/**
 *  [The generated files]
 */

class SysNewsList {
	
	private /*int*/ $id; //PRIMARY KEY 
	private /*string*/ $title;
	private /*int*/ $pubdate;
	private /*int*/ $level;
	private /*string*/ $image_path;
	private /*string*/ $category;
	private /*string*/ $digest;
	private /*string*/ $content;
	private /*string*/ $seed;

	
	private $this_table_status_field = false;
	private $id_status_field = false;
	private $title_status_field = false;
	private $pubdate_status_field = false;
	private $level_status_field = false;
	private $image_path_status_field = false;
	private $category_status_field = false;
	private $digest_status_field = false;
	private $content_status_field = false;
	private $seed_status_field = false;


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
			$sql = "SELECT {$p} FROM `news_list`";
		}
		else
		{			
			$sql = "SELECT {$p} FROM `news_list` WHERE ".SQLUtil::parseCondition($condition);
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
			$tb = new SysNewsList();			
			if (isset($row['id'])) $tb->id = intval($row['id']);
			if (isset($row['title'])) $tb->title = $row['title'];
			if (isset($row['pubdate'])) $tb->pubdate = intval($row['pubdate']);
			if (isset($row['level'])) $tb->level = intval($row['level']);
			if (isset($row['image_path'])) $tb->image_path = $row['image_path'];
			if (isset($row['category'])) $tb->category = $row['category'];
			if (isset($row['digest'])) $tb->digest = $row['digest'];
			if (isset($row['content'])) $tb->content = $row['content'];
			if (isset($row['seed'])) $tb->seed = $row['seed'];
		
			$result[] = $tb;
		}
		
		return $result;
	}	
	
	public static function insertSqlHeader($fields=NULL)
	{
		$result = array();				
		if(!empty($fields)){
			$where = SQLUtil::parseFields($fields);			
			$result[0] = "INSERT INTO `news_list` ({$where}) VALUES ";	
			$ar = array();
			foreach($fields as $key){
				$ar[$key]=1;
			}
			$result[1] = $ar;
		}else{
			$result[0]="INSERT INTO `news_list` (`id`,`title`,`pubdate`,`level`,`image_path`,`category`,`digest`,`content`,`seed`) VALUES ";
			$result[1] = array('id'=>1,'title'=>1,'pubdate'=>1,'level'=>1,'image_path'=>1,'category'=>1,'digest'=>1,'content'=>1,'seed'=>1);
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
		
		$sql = "SELECT {$p} FROM `news_list` WHERE {$where}";

		MySQL::selectDefaultDb();
		$qr = MySQL::getInstance()->RunQuery($sql);
		$ar = MySQL::getInstance()->FetchArray($qr);
		
		if (!$ar || count($ar)==0)
		{
			return false;
		}
		
		if (isset($ar['id'])) $this->id = intval($ar['id']);
		if (isset($ar['title'])) $this->title = $ar['title'];
		if (isset($ar['pubdate'])) $this->pubdate = intval($ar['pubdate']);
		if (isset($ar['level'])) $this->level = intval($ar['level']);
		if (isset($ar['image_path'])) $this->image_path = $ar['image_path'];
		if (isset($ar['category'])) $this->category = $ar['category'];
		if (isset($ar['digest'])) $this->digest = $ar['digest'];
		if (isset($ar['content'])) $this->content = $ar['content'];
		if (isset($ar['seed'])) $this->seed = $ar['seed'];
		
		
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
	
		$sql = "SELECT {$p} FROM `news_list` WHERE {$where}";
	
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
    	if (!isset($this->title)){
    		$emptyFields = false;
    		$fields[] = 'title';
    	}else{
    		$emptyCondition = false; 
    		$condition['title']=$this->title;
    	}
    	if (!isset($this->pubdate)){
    		$emptyFields = false;
    		$fields[] = 'pubdate';
    	}else{
    		$emptyCondition = false; 
    		$condition['pubdate']=$this->pubdate;
    	}
    	if (!isset($this->level)){
    		$emptyFields = false;
    		$fields[] = 'level';
    	}else{
    		$emptyCondition = false; 
    		$condition['level']=$this->level;
    	}
    	if (!isset($this->image_path)){
    		$emptyFields = false;
    		$fields[] = 'image_path';
    	}else{
    		$emptyCondition = false; 
    		$condition['image_path']=$this->image_path;
    	}
    	if (!isset($this->category)){
    		$emptyFields = false;
    		$fields[] = 'category';
    	}else{
    		$emptyCondition = false; 
    		$condition['category']=$this->category;
    	}
    	if (!isset($this->digest)){
    		$emptyFields = false;
    		$fields[] = 'digest';
    	}else{
    		$emptyCondition = false; 
    		$condition['digest']=$this->digest;
    	}
    	if (!isset($this->content)){
    		$emptyFields = false;
    		$fields[] = 'content';
    	}else{
    		$emptyCondition = false; 
    		$condition['content']=$this->content;
    	}
    	if (!isset($this->seed)){
    		$emptyFields = false;
    		$fields[] = 'seed';
    	}else{
    		$emptyCondition = false; 
    		$condition['seed']=$this->seed;
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
		
		$sql = "DELETE FROM `news_list` WHERE ".SQLUtil::parseCondition($condition);
		
		$qr = MySQL::getInstance()->RunQuery($sql);
				
		return (boolean)$qr;
	}
	
	public function  delete()
	{
		if (!isset($this->id))
		{
			return false;
		}
		
		$sql = "DELETE FROM `news_list` WHERE `id`='{$this->id}'";
		
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
 			}else if($f == 'title'){
 				$values .= "'{$this->title}',";
 			}else if($f == 'pubdate'){
 				$values .= "'{$this->pubdate}',";
 			}else if($f == 'level'){
 				$values .= "'{$this->level}',";
 			}else if($f == 'image_path'){
 				$values .= "'{$this->image_path}',";
 			}else if($f == 'category'){
 				$values .= "'{$this->category}',";
 			}else if($f == 'digest'){
 				$values .= "'{$this->digest}',";
 			}else if($f == 'content'){
 				$values .= "'{$this->content}',";
 			}else if($f == 'seed'){
 				$values .= "'{$this->seed}',";
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
		if (isset($this->title))
		{
			$fields .= "`title`,";
			$values .= "'{$this->title}',";
		}
		if (isset($this->pubdate))
		{
			$fields .= "`pubdate`,";
			$values .= "'{$this->pubdate}',";
		}
		if (isset($this->level))
		{
			$fields .= "`level`,";
			$values .= "'{$this->level}',";
		}
		if (isset($this->image_path))
		{
			$fields .= "`image_path`,";
			$values .= "'{$this->image_path}',";
		}
		if (isset($this->category))
		{
			$fields .= "`category`,";
			$values .= "'{$this->category}',";
		}
		if (isset($this->digest))
		{
			$fields .= "`digest`,";
			$values .= "'{$this->digest}',";
		}
		if (isset($this->content))
		{
			$fields .= "`content`,";
			$values .= "'{$this->content}',";
		}
		if (isset($this->seed))
		{
			$fields .= "`seed`,";
			$values .= "'{$this->seed}',";
		}

		
		$fields .= ")";
		$values .= ")";
		
		$sql = "INSERT INTO `news_list` ".$fields.$values;
		
		return str_replace(",)",")",$sql);
	}
	
	private function  getUpFields()
	{
		$update = "";
		
		if ($this->title_status_field)
		{			
			if (!isset($this->title))
			{
				$update .= ("`title`=null,");
			}
			else
			{
				$update .= ("`title`='{$this->title}',");
			}
		}
		if ($this->pubdate_status_field)
		{			
			if (!isset($this->pubdate))
			{
				$update .= ("`pubdate`=null,");
			}
			else
			{
				$update .= ("`pubdate`='{$this->pubdate}',");
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
		if ($this->image_path_status_field)
		{			
			if (!isset($this->image_path))
			{
				$update .= ("`image_path`=null,");
			}
			else
			{
				$update .= ("`image_path`='{$this->image_path}',");
			}
		}
		if ($this->category_status_field)
		{			
			if (!isset($this->category))
			{
				$update .= ("`category`=null,");
			}
			else
			{
				$update .= ("`category`='{$this->category}',");
			}
		}
		if ($this->digest_status_field)
		{			
			if (!isset($this->digest))
			{
				$update .= ("`digest`=null,");
			}
			else
			{
				$update .= ("`digest`='{$this->digest}',");
			}
		}
		if ($this->content_status_field)
		{			
			if (!isset($this->content))
			{
				$update .= ("`content`=null,");
			}
			else
			{
				$update .= ("`content`='{$this->content}',");
			}
		}
		if ($this->seed_status_field)
		{			
			if (!isset($this->seed))
			{
				$update .= ("`seed`=null,");
			}
			else
			{
				$update .= ("`seed`='{$this->seed}',");
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
		
		$sql = "UPDATE `news_list` SET {$update} WHERE {$condition}";
		
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
		
		$sql = "UPDATE `news_list` SET {$update} WHERE {$uc}";
		
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
		
		$sql = "UPDATE `news_list` SET {$update} WHERE {$uc}";
		
		MySQL::selectDefaultDb();
		$qr = MySQL::getInstance()->RunQuery($sql);
				
		return (boolean)$qr;
	}
	
	private function /*void*/ clean() 
	{
		$this->this_table_status_field = false;
		$this->id_status_field = false;
		$this->title_status_field = false;
		$this->pubdate_status_field = false;
		$this->level_status_field = false;
		$this->image_path_status_field = false;
		$this->category_status_field = false;
		$this->digest_status_field = false;
		$this->content_status_field = false;
		$this->seed_status_field = false;

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

	public function /*string*/ getTitle()
	{
		return $this->title;
	}
	
	public function /*void*/ setTitle(/*string*/ $title)
	{
		$this->title = SQLUtil::toSafeSQLString($title);
		$this->title_status_field = true;		
		$this->this_table_status_field = true;		
	}

	public function /*void*/ setTitleNull()
	{
		$this->title = null;
		$this->title_status_field = true;		
		$this->this_table_status_field = true;
	}

	public function /*int*/ getPubdate()
	{
		return $this->pubdate;
	}
	
	public function /*void*/ setPubdate(/*int*/ $pubdate)
	{
		$this->pubdate = intval($pubdate);
		$this->pubdate_status_field = true;		
		$this->this_table_status_field = true;		
	}

	public function /*void*/ setPubdateNull()
	{
		$this->pubdate = null;
		$this->pubdate_status_field = true;		
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

	public function /*string*/ getImagePath()
	{
		return $this->image_path;
	}
	
	public function /*void*/ setImagePath(/*string*/ $image_path)
	{
		$this->image_path = SQLUtil::toSafeSQLString($image_path);
		$this->image_path_status_field = true;		
		$this->this_table_status_field = true;		
	}

	public function /*void*/ setImagePathNull()
	{
		$this->image_path = null;
		$this->image_path_status_field = true;		
		$this->this_table_status_field = true;
	}

	public function /*string*/ getCategory()
	{
		return $this->category;
	}
	
	public function /*void*/ setCategory(/*string*/ $category)
	{
		$this->category = SQLUtil::toSafeSQLString($category);
		$this->category_status_field = true;		
		$this->this_table_status_field = true;		
	}

	public function /*void*/ setCategoryNull()
	{
		$this->category = null;
		$this->category_status_field = true;		
		$this->this_table_status_field = true;
	}

	public function /*string*/ getDigest()
	{
		return $this->digest;
	}
	
	public function /*void*/ setDigest(/*string*/ $digest)
	{
		$this->digest = SQLUtil::toSafeSQLString($digest);
		$this->digest_status_field = true;		
		$this->this_table_status_field = true;		
	}

	public function /*void*/ setDigestNull()
	{
		$this->digest = null;
		$this->digest_status_field = true;		
		$this->this_table_status_field = true;
	}

	public function /*string*/ getContent()
	{
		return $this->content;
	}
	
	public function /*void*/ setContent(/*string*/ $content)
	{
		$this->content = SQLUtil::toSafeSQLString($content);
		$this->content_status_field = true;		
		$this->this_table_status_field = true;		
	}

	public function /*void*/ setContentNull()
	{
		$this->content = null;
		$this->content_status_field = true;		
		$this->this_table_status_field = true;
	}

	public function /*string*/ getSeed()
	{
		return $this->seed;
	}
	
	public function /*void*/ setSeed(/*string*/ $seed)
	{
		$this->seed = SQLUtil::toSafeSQLString($seed);
		$this->seed_status_field = true;		
		$this->this_table_status_field = true;		
	}

	public function /*void*/ setSeedNull()
	{
		$this->seed = null;
		$this->seed_status_field = true;		
		$this->this_table_status_field = true;
	}

	
	public function /*string*/ toDebugString()
	{
		$dbg = "(";
		
		$dbg .= ("id={$this->id},");
		$dbg .= ("title={$this->title},");
		$dbg .= ("pubdate={$this->pubdate},");
		$dbg .= ("level={$this->level},");
		$dbg .= ("image_path={$this->image_path},");
		$dbg .= ("category={$this->category},");
		$dbg .= ("digest={$this->digest},");
		$dbg .= ("content={$this->content},");
		$dbg .= ("seed={$this->seed},");

		$dbg .= ")";
				
		return str_replace(",)",")",$dbg);
	}
}

?>
