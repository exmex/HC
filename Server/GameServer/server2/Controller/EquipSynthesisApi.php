<?php
/**
 * @Author:      jaylu
 * @Date:        2015-01-16 
 * @Description: Description
 * @email:       jay@xxxx.com
 */
require_once($GLOBALS['GAME_ROOT'] . "Classes/EquipModule.php");
/**
 * 装备合成
 * @param Up_EquipSynthesis $pPacket [description]
 */
function equipSynthesisApi(Up_EquipSynthesis $pPacket){
    $userId = $GLOBALS['USER_ID'];
    Logger::getLogger()->debug("&&&&&&&&&&....equipSynthesis Process user id:{$userId}, itemId: {$pPacket->getEquipId()}");
    $result = EquipModule::equipSynthesis($userId, $pPacket->getEquipId());
    return $result;
}