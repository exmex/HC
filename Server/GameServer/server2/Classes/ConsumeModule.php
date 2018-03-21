<?php
/**
 * 消费管理器
 */

//商店刷新类
define('CONSUME_TYPE_SUMMON_SPECIAL_SHOP', 'Summon Special Shop');
define('CONSUME_TYPE_SUMMON_SPECIAL_SHOP_EX', 'Summon So Special Shop');

define('CONSUME_SHOP_1_REFRESH', 'Shop 1 Refresh');
define('CONSUME_SHOP_2_REFRESH', 'Shop 2 Refresh');
define('CONSUME_SHOP_3_REFRESH', 'Shop 3 Refresh');
define('CONSUME_SHOP_4_REFRESH', 'Shop 4 Refresh');
define('CONSUME_SHOP_5_REFRESH', 'Shop 5 Refresh');
define('CONSUME_SHOP_7_REFRESH', 'Shop 7 Refresh');

//次数重置类
define('CONSUME_TYPE_ELITE_RESET', 'Elite Reset');
define('CONSUME_TYPE_EXCAVATE_SEARCH', 'Excavate Search');

define('CONSUME_TYPE_VITALITY', 'Vitality');
define('CONSUME_TYPE_SKILL_UPGRADE_RESET', 'Skill Upgrade Reset');
define('CONSUME_TYPE_MIDAS', 'Midas');
define('CONSUME_TYPE_PVP_BUY', 'PVP Buy');
define('CONSUME_TYPE_TIMES', 'Times');


final class  PRICE_TYPE
{
    const gold = 0;
    const diamond = 1;
    const crusadepoint = 2;
    const arenapoint = 3;
    const guildpoint = 4;
}

require_once($GLOBALS['GAME_ROOT'] . "Classes/DataModule.php");;
require_once($GLOBALS['GAME_ROOT'] . "Classes/PlayerModule.php");

class ConsumeModule
{
    static $instance;
    protected static $currencyTypeList;

    function ConsumeManager()
    {
        self::$currencyTypeList = array();
        self::$currencyTypeList = array(
            //TODO:需要修正每种类型使用的金币类型
            CONSUME_TYPE_SUMMON_SPECIAL_SHOP => PRICE_TYPE::diamond,
            CONSUME_TYPE_SUMMON_SPECIAL_SHOP_EX => PRICE_TYPE::diamond,
            CONSUME_SHOP_1_REFRESH => PRICE_TYPE::diamond,
            CONSUME_SHOP_2_REFRESH => PRICE_TYPE::diamond,
            CONSUME_SHOP_3_REFRESH => PRICE_TYPE::diamond,
            CONSUME_SHOP_4_REFRESH => PRICE_TYPE::crusadepoint,
            CONSUME_SHOP_5_REFRESH => PRICE_TYPE::arenapoint,
            CONSUME_SHOP_7_REFRESH => PRICE_TYPE::guildpoint,
            CONSUME_TYPE_ELITE_RESET => PRICE_TYPE::diamond,
            CONSUME_TYPE_EXCAVATE_SEARCH => PRICE_TYPE::diamond,
            CONSUME_TYPE_VITALITY => PRICE_TYPE::diamond,
            CONSUME_TYPE_SKILL_UPGRADE_RESET => PRICE_TYPE::diamond,
            CONSUME_TYPE_MIDAS => PRICE_TYPE::diamond,
            CONSUME_TYPE_PVP_BUY => PRICE_TYPE::diamond,
            CONSUME_TYPE_TIMES => PRICE_TYPE::diamond,
        );
    }

    static function &getInstance()
    {
        if (!isset (self::$instance)) {
            self::$instance = new ConsumeModule ();
        }
        return self::$instance;
    }

