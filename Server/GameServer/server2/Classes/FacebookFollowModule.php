<?php
/* 
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
require_once($GLOBALS['GAME_ROOT'] . "DbModule/SysPlayer.php");

class FacebookFollowModule
{

    public function getFacebookFollowNum($userId)
    {

        $tbPlayer = new SysPlayer();
    	$tbPlayer->setUserId($userId);
    	if(!$tbPlayer->loaded())
    	{
           $facebookFollowNum = null;
        }
	$facebookFollowNum = $tbPlayer->getFacebookFollow();
    
	return  $facebookFollowNum;        
       
    }

    public function updateFacebookFollowNum($userId,$follow_num)
    {
        $tbPlayer = new SysPlayer();
    	$tbPlayer->setUserId($userId);
    	if(!$tbPlayer->loaded())
    	{
           return false;
        }
        $tbPlayer->setFacebookFollow($follow_num);
	 $tbPlayer->save();
	
        return true;
    }

  
}
?>
