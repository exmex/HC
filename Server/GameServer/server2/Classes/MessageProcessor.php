<?php
require_once($GLOBALS['GAME_ROOT'] . "Protocol/XByteArray.php");
require_once($GLOBALS['GAME_ROOT'] . "Classes/AESMcryptMgr.php");
require_once($GLOBALS['GAME_ROOT'] . "Classes/PlayerCacheModule.php");
require_once($GLOBALS['GAME_ROOT'] . "Classes/CommonModule.php");
require_once($GLOBALS['GAME_ROOT'] . "Classes/RegisterModule.php");
require_once($GLOBALS['GAME_ROOT'] . "DbModule/SysUser.php");
define("PLAYER_REGISTER_QUANTITY_LIMIT", 50000);
class MessageProcessor
{
    private static $MessageCached = null;
    private static $VersionCached = null;

    public static function DecodeMessage($input)
    {
        $byArr = new XByteArray();
        $byArr->set_data($input);
        $mode = intval($byArr->readByte());
        $count1 = $byArr->readByte();
        $count2 = $byArr->readByte();
        $uinLen = $count2 * 256 + $count1;

        // user id
        $uin = $byArr->readBinary($uinLen);
        $GLOBALS['USER_PUID'] = $uin;
        $cryptCodeLen = $byArr->getBytesAvailable();
        $cryptCode = $byArr->readBinary($cryptCodeLen);
        $tbUserInfo = PlayerCacheModule::getUserInfoData($uin, $mode);
        $GLOBALS['SERVERID'] =  $_SERVER['FASTCGI_PLAYER_SERVER'] = self::GetServerId($uin);
        Logger::getLogger()->debug("OnProtoBuff Process Star".$GLOBALS['SERVERID']);
       
        if(empty($tbUserInfo))
        {
            $AllUserTotalArray=PlayerModule::PlayrtNum($GLOBALS['SERVERID']);
            if($AllUserTotalArray['userNum']>=PLAYER_REGISTER_QUANTITY_LIMIT)
            {
                return 6;
            }
            $dataArray['uuid'] = md5($uin);
            $dataArray['deviceID'] = $uin;
            $dataArray['timeZone'] = 'Asia/Shanghai';
            $dataArray['uin'] = $uin;
            $dataArray['serverId'] = intval($GLOBALS['SERVERID']);
            $dataJson=json_encode($dataArray);
            Logger::getLogger()->debug("OnProtoBuff empty user info! regInfo==>".$dataJson);
            $data=json_decode(RegisterModule::RegisterSystem($dataJson),true);
            Logger::getLogger()->debug("OnProtoBuff empty user info! regInfo==>".json_encode($data));
            $uin= $data['uin'];
            $tbUserInfo = PlayerCacheModule::getUserInfo($uin, $mode);
        }

        if ($tbUserInfo->getSTATUS() > 0)
        {
            Logger::getLogger()->error("OnProtoBuff User Status invalid!! " . $tbUserInfo->getSTATUS());
            return null;
        }

        $tbServerUserInfo = PlayerCacheModule::getUserServerInfoData($tbUserInfo->getUin(), $mode,$GLOBALS['SERVERID']);
        if(empty($tbServerUserInfo))
        {
            $AllUserTotalArray=PlayerModule::PlayrtNum($GLOBALS['SERVERID']);
            if($AllUserTotalArray['userNum']>=PLAYER_REGISTER_QUANTITY_LIMIT)
            {
                return 6;
            }
            Logger::getLogger()->debug("new user  tbServerUser".$GLOBALS['SERVERID']);
            $dataArray['uuid'] = md5($uin);
            $dataArray['deviceID'] = $uin;
            $dataArray['timeZone'] = 'Asia/Shanghai';
            $dataArray['uin'] = $uin;
            $dataArray['serverId'] = intval($GLOBALS['SERVERID']);
            $dataJson=json_encode($dataArray);
            $data=json_decode(RegisterModule::RegisterSystem($dataJson),true);
            $uin= $data['uin'];
        }
        $aesMgr = new AESMcryptMgr();
        $sessionKey = '123456789';
        $aesMgr->setKey($sessionKey);
        file_put_contents("request.bin", $cryptCode);
        $decryptMsg = $aesMgr->decrypt($cryptCode);

        $GLOBALS['USER_IN'] = $tbUserInfo->getUin();
        $GLOBALS['USER_KEY'] = $sessionKey;
        $GLOBALS['USER_ZONE_ID'] = $tbUserInfo->getUserZoneId();
        $GLOBALS['USER_ZONE'] = $tbUserInfo->getUserZone();
        $timeZone = $tbUserInfo->getUserZone();
        date_default_timezone_set($timeZone);

        $byArr = new XByteArray();
        $byArr->set_data($decryptMsg);
        $count1 = $byArr->readByte();
        $count2 = $byArr->readByte();
        $count3 = $byArr->readByte();
        $count4 = $byArr->readByte();
        $realLen = $count4 * 256 * 256 * 256 + $count3 * 256 * 256 + $count2 * 256 + $count1;
        $output = $byArr->readBinary($realLen);

        return $output;
    }

