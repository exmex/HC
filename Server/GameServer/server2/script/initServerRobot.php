<?php

/**
 * @author wangyufei
 * @abstract every minute run php
 */
if ($argc != 2) {
    die ("Specify the server, please! initServerRobot.php");
}

$this_file_path = realpath(dirname(__FILE__) . "/../") . '/';
require_once($this_file_path . "config.php");
require_once($GLOBALS ['GAME_ROOT'] . 'CMySQL.php');

// 初始化服务器配置
$serverTag = strval($argv[1]);
$_SERVER['FASTCGI_PLAYER_SERVER'] = $serverTag;

$GLOBALS['USER_ZONE_ID'] = 1;

define("SERVER_ROBOT_NUM", 5000);

function createRobotUsers($curRobotUserNum)
{
    $uinList = array();

    $batch = new SQLBatch();
    $batch->init(SysUser::insertSqlHeader());

    for ($uin = $curRobotUserNum + 1; $uin <= SERVER_ROBOT_NUM; $uin++) {
        $tbUser = new SysUser();
        $tbUser->setUin($uin);
        $tbUser->setGameCenterId("");
        $tbUser->setUserZoneId($GLOBALS['USER_ZONE_ID']);
        $tbUser->setUserZone("Asia/Shanghai");
        $tbUser->setSTATUS(2);
        $tbUser->setIsRobot(1);
        $tbUser->setSessionKey("123456789");

        $batch->add($tbUser);
        $uinList[] = $uin;
    }

    $batch->end();
    $batch->save();

    return $uinList;
}

function getRobotUsers()
{
    $robotUserNum = SERVER_ROBOT_NUM;
    $searchKey = "`is_robot` = 1 limit {$robotUserNum}";
    $userList = SysUser::loadedTable(array("uin"), $searchKey);

    $uinList = array();
    /** @var TbUser $tbUser */
    foreach ($userList as $tbUser) {
        $uinList[] = $tbUser->getUin();
    }
    $curRobotUserNum = count($uinList);
    if ($curRobotUserNum < SERVER_ROBOT_NUM) {
        $newUinList = createRobotUsers($curRobotUserNum);
        $uinList = array_merge($uinList, $newUinList);
    }

    return $uinList;
}

function createRobotUserServer($serverTag, $uinList)
{
    $userIdList = array();
    foreach ($uinList as $uin) {
        $tbServer = new SysUserServer();
        $tbServer->setUin($uin);
        $tbServer->setServerId($serverTag);
        $tbServer->inOrUp();

        PlayerCacheModule::setServerID($tbServer->getUserId(), $serverTag, false);
        $userIdList[] = $tbServer->getUserId();
    }

    return $userIdList;
}

function createRobotPlayers($serverTag, $userIdList)
{
    $robotRule = DataModule::getInstance()->getDataSetting(ROBOT_LUA_KEY);

    $batchPlayer = new SQLBatch();
    $batchPlayer->init(TbPlayer::insertSqlHeader());

    $batchHero = new SQLBatch();
    $batchHero->init(SysPlayerHero::insertSqlHeader(array('user_id', 'tid', 'level', 'rank', 'stars', 'gs')));

    $userIndex = 1;
    foreach ($userIdList as $userId) {
        if (empty($robotRule[$userIndex])) {
            $robotIndexData = $robotRule[array_rand($robotRule, 1)];
        } else {
            $robotIndexData = $robotRule[$userIndex];
        }
        $tbPlayer = new SysPlayer();
        $tbPlayer->setUserId($userId);
        $tbPlayer->setServerId($serverTag);
        $tbPlayer->setNickname($robotIndexData['name']);
        $tbPlayer->setAvatar($robotIndexData['avatar']);
        $tbPlayer->setLevel($robotIndexData['level']);

        $batchPlayer->add($tbPlayer);

        $allHeroRobotData = $robotIndexData["heros"];
        for ($heroIndex = 1; $heroIndex <= 5; $heroIndex++) {
            $heroRobotData = $allHeroRobotData[$heroIndex];
            $tbHero = new SysPlayerHero();
            $tbHero->setUserId($userId);
            $tbHero->setTid($heroRobotData["tid"]);
            $tbHero->setLevel($heroRobotData["level"]);
            $tbHero->setRank($heroRobotData["rank"]);
            $tbHero->setStars($heroRobotData["stars"]);
            $tbHero->setSkill1Level($heroRobotData["level"]);
            $tbHero->setSkill2Level($heroRobotData["level"]);
            $tbHero->setSkill3Level($heroRobotData["level"]);
            $tbHero->setSkill4Level($heroRobotData["level"]);
            $tbHero->setHeroEquip(HERO_INIT_EQUIP_LIST);
            $tbHero->setGs(HeroModule::getHeroGs($userId, $tbHero->getTid(), $tbHero, true));

            $batchHero->add($tbHero);
        }

        $userIndex++;
    }

    $batchPlayer->end();
    $batchPlayer->save();

    $batchHero->end();
    $batchHero->save();
}

function createRobotArenaInfo($serverTag, $userIdList)
{
    foreach ($userIdList as $userId) {
        ArenaModule::addNewPlayerToArena($userId, 1);
    }
}

function main($serverTag)
{
    require_once($GLOBALS['GAME_ROOT'] . "Classes/PlayerModule.php");
    require_once($GLOBALS['GAME_ROOT'] . "Classes/ArenaModule.php");
    require_once($GLOBALS['GAME_ROOT'] . "DbModule/SysUser.php");    require_once($GLOBALS['GAME_ROOT'] . "DbModule/SysUserServer.php");

    // create robot user account
    $uinList = getRobotUsers();

    // create user_server
    $userIdList = createRobotUserServer($serverTag, $uinList);

    // create player && player_hero
    createRobotPlayers($serverTag, $userIdList);

    // create player_arena
    createRobotArenaInfo($serverTag, $userIdList);
}

main($serverTag);