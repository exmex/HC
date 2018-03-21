<?php
/*
 * an.xu
 * 公会信息功能
 *
 * */
require_once($GLOBALS['GAME_ROOT'] . "DbModule/SysPlayerGuild.php");
require_once($GLOBALS['GAME_ROOT'] . "DbModule/SysGuildInfo.php");
require_once($GLOBALS['GAME_ROOT'] . "DbModule/SysGuildStage.php");
require_once($GLOBALS['GAME_ROOT'] . "DbModule/SysGuildStageDrop.php");
require_once($GLOBALS['GAME_ROOT'] . "DbModule/SysPlayerGuildStage.php");
require_once($GLOBALS['GAME_ROOT'] . "DbModule/SysPlayerGuildAppQueue.php");
require_once($GLOBALS['GAME_ROOT'] . "DbModule/SysGuildStageBattleHistory.php");
require_once($GLOBALS['GAME_ROOT'] . "DbModule/SysGuildStageItemsHistory.php");
require_once($GLOBALS['GAME_ROOT'] . "DbModule/SysPlayerGuildApplyInfo.php");
require_once($GLOBALS['GAME_ROOT'] . "DbModule/SysPlayerProvideHero.php");
require_once($GLOBALS['GAME_ROOT'] . "DbModule/SysPlayerHireHero.php");
require_once($GLOBALS['GAME_ROOT'] . "Classes/PlayerModule.php");
require_once($GLOBALS['GAME_ROOT'] . "Classes/VitalityModule.php");
require_once($GLOBALS['GAME_ROOT'] . "Classes/DataModule.php");
require_once($GLOBALS['GAME_ROOT'] . "Classes/VipModule.php");
require_once($GLOBALS['GAME_ROOT'] . "Classes/ItemModule.php");
require_once($GLOBALS['GAME_ROOT'] . "Classes/PlayerCacheModule.php");
require_once($GLOBALS['GAME_ROOT'] . "Classes/TaskModule.php");
require_once($GLOBALS['GAME_ROOT'] . "Classes/LootModule.php");


class GuildModule
{
    /** 公会成员数量 */
    const GUILD_MEMBER_NUM = 50;

    /** 创建公会的花销 */
    const GUILD_CREATE_COST = 500;

    /** 公会开发所需要的最低等级 */
    const GUILD_OPEN_LEVEL = 32;

    /** 工会活跃度上限 */
    const GUILD_MAX_VITALITY = 200000;

    /** 公会成员每日可贡献的活跃度上限 */
    const GUILD_MEMBER_DAY_MAX_VITALITY = 600;

    /** 公会每日最大分配次数 */
    const GUILD_MAX_DISTRIBUTE_NUM = 100;

    /** 最大比例制(进度等) */
    const GUILD_MAX_PERCENT = 10000;

    /** 战斗选武将阶段的超时 */
    const GUILD_PRE_OVER_TIME = 60;

    /** 战斗过程的超时 */
    const GUILD_BATTLE_OVER_TIME = 120;

    private static $_tbPlayerGuildArr = array();
    private static $_tbGuildInfoArray = array();

    private static $_stageRaidArr = array();

    /** @var SysPlayerGuildStage 用户的公会副本挑战记录 */
    private static $_playerGuildStage = null;

    /**
     * 更新公会的活跃度相关
     *
     * @param $userId
     * @param $vitality
     */
    public static function addVitality($userId, $vitality)
    {
        $userGuildTable = self::getTbPlayerGuild($userId);
        if ($userGuildTable->getGuildId() <= 0)
        {
            return;
        }

        $addVitality = min(self::GUILD_MEMBER_DAY_MAX_VITALITY - $userGuildTable->getVitality(), $vitality);
        if ($addVitality > 0)
        {
            $userGuildTable->setVitality($userGuildTable->getVitality() + $addVitality);
            $userGuildTable->setVitalityTime(time());
            $userGuildTable->inOrUp();

            //增加公会活跃度
            $SysGuildInfo = self::getTbGuildInfo($userGuildTable->getGuildId());
            $target = min($SysGuildInfo->getVitality() + $addVitality, self::GUILD_MAX_VITALITY);
            if ($target != $SysGuildInfo->getVitality())
            {
                $SysGuildInfo->setVitality($target);
                $SysGuildInfo->save();
            }
        }

    }

    public static function getUserGuildDownInfo($userId)
    {
        $userGuildTable = self::getTbPlayerGuild($userId);
        $downGuildInfo = new Down_UserGuild();
        if ($userGuildTable->getGuildId()) {
            $guildTb = self::getTbGuildInfo($userGuildTable->getGuildId());

            $downGuildInfo->setId($guildTb->getId());
            $downGuildInfo->setName($guildTb->getGuildName());
            if ($guildTb->getHostId() == $userId)
                $downGuildInfo->setJob(Down_GuildJobT::chairman);
            else
                $downGuildInfo->setJob(Down_GuildJobT::member);
            $downGuildInfo->setReqGuildId(0); //该字段客户端没有使用
        } else {
            $downGuildInfo->setId(0);
            $downGuildInfo->setName("");
            $downGuildInfo->setJob(Down_GuildJobT::member);
        }
        return $downGuildInfo;
    }

    /**
     * 获取自己的公会ID
     *
     * @param $userId
     * @return int
     */
    public static function getGuildIdByUserId($userId)
    {
        $SysPlayerGuild = self::getTbPlayerGuild($userId);
        if ($SysPlayerGuild->getGuildId() > 0)
        {
            return $SysPlayerGuild->getGuildId();
        }

        return 0;
    }

    /**
     *
     * @param $userId
     * @return TbPlayerGuild TbPlayerGuild
     */
    public static function getTbPlayerGuild($userId)
    {
        if (isset(self::$_tbPlayerGuildArr[$userId]))
        {
            return self::$_tbPlayerGuildArr[$userId];
        }

        $SysPlayerGuildInfo = new SysPlayerGuild();
        $SysPlayerGuildInfo->setUserId($userId);
        if ($SysPlayerGuildInfo->loaded())
        {
            $isChanged = false;
            //膜拜次数限制
            if (SQLUtil::isTimeNeedReset($SysPlayerGuildInfo->getWorshipLastTime()))
            {
                $SysPlayerGuildInfo->setWorshipLastTime(0);
                $SysPlayerGuildInfo->setWorshipNumber(0);
                $SysPlayerGuildInfo->setWorshipUid("");
                $isChanged = true;
            }
            //每日活跃度清空
            if ($SysPlayerGuildInfo->getVitality() > 0 && SQLUtil::isTimeNeedReset($SysPlayerGuildInfo->getVitalityTime()))
            {
                $SysPlayerGuildInfo->setVitality(0);
                $SysPlayerGuildInfo->setVitalityTime(0);
                $isChanged = true;
            }

            if ($isChanged)
            {
                $SysPlayerGuildInfo->inOrUp();
            }
        }
        self::$_tbPlayerGuildArr[$userId] = $SysPlayerGuildInfo;

        return $SysPlayerGuildInfo;
    }

    /**
     * @param $guildId
     * @return TbGuildInfo
     */
    public static function getTbGuildInfo($guildId)
    {
        if (isset(self::$_tbGuildInfoArray[$guildId])) {
            return self::$_tbGuildInfoArray[$guildId];
        }

        $SysGuildInfo = new SysGuildInfo();
        $SysGuildInfo->setId($guildId);
        if ($SysGuildInfo->loaded())
        {
            if ($SysGuildInfo->getDistributeNum() > 0 && SQLUtil::isTimeNeedReset($SysGuildInfo->getDistributeTime())) {
                $SysGuildInfo->setDistributeNum(0);
                $SysGuildInfo->setDistributeTime(0);
                $SysGuildInfo->save();
            }
        }

        self::$_tbGuildInfoArray[$guildId] = $SysGuildInfo;

        return $SysGuildInfo;
    }

    /**
     * _query
     *
     * @param $userId
     */
    public static function openGuildPanel($userId)
    {
        $guildReplyInfo = new Down_GuildReply();
        $SysPlayerGuildInfo = self::getTbPlayerGuild($userId);
        if ($SysPlayerGuildInfo->getGuildId() > 0)
        {
            //获取公会信息
            $guildQuery = new Down_GuildQuery();
            $guildInfo = self::getDownGuildInfo($SysPlayerGuildInfo->getGuildId(), $userId);
	        $guildQuery->setInfo($guildInfo);
            $guildWorship = new Down_GuildWorship();
            $guildWorship->setUseTimes($SysPlayerGuildInfo->getWorshipNumber());
            $guildWorship->setTimes($SysPlayerGuildInfo->getWorshipRewardNumber());
            $rewardString = $SysPlayerGuildInfo->getWorshipRewardInfo();
            $rewardArray = explode(",", $rewardString);
            $rewardTempArray = array();
            foreach ($rewardArray as $Values)
            {
                if (strlen($Values) <= 0)
                {
                    continue;
                }
                $tempValuesArray = explode(":", $Values);

                $rewardTempArray[$tempValuesArray[0]] = $tempValuesArray[1];
            }
            //发送奖励
            foreach ($rewardTempArray as $k=>$v)
            {
                $worshipReward = new Down_WorshipReward();
                $worshipReward->setType($k);
                $worshipReward->setParam1($v);
                $guildWorship->appendRewards($worshipReward);
            }
            $guildQuery->setWorship($guildWorship);
            $guildReplyInfo->setQuery($guildQuery);
        }
        else
        {
            //获取公会列表 _list
            $guildList = new Down_GuildList();
            $guildList->setResult(Down_Result::success);
            $serverId = PlayerCacheModule::getServerId($userId);
            $userLevel = PlayerCacheModule::getPlayerLevel($userId);
            $where = "server_id = {$serverId} and state = 1 and min_level_limit <= '{$userLevel}' and user_number < " . self::GUILD_MEMBER_NUM." limit 20";
            $SysGuildInfoArray = SysGuildInfo::loadedTable(null,$where);
            $allGuildIdArray = array();
            foreach ($SysGuildInfoArray as $SysGuildInfo)
            {
                $allGuildIdArray[] = $SysGuildInfo->getId();
            }
            $Down_UserSummaryArray = self::getDown_UserSummary($allGuildIdArray, "and G.guild_position = 1 ");
            foreach ($SysGuildInfoArray as $SysGuildInfo)
            {
                $guildSummaryReplay = new Down_GuildSummary();
                $guildSummaryReplay->setId($SysGuildInfo->getId());
                $guildSummaryReplay->setName($SysGuildInfo->getGuildName());
                $guildSummaryReplay->setAvatar($SysGuildInfo->getAvatar());
                $guildSummaryReplay->setSlogan($SysGuildInfo->getIntro()); //描述信息
                $guildSummaryReplay->setJoinType($SysGuildInfo->getJoinType());
                $guildSummaryReplay->setJoinLimit($SysGuildInfo->getMinLevelLimit()); //等级限制
                $guildSummaryReplay->setMemberCnt($SysGuildInfo->getUserNumber());
                $guildSummaryReplay->setCanJump($SysGuildInfo->getCanJump());
                if (isset($Down_UserSummaryArray[$SysGuildInfo->getId()]))
                {
                    $Down_UserSummary = array_pop($Down_UserSummaryArray[$SysGuildInfo->getId()]);
                    $guildSummaryReplay->setPresident($Down_UserSummary);
                }
                else
                {
                    continue;
                }

                $guildList->appendGuilds($guildSummaryReplay);
            }

            $guildReplyInfo->setList($guildList);

        }
        return $guildReplyInfo;
    }

    /**
     * 创建公会
     *
     * @param $userId
     * @param $guildName
     * @param $avatar
     * @return Down_GuildReply
     */
    public static function createGuildInfo($userId, $guildName, $avatar)
    {
        $serverId = PlayerCacheModule::getServerId($userId);
        $guildReplyInfo = new Down_GuildReply();

        $guildCreateInfo = new Down_GuildCreate();
        
      
        //检查等级
        $userLevel = PlayerCacheModule::getPlayerLevel($userId);
        if($userLevel < self::GUILD_OPEN_LEVEL)
        {
        	Logger::getLogger()->error("createGuild level not enough:" . $userLevel);
            $guildCreateInfo->setResult(Down_Result::fail);
            $guildReplyInfo->setCreate($guildCreateInfo);

            return $guildReplyInfo;
        }
        //检查消耗
        $SysPlayer = PlayerModule::getPlayerTable($userId);
        if ($SysPlayer->getGem() < self::GUILD_CREATE_COST)
        {
            Logger::getLogger()->error("createGuild gem not enough:" . $SysPlayer->getGem());
            $guildCreateInfo->setResult(Down_Result::fail);
            $guildReplyInfo->setCreate($guildCreateInfo);
            return $guildReplyInfo;
        }
      
        //是否已经创建过公会
        $SysGuildInfo = new SysGuildInfo();
        $SysGuildInfo->setHostId($userId);
        $SysGuildInfo->setServerId($serverId);
        if ($SysGuildInfo->LoadedExistFields())
        {
            Logger::getLogger()->error("createGuild have a guild:");
            $guildCreateInfo->setResult(Down_Result::fail);
            $guildReplyInfo->setCreate($guildCreateInfo);
            return $guildReplyInfo;
        }
        //当前还在某公会中
        $SysPlayerGuild = self::getTbPlayerGuild($userId);
        if ($SysPlayerGuild->getGuildId() > 0)
        {
            Logger::getLogger()->error("createGuild already join a guild, {$SysPlayerGuild->getGuildId()}");
            $guildCreateInfo->setResult(Down_Result::fail);
            $guildReplyInfo->setCreate($guildCreateInfo);
            return $guildReplyInfo;
        }
        
        
        PlayerModule::modifyGem($userId, -self::GUILD_CREATE_COST, "createGuild");
        //建立工会
        $SysGuildInfo = new SysGuildInfo();
        $SysGuildInfo->setHostId($userId);
        $SysGuildInfo->setGuildName($guildName);
        $SysGuildInfo->setIntro("");
        $SysGuildInfo->setAvatar($avatar);
        $SysGuildInfo->setJoinType(Down_GuildJoinT::no_verify);
        $SysGuildInfo->setServerId($serverId);
        $SysGuildInfo->setState(1);
        $SysGuildInfo->setVitality(0);
        $SysGuildInfo->setMinLevelLimit(self::GUILD_OPEN_LEVEL);
        $SysGuildInfo->setUserNumber(1);
        $SysGuildInfo->inOrUp();

        $guildId = $SysGuildInfo->getId();
        self::$_tbGuildInfoArray[$guildId] = $SysGuildInfo;
        //把自己加入到工会中并设置管理员权限
        $SysPlayerGuild->setUserId($userId);
        $SysPlayerGuild->setGuildId($guildId);
        $SysPlayerGuild->setVitality(0);
        $SysPlayerGuild->setGuildPosition(Down_GuildJobT::chairman);
        $SysPlayerGuild->inOrUp();
        //删除掉用户的所有申请信息
        $sql = "delete from player_guild_apply_info where user_id = '{$userId}' ";
        MySQL::getInstance()->RunQuery($sql);
        $guildCreateInfo->setResult(Down_Result::success);
        $guildInfo = self::getDownGuildInfo($guildId, $userId);
        $guildCreateInfo->setGuildInfo($guildInfo);
        $guildReplyInfo->setCreate($guildCreateInfo);
        //行为日志
        LogAction::getInstance()->log('CREATE_ALLIANCE', array(
        			'allianceName'	=> $guildName,
        			'avatar'		=> $avatar,
        			'golden'		=> self::GUILD_CREATE_COST
        		)
        );

       //公会日志--start
        $field['userId']=$userId;
        $field['guildName']=$guildName;
        $guild_log_format=self::write_guild_log($field,1);
        self::guild_log($guildId, $guild_log_format);
		//--end
        return $guildReplyInfo;
    }

    /**
     * 解散公会
     * @param $userId
     */
    public static function dismissGuildInfo($userId)
    {
        $guildReplyInfo = new Down_GuildReply();
        $guildDismissInfo = new Down_GuildDismiss();
        $SysPlayerGuildInfo = self::getTbPlayerGuild($userId);
        $guildId = $SysPlayerGuildInfo->getGuildId();
        if ($guildId <= 0)
        {
            Logger::getLogger()->error("dismissGuild no have guild:");
            $guildDismissInfo->setResult(Down_Result::fail);
            $guildReplyInfo->setDismiss($guildDismissInfo);

            return $guildReplyInfo;
        }
        //验证权限
        if ($SysPlayerGuildInfo->getGuildPosition() != Down_GuildJobT::chairman)
        {
            Logger::getLogger()->error("dismissGuild power not enough:");
            $guildDismissInfo->setResult(Down_Result::fail);
            $guildReplyInfo->setDismiss($guildDismissInfo);

            return $guildReplyInfo;
        }
        //需要更新所有公会成员的memcache缓存信息和相关表的信息
        $SysPlayerGuildArray = SysPlayerGuild::loadedTable("user_id", " guild_id = '{$guildId}' ");
        foreach ($SysPlayerGuildArray as $SysPlayerGuild)
        {
            PlayerCacheModule::deleteGuildCache($SysPlayerGuild->getUserId());
        }
        $sql = "delete from player_hire_hero where guild_id = '{$guildId}' ";
        MySQL::getInstance()->RunQuery($sql);

        $sql = "delete from player_provide_hero where guild_id = '{$guildId}' ";
        MySQL::getInstance()->RunQuery($sql);
        //删除所有成员
        $sql = "delete from player_guild where guild_id = '{$guildId}' ";
        MySQL::getInstance()->RunQuery($sql);
        //删除所有的公会申请
        $sql = "delete from player_guild_apply_info where guild_id = '{$guildId}' ";
        MySQL::getInstance()->RunQuery($sql);
        //干掉公会
        $sql = "delete from guild_info where id = '{$guildId}' ";
        MySQL::getInstance()->RunQuery($sql);
        $guildDismissInfo->setResult(Down_Result::success);
        $guildReplyInfo->setDismiss($guildDismissInfo);

        return $guildReplyInfo;
    }

    /**
     * 搜索查找公会
     *
     * 搜索不到数据时无法发送数据到客户端
     *
     * @param $guildId
     * @return Down_GuildReply
     */
    public static function findGuildInfo($userId, $guildId)
    {
        $guildReply = new Down_GuildReply();
        $guildFind = new Down_GuildSearch();
        $guildFind->setResult(Down_Result::success);
        $serverId = PlayerCacheModule::getServerId($userId);
        $guildId = intval($guildId);
        if ($guildId <= 0)
        {
            Logger::getLogger()->error("findGuild error guildId:");
            $guildReply->setSearch($guildFind);
            return $guildReply;
        }

        $SysGuildInfo = self::getTbGuildInfo($guildId);
        if ($SysGuildInfo->getServerId() != $serverId)
        {
            Logger::getLogger()->error("findGuild error serverId:");
            $guildReply->setSearch($guildFind);

            return $guildReply;
        }

        $guildSummary = self::getDown_GuildSummary($guildId);
        if (!empty($guildSummary))
        {
            $guildFind->setGuilds($guildSummary);
        }
        $guildReply->setSearch($guildFind);

        return $guildReply;
    }

