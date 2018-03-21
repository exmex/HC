<?php
$GLOBALS ['GAME_ROOT'] = dirname ( __FILE__ ) . "/";
require_once ("protocol/LocalDeamonProtocolClient.php");
require_once ("config.php");
require_once ($GLOBALS ['GAME_ROOT'] . "log/Logger.php");

class LocalDeamonClient extends LocalDeamonProtocolClient {
	
	public $prepare_sending_data;
	
	public $pushclient_host = PUSH_CLIENT_IP;

	private $m_result_packet;
	
	var $log;
	
	static $instance;
	
	/**
	 * @return LocalDeamonClient
	 */
	static function &getInstance() {
		if (! isset ( self::$instance )) {
			self::$instance = new LocalDeamonClient ();
		}
		
		return self::$instance;
	}
	
	public function LocalDeamonClient() {
		$this->timer_id = new XLONGLONG ();
		$this->log = Logger::getLogger ();
		$_SERVER [_ECUSTOM_HEADER::socket_id] = "LDC_SOCK";
	}
	
	function WriteDataToSocket($data/*:ByteArray*/)/*:int*/
{
		$this->prepare_sending_data .= $data->raw_data;
		return 1;
	}
	
	public static function getAllProxyList() {
		require_once ($GLOBALS ['GAME_ROOT'] . "CMySQL.php");
		
		MySQL::getInstance ()->Disconnect ();
		if (! MySQL::getInstance ()->Connect ( PROXY_DATABASE_HOST, PROXY_DATABASE_USER, PROXY_DATABASE_PASSWORD, PROXY_DATABASE_DB_NAME )) {
			Logger::getLogger ()->error ( "getAllProxyList failed to connect to proxy db" );
			return false;
		}
		
		$qr = MySQL::getInstance ()->RunQuery ( "select proxy_id from proxy_info where status=3" );
		if (! empty ( $qr )) {
			$ar = MySQL::getInstance ()->FetchAllRows ( $qr );
			$result = array ();
			foreach ( $ar as $l ) {
				$result [] = $l [0];
			}
		}
		MySQL::getInstance ()->Disconnect ();
		MySQL::clearMysqlServer();
		
		if (! empty ( $result )) {
			return $result;
		}
		
		return false;
	}
	
	public function OnMutiplecastLocalError($pPacket/*XPACKET_OnMutiplecastPacketError*/)/*:int*/
{
		$this->m_result_packet = $pPacket;
		return 0;
	}
	
	public function OnScheduleTimerResult($pPacket/*XPACKET_OnScheduleTimerResult*/)/*:int*/
{
		$this->m_result_packet = $pPacket;
		return 0;
	}
	public function OnCancelTimerResult($pPacket/*XPACKET_OnCancelTimerResult*/)/*:int*/
{
		$this->m_result_packet = $pPacket;
		return 0;
	}
	
	public function OnTimerTimeOut($pPacket/*XPACKET_OnTimerTimeOut*/)/*:int*/
{
		require_once ($pPacket->pageFilename);
		$func = $pPacket->callbackFunction;
		$func ( $pPacket->timerId, $pPacket->callbackParams );
		return 0;
	}
	
	public function SendPacketBySocket($data) {
		if (stristr ( PHP_OS, "inux" ) == FALSE) {
			$fp = fsockopen ( $this->pushclient_host, $this->pushclient_port, $errno, $errstr, 30 );
		} else {
			$fp = fsockopen ( $this->pushclient_host );
		}
		
		if (! $fp) {
          //  $logStr    = "failed to connect to push_client ".$this->pushclient_host." ".strval($this->pushclient_port);
			// -- 这种需要监控
		//	if (false !== stristr($this->pushclient_host, 'pushclient-tynon-production.sock')) {
			    // -- Tynon Beta
		//	    $this->log->monitor($logStr,'Tynon Pushclient','critical');
		//	}
		//	
		//	$this->log->error($logStr);
		   Logger::getLogger()->fatal("FAILED TO CONNECT TO PUSH");
			return - 1;
		}
		
		fwrite ( $fp, $data );
		$this->m_result_packet = NULL;
		$ret = 0;
		
		while ( ! feof ( $fp ) ) {
			$data = fread ( $fp, 4096 );
			$ret = $this->HandleReceivedData ( $data );
			if ($ret < 0 || ! empty ( $this->m_result_packet )) {
				break;
			}
		}
		
		fclose ( $fp );
		return $ret;
	}
	
	/**
	 * 通知所有玩家
	 */
	public function NotifyAllPlayers($xpacket) {
		$proxyList = self::getAllProxyList();
		if (!$proxyList) {
			return;
		}
		
		$this->BroadCastPacket($proxyList, $xpacket);
	}
	
