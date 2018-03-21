<?php
require_once($GLOBALS['GAME_ROOT'] . "DbModule/SysPlayerShop.php");
require_once($GLOBALS['GAME_ROOT'] . "Classes/DataModule.php");
require_once($GLOBALS['GAME_ROOT'] . "Classes/VipModule.php");
class ShopModule
{
    /** 星际商人所需要的灵魂石数量 */
    const STAR_STONE_GREEN = 20;

    /** 星际商人所需要的灵魂石数量 */
    const STAR_STONE_BLUE = 50;

    /** 星际商人所需要的灵魂石数量 */
    const STAR_STONE_PURPLE = 100;

    public static function getAllShopDownInfo($userId)
    {
        $SearchKey = "`user_id` = '{$userId}'";
        $allShopSys = SysPlayerShop::loadedTable(null, $SearchKey);
        $allShopInfo = array();
        /** @var SysPlayerShop $SysShop */
        $unlock4 = true;
        $unlock5 = true;
        $unlock7 = true;
        foreach ($allShopSys as $SysShop) {
            if ($SysShop->getShopTid() == 6) { //这里不返回星际商店
                continue;
            }
            $oneShop = self::getShopInfo($SysShop);
            $allShopInfo[] = $oneShop;
            if ($SysShop->getShopTid() == 4) {
                $unlock4 = false;
            }
            if ($SysShop->getShopTid() == 5) {
                $unlock5 = false;
            }
            if ($SysShop->getShopTid() == 7) {
                $unlock7 = false;
            }
        }
        if ($unlock4) {
            self::unlockShop($userId, 1, 4); //解锁远征商店
        }
        if ($unlock5) {
            self::unlockShop($userId, 1, 5); //解锁竞技场商店
        }
        if ($unlock7) {
            $guildInfo = GuildModule::getGuildIdByUserId($userId);
            if($guildInfo!=0){
                self::unlockShop($userId, 1, 7); //解锁工会商店
            }
        }


        return $allShopInfo;
    }
	 /**  获取用户商店6的信息**/
    public static function getStarShopDownInfo($userId)
    {
        $oneShop = ShopModule::getCurrentPlayerShop($userId, 6);
        if (isset($oneShop)) {
            $ShopDown = ShopModule::getShopInfo($oneShop);
            return $ShopDown;
        }
    }

    public static function getRandomGoods($ShopID)
    {
        $ShopGoods = array();
        if ($ShopID == 6) {
            return $ShopGoods;
        }
        $DataModule=DataModule::getInstance();
        $ShopDefines = $DataModule->getDataSetting(SHOP_LUA_KEY);
        $goodsTb = $DataModule->getDataSetting(ITEM_GROUPS_LUA_KEY);
        $ShopDef = $ShopDefines[$ShopID];


        for ($i = 1; $i <= 12; $i++) {
            $GoodGroup = intval($ShopDef["Goods {$i} Group"]);
            if ($GoodGroup > 0) {
                $groupGoods = $goodsTb[$GoodGroup];
                $goods = $groupGoods[array_rand($groupGoods)];
                $goods['sale'] = 0;
                //商店打折活动
                if(DailyActivityModule::checkSaleActivity())
                {
                    $good_id = $goods['id'];
                    $itemRule = DataModule::lookupDataTable(ITEM_LUA_KEY, null, array($good_id));
                    $quality = DataModule::lookupDataTable(ITEM_LUA_KEY, "Quality", array($good_id));
                    if($itemRule["Quality"] >= 4 && ($itemRule["Category"] == "EQUIP.PARTS" || $itemRule["Category"] == "EQUIP.REEL" ||  $itemRule["Category"] == "EQUIP.SYNTHETICS"))
                    {
                        $goods['sale'] = 1;
                        $goods['price'] = round($goods['price'] * 0.6);
                    }
                }
                array_push($ShopGoods, $goods);
            }
        }
        if ($ShopID != 4 && $ShopID != 5) {
            shuffle($ShopGoods);
        }
        return $ShopGoods;
    }

    public static function getGoodStr($goods)
    {
        $curGood = "";
        foreach ($goods as $good) {
            $curGood = $curGood . $good["id"] . "-" . $good["amout"] . "-" . $good["price type"] . "-" . $good["price"] . "-" . $good["sale"] . "|";
        }
        return $curGood;
    }

