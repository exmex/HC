<?php
/*
 * 充值返利
 */
require_once($GLOBALS['GAME_ROOT'] . "Classes/DataModule.php");
require_once($GLOBALS['GAME_ROOT'] . "DbModule/SysPayInfo.php");
require_once($GLOBALS['GAME_ROOT'] . "Classes/PlayerModule.php");
require_once($GLOBALS['GAME_ROOT'] . "DbModule/SysUserServer.php");

function RechargeRebateApi($ActivityRechargeRebate,$userId){
  //{"values":{"1":2}}
   $type = $ActivityRechargeRebate->getRechargeRebate();
   $RechargeRebateInfo = DataModule::getInstance()->getDataSetting(ACTIVITY_INFO_CONFIG_LUA_KEY);
   foreach($RechargeRebateInfo["RechargeRebate"] as $key=>$val){
      $delay_days = $val["delay_days"];
      $save_day = $val["save_days"];
      $return_days = $val["return_days"];
      $percentage = $val["percentage"];
      $star_time = $val["start_time"];
      $max_values = $val["max_values"];
      $min_values = $val["min_values"];
    }
    //获取用户的注册时间
      $defaultPayInfo = DataModule::getInstance()->getDataSetting(RECHARGE_LUA_KEY);
     $sqlKey = "user_id = '{$userId}'";
     $tbUserInfoList = SysUserServer::loadedTable(array("reg_time"),$sqlKey);
      foreach ($tbUserInfoList as $userInfo){
        $regTime = $userInfo->getRegTime();
      }
      $add_time = strtotime(date("Y-m-d",($regTime+86400)));
      $current_time = time();
      $activity_open_time = $regTime +($delay_days*24*3600);
      $activity_save_time = $add_time +($delay_days*24*3600)+($save_day*24*3600);
      $activity_end_time = $add_time+($delay_days*24*3600)+($save_day*24*3600)+($return_days*24*3600);
      $RechargeRebateDown =  new Down_RechargeRebateReply();
  if($type == 1){
         //如果当前时间戳大于活动储值之间就是返利阶段
         if($current_time>=$activity_save_time && $current_time<=$activity_end_time ){
             //返利阶段
             $RechargeRebateDown->setStatus(2);
             $sqlKey = "buyer_id = '{$userId}' and pay_time < $activity_save_time";
             $tbPayInfoList = SysPayInfo::loadedTable(array("transaction_id"),$sqlKey);
             $gem_count = 0;
             foreach ($tbPayInfoList as $PayInfo){
                 $transactionId= $PayInfo->getTransactionId();
                 $gem_count += $defaultPayInfo[$transactionId]["Basic"];

             }
             if($gem_count>$max_values){
                 $gem_count = $max_values;
                 $today_gem = round($gem_count*$percentage);
             }
             elseif($gem_count<$min_values){
                  $today_gem = 0;
             }else{
                 $today_gem = round($gem_count*$percentage);
             }
             $RechargeRebateDown->setRechargeMoney($today_gem);
             //已领取多少天 //今日是否领取
             $sql = "select * from recharge_rebate_info where user_id = '{$userId}' and `star_time` = '{$star_time}'";
             $qr = MySQL::getInstance()->RunQuery($sql);
             $ar = MySQL::getInstance()->FetchAllRows($qr);
             if(empty($ar)){
                 $sql="insert into  `recharge_rebate_info` (`user_id`,`get_count`,`star_time`) values ('{$userId}','0','{$star_time}')";
                 MySQL::getInstance()->RunQuery($sql);
                 $RechargeRebateDown->setGetDay(0);
                 $RechargeRebateDown->setGetStatus(0);
                 //返利剩余几天
                 $remaind_time = $activity_end_time-$current_time;
                 $RechargeRebateDown->setTime($remaind_time);
             }else{
                  $setGetDay = $ar[0]["get_count"];
                  $RechargeRebateDown->setGetDay($setGetDay);
                  if($setGetDay==0){
                       $RechargeRebateDown->setGetStatus(0);
                       //返利剩余几天
                       $remaind_time = $activity_end_time-$current_time;
                       $RechargeRebateDown->setTime($remaind_time);
                  }else{
                         $last_query_time = date("Y-m-d",strtotime($ar[0]["query_time"]));
                         $today_time = date("Y-m-d",$current_time);
                         if($last_query_time == $today_time){
                             $RechargeRebateDown->setGetStatus(1);
                             //返利剩余几天
                             $remaind_time = $activity_end_time-$current_time;
			                       if($remaind_time<86400){
                                 $RechargeRebateDown->setTime(0);
                             }else{
                                  $RechargeRebateDown->setTime($remaind_time);
                             }
                            
                         }else{
                             $RechargeRebateDown->setGetStatus(0);
                             //返利剩余几天
                             $remaind_time = $activity_end_time-$current_time;
                             $RechargeRebateDown->setTime($remaind_time);
                         }
                  }
             }                        
         }else{
            //储值阶段
             $RechargeRebateDown->setStatus(1);
            //储值值
             $sqlKey = "buyer_id = '{$userId}' and pay_time < $activity_save_time";
             $tbPayInfoList = SysPayInfo::loadedTable(array("transaction_id"),$sqlKey);
             $gem_count = 0;
             foreach ($tbPayInfoList as $PayInfo){
                 $transactionId= $PayInfo->getTransactionId();
                 $gem_count += $defaultPayInfo[$transactionId]["Basic"];
             }
             if(empty($gem_count)){
                $RechargeRebateDown->setRechargeMoney(0);
             }else{
                  $RechargeRebateDown->setRechargeMoney($gem_count);
             }
              //储值倒计时
             $remaind_time = $activity_save_time - $current_time;
             $RechargeRebateDown->setTime($remaind_time);
         }
       return $RechargeRebateDown;
    }else{
        //领取充值返利
	      $RechargeRebateDown->setStatus(2);
        $sql_check = "select * from recharge_rebate_info where user_id = '{$userId}' and `star_time` = '{$star_time}'";
        $qr_check =  MySQL::getInstance()->RunQuery($sql_check);
        $ar_check = MySQL::getInstance()->FetchAllRows($qr_check);
        $last_query_time = date("Y-m-d",strtotime($ar_check[0]["query_time"]));
        $today_time = date("Y-m-d",$current_time);
        if($last_query_time == $today_time){
             $RechargeRebateDown->setGetStatus(1);
             $RechargeRebateDown->setRechargeMoney(0);
        }else{
             $sql="update `recharge_rebate_info` set `get_count` = get_count+1 where `user_id` = '{$userId}' and `star_time` = '{$star_time}'";
             MySQL::getInstance()->RunQuery($sql);
             //领取过后存入到数据表里 然后今日领取状态为0
             $sqlKey = "buyer_id = '{$userId}' and pay_time < $activity_save_time";
             $tbPayInfoList = SysPayInfo::loadedTable(array("transaction_id"),$sqlKey);
             $gem_count = 0;
             foreach ($tbPayInfoList as $PayInfo)             {
                 $transactionId= $PayInfo->getTransactionId();
                 $gem_count += $defaultPayInfo[$transactionId]["Basic"];
             }
             //今日返利钻石
                 if($gem_count>$max_values){
                     $gem_count = $max_values;
                     $today_gem = round($gem_count*$percentage);
                 }elseif($gem_count<$min_values){
                      $today_gem = 0;
                 }else{
                     $today_gem = round($gem_count*$percentage);
                 }
                $RechargeRebateDown->setRechargeMoney($today_gem);
                //用邮件发送
                 PlayerModule::modifyGem($userId, $today_gem, "recharge_rebate_info");
                 $RechargeRebateDown->setGetStatus(1);
        }
	       //设置当前已经领取多少天
	       $sql="select get_count from recharge_rebate_info where user_id = ".$userId;
          $qr = MySQL::getInstance()->RunQuery($sql);
          $ar = MySQL::getInstance()->FetchAllRows($qr);
          $get_count = $ar[0]["get_count"];
	       // $remaind_time = $activity_end_time-(($ar[0]["get_count"]*86400)+$current_time);
          $remaind_time = $activity_end_time-$current_time;
	       $RechargeRebateDown->setGetDay($get_count);
 	  if($remaind_time<86400){
        $RechargeRebateDown->setTime(0);
      }else{
        $RechargeRebateDown->setTime($remaind_time);
      }
      return $RechargeRebateDown;
    }
}

?>