    /**
     * 加入公会
     *
     * @param $userId
     * @param $guildId
     * @return Down_GuildReply|null
     */
    public static function joinInGuild($userId, $guildId)
    {
        $guildReply = new Down_GuildReply();
        $guildJoin = new Down_GuildJoin();
        $guildJoin->setJoinGuildId(0);
        $serverId = PlayerCacheModule::getServerId($userId);
        $guildId = intval($guildId);
        if ($guildId <= 0)
        {
            Logger::getLogger()->error("joinInGuild error guildId:".$guildId);
            $guildJoin->setResult(0);
            $guildReply->setJoin($guildJoin);

            return $guildReply;
        }

        $SysGuildInfo = self::getTbGuildInfo($guildId);
        if ($SysGuildInfo->getServerId() != $serverId)
        {
            Logger::getLogger()->error("joinInGuild error serverId:".$serverId);
            $guildJoin->setResult(0);
            $guildReply->setJoin($guildJoin);

            return $guildReply;
        }

        //用户已经有公会
        $SysPlayerGuild = self::getTbPlayerGuild($userId);
        if ($SysPlayerGuild->getGuildId() > 0)
        {
            Logger::getLogger()->error("joinInGuild error already have guild:");
            $guildJoin->setResult(0);
            $guildReply->setJoin($guildJoin);

            return $guildReply;
        }

        //刚退出公会的限制条件,退出一小时内无法加入任何公会,48小时内无法回到原公会
        if (($SysPlayerGuild->getLastQuitTime() + 3600) > time())
        {
            Logger::getLogger()->error("joinInGuild error one hour CD:");
            $guildJoin->setResult(0);
            $guildReply->setJoin($guildJoin);

            return $guildReply;
        }

        if ($guildId == $SysPlayerGuild->getLastGuildId() && ($SysPlayerGuild->getLastQuitTime() + 48 * 3600) > time())
        {
            Logger::getLogger()->error("joinInGuild error 48 hour CD:");
            $guildJoin->setResult(0);
            $guildReply->setJoin($guildJoin);

            return $guildReply;
        }

        //判断进入公会的限制条件----用户等级
        $userLevel = PlayerCacheModule::getPlayerLevel($userId);
        if ($userLevel < $SysGuildInfo->getMinLevelLimit())
        {
            Logger::getLogger()->error("joinInGuild error level:");
            $guildJoin->setResult(0);
            $guildReply->setJoin($guildJoin);

            return $guildReply;
        }

        //公会人数限制
        if ($SysGuildInfo->getUserNumber() >= self::GUILD_MEMBER_NUM)
        {
            Logger::getLogger()->error("joinInGuild error is full:");
            $guildJoin->setResult(0);
            $guildReply->setJoin($guildJoin);

            return $guildReply;
        }

        //公会的开放程度
        if ($SysGuildInfo->getJoinType() == Down_GuildJoinT::closed)
        { //关闭
            Logger::getLogger()->error("joinInGuild error is closed:");

            return null;
        }
        elseif($SysGuildInfo->getJoinType() == Down_GuildJoinT::verify)
        { //需要管理员验证
            //加入到审批表
            $SysPlayerGuildApplyInfo = new SysPlayerGuildApplyInfo();
            $SysPlayerGuildApplyInfo->setUserId($userId);
            $SysPlayerGuildApplyInfo->setGuildId($guildId);
            if ($SysPlayerGuildApplyInfo->LoadedExistFields())
            {
                Logger::getLogger()->error("joinInGuild error need verify:");
            }
            else
            {
                $SysPlayerGuildApplyInfo->setApplyTime(time());
               // $SysPlayerGuildApplyInfo->setApplyTime(time());
                $SysPlayerGuildApplyInfo->inOrUp();
            }
            $guildJoin->setResult(Down_GuildJoin_JoinResult::join_wait);
        }
        else
        { //可直接进入
            $SysPlayerGuild->setGuildId($guildId);
            $SysPlayerGuild->setGuildPosition(Down_GuildJobT::member);
            $SysPlayerGuild->inOrUp();
            $guildJoin->setResult(Down_GuildJoin_JoinResult::join_enter);
            $SysGuildInfo->setUserNumber($SysGuildInfo->getUserNumber() + 1);
            $SysGuildInfo->save();
            //删除掉用户的所有申请信息
            $sql = "delete from player_guild_apply_info where user_id = '{$userId}' ";
            $rs = MySQL::getInstance()->RunQuery($sql);
            //公会日志--start
            $field['userId'] = $userId;
            $message = self::write_guild_log($field, 2);
            self::guild_log($guildId, $message);
            //--end
        }




        $guildJoin->setJoinGuildId($guildId);
        $guildJoin->setGuildInfo(self::getDownGuildInfo($guildId, $userId));
        $guildReply->setJoin($guildJoin);

        return $guildReply;
    }

    /**
     * 用户退出公会
     *
     * @param $userId
     * @return Down_GuildReply
     */
    public static function leaveGuild($userId)
    {
        $guildReplyInfo = new Down_GuildReply();
        $guildLeaveReply = new Down_GuildLeave();
        $guildLeaveReply->setResult(Down_Result::fail);

        //获取公会
        $SysPlayerGuild = self::getTbPlayerGuild($userId);
        $guildId=$SysPlayerGuild->getGuildId();
        if ($SysPlayerGuild->getGuildId() > 0)
        {
            $SysGuildInfo = self::getTbGuildInfo($SysPlayerGuild->getGuildId());
            //公会创始人不允许离开,只允许其解散
            if ($SysPlayerGuild->getGuildPosition() == Down_GuildJobT::chairman)
            {
                if ($SysGuildInfo->getHostId() > 0 && $SysGuildInfo->getHostId() == $userId)
                {
                    Logger::getLogger()->debug("leaveGuild is master:");
                    $guildReplyInfo->setLeave($guildLeaveReply);

                    return $guildReplyInfo;
                }
            }
        }
        else
        {
            Logger::getLogger()->debug("leaveGuild is no have guild:");
            $guildReplyInfo->setLeave($guildLeaveReply);

            return $guildReplyInfo;
        }

        PlayerCacheModule::deleteGuildCache($SysPlayerGuild->getUserId());
        self::deleteHireInfo($SysPlayerGuild->getUserId());

        $SysPlayerGuild->setLastGuildId($SysPlayerGuild->getGuildId());
        $SysPlayerGuild->setGuildId(0);
        $SysPlayerGuild->setLastQuitTime(time());
        $SysPlayerGuild->save();

        $SysGuildInfo->setUserNumber($SysGuildInfo->getUserNumber() - 1);
        $SysGuildInfo->save();

        $guildLeaveReply->setResult(Down_Result::success);
        $guildReplyInfo->setLeave($guildLeaveReply);

        //行为日志
        LogAction::getInstance()->log('ALLIANCE_EXIT', array(
        		'allianceName' => $SysGuildInfo->getGuildName()
       		)
        );

        //公会日志--start
        $field['userId']=$userId;
        $message = self::write_guild_log($field, 3);
        self::guild_log($guildId, $message);
        //--end

        return $guildReplyInfo;
    }

    /**
     * 膜拜英雄操作
     *
     * @param $userId
     * @param $worshipUid
     * @param $type
     * @return Down_GuildReply
     */
    public static function worshipReq($userId, $worshipUid, $type)
    {
        $guildReply = new Down_GuildReply();
        $guildWorshipReq = new Down_GuildWorshipReq();
        $guildWorshipReq->setResult(Down_Result::fail);

        if ($userId == $worshipUid)
        {
            Logger::getLogger()->error("worshipReq self:");
            $guildReply->setWorshipReq($guildWorshipReq);
            return $guildReply;
        }

        //获取公会
        $SysPlayerGuild = self::getTbPlayerGuild($userId);
        if ($SysPlayerGuild->getGuildId() > 0)
        {
            //
        }
        else
        {
            Logger::getLogger()->error("worshipReq is no have guild:");
            $guildReply->setWorshipReq($guildWorshipReq);
            return $guildReply;
        }

        //被膜拜的人是否在同一公会
        $SysPlayerGuildS = self::getTbPlayerGuild($worshipUid);
        if ($SysPlayerGuild->getGuildId() != $SysPlayerGuildS->getGuildId())
        {
            Logger::getLogger()->error("worshipReq is no same guild:");
            $guildReply->setWorshipReq($guildWorshipReq);
            return $guildReply;
        }

        //战队等级限制
        $myLevel = PlayerCacheModule::getPlayerLevel($userId);
        $worshipLevel = PlayerCacheModule::getPlayerLevel($worshipUid);
        if ($worshipLevel < ($myLevel + 5))
        {
            Logger::getLogger()->error("worshipReq is no same guild:");
            $guildReply->setWorshipReq($guildWorshipReq);
            return $guildReply;
        }

        //膜拜次数限制
        if (SQLUtil::isTimeNeedReset($SysPlayerGuild->getWorshipLastTime()))
        {
            $SysPlayerGuild->setWorshipLastTime(0);
            $SysPlayerGuild->setWorshipNumber(0);
            $SysPlayerGuild->setWorshipUid("");
        }

        $canWorshipNum = VipModule::getVIPModuleLimitByUserId($userId, _VIP_MODULE_TYPE::WORSHIP_TIMES);
        if ($SysPlayerGuild->getWorshipNumber() >= $canWorshipNum)
        {
            Logger::getLogger()->error("worshipReq is reach max times:");
            $guildReply->setWorshipReq($guildWorshipReq);
            return $guildReply;
        }

        //根据膜拜类型,看是否消费
        $cost = 0;
        $costType = "coin";

        $reward = 0;
        $rewardType = "coin";

        $worshipDefineDataArr = DataModule::lookupDataTable(GUILD_WORSHIP_LUA_KEY, $type);
        if (empty($worshipDefineDataArr)) {
            Logger::getLogger()->error("worshipReq type error:{$type}");
            $guildReply->setWorshipReq($guildWorshipReq);
            return $guildReply;
        }
        $getEnergy = $worshipDefineDataArr['Get Vitality'];

        if ($worshipDefineDataArr['Consume'] == true)
        {
            $cost = $worshipDefineDataArr['Price Amount'];
            $costType = $worshipDefineDataArr['Price Type'] == "Diamond" ? "gems" : "coin";
        }

        if ($costType == "gems")
        { //判断对应vip是否启用钻石膜拜
            $vipState = VipModule::getVIPModuleLimitByUserId($userId, _VIP_MODULE_TYPE::DIAMOND_WORSHIP);
            if (empty($vipState))
            {
                Logger::getLogger()->error("worshipReq no enough vip level," . __LINE__);
                $guildReply->setWorshipReq($guildWorshipReq);
                return $guildReply;
            }
        }

        $reward = $worshipDefineDataArr['Reward Amount'];
        $rewardType = $worshipDefineDataArr['Reward Type'] == "Diamond" ? "gems" : "coin";
        $rewardTypeId = $worshipDefineDataArr['Reward Type'] == "Diamond" ? Down_WorshipReward_Type::diamond : Down_WorshipReward_Type::gold;

        if ($cost > 0) {
            $SysPlayer = PlayerModule::getPlayerTable($userId);
            if ($costType == "coin")
            {
                if ($SysPlayer->getMoney() < $cost)
                {
                    Logger::getLogger()->error("worshipReq no enough money, need {$cost}, have {$SysPlayer->getMoney()} " . __LINE__);
                    $guildReply->setWorshipReq($guildWorshipReq);
                    return $guildReply;
                }

                PlayerModule::modifyMoney($userId, -$cost, "worshipReq");
            }

            if ($costType == "gems")
            {
                if ($SysPlayer->getGem() < $cost)
                {
                    Logger::getLogger()->error("worshipReq no enough gems, need {$cost}, have {$SysPlayer->getMoney()} " . __LINE__);
                    $guildReply->setWorshipReq($guildWorshipReq);
                    return $guildReply;
                }

                PlayerModule::modifyGem($userId, -$cost, "worshipReq");
            }
        }

        $uidStr = $SysPlayerGuild->getWorshipUid();
        if (strlen($uidStr) > 0) {
            $uidArr = explode(",", $uidStr);
        }
        $uidArr[] = $worshipUid;
        $uidArr = array_flip(array_flip($uidArr));
        $SysPlayerGuild->setWorshipUid(implode(",", $uidArr));
        $SysPlayerGuild->setWorshipLastTime(time());
        $SysPlayerGuild->setWorshipNumber($SysPlayerGuild->getWorshipNumber() + 1);
        $SysPlayerGuild->save();
        //发送膜拜奖励
        VitalityModule::modifyVitality($userId, $getEnergy, "worshipReq");

        //更新被膜拜人数据
        $haveRewardStr = $SysPlayerGuildS->getWorshipRewardInfo();
        $haveRewardArr1 = explode(",", $haveRewardStr);
        $haveRewardArr = array();
        foreach ($haveRewardArr1 as $reStr_)
        {
            if (strlen($reStr_) <= 0)
            {
                continue;
            }
            $reArr_ = explode(":", $reStr_);
            $haveRewardArr[$reArr_[0]] = $reArr_[1];
        }

        if (isset($haveRewardArr[$rewardTypeId]))
        {
            $haveRewardArr[$rewardTypeId] += $reward;
        }
        else
        {
            $haveRewardArr[$rewardTypeId] = $reward;
        }
        $infoArr = array();
        foreach ($haveRewardArr as $kk => $rew_)
        {
            $infoArr[] = $kk . ":" . $rew_;
        }

        $SysPlayerGuildS->setWorshipRewardInfo(implode(",", $infoArr));
        $SysPlayerGuildS->setWorshipRewardNumber($SysPlayerGuildS->getWorshipRewardNumber() + 1);
        $SysPlayerGuildS->setWorshipRewardLastTime(time());
        $SysPlayerGuildS->save();

        $guildWorshipReq->setResult(Down_Result::success);
        $guildReply->setWorshipReq($guildWorshipReq);

        //行为日志
        LogAction::getInstance()->log('ALLIANCE_CANBAI', array(
        		'currentContribution'	=> $SysPlayerGuild->getContribution(),
        		'consumeType'			=> $costType,
        		'consumeNum'			=> $cost
        	)
        );

        return $guildReply;
    }

    /**
     * 领膜拜奖励
     *
     * @param $userId
     * @return Down_GuildReply
     */
    public static function worshipWithdraw($userId)
    {
        $guildReply = new Down_GuildReply();
        $guildWorshipWithdraw = new Down_GuildWorshipWithdraw();
        $guildWorshipWithdraw->setResult(Down_Result::fail);

        //获取公会
        $SysPlayerGuild = self::getTbPlayerGuild($userId);
        if ($SysPlayerGuild->getGuildId() > 0)
        {
            //
        }
        else
        {
            Logger::getLogger()->debug("worshipWithdraw is no have guild:");
            $guildReply->setWorshipWithdraw($guildWorshipWithdraw);
            return $guildReply;
        }

        $rewardStr = $SysPlayerGuild->getWorshipRewardInfo();
        $rewardArr1 = explode(",", $rewardStr);
        $rewardArr = array();
        foreach ($rewardArr1 as $reStr_)
        {
            if (strlen($reStr_) <= 0)
            {
                continue;
            }
            $rewArr_ = explode(":", $reStr_);
            $rewardArr[$rewArr_[0]] = $rewArr_[1];
        }

        //发送奖励
        foreach ($rewardArr as $kk => $vv)
        {
            if ($kk == Down_WorshipReward_Type::gold)
            {
                PlayerModule::modifyMoney($userId, $vv, "worshipWithdraw");
            }
            elseif ($kk == Down_WorshipReward_Type::diamond)
            {
                PlayerModule::modifyGem($userId, $vv, "worshipWithdraw");
            }

            $worshipReward = new Down_WorshipReward();
            $worshipReward->setType($kk);
            $worshipReward->setParam1($vv);
            $guildWorshipWithdraw->appendRewards($worshipReward);
        }

        $SysPlayerGuild->setWorshipRewardInfoNull();
        $SysPlayerGuild->setWorshipRewardClaimTime(time());
        $SysPlayerGuild->setWorshipRewardNumber(0);
        $SysPlayerGuild->save();

        $guildWorshipWithdraw->setResult(Down_Result::success);
        $guildReply->setWorshipWithdraw($guildWorshipWithdraw);
        return $guildReply;
    }

    /**
     * 添加佣兵
     *
     * @param $userId
     * @param $heroTid
     * @return Down_GuildReply
     */
    public static function addHire($userId, $heroTid)
    {
        $guildReplyInfo = new Down_GuildReply();
        $guildAddHire = new Down_GuildAddHire();
        $guildAddHire->setResult(Down_Result::fail);
        $guildAddHire->setIncome(0); //价格
        //获取公会
        $SysPlayerGuildInfo = self::getTbPlayerGuild($userId);
        if ($SysPlayerGuildInfo->getGuildId() <= 0)
        {
            Logger::getLogger()->error("addHire is no have guild:");
            $guildReplyInfo->setAddHire($guildAddHire);

            return $guildReplyInfo;
        }
        //检查当前已经派出的用户数量
        $canDispatchNum = VipModule::getVIPModuleLimitByUserId($userId, _VIP_MODULE_TYPE::GUILD_HERO_DISPATCH_LIMIT);
        $SysPlayerProvideHeroArray = SysPlayerProvideHero::loadedTable(null, " user_id = '{$userId}' ");
        if (count($SysPlayerProvideHeroArray) >= $canDispatchNum)
        {
            Logger::getLogger()->error("addHire is reach max user:");
            $guildReplyInfo->setAddHire($guildAddHire);

            return $guildReplyInfo;
        }
        //当前武将是否已经被派出了,防止重复
        foreach ($SysPlayerProvideHeroArray as $SysPlayerProvideHero)
        {
            if ($SysPlayerProvideHero->getHeroTid() == $heroTid)
            {
                Logger::getLogger()->error("addHire is duplicate:");
                $guildReplyInfo->setAddHire($guildAddHire);

                return $guildReplyInfo;
            }
        }
        //检查武将是否存在并属于自己
        $heroList = HeroModule::getAllHeroTable($userId, array($heroTid));
        if (!isset($heroList[$heroTid]))
        {
            Logger::getLogger()->error("addHire no have hero:");
            $guildReplyInfo->setAddHire($guildAddHire);

            return $guildReplyInfo;
        }
        TaskModule::updateDailyTaskProgress($userId, DAILY_TASK_SEND_MERCENARY);
        //更新武将的状态
        $SysHeroArray = $heroList[$heroTid];
        $SysHeroArray->setState(Down_HeroStatus::hire);
        $SysHeroArray->save();

        $SysPlayerProvideHero = new SysPlayerProvideHero();
        $SysPlayerProvideHero->setUserId($userId);
        $SysPlayerProvideHero->setGuildId($SysPlayerGuildInfo->getGuildId());
        $SysPlayerProvideHero->setProvideTime(time());
        $SysPlayerProvideHero->setHeroTid($heroTid);
        $SysPlayerProvideHero->inOrUp();
        //--计算时间收入公式 = (武将战力*"Base Income Ratio Per Second" + "Base Income Per Second") * 时间
        //--最小结算时间为半小时
        //半小时内的收益
        $power = HeroModule::getHeroGs($userId, $heroTid);
        $guildHirePriceDefineArray = DataModule::lookupDataTable(GUILD_HIRE_PRICE_LUA_KEY, 1);
        $income = floor(($power * $guildHirePriceDefineArray['Base Income Ratio Per Second'] + $guildHirePriceDefineArray['Base Income Per Second']) * 1800);
        $guildAddHire->setResult(Down_Result::success);
        $guildAddHire->setIncome($income); //价格
        $guildReplyInfo->setAddHire($guildAddHire);

        return $guildReplyInfo;
    }

    /**
     * 撤回佣兵
     *
     * @param $userId
     * @param $heroTid
     * @return Down_GuildReply
     */
    public static function delHire($userId, $heroTid)
    {
        $guildReplyInfo = new Down_GuildReply();

        $guildDelHire = new Down_GuildDelHire();
        $guildDelHire->setResult(Down_Result::fail);

        $SysPlayerProvideHero = new SysPlayerProvideHero();
        $SysPlayerProvideHero->setUserId($userId);
        $SysPlayerProvideHero->setHeroTid($heroTid);
        if (!$SysPlayerProvideHero->LoadedExistFields())
        {
            Logger::getLogger()->debug("delHire no have hero:");
            $guildReplyInfo->setDelHire($guildDelHire);

            return $guildReplyInfo;
        }
        //半小时内不能撤回
        $time = time() - $SysPlayerProvideHero->getProvideTime();
        if ($time < 1800)
        {
            Logger::getLogger()->debug("delHire no enough time:");
            $guildReplyInfo->setDelHire($guildDelHire);

            return $guildReplyInfo;
        }
        //检查武将是否存在并属于自己
        $heroListArray = HeroModule::getAllHeroTable($userId, array($heroTid));
        if (!isset($heroListArray[$heroTid]))
        {
            Logger::getLogger()->error("delHire no have hero2:");
            $guildReplyInfo->setDelHire($guildDelHire);

            return $guildReplyInfo;
        }
        //更新武将的状态
        $SysHero = $heroListArray[$heroTid];
        $SysHero->setState(Down_HeroStatus::idle);
        $SysHero->save();
        //发送奖励
        $power = HeroModule::getHeroGs($userId, $heroTid);
        $guildHirePriceDefineArr = DataModule::lookupDataTable(GUILD_HIRE_PRICE_LUA_KEY, 1);
        $incomeTime = floor(($power * $guildHirePriceDefineArr['Base Income Ratio Per Second'] + $guildHirePriceDefineArr['Base Income Per Second']) * $time);
        $incomeHire = $SysPlayerProvideHero->getHireIncome();
        PlayerModule::modifyMoney($userId, $incomeTime + $incomeHire, "delHire");
        //撤回
        $SysPlayerProvideHero->delete();

        $guildDelHire->setResult(Down_Result::success);
        $guildDelHire->setHireReward($incomeHire);
        $guildDelHire->setStayReward($incomeTime);
        $guildDelHire->setHeroid($heroTid);
        $guildReplyInfo->setDelHire($guildDelHire);

        return $guildReplyInfo;
    }

    private static function resetHireInfo($userId)
    {
        $lastResetTime = SQLUtil::getLastRestTimeStamp();

        $sql = "delete from player_hire_hero where user_id = '{$userId}' and hire_time < $lastResetTime and hire_from != 1 ";
        MySQL::getInstance()->RunQuery($sql);
    }

