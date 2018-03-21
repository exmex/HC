<?php
require_once ($GLOBALS ['GAME_ROOT'] . "CMySQL.php");
require_once ("SQLUtil.php");
/**
 *  [The generated files]
 */

class SysUserSettings {
	
	private /*string*/ $uin; //PRIMARY KEY 
	private /*string*/ $settings;

	
	private $this_table_status_field = false;
	private $uin_status_field = false;
	private $settings_status_field = false;


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
			$sql = "SELECT {$p} FROM `user_settings`";
		}
		else
		{			
			$sql = "SELECT {$p} FROM `user_settings` WHERE ".SQLUtil::parseCondition($condition);
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
			$tb = new SysUserSettings();			
			if (isset($row['uin'])) $tb->uin = $row['uin'];
			if (isset($row['settings'])) $tb->settings = $row['settings'];
		
			$result[] = $tb;
		}
		
		return $result;
	}	
	
	public static function insertSqlHeader($fields=NULL)
	{
		$result = array();				
		if(!empty($fields)){
			$where = SQLUtil::parseFields($fields);			
			$result[0] = "INSERT INTO `user_settings` ({$where}) VALUES ";	
			$ar = array();
			foreach($fields as $key){
				$ar[$key]=1;
			}
			$result[1] = $ar;
		}else{
			$result[0]="INSERT INTO `user_settings` (`uin`,`settings`) VALUES ";
			$result[1] = array('uin'=>1,'settings'=>1);
		}				
		return $result;
	}
		
	public function  loaded( $fields=NULL,$condition=NULL)
	{

		if (empty($condition) && empty($this->uin))
		{
			return false;
		}
		
		$p = "*";
		$where = "`uin` = '{$this->uin}'";
		
		if(!empty($fields))
		{
			$p = SQLUtil::parseFields($fields);			
		}
	    if (!empty($condition))
		{
			$where =SQLUtil::parseCondition($condition);
		}
		
		$sql = "SELECT {$p} FROM `user_settings` WHERE {$where}";

		MySQL::selectDefaultDb();
		$qr = MySQL::getInstance()->RunQuery($sql);
		$ar = MySQL::getInstance()->FetchArray($qr);
		
		if (!$ar || count($ar)==0)
		{
			return false;
		}
		
		if (isset($ar['uin'])) $this->uin = $ar['uin'];
		if (isset($ar['settings'])) $this->settings = $ar['settings'];
		
		
		$this->clean();
		
		return true;
	}
	
	
	public function  loadedCount( $fields=NULL,$condition=NULL)
	{
	
		if (empty($condition) && empty($this->uin))
		{
			return false;
		}
	
		$p = "*";
		$where = "`uin` = '{$this->uin}'";
	
		if(!empty($fields))
		{
			$p = SQLUtil::parseFields($fields);
		}
		if (!empty($condition))
		{
			$where =SQLUtil::parseCondition($condition);
		}
	
		$sql = "SELECT {$p} FROM `user_settings` WHERE {$where}";
	
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
    	
    	if (!isset($this->uin)){
    		$emptyFields = false;
    		$fields[] = 'uin';
    	}else{
    		$emptyCondition = false; 
    		$condition['uin']=$this->uin;
    	}
    	if (!isset($this->settings)){
    		$emptyFields = false;
    		$fields[] = 'settings';
    	}else{
    		$emptyCondition = false; 
    		$condition['settings']=$this->settings;
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
				
		if (empty($this->uin))
		{
			$this->uin = MySQL::getInstance()->GetInsertId();
		}		
		
		$this->clean();
		
		return true;	
		
	}
	
	public function save($condition=NULL)
	{
		if (empty($condition))
		{
			$uc = "`uin`='{$this->uin}'";
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
		
		$sql = "DELETE FROM `user_settings` WHERE ".SQLUtil::parseCondition($condition);
		
		$qr = MySQL::getInstance()->RunQuery($sql);
				
		return (boolean)$qr;
	}
	
	public function  delete()
	{
		if (!isset($this->uin))
		{
			return false;
		}
		
		$sql = "DELETE FROM `user_settings` WHERE `uin`='{$this->uin}'";
		
		MySQL::selectDefaultDb();
		$qr = MySQL::getInstance()->RunQuery($sql);
				
		return (boolean)$qr;
	}
	
	public function getInsertValue($fields)
	{
		$values = "(";		
		foreach($fields as $f => $k){
			if($f == 'uin'){
 				$values .= "'{$this->uin}',";
 			}else if($f == 'settings'){
 				$values .= "'{$this->settings}',";
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

		if (isset($this->uin))
		{
			$fields .= "`uin`,";
			$values .= "'{$this->uin}',";
		}
		if (isset($this->settings))
		{
			$fields .= "`settings`,";
			$values .= "'{$this->settings}',";
		}

		
		$fields .= ")";
		$values .= ")";
		
		$sql = "INSERT INTO `user_settings` ".$fields.$values;
		
		return str_replace(",)",")",$sql);
	}
	
	private function  getUpFields()
	{
		$update = "";
		
		if ($this->settings_status_field)
		{			
			if (!isset($this->settings))
			{
				$update .= ("`settings`=null,");
			}
			else
			{
				$update .= ("`settings`='{$this->settings}',");
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
		
		$sql = "UPDATE `user_settings` SET {$update} WHERE {$condition}";
		
		return $sql;
	}
	
	public function  add($fieldsValue,$condition=NULL)
	{				
		if (empty($condition))
		{
			$uc = "`uin`='{$this->uin}'";
		}
		else
		{			
			$uc = SQLUtil::parseCondition($condition);
		}
		
		$update = SQLUtil::parseASFieldValues($fieldsValue);
		
		$sql = "UPDATE `user_settings` SET {$update} WHERE {$uc}";
		
		MySQL::selectDefaultDb();
		$qr = MySQL::getInstance()->RunQuery($sql);
				
		return (boolean)$qr;
	}	
	
	public function sub($fieldsVal,$condition=NULL)
	{
		if (empty($condition))
		{
			$uc = "`uin`='{$this->uin}'";
		}
		else
		{			
			$uc = SQLUtil::parseCondition($condition);
		}
		
		$update = SQLUtil::parseASFieldValues($fieldsVal,false);
		
		$sql = "UPDATE `user_settings` SET {$update} WHERE {$uc}";
		
		MySQL::selectDefaultDb();
		$qr = MySQL::getInstance()->RunQuery($sql);
				
		return (boolean)$qr;
	}
	
	private function /*void*/ clean() 
	{
		$this->this_table_status_field = false;
		$this->uin_status_field = false;
		$this->settings_status_field = false;

	}
	
	public function /*string*/ getUin()
	{
		return $this->uin;
	}
	
	public function /*void*/ setUin(/*string*/ $uin)
	{
		$this->uin = SQLUtil::toSafeSQLString($uin);
		$this->uin_status_field = true;		
		$this->this_table_status_field = true;		
	}

	public function /*void*/ setUinNull()
	{
		$this->uin = null;
		$this->uin_status_field = true;		
		$this->this_table_status_field = true;
	}

	public function /*string*/ getSettings()
	{
		return $this->settings;
	}
	
	public function /*void*/ setSettings(/*string*/ $settings)
	{
		$this->settings = SQLUtil::toSafeSQLString($settings);
		$this->settings_status_field = true;		
		$this->this_table_status_field = true;		
	}

	public function /*void*/ setSettingsNull()
	{
		$this->settings = null;
		$this->settings_status_field = true;		
		$this->this_table_status_field = true;
	}

	
	public function /*string*/ toDebugString()
	{
		$dbg = "(";
		
		$dbg .= ("uin={$this->uin},");
		$dbg .= ("settings={$this->settings},");

		$dbg .= ")";
				
		return str_replace(",)",")",$dbg);
	}
}

?>
