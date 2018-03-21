<?php
/**
 * User: jay
 * Date: 14-5-26
 * Time: 下午7:12
 */

//require_once($GLOBALS['GAME_ROOT'] . "DbModule/SQLUtil.php");
//require_once($GLOBALS['GAME_ROOT'] . "DbModule/SysPlayerMail.php");
require_once($GLOBALS['GAME_ROOT'] . "Classes/DataModule.php");
require_once($GLOBALS['GAME_ROOT'] . "Classes/MailModule.php");
/**
 * 个人邮件列表信息
 * @param [int] $userId [用户id]
 */
function getMaillistApi($userId){
    $allMailLists = MailModule::getMailList($userId);
    Logger::getLogger()->debug("GetMailList^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^");
    $reply = new Down_GetMaillistReply();
    foreach ($allMailLists as $mail)
        $reply->appendSysMailList($mail);

    return $reply;
}

/**
 * 阅读邮件
 * @param [int]      $userId [description]
 * @param object $packet [description]
 */
function readMailApi($userId, Up_ReadMail $packet){
    $mailId = $packet->getId();
    Logger::getLogger()->debug("ReadMail::user=" . $userId . ",mailId=" . $mailId);
    $result = MailModule::readMail($userId, $mailId);
    $reply = new Down_ReadMailReply();
    $reply->setResult($result);
    return $reply;
}