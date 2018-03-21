<?php
/* 
 * facebook关注
 */
require_once($GLOBALS['GAME_ROOT'] . "Classes/FacebookFollowModule.php");require_once($GLOBALS['GAME_ROOT'] . "DbModule/SysPlayerMail.php");
require_once($GLOBALS['GAME_ROOT'] . "Classes/MailModule.php");
function FacebookFollowApi($userId){
    $DownNew  =  new Down_FbAttentionReply();
    $facebookFollowNum = FacebookFollowModule::getFacebookFollowNum($userId);
    if($facebookFollowNum == 0){
        $facebookFollowNum = 1;//数据库里存此字段0是未关注 1 是关注
        if(!FacebookFollowModule::updateFacebookFollowNum($userId,$facebookFollowNum)){
            $DownNew->setAttention(0);
            return $DownNew;
        }
        $title="More fun on Facebook fanpage.Join now!";
        $content = "Heroes! We setup fanpage now,let's join together,discuss GotA,get more fun with your friends.The most important thing is you can get announcement,news,help and other revelant infomation earlier on our fanpage.
We prepare present for your Like,join now!";
        $sender = "System";
        $expireTime= time()+7*24*3600;
        $gem = 50;
        $money = 20000;
        $items = "218:20;";
        $ServerId = '';
        if(!MailModule::GmSetMail($userId, $title, $sender, $content, $expireTime, $gem, $money, $items, $ServerId)){
             $DownNew->setAttention(0);
             return $DownNew;
        }
    }
     $DownNew->setAttention(1);
    return $DownNew;
}
?>
