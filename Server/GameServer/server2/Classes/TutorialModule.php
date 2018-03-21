<?php

require_once($GLOBALS['GAME_ROOT'] . "DbModule/SysPlayerTutorial.php");
require_once($GLOBALS['GAME_ROOT'] . "DbModule/SysPlayer.php");

define('TUTORIAL_COUNT', '96');
define('TUTORIAL_MAX_COUNT', '200');

class TutorialModule
{

    public static function getTutorialTable($userId)
    {
        $tbTutorial = new SysPlayerTutorial();
        $tbTutorial->setUserId($userId);
        if ($tbTutorial->loaded()) {

        } else {
            $tbTutorial->setCount(TUTORIAL_COUNT);
            $tutorialArr = array();
            for ($i = 0; $i < TUTORIAL_COUNT; $i++) {
                $tutorialArr[] = 0;
            }
            $tbTutorial->setTutorial(implode("|", $tutorialArr));
            $tbTutorial->inOrUp();
        }
        return $tbTutorial;
    }

    public static function getTutorialDownInfo($userId)
    {
        $tbTutorial = self::getTutorialTable($userId);
        $tutorialArr = explode("|", $tbTutorial->getTutorial());
        return $tutorialArr;
    }

    public static function updateTutorialInfo($userId, $newRecord)
    {
        $tbTutorial = self::getTutorialTable($userId);
        if (count($newRecord) != $tbTutorial->getCount() && count($newRecord) <= TUTORIAL_MAX_COUNT) {
            $tbTutorial->setCount(count($newRecord));
        }

        if (count($newRecord) == $tbTutorial->getCount()) {
        	$ST=0;
        	for ($i=0;$i<count($newRecord);$i++)
        	{
        		if($newRecord[$i]!=0)
        		{
        			$ST++;
        		}
        	}
        	$Player = new SysPlayer();
        	$Player->setUserId($userId);
        	$Player->setTutorialstep($ST);
        	$Player->save();
        	
        	
            $tbTutorial->setTutorial(implode("|", $newRecord));
            $tbTutorial->save();
            return true;
        } else {
            //超过了引导数量的最大值
            return false;
        }
    }

}