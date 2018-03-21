<?php

function DotInfoApi(WorldSvc $svc, Up_DotInfo $pPacket)
{
    $userId = $GLOBALS['USER_ID'];
    
    LogAction::getInstance()->log('DOT_RECORDS', array(
    'dot'		=> $pPacket->getDotId(),
    )
    );
   
}