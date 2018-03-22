<?php
require_once "config.php";

require_once($GLOBALS['GAME_ROOT'] . "runtime.php");

require_once($GLOBALS['GAME_ROOT'] . "Log/LogClient.php");
require_once($GLOBALS['GAME_ROOT'] . "Log/LogAction.php");

require_once($GLOBALS['GAME_ROOT'] . "CConnectionInfo.php");

require_once($GLOBALS['GAME_ROOT'] . "Protocol/XByteArray.php");
require_once($GLOBALS['GAME_ROOT'] . "Protocol/GameProtocolServer.php");

require_once($GLOBALS['GAME_ROOT'] . "DbModule/SQLBatch.php");

require_once($GLOBALS['GAME_ROOT'] . "ProtoSource/DotaServerMsgInfo.php");
require_once($GLOBALS['GAME_ROOT'] . "ProtoSource/pb_proto_bcdown.php");
require_once($GLOBALS['GAME_ROOT'] . "ProtoSource/pb_proto_bcup.php");
require_once($GLOBALS['GAME_ROOT'] . "ProtoSource/pb_proto_down.php");
require_once($GLOBALS['GAME_ROOT'] . "ProtoSource/pb_proto_up.php");

require_once($GLOBALS['GAME_ROOT'] . "Classes/AESMcryptMgr.php");
require_once($GLOBALS['GAME_ROOT'] . "Classes/MessageProcessor.php");


class WorldSvc extends GameProtocolServer
{
    static $instance;

    var $response_data;

    var $conInfo;

    var $domain_name;

    var $debug = true;


    /**
     * @static
     * @return WorldSvc
     */
    static function &getInstance()
    {
        if (isset($_SERVER['GAME_SERVER_INSTANCE'])) {
            return $_SERVER['GAME_SERVER_INSTANCE'];
        }

        if (!isset(self::$instance)) {
            self::$instance = new WorldSvc();
        }

        return self::$instance;
    }

    function WorldSvc()
    {
        $this->conInfo = new ConnectionInfo();

        $domain_name = "HERO_" . $this->getGameVersion();
        $this->domain_name = $domain_name;
    }

    public function getGameVersion()
    {
        if (defined('GAME_VERSION')) {
            return strval(GAME_VERSION);
        }
        return "LOCAl";
    }

    public function isLocal()
    {
        if ($this->getGameVersion() === 'LOCAL') {
            return true;
        }
        return false;
    }

    public function isAlpha()
    {
        if ($this->getGameVersion() === 'ALPHA') {
            return true;
        }
        return false;
    }

    public function isBeta()
    {
        if ($this->getGameVersion() === 'BETA') {
            return true;
        }
        return false;
    }

    public function isLatest()
    {
        if ($this->getGameVersion() === 'LATEST') {
            return true;
        }
        return false;
    }

    public function isProduction()
    {
        if ($this->getGameVersion() === 'PRODUCTION') {
            return true;
        }

        return false;
    }

    public function WriteDataToSocket($data /*:ByteArray*/) /*:int*/
    {
        $this->response_data .= $data->raw_data;
        return 0;
    }

    public function CheckValidAction($action /*:string*/, $msgId) /*:bool*/
    {
        if (true) {
            return true;
        }
        //ignore internal msg state checking.
        //
        if ($msgId == _EMSG_ServerInterface::CMSG_SendInternalNotifyByProxy) {
            return true;
        }


        //connection FSM path checking
        //
        switch ($this->conInfo->state) {
            case _ECONNECTION_STAT::NONE:
                Logger::getLogger()->error("CONNECTION FSM: STATE NONE, MAYBE SQL EXCEPTION IN CONNECTIONINOF CONSTRUCTOR! ");
                return false;
                break;
            /*case _ECONNECTION_STAT::CONNECTED:
                if ($msgId != _EMSG_ServerInterface::CMSG_DoLogin) {
                    Logger::getLogger()->error("CONNECTION FSM: ONLY CMSG_DoLogin ALLOW AT  STATE CONNECTED actionId:{$msgId}");
                    return false;
                }
                break;*/
            case _ECONNECTION_STAT::CLOSED:
                Logger::getLogger()->error("CONNECTION FSM: NO MESSAGE ALLOW AT STAT CLOSED");
                return false;
                break;

        }

        return true;
    }