    public static function EncodeMessage($source, $key = null)
    {
        $srcLen = strlen($source);
        $bySource = new XByteArray();

        $tail_value = floor($srcLen % 256);
        $bySource->writeByte($tail_value);
        $left_value = ($srcLen - $tail_value) / 256;
        $tail_value = floor($left_value % 256);
        $bySource->writeByte($tail_value);
        $left_value = ($left_value - $tail_value) / 256;
        $tail_value = floor($left_value % 256);
        $bySource->writeByte($tail_value);
        $left_value = ($left_value - $tail_value) / 256;
        $bySource->writeByte(floor($left_value % 256));

        $bySource->writeBinary($source, $srcLen);

        $aesMgr = new AESMcryptMgr();
        if (isset($key)) {
            $aesMgr->setKey($key);
        }

        $cryMsg = $aesMgr->encrypt($bySource->raw_data);

        $msgLen = strlen($cryMsg);
        $byMsg = new XByteArray();
        $byMsg->writeBinary($cryMsg, $msgLen);

        return $byMsg->raw_data;
    }

    public static function setBuffMessage($buffKey, Down_DownMsg $message)
    {
        $memKey = "HERO_PROTO_BUFF_" . $buffKey . "_" . $GLOBALS ['USER_IN'];
        CMemcache::getInstance()->setData($memKey, $message->serializeToString(), 3600);
        self::$MessageCached = $message;
    }

    public static function getBuffMessage($buffKey)
    {
        if (isset(self::$MessageCached)) {
            return self::$MessageCached;
        }
        $retPacket = null;
        $memKey = "HERO_PROTO_BUFF_" . $buffKey . "_" . $GLOBALS ['USER_IN'];
        $buffProtocol = CMemcache::getInstance()->getData($memKey);
        if ($buffProtocol) {
            $retPacket = new Down_DownMsg();
            $retPacket->parseFromString($buffProtocol);
        }
        self::$MessageCached = $retPacket;

        return $retPacket;
    }

    public static function getServerVersion($platId, $readSql = false)
    {
        if (!$readSql && isset(self::$VersionCached)) {
            return self::$VersionCached;
        }
        $version = "";
        $memKey = "VERSION_BUFF_" . $platId;
        $buffVersion = CMemcache::getInstance()->getData($memKey);
        if ($readSql) {
            $buffVersion = false;
        }
        if ($buffVersion) {
            $version = $buffVersion;
        } else {
            $patchTable = "client_patch_log";
            if ($platId == 2) {
                $patchTable = "client_patch_log_android";
            }
            if (WorldSvc::getInstance()->isBeta()) {
                $patchTable .= "_temp";
            }
            $s_sql = "SELECT max(binary_version) AS max_binary_version, max(version) AS max_data_version FROM " . $patchTable;
            $qr = MySQL::getInstance()->RunQuery($s_sql);
            if ($qr) {
                $ar = MySQL::getInstance()->FetchArray($qr);
                if ($ar) {
                    $max_binary_version = $ar['max_binary_version'];
                    $max_data_version = $ar['max_data_version'];
                    $version = $max_binary_version . "." . $max_data_version;

                    CMemcache::getInstance()->setData($memKey, $version, 36000);
                    self::$VersionCached = $version;
                }
            }
        }
        return $version;
    }

    public static function getNeedUpdateVersion($platId, $clientVersion)
    {
        $clientVerArr = explode(".", $clientVersion);
        if (count($clientVerArr) < 4) {
            return false;
        }

        $clientBinaryVersion = intval(strval($clientVerArr[0]) . strval($clientVerArr[1]) . strval($clientVerArr[2]));
        $clientDataVersion = intval($clientVerArr[3]);

        $serverVersion = self::getServerVersion($platId);
        $serverVerArr = explode(".", $serverVersion);
        if (count($serverVerArr) < 2) {
            return false;
        }
        $serverBinaryVersion = intval($serverVerArr[0]);
        $serverDataVersion = intval($serverVerArr[1]);

        if (($clientBinaryVersion < $serverBinaryVersion) || ($clientDataVersion < $serverDataVersion)) {
            Logger::getLogger()->error("Client Version is Lower! " . $clientVersion . "->" . $serverVersion);
            return true;
        }

        return false;
    }
    public function GetServerId($puid)
    {
    	$key = "SERVER_ID_".$puid;
    	$mem = CMemcache::getInstance();
    	$serverId=$mem ->getData($key);
    	return $serverId;
    	
    }
}
?>