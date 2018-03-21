<?php

require_once "../config.php";
require_once($GLOBALS['GAME_ROOT'] . "Protocol/game_idl.php");
require_once($GLOBALS['GAME_ROOT'] . "Protocol/XByteArray.php");
require_once($GLOBALS['GAME_ROOT'] . "Protocol/XPACKET_DoLogin.php");
require_once($GLOBALS['GAME_ROOT'] . "Protocol/XPACKET_SendPing.php");
require_once($GLOBALS['GAME_ROOT'] . "Protocol/XPACKET_OnPong.php");

require_once($GLOBALS['GAME_ROOT'] . "Classes/AESMcryptMgr.php");

//
//$c = XPACKET_DoLogin::_ClassFromParameters("1", "", "" ,"");
//$buff = new XByteArray();
//$c->ToBuffer($buff);
//$str = BytesToString($buff->raw_data, strlen($buff->raw_data), "0x ");


$c = XPACKET_OnPong::_ClassFromParameters("1403778952000");
$buff = new XByteArray();
$len = $c->ToBuffer($buff);
$str = BytesToString($buff->raw_data, strlen($buff->raw_data), " ");

echo $str;
exit;