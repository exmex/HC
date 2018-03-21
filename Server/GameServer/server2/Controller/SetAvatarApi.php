<?php
require_once($GLOBALS['GAME_ROOT'] . "Classes/DataModule.php");;
require_once($GLOBALS['GAME_ROOT'] . "Classes/HeroModule.php");
require_once($GLOBALS['GAME_ROOT'] . "Classes/PlayerModule.php");

function SetAvatarApi($userId, $avatarId)
{
    $setAvatarReply = new Down_SetAvatarReply();
    $setAvatarReply->setResult(Down_Result::fail);
    $DataModule = DataModule::getInstance();
    $avatarList = $DataModule->getDataSetting(AVATAR_LUA_KEY);
    $avatarConfig = $avatarList[$avatarId];

    if ($avatarConfig == null) {
        Logger::getLogger()->error("SetAvatarApi  DataModule::getInstance()->getDataSetting(AVATAR_LUA_KEY) Fail!");
        $setAvatarReply->setResult(Down_Result::fail);
        return $setAvatarReply;
    }

    $require = $avatarConfig["Requirement Type"];

    if (!isset($require)) {
        $setAvatarReply->setResult(Down_Result::success);
    } elseif ($require == "HeroRank") {
        $id = $avatarConfig["Requirement ID"];
        $tg = $avatarConfig["Requirement Target"];
        $heroArr = HeroModule::getAllHeroTable($userId, array($id));

        /* @var sysPlayerHero $hero*/
        $hero = $heroArr[$id];
        if (isset($hero) and $tg <= $hero->getRank()) {
            $setAvatarReply->setResult(Down_Result::success);
        }

    } elseif ($require == "PlayerLevel") {
        $tg = $avatarConfig["Requirement Target"];
        $level = PlayerCacheModule::getPlayerLevel($userId);
        if ($tg <= $level) {
            $setAvatarReply->setResult(Down_Result::success);
        }
    }

    if ($setAvatarReply->getResult() == Down_Result::success) {
        $sysPlayer = PlayerModule::getPlayerTable($userId);
        $sysPlayer->setAvatar($avatarId);
        $sysPlayer->save();
    }
    return $setAvatarReply;
}