    /**
     * 刷新与重置类消费总入口
     * 金币、钻石、各类货币的消耗
     * @param $userId 用户ID
     * @param $consumeType 消耗类型
     * @param $times 本日消耗次数
     * @return true/false 消费是否成功
     */
    public static function doConsume( /*String*/
        $userId, /*String*/
        $consumeType, /*String*/
        $times /*int*/
    )
    {
        Logger::getLogger()->debug("doConsume:userId=" . $userId . ",consumeType=" . $consumeType . ",times=" . $times);
        self::getInstance();
        $priceType = self::$currencyTypeList[$consumeType];
        $cost = intval(DataModule::lookupDataTable(GRADIENT_PRICE_LUA_KEY, $consumeType, array($times)));
        return self::buy($userId, $priceType, $cost, array($consumeType => $times));
    }


    /**
     * 购买类消费总入口
     * 金币、钻石、各类货币的消耗
     * 注意：这里只做货币消耗，不进行实际的购买。
     * @param $userId 用户ID
     * @param $priceType 货币类型
     * @param $amount 总金额
     * @param $item 购买商品
     * @param $itemCount 购买数量
     * @return true/false 消费是否成功
     *
     */
    public static function buy( /*String*/
        $userId, /*String*/
        $priceType, /*int*/
        $amount, /*int*/
        $itemArr /*array*/
    )
    {
        $itemStr = SQLUtil::getArrayString($itemArr);
        Logger::getLogger()->info("[buy]userId=" . $userId . ",priceType=" . $priceType . ",amount=" . $amount . ",items=" . $itemStr);
        self::getInstance();
        $tbPlayer = PlayerModule::getPlayerTable($userId);
        switch ($priceType) {
            case PRICE_TYPE::gold:
                $before = $tbPlayer->getMoney();
                if ($before < $amount) {
                    Logger::getLogger()->error("[buy]gold not enough. amount=" . $amount . ", left=", $before);
                    return false;
                }
                $after = PlayerModule::modifyMoney($userId, -$amount, "[buy]items=" . $itemStr);
                if ($after != $before - $amount) { //暂时只记录，不处理
                    Logger::getLogger()->error("[buy]gold modify error,not sync - userId=" . $userId . ",priceType=" . $priceType . "before:" . $before . " , modify:" . -$amount . ", after:" . $after);
                }
                return true;
            case PRICE_TYPE::diamond:
                $before = $tbPlayer->getGem();
                if ($before < $amount) {
                    Logger::getLogger()->error("[buy]diamond not enough. amount=" . $amount . ", left=", $before);
                    return false;
                }
                $after = PlayerModule::modifyGem($userId, -$amount, "[buy]items=" . $itemStr);
                if ($after != $before - $amount) { //暂时只记录，不处理
                    Logger::getLogger()->error("[buy]diamond modify error,not sync - userId=" . $userId . ",priceType=" . $priceType . "before:" . $before . " , modify:" . -$amount . ", after:" . $after);
                }
                return true;
            case PRICE_TYPE::arenapoint:
                $before = $tbPlayer->getArenaPoint();
                if ($before < $amount) {
                    Logger::getLogger()->error("[buy]arenapoint not enough. amount=" . $amount . ", left=", $before);
                    return false;
                }
                $after = PlayerModule::modifyArenaPoint($userId, -$amount, "[buy]items=" . $itemStr);
                if ($after != $before - $amount) { //暂时只记录，不处理
                    Logger::getLogger()->error("[buy]arenapoint modify error,not sync - userId=" . $userId . ",priceType=" . $priceType . "before:" . $before . " , modify:" . -$amount . ", after:" . $after);
                }
                return true;
            case PRICE_TYPE::crusadepoint:
                $before = $tbPlayer->getCrusadePoint();
                if ($before < $amount) {
                    Logger::getLogger()->error("[buy]crusadepoint not enough. amount=" . $amount . ", left=", $before);
                    return false;
                }
                $after = PlayerModule::modifyCrusadePoint($userId, -$amount, "[buy]items=" . $itemStr);
                if ($after != $before - $amount) { //暂时只记录，不处理
                    Logger::getLogger()->error("[buy]crusadepoint modify error,not sync - userId=" . $userId . ",priceType=" . $priceType . "before:" . $before . " , modify:" . -$amount . ", after:" . $after);
                }
                return true;
            case PRICE_TYPE::guildpoint:
                $before = $tbPlayer->getGuildPoint();
                if ($before < $amount) {
                    Logger::getLogger()->error("[buy]guildpoint not enough. amount=" . $amount . ", left=", $before);
                    return false;
                }
                $after = PlayerModule::modifyGuildPoint($userId, -$amount, "[buy]items=" . $itemStr);
                if ($after != $before - $amount) { //暂时只记录，不处理
                    Logger::getLogger()->error("[buy]guildpoint modify error,not sync - userId=" . $userId . ",priceType=" . $priceType . "before:" . $before . " , modify:" . -$amount . ", after:" . $after);
                }
                return true;
        }
    }

