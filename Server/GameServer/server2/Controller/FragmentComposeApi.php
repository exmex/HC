<?php

require_once($GLOBALS['GAME_ROOT'] . "Classes/EquipModule.php");
function fragmentComposeApi(Up_FragmentCompose $pPacket)
{
    $userId = $GLOBALS['USER_ID'];
    Logger::getLogger()->debug("OnFragmentCompose Process user id:{$userId}, make itemId: {$pPacket->getFragment()}, use num: {$pPacket->getFragAmount()}");

    $retReply = EquipModule::fragmentCompose($userId, $pPacket->getFragment(), $pPacket->getFragAmount());

    return $retReply;
}