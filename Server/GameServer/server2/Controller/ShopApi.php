<?php
require_once($GLOBALS['GAME_ROOT'] . "DbModule/SQLUtil.php");
require_once($GLOBALS['GAME_ROOT'] . "Classes/DataModule.php");
require_once($GLOBALS['GAME_ROOT'] . "Classes/ShopModule.php");
require_once($GLOBALS['GAME_ROOT'] . "Classes/ItemModule.php");
require_once($GLOBALS['GAME_ROOT'] . "Classes/ConsumeModule.php");

// 刷新商店

// 1. sync的时候，如果到自动刷新的时间了，刷一批新的物品。
// 2. manual_refresh的时候，到刷新时间了，则免费刷
//Up_ShopRefresh_Rtype
//auto_refresh;   = 时间到了，客户端发起的商店自动刷新请求
//manual_refresh; = 玩家手动刷新的请求
//sync            = 玩家新进入商店时，同步商店
function ShopRefreshApi(WorldSvc $svc, Up_ShopRefresh $pPacket)
{
    Logger::getLogger()->debug("ShopRefreshApi debug");

    $ShopID = $pPacket->getShopId();
    $ShopDefines = DataModule::getInstance()->getDataSetting(SHOP_LUA_KEY);
    $curTime = time();
    $Shop = $ShopDefines[$ShopID];
    //获取商店信息
    $sysShop = ShopModule::getCurrentPlayerShop($GLOBALS ['USER_ID'], $ShopID);
    if (isset($sysShop)) { //商店存在才刷新
        $ExpireTime = $sysShop->getExpireTime();
        if ($ExpireTime > 0 && $ExpireTime < $curTime) { //可过期商店,商店已过期，不再刷新
            return null;
        }
        //更新数据
		if ($sysShop->getTodayTimes() >0 && SQLUtil::isTimeNeedReset($sysShop->getLastManualRefreshTime()))
		{
			Logger::getLogger()->debug("ShopRefreshApi::resetTime");
			$sysShop->setTodayTimes(0); //重置手动刷新次数
		}
        
        $refreshPeroid = SQLUtil::getRefreshTimeRange($Shop["Refresh Times"]);

        
     	 if ($sysShop->getLastAutoRefreshTime() < $refreshPeroid[0]) { //超过货物刷新周期了，需要刷新货物了,无论是手动还是自动
            Logger::getLogger()->debug("ShopRefreshApi::autoRefresh");

            $goods = ShopModule::getRandomGoods($ShopID);
            $curGood = "";
            foreach ($goods as $good) { 
                $curGood = $curGood . $good["id"] . "-" . $good["amout"] . "-" . $good["price type"] . "-" . $good["price"] . "-" . $good["sale"] . "|";
            }
            $sysShop->setCurGoods($curGood);
            $sysShop->setLastAutoRefreshTime($curTime);
        } else if ($pPacket->getType() == Up_ShopRefresh_Rtype::manual_refresh) { 
            Logger::getLogger()->debug("ShopRefreshApi::manualRefresh");
            $consumeKeys = array(
                1 => CONSUME_SHOP_1_REFRESH,
                2 => CONSUME_SHOP_2_REFRESH,
                3 => CONSUME_SHOP_3_REFRESH,
                4 => CONSUME_SHOP_4_REFRESH,
                5 => CONSUME_SHOP_5_REFRESH,
                7 => CONSUME_SHOP_7_REFRESH,
            );
            $refreshTimes = $sysShop->getTodayTimes() + 1;
            //扣费操作
            $Fee = ConsumeModule::doConsume($GLOBALS ['USER_ID'], $consumeKeys[$ShopID], $refreshTimes);
            if (!$Fee) {
            	//扣费失败处理   待定---todo
                return null;
            }
            $sysShop->setTodayTimes($refreshTimes); //计算次数
            $goods = ShopModule::getRandomGoods($ShopID);
            $curGood = "";
            foreach ($goods as $good) {
                $curGood = $curGood . $good["id"] . "-" . $good["amout"] . "-" . $good["price type"] . "-" . $good["price"] . "-" . $good["sale"] . "|";
            }
            $sysShop->setCurGoods($curGood);
            $sysShop->setLastManualRefreshTime($curTime);
        }
        $sysShop->save();
        $reply = ShopModule::getShopInfo($sysShop);
        Logger::getLogger()->debug("ShopRefreshApi:Ending");
        return $reply;
    }
}

