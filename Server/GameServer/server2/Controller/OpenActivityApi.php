<?php
/*
 *open activity
 */
require_once($GLOBALS['GAME_ROOT'] . "Classes/DataModule.php");
require_once($GLOBALS['GAME_ROOT'] . "DbModule/SysPayInfo.php");
require_once($GLOBALS['GAME_ROOT'] . "Classes/PlayerModule.php");
require_once($GLOBALS['GAME_ROOT'] . "DbModule/SysPlayerVip.php");
require_once($GLOBALS['GAME_ROOT'] . "DbModule/SysUserServer.php");
/**
 * 开启活动
 * @param [type] $userId [description]
 */
function OpenActivityApi($userId){
    $DownNew = new  Down_ActivityInfoReply();
    $activityArr = DataModule::getInstance()->getDataSetting(ACTIVITY_CONFIG_LUA_KEY);
    Logger::getLogger()->debug("OnOpenActivity::activityArr is  ".json_encode($activityArr) );
    foreach($activityArr as $key=>$val){
        $addActivityInfo = new Down_LastActivityInfo();
        $addActivityInfo->setGroupId($key);
        foreach($val as $k=>$v){
            $current_time = time();                    
            if(array_key_exists("show_type",$v)){
                  //从配置挡里获取delay save return days 的天数
                  $RechargeRebateInfo = DataModule::getInstance()->getDataSetting(ACTIVITY_INFO_CONFIG_LUA_KEY);
                  $defaultPayInfo = DataModule::getInstance()->getDataSetting(RECHARGE_LUA_KEY);
                  foreach($RechargeRebateInfo["RechargeRebate"] as $ky=>$vl){
                    $delay_days = $vl["delay_days"];
                    $save_day = $vl["save_days"];
                    $return_days = $vl["return_days"];
                    $max_values = $vl["max_values"];
                    $min_values = $vl["min_values"];
                  }
                  //获取该用户的注册时间
                  $sqlKey = "user_id = '{$userId}'";
                  $tbUserInfoList = SysUserServer::loadedTable(array("reg_time"),$sqlKey);
                  foreach ($tbUserInfoList as $userInfo){
                      $regTime = $userInfo->getRegTime();
                  }
                  $add_time = strtotime(date("Y-m-d",($regTime+86400)));
  			          $activity_open_time = $regTime+($delay_days*24*3600);
  		            $activity_save_time = $add_time+($delay_days*24*3600)+($save_day*24*3600);
  		            $activity_end_time = $add_time+($delay_days*24*3600)+($save_day*24*3600)+($return_days*24*3600);

                  //如果当前时间大于用户注册+加上活动推迟时间显示
                  if($current_time>$activity_open_time && $current_time<$activity_end_time){
                      //看是否是返利阶段
                        if($current_time>$activity_save_time && $current_time<=$activity_end_time ) {
                             $sqlKey = "buyer_id = '{$userId}' and pay_time < $activity_save_time";
                             $tbPayInfoList = SysPayInfo::loadedTable(array("transaction_id"),$sqlKey);
                             $gem_count = 0;
                             foreach ($tbPayInfoList as $PayInfo){
                                   $transactionId= $PayInfo->getTransactionId();
                                   $gem_count += $defaultPayInfo[$transactionId]["Basic"];
                              }

                              if(!empty($gem_count)){
                                  if($gem_count >$min_values ){
                                      $addActivityInfo->appendActivityIds($v["id"]);
                                  }
                                
                              }
                        }else{
                            //else是储值阶段
                            $addActivityInfo->appendActivityIds($v["id"]);
                        }
                    }                        
             }else{
                  //处理不是充值返利的活动 看活动是否开启
                  $activty_time = strtotime($v["start_time"])+( $v["during_time"]*24*3600);
                  if($activty_time>=$current_time){
                      $addActivityInfo->appendActivityIds($v["id"]);
                  }
             }
        }                
      $DownNew->appendLastActivityInfo($addActivityInfo);
    } 
    //Logger::getLogger()->debug("OnOpenActivityendendendendendednd".json_encode($DownNew) );
  return $DownNew;
}

?>