    /**
     * 获取自己招募到的武将,战斗验证用
     *
     * @param $userId
     * @param $from
     * @return null
     */
    public static function getUnUseHireHero($userId, $from)
    {
        $SysPlayerHireHeroArr = SysPlayerHireHero::loadedTable(null, " user_id = '{$userId}' and hire_from = '{$from}' and is_use = 0 order by id desc limit 1 ");
        if (is_array($SysPlayerHireHeroArr) && count($SysPlayerHireHeroArr) > 0)
        {
            return $SysPlayerHireHeroArr[0];
        }

        return null;
    }

    /**
     * @param TbPlayerHireHero $SysPlayerHireHero
     */
    public static function updateHireHeroState($SysPlayerHireHero)
    {
        if (empty($SysPlayerHireHero)) {
            return;
        }

        $SysPlayerHireHero->setIsUse(1);
        $SysPlayerHireHero->save();
    }

    /**
     * 清空用户的公会雇佣信息
     *
     * @param $userId
     */
    public static function deleteHireInfo($userId)
    {
        $sql = "delete from player_hire_hero where user_id = '{$userId}' ";
        MySQL::getInstance()->RunQuery($sql);

        $sql = "delete from player_provide_hero where user_id = '{$userId}' ";
        MySQL::getInstance()->RunQuery($sql);

        //更新武将状态
        $hireState = Down_HeroStatus::hire;
        $sql = "update player_hero set state = 0 where user_id = '{$userId}' and state = '{$hireState}' ";
        MySQL::getInstance()->RunQuery($sql);
    }

    /**
     * 查询公会内的佣兵信息
     *
     * @param $userId
     * @param $from
     * @return Down_GuildReply
     */
    public static function queryHires($userId, $from)
    {
        $from = intval($from);
        $guildReply = new Down_GuildReply();
        $guildQueryHires = new Down_GuildQueryHires();
        $guildQueryHires->setFrom($from);

        //获取公会
        $SysPlayerGuild = self::getTbPlayerGuild($userId);
        if ($SysPlayerGuild->getGuildId() > 0) {
            //
        } else {
            Logger::getLogger()->debug("queryHires is no have guild:");
            $guildReply->setQueryHires($guildQueryHires);
            return $guildReply;
        }

        $guildId = $SysPlayerGuild->getGuildId();

        //自动脚本每日清理已经过期的雇用信息
        self::resetHireInfo($userId);

        //获取今天被自己已经雇用过的
        $hiredUserArr = array();
        $SysPlayerHireHeroArr = SysPlayerHireHero::loadedTable(null, " user_id = '{$userId}' ");
        foreach ($SysPlayerHireHeroArr as $SysPlayerHireHero)
        {
            if (!SQLUtil::isTimeNeedReset($SysPlayerHireHero->getHireTime()))
            {
                if (!isset($hiredUserArr[$SysPlayerHireHero->getHireUserId()]))
                {
                    $hiredUserArr[$SysPlayerHireHero->getHireUserId()] = $SysPlayerHireHero->getHireUserId();
                    $guildQueryHires->appendHireUids($SysPlayerHireHero->getHireUserId());
                }
            }
        }

        $guildHirePriceDefineArr = DataModule::lookupDataTable(GUILD_HIRE_PRICE_LUA_KEY, 1);

        //获取公会的所有可雇用信息列表
        $guildHireUserArr = array();
        $sql = "select P.user_id,P.nickname,P.level,P.avatar,H.*,R.* from player as P, player_provide_hero as H, player_hero as R where P.user_id = H.user_id and H.user_id = R.user_id and H.hero_tid = R.tid and H.guild_id = '{$guildId}' ";
        $rs = MySQL::getInstance()->RunQuery($sql);
        while ($value = MySQL::getInstance()->FetchAssoc($rs))
        {

            if (!isset($guildHireUserArr[$value['user_id']]))
            {
                $guildHireUser = new Down_GuildHireUser();
                $guildHireUser->setUid($value['user_id']);
                $guildHireUser->setName($value['nickname']);
                $guildHireUser->setAvatar($value['avatar']);
                $guildHireUser->setLevel($value['level']);
                $guildHireUserArr[$value['user_id']] = $guildHireUser;
            }
            else
            {
                $guildHireUser = $guildHireUserArr[$value['user_id']];
            }

            $hireHeroSummary = new Down_HireHeroSummary();
            $heroSummary = new Down_HeroSummary();
            $heroSummary->setTid($value['tid']);
            $heroSummary->setRank($value['rank']);
            $heroSummary->setLevel($value['level']);
            $heroSummary->setStars($value['stars']);
            $heroSummary->setGs($value['gs']);
            $heroSummary->setState(Down_HeroStatus::hire);
            $hireHeroSummary->setHero($heroSummary);

            //--招募价格 = 武将战力 * "Hire Price Ratio" + "Hire Base Gold"
            $cost = floor($value['gs'] * $guildHirePriceDefineArr['Hire Price Ratio'] + $guildHirePriceDefineArr['Hire Base Gold']);
            $hireHeroSummary->setCost($cost);

            $time = time() - $value['provide_time'];
            if ($time < 1800) {
                $time = 1800;
            }
            $incomeTime = floor(($value['gs'] * $guildHirePriceDefineArr['Base Income Ratio Per Second'] + $guildHirePriceDefineArr['Base Income Per Second']) * $time);
            $incomeHire = $value['hire_income'];
            $hireHeroSummary->setIncome($incomeTime + $incomeHire);
            $hireHeroSummary->setHireTs($value['provide_time']);

            $guildHireUser->appendHeroes($hireHeroSummary);
        }

        foreach ($guildHireUserArr as $guildHireUser) {
            $guildQueryHires->appendUsers($guildHireUser);
        }

        $guildReply->setQueryHires($guildQueryHires);
        return $guildReply;
    }

    /**
     * 雇佣佣兵
     *
     * @param $userId
     * @param $hireUserId
     * @param $hireHeroTid
     * @param $hireFrom
     * @return Down_GuildReply
     */
    public static function hireHero($userId, $hireUserId, $hireHeroTid, $hireFrom)
    {
        $hireFrom = intval($hireFrom);

        $guildReply = new Down_GuildReply();
        $guildHireHero = new Down_GuildHireHero();
        $guildHireHero->setResult(Down_HireResult::fail);

        //获取公会
        $SysPlayerGuild = self::getTbPlayerGuild($userId);
        if ($SysPlayerGuild->getGuildId() > 0)
        {
            //
        }
        else
        {
            Logger::getLogger()->debug("hireHero is no have guild:");
            $guildReply->setHireHero($guildHireHero);
            return $guildReply;
        }

        $guildId = $SysPlayerGuild->getGuildId();
        self::resetHireInfo($userId);

        //同一天只能雇佣同一玩家一次
        $SysPlayerHireHeroArr = SysPlayerHireHero::loadedTable(null, " user_id = '{$userId}' and hire_user_id = '{$hireUserId}' ");
        foreach ($SysPlayerHireHeroArr as $SysPlayerHireHero)
        {
            if (!SQLUtil::isTimeNeedReset($SysPlayerHireHero->getHireTime()))
            {
                Logger::getLogger()->debug("hireHero is have hire from this user today:");
                $guildReply->setHireHero($guildHireHero);

                return $guildReply;
            }
        }

        //只能雇佣比自己战队等级低的玩家武将
        //todo: 这里的问题怪怪的,先不做限制
        $level = PlayerCacheModule::getPlayerLevel($userId);
        $hireLevel = PlayerCacheModule::getPlayerLevel($hireUserId);
        /*if ($hireLevel > $level) {
            Logger::getLogger()->debug("hireHero is high level than me,{$level}, hire:{$hireLevel}:");
            $guildReply->setHireHero($guildHireHero);
            return $guildReply;
        }*/

        //同名英雄不可雇用

        //武将是否被雇佣状态
        $SysPlayerProvideHero = new SysPlayerProvideHero();
        $SysPlayerProvideHero->setUserId($hireUserId);
        $SysPlayerProvideHero->setHeroTid($hireHeroTid);
        if (!$SysPlayerProvideHero->LoadedExistFields())
        {
            Logger::getLogger()->error("hireHero no hire state " . __LINE__);
            $guildReply->setHireHero($guildHireHero);
            return $guildReply;
        }
        //金币是否足够
        $heroList = HeroModule::getAllHeroTable($hireUserId, array($hireHeroTid));
        if (!isset($heroList[$hireHeroTid]))
        {
            Logger::getLogger()->debug("hireHero no have hero:");
            $guildReply->setHireHero($guildHireHero);
            return $guildReply;
        }
        $SysPlayerHeroHire = $heroList[$hireHeroTid];
        $guildHirePriceDefineArr = DataModule::lookupDataTable(GUILD_HIRE_PRICE_LUA_KEY, 1);
        //--招募价格 = 武将战力 * "Hire Price Ratio" + "Hire Base Gold"
        $cost = floor($SysPlayerHeroHire->getGs() * $guildHirePriceDefineArr['Hire Price Ratio'] + $guildHirePriceDefineArr['Hire Base Gold']);
        $SysPlayer = PlayerModule::getPlayerTable($userId);
        if ($SysPlayer->getMoney() < $cost)
        {
            Logger::getLogger()->error("hireHero no enough money, need {$cost}, have {$SysPlayer->getMoney()} " . __LINE__);
            $guildReply->setHireHero($guildHireHero);

            return $guildReply;
        }
        PlayerModule::modifyMoney($userId, -$cost, "hireHero");
        //招募武将
        $SysPlayerHireHero = new SysPlayerHireHero();
        $SysPlayerHireHero->setUserId($userId);
        $SysPlayerHireHero->setHireUserId($hireUserId);
        $SysPlayerHireHero->setHireHeroTid($hireHeroTid);
        $SysPlayerHireHero->setHireFrom($hireFrom);
        if ($SysPlayerHireHero->LoadedExistFields())
        {
            $SysPlayerHireHero->setHireTime(time());
            $SysPlayerHireHero->setGuildId($guildId);
            $SysPlayerHireHero->save();
        }
        else
        {
            $SysPlayerHireHero->setHireTime(time());
            $SysPlayerHireHero->setGuildId($guildId);
            $SysPlayerHireHero->inOrUp();
        }

        //设置对方受益
        $reward = floor($cost * (1 - $guildHirePriceDefineArr['Hire Income Tax Rate']));
        $SysPlayerProvideHero->setHireIncome($SysPlayerProvideHero->getHireIncome() + $reward);
        $SysPlayerProvideHero->save();

        //设置返信
        $guildHireHero->setFrom($hireFrom);
        $guildHireHero->setUid($hireUserId);
        $heroDownArr = HeroModule::getAllHeroDownInfo($hireUserId, array($hireHeroTid));
        $guildHireHero->setHero($heroDownArr[0]);

        $guildHireHero->setResult(Down_HireResult::success);
        $guildReply->setHireHero($guildHireHero);
        return $guildReply;
    }

    /**
     * 获取武将信息
     *
     * @param $userId
     * @param $hireUserId
     * @param $hireHeroTid
     * @return Down_GuildReply
     */
    public static function queryHhDetail($userId, $hireUserId, $hireHeroTid)
    {
        $guildReplyInfo = new Down_GuildReply();
        $guildHhDetailInfo = new Down_GuildQureyHhDetail();
        //判断公会
        //判断当前状态是否可雇佣
        $heroDownArray = HeroModule::getAllHeroDownInfo($hireUserId, array($hireHeroTid));
        $guildHhDetailInfo->setHero($heroDownArray[0]);

        $guildReplyInfo->setQueryHhDetail($guildHhDetailInfo);

        return $guildReplyInfo;
    }

    /** ====================================OP====================================================== */
    /**
     * 从工会踢出用户
     *
     * @param $userId
     * @param $memberUid
     * @return Down_GuildReply
     */
    public static function kickMember($userId, $memberUid)
    {
        $guildReplyInfo = new Down_GuildReply();
        $guildKickInfo = new Down_GuildKick();
        $guildKickInfo->setResult(Down_Result::fail);
        //不能自己踢自己
        if ($userId == $memberUid)
        {
            Logger::getLogger()->debug("kickMember no self:");
            $guildReplyInfo->setKick($guildKickInfo);

            return $guildReplyInfo;
        }

        //获取公会
        $SysPlayerGuildInfo = self::getTbPlayerGuild($userId);
        if ($SysPlayerGuildInfo->getGuildId() > 0)
        {
            if ($SysPlayerGuildInfo->getGuildPosition() == Down_GuildJobT::member)
            {
                Logger::getLogger()->debug("kickMember is no master:");
                $guildReplyInfo->setKick($guildKickInfo);

                return $guildReplyInfo;
            }
        }
        else
        {
            Logger::getLogger()->debug("kickMember is no user:");
            $guildReplyInfo->setKick($guildKickInfo);

            return $guildReplyInfo;
        }

        //$memberUid是否与自己同工会
        $memberPlayerGuildInfo = self::getTbPlayerGuild($memberUid);
        if ($SysPlayerGuildInfo->getGuildId() != $memberPlayerGuildInfo->getGuildId())
        {
            Logger::getLogger()->debug("kickMember is no same guild:");
            $guildReplyInfo->setKick($guildKickInfo);

            return $guildReplyInfo;
        }

        $SysGuildInfo = self::getTbGuildInfo($SysPlayerGuildInfo->getGuildId());
        if ($SysGuildInfo->getHostId() > 0 && $SysGuildInfo->getHostId() == $memberUid)
        { //工会建立人不能被踢掉
            Logger::getLogger()->debug("kickMember user is host:");
            $guildReplyInfo->setKick($guildKickInfo);

            return $guildReplyInfo;
        }

        PlayerCacheModule::deleteGuildCache($memberPlayerGuildInfo->getUserId());
        self::deleteHireInfo($memberPlayerGuildInfo->getUserId());

        $memberPlayerGuildInfo->setLastGuildId($SysPlayerGuildInfo->getGuildId());
        $memberPlayerGuildInfo->setGuildId(0);
        $memberPlayerGuildInfo->setLastQuitTime(time());
        $memberPlayerGuildInfo->save();

        $SysGuildInfo->setUserNumber($SysGuildInfo->getUserNumber() - 1);
        $SysGuildInfo->save();

        $guildKickInfo->setResult(Down_Result::success);
        $guildReplyInfo->setKick($guildKickInfo);

        //行为日志
        LogAction::getInstance()->log('ALLIANCE_KILL', array(
        		'targetPlayerId'	=> $memberUid,
        		'targetName'		=> PlayerCacheModule::getPlayerName($memberUid),
       		 )
        );

        //公会日志--start


        $field['userId']=$userId;
        $field['memberUid']=$memberUid;
        $message=self::write_guild_log($field, 4);
        $guildId=$SysPlayerGuildInfo->getGuildId();
        self::guild_log($guildId, $message);

        //--end

        return $guildReplyInfo;
    }



    /**
     * 会长操作用户入会申请
     * @param $userId
     * @param $applyUid
     */
    public static function isAllowJoinGuild($userId, $applyUid, $opType)
    {
        $isAllowJoinGuildReply = new Down_GuildReply();
        $guildJoinAllow = new Down_GuildJoinConfirm();
        $guildJoinAllow->setResult(Down_Result::fail);

        //获取公会
        $SysPlayerGuildInfo = self::getTbPlayerGuild($userId);
        if ($SysPlayerGuildInfo->getGuildId() > 0)
        {
            if ($SysPlayerGuildInfo->getGuildPosition() == Down_GuildJobT::member)
            {
                Logger::getLogger()->debug("joinConfirm is no master:");
                $isAllowJoinGuildReply->setJoinConfirm($guildJoinAllow);

                return $isAllowJoinGuildReply;
            }
        }
        else
        {
            Logger::getLogger()->debug("joinConfirm is no master:");
            $isAllowJoinGuildReply->setJoinConfirm($guildJoinAllow);

            return $isAllowJoinGuildReply;
        }
        //是否达到当前公会人数限制
        $SysGuildInfo = self::getTbGuildInfo($SysPlayerGuildInfo->getGuildId());
        if ($SysGuildInfo->getUserNumber() >= self::GUILD_MEMBER_NUM)
        {
            Logger::getLogger()->debug("joinConfirm is reach max:");
            $isAllowJoinGuildReply->setJoinConfirm($guildJoinAllow);

            return $isAllowJoinGuildReply;
        }
        //申请者是否已经有公会
        $SysPlayerGuildIsExist = self::getTbPlayerGuild($applyUid);
        if ($SysPlayerGuildIsExist->getGuildId() > 0)
        {
            Logger::getLogger()->debug("joinConfirm is have guild:uid:{$applyUid},guild:{$SysPlayerGuildIsExist->getGuildId()}");
            $isAllowJoinGuildReply->setJoinConfirm($guildJoinAllow);

            return $isAllowJoinGuildReply;
        }
        $guildId = $SysPlayerGuildInfo->getGuildId();
        $SysPlayerGuildApplyInfo = new SysPlayerGuildApplyInfo();
        $SysPlayerGuildApplyInfo->setUserId($applyUid);
        $SysPlayerGuildApplyInfo->setGuildId($guildId);
        if ($SysPlayerGuildApplyInfo->LoadedExistFields())
        {
            if ($opType == Up_GuildJoinConfirm_ConfirmType::reject)
            {
                $SysPlayerGuildApplyInfo->delete();
                $guildJoinAllow->setResult(Down_Result::success);
            }
            else
            {
                $SysPlayerGuildApplyInfo->delete();
                //删除掉用户的所有申请信息
                $sql = "delete from player_guild_apply_info where user_id = '{$applyUid}' ";
                MySQL::getInstance()->RunQuery($sql);
                $SysPlayerGuildInfo->setUserId($applyUid);
                $SysPlayerGuildInfo->setGuildId($guildId);
                $SysPlayerGuildInfo->setGuildPosition(Down_GuildJobT::member);
                $SysPlayerGuildInfo->inOrUp();
                $guildJoinAllow->setResult(Down_Result::success);
                $guildMemberArray = self::getDown_GuildMember($guildId, $applyUid);
                if (isset($guildMemberArray[$applyUid]))
                {
                    $guildJoinAllow->setNewMan($guildMemberArray[$applyUid]);
                }
                PlayerCacheModule::deleteGuildCache($SysPlayerGuildInfo->getUserId());
                $SysGuildInfo->setUserNumber($SysGuildInfo->getUserNumber() + 1);
                $SysGuildInfo->save();
            }
        }
        $isAllowJoinGuildReply->setJoinConfirm($guildJoinAllow);

        return $isAllowJoinGuildReply;
    }

    /**
     * 设置公会信息
     *
     * @param $userId
     * @param Up_GuildSet $guildSet
     */
    public static function setGuildInfo($userId, $guildSetInfo)
    {
        $guildReplyInfo = new Down_GuildReply();
        $downGuildSetInfo = new Down_GuildSet();
        $downGuildSetInfo->setResult(Down_Result::fail);
        //获取公会
        $SysPlayerGuild = self::getTbPlayerGuild($userId);
        if ($SysPlayerGuild->getGuildId() > 0) {
            if ($SysPlayerGuild->getGuildPosition() == Down_GuildJobT::member)
            {
                Logger::getLogger()->debug("setGuildInfo is no master:");
                $guildReplyInfo->setSet($downGuildSetInfo);

                return $guildReplyInfo;
            }
        }
        else
        {
            Logger::getLogger()->debug("setGuildInfo is no master:");
            $guildReplyInfo->setSet($downGuildSetInfo);

            return $guildReplyInfo;
        }
        //设置信息
        $SysGuildInfo = self::getTbGuildInfo($SysPlayerGuild->getGuildId());
        if ($guildSetInfo->getAvatar())
        {
            $SysGuildInfo->setAvatar($guildSetInfo->getAvatar());
        }

        if ($guildSetInfo->getJoinType())
        {
            $SysGuildInfo->setJoinType($guildSetInfo->getJoinType());
        }
        if ($guildSetInfo->getJoinLimit())
        {
            $SysGuildInfo->setMinLevelLimit($guildSetInfo->getJoinLimit());
        }
		if($guildSetInfo->getCanJump()!=="")
        {

            $SysGuildInfo->setCanJump($guildSetInfo->getCanJump());
        }
        if ($guildSetInfo->getAvatarFrame())
        {
        	$SysGuildInfo->getAvatarFrame($guildSetInfo->getAvatarFrame());
        }
        $SysGuildInfo->setIntro($guildSetInfo->getSlogan());
        $SysGuildInfo->save();
        $downGuildSetInfo->setResult(Down_Result::success);
        $guildReplyInfo->setSet($downGuildSetInfo);

        return $guildReplyInfo;
    }

