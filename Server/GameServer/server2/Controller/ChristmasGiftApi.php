<?php
/* 
 * 圣诞活动大礼包
 */
require_once($GLOBALS['GAME_ROOT'] . "Classes/FacebookFollowModule.php");
require_once($GLOBALS['GAME_ROOT'] . "DbModule/SysPlayerMail.php");
require_once($GLOBALS['GAME_ROOT'] . "Classes/MailModule.php");

function ChristmasApi($userId){
   $DownNew  =  new Down_ActivityBigpackageInfoReply();
   $ContinueRecharge = DataModule::lookupDataTable(ACTIVITY_CONFIG_LUA_KEY,  "ChristmasActivity");
   $Resetcharge = DataModule::lookupDataTable(ACTIVITY_INFO_CONFIG_LUA_KEY, "ChristmasGiftReset");
  	$newDate=date('Y-m-d');
 
    $sql_insert="select id from activity_log where user_id=".$userId." and version='".$ContinueRecharge[1]['start_time']."'";
    $res_insert=MySQL::getInstance()->RunQuery($sql_insert);
    $res_insert=MySQL::getInstance()->FetchArray($res_insert);
    if(!$res_insert){
       $sql_insert="insert into activity_log (`user_id`, `activity_score`, `amount`, `buynum`, `datetime`, `server_id`, `last_buy_time`, `redward_status`, `version`, `gift_id`) values(".$userId.",0,3,1,'".date('Y-m-d')."',".$GLOBALS['SERVERID'].",'".date('Y-m-d H:i:s')."',0,'".$ContinueRecharge[1]['start_time']."',0);";
       $sql_insert=MySQL::getInstance()->RunQuery($sql_insert);
    }
  	$sql = "select `activity_score`,`amount`,`buynum`,`gift_id`,`redward_status` from activity_log where user_id = ".$userId." and datetime='".$newDate."' and version='".$ContinueRecharge[1]['start_time']."'";
  	$rs = MySQL::getInstance()->RunQuery($sql);
  	$ar = MySQL::getInstance()->FetchArray($rs);

    if($ar){
          $sql_rank="select count(*) +1 as rank from activity_log where  activity_score >{$ar['activity_score']} and version= '".$ContinueRecharge[1]['start_time']."';";
          $rank_res=MySQL::getInstance()->RunQuery($sql_rank);
          $rank_res=MySQL::getInstance()->FetchArray($rank_res);
          $nextPrice=isset($Resetcharge[$ar['buynum']])?$Resetcharge[$ar['buynum']]:$Resetcharge['common'];
          $sql_distance_con="select activity_score from activity_log where version='".$ContinueRecharge[1]['start_time']."' order by activity_score desc limit ".$ContinueRecharge[1]['big_reward_rank'].",1";//$ContinueRecharge[1]['big_reward_rank']
  
          $res_distance_con=MySQL::getInstance()->RunQuery($sql_distance_con);
          $res_distance_con=MySQL::getInstance()->FetchArray($res_distance_con);
          if($res_distance_con && $res_distance_con['activity_score']<=$ar['activity_score'] || empty($res_distance_con)){
            $sql_distance_con="select activity_score from activity_log where version='".$ContinueRecharge[1]['start_time']."' order by activity_score desc limit 1";//
            $res_distance_con=MySQL::getInstance()->RunQuery($sql_distance_con);
            $res_distance_con=MySQL::getInstance()->FetchArray($res_distance_con);
            $distance_score=$res_distance_con['activity_score']-$ar['activity_score'];

          }else if(($res_distance_con && $res_distance_con['activity_score']>=$ar['activity_score']) ){
            //$sql_distance_con="select activity_score from activity_log order by activity_score desc limit 1";//
            $distance_score=$res_distance_con['activity_score']-$ar['activity_score'];

          }
          $gift_id=explode(',', $ar['gift_id']);
          $DownNew->setPeopleCount($ar['activity_score']);
          $DownNew->setNextResetPrice($nextPrice);//下次重置消耗
          $DownNew->setRemainTimes($ar['amount']);
          $DownNew->setCurrentRanking($rank_res['rank']);
          $DownNew->setDistanceScore20($distance_score);
          if(($gift_id[0]!=0 && count($gift_id)>1)){
            foreach($gift_id as $val){
              $DownNew->appendGetBoxIds($val);
            }
          }

    }else{
        $sql_up_day="select `activity_score`,`amount`,`gift_id`,`buynum`,`redward_status` from activity_log where datetime = '".date('Y-m-d')."' and user_id=".$userId." and version= '".$ContinueRecharge[1]['start_time']."';";
        $sql_up_res=MySQL::getInstance()->RunQuery($sql_up_day);
        $sql_up_res=MySQL::getInstance()->FetchArray($sql_up_res);
        if(!$sql_up_res){
            $sql="update activity_log set `datetime`='".date('Y-m-d')."',`buynum`=0,`amount`=3,`gift_id`=0 where user_id={$userId} and version= '".$ContinueRecharge[1]['start_time']."';";
            $result=MySQL::getInstance()->RunQuery($sql);
            $sql_sel="select activity_score from activity_log where user_id={$userId} and version= '".$ContinueRecharge[1]['start_time']."'; ";
            $result=MySQL::getInstance()->RunQuery($result);
            $result=MySQL::getInstance()->FetchArray($result);
            $sql_rank="select count(*) +1 as rank from activity_log where  activity_score >{$result['activity_score']} and version= '".$ContinueRecharge[1]['start_time']."';";
            $sql_select ="select `activity_score`,`amount`,`gift_id`,`buynum`,`redward_status` from activity_log where user_id = ".$userId." and datetime='".$newDate."' and version= '".$ContinueRecharge[1]['start_time']."'; ";
            $res_select = MySQL::getInstance()->RunQuery($sql_select);
            $res_select = MySQL::getInstance()->FetchArray($res_select);
            //Logger::getLogger()->debug(" OnChristmas xxxxxCCCCCCCCCCCCCCCCCCCCDDDDDDDDDDDDDDDDDD" .$sql_select);
            $rank_res=MySQL::getInstance()->RunQuery($sql_rank);
            $rank_res=MySQL::getInstance()->FetchArray($rank_res);
            //$gift_id=substr($res_select['gift_id'], 0,strlen($res_select['gift_id']));
            $gift_id=explode(',', $res_select['gift_id']);
            $nextPrice=isset($Resetcharge[$res_select['buynum']])?$Resetcharge[$res_select['buynum']]:$Resetcharge['common'];
            $sql_distance_con="select activity_score from activity_log where version='".$ContinueRecharge[1]['start_time']."' order by activity_score desc limit ".$ContinueRecharge[1]['big_reward_rank'].",1";//$ContinueRecharge[1]['big_reward_rank']
            $res_distance_con=MySQL::getInstance()->RunQuery($sql_distance_con);
            $res_distance_con=MySQL::getInstance()->FetchArray($res_distance_con);
            if(($res_distance_con && $res_distance_con['activity_score']<=$rank_res['activity_score']) || empty($res_distance_con)){
              $sql_distance_con="select activity_score from activity_log  where version='".$ContinueRecharge[1]['start_time']."' order  by activity_score desc limit 1";//$ContinueRecharge[1]['big_reward_rank']
              $res_distance_con=MySQL::getInstance()->RunQuery($sql_distance_con);
              $res_distance_con=MySQL::getInstance()->FetchArray($res_distance_con);
              $distance_score=$res_distance_con['activity_score']-$rank_res['activity_score'];
              //$distance_score=$rank_res['activity_score']-$res_distance_con['activity_score'];
            }else if($res_distance_con && $res_distance_con['activity_score']>=$rank_res['activity_score']){
              $distance_score=$res_distance_con['activity_score']-$rank_res['activity_score'];
            }
            $DownNew->setPeopleCount($res_select['activity_score']);
            $DownNew->setNextResetPrice($nextPrice);
            $DownNew->setRemainTimes($res_select['amount']);
            $DownNew->setCurrentRanking($rank_res['rank']);
            $DownNew->setDistanceScore20($distance_score);
            if(($gift_id[0]!=0 && count($gift_id)>1)){
              foreach($gift_id as $val){
                $DownNew->appendGetBoxIds($val);
              }
            }
        }else{
          $DownNew->setPeopleCount($sql_up_res['activity_score']);
          $nextPrice=isset($Resetcharge[$sql_up_res['buynum']])?$Resetcharge[$sql_up_res['buynum']]:$Resetcharge['common'];
          $DownNew->setNextResetPrice($nextPrice);
          $DownNew->setRemainTimes($sql_up_res['amount']);
          $DownNew->setCurrentRanking(0);
          $DownNew->setDistanceScore20(11);
          $gift_id=array(1);
          foreach($gift_id as $val){
            $DownNew->appendGetBoxIds($val);
          }
        }
    }
    return $DownNew;
 
}

 /**
  * 对活动奖励
  * @param int $amount 购买次数
  * @param int $upnew 
  */
