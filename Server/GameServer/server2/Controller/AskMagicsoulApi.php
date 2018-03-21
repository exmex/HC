<?php

require_once($GLOBALS['GAME_ROOT'] . "Classes/TavernModule.php");

function AskMagicsoulApi(Up_AskMagicsoul $pPacket)
{
    $userId = $GLOBALS['USER_ID'];
    Logger::getLogger()->debug("AskMagicsoulApi Process user id:{$userId}");

    $retReply = TavernModule::getMagicSoulReplay();
    return $retReply;
}