    /**
     * 对商店进行解锁操作
     * 根据指定的shopID和关卡ID进行解锁
     * 不存在时增加新的商店
     * 如果存在过期时间的，重置过期时间
     *
     * @return 返回当前解锁的商店  Down_UserShop。
     */
    public static function unlockShop($userId, $stage, $shopID)
    {
        if($shopID == 6)
        {//临时屏蔽商店
            return null;
        }
        //检查解锁条件
        $DataModule = DataModule::getInstance();
        $ShopDefines = $DataModule->getDataSetting(SHOP_LUA_KEY);
        $ShopD = $ShopDefines[$shopID];
        $unlockStage = intval($ShopD["Unlock Stage"]);
        $expireTime = intval($ShopD["Expire Time"]);
        $curTime = time();
        if ($stage >= $unlockStage) {
            /** @var SysPlayerShop $SysShop */
            $SysShop = ShopModule::getCurrentPlayerShop($userId, $shopID);
            if (!isset($SysShop)) { //商店不存在才解锁
                $SysShop = new SysPlayerShop();
                $SysShop->setUserId($userId);
                $SysShop->setShopTid($shopID);
                $SysShop->setTodayTimes(0);
                $SysShop->setLastAutoRefreshTime($curTime);
                $SysShop->setLastManualRefreshTime($curTime);
                $SysShop->setExpireTime($expireTime);
                $goods = ShopModule::getGoodStr(ShopModule::getRandomGoods($shopID));
                if ($shopID == 6) {
                    $soulArr = self::getStarShopMoneyAll($userId);
                    if (count($soulArr) > 0) {
                        $goods = $soulArr[array_rand($soulArr)];
                    }
                }
                $SysShop->setCurGoods($goods);
            } else { //商店存在
                if ($SysShop->getExpireTime() == 0) { //不过期商店，已激活
                    return null;
                }
                if ($SysShop->getExpireTime() > $curTime) { //上次出现的还没过期
                    return null;
                }
            }

            if ($SysShop->getExpireTime() > 0) { //可过期商店，重置过期时间
                if ($shopID == 6) {
                    $soulArr = self::getStarShopMoneyAll($userId);
                    if (count($soulArr) > 0) {
                        $goods = $soulArr[array_rand($soulArr)];
                        $SysShop->setCurGoods($goods);
                    }
                }
                $SysShop->setExpireTime($curTime + $expireTime);
            }

            $SysShop->inOrUp();
            return ShopModule::getShopInfo($SysShop);
        }
        return null;
    }

    /**
     *商店已过期，返回空
     */
    public static function getCurrentPlayerShop($userId, $shopID)
    {
        $searchKey = "`user_id` = '{$userId}' and `shop_tid` = '{$shopID}'";
        $allShopTb = SysPlayerShop::loadedTable(null, $searchKey);
        if (sizeof($allShopTb) > 0) {
            return $allShopTb[0];
        }
        return null;
    }

    /**
     * 花钱打开神秘商店
     * @param $userId UserID
     * @param $shopId 商店ID
     *
     */
    public static function openShop($userId, $shopId)
    {
        Logger::getLogger()->debug("openShop process");
        //特定vip等级以后才可以打开对应商店
        if ($shopId == 2) {
            $vipState = VipModule::getVIPModuleLimitByUserId($userId, _VIP_MODULE_TYPE::SUMMON_SPECIAL_SHOP);
            if (empty($vipState)) {
                Logger::getLogger()->error("openShop not enough vip level" . __LINE__);
                return null;
            }
        }

        if ($shopId == 3) {
            $vipState = VipModule::getVIPModuleLimitByUserId($userId, _VIP_MODULE_TYPE::SUMMON_SO_SPECIAL_SHOP);
            if (empty($vipState)) {
                Logger::getLogger()->error("openShop not enough vip level" . __LINE__);
                return null;
            }
        }

        $curTime = time();
        if ($shopId == 2 || $shopId == 3) {
            //只针对神秘商店
            $shopSys = self::getCurrentPlayerShop($userId, $shopId);
            if (!isset($shopSys)) {
                $shopSys = new SysPlayerShop();
                $shopSys->setUserId($userId);
                $shopSys->setShopTid($shopId);
                $shopSys->setTodayTimes(0);
                $shopSys->setLastAutoRefreshTime($curTime);
                $shopSys->setLastManualRefreshTime($curTime);
                $shopSys->setExpireTime(0);
                $goods = ShopModule::getGoodStr(ShopModule::getRandomGoods($shopId));
                $shopSys->setCurGoods($goods);
                
                if ($shopId == 2) { //打开地精商人
                	ConsumeModule::doConsume($userId, CONSUME_TYPE_SUMMON_SPECIAL_SHOP, 1);
                }
                if ($shopId == 3) { //打开黑市商人
                	ConsumeModule::doConsume($userId, CONSUME_TYPE_SUMMON_SPECIAL_SHOP_EX, 1);
                }
            }
       
            $shopSys->setExpireTime(0);
            $shopSys->inOrUp();
            return self::getShopInfo($shopSys);
        }
        return null;
    }

