<?php

require_once($GLOBALS['GAME_ROOT'] . "DbModule/SysUserServer.php");
require_once($GLOBALS['GAME_ROOT'] . "DbModule/SysServerList.php");


define("SERVER_LIST_MEMCACHE", "SERVER_LIST_MEMCACHE");

/** @var TbPlayer $a
 * @var TbPlayer $b
 */
function tb_sort($a, $b)
{
    if ($a->getLevel() > $b->getLevel()) {
        return -1;
    } elseif ($a->getLevel() < $b->getLevel()) {
        return 1;
    } elseif ($a->getServerId() > $b->getServerId()) {
        return -1;
    } else {
        return 1;
    }
}

class ServerModule
{
    private static $ServerListCached = array();

    public static function updateServerListCache()
    {
        $serverList = SysServerList::loadedTable();
        CMemcache::getInstance()->setData(SERVER_LIST_MEMCACHE, $serverList);
    }

    public static function getServerListTable()
    {
        if (count(self::$ServerListCached) > 0) {
            return self::$ServerListCached;
        }

        $serverList = CMemcache::getInstance()->getData(SERVER_LIST_MEMCACHE);
        if (empty($serverList)) {
            $serverList = SysServerList::loadedTable();
            CMemcache::getInstance()->setData(SERVER_LIST_MEMCACHE, $serverList);
        }

        self::$ServerListCached = $serverList;

        return $serverList;
    }

    public static function getServerOpen($serverId)
    {
        $serverList = self::getServerListTable();
        $nowTime = time();
        /** @var TbServerList $tbServer */
        foreach ($serverList as $tbServer) {
            if ($tbServer->getServerId() == intval($serverId)) {
                if (($tbServer->getServerState() == 1) || ($tbServer->getServerStartDate() < $nowTime)) {
                    return true;
                } else {
                    return false;
                }
            }
        }

        return false;
    }

    /**
     * 根据服务器ID获取服务器详细的信息
     *
     * @param int $serverId
     * @return null|TbServerList
     */
    public static function getServerInfoByServerId($serverId)
    {
        $serverList = self::getServerListTable();

        /** @var TbServerList $tbServer */
        foreach ($serverList as $tbServer) {
            if ($tbServer->getServerId() == intval($serverId)) {
                return $tbServer;
            }
        }

        return null;
    }

    public static function getAllServerDownInfo()
    {
        $serverList = self::getServerListTable();
        $allServer = array();
        $nowTime = time();
        $maxServerId = 1;
        /** @var TbServerList $tbServer */
        foreach ($serverList as $tbServer) {
            if (($tbServer->getServerState() == 1) && ($tbServer->getServerStartDate() < $nowTime)) {
                $oneDownServer = new Down_ServerInfo();
                $oneDownServer->setServerId($tbServer->getServerId());
                $oneDownServer->setServerName($tbServer->getServerName());
                $allServer[$tbServer->getServerId()] = $oneDownServer;
                if ($maxServerId < $tbServer->getServerId()) {
                    $maxServerId = $tbServer->getServerId();
                }
            }
        }

        krsort($allServer);

        $retArr = array();
        $allPlayerInfo = self::getAllServerPlayerInfo($GLOBALS['USER_IN']);

        foreach ($allPlayerInfo as $tbPly)
        {
            /** @var Down_ServerInfo $serverInfo */
            $serverInfo = $allServer[$tbPly->getServerId()];
            unset($allServer[$tbPly->getServerId()]);
            $serverInfo->setPlayerName($tbPly->getNickname());
            $serverInfo->setPlayerLevel($tbPly->getLevel());

            if ($tbPly->getServerId() == $maxServerId) {
                array_unshift($retArr, $serverInfo);
            } else {
                array_push($retArr, $serverInfo);
            }
        }

        /** @var Down_ServerInfo $serverInfo */
        foreach ($allServer as $serverInfo) {
            if ($serverInfo->getServerId() == $maxServerId) {
                array_unshift($retArr, $serverInfo);
            } else {
                array_push($retArr, $serverInfo);
            }
        }

        return $retArr;
    }

    public static function getAllServerPlayerInfo($uin)
    {
        $allPlayerInfo = array();
        $userServerTables = SysUserServer::loadedTable(array("user_id"), array("uin" => $uin));
        if (count($userServerTables) > 0)
        {
            $userIdList = array();
            /** @var TbUserServer $tbUserServer */
            foreach ($userServerTables as $tbUserServer)
            {
                $userIdList[] = $tbUserServer->getUserId();
            }
            if (count($userIdList) == 1)
            {
                $searchItemKey = "`user_id` = '{$userIdList[0]}'";
            }
            else
            {
                $uidStr = implode(",", $userIdList);
                $searchItemKey = "`user_id` in ({$uidStr})";
            }

            $allPlayerInfo = SysPlayer::loadedTable(array("server_id", "nickname", "level"), $searchItemKey);
            usort($allPlayerInfo, "tb_sort");
        }
        return $allPlayerInfo;
    }

}