<?php
require_once ($GLOBALS ['GAME_ROOT'] . "CMySQL.php");
require_once ("SQLUtil.php");
/**
 *  [The generated files]
 */

class SysProductIdMap {
	
	private /*int*/ $product_id; //PRIMARY KEY ID in Recharge.lua
	private /*int*/ $ios_product_id; //Product ID seted in Apple Store
	private /*int*/ $android_product_id; //Product ID seted in Google Play Store
	private /*int*/ $add_time;
	private /*int*/ $update_time;

	
	private $this_table_status_field = false;
	private $product_id_status_field = false;
	private $ios_product_id_status_field = false;
	private $android_product_id_status_field = false;
	private $add_time_status_field = false;
	private $update_time_status_field = false;


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
			$sql = "SELECT {$p} FROM `product_id_map`";
		}
		else
		{			
			$sql = "SELECT {$p} FROM `product_id_map` WHERE ".SQLUtil::parseCondition($condition);
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
			$tb = new SysProductIdMap();			
			if (isset($row['product_id'])) $tb->product_id = intval($row['product_id']);
			if (isset($row['ios_product_id'])) $tb->ios_product_id = intval($row['ios_product_id']);
			if (isset($row['android_product_id'])) $tb->android_product_id = intval($row['android_product_id']);
			if (isset($row['add_time'])) $tb->add_time = intval($row['add_time']);
			if (isset($row['update_time'])) $tb->update_time = intval($row['update_time']);
		
			$result[] = $tb;
		}
		
		return $result;
	}	
	
	public static function insertSqlHeader($fields=NULL)
	{
		$result = array();				
		if(!empty($fields)){
			$where = SQLUtil::parseFields($fields);			
			$result[0] = "INSERT INTO `product_id_map` ({$where}) VALUES ";	
			$ar = array();
			foreach($fields as $key){
				$ar[$key]=1;
			}
			$result[1] = $ar;
		}else{
			$result[0]="INSERT INTO `product_id_map` (`product_id`,`ios_product_id`,`android_product_id`,`add_time`,`update_time`) VALUES ";
			$result[1] = array('product_id'=>1,'ios_product_id'=>1,'android_product_id'=>1,'add_time'=>1,'update_time'=>1);
		}				
		return $result;
	}
		
	public function  loaded( $fields=NULL,$condition=NULL)
	{

		if (empty($condition) && empty($this->product_id))
		{
			return false;
		}
		
		$p = "*";
		$where = "`product_id` = '{$this->product_id}'";
		
		if(!empty($fields))
		{
			$p = SQLUtil::parseFields($fields);			
		}
	    if (!empty($condition))
		{
			$where =SQLUtil::parseCondition($condition);
		}
		
		$sql = "SELECT {$p} FROM `product_id_map` WHERE {$where}";

		MySQL::selectDefaultDb();
		$qr = MySQL::getInstance()->RunQuery($sql);
		$ar = MySQL::getInstance()->FetchArray($qr);
		
		if (!$ar || count($ar)==0)
		{
			return false;
		}
		
		if (isset($ar['product_id'])) $this->product_id = intval($ar['product_id']);
		if (isset($ar['ios_product_id'])) $this->ios_product_id = intval($ar['ios_product_id']);
		if (isset($ar['android_product_id'])) $this->android_product_id = intval($ar['android_product_id']);
		if (isset($ar['add_time'])) $this->add_time = intval($ar['add_time']);
		if (isset($ar['update_time'])) $this->update_time = intval($ar['update_time']);
		
		
		$this->clean();
		
		return true;
	}
	
	
	public function  loadedCount( $fields=NULL,$condition=NULL)
	{
	
		if (empty($condition) && empty($this->product_id))
		{
			return false;
		}
	
		$p = "*";
		$where = "`product_id` = '{$this->product_id}'";
	
		if(!empty($fields))
		{
			$p = SQLUtil::parseFields($fields);
		}
		if (!empty($condition))
		{
			$where =SQLUtil::parseCondition($condition);
		}
	
		$sql = "SELECT {$p} FROM `product_id_map` WHERE {$where}";
	
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
    	
    	if (!isset($this->product_id)){
    		$emptyFields = false;
    		$fields[] = 'product_id';
    	}else{
    		$emptyCondition = false; 
    		$condition['product_id']=$this->product_id;
    	}
    	if (!isset($this->ios_product_id)){
    		$emptyFields = false;
    		$fields[] = 'ios_product_id';
    	}else{
    		$emptyCondition = false; 
    		$condition['ios_product_id']=$this->ios_product_id;
    	}
    	if (!isset($this->android_product_id)){
    		$emptyFields = false;
    		$fields[] = 'android_product_id';
    	}else{
    		$emptyCondition = false; 
    		$condition['android_product_id']=$this->android_product_id;
    	}
    	if (!isset($this->add_time)){
    		$emptyFields = false;
    		$fields[] = 'add_time';
    	}else{
    		$emptyCondition = false; 
    		$condition['add_time']=$this->add_time;
    	}
    	if (!isset($this->update_time)){
    		$emptyFields = false;
    		$fields[] = 'update_time';
    	}else{
    		$emptyCondition = false; 
    		$condition['update_time']=$this->update_time;
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
				
		if (empty($this->product_id))
		{
			$this->product_id = MySQL::getInstance()->GetInsertId();
		}		
		
		$this->clean();
		
		return true;	
		
	}
	
	public function save($condition=NULL)
	{
		if (empty($condition))
		{
			$uc = "`product_id`='{$this->product_id}'";
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
		
		$sql = "DELETE FROM `product_id_map` WHERE ".SQLUtil::parseCondition($condition);
		
		$qr = MySQL::getInstance()->RunQuery($sql);
				
		return (boolean)$qr;
	}
	
	public function  delete()
	{
		if (!isset($this->product_id))
		{
			return false;
		}
		
		$sql = "DELETE FROM `product_id_map` WHERE `product_id`='{$this->product_id}'";
		
		MySQL::selectDefaultDb();
		$qr = MySQL::getInstance()->RunQuery($sql);
				
		return (boolean)$qr;
	}
	
	public function getInsertValue($fields)
	{
		$values = "(";		
		foreach($fields as $f => $k){
			if($f == 'product_id'){
 				$values .= "'{$this->product_id}',";
 			}else if($f == 'ios_product_id'){
 				$values .= "'{$this->ios_product_id}',";
 			}else if($f == 'android_product_id'){
 				$values .= "'{$this->android_product_id}',";
 			}else if($f == 'add_time'){
 				$values .= "'{$this->add_time}',";
 			}else if($f == 'update_time'){
 				$values .= "'{$this->update_time}',";
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

		if (isset($this->product_id))
		{
			$fields .= "`product_id`,";
			$values .= "'{$this->product_id}',";
		}
		if (isset($this->ios_product_id))
		{
			$fields .= "`ios_product_id`,";
			$values .= "'{$this->ios_product_id}',";
		}
		if (isset($this->android_product_id))
		{
			$fields .= "`android_product_id`,";
			$values .= "'{$this->android_product_id}',";
		}
		if (isset($this->add_time))
		{
			$fields .= "`add_time`,";
			$values .= "'{$this->add_time}',";
		}
		if (isset($this->update_time))
		{
			$fields .= "`update_time`,";
			$values .= "'{$this->update_time}',";
		}

		
		$fields .= ")";
		$values .= ")";
		
		$sql = "INSERT INTO `product_id_map` ".$fields.$values;
		
		return str_replace(",)",")",$sql);
	}
	
	private function  getUpFields()
	{
		$update = "";
		
		if ($this->ios_product_id_status_field)
		{			
			if (!isset($this->ios_product_id))
			{
				$update .= ("`ios_product_id`=null,");
			}
			else
			{
				$update .= ("`ios_product_id`='{$this->ios_product_id}',");
			}
		}
		if ($this->android_product_id_status_field)
		{			
			if (!isset($this->android_product_id))
			{
				$update .= ("`android_product_id`=null,");
			}
			else
			{
				$update .= ("`android_product_id`='{$this->android_product_id}',");
			}
		}
		if ($this->add_time_status_field)
		{			
			if (!isset($this->add_time))
			{
				$update .= ("`add_time`=null,");
			}
			else
			{
				$update .= ("`add_time`='{$this->add_time}',");
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
		
		$sql = "UPDATE `product_id_map` SET {$update} WHERE {$condition}";
		
		return $sql;
	}
	
	public function  add($fieldsValue,$condition=NULL)
	{				
		if (empty($condition))
		{
			$uc = "`product_id`='{$this->product_id}'";
		}
		else
		{			
			$uc = SQLUtil::parseCondition($condition);
		}
		
		$update = SQLUtil::parseASFieldValues($fieldsValue);
		
		$sql = "UPDATE `product_id_map` SET {$update} WHERE {$uc}";
		
		MySQL::selectDefaultDb();
		$qr = MySQL::getInstance()->RunQuery($sql);
				
		return (boolean)$qr;
	}	
	
	public function sub($fieldsVal,$condition=NULL)
	{
		if (empty($condition))
		{
			$uc = "`product_id`='{$this->product_id}'";
		}
		else
		{			
			$uc = SQLUtil::parseCondition($condition);
		}
		
		$update = SQLUtil::parseASFieldValues($fieldsVal,false);
		
		$sql = "UPDATE `product_id_map` SET {$update} WHERE {$uc}";
		
		MySQL::selectDefaultDb();
		$qr = MySQL::getInstance()->RunQuery($sql);
				
		return (boolean)$qr;
	}
	
	private function /*void*/ clean() 
	{
		$this->this_table_status_field = false;
		$this->product_id_status_field = false;
		$this->ios_product_id_status_field = false;
		$this->android_product_id_status_field = false;
		$this->add_time_status_field = false;
		$this->update_time_status_field = false;

	}
	
	public function /*int*/ getProductId()
	{
		return $this->product_id;
	}
	
	public function /*void*/ setProductId(/*int*/ $product_id)
	{
		$this->product_id = intval($product_id);
		$this->product_id_status_field = true;		
		$this->this_table_status_field = true;		
	}

	public function /*void*/ setProductIdNull()
	{
		$this->product_id = null;
		$this->product_id_status_field = true;		
		$this->this_table_status_field = true;
	}

	public function /*int*/ getIosProductId()
	{
		return $this->ios_product_id;
	}
	
	public function /*void*/ setIosProductId(/*int*/ $ios_product_id)
	{
		$this->ios_product_id = intval($ios_product_id);
		$this->ios_product_id_status_field = true;		
		$this->this_table_status_field = true;		
	}

	public function /*void*/ setIosProductIdNull()
	{
		$this->ios_product_id = null;
		$this->ios_product_id_status_field = true;		
		$this->this_table_status_field = true;
	}

	public function /*int*/ getAndroidProductId()
	{
		return $this->android_product_id;
	}
	
	public function /*void*/ setAndroidProductId(/*int*/ $android_product_id)
	{
		$this->android_product_id = intval($android_product_id);
		$this->android_product_id_status_field = true;		
		$this->this_table_status_field = true;		
	}

	public function /*void*/ setAndroidProductIdNull()
	{
		$this->android_product_id = null;
		$this->android_product_id_status_field = true;		
		$this->this_table_status_field = true;
	}

	public function /*int*/ getAddTime()
	{
		return $this->add_time;
	}
	
	public function /*void*/ setAddTime(/*int*/ $add_time)
	{
		$this->add_time = intval($add_time);
		$this->add_time_status_field = true;		
		$this->this_table_status_field = true;		
	}

	public function /*void*/ setAddTimeNull()
	{
		$this->add_time = null;
		$this->add_time_status_field = true;		
		$this->this_table_status_field = true;
	}

	public function /*int*/ getUpdateTime()
	{
		return $this->update_time;
	}
	
	public function /*void*/ setUpdateTime(/*int*/ $update_time)
	{
		$this->update_time = intval($update_time);
		$this->update_time_status_field = true;		
		$this->this_table_status_field = true;		
	}

	public function /*void*/ setUpdateTimeNull()
	{
		$this->update_time = null;
		$this->update_time_status_field = true;		
		$this->this_table_status_field = true;
	}

	
	public function /*string*/ toDebugString()
	{
		$dbg = "(";
		
		$dbg .= ("product_id={$this->product_id},");
		$dbg .= ("ios_product_id={$this->ios_product_id},");
		$dbg .= ("android_product_id={$this->android_product_id},");
		$dbg .= ("add_time={$this->add_time},");
		$dbg .= ("update_time={$this->update_time},");

		$dbg .= ")";
				
		return str_replace(",)",")",$dbg);
	}
}

?>