	/**
	 * 通知某个时区的玩家
	 */
	public function NotifyPlayersTimeZone($timeZone, $xpacket) {
		// 获取服务器列表
		require_once ($GLOBALS ['GAME_ROOT'] . "db/TbServerList.php");
		
		$con = null;
		switch ($timeZone) {
			case 1:
			case 2:
			case 3:
				$con = "server_zone_flag in (1, 2, 3)";
				break;
				
			default:
				$con = "server_zone_flag = {$timeZone}";
				break;
		}
		
		$serverList = array();
		$allServer = SysServerList::loadedTable (array('server_unique_flag'), $con);
		if (count($allServer) < 1) {
			return;
		}

        /** @var TbServerList $tbServer */
		foreach ( $allServer as $tbServer ) {
			$serverList[] = $tbServer->getServerId();
		}
		
		if (count($serverList) > 1) {
			$serverStr = implode(",", $serverList);
			$this->NotifyPlayersSameServer($serverStr, $xpacket, true);
		} else {
			$serverStr = $serverList[0];
			$this->NotifyPlayersSameServer($serverStr, $xpacket);
		}
	}
	
	/**
	 * 通知某个服务器的玩家
	 */
	public function NotifyPlayersSameServer($serverId, $xpacket, $isMulti = false) {
		require_once ($GLOBALS ['GAME_ROOT'] . "CMySQL.php");
		if ($isMulti) {
			$sql = "select `proxy_id`,`socket_id` from `player_connection_info` where user_id > 0 and `state` = '4' and `server` in ({$serverId}) order by proxy_id";
		} else {
			$sql = "select `proxy_id`,`socket_id` from `player_connection_info` where user_id > 0 and `state` = '4' and `server` = '{$serverId}' order by proxy_id";
		}
		
		$qr = MySQL::getInstance ()->RunQuery ( $sql );
		if (! $qr) {
			return false;
		}
		$ar = MySQL::getInstance ()->FetchAllRows ( $qr );
		if (empty ( $ar ) || count ( $ar ) == 0) {
			return false;
		}
		
		$targetlist = array ();
		
		$lastProxyId = '';
		$target = null;
		foreach ( $ar as $row ) {
			if ($lastProxyId !== strval($row['proxy_id'])) {
				$target = new PROXY_TARGET_LOCAL ();
				$target->PROXY_ID = strval($row['proxy_id']);
				$lastProxyId = $target->PROXY_ID;
				array_push ( $targetlist, $target );
			}
			
			if ($target != null) {
				array_push ( $target->SOCKET_ID, strval ( $row ['socket_id'] ) );
			}
		}
		
		$br = new XByteArray ();
		$xpacket->ToBuffer ( $br );
		return $this->MutiplecastPacket ( $targetlist, 1, $br->raw_data, 0 );
	}
	
	/**
	 * 通知玩家
	 * @param unknown_type $userIds(array()|string)
	 */
	public function NotifyPlayers($userIds, $xpacket) {
        if (empty($userIds)) {
            return false;
        }

        require_once($GLOBALS['GAME_ROOT'] . "CMySQL.php");
        $userIdStr = "";

        if (is_array($userIds)) {
            $f = true;
            foreach ($userIds as $id) {
                if ($f) {
                    $userIdStr .= "'{$id}'";
                    $f = false;
                } else {
                    $userIdStr .= ",'{$id}'";
                }
            }
        } else {
            $userIdStr = "'{$userIds}'";
        }

        if (empty ($userIdStr)) {
            return false;
        }
		
		$sql = "select `proxy_id`,`socket_id` from `player_connection_info` where `state` = '" . _ECONNECTION_STAT::ENTER_WORLD . "' and `user_id` in ({$userIdStr}) order by proxy_id";

		$qr = MySQL::getInstance ()->RunQuery ( $sql );
		if (! $qr) {
			return false;
		}
		$ar = MySQL::getInstance ()->FetchAllRows ( $qr );
		if (empty ( $ar ) || count ( $ar ) == 0) {
			return false;
		}
		
		$targetlist = array ();
		
		$lastProxyId = '';
		$target = null;
		foreach ( $ar as $row ) {
			if ($lastProxyId !== strval($row['proxy_id'])) {
				$target = new PROXY_TARGET_LOCAL ();
				$target->PROXY_ID = strval($row['proxy_id']);
				$lastProxyId = $target->PROXY_ID;
				array_push ( $targetlist, $target );
			}
			
			if ($target != null) {
				array_push ( $target->SOCKET_ID, strval ( $row ['socket_id'] ) );
			}
		}
		
		$br = new XByteArray ();
		$xpacket->ToBuffer ( $br );
		return $this->MutiplecastPacket ( $targetlist, 1, $br->raw_data, 0 );
	}
	
	/**
	 * use this function to notify any player who is not equal to $_SERVER[SOCKET_ID]
	 *
	 */
	public function NotifyOnePlayer($proxy_id/*string*/,
				$socket_id/*string*/,
				$xpacket/*XPACKET_xxxx*/,
				$bWaitDetailResult = 0) {
		$target = new PROXY_TARGET_LOCAL ();
		$target->PROXY_ID = $proxy_id;
		array_push ( $target->SOCKET_ID, $socket_id );
		$br = new XByteArray ();
		$xpacket->ToBuffer ( $br );
		$targetlist = array ();
		array_push ( $targetlist, $target );
		return $this->MutiplecastPacket ( $targetlist, 1, $br->raw_data, $bWaitDetailResult );
	}
	
