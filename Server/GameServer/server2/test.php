<?php

$_SERVER ['FASTCGI_PLAYER_SERVER'] = "155557";
require_once "global.php";
require_once($GLOBALS ['GAME_ROOT'] . "config.php");

//initServerConfig($_SERVER ['FASTCGI_PLAYER_SERVER']);

require_once($GLOBALS['GAME_ROOT'] . "WorldSvc.php");
//require_once($GLOBALS['GAME_ROOT'] . "Controller/OnLogin.php");

$GLOBALS ['USER_ID'] = 5;

require_once($GLOBALS['GAME_ROOT'] . "Controller/OnEnterStage.php");

$exitStage = new Up_EnterStage();
$exitStage->setStageId(19);


$enterReply = EnterStageApi(new WorldSvc(), $exitStage);

//$table2 = HeroModule::getAllHeroTable(5);

exit;
