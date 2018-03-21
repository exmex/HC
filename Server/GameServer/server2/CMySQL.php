<?php
require_once 'config.php';
require_once 'Log/Logger.php';

class MySQL
{
    /** 当前的数据库连接 */
	private $link = false;

    /** @var bool 是否启用查询缓存 */
    private $enable_cache = false;

    /** @var string 当前连接的ip地址 */
	private $hostname = "";

    /** @var string 当前连接的用户名称 */
	private $username = "";

    /** @var string 当前连接的密码 */
	private $password = "";

    /** @var string 当前连接的数据库名称 */
    private $dbname = "";

	static $extension = 'mysql';

	static $query_cache = array();
	static $query_cache_rows = array();

	static $query_log;

    /** @var MySQL 停用 */
    public static $instance = null;

    /** @var null 当前默认连接的数据库标识 */
    private static $currentDbFlag = null;

    /** @var array 当前所有已经初始化的数据库连接数组,key为其游戏库flag标识 */
    private static $instanceArr = array();

    /** @var \PlayerDbInfo 当前所在的默认游戏服数据库配置 */
	private static $default_db_config;

    /** @var 当前使用的 数据库配置 */
	private static $current_use_db_config; //当前使用的 数据库配置

    /** @var array 所有可连接的数据库信息 */
	private static $player_db_info = array();

    /** @var \PlayerDbInfo 当前选择的数据库 */
	private static $selected_db_info;

	static $selected_user; //当前选择的玩家

	/**
	 * 性能测试 变量
	 */
	static $connect_time = 0.0; //花费在连接的时间
	static $query_time = 0.0;   //花费在查询的时间

    /** 网站主库标记 */
    const WEB_MASTER_FLAG = "web_master";

    /** 网站从库标记 */
    const WEB_SLAVE_FLAG = "web_slave";

	public static function clearMysqlServer() {
     	self::$instance = null;
		self::$instanceArr = array();
	}
	
	static function initDbInfo($str_info)
	{
		if (empty($str_info)){
			return;
		}

		$dbinfo = explode(";",$str_info);
		if (is_array($dbinfo)){
			foreach($dbinfo as $si){
				if (empty($si) || strlen($si) == 0){
					continue;
				}
				$detailInfo = explode("=",$si);
				if (count($detailInfo) != 6){
					Logger::getLogger()->fatal("parse db information error:{$si}");
					continue;
				}
				 $dbi = new PlayerDbInfo();
				 $dbi->id = $detailInfo[0];
				 $dbi->address = $detailInfo[1];
				 $dbi->port = $detailInfo[2];
				 $dbi->user = $detailInfo[3];
				 $dbi->password = $detailInfo[4];
				 $dbi->dbname = $detailInfo[5];

				 self::$player_db_info[$dbi->id]=$dbi;
			}
		}
	}
 
	//选择玩家数据所在数据库 
	static function selectDbForUser($use_id)
	{
        return true; //2012-11-13 现在改为分服机制
		//无其他数据库
		if (empty(self::$player_db_info) || count(self::$player_db_info)==0){
			//Logger::getLogger()->debug("selectDbForUser empty(self::player_db_info)");
			self::selectDefaultDb();
			return true;
		}

		if(empty($use_id)){
			//Logger::getLogger()->debug("selectDbForUser empty(use_id)");
			self::selectDefaultDb();
			return true;
		}

		if ($use_id == self::$selected_user){
			//Logger::getLogger()->debug("selectDbForUser use_id == self::selected_user");
			return true;
		}

		//$db_index = $use_id/MAX_PLAYER_FOR_ONE_SET + $use_id % PLAYER_DB_SET; //分区算法
		//由于目前还是测试版，user_id可以随意指定，所以先去掉上限
		$db_index = $use_id % PLAYER_DB_SET; //分区算法

		if (isset(self::$selected_db_info)){
			if($db_index == self::$selected_db_info->id){
				//Logger::getLogger()->debug("selectDbForUser db_index == self::selected_db_info->id");
				return true;
			}
		}

		$pdi = self::$player_db_info[$db_index];
		if (empty($pdi)){
			//Logger::getLogger()->fatal("failed to find db info for user:{$use_id},use default config instead.");
			self::$selected_db_info = self::$default_db_config;
			self::$selected_user = null;
		}
		else{
			//Logger::getLogger()->debug("selectDbForUser ".$pdi->dbname);
			self::$selected_db_info = $pdi;
			self::$selected_user = $use_id;
		}

	}

