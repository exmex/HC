<?php
/* 
 * 圣诞天天乐
 */
require_once($GLOBALS['GAME_ROOT'] . "DbModule/SysPlayerItems.php");

function  HappyEveryDayApi($ActivityHappyEveryDay,$userId)
{
     $goldCardId = 471;
     $silverCardId = 472;
     $copperCardId = 473;

    //先获取总体协议的num 1代表开启天天乐界面2代表领取
    $type = $ActivityHappyEveryDay->getEveryDayHappy();
    //Logger::getLogger()->error(" OnHappyEveryDay type is ".$type);
    $HappyEveryDayItem = new Down_EveryDayHappyReply();
    if($type==2)
    {       
        //物品是否足够
        $needItemArr = array(471=>1);
        $itemState = ItemModule::checkAllItemsExist($userId, $needItemArr);
        if ($itemState == false)
       {
         //   Logger::getLogger()->error("open GoldCard need " . print_r($needItemArr, true) . "," . __LINE__);
            $HappyEveryDayItem->setStatus(1);
            $HappyEveryDayItem->setGoldcardNumber(0);
            //返回银卡的数量
             $sqlKeySilver = "user_id = '{$userId}' and item_id = '{$silverCardId}'";
             $tbPlayerItemListSilver = SysPlayerItems::loadedTable(array('count'),$sqlKeySilver);
             if(empty($tbPlayerItemListSilver))
             {
                 $HappyEveryDayItem->setSilvercardNumber(0);
             }
             else
             {
                 $HappyEveryDayItem->setSilvercardNumber($tbPlayerItemListSilver[0]->getCount());
             }
            //返回铜卡的数量
            $sqlKeyCopper = "user_id = '{$userId}' and item_id = '{$copperCardId}'";
            $tbPlayerItemListCopper = SysPlayerItems::loadedTable(array('count'),$sqlKeyCopper);
            if(empty($tbPlayerItemListCopper))
            {
                $HappyEveryDayItem->setCoppercardNumber(0);
            }
            else
            {
                $HappyEveryDayItem->setCoppercardNumber($tbPlayerItemListCopper[0]->getCount());
            }
            
            //返回获取道具的id和num
            return $HappyEveryDayItem;
        }        
        $reduceReason = "HappayEveryDay Reward Reduce Gold Card";
       // Logger::getLogger()->error("open SilverCard needdddddd " . print_r($needItemArr, true) . "," . __LINE__);
        $itemSubstate = ItemModule::subItem($userId, $needItemArr,$reduceReason);
        if($itemSubstate==false)
        {
            //返回金卡的数量
                $sqlKeyGold = "user_id = '{$userId}' and item_id = '{$goldCardId}'";
                $tbPlayerItemListGold = SysPlayerItems::loadedTable(array('count'),$sqlKeyGold);
                if(empty($tbPlayerItemListGold))
                {
                    $HappyEveryDayItem->setGoldcardNumber(0);
                }
                else
                {
                    $HappyEveryDayItem->setGoldcardNumber($tbPlayerItemListGold[0]->getCount());
                }
                //返回银卡的数量
                $sqlKeySilver = "user_id = '{$userId}' and item_id = '{$silverCardId}'";
                $tbPlayerItemListSilver = SysPlayerItems::loadedTable(array('count'),$sqlKeySilver);
                if(empty($tbPlayerItemListSilver))
                 {
                     $HappyEveryDayItem->setSilvercardNumber(0);
                 }
                 else
                 {
                     $HappyEveryDayItem->setSilvercardNumber($tbPlayerItemListSilver[0]->getCount());
                 }
                //返回铜卡的数量
                $sqlKeyCopper = "user_id = '{$userId}' and item_id = '{$copperCardId}'";
                $tbPlayerItemListCopper = SysPlayerItems::loadedTable(array('count'),$sqlKeyCopper);
                if(empty($tbPlayerItemListCopper))
                {
                    $HappyEveryDayItem->setCoppercardNumber(0);
                }
                else
                {
                    $HappyEveryDayItem->setCoppercardNumber($tbPlayerItemListCopper[0]->getCount());
                }
                //返回获取道具的id和num
          //      Logger::getLogger()->debug("open silverCard get".json_encode($addItemArr));
                $HappyEveryDayItem->setStatus(1);
                return $HappyEveryDayItem;

        }

        //读金卡的lua文件 算出用户获取的的道具的id
        $times = rand(3,6);
        //Logger::getLogger()->debug("open goldCard wegithweigt". $times);
        $christmasRwards = DataModule::getInstance()->getDataSetting(ACTIVITY_CHRISTMAS_REWARDS_INFO);
        $data = $christmasRwards["gold"];
        for($j=0;$j<$times;++$j)
        {
            $weight = 0; $tempdata = array();
            foreach ($data as $one)
            {
                    $weight += $one['Reward Weight'];
                    for ($i = 0; $i < $one['Reward Weight']; ++$i)
                    {
                            $tempdata[] = $one;
                    }
            }
            $use = rand(0, $weight - 1);
            $one = $tempdata[$use];
            $a = array_search($one,$data);
            unset($data[$a]);
            $temptestData[] = $one;
        }

        
        $addItemArr = $temptestData;

        //入库
        //返回金卡的数量
        $sqlKeyGold = "user_id = '{$userId}' and item_id = '{$goldCardId}'";
        $tbPlayerItemListGold = SysPlayerItems::loadedTable(array('count'),$sqlKeyGold);
        if(empty($tbPlayerItemListGold))
        {
            $HappyEveryDayItem->setGoldcardNumber(0);
        }
        else
        {
            $HappyEveryDayItem->setGoldcardNumber($tbPlayerItemListGold[0]->getCount());
        }
        
        //返回银卡的数量
        $sqlKeySilver = "user_id = '{$userId}' and item_id = '{$silverCardId}'";
        $tbPlayerItemListSilver = SysPlayerItems::loadedTable(array('count'),$sqlKeySilver);
        if(empty($tbPlayerItemListSilver))
         {
             $HappyEveryDayItem->setSilvercardNumber(0);
         }
         else
         {
             $HappyEveryDayItem->setSilvercardNumber($tbPlayerItemListSilver[0]->getCount());
         }
        //返回铜卡的数量
        $sqlKeyCopper = "user_id = '{$userId}' and item_id = '{$copperCardId}'";
        $tbPlayerItemListCopper = SysPlayerItems::loadedTable(array('count'),$sqlKeyCopper);
        if(empty($tbPlayerItemListCopper))
        {
            $HappyEveryDayItem->setCoppercardNumber(0);
        }
        else
        {
            $HappyEveryDayItem->setCoppercardNumber($tbPlayerItemListCopper[0]->getCount());
        }
        //返回获取道具的id和num
        //Logger::getLogger()->debug("open goldCard get".json_encode($addItemArr));

        foreach($addItemArr as $key=>$val)
        {
            $itemArrayDown = new Down_ActivityReward();
            $itemArrayDown->setId($val["Reward ID"]);
            $itemArrayDown->setAmount($val["Reward Amount"]);
            if($val["Reward Type"]== "Item")
            {
                 $addReason = "HappayEveryDayReward--Gold Add Items";
                 ItemModule::addItem($userId, array($val["Reward ID"]=>$val["Reward Amount"]), $addReason);
                 $itemArrayDown->setType(3);
            }
            if($val["Reward Type"]== "Gold")
            {
                //增加金钱及物品,增加合成后物品
                PlayerModule::modifyMoney($userId, $val["Reward Amount"], "ChristmasRewards");
                $itemArrayDown->setType(2);
            }
            $HappyEveryDayItem->appendRewards($itemArrayDown);
        }
        $HappyEveryDayItem->setStatus(2);
        return $HappyEveryDayItem;
    }
    elseif($type==3)
    {
        $needItemArr = array(472=>1);
        $itemState = ItemModule::checkAllItemsExist($userId, $needItemArr);
        if ($itemState == false)
        {
            //Logger::getLogger()->error("open SilverCard need " . print_r($needItemArr, true) . "," . __LINE__);
            $HappyEveryDayItem->setStatus(1);
            $HappyEveryDayItem->setSilvercardNumber(0);
            //返回金卡的数量
            $sqlKeyGold = "user_id = '{$userId}' and item_id = '{$goldCardId}'";
            $tbPlayerItemListGold = SysPlayerItems::loadedTable(array('count'),$sqlKeyGold);
            if(empty($tbPlayerItemListGold))
            {
                $HappyEveryDayItem->setGoldcardNumber(0);
            }
            else
            {
                $HappyEveryDayItem->setGoldcardNumber($tbPlayerItemListGold[0]->getCount());
            }
            //tongka
            $sqlKeyCopper = "user_id = '{$userId}' and item_id = '{$copperCardId}'";
            $tbPlayerItemListCopper = SysPlayerItems::loadedTable(array('count'),$sqlKeyCopper);
            if(empty($tbPlayerItemListCopper))
            {
                $HappyEveryDayItem->setCoppercardNumber(0);
            }
            else
            {
                $HappyEveryDayItem->setCoppercardNumber($tbPlayerItemListCopper[0]->getCount());
            }
            
            return $HappyEveryDayItem;
        }
        //扣除金钱及物品,增加合成后物品
        // PlayerModule::modifyMoney($userId, -$costCoinNum, "equipSynthesis");
        $reduceReason = "HappayEveryDay Reward Reduce Silver Card";
        $itemSubstate = ItemModule::subItem($userId, $needItemArr,$reduceReason);
        if($itemSubstate==false)
        {
            //返回金卡的数量
                $sqlKeyGold = "user_id = '{$userId}' and item_id = '{$goldCardId}'";
                $tbPlayerItemListGold = SysPlayerItems::loadedTable(array('count'),$sqlKeyGold);
                if(empty($tbPlayerItemListGold))
                {
                    $HappyEveryDayItem->setGoldcardNumber(0);
                }
                else
                {
                    $HappyEveryDayItem->setGoldcardNumber($tbPlayerItemListGold[0]->getCount());
                }
                //返回银卡的数量
                $sqlKeySilver = "user_id = '{$userId}' and item_id = '{$silverCardId}'";
                $tbPlayerItemListSilver = SysPlayerItems::loadedTable(array('count'),$sqlKeySilver);
                if(empty($tbPlayerItemListSilver))
                 {
                     $HappyEveryDayItem->setSilvercardNumber(0);
                 }
                 else
                 {
                     $HappyEveryDayItem->setSilvercardNumber($tbPlayerItemListSilver[0]->getCount());
                 }
                //返回铜卡的数量
                $sqlKeyCopper = "user_id = '{$userId}' and item_id = '{$copperCardId}'";
                $tbPlayerItemListCopper = SysPlayerItems::loadedTable(array('count'),$sqlKeyCopper);
                if(empty($tbPlayerItemListCopper))
                {
                    $HappyEveryDayItem->setCoppercardNumber(0);
                }
                else
                {
                    $HappyEveryDayItem->setCoppercardNumber($tbPlayerItemListCopper[0]->getCount());
                }
                //返回获取道具的id和num
          //      Logger::getLogger()->debug("open silverCard get".json_encode($addItemArr));
                $HappyEveryDayItem->setStatus(1);
                return $HappyEveryDayItem;

        }
        //读金卡的lua文件 算出用户获取的的道具的id
         $times = rand(3,6);
        //Logger::getLogger()->debug("open goldCard wegithweigt". $times);
        $christmasRwards = DataModule::getInstance()->getDataSetting(ACTIVITY_CHRISTMAS_REWARDS_INFO);
        $data = $christmasRwards["silver"];
        for($j=0;$j<$times;++$j)
        {
            $weight = 0; $tempdata = array();
            foreach ($data as $one)
            {
                    $weight += $one['Reward Weight'];
                    for ($i = 0; $i < $one['Reward Weight']; ++$i)
                    {
                            $tempdata[] = $one;
                    }
            }
            $use = rand(0, $weight - 1);
            $one = $tempdata[$use];
            $a = array_search($one,$data);
            unset($data[$a]);
            $temptestData[] = $one;
        }

        //Logger::getLogger()->debug("open silverCard get rewards".print_r($temptestData,true));
        $addItemArr = $temptestData;
        //入库        
       //返回金卡的数量
        $sqlKeyGold = "user_id = '{$userId}' and item_id = '{$goldCardId}'";
        $tbPlayerItemListGold = SysPlayerItems::loadedTable(array('count'),$sqlKeyGold);
        if(empty($tbPlayerItemListGold))
        {
            $HappyEveryDayItem->setGoldcardNumber(0);
        }
        else
        {
            $HappyEveryDayItem->setGoldcardNumber($tbPlayerItemListGold[0]->getCount());
        }
        //返回银卡的数量
        $sqlKeySilver = "user_id = '{$userId}' and item_id = '{$silverCardId}'";
        $tbPlayerItemListSilver = SysPlayerItems::loadedTable(array('count'),$sqlKeySilver);
        if(empty($tbPlayerItemListSilver))
         {
             $HappyEveryDayItem->setSilvercardNumber(0);
         }
         else
         {
             $HappyEveryDayItem->setSilvercardNumber($tbPlayerItemListSilver[0]->getCount());
         }
        //返回铜卡的数量
        $sqlKeyCopper = "user_id = '{$userId}' and item_id = '{$copperCardId}'";
        $tbPlayerItemListCopper = SysPlayerItems::loadedTable(array('count'),$sqlKeyCopper);
        if(empty($tbPlayerItemListCopper))
        {
            $HappyEveryDayItem->setCoppercardNumber(0);
        }
        else
        {
            $HappyEveryDayItem->setCoppercardNumber($tbPlayerItemListCopper[0]->getCount());
        }
        //返回获取道具的id和num
        Logger::getLogger()->debug("open silverCard get".json_encode($addItemArr));
       foreach($addItemArr as $key=>$val)
       {
            $itemArrayDown = new Down_ActivityReward();
            $itemArrayDown->setId($val["Reward ID"]);
            $itemArrayDown->setAmount($val["Reward Amount"]);
            if($val["Reward Type"]== "Item")
            {
                 $addReason = "HappayEveryDayReward--Silver Add Items";
                 ItemModule::addItem($userId, array($val["Reward ID"]=>$val["Reward Amount"]), $addReason);
                 $itemArrayDown->setType(3);
            }
            if($val["Reward Type"]== "Gold")
            {
                PlayerModule::modifyMoney($userId, $val["Reward Amount"], "ChristmasRewards");
                $itemArrayDown->setType(2);
            }
            $HappyEveryDayItem->appendRewards($itemArrayDown);
        }
        $HappyEveryDayItem->setStatus(2);
        return $HappyEveryDayItem;
    }
    elseif($type==4)
    {
        $needItemArr = array(473=>1);
        $itemState = ItemModule::checkAllItemsExist($userId, $needItemArr);
        if($itemState == false)
        {
            //Logger::getLogger()->error("open CopperCard need " . print_r($needItemArr, true) . "," . __LINE__);
            $HappyEveryDayItem->setStatus(1);
            $HappyEveryDayItem->setCoppercardNumber(0);
            //返回金卡的数量
            $sqlKeyGold = "user_id = '{$userId}' and item_id = '{$goldCardId}'";
            $tbPlayerItemListGold = SysPlayerItems::loadedTable(array('count'),$sqlKeyGold);
            if(empty($tbPlayerItemListGold))
            {
                $HappyEveryDayItem->setGoldcardNumber(0);
            }
            else
            {
                $HappyEveryDayItem->setGoldcardNumber($tbPlayerItemListGold[0]->getCount());
            }
            //返回银卡的数量
            $sqlKeySilver = "user_id = '{$userId}' and item_id = '{$silverCardId}'";
            $tbPlayerItemListSilver = SysPlayerItems::loadedTable(array('count'),$sqlKeySilver);
            if(empty($tbPlayerItemListSilver))
             {
                 $HappyEveryDayItem->setSilvercardNumber(0);
             }
             else
             {
                 $HappyEveryDayItem->setSilvercardNumber($tbPlayerItemListSilver[0]->getCount());
             }
            
            return $HappyEveryDayItem;
        }
        //扣除金钱及物品,增加合成后物品
        // PlayerModule::modifyMoney($userId, -$costCoinNum, "equipSynthesis");
        $reduceReason = "HappayEveryDay Reward Reduce Copper Card";
        $itemSubstate = ItemModule::subItem($userId, $needItemArr,$reduceReason);
        if($itemSubstate==false)
        {
            //返回金卡的数量
                $sqlKeyGold = "user_id = '{$userId}' and item_id = '{$goldCardId}'";
                $tbPlayerItemListGold = SysPlayerItems::loadedTable(array('count'),$sqlKeyGold);
                if(empty($tbPlayerItemListGold))
                {
                    $HappyEveryDayItem->setGoldcardNumber(0);
                }
                else
                {
                    $HappyEveryDayItem->setGoldcardNumber($tbPlayerItemListGold[0]->getCount());
                }
                //返回银卡的数量
                $sqlKeySilver = "user_id = '{$userId}' and item_id = '{$silverCardId}'";
                $tbPlayerItemListSilver = SysPlayerItems::loadedTable(array('count'),$sqlKeySilver);
                if(empty($tbPlayerItemListSilver))
                 {
                     $HappyEveryDayItem->setSilvercardNumber(0);
                 }
                 else
                 {
                     $HappyEveryDayItem->setSilvercardNumber($tbPlayerItemListSilver[0]->getCount());
                 }
                //返回铜卡的数量
                $sqlKeyCopper = "user_id = '{$userId}' and item_id = '{$copperCardId}'";
                $tbPlayerItemListCopper = SysPlayerItems::loadedTable(array('count'),$sqlKeyCopper);
                if(empty($tbPlayerItemListCopper))
                {
                    $HappyEveryDayItem->setCoppercardNumber(0);
                }
                else
                {
                    $HappyEveryDayItem->setCoppercardNumber($tbPlayerItemListCopper[0]->getCount());
                }
                //返回获取道具的id和num
               // Logger::getLogger()->debug("open silverCard get".json_encode($addItemArr));
                $HappyEveryDayItem->setStatus(1);
                return $HappyEveryDayItem;

        }
        //读金卡的lua文件 算出用户获取的的道具的id
        $times = rand(3,6);
        //Logger::getLogger()->debug("open goldCard wegithweigt". $times);
        $christmasRwards = DataModule::getInstance()->getDataSetting(ACTIVITY_CHRISTMAS_REWARDS_INFO);
        $data = $christmasRwards["copper"];
        for($j=0;$j<$times;++$j)
        {
            $weight = 0; $tempdata = array();
            foreach ($data as $one)
            {
                    $weight += $one['Reward Weight'];
                    for ($i = 0; $i < $one['Reward Weight']; ++$i)
                    {
                            $tempdata[] = $one;
                    }
            }
            $use = rand(0, $weight - 1);
            $one = $tempdata[$use];
            $a = array_search($one,$data);
            unset($data[$a]);
            $temptestData[] = $one;
        }

        //Logger::getLogger()->debug("open silverCard get rewards".print_r($temptestData,true));
        $addItemArr = $temptestData;
        //入库
        //返回金卡的数量
        $sqlKeyGold = "user_id = '{$userId}' and item_id = '{$goldCardId}'";
        $tbPlayerItemListGold = SysPlayerItems::loadedTable(array('count'),$sqlKeyGold);
        if(empty($tbPlayerItemListGold))
        {
            $HappyEveryDayItem->setGoldcardNumber(0);
        }
        else
        {
            $HappyEveryDayItem->setGoldcardNumber($tbPlayerItemListGold[0]->getCount());
        }
        //返回银卡的数量
        $sqlKeySilver = "user_id = '{$userId}' and item_id = '{$silverCardId}'";
        $tbPlayerItemListSilver = SysPlayerItems::loadedTable(array('count'),$sqlKeySilver);
        if(empty($tbPlayerItemListSilver))
         {
             $HappyEveryDayItem->setSilvercardNumber(0);
         }
         else
         {
             $HappyEveryDayItem->setSilvercardNumber($tbPlayerItemListSilver[0]->getCount());
         }
        //返回铜卡的数量
        $sqlKeyCopper = "user_id = '{$userId}' and item_id = '{$copperCardId}'";
        $tbPlayerItemListCopper = SysPlayerItems::loadedTable(array('count'),$sqlKeyCopper);
        if(empty($tbPlayerItemListCopper))
        {
            $HappyEveryDayItem->setCoppercardNumber(0);
        }
        else
        {
            $HappyEveryDayItem->setCoppercardNumber($tbPlayerItemListCopper[0]->getCount());
        }
        //返回获取道具的id和num
        //Logger::getLogger()->debug("open copper Card get".json_encode($addItemArr));
       foreach($addItemArr as $key=>$val)
        {
            $itemArrayDown = new Down_ActivityReward();
            $itemArrayDown->setId($val["Reward ID"]);
            $itemArrayDown->setAmount($val["Reward Amount"]);
            if($val["Reward Type"]== "Item")
            {
                 $addReason = "HappayEveryDayReward--Copper Add Items";
                 ItemModule::addItem($userId, array($val["Reward ID"]=>$val["Reward Amount"]), $addReason);
                 $itemArrayDown->setType(3);
            }
            if($val["Reward Type"]== "Gold")
            {
                PlayerModule::modifyMoney($userId, $val["Reward Amount"], "ChristmasRewards");
                $itemArrayDown->setType(2);
            }
            $HappyEveryDayItem->appendRewards($itemArrayDown);
        }
        $HappyEveryDayItem->setStatus(2);

        return $HappyEveryDayItem;
    }
    else
    {
         //处理开启天天乐
            //金卡数量 金卡的id是
             $sqlKeyGold = "user_id = '{$userId}' and item_id = '{$goldCardId}'";
             $tbPlayerItemListGold = SysPlayerItems::loadedTable(array('count'),$sqlKeyGold);
             if(empty ($tbPlayerItemListGold))
             {
          //      Logger::getLogger()->debug("OnHappyEveryDayGold is empty" );
                $GoldItemCount = 0;               
             }
             else
             {
                 foreach($tbPlayerItemListGold as $tbPlayerItemGold)
                 {
                     $GoldItemCount = $tbPlayerItemGold->getCount();
                 }                 
             }
            // Logger::getLogger()->debug("OnHappyEveryDayGold count".$GoldItemCount );
             $HappyEveryDayItem->setGoldcardNumber($GoldItemCount);
             //存入memecache
             // PlayerCacheModule::setData($userID, $goldCardId, $GoldItemCount);
             //处理银卡 银卡的id是
             $sqlKeySilver = "user_id = '{$userId}' and item_id = '{$silverCardId}'";
             $tbPlayerItemListSilver = SysPlayerItems::loadedTable(array('count'),$sqlKeySilver);
             if(empty ($tbPlayerItemListSilver))
             {
              //  Logger::getLogger()->debug("OnHappyEveryDaySilver is empty" );
               $itemCountSilver = 0;               
             }
             else
             {
                 foreach($tbPlayerItemListSilver as $tbPlayerItemSilver)
                 {
                     $itemCountSilver = $tbPlayerItemSilver->getCount();
                 }                 
             }
             //Logger::getLogger()->debug("OnHappyEveryDaySilver count".$itemCountSilver );
             $HappyEveryDayItem->setSilvercardNumber($itemCountSilver);
             //存入memecache
            // PlayerCacheModule::setData($userID, $silverCardId, $itemCountSilver);
             //处理铜卡
             $sqlKeyCopper = "user_id = '{$userId}' and item_id = '{$copperCardId}'";
             $tbPlayerItemListCopper = SysPlayerItems::loadedTable(array('count'),$sqlKeyCopper);
             if(empty ($tbPlayerItemListCopper))
             {
                //Logger::getLogger()->debug("OnHappyEveryDayCopper is empty" );
                $itemCountCopper = 0;
             }
             else
             {
                 foreach($tbPlayerItemListCopper as $tbPlayerItemCopper)
                 {
                     $itemCountCopper = $tbPlayerItemCopper->getCount();
                 }                
             }
             
              //Logger::getLogger()->debug("OnHappyEveryDayCopper count".$itemCountCopper );
              $HappyEveryDayItem->setCoppercardNumber($itemCountCopper);
              //存入memecache
             //PlayerCacheModule::setData($userID, $copperCardId, $itemCountCopper);
             $HappyEveryDayItem->setStatus(1);

        return $HappyEveryDayItem;             
    }
}
?>
