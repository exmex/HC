<?php
/**
 * @Author:      jaylu
 * @Date:        2015-01-16 
 * @Description: Description
 * @email:       jay@xxxx.com
 */
require_once($GLOBALS['GAME_ROOT'] . "Classes/TavernModule.php");
/**
 * 每天抽奖
 * @param Up_TavernDraw $pPacket [description]
 */
function tavernDrawApi(Up_TavernDraw $pPacket){
    $userId = $GLOBALS['USER_ID'];
    Logger::getLogger()->debug("OnTavernDraw Process user id:{$userId}, drawType:{$pPacket->getDrawType()}, boxType:{$pPacket->getBoxType()}");
    $response = TavernModule::tavernDraw($userId, $pPacket->getBoxType(), $pPacket->getDrawType());
    return $response;
}