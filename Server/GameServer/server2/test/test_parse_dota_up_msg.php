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
//$index = _DOTA_ClientInterface::U41;
$destAll = DotaCryptMsgInfo::$ClientMsg[$index];

$isUseSessionKey = true;
if ($index == _DOTA_ClientInterface::SdkLogin_0) {
    $isUseSessionKey = false;
}

$by = new XByteArray();
$by->set_data($destAll);
// head three is all length (4 byte) and mode (1 byte)
$by->readBinary(5);

// next two is device length (2 byte)
$count1 = $by->readByte();
$count2 = $by->readByte();

// next some is device str
$deviceLen = $count2 * 256 + $count1;
$by->readBinary($deviceLen);

// remain is crypt code
$len = $by->getBytesAvailable();
$dest = $by->readBinary($len);
echo "\ndest=" . BytesToString ($dest, strlen($dest), " ") . "\n";

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
$pbLen = $count4 * 256 * 256 * 256 + $count3 * 256 * 256 + $count2 * 256 + $count1;
//$by->readInt16();

$byStr = $by->readBinary($pbLen);
echo "\nby=" . BytesToString ($byStr, $pbLen, " ") . "\n";
echo "\nlen=" . $pbLen . "\n\n";

//$len = $by->getBytesAvailable();
//$byStr = $by->readBinary($len - 1);
//echo "\nby=" . BytesToString ($byStr, $len, " ") . "\n";
//echo "\nlen=" . $len . "\n";

$newObj = new Up_UpMsg();
$newObj->parseFromString($byStr);

ob_start();
$newObj->dump(true, 5);
$echoLog = ob_get_contents();
ob_end_clean();

print_r($echoLog);

exit;