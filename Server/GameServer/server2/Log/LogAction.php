<?php
if (!isset ($GLOBALS ['GAME_ROOT']) || empty ($GLOBALS ['GAME_ROOT'])) {
    $GLOBALS ['GAME_ROOT'] = realpath(dirname(__FILE__) . '/../') . '/';
}

require_once($GLOBALS ['GAME_ROOT'] . "Log/LoggerConfig.php");
require_once($GLOBALS ['GAME_ROOT'] . "Log/ActionLog.php");

class LogAction
{

    var $file;

    static $instance;

    private function LogAction()
    {
        $this->file = fopen(LOG_ACTION_FILE, 'a+');
    }

    function __destruct()
    {
        fclose($this->file);

    }

    /**
     * @static
     * @return LogAction
     */
    public static function &getInstance()
    {
        if (!isset (self::$instance)) {
            self::$instance = new LogAction();
        }

        return self::$instance;
    }

    public function log($act, $params)
    {
    	$userId = $GLOBALS['USER_ID'];
    	try {
    		$log = new ActionLog($userId, $act, $params);
    		$msg = $log->getLogString() . "\n";
    		fwrite($this->file, $msg, strlen($msg));
    		$log = null;
    	} catch ( Exception $e )
    	{
    		
    	}
    }
}

?>
