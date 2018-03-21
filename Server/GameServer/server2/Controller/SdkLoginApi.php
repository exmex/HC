<?php
//why 14.10.21
require_once($GLOBALS['GAME_ROOT'] . "DbModule/SysUser.php");
function SdkLoginApi(WorldSvc $svc, Up_SdkLogin $pPacket)
{
    if (true) {
     return null;
    }

    Logger::getLogger()->debug("OnSdkLogin Process : " . $pPacket->getSessionKey());

    $tbUser = new SysUser();
    $tbUser->setGameCenterId($pPacket->getSessionKey());
    $nowTime = time();
    $nowTimeStr = date("Y-m-d H:i:s", $nowTime);

    if ($tbUser->LoadedExistFields()) {
        // update user login info
        $tbUser->setLastLoginTime($nowTimeStr);
        $tbUser->setLastLoginTimeStamp($nowTime);
        $tbUser->setLoginNums($tbUser->getLoginNums() + 1);
        $tbUser->save();
    } else {
        // create new user
        $tbUser->setRegTime($nowTimeStr);
        $tbUser->setLastLoginTime($nowTimeStr);
        $tbUser->setRegTimeStamp($nowTime);
        $tbUser->setLastLoginTimeStamp($nowTime);
        $tbUser->inOrUp();
    }

    $reply = new Down_SdkLoginReply();
    $reply->setResult(Down_Result::success);
    $reply->setUin($tbUser->getUin());

    return $reply;
}

function SdkSessionApi($sessionKey)
{
	$SysUser = new SysUser();
	$SysUser->setUin($GLOBALS['USER_IN']);
	$SysUser->loaded();
	if($sessionKey<$SysUser->getSessionKey())
	{
		return false;
	}
	return true;
}