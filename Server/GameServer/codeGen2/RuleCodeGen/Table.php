<?php

class TableField
{	
	var $name;
	
	var $dirtyName;
	
	var $type;
	
	var $default;
	
	var $comment;
	
	var $isKey;	
}

class Table 
{
	var $tableName;
	var $name;
	var $fields;
	
	var $keyfield;
	
	var $key_name;	
	var $field_define_code;
	var $field_dirty_define_code;	
	var $insert_sql_code;
	var $update_sql_code;
	var $clean_code;	
	var $load_table_code;
	var $load_code;	
	var $field_get_set_code;	
	var $to_debug_string_code;
	var $load_from_exist_fields_code;	
	var $select_db_code;
	var $sql_header_code;
	var $insert_value_code;
	var $cache_cmp_condition_code;
	var $copy_cache_table_code;
	
	private $GETSETTPL = "	public function /*[TNAME]*/ get[FNAME]()\r\n	{\r\n		return \$this->[NAME];\r\n	}\r\n	\r\n	public function /*void*/ set[FNAME](/*[TNAME]*/ $[NAME])\r\n	{\r\n		\$this->[NAME] = [TMOTH]($[NAME]);\r\n		\$this->[DNAME] = true;		\r\n		\$this->is_this_table_dirty = true;		\r\n	}\r\n\r\n	public function /*void*/ set[FNAME]Null()\r\n	{\r\n		\$this->[NAME] = null;\r\n		\$this->[DNAME] = true;		\r\n		\$this->is_this_table_dirty = true;\r\n	}\r\n\r\n";
			

	public function Table($tn,$n,$f)
	{
		$this->tableName = $tn;
		$this->name = $n;
		$this->fields = $f;		
	}

	public function genDetails()
	{
		$this->key_name = $this->getKeyName();				
		$this->field_define_code = $this->genFieldDefineCode();
		$this->field_dirty_define_code = $this->genFieldDirtyDefineCode();
		$this->field_get_set_code = $this->genFieldGetSetCode();	
		$this->load_table_code = $this->genLoadTableCode();	
		$this->load_code = $this->genLoadCode();	
		$this->load_from_exist_fields_code = $this->genLoadFromExistFieldsCode();
		$this->insert_sql_code = $this->genInsertSqlCode();
		$this->update_sql_code = $this->genUpdateSqlCode();
		$this->clean_code = $this->genCleanCode();			
		$this->to_debug_string_code = $this->genDebugStringCode();		
		$this->select_db_code = $this->genSelectDBCode();
		$this->sql_header_code = $this->genSqlHeaderCode();
		$this->insert_value_code = $this->genInsertValueCode();
		$this->cache_cmp_condition_code = $this->genCacheCmpConditionCode();
		$this->copy_cache_table_code = $this->genCopyCacheTableCode();
	}
	
	private function getKeyName()
	{		
		$key = null;
		foreach($this->fields as $field)
		{
			if (empty($key))
			{
				if ($field->isKey) 
				{
					$key = $field->name;
					$this->keyfield = $field;
				}
			}
			else
			{		
				if ($field->isKey) 
				{
					throw new Exception($this->name." parse table error muti keys ".$key." ".$field->name."\n",-1);
				}						
			}
		}
		
		if (empty($key))
		{
			throw new Exception($this->name." parse table error no key found \n",-2);
		}
		
		return $key;
	}	
		
	private function genFieldDefineCode()
	{
		$s = '';
		
		foreach($this->fields as $field)
		{
			if ($field->isKey)
			{
				//if (!isset($field->default)){
					$s .= sprintf("	private /*%s*/ $%s; //PRIMARY KEY %s\r\n",$field->type,$field->name,$field->comment);			
				//}else{
				//	$s .= sprintf("	private /*%s*/ $%s = %s; //PRIMARY KEY %s\r\n",$field->type,$field->name,$field->default,$field->comment);	
				//}
			}
			else
			{
				//if (!isset($field->default)){
					if (empty($field->comment)){
						$s .= sprintf("	private /*%s*/ $%s;\r\n",$field->type,$field->name);			
					}else{
						$s .= sprintf("	private /*%s*/ $%s; //%s\r\n",$field->type,$field->name,$field->comment);		
					}
			//	}else{
			//		if (empty($field->comment)){
			//			$s .= sprintf("	private /*%s*/ $%s = %s;\r\n",$field->type,$field->name,$field->default);			
			//		}else{
			//			$s .= sprintf("	private /*%s*/ $%s = %s; //%s\r\n",$field->type,$field->name,$field->default,$field->comment);		
			//		}
			//	}
			}
		}
		
		return $s;
	}
	
    private function genFieldDirtyDefineCode()
	{
		$s = '';
			
		foreach($this->fields as $field)
		{			
			$s .= sprintf("	private $%s = false;\r\n",$field->dirtyName);		
		}

		return $s;
	}
	
    private function genFieldGetSetCode()
	{
		$s = '';
		
		foreach($this->fields as $field)
		{			
			$tpl = $this->GETSETTPL;
			$fname = DBParser::toClassName($field->name); 		
						
			$tpl = str_replace("[FNAME]",$fname,$tpl);
			$tpl = str_replace("[TNAME]",$field->type,$tpl);
			$tpl = str_replace("[NAME]",$field->name,$tpl);
			$tpl = str_replace("[DNAME]",$field->dirtyName,$tpl);
			$tpl = str_replace("[TMOTH]",DBtypeMap::typeVal($field->type),$tpl);
			
			$s .= $tpl;
		}

		return $s;
	}
		
