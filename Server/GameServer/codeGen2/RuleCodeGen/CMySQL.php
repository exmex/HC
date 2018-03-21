<?php
require_once 'config.php';
require_once 'log/Logger.php';

class MySQL
{
	public $link = false;
	
	private $hostname;
	private $username;
	private $password;
	
	var $dbname;
	
	static $extension = 'mysql';
	
	static $query_cache = array();
	static $query_cache_rows = array();
	
	static $query_log;
	
	static $instance;
	
	static function &getInstance()
	{
	    if (!isset(self::$instance))
	    {
	    	self::$instance = new MySQL();
	    	self::$instance->Connect(DATABASE_HOST,DATABASE_USER,DATABASE_PASSWORD,DATABASE_DB_NAME);
	    	if (self::$instance->link == false)
	    	{
	    		Logger::getLogger()->fatal("Failed to connect to mysql ".DATABASE_HOST);
	    		die("Failed to init mysql connection!");
	    	}
	    }
	    
	    return self::$instance;
	}
	
	function Connect($hostname, $username, $password, $dbname, $pconnect = false, $character_set = false)
	{
		if ($pconnect)
		{
			$this->link = @mysql_pconnect($hostname, $username, $password);
		}
		else
		{
			$this->link = @mysql_connect($hostname, $username, $password);
		}
		
		if (!$this->link)
		{
			$this->PrintError('Connect: ' . $hostname, mysql_errno($this->link), mysql_error($this->link));
		}
		
		if (!mysql_select_db($dbname, $this->link))
		{
			$this->PrintError('SELECT DB: ' . $dbname, mysql_errno($this->link), mysql_error($this->link));
		}
		
		if ($character_set)
		{
			// For MySQL 4.1+
			@mysql_query("SET NAMES utf8", $this->link);
		
			// For MySQL 5.0.1 +
			@mysql_query("SET sql_mode = ''", $this->link);
		}
		
		return true;
	}
	
	function Disconnect()
	{
		//global $db_total_query, $db_total_cache_query;
		
		if (@mysql_close($this->link))
		{			
			//$db_query_log = self::$query_log;
			
			return true;
		}
		
		return false;
	}
	
	function RunQuery($query, $show_error = true)
	{
		global $db_total_query;		
		
	   	$db_total_query++;
	 
	    if (DEBUG == true)
	    {
		    self::$query_log .= "\nDB: " . $this->dbname . ': ' . $query;
		}
		    
	    $resource = mysql_query($query, $this->link);
	    
	    if ((mysql_errno($this->link) OR mysql_error($this->link)) AND $show_error)
	    {
	        $this->PrintError($query, mysql_errno($this->link), mysql_error($this->link));
	        return 0;
	    }
		    
	    return $resource;		
	}

	function QueryRowsArray($query, $show_error = true)
	{
		global $db_total_cache_query;
		
		if (!preg_match('#\b(?:INSERT|UPDATE|REPLACE|SET)\b#i', $query) AND $this->enable_cache)
		{
		    $hash = $this->QueryHash($query);
	
		    if (!is_array(self::$query_cache_rows[$hash]))
		    {
		    	unset(self::$query_cache[$hash]);
		    	
			    $this->closeCache();
			    
			    $resource = $this->RunQuery($query, $show_error);
			    
			    $this->openCache();
		    	
		    	if ($this->GetNumRows($resource) == 0)
		    	{
		    		return false;
		    	}
		    	
		    	// Set the cached array
		    	self::$query_cache_rows[$hash] = $this->FetchArray($resource);
		    }
		    else
		    {
		    	//$this->total_cache_query++;
				$db_total_cache_query++;
		    }
	
		    // Return the cached query
		    return self::$query_cache_rows[$hash];
		}
		else
		{		    
		    $this->closeCache();
		    
		    $resource = $this->RunQuery($query, $show_error);
		    
		    $this->openCache();
		    
		    return $this->FetchArray($resource);
		}
	}
	
	function FetchArray($result)
	{
		return @mysql_fetch_array($result);
	}
	
	function FetchAllRows($result)
	{						
		if ($this->GetNumRows($result) <= 0)
		{
			return ;
		}
		
		$array = array();
		$i = 0;		
				
		$row = $this->FetchArray($result);
		while($row)
		{
			$array[$i] = $row;
			$i++;			
			$row = $this->FetchArray($result);
		}
		
		return $array;		
	}
	
	function GetNumRows($resource)
	{		
		return @mysql_num_rows($resource);
	}
	
	function GetNumFields($resource)
	{		
		return @mysql_num_fields($resource);
	}
	
