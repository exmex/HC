<?php
error_reporting(E_ALL);
ini_set('display_errors', '1');
ini_set('display_startup_errors', 1);
ini_set('error_log', dirname(__FILE__) . '/error_log.txt');
error_reporting(-1);
//var_dump(gc_enabled());

set_time_limit(0);

$GLOBALS['beginTime'] = time();

//date_default_timezone_set('US/Pacific');
date_default_timezone_set('Asia/Shanghai');


require_once("../config.php");
require_once("SiteInterface.php");

function main()
{
    $s = new SiteInterface();

    $GLOBALS['USER_ID'] = 1000011;

    $s->updateUserPayMoneyAndVipLevel(1000011, 407);
}

main();