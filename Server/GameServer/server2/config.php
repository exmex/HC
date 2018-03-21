<?php
/**
 * config
 */
$GLOBALS['GAME_ROOT'] = dirname(__FILE__) . "/";

// push client connection
define('PUSH_CLIENT_IP', 'unix:///tmp/dota-pushclient.sock');
// define('PUSH_CLIENT_IP',"127.0.0.1");

define('SERVER_PATH', $GLOBALS['GAME_ROOT'] . 'servers/');
//define('SERVER_PATH','/product/dota/beta/server/htdocs/servers/');

//web mysql database 网站库配置
define('WEB_DATABASE_HOST', '127.0.0.1');
define('WEB_DATABASE_USER', 'root');
define('WEB_DATABASE_PASSWORD', '');
define('WEB_DATABASE_DB_NAME', 'dota');

// proxy mysql database
define('PROXY_DATABASE_HOST', '127.0.0.1');
define('PROXY_DATABASE_USER', 'root');
define('PROXY_DATABASE_PASSWORD', '');
define('PROXY_DATABASE_DB_NAME', 'dota');

//游戏数据库配置
define('DATABASE_HOST', '127.0.0.1');
define('DATABASE_USER', 'root');
define('DATABASE_PASSWORD', '');
define('DATABASE_DB_NAME', 'dota');

define("MEMCACHE_INFO",
    '$MEMCACHE_INFO = array(
        array("HOST" => "127.0.0.1", "PORT" => 11211)
    );'
);

// is debug
define('DEBUG', true);
define('SIG_KEY', '_-+agjas1425((235#lkjsdflkjsfj^(%kljsdf(f@#$SDFtxyugisdrfg');

//LOCAL AAT ALPHA LATEST BETA PRODUCTION PRODUCTION_CANDIDATE
define('GAME_VERSION','ALPHA');

//定义日志路径
$GLOBALS['log'] = $GLOBALS['GAME_ROOT'] . "Log/logs/";

define('GameID', 'legend'); //游戏
define('ENABLE_GM_CMD', true);
define('Server_Version', '2.000.0');
define('OpenRc4Encrypt',false); //是否启用多层加密
//服务器状态：0灰度中， 1正式开服
define('SERVER_STATUS', json_encode(array(1,2,3)));