	/*
	Example:
		$SQL->Update('user', array('money' => '10', 'point' => '10'), array('id' => '1', 'username' => 'explon')):
			SQL:
				UPDATE `user` SET `money` = '10', `point` = '10' WHERE `id` = '1' AND `username` = 'explon';
			RETURN: Resources
			
		$SQL->Update('user', array('money' => '10', 'point' => '10'), array('id' => '1', 'username' => 'explon'), 'OR'):
			SQL:
				UPDATE `user` SET `money` = '10', `point` = '10' WHERE `id` = '1' OR `username` = 'explon';
			RETURN: Resources
		
		Don't set same key in array(), this is wrong:
			$SQL->Update('user', array('money' => '10', 'point' => '10'), array('id' => '1', 'id' => '2'))
		
		$SQL->Update(array('user', 'member'), array('money' => 'money+10', 'point' => 'point-10'), array('id' => '1')):
			SQL:
				UPDATE `user` SET `money` = `money` +10, `point` = `point` -10 WHERE `id` = '1';
				UPDATE `member` SET `money` = `money` +10, `point` = `point` -10 WHERE `id` = '1';
			RETURN: true

			
		$SQL->Update('user', array('money' => '100', 'point' => '100'), array('id' => '<1')):
			SQL:
				UPDATE `user` SET `money` = '100', `point` = '100' WHERE `id` < '1';
			RETURN: Resources
			
		$SQL->Update('user', array('money' => '100', 'point' => '100'), array('id' => '!=1'));
			SQL:
				UPDATE `user` SET `money` = '100', `point` = '100' WHERE `id` != '1';
			RETURN: Resources
	*/
	
	function Update($table, $fields, $where, $where_type = 'AND')
	{
		$fields = $this->QuerySetGenerate($fields);
		$where = $this->QueryWhereGenerate($where);
		
		$set_query = '';
		$where_query = '';
		
		foreach ($fields AS $key => $field)
		{
			$set_query .= ', `' . $key . '` = ' . $field;
		}
		
		if (is_array($table))
		{
			foreach ($where AS $key => $value)
			{
				$where_query .= ' ' . $where_type. " `" . $key . "` " . $value;
			}
			
			foreach ($table AS $_table)
			{
				$this->RunQuery("UPDATE `" . $_table . "` SET " . substr($set_query, 1) . " WHERE " . substr($where_query, strlen($where_type) + 1));
			}
		}
		else
		{
			foreach ($where AS $key => $value)
			{
				$where_query .= ' ' . $where_type. " `" . $key . "` " . $value;
			}
			
			return $this->RunQuery("UPDATE `" . $table . "` SET " . substr($set_query, 1) . " WHERE " . substr($where_query, strlen($where_type) + 1));
		}
	}
	
	/*
	Example:
		$SQL->Select('user', '*', array('id' => '1', 'username' => 'explon'), '0,7', 'OR');
			SQL:
				SELECT * FROM `user` WHERE `id` = '1' OR `username` = 'explon' LIMIT 0,7;
			RETURN: Resources
			
		Don't set same key in array(), this is wrong:
			$SQL->Select('user', '*', array('id' => '1', 'id' => '2'), '0,7', 'OR');
			
		$SQL->Select('user', 'id,username,nickname', array('id' => '1', 'username' => 'explon'), '0,7');
			SQL:
				SELECT `id`, `username`, `nickname` FROM `user` WHERE `id` = '1' AND `username` = 'explon' LIMIT 0,7;
			RETURN: Resources
			
		$SQL->Select('user', 'id,username,nickname', array('id' => '1'));
			SQL:
				SELECT `id`, `username`, `nickname` FROM `user` WHERE `id` = '1';
			RETURN: Resources
	*/
	
	function Select($table, $fields, $where, $limit = false, $where_type = 'AND')
	{
		$where = $this->QueryWhereGenerate($where);
		
		$fields_query = '';
		$where_query = '';
		
		if (strstr($fields, ','))
		{
			$fields_array = explode(',', $fields);
			
			foreach ($fields_array AS $field)
			{
				$fields_query .= ', `' . trim($field) . '`';
			}
			
			$fields_query = substr($fields_query, 1);
		}
		else
		{
			if ($fields == '*')
			{
				$fields_query = $fields;
			}
			else
			{
				$fields_query = '`' . $fields . '`';
			}
		}
		
		foreach ($where AS $key => $value)
		{
			$where_query .= ' ' . $where_type. " `" . $key . "` " . $value;
		}
		
		if ($limit)
		{
			return $this->RunQuery("SELECT " . $fields_query . " FROM `" . $table . "` WHERE " . substr($where_query, strlen($where_type) + 1) . ' LIMIT ' . $limit);
		}
		else
		{
			return $this->RunQuery("SELECT " . $fields_query . " FROM `" . $table . "` WHERE " . substr($where_query, strlen($where_type) + 1));
		}
	}
	
