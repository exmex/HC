<?php
require_once($GLOBALS['GAME_ROOT'] . "DbModule/SysPlayerTutorial.php");
require_once($GLOBALS['GAME_ROOT'] . "DbModule/SysPlayer.php");

define('TUTORIAL_COUNT', '96');
define('TUTORIAL_MAX_COUNT', '200');

function TutorialApi(WorldSvc $svc, Up_Tutorial $pPacket)
{
        Logger::getLogger()->debug("OnTutorial Process");
        $TutorialReply = new Down_TutorialReply();
        $userId = $GLOBALS ['USER_ID'];
        $newRecord = $pPacket->getRecord();
        $SysTutorial = getTutorialTableInfo($userId);
        $TutorialCount = $SysTutorial->getCount();
        $num = count($newRecord);
        if ($num != $TutorialCount && $num <= TUTORIAL_MAX_COUNT)
        {
            $SysTutorial->setCount($num);
        }
        if($num == $TutorialCount)
        {
            $step=0;
            for ($i=0;$i<$num;$i++)
            {
                if($newRecord[$i]!=0)
                {
                    $step++;
                }
            }
            $SysPlayer = new SysPlayer();
            $SysPlayer->setUserId($userId);
            $SysPlayer->setTutorialstep($step);
            $SysPlayer->save();
            $SysTutorial->setTutorial(implode("|", $newRecord));
            $SysTutorial->save();
            $TutorialReply->setResult(Down_Result::success);
        }
        else
        {
            //超过了引导数量的最大值
            $TutorialReply->setResult(Down_Result::fail);
        }

    return $TutorialReply;
}

function getTutorialTableInfo($userId)
{
    $SysPlayerTutorial = new SysPlayerTutorial();
    $SysPlayerTutorial->setUserId($userId);
    if (!$SysPlayerTutorial->loaded())
    {
        $SysPlayerTutorial->setCount(TUTORIAL_COUNT);
        $tutorialArray = array();
        for ($i = 0; $i < TUTORIAL_COUNT; $i++)
        {
            $tutorialArray[] = 0;
        }
        $SysPlayerTutorial->setTutorial(implode("|", $tutorialArray));
        $SysPlayerTutorial->inOrUp();
    }
    return $SysPlayerTutorial;
}

function getTutorialDownInfo($userId)
{
    $SysTutorial = getTutorialTableInfo($userId);
    $tutorialArray = explode("|", $SysTutorial->getTutorial());
    return $tutorialArray;
}








