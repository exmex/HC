<?php

if (!isset($GLOBALS['GAME_ROOT']) || empty($GLOBALS['GAME_ROOT'])) {
    $GLOBALS['GAME_ROOT'] = realpath(dirname(__FILE__) . '/../') . '/';
}
/**
 * Logger
 */
require_once($GLOBALS['GAME_ROOT'] . "Log/LoggerConfig.php");

class Logger
{
    var $logDebug = false;
    var $logWarn = false;
    var $logInfo = false;
    var $logError = false;
    var $logFatal = false;

    var $logToFile = false;
    var $logToScreen = false;

    var $file;

    static $log_time = 0.0;

    static $instance = null;

    private function Logger()
    {
        if (defined('LOG_DEBUG_'))
            $this->logDebug = LOG_DEBUG_;
        if (defined('LOG_WARN_'))
            $this->logWarn = LOG_WARN_;
        if (defined('LOG_INFO_'))
            $this->logInfo = LOG_INFO_;
        if (defined('LOG_ERROR_'))
            $this->logError = LOG_ERROR_;
        if (defined('LOG_FATAL_'))
            $this->logFatal = LOG_FATAL_;
        if (defined('LOG_TO_FILE_'))
            $this->logToFile = LOG_TO_FILE_;
        if (defined('LOG_TO_SCREEN_'))
            $this->logToScreen = LOG_TO_SCREEN_;

        if ($this->logToFile) {
            $createNewFile = (file_exists(LOG_FILE) === false);

            $this->file = fopen(LOG_FILE, 'a+');
            if ($createNewFile) {
                $this->createDir(dirname(LOG_FILE));
                @chmod(LOG_FILE, 0777);
            }
        }
    }

    /**
     *创建文件平时要用
     */
    function createDir($path)
    {
        if (!file_exists($path)) {
            $this->createDir(dirname($path));
            mkdir($path, 0777);
        }
    }

    function __destruct()
    {
        if ($this->logToFile) {
            fclose($this->file);
        }
    }

    static function &getLogger()
    {
        if (empty(self::$instance)) {
            self::$instance = new Logger();
        }

        return self::$instance;
    }

    private function callstackmsg()
    {
        $trace = debug_backtrace();

        $stack = $trace[1];

        $file = isset($stack['file']) ? $stack['file'] : '';
        $index = strrpos($file, '\\');
        if ($index) {
            $file = substr($file, ($index + 1));
        }

        $line = isset($stack['line']) ? $stack['line'] : '';
        return $file . ":" . $line;
    }

	private function getUSATime()
    {
		$date = new DateTime("now", new DateTimeZone("Asia/Shanghai"));
		$format = "Y-m-d H:i:s";
		return $date->format($format);
    }
    
    private function log($m)
    {
        $start = microtime(true);
        $date = $this->getUSATime();
        $uid = "-1";
        $ip = "0.0.0.0";
        $port = "";
        $socket = "";

        if (isset($GLOBALS['USER_ID'])) {
            $uid = $GLOBALS['USER_ID'];
        }
        if (isset($_SERVER ["REMOTE_ADDR"])) {
            $ip = $_SERVER ["REMOTE_ADDR"];
        }
        $l = "{$date}__UID:{$uid}__{$ip}{$m}";
        if ($this->logToFile) {
            @fwrite($this->file, $l, strlen($l));
        }

        if ($this->logToScreen) {
            echo $l;
        }
        self::$log_time += (microtime(true) - $start);
    }

    function debug($msg)
    {
        if ($this->logDebug) {
            $line = $this->callstackmsg();
            $this->log("-DEBUG (" . $line . ") - " . strval($msg) . "\r\n");
        }
    }

    function warn($msg)
    {
        if ($this->logWarn) {
            $line = $this->callstackmsg();
            $this->log("-WARN (" . $line . ") - " . strval($msg) . "\r\n");
        }
    }

    function info($msg)
    {
        if ($this->logInfo) {
            $line = $this->callstackmsg();
            $this->log("-INFO (" . $line . ") - " . strval($msg) . "\r\n");
        }
    }

    function error($msg)
    {
        if ($this->logError) {
            $line = $this->callstackmsg();
            $this->log("-ERROR (" . $line . ") - " . strval($msg) . "\r\n");
        }
    }

    function fatal($msg)
    {
        if ($this->logFatal) {
            $line = $this->callstackmsg();
            $this->log("-FATAL (" . $line . ") - " . strval($msg) . "\r\n");
        }
    }
}

?>
