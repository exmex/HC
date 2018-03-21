<?php

require_once($GLOBALS['GAME_ROOT'] . "Classes/ConsumeModule.php");

function ConsumeItemApi(Up_ConsumeItem $pPacket)
{
    $userId = $GLOBALS['USER_ID'];
    Logger::getLogger()->debug("OnConsumeItem Process user id:{$userId}, heroId:{$pPacket->getHeroId()},itemId: {$pPacket->getItemId()}");

    $retReply = ConsumeModule::consumeItem($userId, $pPacket->getHeroId(), $pPacket->getItemId());

    return $retReply;
}