    /**
     * 检查用户所有5星英雄，灵魂石满足20个的灵魂石列表。
     * @param $userId
     * @return array
     */
    public static function getStarShopMoneyAll($userId)
    {
        //查找5星英雄
        $tbHeroList = HeroModule::getAllHeroTable($userId);
        /** @var TbPlayerHero $tbHero */
        $soulStones = array();
        foreach ($tbHeroList as $tbHero) {
            if ($tbHero->getStars() >= 5) {
                $fragment = DataModule::lookupDataTable(FRAGMENT_LUA_KEY, $tbHero->getTid(), array());
                $soulStoneId = $fragment['Fragment ID'];
                $soulArrp[$soulStoneId] = 20;
                if (ItemModule::checkAllItemsExist($userId, $soulArrp)) {
                    $soulStones[] = $soulStoneId;
                }
            }
        }
        return $soulStones;
    }

    public static function getShopInfo(SysPlayerShop $SysShop)
    {
        //TODO:将来增加如果是6号商店，则返回 StarShop
        if ($SysShop->getShopTid() == 6) { //星际商店
            $oneShop = new Down_StarShop();
            $oneShop->setId($SysShop->getShopTid());
            $oneShop->setExpireTime($SysShop->getExpireTime());
            $soulId = $SysShop->getCurGoods();
            if ($soulId > 0) { //存在足够灵魂石
                $good1 = new Down_StarGoods();
                $good1->setType(0);
                $good1->setAmount(1);
                $good1->setStoneId($soulId);
                $good1->setStoneAmount(self::STAR_STONE_GREEN);
                $oneShop->appendStarGoods($good1);

                $good2 = new Down_StarGoods();
                $good2->setType(1);
                $good2->setAmount(1);
                $good2->setStoneId($soulId);
                $good2->setStoneAmount(self::STAR_STONE_BLUE);
                $oneShop->appendStarGoods($good2);

                $good3 = new Down_StarGoods();
                $good3->setType(2);
                $good3->setAmount(1);
                $good3->setStoneId($soulId);
                $good3->setStoneAmount(self::STAR_STONE_PURPLE);
                $oneShop->appendStarGoods($good3);
            } else { //星际商人，但灵魂石不足
                return null;
            }
        } else {
            $oneShop = new Down_UserShop();
            $oneShop->setId($SysShop->getShopTid());
            $oneShop->setLastAutoRefreshTime($SysShop->getLastAutoRefreshTime());
            $oneShop->setLastManualRefreshTime($SysShop->getLastManualRefreshTime());
            $oneShop->setExpireTime($SysShop->getExpireTime());
            $oneShop->setTodayTimes($SysShop->getTodayTimes());

            $goodsArr = explode("|", $SysShop->getCurGoods());
            foreach ($goodsArr as $good) {
                $oneGoodArr = explode("-", $good);
                if (count($oneGoodArr) >= 4) {
                    $oneGood = new Down_Goods();
                    $oneGood->setId($oneGoodArr[0]);
                    $oneGood->setAmount($oneGoodArr[1]);
                    if ($oneGoodArr[2] == "gold") {
                        $oneGood->settype(PRICE_TYPE::gold);
                    } else if ($oneGoodArr[2] == "diamond") {
                        $oneGood->setType(PRICE_TYPE::diamond);
                    } else if ($oneGoodArr[2] == "crusadepoint") {
                        $oneGood->setType(PRICE_TYPE::crusadepoint);
                    } else if ($oneGoodArr[2] == "arenapoint") {
                        $oneGood->setType(PRICE_TYPE::arenapoint);
                    } else if ($oneGoodArr[2] == "guildpoint") {
                        $oneGood->setType(PRICE_TYPE::guildpoint);
                    } else {
                        $oneGood->setType($oneGoodArr[2]);
                    }
                    $oneGood->setPrice($oneGoodArr[3]);
                    $sale = 0;
                    if(isset($goodsArr[4]))
                    {
                        $sale = intval($oneGoodArr[4]);
                    }
                    $oneGood->setIsSale($sale);
                    $oneShop->appendCurrentGoods($oneGood);
                }
            }
        }

        return $oneShop;
    }

    public static function getShopDownGoods(Down_UserShop $DownShop)
    {
        $goodsArr = $DownShop->getCurrentGoods();
        $ret = "";
        foreach ($goodsArr as $good) {
            $ret .= $good->getId() . "-" . $good->getAmount() . "-" . $good->getType() . "-" . $good->getPrice() . "|";
        }
        return rtrim($ret, '|');
    }
}