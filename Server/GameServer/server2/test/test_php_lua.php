<?php
/**
 * User: zhangliang
 * Date: 14-5-16
 * Time: 上午9:36
 */
require_once "../config.php";

// not require this file in runtime code
//require_once("../protobuf/stubs/ProtobufMessage.php");
//require_once("../manager/DataManager.php");

require_once("../reflector/OnSetName.php");
require_once("../reflector/OnBuySkillStrenPoint.php");
require_once("../reflector/OnSdkLogin.php");
require_once("../manager/HeroManager.php");

$_SERVER ['FASTCGI_PLAYER_SERVER'] = 9999;

HeroModule::getHeroGs(7,1);
 NotifyModule::addNotify(33,NOTIFY_TYPE_LADDER);
//$heroArr =NotifyModule::getAllNotifyDownInfo(7);
//NotifyModule::clearNotify(7,NOTIFY_TYPE_LADDER);

//$setNameReply = OnRequireTaskRewards(7,21,1);
//$setNameReply = OnJobRewards(7,32);
//rewardTast(7, 30, 1);
//TaskModule::triggerFarmStageTask(7, 7);


print("end");
