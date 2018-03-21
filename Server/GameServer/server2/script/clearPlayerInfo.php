<?php

require_once($GLOBALS ['GAME_ROOT'] . "WorldSvc.php");
require_once($GLOBALS ['GAME_ROOT'] . "CMySQL.php");

class clearPlayerInfo
{
    public static function clearByUserId($userId)
    {
        if (WorldSvc::getInstance()->isProduction()) {
            return;
        }
        MySQL::getInstance()->RunQuery("delete from `user_server` where `user_id` = '{$userId}'");

        MySQL::getInstance()->RunQuery("delete from `player` where `user_id` = '{$userId}'");
        MySQL::getInstance()->RunQuery("delete from `player_act_stage` where `user_id` = '{$userId}'");
        MySQL::getInstance()->RunQuery("delete from `player_arena` where `user_id` = '{$userId}'");
        MySQL::getInstance()->RunQuery("delete from `player_battle` where `user_id` = '{$userId}'");
        MySQL::getInstance()->RunQuery("delete from `player_chat` where `user_id` = '{$userId}'");
        MySQL::getInstance()->RunQuery("delete from `player_connection_info` where `user_id` = '{$userId}'");
        MySQL::getInstance()->RunQuery("delete from `player_daily_login` where `user_id` = '{$userId}'");
        MySQL::getInstance()->RunQuery("delete from `player_elite_stage` where `user_id` = '{$userId}'");
        MySQL::getInstance()->RunQuery("delete from `player_guild` where `user_id` = '{$userId}'");
        MySQL::getInstance()->RunQuery("delete from `player_guild_apply_info` where `user_id` = '{$userId}'");
        MySQL::getInstance()->RunQuery("delete from `player_hero` where `user_id` = '{$userId}'");
        MySQL::getInstance()->RunQuery("delete from `player_hire_hero` where `user_id` = '{$userId}'");
        MySQL::getInstance()->RunQuery("delete from `player_items` where `user_id` = '{$userId}'");
        MySQL::getInstance()->RunQuery("delete from `player_mail` where `user_id` = '{$userId}'");
        MySQL::getInstance()->RunQuery("delete from `player_month_card` where `user_id` = '{$userId}'");
        MySQL::getInstance()->RunQuery("delete from `player_normal_stage` where `user_id` = '{$userId}'");
        MySQL::getInstance()->RunQuery("delete from `player_notify` where `user_id` = '{$userId}'");
        MySQL::getInstance()->RunQuery("delete from `player_provide_hero` where `user_id` = '{$userId}'");
        MySQL::getInstance()->RunQuery("delete from `player_shop` where `user_id` = '{$userId}'");
        MySQL::getInstance()->RunQuery("delete from `player_skill` where `user_id` = '{$userId}'");
        MySQL::getInstance()->RunQuery("delete from `player_task` where `user_id` = '{$userId}'");
        MySQL::getInstance()->RunQuery("delete from `player_tavern` where `user_id` = '{$userId}'");
        MySQL::getInstance()->RunQuery("delete from `player_tbc` where `user_id` = '{$userId}'");
        MySQL::getInstance()->RunQuery("delete from `player_tutorial` where `user_id` = '{$userId}'");
        MySQL::getInstance()->RunQuery("delete from `player_vip` where `user_id` = '{$userId}'");
        MySQL::getInstance()->RunQuery("delete from `player_vitality` where `user_id` = '{$userId}'");
    }

    public static function clearByServerId($serverId)
    {
        if (WorldSvc::getInstance()->isProduction()) {
            return;
        }

        require_once($GLOBALS['GAME_ROOT'] . "DbModule/SysUserServer.php");
        $userServerList = SysUserServer::loadedTable(array("user_id"), array("server_id"=>$serverId));
        /** @var TbUserServer $userServer */
        foreach ($userServerList as $userServer) {
            self::clearByUserId($userServer->getUserId());
        }
    }
}