	/*
	Example:
		$SQL->Insert('photos', array('id', 'gid', 'user', 'views', 'time', 'filename', 'title'), array('NULL', '1', '2', '3', '4', '5', '6'));
			SQL:
				INSERT INTO `photos` ( `id`, `gid`, `user`, `views`, `time`, `filename`, `title`) VALUES (NULL, '1', '2', '3', '4', '5', '6');
			RETURN: mysql_insert_id()
			
		$SQL->Insert(array('photos', 'photos'), array('id', 'gid', 'user', 'views', 'time', 'filename', 'title'), array('NULL', '1', '2', '3', '4', '5', '6'));
			SQL:
				INSERT INTO `photos` ( `id`, `gid`, `user`, `views`, `time`, `filename`, `title`) VALUES (NULL, '1', '2', '3', '4', '5', '6');
				INSERT INTO `photos` ( `id`, `gid`, `user`, `views`, `time`, `filename`, `title`) VALUES (NULL, '1', '2', '3', '4', '5', '6');
			RETURN: true
	*/
	
	function Insert($table, $fields, $values)
	{
		$fields_query = '';
		$values_query = '';
		
		foreach ($fields AS $field)
		{
			$fields_query .= ', `' . trim($field) . '`';
		}
		
		$fields_query = substr($fields_query, 1);
		
		foreach ($values AS $value)
		{
			if ($value == 'NULL')
			{
				$values_query .= ', ' . trim($value);
			}
			else
			{
				$values_query .= ', \'' . trim($value) . '\'';
			}
		}
		
		$values_query = substr($values_query, 2);
		
		if (is_array($table))
		{
			foreach ($table AS $_table)
			{
				$this->RunQuery("INSERT INTO `" . $_table . "` (" . $fields_query . ") VALUES (" . $values_query . ")");
			}
			
			return true;
		}
		else
		{
			$this->RunQuery("INSERT INTO `" . $table . "` (" . $fields_query . ") VALUES (" . $values_query . ")");
			
			return $this->GetInsertId();
		}
	}
	
	private function QueryWhereGenerate($where)
	{
		if (!is_array($where))
		{
			return false;
		}
		
		$where_change_char = array('>', '<', '!=');
		
		$new_where = array();
		
		foreach($where AS $key => $value)
		{
			if (in_array(substr($value, 0, 1), $where_change_char))
			{
				$new_str = substr($value, 0, 1) . ' \'' . substr($value, 1) . '\'';
			}
			else if (in_array(substr($value, 0, 2), $where_change_char))
			{
				$new_str = substr($value, 0, 2) . ' \'' . substr($value, 2) . '\'';
			}
			else
			{
				$new_str = '= \'' . $value . '\'';
			}
			
			$new_where[$key] = $new_str;
		}
		
		return $new_where;
	}
	
	private function QuerySetGenerate($fields)
	{
		if (!is_array($fields))
		{
			return false;
		}
		
		$new_fields = array();
		
		foreach ($fields AS $key => $field)
		{
			$key_len = strlen($key);
			
			if (substr($field, 0, $key_len) == $key)
			{
				$new_str = '`' . $key . '` ' . substr($field, $key_len);
			}
			else
			{
				$new_str = '\'' . $field . '\'';
			}
			
			$new_fields[$key] = $new_str;
		}
		
		return $new_fields;
	}
	
	function GetInsertId()
	{
		return mysql_insert_id($this->link);
	}
	
	function PrintError($error, $error_msg, $error_code)
	{				   
		$trace = debug_backtrace();
				
		Logger::getLogger()->error("run sql error[");
		foreach($trace as $s)
		{
			$file = isset($s['file'])?$s['file']:'';
			$line = isset($s['line'])?$s['line']:'';
			Logger::getLogger()->error("STACK:{$file}:{$line}");				
		}		
		Logger::getLogger()->error($error." error_code:". $error_code. " error_msg:". $error_msg."]");
		
	}
	
	/**	 
	 * @param $table
	 * @param $fieldName
	 * @param $value
	 * @return bool
	 * 
	 * Example:
	 *   CheckExist("player","name","'sam'"); 
	 *   CheckExist("player","user_id",1);
	 */
	
	function CheckExist($table,$fieldName,$value)/*:bool*/
	{
		$query = "SELECT COUNT(*) FROM ".$table." WHERE `".$fieldName."`=".strval($value);
		$rs = $this->RunQuery($query);
		$arr = $this->FetchArray($rs);
		if (!$arr)
		{
			return false;
		}				
		
		return ($arr[0] > 0);
	}
	
	function BeginTran()
	{
		$this->RunQuery( "BEGIN" ); //开始事务
	}
	function Commit()
	{
		$this->RunQuery( "COMMIT" ); //结束事务
	}
	function Rollback()
	{
		$this->RunQuery( "ROLLBACK" ); //结束事务
	}
}
