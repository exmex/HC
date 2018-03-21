<?php

require_once("config.php");

require_once($GLOBALS ['GAME_ROOT'] . "WorldSvc.php");
require_once($GLOBALS ['GAME_ROOT'] . "CMySQL.php");

require_once($GLOBALS['GAME_ROOT'] . "Classes/ServerModule.php");
require_once($GLOBALS['GAME_ROOT'] . "Classes/TavernModule.php");

TavernModule::autoInitMagicDaySoul();
exit;