    /**
     * 物品出售
     *
     * 注意：这里只做货币增加，不进行实际的购买。
     *
     * @param int $userId 用户ID
     * @param int $priceType 货币类型
     * @param int $amount 总金额
     * @param array $itemArr 购买商品
     * @return bool 消费是否成功
     */
    public static function sell( /*String*/
        $userId, /*String*/
        $priceType, /*int*/
        $amount, /*int*/
        $itemArr /*array*/
    )
    {
        $itemStr = SQLUtil::getArrayString($itemArr);
        Logger::getLogger()->info("[sell]userId=" . $userId . ",priceType=" . $priceType . ",amount=" . $amount . ",items=" . $itemStr);
        switch ($priceType) {
            case PRICE_TYPE::gold:
                $after = PlayerModule::modifyMoney($userId, $amount, "[sell]item=" . $itemStr);
                return true;
            case PRICE_TYPE::diamond:
                $after = PlayerModule::modifyGem($userId, $amount, "[buy]item=" . $itemStr);
                return true;
            case PRICE_TYPE::arenapoint:
                //
                break;
            case PRICE_TYPE::crusadepoint:
                //
                break;
            case PRICE_TYPE::guildpoint:
                break;
        }

        return true;
    }

    /**
     * 消费经验丹
     *
     * @param $userId int
     * @param $heroId
     * @param $itemId
     * @return Down_ConsumeItemReply
     */
    public static function consumeItem($userId, $heroTid, $itemIdBits)
    {
        require_once($GLOBALS['GAME_ROOT'] . "Classes/HeroModule.php");
        require_once($GLOBALS['GAME_ROOT'] . "Classes/MathUtil.php");
        require_once($GLOBALS['GAME_ROOT'] . "Classes/ItemModule.php");

        $consumeItemReply = new Down_ConsumeItemReply();

        //获取武将信息
        $sysPlayerHeroArr = HeroModule::getAllHeroTable($userId, array($heroTid));
        if (!isset($sysPlayerHeroArr[$heroTid])) {
            Logger::getLogger()->error("consumeItem not found hero heroTid = {$heroTid}");
            return null;
        }

        /** @var SysPlayerHero $sysPlayerHero */
        $sysPlayerHero = & $sysPlayerHeroArr[$heroTid];

        $itemId = MathUtil::bits($itemIdBits, 0, 10);
        $itemNum = MathUtil::bits($itemIdBits, 10, 11);

        $itemArr = array($itemId => $itemNum);

        //扣除物品
        $haveState = ItemModule::subItem($userId, $itemArr, "consumeItem");
        if ($haveState == false) {
            Logger::getLogger()->error("consumeItem not have enough itemNum = {$itemNum}");
            $consumeItemReply->setHero(HeroModule::getAllHeroDownInfo($userId, array($sysPlayerHero->getTid())));
            return $consumeItemReply;
        }

        //每一个经验丹可以增加的经验数量
        $eachAddExp = DataModule::lookupDataTable(ITEM_LUA_KEY, "Exp", array($itemId));
        $totalExp = $eachAddExp * $itemNum;

        HeroModule::modifyOneHeroExp($sysPlayerHero, $totalExp, "consumeItem");

        $consumeItemReply->setHero(HeroModule::getAllHeroDownInfo($userId, array($sysPlayerHero->getTid())));

        return $consumeItemReply;
    }
}
 