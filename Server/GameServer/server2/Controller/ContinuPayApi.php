<?php
/* 
 * 每日充值活动
 */
require_once($GLOBALS['GAME_ROOT'] . "Classes/FacebookFollowModule.php");
require_once($GLOBALS['GAME_ROOT'] . "DbModule/SysPlayerMail.php");
require_once($GLOBALS['GAME_ROOT'] . "Classes/MailModule.php");
function ContinuPayApi($userId){
   $DownNew  =  new Down_ContinuePayReply();
   $ContinueRecharge = DataModule::lookupDataTable(ACTIVITY_CONFIG_LUA_KEY, "OpenServerActivity");
   $AllTime = strtotime($ContinueRecharge[2]['start_time']) + 3600*24*$ContinueRecharge[2]['during_time'];
   $endTime = $AllTime - time();
   $DownNew->setTime($endTime);
   $dates= date("Ymd");
  for($i=0;$i<$ContinueRecharge[2]['during_time'];$i++){	
  	$startTime = strtotime($ContinueRecharge[2]['start_time']);
  	$startDate = date("Y-m-d",$startTime);
  	$newDate=date('Ymd',strtotime("$startDate + $i day"));
  	$sql = "select * from continu_pay where user_id = ".$userId." and date=".$newDate;
  	$rs = MySQL::getInstance()->RunQuery($sql);
  	$ar = MySQL::getInstance()->FetchArray($rs);
  	if($newDate<$dates){  
       if (!$ar || count($ar)==0) {
       	$DownNew->appendStatus(2);
       }else {
       	$DownNew->appendStatus(1);
       }
  	}else if($newDate == $dates){
  		if (!$ar || count($ar)==0) {
  			$DownNew->appendStatus(4);
  		}else{
  			$DownNew->appendStatus(1);
  		}
  	}else if($newDate > $dates){
  			$DownNew->appendStatus(3);
  	}
  }
  return $DownNew;
}
?>