<?php
require_once ($GLOBALS ['GAME_ROOT'] . "CMySQL.php");

class SQLBatch {
	
	private $sql = "";
	private $sql_header=array();
	private $has_value = false;

	public function init($sql_header)
	{
		if(!is_array($sql_header) || count($sql_header) < 2){	
			Logger::getLogger()->error("failed to init sqlbatch {$sql_header}");		
			return;
		}			
		$this->sql_header = $sql_header;
		$this->sql = $sql_header[0];
		$this->has_value = false;
	}
	
	public function add($table)
	{
		$this->sql .= $table->getInsertValue($this->sql_header[1]).",";
		$this->has_value = true;
	}
	
	public function end()
	{
		if(!$this->has_value){
			return;
		}
		
		$i = strrpos($this->sql,",");
		if (!is_bool($i))
		{
			$this->sql = substr($this->sql,0,$i);
		}
		$this->sql .= ";";
	}
	
	public function save()
	{
		if(!$this->has_value){
			return;
		}
		MySQL::getInstance()->RunQuery($this->sql);
	}
	
	public function getSql()
	{
		return $this->sql;
	}

}

?>