    /**
     * 修改用户权限
     *
     * @param $userId
     * @param $memberUid
     * @param $jobT
     * @return Down_GuildReply
     */
    public static function updateMemberPer($userId, $memberUid, $permission)
    {
        $guildReplyInfo = new Down_GuildReply();
        $downGuildSetPermission = new Down_GuildSetJob();
        $downGuildSetPermission->setResult(Down_Result::fail);
        //获取公会 看权限是否足够
        $SysPlayerGuildInfo = self::getTbPlayerGuild($userId);
        if ($SysPlayerGuildInfo->getGuildId() > 0)
        {
            if ($SysPlayerGuildInfo->getGuildPosition() == Down_GuildJobT::member)
            {
                Logger::getLogger()->debug("udpate permission is not  master:");
                $guildReplyInfo->setSetJob($downGuildSetPermission);

                return $guildReplyInfo;
            }
        }
        else
        {
            Logger::getLogger()->debug("udpate permission is not master:");
            $guildReplyInfo->setSetJob($downGuildSetPermission);

            return $guildReplyInfo;
        }

        //判断用户和修改用户权限用户是否在同一个公会中
        $SysPlayerGuildMember = self::getTbPlayerGuild($memberUid);
        if ($SysPlayerGuildInfo->getGuildId() != $SysPlayerGuildMember->getGuildId())
        {
            Logger::getLogger()->debug("udpate permission is no same guild:");
            $guildReplyInfo->setSetJob($downGuildSetPermission);

            return $guildReplyInfo;
        }

        $SysPlayerGuildMember->setGuildPosition($permission);
        $SysPlayerGuildMember->save();

        //将对方提升为会长才给自己降级
        if ($permission == Down_GuildJobT::chairman && $SysPlayerGuildInfo->getGuildPosition() == Down_GuildJobT::chairman)
        {
            $SysGuildInfo = self::getTbGuildInfo($SysPlayerGuildInfo->getGuildId());
            $SysGuildInfo->setHostId($SysPlayerGuildMember->getUserId());
            $SysGuildInfo->save();
            //给自己降级
            $SysPlayerGuildInfo->setGuildPosition(Down_GuildJobT::elder);
            $SysPlayerGuildInfo->save();
            //行为日志
            LogAction::getInstance()->log('ALLIANCE_TRANSFER', array(
            		'targetPlayerId'	=> $memberUid,
            		'targetName'		=> PlayerCacheModule::getPlayerName($memberUid)
           		 )
            );
        }
        $downGuildSetPermission->setResult(Down_Result::success);
        $guildReplyInfo->setSetJob($downGuildSetPermission);

        return $guildReplyInfo;
    }

    /**
     * @param $guildId
     * @return Down_GuildSummary
     */
    public static function getDown_GuildSummary($guildId)
    {
        $guildSummary = new Down_GuildSummary();
        $Down_UserSummaryArr = self::getDown_UserSummary(array($guildId), " and G.guild_position = 1 ");
        $SysGuildInfo = self::getTbGuildInfo($guildId);
        if ($SysGuildInfo->getHostId() > 0)
        {
            $guildSummary->setId($SysGuildInfo->getId());
            $guildSummary->setName($SysGuildInfo->getGuildName());
            $guildSummary->setAvatar($SysGuildInfo->getAvatar());
            $guildSummary->setSlogan($SysGuildInfo->getIntro()); //描述信息
            $guildSummary->setJoinType($SysGuildInfo->getJoinType());
            $guildSummary->setJoinLimit($SysGuildInfo->getMinLevelLimit()); //等级限制
            $guildSummary->setMemberCnt($SysGuildInfo->getUserNumber());
           $guildSummary->setCanJump($SysGuildInfo->getCanJump());
	   if (isset($Down_UserSummaryArr[$SysGuildInfo->getId()]))
            {
                $Down_UserSummary = array_pop($Down_UserSummaryArr[$SysGuildInfo->getId()]);
                $guildSummary->setPresident($Down_UserSummary);
            }
        }
        else
        {
            $guildSummary = null;
        }

        return $guildSummary;
    }

    public static function getDown_UserSummary($guildIdArr, $where = "")
    {
        $Down_UserSummaryArr = array();

        if (!is_array($guildIdArr) || count($guildIdArr) <= 0)
        {
            return $Down_UserSummaryArr;
        }
        $guildIdStr = implode(",", $guildIdArr);
        $sql = "select P.*, G.guild_id, V.vip, I.guild_name
                from player_guild as G, player as P, player_vip as V, guild_info as I
                where G.user_id=P.user_id and P.user_id = V.user_id and G.guild_id = I.id and G.guild_id in ($guildIdStr) {$where} ";
        $rs = MySQL::getInstance()->RunQuery($sql);
        while ($value = MySQL::getInstance()->FetchAssoc($rs))
        {
            $down_UserSummary = new Down_UserSummary();
            $down_UserSummary->setName($value['nickname']);
            $down_UserSummary->setAvatar($value['avatar']);
            $down_UserSummary->setGuildName($value['guild_name']);
            $down_UserSummary->setLevel($value['level']);
            $down_UserSummary->setVip($value['vip']);
            $Down_UserSummaryArr[$value['guild_id']][$value['user_id']] = $down_UserSummary;
        }

        return $Down_UserSummaryArr;
    }

    /**
     * getDown_GuildMember
     *
     * @param $guildId
     * @param array $userIdArr
     * @return array
     */
    public static function getDown_GuildMember($guildId, $userIdArr = array())
    {
        $Down_GuildMemberArr = array();
        $SysGuildInfo = self::getTbGuildInfo($guildId);
        $sqlStr = "";
        if (is_array($userIdArr) && count($userIdArr) > 0)
        {
            $sqlStr = " and G.user_id in (" . implode(",", $userIdArr) . ") ";
        }
        $sql = "select P.*,G.guild_position,V.vip,U.last_login_time
               from player_guild as G, player as P, player_vip as V, user_server as U
               where U.user_id = P.user_id and G.user_id=P.user_id and P.user_id = V.user_id and G.guild_id = '{$guildId}' {$sqlStr} ";
        $rs = MySQL::getInstance()->RunQuery($sql);
        while ($value = MySQL::getInstance()->FetchAssoc($rs))
        {
            //TODO::补充协议数据
            $guildMember = new Down_GuildMember();
            $down_UserSummary = new Down_UserSummary();
            $down_UserSummary->setName($value['nickname']);
            $down_UserSummary->setAvatar($value['avatar']);
            $down_UserSummary->setGuildName($SysGuildInfo->getGuildName());
            $down_UserSummary->setLevel($value['level']);
            $down_UserSummary->setVip($value['vip']);
            $guildMember->setSummary($down_UserSummary);
            $guildMember->setUid($value['user_id']);
            $guildMember->setJob($value['guild_position']);
            $guildMember->setLastLogin($value['last_login_time']);
            $guildMember->setActive(0); //todo:新协议功能
            $guildMember->setJoinInstanceTime(0);
            $Down_GuildMemberArr[$value['user_id']] = $guildMember;
        }
        return $Down_GuildMemberArr;
    }

    /**
     * 获取公会的Down_GuildInfo信息
     *
     * @param $guildId
     * @return Down_GuildInfo
     */
    public static function getDownGuildInfo($guildId, $userId)
    {
        $guildInfo = new Down_GuildInfo();
        //工会基础信息
        $guildSummary = self::getDown_GuildSummary($guildId);
        $guildInfo->setSummary($guildSummary);
        //成员信息
        $guildMemberArr = self::getDown_GuildMember($guildId);
        foreach ($guildMemberArr as $guildMember) {
            $guildInfo->appendMembers($guildMember);
        }
        //申请信息
        $sql = "select P.*,V.vip from player_guild_apply_info as G, player as P, player_vip as V where G.user_id=P.user_id and P.user_id = V.user_id and G.guild_id = '{$guildId}' ";
        $rs = MySQL::getInstance()->RunQuery($sql);
        while ($value = MySQL::getInstance()->FetchAssoc($rs))
        {
            $guildMember = new Down_GuildApplier();
            $guildMember->setUid($value['user_id']);
            $down_UserSummary = new Down_UserSummary();
            $down_UserSummary->setName($value['nickname']);
            $down_UserSummary->setAvatar($value['avatar']);
            $down_UserSummary->setGuildName($guildSummary->getName());
            $down_UserSummary->setLevel($value['level']);
            $down_UserSummary->setVip($value['vip']);
            $guildMember->setUserSummary($down_UserSummary);
            $guildInfo->appendAppliers($guildMember);
        }
        $SysGuildInfo = self::getTbGuildInfo($guildId);
        $SysPlayerGuild = self::getTbPlayerGuild($userId);
        //todo:补充新协议
        $guildInfo->setVitality($SysGuildInfo->getVitality());
        $selfVitality = $SysPlayerGuild->getVitality();
        if (empty($selfVitality))
        {
            $selfVitality = 0;
        }
        $guildInfo->setSelfVitality($selfVitality);
        $guildInfo->setLeftDistributeTime(1 - $SysGuildInfo->getDistributeNum()); //后期测试  暂定100 原来是1

        return $guildInfo;
    }

    /**
     * 获取公会成员的所有userId
     *
     * @param $guildId
     * @return array
     */
    public static function getGuildAllUserId($guildId)
    {
        $userIdArr = array();
        $SysPlayerGuildArr = SysPlayerGuild::loadedTable('user_id', " guild_id = '{$guildId}' ");
        foreach ($SysPlayerGuildArr as $SysPlayerGuild)
        {
            $userIdArr[$SysPlayerGuild->getUserId()] = $SysPlayerGuild->getUserId();
        }
        return $userIdArr;
    }

    /********公会副本相关开始********************************************************************/

    public static function getDownGuildInstanceSummary($SysGuildStage)
    {
        $now = time();
        $Down_GuildInstanceSummary = new Down_GuildInstanceSummary();
        $Down_GuildInstanceSummary->setId($SysGuildStage->getRaidId());
        $Down_GuildInstanceSummary->setStageId($SysGuildStage->getStageId());
       //todo:用户今日剩余挑战次数--后期测试
//        $nowTime = date('Y-m-d');
//        $wherestr = "guild_id = '{$SysGuildStage->getGuildId()}' and stage_id = '{$SysGuildStage->getStageId()}' and DATE_FORMAT(FROM_UNIXTIME(battle_time),'%Y-%m-%d') = '{$nowTime}'";
//        $SysPlayerGuildStageInfo = SysPlayerGuildStage::loadedTable("count",$wherestr);
//        Logger::getLogger()->debug(print_r($SysPlayerGuildStageInfo, true));
//        foreach($SysPlayerGuildStageInfo as $PlayerGuildStageInfo)
//        {
//            $count = $PlayerGuildStageInfo->getCount();
//        }
//        if(empty($count))
//        {
//            $count = 2;
//        }elseif($count>=2)
//        {
//            $count = 0;
//        }

       // $Down_GuildInstanceSummary->setLeftTime($count);
        $Down_GuildInstanceSummary->setLeftTime(2);
        $Down_GuildInstanceSummary->setStartTime($SysGuildStage->getBeginTime());
        $Down_GuildInstanceSummary->setProgress($SysGuildStage->getProgress());
        $Down_GuildInstanceSummary->setStageProgress($SysGuildStage->getStageProgress());
        if ($SysGuildStage->getChallengerStatus() == Down_GuildInstanceDetail_ChallengerStatus::prepare)
        {
            if ($now < ($SysGuildStage->getChallengerBeginTime() + self::GUILD_PRE_OVER_TIME) && $SysGuildStage->getChallenger() > 0)
            {
                $Down_GuildInstanceSummary->setBattleUserId($SysGuildStage->getChallenger());
            }
        }
        elseif ($SysGuildStage->getChallengerStatus() == Down_GuildInstanceDetail_ChallengerStatus::battle)
        {
            if ($now < ($SysGuildStage->getChallengerBeginTime() + self::GUILD_BATTLE_OVER_TIME) && $SysGuildStage->getChallenger() > 0)
            {
                $Down_GuildInstanceSummary->setBattleUserId($SysGuildStage->getChallenger());
            }
        }

        return $Down_GuildInstanceSummary;
    }

    /**
     * 查询公会副本简要信息  查询公会的简要信息,进入到团队副本
     *
     * @param $userId
     * @return Down_GuildReply
     */
    public static function findGuildBriefInfo($userId)
    {
        $current_raid_id = 0;
        $guildReplyInfo = new Down_GuildReply();
        $down_GuildInstanceQueryReply = new Down_GuildInstanceQuery();
        $down_GuildInstanceQueryReply->setIsCanJump(Down_GuildInstanceQuery_IsCanJump::false);
        $SysPlayerGuildInfo = self::getTbPlayerGuild($userId);
        if ($SysPlayerGuildInfo->getGuildId() > 0)
        {
            $where = "guild_id = '{$SysPlayerGuildInfo->getGuildId()}' order by raid_id asc";
            $SysGuildStageArray = SysGuildStage::loadedTable(null,$where);
            if (count($SysGuildStageArray) <= 0)
            {
                //需要判断并解锁
                $current_raid_id = 1;
            }
            foreach ($SysGuildStageArray as $SysGuildStage)
            {
                $Down_GuildInstanceSummary = self::getDownGuildInstanceSummary($SysGuildStage);
                $down_GuildInstanceQueryReply->appendSummary($Down_GuildInstanceSummary);
                if ($SysGuildStage->getRaidId() > $current_raid_id)
                {
                    $current_raid_id = $SysGuildStage->getRaidId();
                }
            }
        }
        $down_GuildInstanceQueryReply->setCurrentRaidId($current_raid_id);
        $down_GuildInstanceQueryReply->setStagePass(0); //todo:
        $guildReplyInfo->setInstanceQuery($down_GuildInstanceQueryReply);

        return $guildReplyInfo;
    }

    private static function getStageRaidArr()
    {
        if (empty(self::$_stageRaidArr))
        {
            //查找raid id以及stage id
            $raidDefineArr = DataModule::getInstance()->getDataSetting(GUILD_RAID_LUA_KEY);
            foreach ($raidDefineArr as $deArr_)
            {
                $beginStageId = $deArr_['Begin Stage ID'];
                $stageCount = $deArr_['Stages Count'];
                $raid_ = $deArr_['Raid ID'];
                for ($p = 0; $p < $stageCount; $p++)
                {
                    $stage_ = $beginStageId + $p;
                    self::$_stageRaidArr[$stage_] = $raid_;
                }
            }
        }

        return self::$_stageRaidArr;
    }


    private static function isChallenging($SysGuildStage)
    {
        $challenging = false;
        $now = time();

        //服务器端延时5s
        if ($SysGuildStage->getChallenger() > 0) {
            if ($SysGuildStage->getChallengerStatus() == Down_GuildInstanceDetail_ChallengerStatus::prepare)
            {
                if (($SysGuildStage->getChallengerBeginTime() + self::GUILD_PRE_OVER_TIME + 5) > $now)
                {
                    //返回挑战者信息
                    $challenging = true;
                }
            }
            elseif ($SysGuildStage->getChallengerStatus() == Down_GuildInstanceDetail_ChallengerStatus::battle)
            {
                if (($SysGuildStage->getChallengerBeginTime() + self::GUILD_BATTLE_OVER_TIME + 5) > $now)
                {
                    //返回挑战者信息
                    $challenging = true;
                }
            }
        }

        return $challenging;
    }

    private static function getPlayerGuildStage($userId, $raidId)
    {
        if (self::$_playerGuildStage)
        {
            if (self::$_playerGuildStage->getCount() > 0 && SQLUtil::isTimeNeedReset(self::$_playerGuildStage->getBattleTime()))
            {
                self::$_playerGuildStage->setCount(0);
                self::$_playerGuildStage->save();
            }

            return self::$_playerGuildStage;
        }

        self::$_playerGuildStage = new SysPlayerGuildStage();
        self::$_playerGuildStage->setUserId($userId);
        self::$_playerGuildStage->setRaidId($raidId);
        if (self::$_playerGuildStage->LoadedExistFields()) {
            if (self::$_playerGuildStage->getCount() > 0 && SQLUtil::isTimeNeedReset(self::$_playerGuildStage->getBattleTime()))
            {
                self::$_playerGuildStage->setCount(0);
                self::$_playerGuildStage->save();
            }
        }
        else
        {
            self::$_playerGuildStage->inOrUp();
        }
        return self::$_playerGuildStage;
    }

    /**
     * 查询公会副本详细信息  进入到对应的关卡中
     *
     * @param $userId
     * @param $stageId
     * @return Down_GuildReply|null
     */
    public static function findGuildDetailInfo($userId, $stageId)
    {
        $guildReplyInfo = new Down_GuildReply();
        $Down_GuildInstanceDetailInfo = new Down_GuildInstanceDetail();
        $SysPlayerGuildInfo = self::getTbPlayerGuild($userId);
        if ($SysPlayerGuildInfo->getGuildId() > 0)
        {
            $stageRaidArray = self::getStageRaidArr();
            if (!isset($stageRaidArray[$stageId]))
            {
                return null;
            }
            $SysGuildStageInfo = new SysGuildStage();
            $SysGuildStageInfo->setGuildId($SysPlayerGuildInfo->getGuildId());
            $SysGuildStageInfo->setRaidId($stageRaidArray[$stageId]);
            if ($SysGuildStageInfo->LoadedExistFields())
            {
                $Down_GuildInstanceDetailInfo->setStage($stageId);
                $Down_GuildInstanceDetailInfo->setWave($SysGuildStageInfo->getWaveIndex());
                $hpString = $SysGuildStageInfo->getDetail();
                if (strlen($hpString) > 5)
                {
                    $hpArray = explode(";", $hpString);
                    foreach ($hpArray as $hp)
                    {
                        $Down_GuildInstanceDetailInfo->appendHp($hp);
                    }
                }
                else
                {
                    $Down_GuildInstanceDetailInfo->appendHp(10000);
                    $Down_GuildInstanceDetailInfo->appendHp(10000);
                    $Down_GuildInstanceDetailInfo->appendHp(10000);
                    $Down_GuildInstanceDetailInfo->appendHp(10000);
                    $Down_GuildInstanceDetailInfo->appendHp(10000);
                }
                //todo:每个怪的血值
                //todo:用户的所有挑战记录,包括输出伤害
                if ($SysGuildStageInfo->getChallenger() > 0 && $SysGuildStageInfo->getChallenger() != $userId)
                {
                    $challenging = self::isChallenging($SysGuildStageInfo);
                    if ($challenging)
                    {

                        $Down_GuildInstanceDetailInfo->setChallengerStatus($SysGuildStageInfo->getChallengerStatus());
                        $Down_GuildInstanceDetailInfo->setChallenger($SysGuildStageInfo->getChallenger());
                    }
                }
                $guildReplyInfo->setInstanceDetail($Down_GuildInstanceDetailInfo);

                return $guildReplyInfo;
            }
            else
            {
             // 不存在记录,会长未解锁对应的关卡
                return null;
            }
        }
        return null;
    }

