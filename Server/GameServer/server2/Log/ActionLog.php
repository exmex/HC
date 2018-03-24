<?php

class ActionLog {

	private $userId;
	private $action;
	private $params;
	
	function __construct($userId, $action, $params) {
		$this->userId = $userId;
		$this->action = $action;
		$this->params = $params;
	}
	
	function getLogString()
	{
		$uin = isset($GLOBALS['USER_IN']) ? $GLOBALS['USER_IN'] : PlayerCacheModule::getUinById($this->userId);
		$sysUser = PlayerCacheModule::getUserInfo($uin);
		$getModel = $sysUser->getModel();
		if($getModel=='')
		{
			$getModel=$GLOBALS['Deviceid'];
		}
		$StayTimes = strtotime(date('Ymd')) - strtotime(date('Ymd', $sysUser->getRegTimeStamp()));
		$stay = ceil($StayTimes / 86400) + 1;
		$info = array(
			'ts'		   => $this->getTime(),
			'puid' 			=> $sysUser->getGameCenterId(),
			'device_id'		=> $getModel,
			'player_id'		=> $this->userId,
			'scene'			=> 'scene',
			'level'			=> PlayerCacheModule::getPlayerLevel($this->userId),
			'stay'			=> $stay,
			'action'		=> $this->action,
			'v1'			=> $this->params,
			'v2'			=> '',
			'v3'			=> '',
			'v4'			=> '',
			'ip'			=> $sysUser->getRegIp(),
			'osversion'		=> $sysUser->getOSVer(),
			'phonetype'		=> '',
			'imei'			=> '',
			'mac'			=> '',
			'store'			=> $this->getPlatformStr($sysUser->getPlatform()),
			'server'		=> $GLOBALS['SERVERID'],
			'os'			=> '',
			'gameid'		=> $this->getGameID()
		);
		
		return json_encode($info);
	}
	
	private function getTime()
	{
		$date = new DateTime ("now", new DateTimeZone ("Asia/Shanghai"));
		$format = "Y-m-d H:i:s";
		return $date->format($format);
	}
	
	private function getGameID()
	{
		return defined('GameID') ? GameID : 'legend';
	}
	
	private function getPlatformStr($platId)
	{
	 	/*$arr = array(
	 		1=>"appstore",
	 		2=>"googleplay",
	 	);
	 	return $arr[$platId];
	 	*/
		$str = $platId == 2 ? 'appstore' : 'googleplay';
		return $str;
	}
}

?>