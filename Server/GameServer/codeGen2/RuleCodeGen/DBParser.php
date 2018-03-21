<?php

require_once ("CMySQL.php");
require_once ("Table.php");
require_once ("DBtypeMap.php");

class DBParser {
	
	var $tableTpl;
	var $tableCacheTpl;
	var $outputPath;
	var $cacheTables = array();
		
	public function DBParser($t,$op)
	{
		$this->tableTpl = file_get_contents($t."DbTable.php");
		$this->tableCacheTpl = file_get_contents($t."DbTableC.php");
		$this->outputPath = $op;		
		
		$f = fopen($t."cacheTables.txt", "r");
		while(!feof($f)){
			$line = fgets($f);
			$line = trim($line);
			if(empty($line)){
				continue;
			}
			$this->cacheTables[$line] = $line;
		}
		fclose($f);
	}

	public function parse($targetTables) 
	{				
		if(!empty($targetTables)){
			if(is_string($targetTables)){
				try
				{
					$this->parseTable($targetTables);
				}
				catch(Exception $e)
				{
					echo $e->getMessage();			
				}
			}else if(is_array($targetTables)){
				foreach($targetTables as $table){
					try
					{
						$this->parseTable($table);
					}
					catch(Exception $e)
					{
						echo $e->getMessage();			
					}
				}				
			}
			return;
		}
		
		$qr = MySQL::getInstance ()->RunQuery ( "SHOW TABLES" );
		
		$res = MySQL::getInstance ()->FetchAllRows ( $qr );
		
		foreach ( $res as $table ) 
		{
			try
			{
				$this->parseTable($table[0]);
			}
			catch(Exception $e)
			{
				echo $e->getMessage();			
			}
		}
	}
	
	private function getComments($tableName)
	{
		$result = array();
		
		$qr = MySQL::getInstance ()->RunQuery ( "SELECT COLUMN_NAME as name,COLUMN_COMMENT as comment FROM INFORMATION_SCHEMA.COLUMNS where TABLE_NAME='{$tableName}'");
		$cmr = MySQL::getInstance ()->FetchAllRows ( $qr );
		if (empty($cmr)){
			return $result;
		}
		foreach($cmr as $c){
			$d = str_replace("\r"," ",$c['comment']);
			$d = str_replace("\n"," ",$d);
			$result[$c['name']] = $d;
		}		
				
		return $result;
	}
	
	public function parseTable($tableName) 
	{
		$qr = MySQL::getInstance ()->RunQuery ( "DESC ".$tableName );
		
		$res = MySQL::getInstance ()->FetchAllRows ( $qr );
		
		if (empty($res))
		{
			echo "Error parse table ".$tableName."\n";
		}
		
		
		
		$fields = array();
		
		$comments = $this->getComments($tableName);
						
		foreach ( $res as $tableInfo ) 
		{
			$tf = new TableField();
			$tf->name = $tableInfo['Field'];
			$tf->dirtyName = sprintf("is_%s_dirty",$tf->name);
			$tf->type =  DBtypeMap::dbType2Php($tableInfo['Type']);
			$tf->default = $tableInfo['Default'];
			if (isset($tf->default) && DBtypeMap::isString($tf->type)){
				$tf->default = "'{$tf->default}'";
			}			
			$tf->comment = $comments[$tf->name];
			$tf->isKey = (strcasecmp($tableInfo['Key'],"PRI") == 0);
			$fields[] = $tf;			
		}
				
		
		$tableObj = new Table($tableName,"Tb".$this->toClassName($tableName),$fields);		
		$tableObj->genDetails();
		
		$time = date("Y-m-d H:i:s");
		
		if(isset($this->cacheTables[$tableName])){
			$tpl = $this->tableCacheTpl;
		}else{
			$tpl = $this->tableTpl;
		}				
		$tpl = str_replace("/*::DATE_TIME_CODE::*/",$time,$tpl);
		$tpl = str_replace("/*::TABLE_NAME::*/",$tableName,$tpl);
		$tpl = str_replace("/*::TABLE_CLASS_NAME::*/",$tableObj->name,$tpl);
		$tpl = str_replace("/*::KEY_NAME::*/",$tableObj->key_name,$tpl);			
		$tpl = str_replace("/*::FIELD_DEFINE_CODE::*/",$tableObj->field_define_code,$tpl);	
		$tpl = str_replace("/*::FIELD_DIRTY_DEFINE_CODE::*/",$tableObj->field_dirty_define_code,$tpl);	
		$tpl = str_replace("/*::FIELD_GET_SET_CODE::*/",$tableObj->field_get_set_code,$tpl);	
		$tpl = str_replace("/*::LOAD_TABLE_CODE::*/	",$tableObj->load_table_code,$tpl);	
		$tpl = str_replace("/*::LOAD_CODE::*/",$tableObj->load_code,$tpl);	
		$tpl = str_replace("/*::LOAD_FROM_EXIST_FIELDS_CODE::*/",$tableObj->load_from_exist_fields_code,$tpl);				
		$tpl = str_replace("/*::INSERT_SQL_CODE::*/",$tableObj->insert_sql_code,$tpl);	
		$tpl = str_replace("/*::UPDATE_SQL_CODE::*/",$tableObj->update_sql_code,$tpl);			
		$tpl = str_replace("/*::CLEAN_CODE::*/",$tableObj->clean_code,$tpl);		
		$tpl = str_replace("/*::TO_DEBUG_STRING_CODE::*/",$tableObj->to_debug_string_code,$tpl);		
		$tpl = str_replace("/*::SELECT_DB_CODE::*/",$tableObj->select_db_code,$tpl);		
		$tpl = str_replace("/*::SQL_HEADER_CODE::*/",$tableObj->sql_header_code,$tpl);		
		$tpl = str_replace("/*::INSERT_VALUE_CODE::*/",$tableObj->insert_value_code,$tpl);	
		$tpl = str_replace("/*::CACHE_CMP_CONDITION_CODE::*/",$tableObj->cache_cmp_condition_code,$tpl);
		$tpl = str_replace("/*::COPY_CACHE_TABLE_CODE::*/",$tableObj->copy_cache_table_code,$tpl);
						
		$tpl = str_replace(",)",")",$tpl);

		$path = $this->outputPath.$tableObj->name.".php";		
				
		file_put_contents($path,$tpl);
		
	}
	
	public static function toClassName($name)
	{
		$cname = $name;
		$cname[0] = strtoupper($cname[0]);
		
		$n2 = "";
		$l = strlen($cname);
		$need_upper = false;
		for ($i=0; $i < $l; $i++)
		{
			if (strncasecmp($cname[$i],'_',1)!=0)
			{
				if (!$need_upper)
				{
					$n2 .= $cname[$i];
				}
				else
				{
					$n2 .= strtoupper($cname[$i]);
					$need_upper = false;
				}
			}
			else 
			{
				$need_upper = true;				
			}			
		}
		
		return $n2;
	}
}

?>