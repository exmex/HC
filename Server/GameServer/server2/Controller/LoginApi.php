<?php

require_once($GLOBALS['GAME_ROOT'] . "DbModule/SysUserServer.php");
//why 14.10.21
require_once($GLOBALS['GAME_ROOT'] . "DbModule/SysUser.php");
require_once($GLOBALS['GAME_ROOT'] . "Classes/PlayerModule.php");
require_once($GLOBALS['GAME_ROOT'] . "Classes/PlayerCacheModule.php");
require_once($GLOBALS['GAME_ROOT'] . "Classes/NewServerActivity.php");

function LoginApi(WorldSvc $svc, Up_Login $postData)
{
    Logger::getLogger()->debug("OnLogin Process");
    if($GLOBALS['USER_IN']=="")
    {
        Logger::getLogger()->error("USER ID is empty!");
        return null;
    }
//    if (!checkLoginPwd($postData) )
//    {
//        return 5;
//    }
    $uin = $GLOBALS['USER_IN'];
    $GLOBALS['Deviceid'] = $deviceId = $postData->getOldDeviceid();;
    $languageId = $postData->getLanguageid();

    $sysUserInfo = new SysUser();
    $sysUserInfo->setUin($uin);
    if(!$sysUserInfo->loaded())
    {
        return null;
    }
    $sessionKey = time();
    $sysUserInfo->setSessionKey($sessionKey);
    if ($sysUserInfo->getModel()=="")
    {
        $sysUserInfo->setModel($deviceId);
    }
    if($sysUserInfo->getLanguage() != $languageId)
    {
        $sysUserInfo->setLanguage($languageId);
    }
    $sysUserInfo->save();
    $serverId = intval($GLOBALS['SERVERID']);
    $retReply = getLoginReply($uin, $serverId, $sessionKey);
    //行为日志
    LogAction::getInstance()->log('LOGIN_GAME', '');

    return $retReply;
}

function checkLoginPwd( Up_Login $postData)
{
    if ( !defined('Server_Version') )
    {
        return true;
    }

    $puid = $GLOBALS['USER_PUID'];
    $deviceId = $postData->getOldDeviceid();
    if (substr($deviceId, 0, 6) == 'win32_' )
    {
        $deviceId = 'win32Device';
    }
    $version = Server_Version;
    $key = 'pfldhzbycglblftgzhlcxlyc';

    $string = sprintf('%s_%s_%s_%s', $puid, $deviceId, $version, $key);
    $dataString = md5(base64_encode($string));

    if ($dataString != $postData->getVersion())
    {
        Logger::getLogger()->error("Login pwd not match!");
        return false;
    }
    return true;
}


function getLoginReply($uin, $serverId, $sessionKey)
{
    Logger::getLogger()->debug("getLoginReply Process uin " . $uin . " serverId " . $serverId);
    $sysUserServerInfo = new SysUserServer();
    $sysUserServerInfo->setUin($uin);
    $sysUserServerInfo->setServerId($serverId);
    if (!$sysUserServerInfo->loadedExistFields())
    {
        Logger::getLogger()->error("USER ID not be create!");
        return null;
    }
    $GLOBALS ['USER_ID'] = $sysUserServerInfo->getUserId();
    $nowTime = time();
    $sysUserServerInfo->setLoginNums($sysUserServerInfo->getLoginNums() + 1);
    $sysUserServerInfo->setLastLoginTime($nowTime);
    $sysUserServerInfo->save();

    $loginUser = PlayerModule::getUserDownInfo($sysUserServerInfo->getUserId(), $serverId);
    if (empty($loginUser))
    {
        Logger::getLogger()->error("no login user info!" . $sysUserServerInfo->getUserId());
        return null;
    }
    $loginUser->setLastLogin($nowTime);
    // 缓存玩家基本数据
    PlayerCacheModule::reset($sysUserServerInfo->getUserId());
    PlayerCacheModule::setLastLoginTime($sysUserServerInfo->getUserId(), $nowTime);
    PlayerCacheModule::setServerID($sysUserServerInfo->getUserId(), $sysUserServerInfo->getServerId());
    //发送开服每日活动好评奖励
    NewServerActivity::newServerMailCheck($sysUserServerInfo->getUserId(), $serverId);
    DailyActivityModule::checkLoginActivity($sysUserServerInfo->getUserId());
    ArenaModule::updateRewardListToMail($sysUserServerInfo->getUserId());
    $getPraiseRewards=NewServerActivity::PraiseActivities();
    $loginUser->setPraise($getPraiseRewards);
    $loginUser->setSessionid($sessionKey);

    $loginReply = new Down_LoginReply();
    $loginReply->setResult(Down_Result::success);
    $loginReply->setUser($loginUser);
    $timeZone = SQLUtil::getTimezoneOffset($GLOBALS['USER_ZONE']);
    $loginReply->setTimeZone($timeZone);

    return $loginReply;

}