function ChristmasRewardInfoApi(WorldSvc $svc, Up_ActivityBigpackageRewardInfo $pPacket,$userId){
   $DownNew  =  new Down_ActivityBigpackageRewardReply();
   $boxid=$pPacket->getBoxId(); 
   $ContinueRecharge = DataModule::lookupDataTable(ACTIVITY_CONFIG_LUA_KEY, "ChristmasActivity");
   $rand_gift=DataModule::lookupDataTable(ACTIVITY_INFO_CONFIG_LUA_KEY,  "ChristmasGift");
  $newDate=date('Y-m-d');
  $sql_read = "select `amount`,`buynum`,`gift_id`,`activity_score` from activity_log where user_id = ".$userId." and datetime='".$newDate."' and version='".$ContinueRecharge[1]['start_time']."';";
  $read_result=MySQL::getInstance()->RunQuery($sql_read);
  $read_result=MySQL::getInstance()->FetchArray($read_result);
  // 查当前分数差距20名
  $sql_distance_con="select activity_score from activity_log where version='".$ContinueRecharge[1]['start_time']."' order by activity_score desc limit ".$ContinueRecharge[1]['big_reward_rank'].",1";//
  $res_distance_con=MySQL::getInstance()->RunQuery($sql_distance_con);
  $res_distance_con=MySQL::getInstance()->FetchArray($res_distance_con);
  if(($res_distance_con && $res_distance_con['activity_score']<=$read_result['activity_score']) || empty($res_distance_con)){
    $sql_distance_con="select activity_score from activity_log where version='".$ContinueRecharge[1]['start_time']."' order by activity_score desc limit 1";//
    Logger::getLogger()->debug(" =====================" .$sql_distance_con);
    $res_distance_con=MySQL::getInstance()->RunQuery($sql_distance_con);
    $res_distance_con=MySQL::getInstance()->FetchArray($res_distance_con);
    $distance_score=$res_distance_con['activity_score']-$read_result['activity_score'];
  }else if($res_distance_con && $res_distance_con['activity_score']>=$read_result['activity_score']){
    $distance_score=$res_distance_con['activity_score']-$read_result['activity_score'];
  }
  $sql_rank="select count(*) +1 as rank from activity_log where  activity_score >{$read_result['activity_score']} and version= '".$ContinueRecharge[1]['start_time']."';";
  $rank_res=MySQL::getInstance()->RunQuery($sql_rank);
  $rank_res=MySQL::getInstance()->FetchArray($rank_res);
  if($read_result['amount']<=0){
    $DownNew->setStatus(0);
    $DownNew->setPeopleCount($read_result['activity_score']);
    $DownNew->setDistanceScore20($distance_score);// 
    $DownNew->setCurrentRanking($rank_res['rank']);
    return $DownNew;
  }
  $boxid=$boxid.','.$read_result['gift_id'];
  $sql = "update activity_log set `amount`=amount-1,`gift_id`='$boxid' where user_id = ".$userId." and datetime='".$newDate."' and version='".$ContinueRecharge[1]['start_time']."';";
  if(!MySQL::getInstance()->RunQuery($sql)){
    $DownNew->setStatus(0);
    $DownNew->setPeopleCount($read_result['activity_score']);
    $DownNew->setCurrentRanking($rank_res['rank']);
    $DownNew->setDistanceScore20($distance_score);
    return $DownNew;
  }
  if(!$read_result || $read_result['amount']<=0){
    $DownNew->setStatus(0);
    $DownNew->setPeopleCount($read_result['activity_score']);
    $DownNew->setCurrentRanking($rank_res['rank']);
    $DownNew->setDistanceScore20($distance_score);
     return $DownNew;
  }else{
    $randNum = rand(2,5);
    for($i=0;$i<$randNum;$i++)
    {
	   $rewards=new Down_ActivityReward();
      $weight = 0; 
      $tempdata = array(); 
      foreach ($rand_gift as $val) {
        $weight += $val['Reward Weight'];
        for ($s = 0; $s < $val['Reward Weight'];$s++) {
          $tempdata[] = $val;
        }
      }
      $use = rand(0, $weight - 1); 
      $one = $tempdata[$use];
      $unItem = array_search($one, $rand_gift);
      unset($rand_gift[$unItem]);        
      $rewards->setId($one['Reward ID']);
      $rewards->setAmount($one['Reward Amount']);
      $rewards->setType($one['Reward TypeStatus']);
      $DownNew->appendRewards($rewards);
      $DownNew->appendItemIds($one['Reward ID']);
      if($one['Reward TypeStatus']==2){ // 是金币就写到金币表中
        PlayerModule::modifyMoney($userId,$one['Reward Amount'],'add_money_amount_log'.date('Y-m-d'));
      }
      if($one['Reward TypeStatus']!=2){
        ItemModule::addItem($userId, array($one['Reward ID'] => $one['Reward Amount'],), "DailyLogin-" . date('Y-m-d'));
      }
     
    }
     $sql_score = "update activity_log set `activity_score`=activity_score+100 where user_id = ".$userId." and datetime='".$newDate."' and version='".$ContinueRecharge[1]['start_time']."';";
     $res_score=MySQL::getInstance()->RunQuery($sql_score);
     if($res_score){
        $_sql_score="select activity_score from activity_log where user_id = ".$userId." and datetime='".$newDate."' and version='".$ContinueRecharge[1]['start_time']."';";
        $_score=MySQL::getInstance()->RunQuery($_sql_score);
        $_score=MySQL::getInstance()->FetchArray($_score);
        $sql_rank="select count(*) +1 as rank from activity_log where  activity_score >{$_score['activity_score']} and version= '".$ContinueRecharge[1]['start_time']."';";
        $rank_res=MySQL::getInstance()->RunQuery($sql_rank);
        $rank_res=MySQL::getInstance()->FetchArray($rank_res);
        // 查当前分数差距20名
        $sql_distance_con="select activity_score from activity_log where version='".$ContinueRecharge[1]['start_time']."' order by activity_score desc limit ".$ContinueRecharge[1]['big_reward_rank'].",1";//
        $res_distance_con=MySQL::getInstance()->RunQuery($sql_distance_con);
        $res_distance_con=MySQL::getInstance()->FetchArray($res_distance_con);
        if(($res_distance_con && $res_distance_con['activity_score']<=$_score['activity_score']) || empty($res_distance_con)){
          $sql_distance_con="select activity_score from activity_log where version='".$ContinueRecharge[1]['start_time']."' order by activity_score desc limit 1";//
          $res_distance_con=MySQL::getInstance()->RunQuery($sql_distance_con);
          $res_distance_con=MySQL::getInstance()->FetchArray($res_distance_con);
          $distance_score=$res_distance_con['activity_score']-$_score['activity_score'];
        }else if($res_distance_con && $res_distance_con['activity_score']>=$_score['activity_score']){
          $distance_score=$res_distance_con['activity_score']-$_score['activity_score'];
        }
        $DownNew->setPeopleCount($_score['activity_score']);
        $DownNew->setDistanceScore20($distance_score);
        $DownNew->setCurrentRanking($rank_res['rank']);
     }else{
        $DownNew->setPeopleCount(0);
        $DownNew->setCurrentRanking(1111111);
        $DownNew->setDistanceScore20($distance_score);
     }
  }
  $DownNew->setStatus(1);
  return $DownNew;
}