    public function kickoutOtherConnection($u)
    {
        $query = "select proxy_id,socket_id,address,create_time from player_connection_info where user_id='{$u}' and type=1 ";
        $rs = MySQL::getInstance()->RunQuery($query);
        $arr = MySQL::getInstance()->FetchAllRows($rs);
        //print_r($arr);
        Logger::getLogger()->debug("run sql:" . $query . "count:" . count($arr));

        if (empty($arr) || count($arr) <= 0) {
            Logger::getLogger()->debug("no duplicated login");
            return;
        }

        $target_map = array();
        foreach ($arr as $row) {
            $proxy_id = $row['proxy_id'];
            $socket_id = $row['socket_id'];
            $address = $row['address'];
            $create_time = $row['create_time'];

            Logger::getLogger()->error("DUPLICATE LOGIN FOR USER {$u} FROM {$proxy_id} {$socket_id} address {$address} ,create at {$create_time}");
            if (!array_key_exists($proxy_id, $target_map)) {
                $target = new PROXY_TARGET_LOCAL();
                $target->PROXY_ID = $proxy_id;
                $target_map[$proxy_id] = $target;
            }

            $target = $target_map[$proxy_id];
            if (!in_array($socket_id, $target->SOCKET_ID)) {
                array_push($target->SOCKET_ID, $socket_id);
            }

            //正常情况不可能大于2条的。
            //
            $query = "DELETE FROM player_connection_info WHERE proxy_id='{$proxy_id}' and socket_id='{$socket_id}' and type=1";
            MySQL::getInstance()->RunQuery($query);
        }

        $target_list = array_values($target_map);

        require_once($GLOBALS['GAME_ROOT'] . "Protocol/XPACKET_OnKickout.php");
        $packet = new XPACKET_OnKickout();
        $packet->error_code = _ECOMMON_SERVER_ERROR_A::KICKED_OUT_BY_OTHER_DUPLICATED_LOGIN;
        require_once("LocalDeamonClient.php");
        LocalDeamonClient::getInstance()->KickoutPlayers($target_list, $packet, FALSE);
    }

    /**
     *  这个函数是PROXY程序用来通知客户端断线的,通知是事件参照_EINTERNAL_NOTIFY_BY_PROXY_A
     *  主要用来参断线的临时数据清理，好友离线通知，及前一个指令的发送状态。
     *  注意，这里的任何回应不会继续发给CLIENT的了。
     */
    public function OnInternalNotifyByProxy($pPacket /*XPACKET_SendInternalNotifyByProxy*/) /*:int*/
    {
        return 0;
    }

    public function OnDoLogin($pPacket /*XPACKET_DoLogin*/) /*:int*/
    {
    	$this->SetServerId($pPacket->userId,$pPacket->server);
        return 0;
    }

    public function OnProtoBuff($pPacket /*XPACKET_SendProtoBuff*/) /*:int*/
    {
        $profileMode = false;
        if ($profileMode) {
            require_once($GLOBALS['GAME_ROOT'] . "xhprof_lib/utils/xhprof_lib.php");
            require_once($GLOBALS['GAME_ROOT'] . "xhprof_lib/utils/xhprof_runs.php");
            // start profiling
            xhprof_enable();
        }

        require_once($GLOBALS['GAME_ROOT'] . "Controller/ProtoBuffApi.php");
        $retPacket = new Down_DownMsg();
        $retCode = OnProtoBuff($this, $pPacket, $retPacket);
        //Logger::getLogger()->debug("getLoginReplyPacket OnProtoBuff " . json_encode($pPacket));
        $this->SendClientPacket($retCode, $retPacket);
        if ($profileMode) {
               // stop profiler
            $xhprof_data = xhprof_disable();
            // save raw data for this profiler run using default
            // implementation of iXHProfRuns.
            $xhprof_runs = new XHProfRuns_Default();

            // save the run under a namespace "xhprof_foo"
            $run_id = $xhprof_runs->save_run($xhprof_data, "OnProtoBuff");

            LogProfile::getInstance()->log("OnProtoBuff RunID = " . $run_id);
        }

        return 0;
    }

    public function SendClientPacket($retCode, Down_DownMsg $pPacket) /*:int*/
    {
        $pbStr = $pPacket->serializeToString();

        $isDebug = true;
        if ($isDebug) {
            $log = BytesToString($pbStr, strlen($pbStr), " ");
            Logger::getLogger()->debug("serial=" . $log);
        }

        $retStr = MessageProcessor::EncodeMessage($pbStr, $GLOBALS['USER_KEY']);
        if ($isDebug) {
            $log = BytesToString($retStr, strlen($retStr), " ");
            Logger::getLogger()->debug("encode=" . $log);
        }

        $this->SendProtoReponse($retCode, $retStr);

        return 0;
    }
    public function SetServerId($puid,$ret)
    {
    	$key = "SERVER_ID_".$puid;
    	$mem = CMemcache::getInstance();
    	$mem ->setData($key, $ret,86400); 
    }

}