	/**
	 * $proxy_list = array of proxy_id
	 * */
	public function BroadCastPacket($proxy_list, $xpacket/*XPACKET_xxxx*/,
			$bWaitDetailResult = 0) {
		$targetlist = array ();
		
		foreach ( $proxy_list as $pid ) {
			$target = new PROXY_TARGET_LOCAL ();
			$target->PROXY_ID = $pid;
			array_push ( $targetlist, $target );
		}
		
		$br = new XByteArray ();
		$xpacket->ToBuffer ( $br );
		return $this->MutiplecastPacket ( $targetlist, 0, $br->raw_data, $bWaitDetailResult );
	}
	
	/**
	 * @param $xpacket is the packet you need to send to the player, defined as XPACKET_xxxx
	 * it can be null if you don't want to let the player know why.
	 *
	 * */
	public function KickOnePlayer($proxy_id, $socket_id, $xpacket = null/*XPACKET_xxxx*/,
		$bWaitDetailResult = 0) {
		$target = new PROXY_TARGET_LOCAL ();
		$target->PROXY_ID = $proxy_id;
		array_push ( $target->SOCKET_ID, $socket_id );
		$br = new XByteArray ();
		if ($xpacket != null) {
			$xpacket->ToBuffer ( $br );
		}
		
		$targetlist = array ();
		array_push ( $targetlist, $target );
		return $this->MutiplecastPacket ( array ($target ), 1, $br->raw_data, $bWaitDetailResult, 1 );
	}
	
	/**
		 @param $targets  - array of PROXY_TARGET_LOCAL, you must normalize the target in format of PROXY_TARGET_LOCAL and
		 										duplicated proxy_id in targets is not allowed.
		 										see KickOnePlayer .
		  @param $xpacket is the packet you need to send to the player, defined as XPACKET_xxxx
	 		       it can be null if you don't want to let the player know why.
	 */
	public function KickoutPlayers($targets, $xpacket, $bWaitDetailResult) {
		$br = new XByteArray ();
		if ($xpacket != null) {
			$xpacket->ToBuffer ( $br );
		}
		return $this->MutiplecastPacket ( $targets, 1, $br->raw_data, $bWaitDetailResult, 1 );
	}
	
	public function MutiplecastPacket($targets/*:PROXY_TARGET_LOCAL[] */ ,
			$bIncluded/*:UCHAR*/ ,$pPacket/*:UCHAR[] */ ,$bWaitDetailResult/*:UCHAR*/, $bKickout = 0) {
		$this->m_result_packet = null;
		$this->prepare_sending_data = "";
		
		$res = $this->SendMutiplecastLocal ( $targets/*:PROXY_TARGET_LOCAL[] */ ,$bIncluded/*:UCHAR*/ ,$pPacket/*:UCHAR[] */ ,$bWaitDetailResult/*:UCHAR*/,$bKickout );
		if ($res < 0) {
			return $res;
		}
		
		$res = $this->SendPacketBySocket ( $this->prepare_sending_data );
		if ($res < 0) {
			return $res;
		}
		
		if (empty ( $this->m_result_packet )) {
			return - 1;
		}
		
		return $this->m_result_packet;
	}
	
	public function SetTimer($milliSeconds/*:UINT*/ ,
	$pageFilename/*:string utf-8*/ ,
	$className/*:string utf-8*/ ,
	$callbackParams/*:array */ ,
	$bRepeating/*:UCHAR*/=false) {
		$this->m_result_packet = null;
		$this->prepare_sending_data = "";
		//如果是数组
		$cparams = '';
		if (is_array ( $callbackParams )) {
			foreach ( $callbackParams as $key => $value ) {
				$cparams .= ($key . "=>" . $value . ",");
			}
		} else {
			$cparams = $callbackParams;
		}
		
		$res = $this->SendScheduleTimer ( $bRepeating, $milliSeconds, $pageFilename, $className, $cparams );
		if ($res < 0) {
			return array ($res, NULL );
		}
		$res = $this->SendPacketBySocket ( $this->prepare_sending_data );
		if ($res < 0) {
			return array ($res, NULL );
		}
		
		if (empty ( $this->m_result_packet )) {
			return array (- 1, NULL );
		}
		
		return array ($this->m_result_packet->errorCode/*:INT*/,
		$this->m_result_packet->timerId/*:string utf-8**/);
	}
	
	public function CancelTimer($timerId/*:string utf-8*/ )
	{
		$this->m_result_packet = null;
		$this->prepare_sending_data = "";
		
		$res = $this->SendCancelTimer ( $timerId/*:string utf-8*/  );
		if ($res < 0) {
			return $res;
		}
		$res = $this->SendPacketBySocket ( $this->prepare_sending_data );
		if ($res < 0) {
			return $res;
		}
		
		if (empty ( $this->m_result_packet )) {
			return - 1;
		}
		
		return $this->m_result_packet->errorCode/*:INT*/;
	}

}

?>
