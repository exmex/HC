<?php

//脚本执行错误判断,给记录错误使用
$isRunError = false;

function shutdown()
{
    global $isRunError;
    // This is our shutdown function, in
    // here we can do any last operations
    // before the script is complete.
    if ($isRunError == false) {
        $errMsg = ob_get_contents();
        print($errMsg);
        ob_flush();

        if (!isset($GLOBALS['INPUT_DATA'])) {
            $GLOBALS['INPUT_DATA'] = "";
        }

        $errMsg = str_replace("\n", "", $errMsg);
        $errMsg = str_replace("\r", "", $errMsg);

        if (strlen($errMsg) > 0) {
            $GLOBALS['GAME_ROOT'] = dirname(__FILE__) . "/";
            require_once($GLOBALS['GAME_ROOT'] . "Log/Logger.php");
            Logger::getLogger()->error("PHP_SERVER_RUNNING_SCRIPT_ERROR:::" . $errMsg . "\r\n");
        }
    }
}

register_shutdown_function('shutdown');

//语法错误不会走这个方法
function catchs($errno, $errstr, $errfile, $errline)
{
    $message = array(
        'Message' => $errstr,
        'Code' => $errno,
        'Line' => $errline,
        'File' => $errfile,
        'Trace' => debug_backtrace()
    );

    $GLOBALS['GAME_ROOT'] = dirname(__FILE__) . "/";

    switch ($errno) {
        case E_USER_ERROR:
            require_once($GLOBALS['GAME_ROOT'] . "Log/Logger.php");
            Logger::getLogger()->error("PHP_SERVER_RUNNING_USER_ERROR:::" . print_r($message, true));
            //exit(1);
            break;
        case E_USER_WARNING:
            require_once($GLOBALS['GAME_ROOT'] . "Log/Logger.php");
            Logger::getLogger()->error("PHP_SERVER_RUNNING_USER_WARNING:::" . print_r($message, true));
            break;
        case E_USER_NOTICE:
            break;
        default:
            break;
    }

    /* Don't execute PHP internal error handler */
    return true;
}

set_error_handler('catchs');


function translateHeader($name)
{
    if (isset($_SERVER["HTTP_" . $name]))
        $_SERVER[$name] = $_SERVER["HTTP_" . $name];
}

function exec_gate_way($svc_class)
{
    global $isRunError;

    require_once("config.php");
    require_once($GLOBALS['GAME_ROOT'] . "Protocol/proxy_idl.php");

    $start_time = microtime(TRUE);
    if (!isset($_SERVER[_ECUSTOM_HEADER::socket_id])) {
        //should using http protocol to access the gateway, translate it before process
        //
        translateHeader(_ECUSTOM_HEADER::socket_id);
        translateHeader(_ECUSTOM_HEADER::proxy_id);
        translateHeader("FASTCGI_PLAYER_USER_ID");
        translateHeader("FASTCGI_REQUEST_PACKET_ID");
        translateHeader("REMOTE_ADDR");
        translateHeader("REMOTE_PORT");
        translateHeader("FASTCGI_PLAYER_SERVER");
    }

    $GLOBALS['INPUT_DATA'] = $post_data = file_get_contents('php://input');

    header(_ECUSTOM_HEADER::socket_id . ": " . $_SERVER[_ECUSTOM_HEADER::socket_id]);

    ob_start();

 /*   if (empty($_SERVER['FASTCGI_PLAYER_SERVER'])) {
        $_SERVER['FASTCGI_PLAYER_SERVER'] = 9999;
    }
    $GLOBALS['SERVERID'] = $server = $_SERVER['FASTCGI_PLAYER_SERVER'];
*/
    /*if (checkMergeServer($server)) {
        echo 'server = ' . $server . "\n";
        return;
    }*/

    require_once($GLOBALS['GAME_ROOT'] . "Log/Logger.php");
    require_once($GLOBALS['GAME_ROOT'] . "runtime.php");
    require_once($GLOBALS['GAME_ROOT'] . "CMySQL.php");
    require_once($GLOBALS['GAME_ROOT'] . "CMemcache.php");

    //$rt = new runtime;
    //$rt->start();   

    if (isset($_SERVER['FASTCGI_PLAYER_USER_ID']))
        $GLOBALS['USER_ID'] = $_SERVER["FASTCGI_PLAYER_USER_ID"];


    $startLogStr = "";
    if (isset($_SERVER['FASTCGI_REQUEST_PACKET_ID']))
        $startLogStr .= "Receiced: " . $_SERVER['FASTCGI_REQUEST_PACKET_ID'];
    if (isset($_SERVER['REMOTE_ADDR']))
        $startLogStr .= " Request User Ip: " . $_SERVER['REMOTE_ADDR'];

    Logger::getLogger()->info($startLogStr);


    require_once($svc_class . ".php");
    $svc = new $svc_class();

    $ret = 0;

    $_SERVER['GAME_SERVER_INSTANCE'] = $svc;

    if (isset($_SERVER['PLAYER_DB_INFO'])) {
        //MySQL::initDbInfo($_SERVER['PLAYER_DB_INFO']); //init player db information
    }
    try {
        if (false) {
            require_once($GLOBALS['GAME_ROOT'] . "Protocol/XByteArray.php");
            Logger::getLogger()->debug("DUMP POST_DATA: " . BytesToString($post_data, strlen($post_data), ""));
        }

        $ret = $svc->HandleReceivedData($post_data);
    } catch (Exception $e) {
        print($e->getMessage());
    }

    MySQL::getInstance()->Disconnect();
    CMemcache::closeReally();
    $errMsg = ob_get_contents();
    if (strlen($errMsg) > 0) {
        Logger::getLogger()->error(strlen($errMsg) . ":" . $errMsg);

        //	if (!DEBUG)	
        //	{
        //		ob_get_clean ();
        //	}
        //	else
        //{
        header(_ECUSTOM_HEADER::php_err_length . ": " . strlen($errMsg));
        //}
    }

    if ($ret < 0) {
        header(_ECUSTOM_HEADER::proto_error_code . ": " . $ret);
    } else {
        /*if (strlen($svc->response_data) > 1000) {
            $ucharData = $svc->response_data;
            $svc->response_data = "";
            $zipData = gzcompress($ucharData);
            $svc->SendSendZipData($zipData);
        }*/

        header(_ECUSTOM_HEADER::content_type . ": " . _ECUSTOM_HEADER::x_proto_type);
        header(_ECUSTOM_HEADER::content_length . ": " . strlen($svc->response_data));

        $isRunError = true;
        print($svc->response_data);
    }
    ob_flush();

    //$rt->stop();
    $run_time = microtime(TRUE) - $start_time;
    Logger::getLogger()->info("[" . getmypid() . "] exec end time is: " . $run_time . " MYSQL connect time:" . MySQL::$connect_time . " query time:" . MySQL::$query_time . " WriteLogTime:" 
    		. Logger::$log_time ." mcReadTime:". CMemcache::$memcache_read_time 
    		." mcWriteTime:" . CMemcache::$memcache_write_time);
}

function checkMergeServer($serverId)
{
    $mergeServers = array();

    if (in_array($serverId, $mergeServers)) {
        return true;
    }

    return false;
}