    private function genInsertSqlCode()
	{
		$s = '';
			
		foreach($this->fields as $field)
		{	
			$s .= "		if (isset(\$this->{$field->name}))\r\n		{\r\n			\$fields .= \"`{$field->name}`,\";\r\n			\$values .= \"'{\$this->{$field->name}}',\";\r\n		}\r\n";
		}

		return $s;
	}
	
    private function genUpdateSqlCode()
	{
		$s = '';
			
		foreach($this->fields as $field)
		{
			if (! $field->isKey) 
			{
				$s .= "		if (\$this->{$field->dirtyName})\r\n		{			\r\n			if (!isset(\$this->{$field->name}))\r\n			{\r\n				\$update .= (\"`{$field->name}`=null,\");\r\n			}\r\n			else\r\n			{\r\n				\$update .= (\"`{$field->name}`='{\$this->{$field->name}}',\");\r\n			}\r\n		}\r\n";
			}
		}

		return $s;
	}
	
    private function genCleanCode()
	{
		$s = '';
			
		foreach($this->fields as $field)
		{
			$s .= sprintf("		\$this->%s = false;\r\n",$field->dirtyName);
		}

		return $s;
	}
	
	private function genLoadCode()
	{
		$s = '';		
		
		foreach($this->fields as $field)
		{
			$type = DBtypeMap::noStringTypeVal($field->type);
			if(empty($type)){
				$s .= "		if (isset(\$ar['{$field->name}'])) \$this->{$field->name} = \$ar['{$field->name}'];\r\n";
			}else{
				$s .= "		if (isset(\$ar['{$field->name}'])) \$this->{$field->name} = {$type}(\$ar['{$field->name}']);\r\n";
			}
		}
		
		
		return str_replace(",)","",$s);
	}	
	
	private function genDebugStringCode()
	{
		$s = '';
		
		foreach($this->fields as $field)
		{
			$s .= "		\$dbg .= (\"{$field->name}={\$this->{$field->name}},\");\r\n";
		}
		
		return $s;		
	}
	
	private function genLoadFromExistFieldsCode()
	{
		$s = '';
		
		foreach($this->fields as $field)
		{			
			$s .= "    	if (!isset(\$this->{$field->name})){\r\n    		\$emptyFields = false;\r\n    		\$fields[] = '{$field->name}';\r\n    	}else{\r\n    		\$emptyCondition = false; \r\n    		\$condition['{$field->name}']=\$this->$field->name;\r\n    	}\r\n";
		}
		
		return $s;
	}
	
	
	private function genLoadTableCode()
	{
		$s = '';
		
		foreach($this->fields as $field)
		{
			$type = DBtypeMap::noStringTypeVal($field->type);
			if(empty($type)){
				$s .= "			if (isset(\$row['{$field->name}'])) \$tb->{$field->name} = \$row['{$field->name}'];\r\n";
			}else{
				$s .= "			if (isset(\$row['{$field->name}'])) \$tb->{$field->name} = {$type}(\$row['{$field->name}']);\r\n";
			}
		}
		
		return $s;		
	}
	
	private function genSelectDBCode()
	{
		$s = '';
		//player开头的表分区 其他不分 
		if (strncasecmp($this->tableName,"player",6)==0)
		{
			$s = "		if(isset(\$this->user_id)){MySQL::selectDbForUser(\$this->user_id);}else{MySQL::selectDbForUser(\$GLOBALS['USER_ID']);}";			
		}
		else
		{
			$s = "		MySQL::selectDefaultDb();";			
		}
		
		return $s;
	}
	
	private function genSqlHeaderCode()
	{
		/**
		  	$result[0] = "INSERT INTO `player_tech` (`user_id`,`type`,`level`,`grow`,`percent`) VALUES ";	
			$result[1] = array('user_id','type','level','grow','percent');
		 */
		$s = "			\$result[0]=\"INSERT INTO `{$this->tableName}` (";
		$s2 = "			\$result[1] = array(";
		
		foreach($this->fields as $field)
		{			
			$s .= "`{$field->name}`,";			
			$s2 .= "'{$field->name}'=>1,";			
		}
		
		$s .= ") VALUES \";\r\n";
		$s2 .= ");";
		
		$s .= $s2;
		
		return str_replace(",)",")",$s);		
	}
	
	private function genInsertValueCode()
	{
		$s = "";
		$first = true;
		foreach($this->fields as $field)
		{	
			if($first){
			 	$s.="			if(\$f == '{$field->name}'){\r\n 				\$values .= \"'{\$this->{$field->name}}',\";\r\n 			}";
			}else{
				$s.="else if(\$f == '{$field->name}'){\r\n 				\$values .= \"'{\$this->{$field->name}}',\";\r\n 			}";
			}	
			$first = false;						
		}
		
		return $s;
	}
	
	private function genCacheCmpConditionCode()
	{
		//
		$s = "";
		foreach($this->fields as $field)
		{
			$tv = DBtypeMap::rawStringTypeVal($field->type);
			$s .= "			if(isset(\$condition['{$field->name}']) && {$tv}(\$condition['{$field->name}']) != \$record->{$field->name}) continue;\r\n";
		}
		return $s;
	}
	
	private function genCopyCacheTableCode()
	{
		$s = "";
		foreach ($this->fields as $field){
			$s .= "			\$this->{$field->name} = \$cacheTb->{$field->name};\r\n";
		}
		
		return $s;
	}
	
}

?>