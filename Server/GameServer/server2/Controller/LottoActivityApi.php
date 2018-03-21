<?php
/* 
 * 大乐透活动
 */
require_once($GLOBALS['GAME_ROOT'] . "Classes/DataModule.php");
require_once($GLOBALS['GAME_ROOT'] . "Classes/PlayerModule.php");
function LottoActivityApi($userId){
        $retrunDownResult = new Down_ActivityLottoInfoReply();
        //获取当前的钻石数
         $tbPlayer = new SysPlayer();
         $tbPlayer->setUserId($userId);
         if($tbPlayer->loaded()){
            $retrunDownResult->setDiamondNum($tbPlayer->getGem());
         }else{
            $retrunDownResult->setDiamondNum(0);
         }
        //活动开始时间
        $activityArr = DataModule::getInstance()->getDataSetting(ACTIVITY_CONFIG_LUA_KEY);
        foreach($activityArr["NearActivity"] as $key=>$val){
            if($val["id"] == 1){
                $star_time = $val["start_time"];
                $during_time = $val["during_time"];
            }
         }
         //活动剩余时间
         $remain_time =(strtotime($star_time)+($during_time*24*3600))-time();
         $retrunDownResult->setRemainTime($remain_time);
         //获取serverId 查看数据库有没有这条数据有查出current_step 没有就插入 current_step =1
         $diamonArray = DataModule::getInstance()->getDataSetting(ACTIVITY_INFO_CONFIG_LUA_KEY);
         $serverId = $tbPlayer->getServerId();
         $sql = "select * from lotto_activity where `server_id` = '{$serverId}' and user_id = '{$userId}' and `star_time` = '{$star_time}'";
         $qr = MySQL::getInstance()->RunQuery($sql);
         $ar = MySQL::getInstance()->FetchAllRows($qr);
         if(empty($ar)){
              $sql = "insert into lotto_activity(`user_id`,`server_id`,`star_time`)
                                          values('{$userId}','{$serverId}','{$star_time}')";
              $qr = MySQL::getInstance()->RunQuery($sql);
              $current_step = 1;                                
         }else{
              //获取消耗钻石和赢取钻石
             $count_step = count($diamonArray["lotto"]);
             if($ar[0]["current_step"]<$count_step){
                 $current_step = $ar[0]["current_step"]+1; 
             }else{
                 $current_step = $count_step;
             }
         }
        foreach($diamonArray["lotto"] as $key=>$val){
            if($key==$current_step){
                $needDiamondNum = $val["need_diamond_num"];
	            $winDiamondNumMin = $val["win_diamond_num_min"];
                $winDiamondNumMax = $val["win_diamond_num_max"];
            }
        }  
        $retrunDownResult->setCurrentStep($current_step);
        $retrunDownResult->setNeedDiamondNum($needDiamondNum);
        $retrunDownResult->setWinDiamondNum($winDiamondNumMin);   
        return $retrunDownResult;   
}

/**
 * 结算
 * @param  [type] $userId [description]
 * @return [type]         [description]
 */