    /**
     * 开启公会副本 所有公会会员进入副本,初始化掉落,血值等信息
     *
     * @param $userId
     * @param $stageId
     * @return Down_GuildReply|null
     */
    public static function instanceStart($userId, $stageId)
    {
        $guildReplyInfo = new Down_GuildReply();
        $Down_GuildInstanceStartReply = new Down_GuildInstanceStart();

        $SysPlayerGuildInfo = self::getTbPlayerGuild($userId);
        if ($SysPlayerGuildInfo->getGuildId() > 0)
        {
            $stageRaidArray = self::getStageRaidArr();
            if (!isset($stageRaidArray[$stageId]))
            {
                Logger::getLogger()->error("instanceStart, " . __LINE__);

                return null;
            }
            $raidId = $stageRaidArray[$stageId];
            $raidArray = DataModule::lookupDataTable(GUILD_RAID_LUA_KEY, $raidId);
            $SysGuildStageInfo = new SysGuildStage();
            $SysGuildStageInfo->setGuildId($SysPlayerGuildInfo->getGuildId());
            $SysGuildStageInfo->setRaidId($stageRaidArray[$stageId]);
            if ($SysGuildStageInfo->LoadedExistFields())
            { //检查当前副本是否开放
                //检查完成度
                if ($SysGuildStageInfo->getProgress() >= 10000)
                {
                    Logger::getLogger()->error("instanceStart, " . __LINE__);

                    return null;
                }
                //是否有人在战斗
                //todo: 有人在战斗时 客户端需要什么数据
                if ($SysGuildStageInfo->getChallenger() != $userId)
                {
                    $challenging = self::isChallenging($SysGuildStageInfo);
                    if ($challenging)
                    {
                        Logger::getLogger()->error("instanceStart, " . __LINE__);

                        return null;
                    }
                }
                //todo：判断挑战次数-------后期测试
//                $nowTime = date('Y-m-d');
//                $wherestr = "guild_id = '{$SysGuildStageInfo->getGuildId()}' and stage_id = '{$stageId}' and DATE_FORMAT(FROM_UNIXTIME(battle_time),'%Y-%m-%d') = '{$nowTime}'";
//                $SysPlayerGuildStageInfo = SysPlayerGuildStage::loadedTable("count",$wherestr);
//                foreach($SysPlayerGuildStageInfo as $PlayerGuildStageInfo)
//                {
//                    $count = $PlayerGuildStageInfo->getCount();
//                }
//                if($count>=2)
//                {
//                    Logger::getLogger()->error("instanceStart, " . __LINE__);
//
//                    return null;
//                }

                //更新stage记录
                $SysGuildStageInfo->setChallenger($userId);
                $SysGuildStageInfo->setStageId($stageId);
                $SysGuildStageInfo->setChallengerBeginTime(time());
                $SysGuildStageInfo->setChallengerStatus(Down_GuildInstanceDetail_ChallengerStatus::battle);
                $SysGuildStageInfo->save();
                //用户挑战开始记录
                $SysPlayerGuildStageInfo = self::getPlayerGuildStage($userId, $stageRaidArray[$stageId]);
                $SysPlayerGuildStageInfo->setStageId($stageId);
                $SysPlayerGuildStageInfo->setWaveIndex($SysGuildStageInfo->getWaveIndex());
                $SysPlayerGuildStageInfo->setBattleTime(time());
                $SysPlayerGuildStageInfo->setCount($SysPlayerGuildStageInfo->getCount() + 1);
                $SysPlayerGuildStageInfo->setGuildId($SysPlayerGuildInfo->getGuildId());
                $SysPlayerGuildStageInfo->setServerId(PlayerCacheModule::getServerID($userId));
                $SysPlayerGuildStageInfo->save();

                $Down_GuildInstanceStartReply->setRseed(mt_rand(1, 999));
                $Down_GuildInstanceInfo = new Down_GuildInstanceInfo();
                $Down_GuildInstanceInfo->setRaidId($stageRaidArray[$stageId]);
                $Down_GuildInstanceInfo->setStageIndex($stageId);
                $Down_GuildInstanceInfo->setWaveIndex($SysGuildStageInfo->getWaveIndex());
                $hpString = $SysGuildStageInfo->getDetail();
                if (strlen($hpString) > 5)
                {
                    $hpArray = explode(";", $hpString);
                    foreach ($hpArray as $hp)
                    {
                        $Down_GuildInstanceInfo->appendHpInfo($hp);
                    }
                }
                else
                {
                    $Down_GuildInstanceInfo->appendHpInfo(10000);
                    $Down_GuildInstanceInfo->appendHpInfo(10000);
                    $Down_GuildInstanceInfo->appendHpInfo(10000);
                    $Down_GuildInstanceInfo->appendHpInfo(10000);
                    $Down_GuildInstanceInfo->appendHpInfo(10000);
                }
                $Down_GuildInstanceStartReply->setInstanceInfo($Down_GuildInstanceInfo);
                //普通物品掉落逻辑
                //关卡特殊掉落信息,先随机掉落一个
                /*$raidArr = DataModule::lookupDataTable(GUILD_RAID_LUA_KEY, $raidId);
                $rewardArr = array();
                for ($pp = 1; $pp <= 10; $pp++) {
                    if (isset($raidArr["Special Loot $pp ID"])) {
                        $rewardArr[] = $raidArr["Special Loot $pp ID"];
                    }
                }*/
                $lootArray = array();
                $lootInfo = explode("|", $SysGuildStageInfo->getLoot());
                foreach ($lootInfo as $loot)
                {
                    $lootDetail = explode("-", $loot);
                    if (count($lootDetail) >= 4)
                    {
                        $lootArray[] = $lootDetail;
                    }
                }
                foreach ($lootArray as $oneLoot)
                {
                    $argArray = array(3, intval($oneLoot[0]), 3, intval($oneLoot[1]), 10, intval($oneLoot[2]));
                    $a = MathUtil::makeBits($argArray);
                    $Down_GuildInstanceStartReply->appendLoots($a);

                }
                //设置血条掉落
                if (($stageId == ($raidArray['Begin Stage ID'] + $raidArray['Stages Count'] - 1)) && strlen($SysGuildStageInfo->getSpecialLoot()) > 5)
                {
                    $specialLootArr = explode("@", $SysGuildStageInfo->getSpecialLoot());

                    $per = 1;
                    $Down_GuildStageHpDrop = new Down_GuildStageHpDrop();
                    $battleTable = DataModule::lookupDataTable(BATTLE_LUA_KEY, null, array($stageId, 3));
                    $argArray = array(3, 3, 3, intval($battleTable['Boss Position']), 10, 0);
                    $Down_GuildStageHpDrop->setMonsterInfo(MathUtil::makeBits($argArray));
                    foreach ($specialLootArr as $specialLootStr)
                    {

                        if (strlen($specialLootStr) > 5)
                        {
                            $Down_HpDrop = new Down_HpDrop();
                            $Down_HpDrop->setPer($per);
                            $lootInfo = explode("|", $specialLootStr);
                            foreach ($lootInfo as $loot)
                            {
                                $lootDetail = explode("-", $loot);
                                if (count($lootDetail) >= 4)
                                {
                                    $argArray = array(3, intval($lootDetail[0]), 3, intval($lootDetail[1]), 10, intval($lootDetail[2]));
                                    $Down_HpDrop->appendItems($lootDetail[2]);
                                }
                            }
                            $Down_GuildStageHpDrop->appendLoots($Down_HpDrop);
                        }
                        $per++;
                    }
                    $Down_GuildInstanceStartReply->appendHpDrop($Down_GuildStageHpDrop);
                }
                Logger::getLogger()->debug(print_r($Down_GuildInstanceStartReply, true));
                $guildReplyInfo->setInstanceStart($Down_GuildInstanceStartReply);

                return $guildReplyInfo;
            }
            else
            {
                Logger::getLogger()->error("instanceStart, " . __LINE__);

                return null;
            }
        }
        return null;
    }

    /**
     * 初始化团队副本的掉落
     *
     * @param $stage
     * @param $hpNum 血条数量
     * @return array
     */
    private static function initStageLootArr($stage, $hpNum = 1)
    {
        $returnLootArr = array(
            0 => array(), //三波战斗掉落
            1 => array() //boss战每血条掉落
        );

        for ($i = 1; $i <= 3; $i++) {
            $lootArr_ = LootModule::getLootInfo(0, $stage, false, false, $i);
            $returnLootArr[0] = array_merge($returnLootArr[0], $lootArr_);
        }

        //血条掉落
        for ($i = 1; $i < $hpNum; $i++)
        {
            $returnLootArr[1][] = LootModule::getLootInfo(0, $stage, false, false, 3);
        }
        return $returnLootArr;
    }

    /**
     * 结束公会副本  退出副本的触发,服务器校验以及标记当前副本状态
     *
     * @param $userId
     * @param Up_GuildInstanceEnd $Up_GuildInstanceEnd
     */
    public static function instanceEnd($userId, $Up_GuildInstanceEnd)
    {
        $guildReplyInfo = new Down_GuildReply();
        $Down_GuildInstanceEndDown = new Down_GuildInstanceEndDown();
        $serverId = PlayerCacheModule::getServerID($userId);
        $SysPlayerGuildInfo = self::getTbPlayerGuild($userId);
        if ($SysPlayerGuildInfo->getGuildId() > 0)
        {
            $stageRaidArray = self::getStageRaidArr();
            $SysGuildStageInfo = new SysGuildStage();
            $SysGuildStageInfo->setGuildId($SysPlayerGuildInfo->getGuildId());
            $SysGuildStageInfo->setChallenger($userId);
            if ($SysGuildStageInfo->LoadedExistFields()) { //检查当前副本是否开放
                //超时时间和状态 和 当前用户是否是战斗用户
                if ($SysGuildStageInfo->getChallengerStatus() != 1 || $SysGuildStageInfo->getChallenger() != $userId)
                {
                    Logger::getLogger()->error("instanceend, " . __LINE__);

                    return null; //todo:发送 网络断线 的假提示信息
                }

                //todo:判断战斗的真实性

               $ver_result=$Up_GuildInstanceEnd->getResult();
                $ver_hpinfo=$Up_GuildInstanceEnd->getHpInfo();
                $ver_wave=$Up_GuildInstanceEnd->getWave();
                $ver_damage=$Up_GuildInstanceEnd->getDamage();
                $ver_progress=$Up_GuildInstanceEnd->getProgress();
                $ver_stageprogress=$Up_GuildInstanceEnd->getStageProgress();
                /* $CheckWave = $ver_result*3-$ver_wave;
                if($CheckWave!=0)
                {
                	Logger::getLogger()->error("CheckWave, " . __LINE__);

                	return null; //todo:发送 网络断线 的假提示信息
                }
                $AlwaysCheck = $ver_result*$ver_damage*$ver_progress*$ver_stageprogress;
                if($AlwaysCheck<=0)
                {
                	Logger::getLogger()->error("AlwaysCheck, " . __LINE__);
                	return null; //todo:发送 网络断线 的假提示信息
                }*/

                //todo:公会币掉落程序
                //更新获取的金币值
                //Raid Gold Bonus  a = 伤害值 / 10 * VIP加成 b = a / 1
                //start 计算用户金币 暂定
                $PlayerVip = new SysPlayerVip();
                $PlayerVip->setUserId($userId);
                if($PlayerVip->loaded())
                {
                    $playerVip = $PlayerVip->getVip();
                }
                $RaidGoldBounsArray = DataModule::lookupDataTable(VIP_LUA_KEY, $playerVip);
                $RaidGoldBouns =$RaidGoldBounsArray["Raid Gold Bonus"];
                $variable = 1;
                $damage = $Up_GuildInstanceEnd->getDamage();
                $goldCountFromDamage =floor($RaidGoldBouns/10*$damage);
                $goldCountFromVar  = $goldCountFromDamage/$variable;
                $goldCount = min($goldCountFromDamage,$goldCountFromVar);
                PlayerModule::modifyMoney($userId, $goldCount,"Add Money From Guild");
                //end


                //玩家的每场战斗记录
                $SysGuildStageBattleHistoryInfo = new SysGuildStageBattleHistory();
                $SysGuildStageBattleHistoryInfo->setUserId($userId);
                $SysGuildStageBattleHistoryInfo->setDamage($damage);
                $SysGuildStageBattleHistoryInfo->setBattleTime(time());
                $SysGuildStageBattleHistoryInfo->setRaidId($SysGuildStageInfo->getRaidId());
                $SysGuildStageBattleHistoryInfo->setStageId($SysGuildStageInfo->getStageId());
                $SysGuildStageBattleHistoryInfo->setWave($Up_GuildInstanceEnd->getWave());
                $SysGuildStageBattleHistoryInfo->setGuildId($SysPlayerGuildInfo->getGuildId());
                $SysGuildStageBattleHistoryInfo->setServerId($serverId);
                if ($Up_GuildInstanceEnd->getStageProgress() >= 10000)
                {
                    $SysGuildStageBattleHistoryInfo->setIsKill(1);
                    //todo：这块涉及公会币 玩家最后一击获取的公会币
                    //PlayerModule::modifyPlyGuildPoint($userId,$Up_GuildInstanceEnd->getGuildCount(),"add7daysrewards");
                    $final_hit_bonus = DataModule::lookupDataTable(GUILD_INSTANCE_LUA_KEY, "final_hit");
                    PlayerModule::modifyPlyGuildPoint($userId,$final_hit_bonus,"guild stage last hit");
                }
                else
                {
                    $SysGuildStageBattleHistoryInfo->setIsKill(0);
                }
                $heroArray = $Up_GuildInstanceEnd->getHeroes();
                $heroString = implode(",", $heroArray);
                $SysGuildStageBattleHistoryInfo->setHeros($heroString);
                $SysGuildStageBattleHistoryInfo->inOrUp();
                //处理掉落
                $lootItemArray = self::lootParse($SysGuildStageInfo, $Up_GuildInstanceEnd);
                if (count($lootItemArray['user']) > 0)
                {
                    $userItemArray = array();
                    foreach ($lootItemArray['user'] as $item)
                    {
                        if (isset($userItemArray[$item]))
                        {
                            $userItemArray[$item] += 1;
                        }
                        else
                        {
                            $userItemArray[$item] = 1;
                        }
                        $Down_GuildInstanceEndDown->appendRewards($item);
                    }
                    $reason = "GUILD_RAID_DROP";
                    ItemModule::addItem($userId, $userItemArray, $reason);
                }
                if (count($lootItemArray['guild']) > 0)
                {
                    $sql = "insert into guild_stage_drop (guild_id,raid_id,item_id,drop_count,drop_user_id,drop_time) values ";
                    $now = time();
                    $uSqlArray= array();
                    foreach ($lootItemArray['guild'] as $item)
                    {
                        $uSqlArray[] = "('{$SysPlayerGuildInfo->getGuildId()}','{$SysGuildStageInfo->getRaidId()}','{$item}','1','{$userId}','{$now}')";
                        $Down_GuildInstanceEndDown->appendApplyRewards($item);
                    }
                    $sql .= implode(",", $uSqlArray);
                    $rs = MySQL::getInstance()->RunQuery($sql);
                }
                $oldStageProgress = $SysGuildStageInfo->getStageProgress();
                $oldWaveIndex = $SysGuildStageInfo->getWaveIndex();
                $oldHPDesc = $SysGuildStageInfo->getDetail();
                $hpInfoArr = $Up_GuildInstanceEnd->getHpInfo();
                $SysGuildStageInfo->setDetail(implode(";", $hpInfoArr));
                $SysGuildStageInfo->setWaveIndex($Up_GuildInstanceEnd->getWave());
                $SysGuildStageInfo->setProgress($Up_GuildInstanceEnd->getProgress());
                $SysGuildStageInfo->setStageProgress($Up_GuildInstanceEnd->getStageProgress());
                $SysGuildStageInfo->save();
                $raidArray = DataModule::lookupDataTable(GUILD_RAID_LUA_KEY, $SysGuildStageInfo->getRaidId());
                $maybeRewardArray = array();
                for ($i = 1; $i <= 10; $i++)
                {
                    if (isset($raidArray["Special Loot $i ID"]))
                    {
                        $maybeRewardArray[$raidArray["Special Loot $i ID"]] = $raidArray["Special Loot $i ID"];
                    }
                }
                //特殊物品掉落(更新掉落数量和状态)
                //自动解锁下一关卡
                //stage发生变化,数据需要重置,判断上一个stage的完成度
                if ($Up_GuildInstanceEnd->getProgress() < 10000 && $SysGuildStageInfo->getStageProgress() >= 10000)
                {
                    //初始化下一关卡的掉落信息(普通和特殊)
                    $nextStage = $SysGuildStageInfo->getStageId() + 1;
                    //获取是否是最终关卡, 是:获取血条数量
                    $hpNum = 1;
                    if ($nextStage == ($raidArray['Begin Stage ID'] + $raidArray['Stages Count'] - 1))
                    {
                        //最终关卡, 从unit表中获取boss的血条数量
                        $battleTable = DataModule::lookupDataTable(BATTLE_LUA_KEY, null, array($nextStage, 3));
                        $heroUnitLua = DataModule::lookupDataTable(HERO_UNIT_LUA_KEY, null, array($battleTable['Monster 1 ID']));
                        $hpNum = isset($heroUnitLua['HP Layers']) ? $heroUnitLua['HP Layers'] : 1;
                    }
                    $returnLootArray = self::initStageLootArr($nextStage, $hpNum);
                    $lootArr = $returnLootArray[0];
                    if (count($lootArr) > 0)
                    {
                        $LootStrArr = array();
                        foreach ($lootArr as $lootInfo)
                        {
                            $LootStrArr[] = implode("-", $lootInfo);
                        }
                        $SysGuildStageInfo->setLoot(implode("|", $LootStrArr));
                    }
                    else
                    {
                        $SysGuildStageInfo->setLoot("");
                    }
                    $specialLootArray = $returnLootArray[1];
                    if (count($specialLootArray) > 0)
                    {
                        $specialLootStrArray = array();
                        foreach ($specialLootArray as $hpLootArr)
                        {
                            $lArr = array();
                            foreach ($hpLootArr as $loot)
                            {
                                $lArr[] = implode("-", $loot);
                            }
                            $specialLootStrArr[] = implode("|", $lArr);
                        }
                        $SysGuildStageInfo->setSpecialLoot(implode("@", $specialLootStrArray));
                    }
                    else
                    {
                        $SysGuildStageInfo->setSpecialLoot("");
                    }

                    $SysGuildStageInfo->setWaveIndex(1);
                    $SysGuildStageInfo->setStageId($nextStage);
                    $SysGuildStageInfo->setDetail("");
                    $SysGuildStageInfo->setStageProgress(0);
                    $SysGuildStageInfo->save();
                }
                $vipLevel = VipModule::getVipLevel($userId);
                if ($vipLevel < 6)
                {
                    TaskModule::updateDailyTaskProgress($userId, DAILY_TASK_ENTER_RAID, 1, 0);
                }
                else
                {
                    TaskModule::updateDailyTaskProgress($userId, DAILY_TASK_ENTER_RAID, 1, 1);
                }

                //:判断是否通关,通关后会自动开启下一个关卡  发送通关奖励,.
                if ($Up_GuildInstanceEnd->getProgress() >= 10000)
                {
                    if ($SysGuildStageInfo->getFirstPassTimestamp() <= 0)
                    {
                        $SysGuildStageInfo->setFirstPassTimestamp(time());
                    }
                    $useTime = time() - $SysGuildStageInfo->getBeginTime();
                    if ($SysGuildStageInfo->getFastPassTime() <= 0)
                    {
                        $SysGuildStageInfo->setFastPassTime($useTime);
                    }
                    elseif ($useTime < $SysGuildStageInfo->getFastPassTime())
                    {
                        $SysGuildStageInfo->setFastPassTime($useTime);
                    }
                    $SysGuildStageInfo->save();

                    //todo:发送通关奖励,所有工会成员,如果短于7days,还有附加奖励一块应该是添加公会币的地方先写一个测试数据 具体等策划出案子
                    $pass_rewards = DataModule::lookupDataTable(GUILD_INSTANCE_LUA_KEY, "pass_rewards");
                    $week_pass_bonus = 0;
                    if($SysGuildStageInfo->getFastPassTime()<7*24*60*60)
                    {
                        $current_stage = $SysGuildStageInfo->getStageId();
                        $week_pass_level_bonus = DataModule::lookupDataTable(GUILD_INSTANCE_LUA_KEY, "week_pass_level_bonus");
                        $week_pass_bonus = $week_pass_level_bonus[$current_stage];
                    }
                    $SysPlayerGuildInfoArray = new SysPlayerGuild();
                    $SysPlayerGuildInfoArray->setGuildId($SysPlayerGuildInfo->getGuildId());
                    if($SysPlayerGuildInfoArray->LoadedExistFields())
                    {
                        foreach($SysPlayerGuildInfoArray as $SysPlayerGuildIdArray)
                        {
                           $userId =  $SysPlayerGuildIdArray->getUserId();
                           PlayerModule::modifyPlyGuildPoint($userId,$pass_rewards,"addpassrewards");
                           PlayerModule::modifyPlyGuildPoint($userId,$week_pass_bonus,"add7daysrewards");
                        }
                    }

                    //Damage Ranking Rewards
                    $damage_ranking = 1;
                    $damage_ranking_bonus = DataModule::lookupDataTable(GUILD_INSTANCE_LUA_KEY, "Damage_Ranking_Rewards");
                    $needSting = " max(damage) as damage,user_id,user_name ";
                    $whereStr = " guild_id = '{$myGuildId}' and raid_id = '{$raidId}' group by user_id ";
                    $SysGuildStageBattleHistoryArray = SysGuildStageBattleHistory::loadedTable($needSting, $whereStr);
                    foreach ($SysGuildStageBattleHistoryArray as $SysGuildStageBattleHistory)
                    {
                        if ($damage_ranking < sizeof($damage_ranking_bonus) && $userId == $SysGuildStageBattleHistory->getUserId())
                        {
                            $damage_bonus = $damage_ranking_bonus[$damage_ranking];
                            PlayerModule::modifyPlyGuildPoint($userId,$damage_bonus,"damagerankingrewards");
                        }
                        else
                        {
                            break;
                        }
                        $damage_ranking += 1;
                    }

                    //自动开启新关卡
                    $nextRaid = $SysGuildStageInfo->getRaidId() + 1;
                    $SysGuildStageNext = new SysGuildStage();
                    $SysGuildStageNext->setGuildId($SysPlayerGuildInfo->getGuildId());
                    $SysGuildStageNext->setRaidId($nextRaid);
                    if ($SysGuildStageNext->LoadedExistFields())
                    {

                    }
                    $raidArr = DataModule::lookupDataTable(GUILD_RAID_LUA_KEY, $nextRaid);
                    if (!empty($raidArr))
                    {
                        $returnLootArr = self::initStageLootArr($raidArr['Begin Stage ID']);
                        $lootArr = $returnLootArr[0];
                        if (count($lootArr) > 0)
                        {
                            $LootStrArr = array();
                            foreach ($lootArr as $lootInfo)
                            {
                                $LootStrArr[] = implode("-", $lootInfo);
                            }

                            $SysGuildStageNext->setLoot(implode("|", $LootStrArr));
                        }
                        else
                        {
                            $SysGuildStageNext->setLoot("");
                        }
                        $SysGuildStageNext->setSpecialLoot("");

                        $SysGuildStageNext->setStageId($raidArr['Begin Stage ID']);
                        $SysGuildStageNext->setWaveIndex(1);
                        $SysGuildStageNext->setBeginTime(time());
                        $SysGuildStageNext->setChallenger(0);
                        $SysGuildStageNext->setChallengerBeginTime(0);
                        $SysGuildStageNext->setChallengerStatus(0);
                        $SysGuildStageNext->setDetail("");
                        $SysGuildStageNext->setProgress(0);
                        $SysGuildStageNext->setStageProgress(0);
                        $SysGuildStageNext->setServerId($serverId);
                        $SysGuildStageNext->inOrUp();

                        $nextStage = $SysGuildStageInfo->getStageId() + 1;
                        //公会日志--start
                        if ($nextStage == ($raidArray['Begin Stage ID'] + $raidArray['Stages Count'] - 1))
                        {
                        	$field['userId']=$userId;
                        	$field['raidId']=$SysGuildStageInfo->getRaidId();
                        	$message = self::write_guild_log($field, 7);
                        	$guildId=$SysPlayerGuildInfo->getGuildId();
                        	self::guild_log($guildId, $message);
                        }
                        //--end

                    }
                }

                $Down_GuildInstanceEndDown->setSummary(self::getDownGuildInstanceSummary($SysGuildStageInfo));
                $Down_GuildInstanceEndDown->setResult($Up_GuildInstanceEnd->getResult());
                $Down_GuildInstanceEndDown->setStageOldProgress($oldStageProgress);
                $Down_GuildInstanceEndDown->setJoinTimes($SysPlayerGuildInfo->getJoinTime());
                $guildReplyInfo->setInstanceEnd($Down_GuildInstanceEndDown);

                return $guildReplyInfo;
            }
        }
        return null;
    }

