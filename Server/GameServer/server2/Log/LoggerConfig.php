<?php
    define('LOG_DEBUG_',true);
    define('LOG_WARN_' ,true);
    define('LOG_INFO_' ,true);
    define('LOG_ERROR_',true);
    define('LOG_FATAL_',true);
    
    //是否记录到文件
    define('LOG_TO_FILE_',true);
    //是否记录到屏幕
    define('LOG_TO_SCREEN_',false);
	
    //是否记录到db
    define('LOG_TO_DB_',true);
       
    //记录文件
    if(!isset($GLOBALS['log'])){
    	$GLOBALS['log'] = dirname(__FILE__)."/logs";
    }
    
    define('LOG_FILE',$GLOBALS['log']."/server_".date("Y-m-d").".log");
    define('LOG_CLIENT_FILE',$GLOBALS['log']."/logclient_".date("Y-m-d").".log");
    define('BATTLE_LOG_FILE',$GLOBALS['log']."/battle_".date("Y-m-d").".log");
    define('LOG_ACTION_FILE',$GLOBALS['log']."/action.log");
    
    define('LOG_PROFILE', $GLOBALS['log']."/profile_".date("Y-m-d").".log");
?>