function endLottoActivityApi($userId){
    $LottoRewardReturn = new Down_ActivityLottoRewardReply();
     //获取当前的钻石数
     $tbPlayer = new SysPlayer();
     $tbPlayer->setUserId($userId);
     if($tbPlayer->loaded()){
         $DiamondNum=$tbPlayer->getGem();
     }else{
        $DiamondNum=0;
     }
     //获取当前的层数
    $activityArr = DataModule::getInstance()->getDataSetting(ACTIVITY_CONFIG_LUA_KEY);
    $diamonArray = DataModule::getInstance()->getDataSetting(ACTIVITY_INFO_CONFIG_LUA_KEY);
    foreach($activityArr["NearActivity"] as $key=>$val){
        if($val["id"] == 1){
            $star_time = $val["start_time"];
        }
     }
    $serverId = $tbPlayer->getServerId();
    $sql = "select * from lotto_activity where `server_id` = '{$serverId}' and user_id = '{$userId}' and `star_time` = '{$star_time}'";
    $qr = MySQL::getInstance()->RunQuery($sql);
    $ar = MySQL::getInstance()->FetchAllRows($qr);
    $save_step = $ar[0]["current_step"];
    $count_step = count($diamonArray["lotto"]);
    if($save_step<$count_step){
        $current_step = $save_step+1;
        foreach($diamonArray["lotto"] as $key=>$val){
            if($key==$current_step){
            	$needDiamondNum = $val["need_diamond_num"];
	            $winDiamondNumMin = $val["win_diamond_num_min"];
            	$winDiamondNumMax = $val["win_diamond_num_max"];
            }
        }
	   $winDiamondNum = rand($winDiamondNumMin,$winDiamondNumMax);
        if($DiamondNum>=$needDiamondNum){
            $sql = "update lotto_activity set current_step= current_step+1  where `server_id` = '{$serverId}' and user_id = '{$userId}' and `star_time` = '{$star_time}'";
            //Logger::getLogger()->debug("updateupdate" .$sql);
           if(MySQL::getInstance()->RunQuery($sql)){
               if($current_step<$count_step){
                    PlayerModule::modifyGem($userId, -$needDiamondNum, "LottoReduce:");
                    PlayerModule::modifyGem($userId, $winDiamondNum, "LottoAdd:");
                    $LottoRewardReturn->setRewardDiamonNum($winDiamondNum); //获得的奖励数目
                    $LottoRewardReturn->setDiamondNum($tbPlayer->getGem()); //现有钻石数
                    $LottoRewardReturn->setHaveNextRound(1); //是否有下一次1：有，0：没有
                    $LottoRewardReturn->setStatus(1);//成功
                    $LottoRewardReturn->setNeedDiamondNum($diamonArray["lotto"][$current_step+1]["need_diamond_num"]);
               }else{
                    $LottoRewardReturn->setRewardDiamonNum($winDiamondNum); //获得的奖励数目
                    $LottoRewardReturn->setDiamondNum($tbPlayer->getGem()); //现有钻石数
                    $LottoRewardReturn->setHaveNextRound(0); //是否有下一次1：有，0：没有
                    $LottoRewardReturn->setStatus(1);//成功
                    $LottoRewardReturn->setNeedDiamondNum($diamonArray["lotto"][$count_step]["need_diamond_num"]);
               }
           }else{
                $LottoRewardReturn->setStatus(4);//失败
                $LottoRewardReturn->setNeedDiamondNum(0);//下一次需要的钻石数目
                $LottoRewardReturn->setHaveNextRound(1); //是否有下一次1：有，0：没有
                $LottoRewardReturn->setRewardDiamonNum(0); //获得的奖励数目
                $LottoRewardReturn->setDiamondNum(0); //现有钻石数
           }

        }else{
            $LottoRewardReturn->setStatus(0);//失败
            $LottoRewardReturn->setNeedDiamondNum(0);//下一次需要的钻石数目
            $LottoRewardReturn->setHaveNextRound(0); //是否有下一次1：有，0：没有
            $LottoRewardReturn->setRewardDiamonNum(0); //获得的奖励数目
            $LottoRewardReturn->setDiamondNum($tbPlayer->getGem()); //现有钻石数
        }
    }else{
        $LottoRewardReturn->setHaveNextRound(0); //是否有下一次1：有，0：没有
        $LottoRewardReturn->setStatus(3);
        $LottoRewardReturn->setRewardDiamonNum(0); //获得的奖励数目
        $LottoRewardReturn->setNeedDiamondNum(0);//下一次需要的钻石数目
        $LottoRewardReturn->setDiamondNum($tbPlayer->getGem()); //现有钻石数
     } 
    return $LottoRewardReturn; 
}

?>