	static function selectDefaultDb()
	{
		/*if (empty(self::$instance)){
			self::getInstance();
		}else{
			self::$selected_db_info = self::$default_db_config;
		}
		self::$selected_user = null;*/
	}

	function MySQL()
	{
// 		if(empty(self::$default_db_config)){
// 		   $dbi = new PlayerDbInfo();
// 		   $dbi->id = -1;
// 		   $dbi->address = $GLOBALS['DATABASE_HOST'];
// 		   //$dbi->port = 3306;
// 		   $dbi->user = $GLOBALS['DATABASE_USER'];
// 		   $dbi->password = $GLOBALS['DATABASE_PASSWORD'];
// 		   $dbi->dbname = $GLOBALS['DATABASE_DB_NAME'];
// 		   self::$default_db_config = $dbi;
// 		   //使用默认配置
// 		   if(empty(self::$selected_db_info)){
// 		   	self::$selected_db_info = self::$default_db_config;
// 		   }
// 		}
	}

    /**
     * @static
     * @return MySQL
     */
    static function &getInstance()
    {
        if (empty(self::$currentDbFlag) && isset($_SERVER['FASTCGI_PLAYER_SERVER'])) {
            //用户所在游戏库
            $dbFlag = $_SERVER['FASTCGI_PLAYER_SERVER'];
        } else {
            $dbFlag = self::$currentDbFlag;
        }

        //设置一个默认的调试用
        if (empty($dbFlag)) {
            $dbFlag = "9999";
        }

        if (isset(self::$instanceArr[$dbFlag]) && !empty(self::$instanceArr[$dbFlag])) {
            return self::$instanceArr[$dbFlag];
        }

        //判断连接目标源
        switch ($dbFlag) {
            case self::WEB_MASTER_FLAG: //网站主库
                self::$instanceArr[$dbFlag] = & self::initWebMasterDbConnect();
                break;
            case self::WEB_SLAVE_FLAG: //网站从库
                self::$instanceArr[$dbFlag] = & self::initWebSlaveDbConnect();
                break;
            default: //其他游戏服
                if(isset($_SERVER['FASTCGI_PLAYER_SERVER']) && $dbFlag == $_SERVER['FASTCGI_PLAYER_SERVER']){
                    self::$instanceArr[$dbFlag] = & self::initGameDbConnect($dbFlag, self::$default_db_config);
                }else{
                    self::$instanceArr[$dbFlag] = & self::initGameDbConnect($dbFlag);
                }
                break;
        }

        return self::$instanceArr[$dbFlag];
    }

    /**
     * @param MySQL $mysql
     * @param PlayerDbInfo $dbInfo
     */
    private static function &tryConnectDb(&$mysql = null, &$dbInfo = null)
    {
        $mysql->Connect($dbInfo->address, $dbInfo->user, $dbInfo->password, $dbInfo->dbname);
        if ($mysql->link == false) {
            $mysql->Connect($dbInfo->address, $dbInfo->user, $dbInfo->password, $dbInfo->dbname);

            if ($mysql->link == false) {
                $mysql->Connect($dbInfo->address, $dbInfo->user, $dbInfo->password, $dbInfo->dbname);

                if ($mysql->link == false) {
                    Logger::getLogger()->fatal("Failed to connect to mysql,host:{$dbInfo->address},dbname:{$dbInfo->dbname} ");
                    die("Failed to init mysql connection!");
                }

            }
        }

        self::$current_use_db_config = $dbInfo;
        return $mysql;
    }

    //初始化web主库的连接
    private static function &initWebMasterDbConnect()
    {
        $mysql = new MySQL();

        $playerDbInfo = new PlayerDbInfo();
        $playerDbInfo->id = self::WEB_MASTER_FLAG;
        $playerDbInfo->address = WEB_DATABASE_HOST;
        $playerDbInfo->user = WEB_DATABASE_USER;
        $playerDbInfo->password = WEB_DATABASE_PASSWORD;
        $playerDbInfo->dbname = WEB_DATABASE_DB_NAME;
        $playerDbInfo->port = 3306;

        return self::tryConnectDb($mysql, $playerDbInfo);
    }

    //初始化web从库连接
    private static function &initWebSlaveDbConnect()
    {
        $mysql = new MySQL();

        $playerDbInfo = new PlayerDbInfo();
        $playerDbInfo->id = self::WEB_SLAVE_FLAG;
        $playerDbInfo->address = WEB_DATABASE_HOST;
        $playerDbInfo->user = WEB_DATABASE_USER;
        $playerDbInfo->password = WEB_DATABASE_PASSWORD;
        $playerDbInfo->dbname = WEB_DATABASE_DB_NAME;
        $playerDbInfo->port = 3306;

        return self::tryConnectDb($mysql, $playerDbInfo);
    }

