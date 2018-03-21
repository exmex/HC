<?php
require_once ($GLOBALS ['GAME_ROOT'] . "CMySQL.php");
require_once ("SQLUtil.php");
/**
 *  [The generated files]
 */

class SysLocalStrings {
	
	private /*string*/ $id; //PRIMARY KEY ID
	private /*string*/ $key; //string key
	private /*string*/ $lang; //language id
	private /*string*/ $string; //local string

	
	private $this_table_status_field = false;
	private $id_status_field = false;
	private $key_status_field = false;
	private $lang_status_field = false;
	private $string_status_field = false;


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
			$sql = "SELECT {$p} FROM `local_strings`";
		}
		else
		{			
			$sql = "SELECT {$p} FROM `local_strings` WHERE ".SQLUtil::parseCondition($condition);
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
			$tb = new SysLocalStrings();			
			if (isset($row['id'])) $tb->id = $row['id'];
			if (isset($row['key'])) $tb->key = $row['key'];
			if (isset($row['lang'])) $tb->lang = $row['lang'];
			if (isset($row['string'])) $tb->string = $row['string'];
		
			$result[] = $tb;
		}
		
		return $result;
	}	
	
	public static function insertSqlHeader($fields=NULL)
	{
		$result = array();				
		if(!empty($fields)){
			$where = SQLUtil::parseFields($fields);			
			$result[0] = "INSERT INTO `local_strings` ({$where}) VALUES ";	
			$ar = array();
			foreach($fields as $key){
				$ar[$key]=1;
			}
			$result[1] = $ar;
		}else{
			$result[0]="INSERT INTO `local_strings` (`id`,`key`,`lang`,`string`) VALUES ";
			$result[1] = array('id'=>1,'key'=>1,'lang'=>1,'string'=>1);
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
		
		$sql = "SELECT {$p} FROM `local_strings` WHERE {$where}";

		MySQL::selectDefaultDb();
		$qr = MySQL::getInstance()->RunQuery($sql);
		$ar = MySQL::getInstance()->FetchArray($qr);
		
		if (!$ar || count($ar)==0)
		{
			return false;
		}
		
		if (isset($ar['id'])) $this->id = $ar['id'];
		if (isset($ar['key'])) $this->key = $ar['key'];
		if (isset($ar['lang'])) $this->lang = $ar['lang'];
		if (isset($ar['string'])) $this->string = $ar['string'];
		
		
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
	
		$sql = "SELECT {$p} FROM `local_strings` WHERE {$where}";
	
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
    	if (!isset($this->key)){
    		$emptyFields = false;
    		$fields[] = 'key';
    	}else{
    		$emptyCondition = false; 
    		$condition['key']=$this->key;
    	}
    	if (!isset($this->lang)){
    		$emptyFields = false;
    		$fields[] = 'lang';
    	}else{
    		$emptyCondition = false; 
    		$condition['lang']=$this->lang;
    	}
    	if (!isset($this->string)){
    		$emptyFields = false;
    		$fields[] = 'string';
    	}else{
    		$emptyCondition = false; 
    		$condition['string']=$this->string;
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
		
		$sql = "DELETE FROM `local_strings` WHERE ".SQLUtil::parseCondition($condition);
		
		$qr = MySQL::getInstance()->RunQuery($sql);
				
		return (boolean)$qr;
	}
	
	public function  delete()
	{
		if (!isset($this->id))
		{
			return false;
		}
		
		$sql = "DELETE FROM `local_strings` WHERE `id`='{$this->id}'";
		
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
 			}else if($f == 'key'){
 				$values .= "'{$this->key}',";
 			}else if($f == 'lang'){
 				$values .= "'{$this->lang}',";
 			}else if($f == 'string'){
 				$values .= "'{$this->string}',";
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
		if (isset($this->key))
		{
			$fields .= "`key`,";
			$values .= "'{$this->key}',";
		}
		if (isset($this->lang))
		{
			$fields .= "`lang`,";
			$values .= "'{$this->lang}',";
		}
		if (isset($this->string))
		{
			$fields .= "`string`,";
			$values .= "'{$this->string}',";
		}

		
		$fields .= ")";
		$values .= ")";
		
		$sql = "INSERT INTO `local_strings` ".$fields.$values;
		
		return str_replace(",)",")",$sql);
	}
	
	private function  getUpFields()
	{
		$update = "";
		
		if ($this->key_status_field)
		{			
			if (!isset($this->key))
			{
				$update .= ("`key`=null,");
			}
			else
			{
				$update .= ("`key`='{$this->key}',");
			}
		}
		if ($this->lang_status_field)
		{			
			if (!isset($this->lang))
			{
				$update .= ("`lang`=null,");
			}
			else
			{
				$update .= ("`lang`='{$this->lang}',");
			}
		}
		if ($this->string_status_field)
		{			
			if (!isset($this->string))
			{
				$update .= ("`string`=null,");
			}
			else
			{
				$update .= ("`string`='{$this->string}',");
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
		
		$sql = "UPDATE `local_strings` SET {$update} WHERE {$condition}";
		
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
		
		$sql = "UPDATE `local_strings` SET {$update} WHERE {$uc}";
		
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
		
		$sql = "UPDATE `local_strings` SET {$update} WHERE {$uc}";
		
		MySQL::selectDefaultDb();
		$qr = MySQL::getInstance()->RunQuery($sql);
				
		return (boolean)$qr;
	}
	
	private function /*void*/ clean() 
	{
		$this->this_table_status_field = false;
		$this->id_status_field = false;
		$this->key_status_field = false;
		$this->lang_status_field = false;
		$this->string_status_field = false;

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

	public function /*string*/ getKey()
	{
		return $this->key;
	}
	
	public function /*void*/ setKey(/*string*/ $key)
	{
		$this->key = SQLUtil::toSafeSQLString($key);
		$this->key_status_field = true;		
		$this->this_table_status_field = true;		
	}

	public function /*void*/ setKeyNull()
	{
		$this->key = null;
		$this->key_status_field = true;		
		$this->this_table_status_field = true;
	}

	public function /*string*/ getLang()
	{
		return $this->lang;
	}
	
	public function /*void*/ setLang(/*string*/ $lang)
	{
		$this->lang = SQLUtil::toSafeSQLString($lang);
		$this->lang_status_field = true;		
		$this->this_table_status_field = true;		
	}

	public function /*void*/ setLangNull()
	{
		$this->lang = null;
		$this->lang_status_field = true;		
		$this->this_table_status_field = true;
	}

	public function /*string*/ getString()
	{
		return $this->string;
	}
	
	public function /*void*/ setString(/*string*/ $string)
	{
		$this->string = SQLUtil::toSafeSQLString($string);
		$this->string_status_field = true;		
		$this->this_table_status_field = true;		
	}

	public function /*void*/ setStringNull()
	{
		$this->string = null;
		$this->string_status_field = true;		
		$this->this_table_status_field = true;
	}

	
	public function /*string*/ toDebugString()
	{
		$dbg = "(";
		
		$dbg .= ("id={$this->id},");
		$dbg .= ("key={$this->key},");
		$dbg .= ("lang={$this->lang},");
		$dbg .= ("string={$this->string},");

		$dbg .= ")";
				
		return str_replace(",)",")",$dbg);
	}
}

?>
