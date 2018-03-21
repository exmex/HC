<?php
error_reporting(E_ALL);
ini_set('display_errors', '1');
ini_set('display_startup_errors', 1);
ini_set('error_log', dirname(__FILE__) . '/error_log.txt');
error_reporting(-1);
//var_dump(gc_enabled());

set_time_limit(0);

$GLOBALS['beginTime'] = time();

date_default_timezone_set('US/Pacific');

//$_SERVER ['FASTCGI_PLAYER_SERVER'] = "9999";
require_once("../../server2/config.php");
//require_once ($GLOBALS ['GAME_ROOT'] . "config.php");

//initServerConfig($_SERVER ['FASTCGI_PLAYER_SERVER']);

require_once($GLOBALS['GAME_ROOT'] . "WorldSvc.php");
//require_once($GLOBALS['GAME_ROOT'] . "reflector/OnLogin.php");
$GLOBALS ['USER_ID'] = 3;
$_SERVER ['FASTCGI_PLAYER_SERVER'] = "9999";

require_once($GLOBALS['GAME_ROOT'] . "manager/MathUtil.php");
require_once($GLOBALS['GAME_ROOT'] . "manager/ShopManager.php");
require_once($GLOBALS['GAME_ROOT'] . "manager/MathUtil.php");
require_once($GLOBALS['GAME_ROOT'] . "manager/TavernManager.php");
require_once($GLOBALS['GAME_ROOT'] . "manager/EquipManager.php");
require_once($GLOBALS['GAME_ROOT'] . "manager/GuildManager.php");
require_once($GLOBALS['GAME_ROOT'] . "manager/DataManager.php");


$payDefines = DataManager::getInstance()->getDataSetting(RECHARGE_LUA_KEY);

foreach ($payDefines as $key => $vArr) {
    if (isset($vArr['Cost'])) {
        /*if($key == 301){
            $payDefines[$key]['Cost'] = sprintf("%0.0f", $vArr['Cost']);
        }elseif($key == 401){
            $payDefines[$key]['Cost'] = sprintf("%0.2f", $vArr['Cost']);
        }else{
            $payDefines[$key]['Cost'] = sprintf("%0.1f", $vArr['Cost']);
        }*/

        $payDefines[$key]['Cost'] = sprintf("%0.2f", $vArr['Cost']);
    }
}


$payInfo = "<?php return " . var_export($payDefines, true) . ";";

//支付信息配置文件
$filename = $GLOBALS['GAME_ROOT'] . "../../web/src/protected/config/pay/paydefine.php";

write_file($filename, $payInfo);

$payDefines = DataManager::getInstance()->getDataSetting(RECHARGE_ALPHA_LUA_KEY);

foreach ($payDefines as $key => $vArr) {
    if (isset($vArr['Cost'])) {
        /*if($key == 301){
            $payDefines[$key]['Cost'] = sprintf("%0.0f", $vArr['Cost']);
        }elseif($key == 401){
            $payDefines[$key]['Cost'] = sprintf("%0.2f", $vArr['Cost']);
        }else{
            $payDefines[$key]['Cost'] = sprintf("%0.1f", $vArr['Cost']);
        }*/

        $payDefines[$key]['Cost'] = sprintf("%0.2f", $vArr['Cost']);
    }
}


$payInfo = "<?php return " . var_export($payDefines, true) . ";";

//支付信息配置文件
$filename = $GLOBALS['GAME_ROOT'] . "../../web/src/protected/config/pay/paydefineAlpha.php";

write_file($filename, $payInfo);


//for production
$payDefines = DataManager::getInstance()->getDataSetting(RECHARGE_PRODUCTION_LUA_KEY);

foreach ($payDefines as $key => $vArr) {
    if (isset($vArr['Cost'])) {
        /*if($key == 301){
            $payDefines[$key]['Cost'] = sprintf("%0.0f", $vArr['Cost']);
        }elseif($key == 401){
            $payDefines[$key]['Cost'] = sprintf("%0.2f", $vArr['Cost']);
        }else{
            $payDefines[$key]['Cost'] = sprintf("%0.1f", $vArr['Cost']);
        }*/

        $payDefines[$key]['Cost'] = sprintf("%0.2f", $vArr['Cost']);
    }
}


$payInfo = "<?php return " . var_export($payDefines, true) . ";";

//支付信息配置文件
$filename = $GLOBALS['GAME_ROOT'] . "../../web/src/protected/config/pay/paydefineProduction.php";

write_file($filename, $payInfo);

function write_file($filename, $data, $method = "rb+", $iflock = 1)
{
    @touch($filename);
    $handle = @fopen($filename, $method);
    if ($iflock) {
        @flock($handle, LOCK_EX);
    }
    @fputs($handle, $data);
    if ($method == "rb+") @ftruncate($handle, strlen($data));
    @fclose($handle);
    @chmod($filename, 0777);
    if (is_writable($filename)) {
        return 1;
    } else {
        return 0;
    }
}


exit;