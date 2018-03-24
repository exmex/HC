<?php
if (!isset ($GLOBALS ['GAME_ROOT']) || empty ($GLOBALS ['GAME_ROOT'])) {
    $GLOBALS ['GAME_ROOT'] = realpath(dirname(__FILE__) . '/../') . '/';
}

require_once($GLOBALS ['GAME_ROOT'] . "Log/LoggerConfig.php");

class LogClient
{

    var $file;

    static $instance;

    private function LogClient()
    {
        $this->file = fopen(LOG_CLIENT_FILE, 'a+');
    }

    function __destruct()
    {
        fclose($this->file);

    }

    /**
     * @static
     * @return LogClient
     */
    public static function &getInstance()
    {
        if (!isset (self::$instance)) {
            self::$instance = new LogClient ();
        }

        return self::$instance;
    }

    private function callstackmsg()
    {
        $trace = debug_backtrace();

        $stack = $trace [1];

        $file = isset ($stack ['file']) ? $stack ['file'] : '';
        $index = strrpos($file, '\\');
        if ($index) {
            $file = substr($file, ($index + 1));
        }
        $line = isset ($stack ['line']) ? $stack ['line'] : '';

        return $file . ":" . $line;
    }

    private function log($msg)
    {
        $l = $this->getUSATime() . $msg;
        fwrite($this->file, $l, strlen($l));
    }

    private function getUSATime()
    {
        $date = new DateTime("now", new DateTimeZone("Asia/Shanghai"));
        $format = "Y-m-d H:i:s";
        return $date->format($format);
    }

    public function logLogin($userId)
    {
        $line = $this->callstackmsg();
        $this->log("-LOGIN ({$line}) - {$userId}\r\n");
    }

    public function logLogout($userId)
    {
        $line = $this->callstackmsg();
        $this->log("-LOGOUT ({$line}) - {$userId}\r\n");
    }

    public function logAddHero($userId, $reason, $heroId, $rank, $star)
    {
        $line = $this->callstackmsg();
        $this->log("-ADDHERO ({$line}) - {$userId}__{$reason}__{$heroId}__{$rank}__{$star}__\r\n");
    }

    public function logAddItem($userId, $reason, $item, $hasCount, $afterCount)
    {
        $line = $this->callstackmsg();
        $this->log("-ADDITEM ({$line}) - {$userId}__{$reason}__{$item}__{$hasCount}__{$afterCount}__\r\n");
    }

    public function logUseItem($userId, $reason, $item, $hasCount, $afterCount)
    {
        $line = $this->callstackmsg();
        $this->log("-USEITEM ({$line}) - {$userId}__{$reason}__{$item}__{$hasCount}__{$afterCount}__\r\n");
    }

    public function logDelItem($userId, $reason, $item, $hasCount, $afterCount)
    {
        $line = $this->callstackmsg();
        $this->log("-DELITEM ({$line}) - {$userId}__{$reason}__{$item}__{$hasCount}__{$afterCount}__\r\n");
    }

    public function logMoneyChanged($userId, $reason, $moneyBefore, $moneyAfter)
    {
        $line = $this->callstackmsg();
        $this->log("-MONEYCHANGED ({$line}) - {$userId}__{$reason}__{$moneyBefore}__{$moneyAfter}__\r\n");
    }

    public function logGemChanged($userId, $reason, $gemBefore, $gemAfter)
    {
        $line = $this->callstackmsg();
        $this->log("-GEMCHANGED ({$line}) - {$userId}__{$reason}__{$gemBefore}__{$gemAfter}__\r\n");
    }

    public function logArenaPointChanged($userId, $reason, $pointBefore, $pointAfter)
    {
        $line = $this->callstackmsg();
        $this->log("-ARENAPOINTCHANGED ({$line}) - {$userId}__{$reason}__{$pointBefore}__{$pointAfter}__\r\n");
    }

    public function logCrusadePointChanged($userId, $reason, $pointBefore, $pointAfter)
    {
        $line = $this->callstackmsg();
        $this->log("-CRUSADEPOINTCHANGED ({$line}) - {$userId}__{$reason}__{$pointBefore}__{$pointAfter}__\r\n");
    }

    public function logPlyExpChanged($userId, $reason, $expBefore, $expAfter)
    {
        $line = $this->callstackmsg();
        $this->log("-PLAYEREXPCHANGED ({$line}) - {$userId}__{$reason}__{$expBefore}__{$expAfter}__\r\n");
    }

    public function logHeroExpChanged($userId, $reason, $heroTid, $expBefore, $expAfter)
    {
        $line = $this->callstackmsg();
        $this->log("-HEROEXPCHANGED ({$line}) - {$userId}__{$reason}__{$heroTid}__{$expBefore}__{$expAfter}__\r\n");
    }

    public function logVitChanged($userId, $reason, $vitBefore, $vitAfter)
    {
        $line = $this->callstackmsg();
        $this->log("-VITCHANGED ({$line}) - {$userId}__{$reason}__{$vitBefore}__{$vitAfter}__\r\n");
    }

    public function logGuildPointChanged($userId, $reason, $vitBefore, $vitAfter)
    {
        $line = $this->callstackmsg();
        $this->log("-GUILDPOINTCHANGED ({$line}) - {$userId}__{$reason}__{$vitBefore}__{$vitAfter}__\r\n");
    }
}

?>
