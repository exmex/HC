<?php

require_once($GLOBALS['GAME_ROOT'] . "Classes/PlayerModule.php");
require_once($GLOBALS['GAME_ROOT'] . "Classes/MathUtil.php");
require_once($GLOBALS['GAME_ROOT'] . "Classes/VipModule.php");
/**
 * 英雄装备进阶
 * @param WorldSvc            $svc     [description]
 * @param Up_HeroEquipUpgrade $pPacket [description]
 */
function heroEquipUpgradeApi(WorldSvc $svc, Up_HeroEquipUpgrade $pPacket){
    $userId = $GLOBALS ['USER_ID'];
    Logger::getLogger()->debug("OnHeroEquipUpgrade Process user id:{$userId}");
    $result = equipUpgradeProcess($userId, $pPacket);
    $retReply = new Down_HeroEquipUpgradeReply();
    if ($result) {
        $retReply->setResult(Down_Result::success);
        $heroInfoArr = HeroModule::getAllHeroDownInfo($userId, array($pPacket->getHeroid()));
        foreach ($heroInfoArr as $heroInfo) {
            $retReply->setHero($heroInfo);
            break;
        }
    } else {
        $retReply->setResult(Down_Result::fail);
    }
    return $retReply;
}

/**
 * 装备进阶逻辑
 * @param  [type]              $userId  [description]
 * @param  Up_HeroEquipUpgrade $pPacket [description]
 * @return [type]                       [description]
 */
function equipUpgradeProcess($userId, Up_HeroEquipUpgrade $pPacket){
    $index = $pPacket->getSlot();
    //装备为6块可以进阶
    if ($index < 1 || $index > 6) {
        Logger::getLogger()->error("equipUpgradeProcess index is over band:" . $index);
        return false;
    }
    $playerLevel = PlayerCacheModule::getPlayerLevel($userId);
    $isEnhanceOpen = PlayerModule::checkFuncOpen($playerLevel, "Enhance");
    if (!$isEnhanceOpen) {
        Logger::getLogger()->error("equipUpgradeProcess func not open by level:" . $playerLevel);
        return false;
    }
    $opType = $pPacket->getOpType();
    $heroTid = $pPacket->getHeroid();
    $heroList = HeroModule::getAllHeroTable($userId, array($heroTid));
    if (empty($heroList[$heroTid])) {
        Logger::getLogger()->error("equipUpgradeProcess not found hero heroTid = {$heroTid}");
        return false;
    }

    $objhero = $heroList[$heroTid];
    $equipArr = HeroModule::getHeroEquipArr($objhero);
    $equipId = $equipArr[$index][0];
    $exp = $equipArr[$index][1];
    if ($equipId == 0) {
        Logger::getLogger()->error("equipUpgradeProcess equip index empty:" . $index);
        return false;
    }

    $maxExp = ItemModule::getEquipMaxExp($equipId);
    if (($maxExp <= 0) || ($exp == $maxExp)) {
        Logger::getLogger()->error("equipUpgradeProcess equip can not be upgrade!");
        return false;
    }
    $tbPlayer = PlayerModule::getPlayerTable($userId);
    $quality = DataModule::lookupDataTable(ITEM_LUA_KEY, "Quality", array($equipId));
    $curLv = ItemModule::getEquipCurLv($equipId, $exp, $quality);
    $reason = "OnHeroEquipUpgrade:{$heroTid}-{$index}";
    if ($opType == Up_HeroEquipUpgrade_OPTYPE::boss) {
        $vipState = VipModule::getVIPModuleLimitByUserId($userId, _VIP_MODULE_TYPE::ITEM_ONE_CLICK_UPGRADE);
        if (empty($vipState)) {
            Logger::getLogger()->error("equipUpgradeProcess not enough vip level" . __LINE__);
            return null;
        }

        $unitPrice = DataModule::lookupDataTable(ENHANCE_LUA_KEY, "One-Click Unit Price", array($quality));
        $costGem = $unitPrice * ($maxExp - $exp);

        if ($tbPlayer->getGem() < $costGem) {
            Logger::getLogger()->error("equipUpgradeProcess gem not enough! cur=" . $tbPlayer->getGem() . " need=" . $costGem);
            return false;
        }

        PlayerModule::modifyGem($userId, -$costGem, $reason);
        $afterExp = $maxExp;
    } else {
        $addExp = 0;
        $materialArr = array(); //array($itemId=>$count)
        foreach ($pPacket->getMaterials() as $bit) {
            $itemId = intval(MathUtil::bits($bit, 0, 10));
            $itemCount = intval(MathUtil::bits($bit, 10, 11));

            $unitExp = DataModule::lookupDataTable(ITEM_LUA_KEY, "Enhance Value", array($itemId));
            if ($unitExp == 0) {
                Logger::getLogger()->error("equipUpgradeProcess item cant be material:" . $itemId);
                return false;
            }
            $addExp += $unitExp * $itemCount;
            $materialArr[$itemId] = $itemCount;
        }
        if ($addExp <= 0) {
            Logger::getLogger()->error("equipUpgradeProcess add exp is zero!");
            return false;
        }
        $afterExp = $exp + $addExp;
        if ($afterExp > $maxExp) {
            $afterExp = $maxExp;
            $addExp = $maxExp - $exp;
        }

        $unitPrice = DataModule::lookupDataTable(ENHANCE_LUA_KEY, "Unit Price", array($quality));
        $costMoney = $unitPrice * $addExp;
        $tbPlayer = PlayerModule::getPlayerTable($userId);
        if ($tbPlayer->getMoney() < $costMoney) {
            Logger::getLogger()->error("equipUpgradeProcess money not enough! cur=" . $tbPlayer->getMoney() . " need=" . $costMoney);
            return false;
        }

        $subRet = ItemModule::subItem($userId, $materialArr, $reason);
        if (!$subRet) {
            return false;
        }
        PlayerModule::modifyMoney($userId, -$costMoney, $reason);
    }

    $equipArr[$index][1] = $afterExp;
    $equipStr = HeroModule::getHeroEquipStr($equipArr);
    $objhero->setHeroEquip($equipStr);
    $afterLv = ItemModule::getEquipCurLv($equipId, $afterExp, $quality);
    if ($afterLv > $curLv) {
        $objhero->setGs(HeroModule::getHeroGs($userId, $heroTid, $objhero));
    }
    $objhero->save();
    // trigger daily task
    if ($afterLv > $curLv) {
        TaskModule::updateDailyTaskProgress($userId, DAILY_TASK_ENHANCE_LEVEL_UP);
    }
    //行为日志
    LogAction::getInstance()->log('EQUIP_EHANCE', array(
    		'equipId'		=> $equipId,
    		'oldLevel'		=> $curLv,
    		'curLevel'		=> $afterLv,
    		'costSilver'	=> $costMoney,
    		'afterSilver'	=> $tbPlayer->getMoney(),
    		'quality'		=> $quality
   		 )
    );
    
    return true;
}
