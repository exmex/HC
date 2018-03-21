<?php
require_once ($GLOBALS ['GAME_ROOT'] . "CMySQL.php");
require_once ("SQLUtil.php");
/**
 *  [The generated files]
 */

class SysAdmin {
	
	private /*int*/ $admin_id; //PRIMARY KEY 
	private /*int*/ $admin_groups_id;
	private /*string*/ $admin_firstname;
	private /*string*/ $admin_lastname;
	private /*string*/ $admin_email_address;
	private /*string*/ $admin_password;
	private /*string*/ $admin_created;
	private /*string*/ $admin_modified;
	private /*string*/ $admin_logdate;
	private /*int*/ $admin_lognum;

	
	private $this_table_status_field = false;
	private $admin_id_status_field = false;
	private $admin_groups_id_status_field = false;
	private $admin_firstname_status_field = false;
	private $admin_lastname_status_field = false;
	private $admin_email_address_status_field = false;
	private $admin_password_status_field = false;
	private $admin_created_status_field = false;
	private $admin_modified_status_field = false;
	private $admin_logdate_status_field = false;
	private $admin_lognum_status_field = false;


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
			$sql = "SELECT {$p} FROM `admin`";
		}
		else
		{			
			$sql = "SELECT {$p} FROM `admin` WHERE ".SQLUtil::parseCondition($condition);
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
			$tb = new SysAdmin();			
			if (isset($row['admin_id'])) $tb->admin_id = intval($row['admin_id']);
			if (isset($row['admin_groups_id'])) $tb->admin_groups_id = intval($row['admin_groups_id']);
			if (isset($row['admin_firstname'])) $tb->admin_firstname = $row['admin_firstname'];
			if (isset($row['admin_lastname'])) $tb->admin_lastname = $row['admin_lastname'];
			if (isset($row['admin_email_address'])) $tb->admin_email_address = $row['admin_email_address'];
			if (isset($row['admin_password'])) $tb->admin_password = $row['admin_password'];
			if (isset($row['admin_created'])) $tb->admin_created = $row['admin_created'];
			if (isset($row['admin_modified'])) $tb->admin_modified = $row['admin_modified'];
			if (isset($row['admin_logdate'])) $tb->admin_logdate = $row['admin_logdate'];
			if (isset($row['admin_lognum'])) $tb->admin_lognum = intval($row['admin_lognum']);
		
			$result[] = $tb;
		}
		
		return $result;
	}	
	
	public static function insertSqlHeader($fields=NULL)
	{
		$result = array();				
		if(!empty($fields)){
			$where = SQLUtil::parseFields($fields);			
			$result[0] = "INSERT INTO `admin` ({$where}) VALUES ";	
			$ar = array();
			foreach($fields as $key){
				$ar[$key]=1;
			}
			$result[1] = $ar;
		}else{
			$result[0]="INSERT INTO `admin` (`admin_id`,`admin_groups_id`,`admin_firstname`,`admin_lastname`,`admin_email_address`,`admin_password`,`admin_created`,`admin_modified`,`admin_logdate`,`admin_lognum`) VALUES ";
			$result[1] = array('admin_id'=>1,'admin_groups_id'=>1,'admin_firstname'=>1,'admin_lastname'=>1,'admin_email_address'=>1,'admin_password'=>1,'admin_created'=>1,'admin_modified'=>1,'admin_logdate'=>1,'admin_lognum'=>1);
		}				
		return $result;
	}
		
	public function  loaded( $fields=NULL,$condition=NULL)
	{

		if (empty($condition) && empty($this->admin_id))
		{
			return false;
		}
		
		$p = "*";
		$where = "`admin_id` = '{$this->admin_id}'";
		
		if(!empty($fields))
		{
			$p = SQLUtil::parseFields($fields);			
		}
	    if (!empty($condition))
		{
			$where =SQLUtil::parseCondition($condition);
		}
		
		$sql = "SELECT {$p} FROM `admin` WHERE {$where}";

		MySQL::selectDefaultDb();
		$qr = MySQL::getInstance()->RunQuery($sql);
		$ar = MySQL::getInstance()->FetchArray($qr);
		
		if (!$ar || count($ar)==0)
		{
			return false;
		}
		
		if (isset($ar['admin_id'])) $this->admin_id = intval($ar['admin_id']);
		if (isset($ar['admin_groups_id'])) $this->admin_groups_id = intval($ar['admin_groups_id']);
		if (isset($ar['admin_firstname'])) $this->admin_firstname = $ar['admin_firstname'];
		if (isset($ar['admin_lastname'])) $this->admin_lastname = $ar['admin_lastname'];
		if (isset($ar['admin_email_address'])) $this->admin_email_address = $ar['admin_email_address'];
		if (isset($ar['admin_password'])) $this->admin_password = $ar['admin_password'];
		if (isset($ar['admin_created'])) $this->admin_created = $ar['admin_created'];
		if (isset($ar['admin_modified'])) $this->admin_modified = $ar['admin_modified'];
		if (isset($ar['admin_logdate'])) $this->admin_logdate = $ar['admin_logdate'];
		if (isset($ar['admin_lognum'])) $this->admin_lognum = intval($ar['admin_lognum']);
		
		
		$this->clean();
		
		return true;
	}
	
	
	public function  loadedCount( $fields=NULL,$condition=NULL)
	{
	
		if (empty($condition) && empty($this->admin_id))
		{
			return false;
		}
	
		$p = "*";
		$where = "`admin_id` = '{$this->admin_id}'";
	
		if(!empty($fields))
		{
			$p = SQLUtil::parseFields($fields);
		}
		if (!empty($condition))
		{
			$where =SQLUtil::parseCondition($condition);
		}
	
		$sql = "SELECT {$p} FROM `admin` WHERE {$where}";
	
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
    	
    	if (!isset($this->admin_id)){
    		$emptyFields = false;
    		$fields[] = 'admin_id';
    	}else{
    		$emptyCondition = false; 
    		$condition['admin_id']=$this->admin_id;
    	}
    	if (!isset($this->admin_groups_id)){
    		$emptyFields = false;
    		$fields[] = 'admin_groups_id';
    	}else{
    		$emptyCondition = false; 
    		$condition['admin_groups_id']=$this->admin_groups_id;
    	}
    	if (!isset($this->admin_firstname)){
    		$emptyFields = false;
    		$fields[] = 'admin_firstname';
    	}else{
    		$emptyCondition = false; 
    		$condition['admin_firstname']=$this->admin_firstname;
    	}
    	if (!isset($this->admin_lastname)){
    		$emptyFields = false;
    		$fields[] = 'admin_lastname';
    	}else{
    		$emptyCondition = false; 
    		$condition['admin_lastname']=$this->admin_lastname;
    	}
    	if (!isset($this->admin_email_address)){
    		$emptyFields = false;
    		$fields[] = 'admin_email_address';
    	}else{
    		$emptyCondition = false; 
    		$condition['admin_email_address']=$this->admin_email_address;
    	}
    	if (!isset($this->admin_password)){
    		$emptyFields = false;
    		$fields[] = 'admin_password';
    	}else{
    		$emptyCondition = false; 
    		$condition['admin_password']=$this->admin_password;
    	}
    	if (!isset($this->admin_created)){
    		$emptyFields = false;
    		$fields[] = 'admin_created';
    	}else{
    		$emptyCondition = false; 
    		$condition['admin_created']=$this->admin_created;
    	}
    	if (!isset($this->admin_modified)){
    		$emptyFields = false;
    		$fields[] = 'admin_modified';
    	}else{
    		$emptyCondition = false; 
    		$condition['admin_modified']=$this->admin_modified;
    	}
    	if (!isset($this->admin_logdate)){
    		$emptyFields = false;
    		$fields[] = 'admin_logdate';
    	}else{
    		$emptyCondition = false; 
    		$condition['admin_logdate']=$this->admin_logdate;
    	}
    	if (!isset($this->admin_lognum)){
    		$emptyFields = false;
    		$fields[] = 'admin_lognum';
    	}else{
    		$emptyCondition = false; 
    		$condition['admin_lognum']=$this->admin_lognum;
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
				
		if (empty($this->admin_id))
		{
			$this->admin_id = MySQL::getInstance()->GetInsertId();
		}		
		
		$this->clean();
		
		return true;	
		
	}
	
	public function save($condition=NULL)
	{
		if (empty($condition))
		{
			$uc = "`admin_id`='{$this->admin_id}'";
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
		
		$sql = "DELETE FROM `admin` WHERE ".SQLUtil::parseCondition($condition);
		
		$qr = MySQL::getInstance()->RunQuery($sql);
				
		return (boolean)$qr;
	}
	
	public function  delete()
	{
		if (!isset($this->admin_id))
		{
			return false;
		}
		
		$sql = "DELETE FROM `admin` WHERE `admin_id`='{$this->admin_id}'";
		
		MySQL::selectDefaultDb();
		$qr = MySQL::getInstance()->RunQuery($sql);
				
		return (boolean)$qr;
	}
	
	public function getInsertValue($fields)
	{
		$values = "(";		
		foreach($fields as $f => $k){
			if($f == 'admin_id'){
 				$values .= "'{$this->admin_id}',";
 			}else if($f == 'admin_groups_id'){
 				$values .= "'{$this->admin_groups_id}',";
 			}else if($f == 'admin_firstname'){
 				$values .= "'{$this->admin_firstname}',";
 			}else if($f == 'admin_lastname'){
 				$values .= "'{$this->admin_lastname}',";
 			}else if($f == 'admin_email_address'){
 				$values .= "'{$this->admin_email_address}',";
 			}else if($f == 'admin_password'){
 				$values .= "'{$this->admin_password}',";
 			}else if($f == 'admin_created'){
 				$values .= "'{$this->admin_created}',";
 			}else if($f == 'admin_modified'){
 				$values .= "'{$this->admin_modified}',";
 			}else if($f == 'admin_logdate'){
 				$values .= "'{$this->admin_logdate}',";
 			}else if($f == 'admin_lognum'){
 				$values .= "'{$this->admin_lognum}',";
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

		if (isset($this->admin_id))
		{
			$fields .= "`admin_id`,";
			$values .= "'{$this->admin_id}',";
		}
		if (isset($this->admin_groups_id))
		{
			$fields .= "`admin_groups_id`,";
			$values .= "'{$this->admin_groups_id}',";
		}
		if (isset($this->admin_firstname))
		{
			$fields .= "`admin_firstname`,";
			$values .= "'{$this->admin_firstname}',";
		}
		if (isset($this->admin_lastname))
		{
			$fields .= "`admin_lastname`,";
			$values .= "'{$this->admin_lastname}',";
		}
		if (isset($this->admin_email_address))
		{
			$fields .= "`admin_email_address`,";
			$values .= "'{$this->admin_email_address}',";
		}
		if (isset($this->admin_password))
		{
			$fields .= "`admin_password`,";
			$values .= "'{$this->admin_password}',";
		}
		if (isset($this->admin_created))
		{
			$fields .= "`admin_created`,";
			$values .= "'{$this->admin_created}',";
		}
		if (isset($this->admin_modified))
		{
			$fields .= "`admin_modified`,";
			$values .= "'{$this->admin_modified}',";
		}
		if (isset($this->admin_logdate))
		{
			$fields .= "`admin_logdate`,";
			$values .= "'{$this->admin_logdate}',";
		}
		if (isset($this->admin_lognum))
		{
			$fields .= "`admin_lognum`,";
			$values .= "'{$this->admin_lognum}',";
		}

		
		$fields .= ")";
		$values .= ")";
		
		$sql = "INSERT INTO `admin` ".$fields.$values;
		
		return str_replace(",)",")",$sql);
	}
	
	private function  getUpFields()
	{
		$update = "";
		
		if ($this->admin_groups_id_status_field)
		{			
			if (!isset($this->admin_groups_id))
			{
				$update .= ("`admin_groups_id`=null,");
			}
			else
			{
				$update .= ("`admin_groups_id`='{$this->admin_groups_id}',");
			}
		}
		if ($this->admin_firstname_status_field)
		{			
			if (!isset($this->admin_firstname))
			{
				$update .= ("`admin_firstname`=null,");
			}
			else
			{
				$update .= ("`admin_firstname`='{$this->admin_firstname}',");
			}
		}
		if ($this->admin_lastname_status_field)
		{			
			if (!isset($this->admin_lastname))
			{
				$update .= ("`admin_lastname`=null,");
			}
			else
			{
				$update .= ("`admin_lastname`='{$this->admin_lastname}',");
			}
		}
		if ($this->admin_email_address_status_field)
		{			
			if (!isset($this->admin_email_address))
			{
				$update .= ("`admin_email_address`=null,");
			}
			else
			{
				$update .= ("`admin_email_address`='{$this->admin_email_address}',");
			}
		}
		if ($this->admin_password_status_field)
		{			
			if (!isset($this->admin_password))
			{
				$update .= ("`admin_password`=null,");
			}
			else
			{
				$update .= ("`admin_password`='{$this->admin_password}',");
			}
		}
		if ($this->admin_created_status_field)
		{			
			if (!isset($this->admin_created))
			{
				$update .= ("`admin_created`=null,");
			}
			else
			{
				$update .= ("`admin_created`='{$this->admin_created}',");
			}
		}
		if ($this->admin_modified_status_field)
		{			
			if (!isset($this->admin_modified))
			{
				$update .= ("`admin_modified`=null,");
			}
			else
			{
				$update .= ("`admin_modified`='{$this->admin_modified}',");
			}
		}
		if ($this->admin_logdate_status_field)
		{			
			if (!isset($this->admin_logdate))
			{
				$update .= ("`admin_logdate`=null,");
			}
			else
			{
				$update .= ("`admin_logdate`='{$this->admin_logdate}',");
			}
		}
		if ($this->admin_lognum_status_field)
		{			
			if (!isset($this->admin_lognum))
			{
				$update .= ("`admin_lognum`=null,");
			}
			else
			{
				$update .= ("`admin_lognum`='{$this->admin_lognum}',");
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
		
		$sql = "UPDATE `admin` SET {$update} WHERE {$condition}";
		
		return $sql;
	}
	
	public function  add($fieldsValue,$condition=NULL)
	{				
		if (empty($condition))
		{
			$uc = "`admin_id`='{$this->admin_id}'";
		}
		else
		{			
			$uc = SQLUtil::parseCondition($condition);
		}
		
		$update = SQLUtil::parseASFieldValues($fieldsValue);
		
		$sql = "UPDATE `admin` SET {$update} WHERE {$uc}";
		
		MySQL::selectDefaultDb();
		$qr = MySQL::getInstance()->RunQuery($sql);
				
		return (boolean)$qr;
	}	
	
	public function sub($fieldsVal,$condition=NULL)
	{
		if (empty($condition))
		{
			$uc = "`admin_id`='{$this->admin_id}'";
		}
		else
		{			
			$uc = SQLUtil::parseCondition($condition);
		}
		
		$update = SQLUtil::parseASFieldValues($fieldsVal,false);
		
		$sql = "UPDATE `admin` SET {$update} WHERE {$uc}";
		
		MySQL::selectDefaultDb();
		$qr = MySQL::getInstance()->RunQuery($sql);
				
		return (boolean)$qr;
	}
	
	private function /*void*/ clean() 
	{
		$this->this_table_status_field = false;
		$this->admin_id_status_field = false;
		$this->admin_groups_id_status_field = false;
		$this->admin_firstname_status_field = false;
		$this->admin_lastname_status_field = false;
		$this->admin_email_address_status_field = false;
		$this->admin_password_status_field = false;
		$this->admin_created_status_field = false;
		$this->admin_modified_status_field = false;
		$this->admin_logdate_status_field = false;
		$this->admin_lognum_status_field = false;

	}
	
	public function /*int*/ getAdminId()
	{
		return $this->admin_id;
	}
	
	public function /*void*/ setAdminId(/*int*/ $admin_id)
	{
		$this->admin_id = intval($admin_id);
		$this->admin_id_status_field = true;		
		$this->this_table_status_field = true;		
	}

	public function /*void*/ setAdminIdNull()
	{
		$this->admin_id = null;
		$this->admin_id_status_field = true;		
		$this->this_table_status_field = true;
	}

	public function /*int*/ getAdminGroupsId()
	{
		return $this->admin_groups_id;
	}
	
	public function /*void*/ setAdminGroupsId(/*int*/ $admin_groups_id)
	{
		$this->admin_groups_id = intval($admin_groups_id);
		$this->admin_groups_id_status_field = true;		
		$this->this_table_status_field = true;		
	}

	public function /*void*/ setAdminGroupsIdNull()
	{
		$this->admin_groups_id = null;
		$this->admin_groups_id_status_field = true;		
		$this->this_table_status_field = true;
	}

	public function /*string*/ getAdminFirstname()
	{
		return $this->admin_firstname;
	}
	
	public function /*void*/ setAdminFirstname(/*string*/ $admin_firstname)
	{
		$this->admin_firstname = SQLUtil::toSafeSQLString($admin_firstname);
		$this->admin_firstname_status_field = true;		
		$this->this_table_status_field = true;		
	}

	public function /*void*/ setAdminFirstnameNull()
	{
		$this->admin_firstname = null;
		$this->admin_firstname_status_field = true;		
		$this->this_table_status_field = true;
	}

	public function /*string*/ getAdminLastname()
	{
		return $this->admin_lastname;
	}
	
	public function /*void*/ setAdminLastname(/*string*/ $admin_lastname)
	{
		$this->admin_lastname = SQLUtil::toSafeSQLString($admin_lastname);
		$this->admin_lastname_status_field = true;		
		$this->this_table_status_field = true;		
	}

	public function /*void*/ setAdminLastnameNull()
	{
		$this->admin_lastname = null;
		$this->admin_lastname_status_field = true;		
		$this->this_table_status_field = true;
	}

	public function /*string*/ getAdminEmailAddress()
	{
		return $this->admin_email_address;
	}
	
	public function /*void*/ setAdminEmailAddress(/*string*/ $admin_email_address)
	{
		$this->admin_email_address = SQLUtil::toSafeSQLString($admin_email_address);
		$this->admin_email_address_status_field = true;		
		$this->this_table_status_field = true;		
	}

	public function /*void*/ setAdminEmailAddressNull()
	{
		$this->admin_email_address = null;
		$this->admin_email_address_status_field = true;		
		$this->this_table_status_field = true;
	}

	public function /*string*/ getAdminPassword()
	{
		return $this->admin_password;
	}
	
	public function /*void*/ setAdminPassword(/*string*/ $admin_password)
	{
		$this->admin_password = SQLUtil::toSafeSQLString($admin_password);
		$this->admin_password_status_field = true;		
		$this->this_table_status_field = true;		
	}

	public function /*void*/ setAdminPasswordNull()
	{
		$this->admin_password = null;
		$this->admin_password_status_field = true;		
		$this->this_table_status_field = true;
	}

	public function /*string*/ getAdminCreated()
	{
		return $this->admin_created;
	}
	
	public function /*void*/ setAdminCreated(/*string*/ $admin_created)
	{
		$this->admin_created = SQLUtil::toSafeSQLString($admin_created);
		$this->admin_created_status_field = true;		
		$this->this_table_status_field = true;		
	}

	public function /*void*/ setAdminCreatedNull()
	{
		$this->admin_created = null;
		$this->admin_created_status_field = true;		
		$this->this_table_status_field = true;
	}

	public function /*string*/ getAdminModified()
	{
		return $this->admin_modified;
	}
	
	public function /*void*/ setAdminModified(/*string*/ $admin_modified)
	{
		$this->admin_modified = SQLUtil::toSafeSQLString($admin_modified);
		$this->admin_modified_status_field = true;		
		$this->this_table_status_field = true;		
	}

	public function /*void*/ setAdminModifiedNull()
	{
		$this->admin_modified = null;
		$this->admin_modified_status_field = true;		
		$this->this_table_status_field = true;
	}

	public function /*string*/ getAdminLogdate()
	{
		return $this->admin_logdate;
	}
	
	public function /*void*/ setAdminLogdate(/*string*/ $admin_logdate)
	{
		$this->admin_logdate = SQLUtil::toSafeSQLString($admin_logdate);
		$this->admin_logdate_status_field = true;		
		$this->this_table_status_field = true;		
	}

	public function /*void*/ setAdminLogdateNull()
	{
		$this->admin_logdate = null;
		$this->admin_logdate_status_field = true;		
		$this->this_table_status_field = true;
	}

	public function /*int*/ getAdminLognum()
	{
		return $this->admin_lognum;
	}
	
	public function /*void*/ setAdminLognum(/*int*/ $admin_lognum)
	{
		$this->admin_lognum = intval($admin_lognum);
		$this->admin_lognum_status_field = true;		
		$this->this_table_status_field = true;		
	}

	public function /*void*/ setAdminLognumNull()
	{
		$this->admin_lognum = null;
		$this->admin_lognum_status_field = true;		
		$this->this_table_status_field = true;
	}

	
	public function /*string*/ toDebugString()
	{
		$dbg = "(";
		
		$dbg .= ("admin_id={$this->admin_id},");
		$dbg .= ("admin_groups_id={$this->admin_groups_id},");
		$dbg .= ("admin_firstname={$this->admin_firstname},");
		$dbg .= ("admin_lastname={$this->admin_lastname},");
		$dbg .= ("admin_email_address={$this->admin_email_address},");
		$dbg .= ("admin_password={$this->admin_password},");
		$dbg .= ("admin_created={$this->admin_created},");
		$dbg .= ("admin_modified={$this->admin_modified},");
		$dbg .= ("admin_logdate={$this->admin_logdate},");
		$dbg .= ("admin_lognum={$this->admin_lognum},");

		$dbg .= ")";
				
		return str_replace(",)",")",$dbg);
	}
}

?>
