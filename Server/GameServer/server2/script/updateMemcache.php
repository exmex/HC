<?php
$this_file_path = realpath(dirname(__FILE__) . "/../") . '/';
require_once($this_file_path . "config.php");
require_once($GLOBALS ['GAME_ROOT'] . 'CMySQL.php');

function main()
{
    require_once($GLOBALS['GAME_ROOT'] . "Classes/DataModule.php");;
    require_once($GLOBALS['GAME_ROOT'] . "Classes/ServerModule.php");
    require_once($GLOBALS['GAME_ROOT'] . "Classes/MessageProcessor.php");

    // update lua data cache
    DataModule::updateCache();

    // update server list cache
    ServerModule::updateServerListCache();

    // update server version cache
    MessageProcessor::getServerVersion(1, true);
    MessageProcessor::getServerVersion(2, true);
}

main();