/*
 * 购买商品
 */
function ShopConsumeApi(WorldSvc $svc, Up_ShopConsume $pPacket)
{
    Logger::getLogger()->debug("ShopConsumeApi After");
    $ShopID = $pPacket->getSid();
    $SoltId = $pPacket->getSlotid();
    $Amount = $pPacket->getAmount();
    $curTime = time();

    $reply = new Down_ShopConsumeReply();
    $reply->setResult(Down_Result::fail);
    //获取商店信息
    $AloneShop = ShopModule::getCurrentPlayerShop($GLOBALS ['USER_ID'], $ShopID);
    if (isset($AloneShop)) {
        $ShopDown = ShopModule::getShopInfo($AloneShop);
        $goods = $ShopDown->getCurrentGoodsAt($SoltId - 1);
        if ($ShopDown->getExpireTime() == 0 || $ShopDown->getExpireTime() > $curTime) {
            if ($goods->getAmount() >= $Amount) {
                Logger::getLogger()->debug("ShopConsumeApi->BuyItem=" . $goods->getId() . ";left=" . $goods->getAmount() . ",amount=" . $Amount);
                if (ConsumeModule::buy($GLOBALS ['USER_ID'], $goods->getType(), $goods->getPrice() * $Amount, array($goods->getId() => $Amount))) { //
                    ItemModule::addItem($GLOBALS ['USER_ID'], array($goods->getId() => $goods->getAmount()), "BuyItem");
                    $goods->setAmount(0);
                    $AloneShop->setCurGoods(ShopModule::getShopDownGoods($ShopDown));
                    $AloneShop->Save();
                    $reply->setResult(Down_Result::success);
                } else {
                    Logger::getLogger()->debug("ShopConsumeApi::buyamount=" . $Amount . ",left=" . $goods->getAmount());
                }
            } else {
                Logger::getLogger()->debug("ShopConsumeApi::buyamount=" . $Amount . ",left=" . $goods->getAmount());
            }
        }
    }
    return $reply;
}

/*
 * 出售商品
 */
function SellItemApi(WorldSvc $svc, Up_SellItem $pPacket)
{
    Logger::getLogger()->debug("SellItemApi After");
    $goods = $pPacket->getItemIterator();
    $SellItems = array();
    $TotalPrice = 0;
    while ($goods->valid()) {
        $Id = MathUtil::bits($goods->current(), 0, 10);
        $Amount = MathUtil::bits($goods->current(), 10, 11);
        $SellItems[$Id] = $Amount;
        $price = DataModule::getInstance()->lookupDataTable(ITEM_LUA_KEY, "Sell Price", array($Id));
        $TotalPrice += $price * $Amount;
        $goods->next();
    }

    $reply = new Down_SellItemReply();
    $reply->setResult(Down_Result::fail);
    if (ItemModule::checkAllItemsExist($GLOBALS['USER_ID'], $SellItems)) {
        if (ItemModule::subItem($GLOBALS['USER_ID'], $SellItems, "SellItem")) {
            if (ConsumeModule::sell($GLOBALS['USER_ID'], PRICE_TYPE::gold, $TotalPrice, $SellItems)) {
                $reply->setResult(Down_Result::success);
            }
        }
    }
    return $reply;
}

/*
 * 花钱打开神秘商店
 */
function OpenShopApi($userId, Up_OpenShop $OpenShop)
{
    $reply = new Down_OpenShopReply();
    $reply->setResult(Down_Result::fail);
    $Shop = ShopModule::openShop($userId, $OpenShop->getShopid());
    if (isset($Shop)) {
        $reply->setResult(Down_Result::success);
        $reply->setShop($Shop);
    }
    return $reply;
}