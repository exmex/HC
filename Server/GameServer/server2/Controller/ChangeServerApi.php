<?php

require_once($GLOBALS['GAME_ROOT'] . "Classes/ServerModule.php");

function ChangeServerApi(WorldSvc $svc, Up_ChangeServer $packet)
{
    $uin = $GLOBALS['USER_IN'];
    $opType = $packet->getOpType();
    $serverId = $packet->getServerId();
    $userId = $GLOBALS ['USER_ID'];
    Logger::getLogger()->debug("ChangeServerApi Process user id:{$userId}, opType:{$opType}");

    $retReply = new Down_ChangeServerReply();

    if ($opType == Up_ServerOptType::change) {
        Logger::getLogger()->debug("ChangeServerApi target:{$serverId}");
        $retReply->setResult(Down_ServerOptResult::change_ok);
        if (!ServerModule::getServerOpen($serverId)) {
            $retReply->setResult(Down_ServerOptResult::fail);
            return $retReply;
        }
        // 换服
        $nowTime = time();
        $sysServer = new SysUserServer();
        $sysServer->setUin($uin);
        $sysServer->setServerId($serverId);
        if ($sysServer->LoadedExistFields()) {
        	// 更新最近登录时间,由网站进行下次登录判断
            $sysServer->setLastLoginTime($nowTime); 
            $sysServer->save();
        } else {
            $sysServer->setRegTime($nowTime);
            $sysServer->setLastLoginTime($nowTime);
            $ip = "0.0.0.0";
            if (isset($_SERVER ["REMOTE_ADDR"])) {
                $ip = $_SERVER ["REMOTE_ADDR"];
            }
            $sysServer->setRegIp($ip);
            $sysServer->setLastLoginIp($ip);
            $sysServer->setLoginNums(0);

            $sysServer->inOrUp();
        }
    } else {
        // 获取服务器列表
        $retReply->setResult(Down_ServerOptResult::get_ok);
        $serverList = ServerModule::getAllServerDownInfo();
        /** @var Down_ServerInfo $latestServer */
        $latestServer = current($serverList);
        if (intval($latestServer->getServerId()) > $serverId) {
            foreach ($serverList as $oneServer) {
                $retReply->appendServerInfo($oneServer);
            }
        }
    }
    return $retReply;
}
