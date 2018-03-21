<?php
require_once ($GLOBALS ['GAME_ROOT'] . "CMySQL.php");
require_once ("SQLUtil.php");
/**
 *  [The generated files]
 */

class SysClientPatchLog {
	
	private /*string*/ $id; //PRIMARY KEY 
	private /*string*/ $version;
	private /*string*/ $filename;
	private /*string*/ $hash;
	private /*string*/ $update_time;
	private /*string*/ $svn_version;
	private /*int*/ $active;
	private /*string*/ $binary_version;
	private /*string*/ $raw_filename;
	private /*string*/ $size;

	
	private $this_table_status_field = false;
	private $id_status_field = false;
	private $version_status_field = false;
	private $filename_status_field = false;
	private $hash_status_field = false;
	private $update_time_status_field = false;
	private $svn_version_status_field = false;
	private $active_status_field = false;
	private $binary_version_status_field = false;
	private $raw_filename_status_field = false;
	private $size_status_field = false;


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
			$sql = "SELECT {$p} FROM `client_patch_log`";
		}
		else
		{			
			$sql = "SELECT {$p} FROM `client_patch_log` WHERE ".SQLUtil::parseCondition($condition);
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
			$tb = new SysClientPatchLog();			
			if (isset($row['id'])) $tb->id = $row['id'];
			if (isset($row['version'])) $tb->version = $row['version'];
			if (isset($row['filename'])) $tb->filename = $row['filename'];
			if (isset($row['hash'])) $tb->hash = $row['hash'];
			if (isset($row['update_time'])) $tb->update_time = $row['update_time'];
			if (isset($row['svn_version'])) $tb->svn_version = $row['svn_version'];
			if (isset($row['active'])) $tb->active = intval($row['active']);
			if (isset($row['binary_version'])) $tb->binary_version = $row['binary_version'];
			if (isset($row['raw_filename'])) $tb->raw_filename = $row['raw_filename'];
			if (isset($row['size'])) $tb->size = $row['size'];
		
			$result[] = $tb;
		}
		
		return $result;
	}	
	
	public static function insertSqlHeader($fields=NULL)
	{
		$result = array();				
		if(!empty($fields)){
			$where = SQLUtil::parseFields($fields);			
			$result[0] = "INSERT INTO `client_patch_log` ({$where}) VALUES ";	
			$ar = array();
			foreach($fields as $key){
				$ar[$key]=1;
			}
			$result[1] = $ar;
		}else{
			$result[0]="INSERT INTO `client_patch_log` (`id`,`version`,`filename`,`hash`,`update_time`,`svn_version`,`active`,`binary_version`,`raw_filename`,`size`) VALUES ";
			$result[1] = array('id'=>1,'version'=>1,'filename'=>1,'hash'=>1,'update_time'=>1,'svn_version'=>1,'active'=>1,'binary_version'=>1,'raw_filename'=>1,'size'=>1);
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
		
		$sql = "SELECT {$p} FROM `client_patch_log` WHERE {$where}";

		MySQL::selectDefaultDb();
		$qr = MySQL::getInstance()->RunQuery($sql);
		$ar = MySQL::getInstance()->FetchArray($qr);
		
		if (!$ar || count($ar)==0)
		{
			return false;
		}
		
		if (isset($ar['id'])) $this->id = $ar['id'];
		if (isset($ar['version'])) $this->version = $ar['version'];
		if (isset($ar['filename'])) $this->filename = $ar['filename'];
		if (isset($ar['hash'])) $this->hash = $ar['hash'];
		if (isset($ar['update_time'])) $this->update_time = $ar['update_time'];
		if (isset($ar['svn_version'])) $this->svn_version = $ar['svn_version'];
		if (isset($ar['active'])) $this->active = intval($ar['active']);
		if (isset($ar['binary_version'])) $this->binary_version = $ar['binary_version'];
		if (isset($ar['raw_filename'])) $this->raw_filename = $ar['raw_filename'];
		if (isset($ar['size'])) $this->size = $ar['size'];
		
		
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
	
		$sql = "SELECT {$p} FROM `client_patch_log` WHERE {$where}";
	
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
    	if (!isset($this->version)){
    		$emptyFields = false;
    		$fields[] = 'version';
    	}else{
    		$emptyCondition = false; 
    		$condition['version']=$this->version;
    	}
    	if (!isset($this->filename)){
    		$emptyFields = false;
    		$fields[] = 'filename';
    	}else{
    		$emptyCondition = false; 
    		$condition['filename']=$this->filename;
    	}
    	if (!isset($this->hash)){
    		$emptyFields = false;
    		$fields[] = 'hash';
    	}else{
    		$emptyCondition = false; 
    		$condition['hash']=$this->hash;
    	}
    	if (!isset($this->update_time)){
    		$emptyFields = false;
    		$fields[] = 'update_time';
    	}else{
    		$emptyCondition = false; 
    		$condition['update_time']=$this->update_time;
    	}
    	if (!isset($this->svn_version)){
    		$emptyFields = false;
    		$fields[] = 'svn_version';
    	}else{
    		$emptyCondition = false; 
    		$condition['svn_version']=$this->svn_version;
    	}
    	if (!isset($this->active)){
    		$emptyFields = false;
    		$fields[] = 'active';
    	}else{
    		$emptyCondition = false; 
    		$condition['active']=$this->active;
    	}
    	if (!isset($this->binary_version)){
    		$emptyFields = false;
    		$fields[] = 'binary_version';
    	}else{
    		$emptyCondition = false; 
    		$condition['binary_version']=$this->binary_version;
    	}
    	if (!isset($this->raw_filename)){
    		$emptyFields = false;
    		$fields[] = 'raw_filename';
    	}else{
    		$emptyCondition = false; 
    		$condition['raw_filename']=$this->raw_filename;
    	}
    	if (!isset($this->size)){
    		$emptyFields = false;
    		$fields[] = 'size';
    	}else{
    		$emptyCondition = false; 
    		$condition['size']=$this->size;
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
		
		$sql = "DELETE FROM `client_patch_log` WHERE ".SQLUtil::parseCondition($condition);
		
		$qr = MySQL::getInstance()->RunQuery($sql);
				
		return (boolean)$qr;
	}
	
	public function  delete()
	{
		if (!isset($this->id))
		{
			return false;
		}
		
		$sql = "DELETE FROM `client_patch_log` WHERE `id`='{$this->id}'";
		
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
 			}else if($f == 'version'){
 				$values .= "'{$this->version}',";
 			}else if($f == 'filename'){
 				$values .= "'{$this->filename}',";
 			}else if($f == 'hash'){
 				$values .= "'{$this->hash}',";
 			}else if($f == 'update_time'){
 				$values .= "'{$this->update_time}',";
 			}else if($f == 'svn_version'){
 				$values .= "'{$this->svn_version}',";
 			}else if($f == 'active'){
 				$values .= "'{$this->active}',";
 			}else if($f == 'binary_version'){
 				$values .= "'{$this->binary_version}',";
 			}else if($f == 'raw_filename'){
 				$values .= "'{$this->raw_filename}',";
 			}else if($f == 'size'){
 				$values .= "'{$this->size}',";
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
		if (isset($this->version))
		{
			$fields .= "`version`,";
			$values .= "'{$this->version}',";
		}
		if (isset($this->filename))
		{
			$fields .= "`filename`,";
			$values .= "'{$this->filename}',";
		}
		if (isset($this->hash))
		{
			$fields .= "`hash`,";
			$values .= "'{$this->hash}',";
		}
		if (isset($this->update_time))
		{
			$fields .= "`update_time`,";
			$values .= "'{$this->update_time}',";
		}
		if (isset($this->svn_version))
		{
			$fields .= "`svn_version`,";
			$values .= "'{$this->svn_version}',";
		}
		if (isset($this->active))
		{
			$fields .= "`active`,";
			$values .= "'{$this->active}',";
		}
		if (isset($this->binary_version))
		{
			$fields .= "`binary_version`,";
			$values .= "'{$this->binary_version}',";
		}
		if (isset($this->raw_filename))
		{
			$fields .= "`raw_filename`,";
			$values .= "'{$this->raw_filename}',";
		}
		if (isset($this->size))
		{
			$fields .= "`size`,";
			$values .= "'{$this->size}',";
		}

		
		$fields .= ")";
		$values .= ")";
		
		$sql = "INSERT INTO `client_patch_log` ".$fields.$values;
		
		return str_replace(",)",")",$sql);
	}
	
	private function  getUpFields()
	{
		$update = "";
		
		if ($this->version_status_field)
		{			
			if (!isset($this->version))
			{
				$update .= ("`version`=null,");
			}
			else
			{
				$update .= ("`version`='{$this->version}',");
			}
		}
		if ($this->filename_status_field)
		{			
			if (!isset($this->filename))
			{
				$update .= ("`filename`=null,");
			}
			else
			{
				$update .= ("`filename`='{$this->filename}',");
			}
		}
		if ($this->hash_status_field)
		{			
			if (!isset($this->hash))
			{
				$update .= ("`hash`=null,");
			}
			else
			{
				$update .= ("`hash`='{$this->hash}',");
			}
		}
		if ($this->update_time_status_field)
		{			
			if (!isset($this->update_time))
			{
				$update .= ("`update_time`=null,");
			}
			else
			{
				$update .= ("`update_time`='{$this->update_time}',");
			}
		}
		if ($this->svn_version_status_field)
		{			
			if (!isset($this->svn_version))
			{
				$update .= ("`svn_version`=null,");
			}
			else
			{
				$update .= ("`svn_version`='{$this->svn_version}',");
			}
		}
		if ($this->active_status_field)
		{			
			if (!isset($this->active))
			{
				$update .= ("`active`=null,");
			}
			else
			{
				$update .= ("`active`='{$this->active}',");
			}
		}
		if ($this->binary_version_status_field)
		{			
			if (!isset($this->binary_version))
			{
				$update .= ("`binary_version`=null,");
			}
			else
			{
				$update .= ("`binary_version`='{$this->binary_version}',");
			}
		}
		if ($this->raw_filename_status_field)
		{			
			if (!isset($this->raw_filename))
			{
				$update .= ("`raw_filename`=null,");
			}
			else
			{
				$update .= ("`raw_filename`='{$this->raw_filename}',");
			}
		}
		if ($this->size_status_field)
		{			
			if (!isset($this->size))
			{
				$update .= ("`size`=null,");
			}
			else
			{
				$update .= ("`size`='{$this->size}',");
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
		
		$sql = "UPDATE `client_patch_log` SET {$update} WHERE {$condition}";
		
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
		
		$sql = "UPDATE `client_patch_log` SET {$update} WHERE {$uc}";
		
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
		
		$sql = "UPDATE `client_patch_log` SET {$update} WHERE {$uc}";
		
		MySQL::selectDefaultDb();
		$qr = MySQL::getInstance()->RunQuery($sql);
				
		return (boolean)$qr;
	}
	
	private function /*void*/ clean() 
	{
		$this->this_table_status_field = false;
		$this->id_status_field = false;
		$this->version_status_field = false;
		$this->filename_status_field = false;
		$this->hash_status_field = false;
		$this->update_time_status_field = false;
		$this->svn_version_status_field = false;
		$this->active_status_field = false;
		$this->binary_version_status_field = false;
		$this->raw_filename_status_field = false;
		$this->size_status_field = false;

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

	public function /*string*/ getVersion()
	{
		return $this->version;
	}
	
	public function /*void*/ setVersion(/*string*/ $version)
	{
		$this->version = SQLUtil::toSafeSQLString($version);
		$this->version_status_field = true;		
		$this->this_table_status_field = true;		
	}

	public function /*void*/ setVersionNull()
	{
		$this->version = null;
		$this->version_status_field = true;		
		$this->this_table_status_field = true;
	}

	public function /*string*/ getFilename()
	{
		return $this->filename;
	}
	
	public function /*void*/ setFilename(/*string*/ $filename)
	{
		$this->filename = SQLUtil::toSafeSQLString($filename);
		$this->filename_status_field = true;		
		$this->this_table_status_field = true;		
	}

	public function /*void*/ setFilenameNull()
	{
		$this->filename = null;
		$this->filename_status_field = true;		
		$this->this_table_status_field = true;
	}

	public function /*string*/ getHash()
	{
		return $this->hash;
	}
	
	public function /*void*/ setHash(/*string*/ $hash)
	{
		$this->hash = SQLUtil::toSafeSQLString($hash);
		$this->hash_status_field = true;		
		$this->this_table_status_field = true;		
	}

	public function /*void*/ setHashNull()
	{
		$this->hash = null;
		$this->hash_status_field = true;		
		$this->this_table_status_field = true;
	}

	public function /*string*/ getUpdateTime()
	{
		return $this->update_time;
	}
	
	public function /*void*/ setUpdateTime(/*string*/ $update_time)
	{
		$this->update_time = SQLUtil::toSafeSQLString($update_time);
		$this->update_time_status_field = true;		
		$this->this_table_status_field = true;		
	}

	public function /*void*/ setUpdateTimeNull()
	{
		$this->update_time = null;
		$this->update_time_status_field = true;		
		$this->this_table_status_field = true;
	}

	public function /*string*/ getSvnVersion()
	{
		return $this->svn_version;
	}
	
	public function /*void*/ setSvnVersion(/*string*/ $svn_version)
	{
		$this->svn_version = SQLUtil::toSafeSQLString($svn_version);
		$this->svn_version_status_field = true;		
		$this->this_table_status_field = true;		
	}

	public function /*void*/ setSvnVersionNull()
	{
		$this->svn_version = null;
		$this->svn_version_status_field = true;		
		$this->this_table_status_field = true;
	}

	public function /*int*/ getActive()
	{
		return $this->active;
	}
	
	public function /*void*/ setActive(/*int*/ $active)
	{
		$this->active = intval($active);
		$this->active_status_field = true;		
		$this->this_table_status_field = true;		
	}

	public function /*void*/ setActiveNull()
	{
		$this->active = null;
		$this->active_status_field = true;		
		$this->this_table_status_field = true;
	}

	public function /*string*/ getBinaryVersion()
	{
		return $this->binary_version;
	}
	
	public function /*void*/ setBinaryVersion(/*string*/ $binary_version)
	{
		$this->binary_version = SQLUtil::toSafeSQLString($binary_version);
		$this->binary_version_status_field = true;		
		$this->this_table_status_field = true;		
	}

	public function /*void*/ setBinaryVersionNull()
	{
		$this->binary_version = null;
		$this->binary_version_status_field = true;		
		$this->this_table_status_field = true;
	}

	public function /*string*/ getRawFilename()
	{
		return $this->raw_filename;
	}
	
	public function /*void*/ setRawFilename(/*string*/ $raw_filename)
	{
		$this->raw_filename = SQLUtil::toSafeSQLString($raw_filename);
		$this->raw_filename_status_field = true;		
		$this->this_table_status_field = true;		
	}

	public function /*void*/ setRawFilenameNull()
	{
		$this->raw_filename = null;
		$this->raw_filename_status_field = true;		
		$this->this_table_status_field = true;
	}

	public function /*string*/ getSize()
	{
		return $this->size;
	}
	
	public function /*void*/ setSize(/*string*/ $size)
	{
		$this->size = SQLUtil::toSafeSQLString($size);
		$this->size_status_field = true;		
		$this->this_table_status_field = true;		
	}

	public function /*void*/ setSizeNull()
	{
		$this->size = null;
		$this->size_status_field = true;		
		$this->this_table_status_field = true;
	}

	
	public function /*string*/ toDebugString()
	{
		$dbg = "(";
		
		$dbg .= ("id={$this->id},");
		$dbg .= ("version={$this->version},");
		$dbg .= ("filename={$this->filename},");
		$dbg .= ("hash={$this->hash},");
		$dbg .= ("update_time={$this->update_time},");
		$dbg .= ("svn_version={$this->svn_version},");
		$dbg .= ("active={$this->active},");
		$dbg .= ("binary_version={$this->binary_version},");
		$dbg .= ("raw_filename={$this->raw_filename},");
		$dbg .= ("size={$this->size},");

		$dbg .= ")";
				
		return str_replace(",)",")",$dbg);
	}
}

?>