/* 
 * 圣诞活动重置
 */
function ChristmasActivityResetApi($userId){  
   $DownNew  =  new Down_ActivityBigpackageResetReply();
   $ContinueRecharge = DataModule::lookupDataTable(ACTIVITY_CONFIG_LUA_KEY, "ChristmasActivity");
   $tbPlayer = new SysPlayer();
    $startTime = strtotime($ContinueRecharge[1]['start_time']);
    $startDate = date("Y-m-d",$startTime);
    $newDate=date('Y-m-d');
    $tbPlayer->setUserId($userId);
    $tbPlayer->load(array('gem'));
    $gem=$tbPlayer->getGem();
    $sql = "select * from activity_log where user_id = ".$userId." and datetime='".$newDate."' and version='".$ContinueRecharge[1]['start_time']."'";
    $res = MySQL::getInstance()->RunQuery($sql);
    $res = MySQL::getInstance()->FetchArray($res);
    if($res['buynum']>=50){
       $DownNew->setStatus(2);
       $DownNew->setNextResetPrice(0);
       return $DownNew;
    }
    $reset_gem=DataModule::lookupDataTable(ACTIVITY_INFO_CONFIG_LUA_KEY,  "ChristmasGiftReset");
    if($gem<$reset_gem[$res['buynum']]){
       $DownNew->setStatus(0);
       $DownNew->setNextResetPrice(0);
       return $DownNew;
    }
    if(isset($reset_gem[$res['buynum']])){
      //需要消耗钻石数 $reset_gm[$res[0]['buynum']];
      $_gem=$gem-$reset_gem[$res['buynum']]; 
      $nextPrice=isset($reset_gem[$res['buynum']])?$reset_gem[$res['buynum']]:$reset_gem['common'];
      $DownNew->setNextResetPrice($nextPrice);
      $tbPlayer->setGem($_gem);
      PlayerModule::modifyGem($userId, -intval($reset_gem[$res['buynum']]), "reset_zuanshi_info_xxxxxxxxxx");
      $sql_up="update activity_log set `buynum`=buynum+1,`amount`=3 ,`gift_id`=0 where user_id={$userId} and datetime='{$newDate}' and version='".$ContinueRecharge[1]['start_time']."'; ";
      $res=MySQL::getInstance()->RunQuery($sql_up);
      $DownNew->setStatus(1);
      $DownNew->setNextResetPrice($nextPrice);
    }else{
      $_gem=$gem-$reset_gem['common'];
      $tbPlayer->setGem($_gem);
      PlayerModule::modifyGem($userId, -intval($reset_gem['common']), "reset_zuanshi_info_commn");
      $sql_up="update activity_log set `buynum`=buynum+1,`amount`=3,`gift_id`=0 where user_id={$userId} and datetime='{$newDate}' and version='".$ContinueRecharge[1]['start_time']."'; ";
      $res=MySQL::getInstance()->RunQuery($sql_up);
      if($res){
          $DownNew->setStatus(1);
          $DownNew->setNextResetPrice($reset_gem['common']);
      }else{
        $DownNew->setStatus(0);
        $DownNew->setNextResetPrice($reset_gem['common']);
      }
    }
    if($gem<=0){
      $DownNew->setStatus(0);
      $DownNew->setNextResetPrice(0);
    }

    return $DownNew;
}
?>