    /**
     * 处理掉落解析
     *
     * @param TbGuildStage $SysGuildStage
     * @param Up_GuildInstanceEnd $Up_GuildInstanceEnd
     */
    private static function lootParse(&$SysGuildStageInfo, $Up_GuildInstanceEnd)
    {
        $returnArr = array(
            'user' => array(),
            'guild' => array(),
        );

        $lootIsChange = $specialLootIsChange = false;

        $lootArr = $lootFinalArr = array();
        $specialLootArr = $specialLootFinalArr = array();

        $lootStr = $SysGuildStageInfo->getLoot();
        $specialLootStr = $SysGuildStageInfo->getSpecialLoot();

        if (strlen($lootStr) > 5 || strlen($specialLootStr) > 5)
        {
            if (strlen($lootStr) > 5)
            {
                $lootInfo = explode("|", $lootStr);
                foreach ($lootInfo as $loot)
                {
                    $lootDetail = explode("-", $loot);
                    if (count($lootDetail) >= 4)
                    {
                        $lootArr[] = $lootDetail;
                    }
                }
            }
            if (strlen($specialLootStr) > 5)
            {
                $specialArr_ = explode("@", $specialLootStr);
                foreach ($specialArr_ as $kkk => $specialStr_)
                {
                    $per_ = $kkk + 1;
                    $lootDetail = array();
                    if (strlen($specialStr_) > 5)
                    {
                        $lootInfo = explode("|", $specialStr_);
                        foreach ($lootInfo as $loot)
                        {
                            $lootDetail = explode("-", $loot);
                            if (count($lootDetail) >= 4)
                            {
                                $specialLootArr[$per_][] = $lootDetail;
                            }
                        }
                    }
                }
            }
            $lootFinalArr = $lootArr;
            $specialLootFinalArr = $specialLootArr;
            if ($Up_GuildInstanceEnd->getStageProgress() >= 10000)
            { //本stage是否打完,打完全部发放
                foreach ($lootArr as $loot_)
                {
                    if ($loot_[3] == 0)
                    {
                        $returnArr['user'][] = $loot_[2];
                    }
                    else
                    {
                        $returnArr['guild'][] = $loot_[2];
                    }
                }

                $lootFinalArr = array();

                //打完了多血条的情况
                foreach ($specialLootArr as $perArr_)
                {
                    foreach ($perArr_ as $special_)
                    {
                        if (!empty($special_) && count($special_) >= 4)
                        {
                            if ($special_[3] == 0)
                            {
                                $returnArr['user'][] = $special_[2];
                            }
                            else
                            {
                                $returnArr['guild'][] = $special_[2];
                            }
                        }
                    }
                }

                $specialLootFinalArr = array();
                $lootIsChange = $specialLootIsChange = true;
            }
            else
            {
                for ($i = $SysGuildStageInfo->getWaveIndex(); $i < $Up_GuildInstanceEnd->getWave(); $i++)
                { //前几波boss全部杀死
                    foreach ($lootArr as $key_ => $loot_)
                    {
                        if ($loot_[0] == $i)
                        {
                            if ($loot_[3] == 0)
                            {
                                $returnArr['user'][] = $loot_[2];
                            }
                            else
                            {
                                $returnArr['guild'][] = $loot_[2];
                            }
                            unset($lootFinalArr[$key_]);

                            $lootIsChange = true;
                        }
                    }
                }
                //获取当前wave boss位置, 判断当前wave武将血值
                $battleTable = DataModule::lookupDataTable(BATTLE_LUA_KEY, null, array($SysGuildStageInfo->getStageId(), $Up_GuildInstanceEnd->getWave()));
                $bossPosition = $battleTable['Boss Position'];
                $heroHPArr_ = $Up_GuildInstanceEnd->getHpInfo();
                Logger::getLogger()->debug("lootParse .....$bossPosition:" . __LINE__);
                Logger::getLogger()->debug(print_r($heroHPArr_, true));
                $bossHP = $heroHPArr_[$bossPosition - 1];
                if ($bossHP == 0)
                {
                    foreach ($lootArr as $key_ => $loot_)
                    {
                        if ($loot_[0] == $Up_GuildInstanceEnd->getWave() && $loot_[1] == $bossPosition)
                        {
                            if ($loot_[3] == 0)
                            {
                                $returnArr['user'][] = $loot_[2];
                            }
                            else
                            {
                                $returnArr['guild'][] = $loot_[2];
                            }
                            unset($lootFinalArr[$key_]);
                            $lootIsChange = true;
                        }
                    }
                }

                //如果是有多血条,现在所处血条范围以及获得情况
                if ($Up_GuildInstanceEnd->getWave() == 3 && count($specialLootArr) > 0)
                {
                    $beginIndex = floor((10000 - $bossHP) / 1000);
                    for ($i = 1; $i <= $beginIndex; $i++)
                    {
                        foreach ($specialLootArr as $perKey_ => $perArr_)
                        {
                            if ($perKey_ == $i)
                            {
                                foreach ($perArr_ as $special_)
                                {
                                    if (!empty($special_) && count($special_) >= 4)
                                    {
                                        if ($special_[3] == 0)
                                        {
                                            $returnArr['user'][] = $special_[2];
                                        }
                                        else
                                        {
                                            $returnArr['guild'][] = $special_[2];
                                        }
                                    }
                                }
                                unset($specialLootFinalArr[$perKey_]);
                                $specialLootIsChange = true;
                            }
                        }
                    }
                }

            }

            //重新保存对应的掉落信息
            $lootFinalStr = $specialLootFinalStr = "";
            if ($lootIsChange)
            {
                foreach ($lootFinalArr as $loot_)
                {
                    if (!empty($loot_))
                    {
                        $lootFinalStr .= implode("-", $loot_) . "|";
                    }
                }
                if (strlen($lootFinalStr) > 5)
                {
                    $lootFinalStr = substr($lootFinalStr, 0, -1);
                    $SysGuildStageInfo->setLoot($lootFinalStr);
                }
            }
            if ($specialLootIsChange)
            {
                $specialLootFinalTempArr = array();
                foreach ($specialLootFinalArr as $perKey_ => $perArr_)
                {
                    foreach ($perArr_ as $special_)
                    {
                        $specialLootFinalTempArr[$perKey_][] = implode("-", $special_);
                    }
                }
                for ($i = 1; $i <= 9; $i++)
                {
                    if (isset($specialLootFinalTempArr[$i]) && !empty($specialLootFinalTempArr[$i]))
                    {
                        $specialLootFinalStr .= implode("|", $specialLootFinalTempArr[$i]) . "@";
                    }
                    else
                    {
                        $specialLootFinalStr .= "@";
                    }
                }
                if (strlen($specialLootFinalStr) > 5)
                {
                    $specialLootFinalStr = substr($specialLootFinalStr, 0, -1);
                    $SysGuildStageInfo->setSpecialLoot($specialLootFinalStr);
                }
            }
        }
        return $returnArr;
    }

    /**
     * 尝试进入关卡
     *
     * @param $userId
     * @param $stageId
     * @return Down_GuildReply|null
     */
    public static function instancePrepare($userId, $stageId)
    {
        $guildReplyInfo = new Down_GuildReply();
        $Down_GuildInstancePrepare = new Down_GuildInstancePrepare();
        $Down_GuildInstancePrepare->setResult(Down_Result::fail);
        $Down_GuildInstancePrepare->setLeftTime(0);

        //战斗时及结算也检查
        //检查剩余次数
        $SysPlayerGuildInfo = self::getTbPlayerGuild($userId);
        if ($SysPlayerGuildInfo->getGuildId() > 0)
        {
            $stageRaidArray = self::getStageRaidArr();
            if (!isset($stageRaidArray[$stageId]))
            {
                $guildReplyInfo->setInstancePrepare($Down_GuildInstancePrepare);

                return $guildReplyInfo;
            }
            //todo:检查自己对应的普通副本有没有完成  Require Stage ------等后期测试
            $SysNormalStageInfo = new SysPlayerNormalStage();
            $SysNormalStageInfo->setUserId($userId);
            if ($SysNormalStageInfo->LoadedExistFields())
            {
                $userMaxStageId = $SysNormalStageInfo->getMaxStageId();
                $stageTable = DataModule::lookupDataTable(STAGE_LUA_KEY,$userMaxStageId);
                $raidArr = DataModule::lookupDataTable(GUILD_RAID_LUA_KEY, $stageRaidArray[$stageId]);
                if($stageTable["Chapter ID"]<$raidArr["Chapter ID"])
                {
                    $guildReplyInfo->setInstancePrepare($Down_GuildInstancePrepare);

                    return $guildReplyInfo;
                }
            }
            //todo：防止跳跃关卡---等后期测试
            $SysGuildStageInfo = new SysGuildStage();
            $SysGuildStageInfo->setGuildId($SysPlayerGuildInfo->getGuildId());
            $SysGuildStageInfo->setStageId($stageId);
            $SysGuildStageInfo->setRaidId($stageRaidArray[$stageId]);
            if ($SysGuildStageInfo->LoadedExistFields())
            {
                //每个怪的血值
                //用户的所有挑战记录,包括输出伤害Todo:等后期测试
                if ($SysGuildStageInfo->getChallenger() > 0 && $SysGuildStageInfo->getChallenger() != $userId)
                {
                    $challenging = self::isChallenging($SysGuildStageInfo);
                    if ($challenging)
                    {
                        $guildReplyInfo->setInstancePrepare($Down_GuildInstancePrepare);

                        return $guildReplyInfo;
                    }
                }
                if ($SysGuildStageInfo->getChallenger() == $userId)
                {
                    $now = time();
                    if (($now - $SysGuildStageInfo->getChallengerBeginTime()) > self::GUILD_PRE_OVER_TIME)
                    {
                        $SysGuildStageInfo->setChallenger($userId);
                        $SysGuildStageInfo->setChallengerBeginTime(time());
                        $Down_GuildInstancePrepare->setLeftTime(60); //准备阶段剩余时间
                    }
                    else
                    {
                        $Down_GuildInstancePrepare->setLeftTime(self::GUILD_PRE_OVER_TIME - ($now - $SysGuildStageInfo->getChallengerBeginTime())); //准备阶段剩余时间
                    }
                }
                else
                {
                    $Down_GuildInstancePrepare->setLeftTime(60); //准备阶段剩余时间
                }

                $SysGuildStageInfo->setChallenger($userId);
                $SysGuildStageInfo->setStageId($stageId);
                $SysGuildStageInfo->setChallengerStatus(Down_GuildInstanceDetail_ChallengerStatus::prepare);
                $SysGuildStageInfo->save();
                $Down_GuildInstancePrepare->setResult(Down_Result::success);
            }
        }
        $guildReplyInfo->setInstancePrepare($Down_GuildInstancePrepare);
        return $guildReplyInfo;
    }

    //开启或者重置副本
    public static function instanceOpen($userId, $raidId)
    {
        $guildReplyInfo = new Down_GuildReply();
        $Down_GuildInstanceOpen = new Down_GuildInstanceOpen();
        //检查剩余次数
        $SysPlayerGuildInfo = self::getTbPlayerGuild($userId);
        if ($SysPlayerGuildInfo->getGuildId() > 0)
        {
            $raidArr = DataModule::lookupDataTable(GUILD_RAID_LUA_KEY, $raidId);
            //检查所需要的公会活跃度
            $SysGuildInfo = self::getTbGuildInfo($SysPlayerGuildInfo->getGuildId());
            if ($raidArr['Guild Active Cost'] > $SysGuildInfo->getVitality())
            {
                Logger::getLogger()->debug("instanceOpen Vitality not enough:" . __LINE__);

                return null;
            }
            //必须是会长
            if ($SysPlayerGuildInfo->getGuildPosition() != Down_GuildJobT::chairman)
            {
                Logger::getLogger()->debug("instanceOpen not chairman:" . __LINE__);

                return null;
            }
            //扣除活跃度
            $SysGuildInfo->setVitality($SysGuildInfo->getVitality() - $raidArr['Guild Active Cost']);
            $SysGuildInfo->save();

            $SysGuildStageInfo = new SysGuildStage();
            $SysGuildStageInfo->setGuildId($SysPlayerGuildInfo->getGuildId());
            $SysGuildStageInfo->setRaidId($raidId);
            if ($SysGuildStageInfo->LoadedExistFields())
            {
                //todo：处理重置副本 删除对应的数据---后期测试
                $sql = "delete from player_guild_stage  where guild_id = '{$SysPlayerGuildInfo->getGuildId()}' and raid_id = '{$raidId}' ";
                MySQL::getInstance()->RunQuery($sql);
                //公会日志--start
                $field['userId'] = $userId;
                $field['raidId'] = $raidId;
                $message = self::write_guild_log($field, 6);
                $guildId=$SysPlayerGuildInfo->getGuildId();
                self::guild_log($guildId, $message);
                //--end

            }
            //todo:初始化第一关卡的掉落信息(普通和特殊)
            $returnLootArr = self::initStageLootArr($raidArr['Begin Stage ID']);
            $lootArr = $returnLootArr[0];
            if (count($lootArr) > 0)
            {
                $LootStrArr = array();
                foreach ($lootArr as $lootInfo)
                {
                    $LootStrArr[] = implode("-", $lootInfo);
                }
                $SysGuildStageInfo->setLoot(implode("|", $LootStrArr));
            }
            else
            {
                $SysGuildStageInfo->setLoot("");
            }
            $SysGuildStageInfo->setSpecialLoot("");
            $serverId = PlayerCacheModule::getServerID($userId);
            $SysGuildStageInfo->setStageId($raidArr['Begin Stage ID']);
            $SysGuildStageInfo->setWaveIndex(1);
            $SysGuildStageInfo->setBeginTime(time());
            $SysGuildStageInfo->setChallenger(0);
            $SysGuildStageInfo->setChallengerBeginTime(0);
            $SysGuildStageInfo->setChallengerStatus(0);
            $SysGuildStageInfo->setDetail("");
            $SysGuildStageInfo->setProgress(0);
            $SysGuildStageInfo->setStageProgress(0);
            $SysGuildStageInfo->setServerId($serverId);
            $SysGuildStageInfo->inOrUp();

            $Down_GuildInstanceOpen->setResult(Down_Result::success);
            $Down_GuildInstanceOpen->setRaidId($raidId);
            $Down_GuildInstanceOpen->setLeftTime(7 * 24 * 3600);

            $guildReplyInfo->setInstanceOpen($Down_GuildInstanceOpen);

            return $guildReplyInfo;
        }

        return null;
    }

    private static function openRaid()
    {

    }

    /**
     *  获取当前副本的掉落情况和申请(所有人)
     *
     * @param $userId
     * @param $raidId
     * @return Down_GuildReply
     */
    public static function instanceDrop($userId, $raidId)
    {
        $guildReplyInfo = new Down_GuildReply();
        $Down_GuildInstanceDrop = new Down_GuildInstanceDrop();
        $SysPlayerGuildInfo = self::getTbPlayerGuild($userId);
        if ($SysPlayerGuildInfo->getGuildId() > 0)
        {

            //获取公会内所有的申请信息
            $where = " guild_id = '{$SysPlayerGuildInfo->getGuildId()}' and item_id > 0 order by sort asc ";
            $SysPlayerGuildAppQueueArray = SysPlayerGuildAppQueue::loadedTable(null, $where);
            $applyItemArr = array();
            $myRank = 0;
            $myApplyItem = 0;
            foreach ($SysPlayerGuildAppQueueArray as $SysPlayerGuildAppQueue)
            {
                if (!isset($applyItemArr[$SysPlayerGuildAppQueue->getItemId()]))
                {
                    $applyItemArr[$SysPlayerGuildAppQueue->getItemId()] = 1;
                }
                else
                {
                    $applyItemArr[$SysPlayerGuildAppQueue->getItemId()] += 1;
                }
                if ($SysPlayerGuildAppQueue->getUserId() == $userId)
                {
                    $myRank = $applyItemArr[$SysPlayerGuildAppQueue->getItemId()];
                    $myApplyItem = $SysPlayerGuildAppQueue->getItemId();
                }
            }
            //所有已经掉落的物品详情
            $where = " guild_id = '{$SysPlayerGuildInfo->getGuildId()}' and state = 0 ";
            $SysGuildStageDropArray = SysGuildStageDrop::loadedTable(null, $where);
            $guildItemArr = array();
            $isCanApplyArr = array();
            /** @var TbGuildStageDrop $SysGuildStageDrop_ */
            foreach ($SysGuildStageDropArray as $SysGuildStageDrop)
            {
                if (!isset($guildItemArr[$SysGuildStageDrop->getItemId()]))
                {
                    $guildItemArr[$SysGuildStageDrop->getItemId()] = $SysGuildStageDrop->getDropCount();
                }
                else
                {
                    $guildItemArr[$SysGuildStageDrop->getItemId()] += $SysGuildStageDrop->getDropCount();
                }
                if ($SysPlayerGuildInfo->getJoinTime() < $SysGuildStageDrop->getDropTime())
                {
                    if (!isset($isCanApplyArr[$SysGuildStageDrop->getItemId()]))
                    {
                        $isCanApplyArr[$SysGuildStageDrop->getItemId()] = $SysGuildStageDrop->getDropCount();
                    }
                    else
                    {
                        $isCanApplyArr[$SysGuildStageDrop->getItemId()] += $SysGuildStageDrop->getDropCount();
                    }
                }
            }
            $raidArr = DataModule::lookupDataTable(GUILD_RAID_LUA_KEY, $raidId);
            for ($i = 1; $i <= 10; $i++) {
                $key_ = "Special Loot $i ID";
                if (isset($raidArr[$key_]) && $raidArr[$key_] > 0)
                {
                    $itemId_ = $raidArr[$key_];
                    $Down_GuildInstanceItem = new Down_GuildInstanceItem();
                    $Down_GuildInstanceItem->setItemId($itemId_);
                    $Down_GuildInstanceItem->setNum(0);
                    if (isset($guildItemArr[$itemId_]))
                    {
                        $Down_GuildInstanceItem->setNum($guildItemArr[$itemId_]);
                    }
                    $Down_GuildInstanceItem->setState(Down_GuildInstanceItem_DropState::no_apply);
                    if ($myApplyItem == $itemId_)
                    {
                        $Down_GuildInstanceItem->setState(Down_GuildInstanceItem_DropState::apply);
                    }
                    /*if (isset($isCanApplyArr[$itemId_])) {
                        $Down_GuildInstanceItem->setState(Down_GuildInstanceItem_DropState::apply);
                    }*/
                    $Down_GuildInstanceItem->setApplyNum(0);
                    if (isset($applyItemArr[$itemId_]))
                    {
                        $Down_GuildInstanceItem->setApplyNum($applyItemArr[$itemId_]);
                    }
                    $Down_GuildInstanceItem->setAbleAppCount(0);
                    if (isset($isCanApplyArr[$itemId_]))
                    {
                        $Down_GuildInstanceItem->setAbleAppCount($isCanApplyArr[$itemId_]);
                    }
                    $Down_GuildInstanceDrop->appendItems($Down_GuildInstanceItem);
                }
            }
            //申请的物品以及当前排名
            if ($myApplyItem > 0)
            {
                $Down_GuildInstanceDrop->setApplyItemId($myApplyItem);
            }
            if ($myRank > 0)
            {
                $Down_GuildInstanceDrop->setRank($myRank);
            }
        }
        $Down_GuildInstanceDrop->setRaidId($raidId);
        Logger::getLogger()->debug(print_r($Down_GuildInstanceDrop, true));
        $guildReplyInfo->setInstanceDrop($Down_GuildInstanceDrop);

        return $guildReplyInfo;
    }