    private static function &initGameDbConnect($serverFlag, $dbinfo = null)
    {
        $mysql = new MySQL();
        if (empty($dbinfo)) {
            $playerDbInfo = self::getServerDBInfo($serverFlag);
        } else {
            $playerDbInfo = $dbinfo;
        }

        return self::tryConnectDb($mysql, $playerDbInfo);
    }

    /**
     * @param $serverFlag 服务器标识
     * @return PlayerDbInfo
     */
    public static function getServerDBInfo($serverFlag)
    {
        $serverConnInfo = new PlayerDbInfo();
        $serverConnInfo->address = DATABASE_HOST;
        $serverConnInfo->user = DATABASE_USER;
        $serverConnInfo->password = DATABASE_PASSWORD;
        $serverConnInfo->dbname = DATABASE_DB_NAME;
        $serverConnInfo->id = $serverFlag;
        $serverConnInfo->port = 3306;

        return $serverConnInfo;
    }


    function Connect($hostname, $username, $password, $dbname, $pconnect = true, $character_set = true)
	{
		$start =  microtime(TRUE);


		if ($pconnect)
		{
			$this->link = mysql_pconnect($hostname, $username, $password);
		}
		else
		{
			$this->link = mysql_connect($hostname, $username, $password);
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
			mysql_query("SET NAMES utf8", $this->link);

			// For MySQL 5.0.1 +
			mysql_query("SET sql_mode = ''", $this->link);
		}

        $this->hostname = $hostname;
        $this->username = $username;
        $this->password = $password;
        $this->dbname = $dbname;

		self::$connect_time += (microtime(TRUE) - $start);

		return true;
	}

	function Disconnect()
	{
		//global $db_total_query, $db_total_cache_query;
		if($this->link)
		{
			if (mysql_close($this->link))
			{
				//$db_query_log = self::$query_log;

				return true;
			}
		}

		return false;
	}

	function RunQuery($query, $show_error = true)
	{
		global $db_total_query;

	   	$db_total_query++;

	   	$start =  microtime(TRUE);

	    if (DEBUG == true)
	    {
		    self::$query_log .= "\nDB: " . $this->dbname . ': ' . $query;
		}

	    $resource = mysql_query($query, $this->link);

	    //MySQL server has gone away
		//Lost connection to MySQL server during query

	    if ((mysql_errno($this->link) OR mysql_error($this->link)) AND $show_error)
	    {
	        $this->PrintError($query, mysql_errno($this->link), mysql_error($this->link));
	        return 0;
	    }

	    self::$query_time += (microtime(TRUE)-$start);

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

	function FetchArray($result, $array_type = MYSQL_BOTH)
	{
		return mysql_fetch_array($result, $array_type);
	}

	/**
	 * @desc   get assoc rows
	 * @param  $result
	 */
	function FetchAssoc($result) {
	    return mysql_fetch_assoc($result);
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
		return mysql_num_rows($resource);
	}

	function GetNumFields($resource)
	{
		return mysql_num_fields($resource);
	}

	function GetAffectRows() {
	    return mysql_affected_rows();
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
	 * param $table
	 * param $fieldName
	 * param $value
	 * return bool
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
	//	$this->RunQuery( "BEGIN" ); //开始事务
	}
	function Commit()
	{
	//	$this->RunQuery( "COMMIT" ); //结束事务
	}
	function Rollback()
	{
//		$this->RunQuery( "ROLLBACK" ); //结束事务
	}

    /**
     * @param null $currentDbFlag
     */
    public static function setCurrentDbFlag($currentDbFlag = null)
    {
        self::$currentDbFlag = $currentDbFlag;
    }

    /**
     * @return null
     */
    public static function getCurrentDbFlag()
    {
        return self::$currentDbFlag;
    }

    /**
     * 模拟PDO的绑定绑定变量做法
     *
     * 实际上是bindValue,没有做变量的带入
     * @param $sql
     * @param $key
     * @param $value
     * @param int $type
     */
    public function bindValue(&$sql, $key, $value, $type = 2)
    {
        $sql = str_replace($key, "'" . mysql_real_escape_string($value) . "'", $sql);
    }

}


class PlayerDbInfo
{
	var $id;
	var $address;
	var $port;
	var $user;
	var $password;
	var $dbname;
}
