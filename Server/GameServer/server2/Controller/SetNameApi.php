<?php
/**
 * User: xumanli
 * Date: 15-01-25
 * Time: 下午6点
 */
require_once($GLOBALS['GAME_ROOT'] . "Classes/PlayerModule.php");
define('PLAYER_NAME_MAX_LENGTH', 13);

function SetNameApi($userId, $name)
{
    $settingNameReplyInfo = new Down_SetNameReply();
    $SysPlayerInfo = PlayerModule::getPlayerTable($userId);
    if (empty($SysPlayerInfo))
    {
        $settingNameReplyInfo->setResult(Down_SetNameReply_SetNameResult::dirty_word);
        Logger::getLogger()->error("SetNameApi : user getPlayerTable is null!");
        
        return $settingNameReplyInfo;
    }
    //长度检查
    if (strlen($name) == 0 or strlen($name) > PLAYER_NAME_MAX_LENGTH)
    {
        $settingNameReplyInfo->setResult(Down_SetNameReply_SetNameResult::dirty_word);
        Logger::getLogger()->error("SetNameApi: name length is Illegal, length:". strlen($name));

        return $settingNameReplyInfo;
    }
    //非法字符、敏感词检查
    //名字重复检查
    $serverId = PlayerCacheModule::getServerId($userId);
    if (count(SysPlayer::loadedTable(null, "`server_id`='{$serverId}' and `nickname`='{$name}'")) > 0)
    {
        $settingNameReplyInfo->setResult(Down_SetNameReply_SetNameResult::exists);
        Logger::getLogger()->error("SetNameApi: the name exists!  Name:". $name);

        return $settingNameReplyInfo;
    }

    //收费处理(首次免费)
    if ($SysPlayerInfo->getNickname() != PLAYER_DEFAULT_NAME && strlen($SysPlayerInfo->getNickname()) > 0 )
    {
        $leftGem = $SysPlayerInfo->getGem();
        if ($leftGem >= PLAYER_CHANGE_NAME_PRICE)
        {
            PlayerModule::modifyGem($userId, -PLAYER_CHANGE_NAME_PRICE,"Set Name");
        }
        else
        {
            $settingNameReplyInfo->setResult(Down_SetNameReply_SetNameResult::dirty_word);
            Logger::getLogger()->error("SetNameApi: no enough gem to change name!");
            
            return $settingNameReplyInfo;
        }
    }
//修改名字
    $SysPlayerInfo->setNickname($name);
    $SysPlayerInfo->setLastSetNameTime(time());
    $SysPlayerInfo->save();
    $settingNameReplyInfo->setResult(Down_SetNameReply_SetNameResult::success);

    return $settingNameReplyInfo;
}
