<?php
/**
 * Helper class for generating source code
 */
require_once "../config.php";
require_once($GLOBALS['GAME_ROOT'] . "Protocol/XByteArray.php");
require_once($GLOBALS['GAME_ROOT'] . "Classes/AESMcryptMgr.php");

require_once($GLOBALS['GAME_ROOT'] . "ProtoSource/DotaCryptMsgInfo.php");
require_once($GLOBALS['GAME_ROOT'] . "ProtoSource/pb_proto_bcdown.php");
require_once($GLOBALS['GAME_ROOT'] . "ProtoSource/pb_proto_bcup.php");
require_once($GLOBALS['GAME_ROOT'] . "ProtoSource/pb_proto_down.php");
require_once($GLOBALS['GAME_ROOT'] . "ProtoSource/pb_proto_up.php");

$index = 17;
$destAll = DotaCryptMsgInfo::$ServerMsg[$index];

$isUseSessionKey = true;
if ($index == _DOTA_ClientInterface::SdkLogin_0) {
    $isUseSessionKey = false;
}

$by = new XByteArray();
$by->set_data($destAll);
// head two is all length (4 byte)
$tmp = $by->readBinary(4);

$len = $by->getBytesAvailable();
$dest = $by->readBinary($len);

// decrypt code
$crypt2 = new AESMcryptMgr();
if ($isUseSessionKey) {
    $crypt2->setKey("6de3a89479151c70df955dafe68ba0c6");
} else {
    $crypt2->setKey("182173557");
}

$dest1 = $crypt2->decrypt($dest);
echo "\ndest1=" . BytesToString ($dest1, strlen($dest1), " ") . "\n";

$by = new XByteArray();
$by->set_data($dest1);
$count1 = $by->readByte();
$count2 = $by->readByte();
$count3 = $by->readByte();
$count4 = $by->readByte();
$msgLen = $count4 * 256 * 256 * 256 + $count3 * 256 * 256 + $count2 * 256 + $count1;
$desc2 = $by->readBinary($msgLen);
echo "\ndesc2=" . BytesToString ($desc2, strlen($desc2), " ") . "\n\n";

$newObj = new Down_DownMsg();
$newObj->parseFromString($desc2);

ob_start();
$newObj->dump(true, 5);
$echoLog = ob_get_contents();
ob_end_clean();

print_r($echoLog);

exit;
