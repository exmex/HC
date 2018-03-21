<?php
require_once($GLOBALS['GAME_ROOT'] . "Classes/GuildModule.php");

function GuildApi(Up_Guild $postPacketInfo)
{
    $retReplyInfo = null;
    $userId = $GLOBALS['USER_ID'];
    //创建公会
    $createGuildInfo = $postPacketInfo->getCreate();
    if (isset($createGuildInfo))
    {
        $retReplyInfo = GuildModule::createGuildInfo($userId, $createGuildInfo->getName(), $createGuildInfo->getAvatar());
    }
    //解散公会
    $dismissGuildInfo = $postPacketInfo->getDismiss();
    if (isset($dismissGuildInfo))
    {
        $retReplyInfo = GuildModule::dismissGuildInfo($userId);
    }
    //打开公会面板
    $openGuildPanel = $postPacketInfo->getOpenPannel();
    if (isset($openGuildPanel))
    {
        $retReplyInfo = GuildModule::openGuildPanel($userId);
    }
    //查找公会
    $findGuildInfo = $postPacketInfo->getSearch();
    if (isset($findGuildInfo))
    {
        $retReplyInfo = GuildModule::findGuildInfo($userId, $findGuildInfo->getGuildId());
    }
    //加入公会
    $joinInGuild = $postPacketInfo->getJoin();
    if (isset($joinInGuild))
    {
        $retReplyInfo = GuildModule::joinInGuild($userId, $joinInGuild->getGuildId());
    }
    //会长操作是否同意用户
    $isAllowJoinGuild = $postPacketInfo->getJoinConfirm();
    if (isset($isAllowJoinGuild))
    {
        $retReplyInfo = GuildModule::isAllowJoinGuild($userId, $isAllowJoinGuild->getUid(), $isAllowJoinGuild->getType());
    }
    //离开公会
    $leaveGuild = $postPacketInfo->getLeave();
    if (isset($leaveGuild))
    {
        $retReplyInfo = GuildModule::leaveGuild($userId);
    }
    //踢出公会
    $kickGuild = $postPacketInfo->getKick();
    if (isset($kickGuild))
    {
        $retReplyInfo = GuildModule::kickMember($userId, $kickGuild->getUid());
    }
    //设置公会信息
    $settingGuildInfo = $postPacketInfo->getSet();
    if (isset($settingGuildInfo))
    {
        $retReplyInfo = GuildModule::setGuildInfo($userId, $settingGuildInfo);
    }
    //修改成员权限
    $updateMemberPer = $postPacketInfo->getSetJob();
    if (isset($updateMemberPer))
    {
       $retReplyInfo = GuildModule::updateMemberPer($userId, $updateMemberPer->getUid(), $updateMemberPer->getJob());
    }
    //上架雇佣英雄
    $addMercenary = $postPacketInfo->getAddHire();
    if (isset($addMercenary))
    {
        $retReplyInfo = GuildModule::addHire($userId, $addMercenary->getHeroid());
    }
    //下架雇佣英雄
    $delMercenary = $postPacketInfo->getDelHire();
    if (isset($delMercenary))
    {
        $retReplyInfo = GuildModule::delHire($userId, $delMercenary->getHeroid());
    }
    //查询公会用的雇佣英雄
    $queryHires = $postPacketInfo->getQueryHires();
    if (isset($queryHires))
    {
        $retReplyInfo = GuildModule::queryHires($userId, $queryHires->getFrom());
    }
    //雇佣别人的英雄
    $hireHero = $postPacketInfo->getHireHero();
    if (isset($hireHero))
    {
        $retReplyInfo = GuildModule::hireHero($userId, $hireHero->getUid(), $hireHero->getHeroid(), $hireHero->getFrom());
    }
    //膜拜英雄
    $worshipReq = $postPacketInfo->getWorshipReq();
    if (isset($worshipReq))
    {
        $retReply = GuildModule::worshipReq($userId, $worshipReq->getUid(), $worshipReq->getId());
    }
    //领膜拜奖励
    $worshipWithdraw = $postPacketInfo->getWorshipWithdraw();
    if (isset($worshipWithdraw))
    {
        $retReply = GuildModule::worshipWithdraw($userId);
    }
    //雇佣英雄详情查询
    $hireMercenaryInfo = $postPacketInfo->getQueryHhDetail();
    if (isset($hireMercenaryInfo))
    {
        $retReplyInfo = GuildModule::queryHhDetail($userId, $hireMercenaryInfo->getUid(), $hireMercenaryInfo->getHeroid());
    }
    //查询公会副本简要信息
    $findGuildBriefInfo = $postPacketInfo->getInstanceQuery();
    if (isset($findGuildBriefInfo))
    {
        $retReplyInfo = GuildModule::findGuildBriefInfo($userId);
    }
    //查询公会副本详细信息
    $findGuildDetailInfo = $postPacketInfo->getInstanceDetail();
    if (isset($findGuildDetailInfo))
    {
        $retReplyInfo = GuildModule::findGuildDetailInfo($userId, $findGuildDetailInfo->getStageId());
    }
    //公会副本战斗
    $InstanceStart = $postPacketInfo->getInstanceStart();
    if (isset($InstanceStart))
    {
        $retReplyInfo = GuildModule::instanceStart($userId, $InstanceStart->getStageId());
    }
    //结束副本战斗
    $InstanceEnd = $postPacketInfo->getInstanceEnd();
    if (isset($InstanceEnd))
    {
        $retReplyInfo = GuildModule::instanceEnd($userId, $InstanceEnd);
    }
    //尝试进入关卡
    $InstancePrepare = $postPacketInfo->getInstancePrepare();
    if (isset($InstancePrepare))
    {
        $retReplyInfo = GuildModule::instancePrepare($userId, $InstancePrepare->getStageId());
    }
    //去公会副本
    $InstanceOpen = $postPacketInfo->getInstanceOpen();
    if (isset($InstanceOpen))
    {
        $retReplyInfo = GuildModule::instanceOpen($userId, $InstanceOpen->getRaidId());
    }
    //申请副本掉落  获取当前副本的掉落情况和申请(所有人)
    $InstanceDrop = $postPacketInfo->getInstanceDrop();
    if (isset($InstanceDrop))
    {
        $retReplyInfo = GuildModule::instanceDrop($userId, $InstanceDrop->getRaidId());
    }
    //申请副本掉落
    $InstanceApply = $postPacketInfo->getInstanceApply();
    if (isset($InstanceApply))
    {
        $retReplyInfo = GuildModule::instanceApply($userId, $InstanceApply->getRaidId(), $InstanceApply->getItemId());
    }
    //请求分配物品信息
    $DropInfo = $postPacketInfo->getDropInfo();
    if (isset($DropInfo))
    {
        $retReplyInfo = GuildModule::dropInfo($userId);
    }
    //分物品
    $DropGive = $postPacketInfo->getDropGive();
    if (isset($DropGive))
    {
        $retReplyInfo = GuildModule::dropGive($userId, $DropGive);
    }
    //输出统计 单次最高伤害排名
    $InstanceDamage = $postPacketInfo->getInstanceDamage();
    if (isset($InstanceDamage))
    {
        $retReplyInfo = GuildModule::instanceDamage($userId, $InstanceDamage->getRaidId());
    }
    //物品分配纪录
    $ItemsHistory = $postPacketInfo->getItemsHistory();
    if (isset($ItemsHistory))
    {
        $retReplyInfo = GuildModule::itemsHistory($userId);
    }
    //插队
    $GuildJump = $postPacketInfo->getGuildJump();
    if (isset($GuildJump))
    {
        $retReplyInfo = GuildModule::guildJump($userId);
    }
    //请求申请队列
    $GuildAppQueue = $postPacketInfo->getGuildAppQueue();
    if (isset($GuildAppQueue))
    {
        $retReplyInfo = GuildModule::guildAppQueue($userId, $GuildAppQueue->getItemId());
    }
    //公会副本排行榜
    $GuildStageRank = $postPacketInfo->getGuildStageRank();
    if (isset($GuildStageRank))
    {
        $retReplyInfo = GuildModule::guildStageRank($userId, $GuildStageRank->getStageId());
    }
    //公会成员列表
    $GuildQueryMember = $postPacketInfo->getGuildQueryMember();
    if (isset($GuildQueryMember))
    {
        $retReplyInfo = GuildModule::guildQueryMember($userId);
    }
    //公会全员邮件
    $GuildSendMail = $postPacketInfo->getGuildSendMail();
    if (isset($GuildSendMail))
    {
        $retReplyInfo = GuildModule::guildSendMail($userId);
    }

    if ($retReplyInfo)
    {
        $retReplyInfo->setResult(Down_Result::success);
    }

    return $retReplyInfo;
}

function GuildLogApi(Up_RequestGuildLog $pack)
{
	$retReplyInfo = null;
	$userId = $GLOBALS['USER_ID'];
	//公会成员列表
	$GuildLogStatus = $pack->getLogStatus();
	if (isset($GuildLogStatus))
	{
		$retReplyInfo = GuildModule::getguildLog($userId);
	}
	return $retReplyInfo;
}