    private static function getDownGuildAppQueue($userId, $guildId, $itemId)
    {
        $Down_GuildAppQueue = new Down_GuildAppQueue();

        //获取队列中的用户
        $SysPlayerGuildAppQueueArr = SysPlayerGuildAppQueue::loadedTable(array('user_id','jump_times'), " guild_id = '{$guildId}' and item_id = '{$itemId}' order by sort asc ");
        $queueUserIdArr = array();
        $rank = 99;
        $rankIndex = 1;
        foreach ($SysPlayerGuildAppQueueArr as $SysPlayerGuildAppQueue_) {
            if ($SysPlayerGuildAppQueue_->getUserId() == $userId)
            {
                $rank = $rankIndex;
               $JumpTimes= $SysPlayerGuildAppQueue_->getJumpTimes();
            }
            $queueUserIdArr[] = $SysPlayerGuildAppQueue_->getUserId();
            $rankIndex++;
        }

        $queueUserIdStr = implode(",", $queueUserIdArr);
        $userSummaryArr = self::getDown_UserSummary(array($guildId), " and G.user_id in ($queueUserIdStr) ");
        if (isset($userSummaryArr[$guildId]))
        {
        	foreach ($queueUserIdStr as $v)
        	{
	            foreach ($userSummaryArr[$guildId] as $key=>$userSummary_)
	            {
	            	if($v==$key){
	               	 $Down_GuildAppQueue->appendSummary($userSummary_);
	            	}
	            }
        	}
        }

        $itemCount = 0;
        $drop_time=0;
        $SysGuildStageDrop = new SysGuildStageDrop();
        $SysGuildStageDrop->setGuildId($guildId);
        $SysGuildStageDrop->setItemId($itemId);
        
        if ($SysGuildStageDrop->LoadedExistFields()) {
            $itemCount = $SysGuildStageDrop->getDropCount() - $SysGuildStageDrop->getDistributeCount();
            if($itemCount>0)
            {
            	$drop_time = $SysGuildStageDrop->getDropTime();
            }
        }
        $CostMoney = ($rank-1)*50;
        $Down_GuildAppQueue->setTimeout($drop_time); //todo:
        $Down_GuildAppQueue->setItemCount($itemCount);
        $Down_GuildAppQueue->setRank($rank);
        $Down_GuildAppQueue->setItemId($itemId);
        $Down_GuildAppQueue->setJumpTimes($JumpTimes);
        $Down_GuildAppQueue->setCostMoney($CostMoney);

        return $Down_GuildAppQueue;
    }

    /**
     * 申请副本掉落  申请排队获取
     *
     * @param $userId
     * @param $raidId
     * @param $itemId
     * @return Down_GuildReply|null
     */
    public static function instanceApply($userId, $raidId, $itemId)
    {
        $guildReplyInfo = new Down_GuildReply();
        $Down_GuildInstanceApply = new Down_GuildInstanceApply();
        $Down_GuildInstanceApply->setResult(Down_Result::success);
        //todo:判断当前raid是否掉落此物品从配置档里读取是否存在客户端给发的itemId存在往下走不再在申请掉落违法返回相应的信息 20150414---420---后期测试
        $raidArray = DataModule::lookupDataTable(GUILD_RAID_LUA_KEY, $raidId);
        $maybeRewardArray = array();
        for ($i = 1; $i <= 10; $i++)
        {
            if (isset($raidArray["Special Loot $i ID"]))
            {
                $maybeRewardArray[$raidArray["Special Loot $i ID"]] = $raidArray["Special Loot $i ID"];
            }
        }
        if(!in_array($itemId,$maybeRewardArray))
        {
            return null;
        }
        $SysPlayerGuildInfo = self::getTbPlayerGuild($userId);
        $myGuildId = $SysPlayerGuildInfo->getGuildId();
        if ($SysPlayerGuildInfo->getGuildId() > 0)
        {
            $serverId = PlayerCacheModule::getServerID($userId);
            //返回当前物品的队列情况
            $now = time();
            $SysPlayerGuildAppQueue = new SysPlayerGuildAppQueue();
            $SysPlayerGuildAppQueue->setUserId($userId);
            if ($SysPlayerGuildAppQueue->loaded())
            {
                if ($SysPlayerGuildAppQueue->getItemId() == $itemId)
                { //重复发送相同的item,则是取消申请
                    $itemId = 0;
                }
            }
            $SysPlayerGuildAppQueue->setRaidId($raidId);
            $SysPlayerGuildAppQueue->setItemId($itemId);
            $SysPlayerGuildAppQueue->setApplyTime($now);
            $SysPlayerGuildAppQueue->setCostMoney(50);
            $SysPlayerGuildAppQueue->setSort($now);
            $SysPlayerGuildAppQueue->setGuildId($SysPlayerGuildInfo->getGuildId());
            $SysPlayerGuildAppQueue->setServerId($serverId);
            $SysPlayerGuildAppQueue->inOrUp();
            $Down_GuildAppQueue = self::getDownGuildAppQueue($userId, $myGuildId, $itemId);
            $Down_GuildInstanceApply->setAppQueue($Down_GuildAppQueue);
            $guildReplyInfo->setInstanceApply($Down_GuildInstanceApply);

            return $guildReplyInfo;
        }
        return null;
    }

    /**
     * 请求分配物品信息 详细的物品掉落信息,包括qps
     *
     * @param $userId
     * @return Down_GuildReply|null
     */
    public static function dropInfo($userId)
    {
        $guildReplyInfo = new Down_GuildReply();
        $Down_GuildDropInfo = new Down_GuildDropInfo();

        $SysPlayerGuildInfo = self::getTbPlayerGuild($userId);
        $myGuildId = $SysPlayerGuildInfo->getGuildId();
        if ($SysPlayerGuildInfo->getGuildId() > 0)
        {
            $Down_GuildMemberArr = self::getDown_GuildMember($myGuildId);
            foreach ($Down_GuildMemberArr as $GuildMember_)
            {
                $Down_GuildDropInfo->appendMembers($GuildMember_);
            }
            //获取所有的raid
            $SysGuildStageArray = SysGuildStage::loadedTable("raid_id", " guild_id = '{$myGuildId}' ");
            //所有raid的dps  (用户的dps累加以及最大dps值存储)
            $dpsArr = array();
            $SysPlayerGuildStageArray = SysPlayerGuildStage::loadedTable(null, " guild_id = '{$myGuildId}' ");
            foreach ($SysPlayerGuildStageArray as $SysPlayerGuildStage)
            {
                $dpsArr[$SysPlayerGuildStage->getRaidId()][] = $SysPlayerGuildStage;
            }
            //所有raid的掉落信息
            $itemArr = array();
            $whereStr = "guild_id = '{$myGuildId}' and state = 0 ";
            $SysGuildStageDropArray = SysGuildStageDrop::loadedTable(null, $whereStr);
            
            foreach ($SysGuildStageDropArray as $SysGuildStageDrop)
            {
                $itemArr[$SysGuildStageDrop->getRaidId()][] = $SysGuildStageDrop;
            }
            //获取所有物品的申请记录
            $applyArr = array();
            $where = " guild_id = '{$myGuildId}' and item_id > 0 order by sort asc ";
            $SysPlayerGuildAppQueueArray = SysPlayerGuildAppQueue::loadedTable(null, $where);
            foreach ($SysPlayerGuildAppQueueArray as $SysPlayerGuildAppQueue)
            {
                $applyArr[$SysPlayerGuildAppQueue->getItemId()][] = $SysPlayerGuildAppQueue;
            }
            Logger::getLogger()->debug("info:".json_encode($applyArr));
            foreach ($SysGuildStageArray as $SysGuildStage_)
            {
                $Down_GuildDropItem = new Down_GuildDropItem();
                $raidId = $SysGuildStage_->getRaidId();
                $Down_GuildDropItem->setRaidId($raidId);
                $ret_check = false;
                if (isset($dpsArr[$raidId]))
                {
                    foreach ($dpsArr[$raidId] as $SysPlayerGuildStage_)
                    {
                        $Down_GuildInstanceDps = new Down_GuildInstanceDps();
                        $Down_GuildInstanceDps->setDps($SysPlayerGuildStage_->getTotalDamage());
                        $Down_GuildInstanceDps->setUid($SysPlayerGuildStage_->getUserId());
                        $Down_GuildDropItem->appendDpsList($Down_GuildInstanceDps);
                    }
                    $ret_check = true;
                }
                if (isset($itemArr[$raidId]))
                {
                    foreach ($itemArr[$raidId] as $SysGuildStageDrop_)
                    {
                        $itemId = $SysGuildStageDrop_->getItemId();
                        $Down_GuildDropItemInfo = new Down_GuildDropItemInfo();
                        $Down_GuildDropItemInfo->setItemId($itemId);

                       	$y=date("Y");
                        $m=date("m");
                        $d=date("d");
                        $h=date("H")+1;
                        $i="00";
                        $s="00";
                         if($h<=11 || $h>=24)
                        {
                        	if($h>=24)
                        	{
                        		$DropTime=strtotime(date("Y-m-d",strtotime("+1 day")))+11*3600;
                        	}
                        	if($h<=11)
                        	{
                        		$h=11;
                        		$DropTime=strtotime($y.$m.$d.$h.$i.$s);
                        	}
                        }else 
                        {
                        	$DropTime=strtotime($y.$m.$d.$h.$i.$s);
                        }
                        $Down_GuildDropItemInfo->setTimeOutEnd($DropTime); //todo:

                        //申请者队列
                        if (isset($applyArr[$itemId]))
                        {
                            foreach ($applyArr[$itemId] as $SysPlayerGuildAppQueue_)
                            {
                                $Down_GuildDropItemInfo->appendUserId($SysPlayerGuildAppQueue_->getUserId());
                            }
                        }
                        $Down_GuildDropItem->appendItemInfo($Down_GuildDropItemInfo);
                    }
                    $ret_check = true;
                }
                $down_info = null;
                if ($ret_check)
                {
                    $down_info = $Down_GuildDropItem;
                }
                $Down_GuildDropInfo->appendItems($down_info);
            }
            $guildReplyInfo->setDropInfo($Down_GuildDropInfo);

            return $guildReplyInfo;
        }
        return null;
    }

    /**
     * 分物品  公会会长分配物品给某个人,每日限一次
     *
     * @param $userId
     * @param Up_GuildDropGive $Up_GuildDropGive
     */
    public static function dropGive($userId, $Up_GuildDropGive)
    {
        $guildReplyInfo = new Down_GuildReply();
        $Down_GuildDropGive = new Down_GuildDropGive();
        $Down_GuildDropGive->setResult(Down_Result::fail);
        $guildReplyInfo->setDropGive($Down_GuildDropGive);
        $SysPlayerGuildInfo = self::getTbPlayerGuild($userId);
        $myGuildId = $SysPlayerGuildInfo->getGuildId();
        if ($SysPlayerGuildInfo->getGuildId() > 0)
        {
            //必须是会长
            if ($SysPlayerGuildInfo->getGuildPosition() != Down_GuildJobT::chairman)
            {
                return $guildReplyInfo;
            }
            $SysGuildInfo = self::getTbGuildInfo($SysPlayerGuildInfo->getGuildId());
            //检查今日使用的次数
            if ($SysGuildInfo->getDistributeNum() >= 100)
            {
                //失败
                return $guildReplyInfo;
            }
            //判断物品是否存在, 数量是否够,副本掉落表中此物品分配加1

            $raid_id = $Up_GuildDropGive->getRaidId();
            $item_id = $Up_GuildDropGive->getItemId();

            $SysGuildStageDropInfo = new SysGuildStageDrop();
            $SysGuildStageDropInfo->setGuildId($myGuildId);
            $SysGuildStageDropInfo->setRaidId($raid_id);
            $SysGuildStageDropInfo->setItemId($item_id);
            if (!$SysGuildStageDropInfo->LoadedExistFields())
            {
                return $guildReplyInfo;
            }
            if ($SysGuildStageDropInfo->getDropCount() <= $SysGuildStageDropInfo->getDistributeCount())
            {
                return $guildReplyInfo;
            }
            $time_out = $SysGuildStageDropInfo->getDropTime();

            $SysGuildInfo->setDistributeNum(1);
            $SysGuildInfo->setDistributeTime(time());
            $SysGuildInfo->save();

            //When reward was given, reward data should be delete.
            $sql = "delete from guild_stage_drop 
            where guild_id = '{$myGuildId}' and raid_id = '{$raid_id}' and item_id = '{$item_id}' and drop_time = '{$time_out}'";
            MySQL::getInstance()->RunQuery($sql);

            //记录发放历史
            $SysGuildStageItemsHistoryInfo = new SysGuildStageItemsHistory();
            $SysGuildStageItemsHistoryInfo->setUserId($Up_GuildDropGive->getUserId());
            $SysGuildStageItemsHistoryInfo->setItemId($Up_GuildDropGive->getItemId());
            $SysGuildStageItemsHistoryInfo->setSenderUserId($userId);
            $SysGuildStageItemsHistoryInfo->setSendTime(time());
            $SysGuildStageItemsHistoryInfo->setGuildId($myGuildId);
            $SysGuildStageItemsHistoryInfo->setType(1); //标记为是人为分配的
            $SysGuildStageItemsHistoryInfo->setRaidId($Up_GuildDropGive->getRaidId());
            $SysGuildStageItemsHistoryInfo->inOrUp();

            //发放奖励
            ItemModule::addItem($Up_GuildDropGive->getUserId(), array($Up_GuildDropGive->getItemId() => 1), "GuildDropGive");
            $Down_GuildDropGive->setResult(Down_Result::success);
            $guildReplyInfo->setDropGive($Down_GuildDropGive);
			//公会日志 --start

            $field['userId']=$userId;
            $field['memberUid']=$Up_GuildDropGive->getUserId();
            $field['itemId']=$Up_GuildDropGive->getItemId();
            $message = self::write_guild_log($field, 8);
            $guildId=$SysPlayerGuildInfo->getGuildId();
            self::guild_log($guildId, $message);
            //--end
            return $guildReplyInfo;
        }
        return $guildReplyInfo;
    }

    /**
     * 输出统计 单次最高伤害排名
     *
     * @param $userId
     * @param $raidId
     */
    public static function instanceDamage($userId, $raidId)
    {
        $guildReplyInfo = new Down_GuildReply();
        $Down_GuildInstanceDamage = new Down_GuildInstanceDamage();

        $SysPlayerGuildInfo = self::getTbPlayerGuild($userId);
        $myGuildId = $SysPlayerGuildInfo->getGuildId();
        if ($SysPlayerGuildInfo->getGuildId() > 0)
        {
            $damageArr = array();
            $needSting = " max(damage) as damage,user_id,user_name ";
            $whereStr = " guild_id = '{$myGuildId}' and raid_id = '{$raidId}' group by user_id ";
            $SysGuildStageBattleHistoryArray = SysGuildStageBattleHistory::loadedTable($needSting, $whereStr);
            foreach ($SysGuildStageBattleHistoryArray as $SysGuildStageBattleHistory)
            {
                $damageArr[$SysGuildStageBattleHistory->getUserId()] = $SysGuildStageBattleHistory->getDamage();
            }
            $UserSummaryArr = array();
            $userIdArr = array_keys($damageArr);
            if (count($userIdArr) > 0)
            {
                $userIdStr = implode(",", $userIdArr);
                $UserSummaryArr = self::getDown_UserSummary(array($myGuildId), " and G.user_id in ($userIdStr) ");
            }
            $isthere = 0;
            foreach ($damageArr as $userId_ => $damage_)
            {
                if (isset($UserSummaryArr[$myGuildId]) && isset($UserSummaryArr[$myGuildId][$userId_]))
                {
                    $Down_GuildChallengerDamage = new Down_GuildChallengerDamage();
                    $Down_GuildChallenger = new Down_GuildChallenger();
                    $Down_GuildChallenger->setSummary($UserSummaryArr[$myGuildId][$userId_]);
                    $Down_GuildChallengerDamage->setChallenger($Down_GuildChallenger);
                    $Down_GuildChallengerDamage->setDamage($damage_);
                    $Down_GuildInstanceDamage->appendDamages($Down_GuildChallengerDamage);
                    $isthere = 1;
                }
            }
            $Down_GuildInstanceDamage->setIsthere($isthere);
        }
        $guildReplyInfo->setInstanceDamage($Down_GuildInstanceDamage);

        return $guildReplyInfo;
    }

    /**
     * 物品分配纪录
     *
     * @param $userId
     * @return Down_GuildReply
     */
    public static function itemsHistory($userId)
    {
        $guildReplyInfo = new Down_GuildReply();
        $Down_GuildItemsHistory = new Down_GuildItemsHistory();

        $SysPlayerGuildInfo = self::getTbPlayerGuild($userId);
        $myGuildId = $SysPlayerGuildInfo->getGuildId();
        if ($SysPlayerGuildInfo->getGuildId() > 0)
        {
            $SysGuildStageItemsHistoryArray = SysGuildStageItemsHistory::loadedTable(null, " guild_id = '{$myGuildId}' order by id desc limit 20 ");
           //todo:修改道具分配数据为空的时候处理方式-----后期测试20150420
           $isthere = 0;
            foreach ($SysGuildStageItemsHistoryArray as $SysGuildStageItemsHistory)
            {
                $Down_GuildItemHistory = new Down_GuildItemHistory();
                $Down_GuildItemHistory->setItemId($SysGuildStageItemsHistory->getItemId());
                $Down_GuildItemHistory->setReceiverName($SysGuildStageItemsHistory->getUserId());
                $Down_GuildItemHistory->setSendTime($SysGuildStageItemsHistory->getSendTime());
                if ($SysGuildStageItemsHistory->getType() == 1)
                {
                    $Down_GuildItemHistory->setSenderName($SysGuildStageItemsHistory->getSenderUserName());
                }
                $Down_GuildItemsHistory->appendItemHistorys($Down_GuildItemHistory);
                $isthere = 1;
            }
            $Down_GuildItemsHistory->setIsthere($isthere);
        }
       
        $guildReplyInfo->setItemsHistory($Down_GuildItemsHistory);
        

        return $guildReplyInfo;
    }

    /**
     * 申请插队
     *
     * @param $userId

     * @return $Down_GuildJump|null
     */

    public static function guildJump($userId)
    {
        $guildReplyInfo = new Down_GuildReply();
        $Down_GuildJump = new Down_GuildJump();
        //判断是否允许插队
        $SysPlayerGuildInfo = self::getTbPlayerGuild($userId);
        $myGuildId = $SysPlayerGuildInfo->getGuildId();
        if ($myGuildId > 0)
        {
            // 公会信息
            $SysGuildInfo = self::getTbGuildInfo($myGuildId);
            $canJump = $SysGuildInfo->getCanJump();
            // 不允许插队
            if($canJump == 0)
                return $guildReplyInfo;
            else
                Logger::getLogger()->debug("Queue-jumping is allowed in your guild, that's evil" );
        }

        $SysPlayerGuildAppQueue = new SysPlayerGuildAppQueue();
        $SysPlayerGuildAppQueue->setUserId($userId);


        if (!$SysPlayerGuildAppQueue->loaded())
        {
            $Down_GuildJump->setResult(0);
            $Down_GuildJump->setAppQueue(0);
            $guildReplyInfo->setGuildJump($Down_GuildJump);
            return $guildReplyInfo;
        }

        $raidId = $SysPlayerGuildAppQueue->getRaidId();
        $itemId = $SysPlayerGuildAppQueue->getItemId();
        $guildId = $SysPlayerGuildAppQueue->getGuildId();
        $where = " guild_id = '{$guildId}' and item_id = '{$itemId}' order by sort asc ";
        $SysPlayerGuildAppQueueArray = SysPlayerGuildAppQueue::loadedTable(null, $where);
        $SysPlayerGuildAppQueueFirst = $SysPlayerGuildAppQueueArray[0];
        if ($SysPlayerGuildAppQueue->getUserId() == $SysPlayerGuildAppQueueFirst->getUserId())
        {
            Logger::getLogger()->debug("Player already in the first" );
            $Down_GuildJump->setAppQueue(0);
            $guildReplyInfo->setGuildJump($Down_GuildJump);
            return $guildReplyInfo;
        }

        //判断插队所需要的公会硬币是否满足
        $sysPlayer = PlayerModule::getPlayerTable($userId);
        $playerGuildPoint = $sysPlayer->getGuildPoint();

        $totalCostMoney = 0;

        for ($i = 0; $i < count($SysPlayerGuildAppQueueArray); $i++)
        {
            // 得到需要花费的公会币总数
            if($SysPlayerGuildAppQueueArray[$i]->getUserId() != $SysPlayerGuildAppQueue->getUserId())
            {
                $totalCostMoney = $totalCostMoney + $SysPlayerGuildAppQueueArray[$i]->getCostMoney();
            }
        }

        // 公会币不足以支付所有其他玩家
        if($playerGuildPoint < $totalCostMoney)
        {
            return $guildReplyInfo;
        }

        for ($i = 0; $i < count($SysPlayerGuildAppQueueArray); $i++)
        {
            // 其他成员降位
            if($SysPlayerGuildAppQueueArray[$i]->getUserId() != $SysPlayerGuildAppQueue->getUserId())
            {
                $SysPlayerGuildAppQueueArray[$i]->setSort($SysPlayerGuildAppQueueArray[$i]->getSort() + 1);
                PlayerModule::modifyPlyGuildPoint($SysPlayerGuildAppQueueArray[$i]->getUserId(),$SysPlayerGuildAppQueueArray[$i]->getCostMoney());
                $SysPlayerGuildAppQueueArray[$i]->save();
                
            }
            // 插队成员升到第一
            else
            {
                //扣除公会硬币,发放给被插队者
                $SysPlayerGuildAppQueue->setSort(1);
                $SysPlayerGuildAppQueue->setJumpTimes($SysPlayerGuildAppQueue->getJumpTimes() + 1);
                PlayerModule::modifyPlyGuildPoint($userId,-$totalCostMoney);
            }
        }

        $SysPlayerGuildAppQueue->save();

        $Down_GuildAppQueue = self::getDownGuildAppQueue($userId, $guildId, $itemId);
        $Down_GuildJump->setResult(Down_Result::success);
        $Down_GuildJump->setAppQueue($Down_GuildAppQueue);

        $guildReplyInfo->setGuildJump($Down_GuildJump);

        return $guildReplyInfo;
    }



