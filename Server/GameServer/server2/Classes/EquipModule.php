<?php

/**
 * @Author:      jaylu
 * @Date:        2015-01-10 
 * @Description: Description
 * @email:       jay@xxxx.com
 */
require_once($GLOBALS['GAME_ROOT'] . "Classes/DataModule.php");;
require_once($GLOBALS['GAME_ROOT'] . "Classes/PlayerModule.php");
require_once($GLOBALS['GAME_ROOT'] . "Classes/ItemModule.php");

class EquipModule{
    /**
     * 装备合成
     * @param $userId
     * @param $equipId
     * @return Down_EquipSynthesisReply
     */
    public static function equipSynthesis($userId, $equipId){
        $downEquipSynthesisReply = new Down_EquipSynthesisReply();
        $equipDefineDataArr = DataModule::lookupDataTable(EQUIP_CRAFT_KEY, $equipId, array());
        if (empty($equipDefineDataArr)) {
            Logger::getLogger()->error("equipSynthesis Failed to load equip define,id:{$equipId}," . __LINE__);
            $downEquipSynthesisReply->setResult(Down_Result::fail);
            return $downEquipSynthesisReply;
        }
        $needComponentNum = intval($equipDefineDataArr['Components']);
        $costCoinNum = isset($equipDefineDataArr['Expense']) ? intval($equipDefineDataArr['Expense']) : 99999999;
        $needItemArr = array();
        for($i = 1; $i <= $needComponentNum; $i++){
            $id = $equipDefineDataArr["Component" . $i];
            $need = max($equipDefineDataArr["Component$i Count"], 1);
            if (isset($needItemArr[$id])) {
                $needItemArr[$id] += $need;
            } else {
                $needItemArr[$id] = $need;
            }
        }
        //金钱是否足够
        self::checkMoneyCount($downEquipSynthesisReply,$costCoinNum,Down_Result::fail,$userId);
        //物品是否足够
        self::checkItemsCount($downEquipSynthesisReply,$needItemArr,Down_Result::fail,$userId);
        //扣除金钱及物品,增加合成后物品
        PlayerModule::modifyMoney($userId, -$costCoinNum, "equipSynthesis");
        ItemModule::subItem($userId, $needItemArr, "equipSynthesis");
        $addItemArr = array($equipId => 1);
        ItemModule::addItem($userId, $addItemArr, "equipSynthesis");
        //返回downMsg
        $downEquipSynthesisReply->setResult(Down_Result::success);
        //行为日志
        LogAction::getInstance()->log('COMPOUND_EQUIP', array(
                'equipItemId'   => $equipId
              )
        );
        return $downEquipSynthesisReply;
    }

    /**
     * 碎片合成
     *
     * @param $userId
     * @param $makeId
     * @param $useAmount
     */
    public static function fragmentCompose($userId, $makeId, $useAmount){
        $fragmentComposeReply = new Down_FragmentComposeReply();
        $makeDefineDataArr = DataModule::lookupDataTable(FRAGMENT_LUA_KEY, $makeId, array());
        if (empty($makeDefineDataArr)) {
            Logger::getLogger()->error("fragmentCompose Failed to load equip define,id:{$makeId}," . __LINE__);
            $fragmentComposeReply->setResult(Down_Result::fail);
            return $fragmentComposeReply;
        }

        $needItemNum = intval($makeDefineDataArr['Fragment Count']);
        $needItemId = $makeDefineDataArr['Fragment ID'];
        $needCoinNum = $makeDefineDataArr['Expense'];

        $giveItemNum = floor($useAmount / $needItemNum);
        $finalUseNum = $giveItemNum * $needItemNum;
        if ($giveItemNum <= 0) {
            Logger::getLogger()->error("fragmentCompose Failed to giveNum,id:{$makeId},useAmount: {$useAmount}," . __LINE__);
            $fragmentComposeReply->setResult(Down_Result::fail);
            return $fragmentComposeReply;
        }
        //金钱是否足够
        self::checkMoneyCount($fragmentComposeReply,$needCoinNum,Down_Result::fail,$userId);
        $needItemArr = array($needItemId => $finalUseNum);
 
        self::checkItemsCount($fragmentComposeReply,$needItemArr,Down_Result::fail,$userId);
        //扣除金钱及物品,增加合成后物品
        PlayerModule::modifyMoney($userId, -$needCoinNum, "fragmentCompose");
        ItemModule::subItem($userId, $needItemArr, "fragmentCompose");

        $addItemArr = array($makeId => $giveItemNum);
        ItemModule::addItem($userId, $addItemArr, "fragmentCompose");

        //返回downMsg
        $fragmentComposeReply->setResult(Down_Result::success);
        return $fragmentComposeReply;
    }

    /**
     * 检查金钱数量
     * @param  [object] $obj           [description]
     * @param  [int]    $needCoinNum   [description]
     * @param  [string] $errorMes      [description]
     * @return [object] $obj           [description]
     */
    private static function checkMoneyCount($obj,$needCoinNum,$errorMes,$userId){
        $tbPlayer = PlayerModule::getPlayerTable($userId);
        if ($tbPlayer->getMoney() < $needCoinNum) {
            Logger::getLogger()->error("equipSynthesis no enough money, need {$needCoinNum}, have {$tbPlayer->getMoney()} " . __LINE__);
            $obj->setResult($errorMes);
            return $obj;
        }   

    }

    /**
     * 检查物品数量
     * @param  [type] $obj         [description]
     * @param  [type] $needItemArr [description]
     * @param  [type] $errorMes    [description]
     * @param  [type] $userId      [description]
     * @return [type]              [description]
     */
    private static function checkItemsCount($obj,$needItemArr,$errorMes,$userId){
        $itemState = ItemModule::checkAllItemsExist($userId, $needItemArr);
        if ($itemState == false) {
            Logger::getLogger()->error("equipSynthesis no enough item, need " . print_r($needItemArr, true) . "," . __LINE__);
            $obj->setResult($errorMes);
            return $obj;
        }
    }
}
 