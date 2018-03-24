<?php

if (! isset ( $GLOBALS ['GAME_ROOT'] ) || empty ( $GLOBALS ['GAME_ROOT'] )) {
	$GLOBALS ['GAME_ROOT'] = realpath ( dirname ( __FILE__ ) . '/../' ) . '/';
}

require_once ($GLOBALS ['GAME_ROOT'] . "Log/LoggerConfig.php");

class LogProfile {
	
	var $file;
	
	static $instance;
	
	private function LogProfile() {
		$this->file = fopen ( LOG_PROFILE, 'a+' );
	}
	
	function __destruct() {
		fclose ( $this->file );
	
	}
	
	/**
	 * @static
	 * @return LogProfile
	 */
	public static function &getInstance() {
		if (! isset ( self::$instance )) {
			self::$instance = new LogProfile ();
		}
	
		return self::$instance;
	}
	
	
	public function log($msg)
	{
		$date = $this->getUSATime();
		$uid = "-1";
		$ip = "0.0.0.0";
		$port = "0";
		$socket = "0";
		
		if (isset($GLOBALS['USER_ID'])) {
			$uid = $GLOBALS['USER_ID'];
		}
		if (isset($_SERVER ["REMOTE_ADDR"])) {
			$ip = $_SERVER ["REMOTE_ADDR"];
		}
		if (isset($_SERVER["REMOTE_PORT"])) {
			$port = $_SERVER["REMOTE_PORT"];
		}
		if (isset($_SERVER["HTTP_SOCKET_ID"])) {
			$socket = $_SERVER["HTTP_SOCKET_ID"];
		}
		
		$l = "{$date}__UID:{$uid}__{$ip}:{$port}__{$socket}__{$msg}\r\n";
		
		@fwrite($this->file, $l, strlen($l));
	}
	
	private function getUSATime()
	{		
		$date = new DateTime("now", new DateTimeZone("Asia/Shanghai"));
		$format = "Y-m-d H:i:s";
		return $date->format($format);
	}
	
}



?>