    /**
     * 请求物品的申请队列
     *
     * @param $userId
     * @param $itemId
     */
    public static function guildAppQueue($userId, $itemId)
    {
        $guildReplyInfo = new Down_GuildReply();
        $SysPlayerGuildInfo = self::getTbPlayerGuild($userId);
        $myGuildId = $SysPlayerGuildInfo->getGuildId();
        if ($SysPlayerGuildInfo->getGuildId() > 0)
        {
            $Down_GuildAppQueue = self::getDownGuildAppQueue($userId, $myGuildId, $itemId);
            $guildReplyInfo->setGuildAppQueue($Down_GuildAppQueue);

            return $guildReplyInfo;
        }
        return null;
    }

    /**
     * stage排行榜
     *
     * @param $userId
     * @param $stageId
     * @return Down_GuildStageRank
     */
    public static function guildStageRank($userId, $stageId)
    {
        $guildReplyInfo = new Down_GuildReply();
        $Down_GuildStageRank = new Down_GuildStageRank();
        $Down_GuildStageRank->setStageId($stageId);
        $serverId = PlayerCacheModule::getServerID($userId);
        $SysPlayerGuildInfo = self::getTbPlayerGuild($userId);
        $myGuildId = $SysPlayerGuildInfo->getGuildId();
        if ($SysPlayerGuildInfo->getGuildId() > 0)
        {
            $stageRaidArr_ = self::getStageRaidArr();
            if (!isset($stageRaidArr_[$stageId]))
            {
                Logger::getLogger()->error("guildStageRank, " . __LINE__);
                $guildReplyInfo->setGuildStageRank($Down_GuildStageRank);

                return $guildReplyInfo;
            }
            $raidId = $stageRaidArr_[$stageId];
            $raidArr = DataModule::lookupDataTable(GUILD_RAID_LUA_KEY, $raidId);
            if ($stageId == ($raidArr['Begin Stage ID'] + $raidArr['Stages Count'] - 1))
            {
                //获取本服最快通关公会
                $where = " raid_id = '{$raidId}' and server_id = '{$serverId}' and fast_pass_time > 0 order by fast_pass_time asc limit 1 ";
                $SysGuildStageArr = SysGuildStage::loadedTable(null, $where);
                foreach ($SysGuildStageArr as $SysGuildStage_)
                {
                    $SysGuildInfo = self::getTbGuildInfo($SysGuildStage_->getGuildId());
                    $Down_GuildFastPass = new Down_GuildFastPass();
                    $Down_GuildFastPass->setId($SysGuildStage_->getGuildId());
                    $Down_GuildFastPass->setIcon($SysGuildInfo->getAvatar());
                    $Down_GuildFastPass->getTime($SysGuildStage_->getFastPassTime());
                    $Down_GuildFastPass->getName($SysGuildInfo->getGuildName());
                    $Down_GuildStageRank->setFastPass($Down_GuildFastPass);
                }
            }
            //获取全服首次击杀
            $where = " stage_id = '{$stageId}' and server_id = '{$serverId}' and is_kill = 1 order by id asc limit 1 ";
            $SysGuildStageBattleHistoryArr = SysGuildStageBattleHistory::loadedTable(null, $where);
            foreach ($SysGuildStageBattleHistoryArr as $SysGuildStageBattleHistory)
            {
                $Down_GuildFirstPass = new Down_GuildFirstPass();
                $Down_GuildFirstPass->setPassTime($SysGuildStageBattleHistory->getBattleTime());
                $where = " and G.user_id = '{$SysGuildStageBattleHistory->getUserId()}'";
                $Down_UserSummaryArr = self::getDown_UserSummary(array($SysGuildStageBattleHistory->getGuildId()),$where);
                if (isset($Down_UserSummaryArr[$SysGuildStageBattleHistory->getGuildId()]))
                {
                    $Down_UserSummary = array_pop($Down_UserSummaryArr[$SysGuildStageBattleHistory->getGuildId()]);
                    $Down_GuildFirstPass->setSummary($Down_UserSummary);
                    $Down_GuildStageRank->setFirstPass($Down_GuildFirstPass);
                }
            }
            //伤害排名前十
            $where = " stage_id = '{$stageId}' and server_id = '{$serverId}' group by user_id limit 10 ";
            $needString = "user_id, guild_id, max(damage) as damage ";
            $SysGuildStageBattleHistoryArray = SysGuildStageBattleHistory::loadedTable($needString, $where);
            $guildArr_ = array();
            $userIdArr_ = array();
            foreach ($SysGuildStageBattleHistoryArray as $SysbGuildStageBattleHistory_)
            {
                $guildArr_[$SysbGuildStageBattleHistory_->getGuildId()] = $SysbGuildStageBattleHistory_->getGuildId();
                $userIdArr_[$SysbGuildStageBattleHistory_->getUserId()] = $SysbGuildStageBattleHistory_->getUserId();
            }

            if (count($userIdArr_) > 0)
            {
                $userIdStr_ = implode(",", $userIdArr_);
                $Down_UserSummaryArr = self::getDown_UserSummary($guildArr_, " and G.user_id in ($userIdStr_) ");
                foreach ($SysGuildStageBattleHistoryArray as $SysGuildStageBattleHistory)
                {
                    if (isset($Down_UserSummaryArr[$SysGuildStageBattleHistory->getGuildId()]) && isset($Down_UserSummaryArr[$SysGuildStageBattleHistory->getGuildId()][$SysGuildStageBattleHistory->getUserId()]))
                    {
                        $Down_DpsRank = new Down_DpsRank();
                        $Down_DpsRank->setDps($SysGuildStageBattleHistory->getDamage());
                        $Down_UserSummary_ = $Down_UserSummaryArr[$SysGuildStageBattleHistory->getGuildId()][$SysGuildStageBattleHistory->getUserId()];
                        $Down_DpsRank->setDpsUser($Down_UserSummary_);
                        $Down_DpsRankArray = new Down_DpsRankArray();
                        //随即显示两个用户的武将?
                        //Down_HeroSummary
                        $Down_GuildStageRank->appendDpsRank($Down_DpsRank);
                    }
                }
            }
        }
        $guildReplyInfo->setGuildStageRank($Down_GuildStageRank);

        return $guildReplyInfo;
    }

    public static function guildQueryMember($userId)
    {
        $guildReplyInfo = new Down_GuildReply();
        $Down_GuildMembers = new Down_GuildMembers();

        $SysPlayerGuildInfo = self::getTbPlayerGuild($userId);
        $myGuildId = $SysPlayerGuildInfo->getGuildId();
        if ($SysPlayerGuildInfo->getGuildId() > 0)
        {
            $guildMemberArray = self::getDown_GuildMember($myGuildId);
            foreach ($guildMemberArray as $guildMember)
            {
                $Down_GuildMembers->appendGuildMember($guildMember);
            }
        }
        $guildReplyInfo->setGuildMembers($Down_GuildMembers);

        return $guildReplyInfo;
    }

    public static function guildSendMail($userId, $GuildSendMail)
    {
        $guildReplyInfo = new Down_GuildReply();
        $guildSendMailInfo = new Down_GuildSendMail();
        
        $mail_title = $GuildSendMail->getTitle();
        $mail_content = $GuildSendMail->getContent();

        $sysPlayer = PlayerModule::getPlayerTable($userId);
        $master_name = $sysPlayer->getNickname();

        $SysPlayerGuildInfo = self::getTbPlayerGuild($userId);
        $SysPlayerGuildInfoArray = new SysPlayerGuild();
        $SysPlayerGuildInfoArray->setGuildId($SysPlayerGuildInfo->getGuildId());
        if($SysPlayerGuildInfoArray->LoadedExistFields())
        {
            foreach($SysPlayerGuildInfoArray as $SysPlayerGuildIdArray)
            {
                $member_Id =  $SysPlayerGuildIdArray->getUserId();
                MailModule::sendPlainMail(
                    $member_Id,
                    $master_name,
                    $mail_title,
                    $mail_content,
                    "",
                    "",
                    "",
                    ""
                );
            }
            $guildSendMailInfo -> setResult(Down_Result::success);
            $guildReplyInfo->setSendMailReply($guildSendMailInfo);
            return $guildReplyInfo;
        }
        return null;
    }

    public static function autoDistributeDrop()
    {
        $everyRound = 500; //每轮处理500个公会
        $beginGuildId = 0; //当前开始公会id

        $mailTitle = "Rewards from Raid Instances";

        while (true)
        {
            $guildArr_ = array();
            $where = " state = 0 and guild_id > '{$beginGuildId}' group by guild_id asc limit {$everyRound} ";
            $SysGuildStageDropArr_ = SysGuildStageDrop::loadedTable('guild_id', $where);
            if (empty($SysGuildStageDropArr_))
            {
                //退出
                break;
            }
            foreach ($SysGuildStageDropArr_ as $SysbGuildStageDrop_)
            {
                $beginGuildId = $SysbGuildStageDrop_->getGuildId();
                $guildArr_[] = $SysbGuildStageDrop_->getGuildId();
            }
            $guildStr = implode(",", $guildArr_);
            //获取公会名称
            $guildNameArr = array();
            $sql = "select id, guild_name from guild_info where id in ($guildStr)";
            $rs = MySQL::getInstance()->RunQuery($sql);
            while ($value = MySQL::getInstance()->FetchAssoc($rs))
            {
                $guildNameArr[$value['id']] = $value['guild_name'];
            }
            $applyUserIdArr = array();
            //获取所有用户的申请信息
            $sql = "select Q.user_id,Q.guild_id,Q.item_id,Q.sort,G.join_time
                    from player_guild_app_queue as Q, player_guild as G
                    where Q.user_id = G.user_id and Q.guild_id in ({$guildStr})
                    order by Q.guild_id asc, Q.sort asc  ";
            $rs = MySQL::getInstance()->RunQuery($sql);
            while ($value = MySQL::getInstance()->FetchAssoc($rs))
            {
                $applyUserIdArr[$value['guild_id']][$value['item_id']][] = $value;
            }

            $dropItemArr = array();
            $distributeIdArr_ = array();
            $getItemUserArr_ = array();
            //获取所有掉落信息
            $sql = "select id,guild_id,item_id,drop_time,raid_id
                    from guild_stage_drop
                    where state = 0 and guild_id in ({$guildStr})
                    order by id desc ";
            $rs = MySQL::getInstance()->RunQuery($sql);
            while ($value = MySQL::getInstance()->FetchAssoc($rs))
            {
                //$dropItemArr[$value['guild_id']][$value['item_id']][] = $value;
                if (isset($applyUserIdArr[$value['guild_id']]) && isset($applyUserIdArr[$value['guild_id']][$value['item_id']]))
                {
                    foreach ($applyUserIdArr[$value['guild_id']][$value['item_id']] as $kk_ => $uArr_)
                    {
                        if ($value['drop_time'] > $uArr_['join_time'])
                        {
                            $distributeIdArr_[] = $value['id'];
                            $getItemUserArr_[$uArr_['user_id']] = $value;
                            unset($applyUserIdArr[$value['guild_id']][$value['item_id']][$kk_]);
                        }
                    }
                }
            }

            //更新物品状态
            if (count($distributeIdArr_) > 0)
            {
                $distributeIdStr_ = implode(",", $distributeIdArr_);
                $sql = "update guild_stage_drop set state = 1 where id in ($distributeIdStr_)";
                $rs = MySQL::getInstance()->RunQuery($sql);
            }

            if (count($getItemUserArr_) > 0)
            {
                $now = time();
                $expireTime = $now + 365 * 3600 * 24;
                $hisSqlArr_ = array();
                $mailSqlArr_ = array();
                foreach ($getItemUserArr_ as $userId_ => $iArr_)
                {
                    $hisSqlArr_[] = "('{$userId_}','{$iArr_['item_id']}','{$now}','{$iArr_['raid_id']}','{$iArr_['guild_id']}')";
                    $guildName_ = "";
                    if(isset($guildNameArr[$iArr_['guild_id']]))
                    {
                        $guildName_ = $guildNameArr[$iArr_['guild_id']];
                    }
                    $mailBody = "Dear Leader,
                                 Here are your rewards of Raid Instances from your Guild $guildName_.
                                 Best Regards";
                    $mailSqlArr_[] = "('{$userId_}','{$mailTitle}','Ember','{$mailBody}', '{$now}','{$expireTime}','{$iArr_['item_id']}:1;')";
                }
                //更新分配历史记录
                $sql = "insert into guild_stage_items_history (user_id,item_id,send_time,raid_id,guild_id) values " . implode(",", $hisSqlArr_);
                $rs = MySQL::getInstance()->RunQuery($sql);
                Logger::getLogger()->debug("autoDistributeDrop his sql: $sql");
                //发放物品分配邮件
                $sql = "insert into player_mail (user_id,title,`from`,content,mail_time,expire_time,items) values " . implode(",", $mailSqlArr_);
                $rs = MySQL::getInstance()->RunQuery($sql);
                //更新用户申请队列
                $uidStr = implode(",", array_keys($getItemUserArr_));
                $sql = "update player_guild_app_queue set item_id = 0 where user_id in ($uidStr)";
                $rs = MySQL::getInstance()->RunQuery($sql);
            }
        }
    }

    /**
     * 获取下一次可以自动分配物品的时间
     *
     * @param bool $isUser
     * @return int
     */
    public static function getCanDistributeTime($isUser = true)
    {
        $now = time();
        $hour = intval(date("H"));
        $minute = intval(date("i"));
        $sec = date("s");

//         //11~24点整点自动分配
//         if ( $minute == 0 && (($hour >= 11 && $hour <= 23) || $hour == 0) )
//         {
//         	return 0;
//         }
//         return 1;

        //测试阶段按照每五分钟自动分配来计算
        if ($mod = $minute % 5 == 0)
        {
            if ($isUser)
            {
                return 5 * 60;
            }
            return 0;
        }
        return $now + (5 - $mod) * 60 + (30 - $sec);
    }
    /****************************************************************************/
    /**
     *
     * 公会日志返回
     * @param $state
     *
     */
	 public static function getguildLog($userId)
   	 {
        $SysPlayerGuildInfo = self::getTbPlayerGuild($userId);
        $SysGuildInfo = self::getTbGuildInfo($SysPlayerGuildInfo->getGuildId());
        $guildId = $SysPlayerGuildInfo->getGuildId();
        $requestGuildLogReply = new Down_RequestGuildLogReply();

       

        $logtime=strtotime('today')-86400*14;

        $sql = "select * from guild_log where guild_id={$guildId} and logtime>={$logtime} order by id desc";
        $rs = MySQL::getInstance()->RunQuery($sql);
                        $values = MySQL::getInstance()->FetchAllRows($rs);

                        if (empty($values) || count($values) == 0)
                        {
                        	$GuildLog = new Down_GuildLog();
                        	$GuildLog->setId(0);
                        	$GuildLog->appendGuildLogContent('暂无公会信息');
                        	$GuildLog->setDate(time());
                        	$requestGuildLogReply->appendGuildLog($GuildLog);
                        }
                        foreach($values as $value)
                        {
	                        	$GuildLog = new Down_GuildLog();
		                        $GuildLog->setId($value['id']);
		
		                        $logArr = json_decode($value['message'],true);
		                        
		                        foreach ($logArr as $val)
		                        {
		                                $Down_GuildLogContent=new Down_GuildLogContent();
		                                $Down_GuildLogContent->setTime($val['times']);
		                                $Down_GuildLogContent->setContent($val['logContent']);
		                                
		                                $GuildLog->appendGuildLogContent($Down_GuildLogContent);
		                        }
	
	                        $GuildLog->setDate($value['logtime']);
	                        $requestGuildLogReply->appendGuildLog($GuildLog);
                        }
       
        return $requestGuildLogReply;

    }


    /*
     * 公会日志格式
     *
     * */
    public static function write_guild_log($field,$type)
    {
    	$message=null;
    	$message['times'] = time();
    	if($type==1)
    	{
    		$userName = PlayerCacheModule::getPlayerName($field['userId']);
    		$message['logContent'] ='会长'.$userName.'创建公会 '.$field['guildName'];
    	}
    	if($type==2)
    	{
    		$userName = PlayerCacheModule::getPlayerName($field['userId']);
    		$message['logContent'] =$userName.' 加入公会';
    	}
    	if($type==3)
    	{
    		$userName = PlayerCacheModule::getPlayerName($field['userId']);
    		$message['logContent'] =$userName.' 退出公会';
    	}
    	if($type==4)
    	{
    		$userName = PlayerCacheModule::getPlayerName($field['userId']);
    		$userNameMember = PlayerCacheModule::getPlayerName($field['memberUid']);
    		$job = PlayerCacheModule::getGuildPosition($field['userId']);
    		$message['logContent'] =$job." ".$userName." 将  ".$userNameMember." 移出公会";
    	}
    	if($type==5)
    	{
    		//todo::报名参加公会战公会日志
    	}
    	if($type==6)
    	{
    		$userName = PlayerCacheModule::getPlayerName($field['userId']);
    		$job = PlayerCacheModule::getGuildPosition($field['userId']);
    		$message['logContent'] =$job.' '.$userName.' 重置了团队副本:第 '.$field['raidId'].' 章';

    	}
    	if($type==7)
    	{
    		$userName = PlayerCacheModule::getPlayerName($field['userId']);
    		$raidId=$field['raidId'];
    		$message['logContent'] ='团队副本 :第'.$raidId.'章通关, 最后一击由 '.$userName.' 完成';
    	}
    	if($type==8)
    	{

    		$userNameHost = PlayerCacheModule::getPlayerName($field['userId']);
    		$userName = PlayerCacheModule::getPlayerName($field['memberUid']);
    		$job = PlayerCacheModule::getGuildPosition($field['userId']);
    		$itemName = $field['itemId'];
    		$message['logContent'] =$job." ".$userNameHost.' 将  #'.$itemName.'# 分配给 '.$$userName;
    	}
    	return $message;

    }

	/*
	 * 记录公会操作日志
	 *
	 * */
    public static function guild_log($guild_id,$message)
    {
    	$logtime=strtotime('today');
    	$sql = "select * from guild_log where guild_id={$guild_id} and logtime={$logtime}";
    	$qr = MySQL::getInstance()->RunQuery($sql);
    	$ar = MySQL::getInstance()->FetchArray($qr);

    	if(!$ar)
    	{
    		$messageArray = array();
    		array_push($messageArray, $message);
    		$messageArrayJson = addslashes(json_encode($messageArray));
    		$sql = "insert into guild_log (`logtime`,`message`,`guild_id`) values ('{$logtime}','{$messageArrayJson}','{$guild_id}')";
    		$rs = MySQL::getInstance()->RunQuery($sql);
    	}
    	else
    	{
    		$messageArray = json_decode($ar['message'],true);
    		array_push($messageArray, $message);
    		$messageArrayJson = addslashes(json_encode($messageArray));
    		$sql = "update guild_log set message = '{$messageArrayJson}' where guild_id={$guild_id} and logtime={$logtime}";
    		$rs = MySQL::getInstance()->RunQuery($sql);

    	}

    }

}

