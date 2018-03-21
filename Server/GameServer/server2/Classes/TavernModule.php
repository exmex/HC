<?php
/**
 * @Author:      jaylu
 * @Date:        2015-01-22 
 * @Description: Description
 * @email:       jay@xxxx.com
 */
require_once($GLOBALS['GAME_ROOT'] . "DbModule/SysPlayerTavern.php");
require_once($GLOBALS['GAME_ROOT'] . "DbModule/SysGlobal.php");
require_once($GLOBALS['GAME_ROOT'] . "DbModule/SysPlayerHero.php");
require_once($GLOBALS['GAME_ROOT'] . "Classes/ParamModule.php");
require_once($GLOBALS['GAME_ROOT'] . "Classes/DataModule.php");;
require_once($GLOBALS['GAME_ROOT'] . "Classes/PlayerModule.php");
require_once($GLOBALS['GAME_ROOT'] . "Classes/HeroModule.php");
require_once($GLOBALS['GAME_ROOT'] . "Classes/TaskModule.php");
require_once($GLOBALS['GAME_ROOT'] . "Classes/VipModule.php");
require_once($GLOBALS['GAME_ROOT'] . "Classes/GlobalModule.php");

class TavernModule{
    /** 初始化天命值 */
    const TAVERN_INIT_FATE = 30;
    const TAVERN_MAX_HERO_NUM = 3;
   /**
    * 紫色箱子的十连抽规则定义 
    * @var array
    */
    private static $purpleBoxHeroDefineArr = array(
        1 => array(1 => 1, 2 => 1, 3 => 0, 'rate' => 0.03),
        2 => array(1 => 1, 2 => 0, 3 => 1, 'rate' => 0.03),
        3 => array(1 => 0, 2 => 1, 3 => 1, 'rate' => 0.04),
        4 => array(1 => 1, 2 => 1, 3 => 1, 'rate' => 0.06),
        5 => array(1 => 1, 2 => 2, 3 => 0, 'rate' => 0.06),
        6 => array(1 => 2, 2 => 1, 3 => 0, 'rate' => 0.14),
        7 => array(1 => 2, 2 => 0, 3 => 1, 'rate' => 0.14),
        8 => array(1 => 3, 2 => 1, 3 => 0, 'rate' => 0.15),
        9 => array(1 => 3, 2 => 0, 3 => 1, 'rate' => 0.15),
        10 => array(1 => 2, 2 => 1, 3 => 1, 'rate' => 0.02),
        11 => array(1 => 2, 2 => 2, 3 => 0, 'rate' => 0.025),
        12 => array(1 => 2, 2 => 0, 3 => 2, 'rate' => 0.005),
        13 => array(1 => 1, 2 => 2, 3 => 1, 'rate' => 0.02),
        14 => array(1 => 1, 2 => 3, 3 => 0, 'rate' => 0.025),
        15 => array(1 => 1, 2 => 1, 3 => 2, 'rate' => 0.005),
        16 => array(1 => 3, 2 => 1, 3 => 1, 'rate' => 0.08),
        17 => array(1 => 2, 2 => 2, 3 => 1, 'rate' => 0.01),
        18 => array(1 => 2, 2 => 1, 3 => 2, 'rate' => 0.01),
    );

    /**
     * 紫色箱子的十连抽规则定义, 活动使用
     * @var array
     */
    private static $purpleBoxHeroDefineActivityArr = array(
        1 => array(1 => 1, 2 => 2, 3 => 0, 'rate' => 0.03),
        2 => array(1 => 1, 2 => 1, 3 => 1, 'rate' => 0.03),
        3 => array(1 => 0, 2 => 2, 3 => 1, 'rate' => 0.04),
        4 => array(1 => 1, 2 => 2, 3 => 1, 'rate' => 0.06),
        5 => array(1 => 1, 2 => 3, 3 => 0, 'rate' => 0.06),
        6 => array(1 => 2, 2 => 2, 3 => 0, 'rate' => 0.14),
        7 => array(1 => 2, 2 => 1, 3 => 1, 'rate' => 0.14),
        8 => array(1 => 3, 2 => 2, 3 => 0, 'rate' => 0.15),
        9 => array(1 => 3, 2 => 1, 3 => 1, 'rate' => 0.15),
        10 => array(1 => 2, 2 => 2, 3 => 1, 'rate' => 0.02),
        11 => array(1 => 2, 2 => 3, 3 => 0, 'rate' => 0.025),
        12 => array(1 => 2, 2 => 1, 3 => 2, 'rate' => 0.005),
        13 => array(1 => 1, 2 => 3, 3 => 1, 'rate' => 0.02),
        14 => array(1 => 1, 2 => 4, 3 => 0, 'rate' => 0.025),
        15 => array(1 => 1, 2 => 2, 3 => 2, 'rate' => 0.005),
        16 => array(1 => 3, 2 => 2, 3 => 1, 'rate' => 0.08),
        17 => array(1 => 2, 2 => 3, 3 => 1, 'rate' => 0.01),
        18 => array(1 => 2, 2 => 2, 3 => 2, 'rate' => 0.01),
    );
    private static $TavernTableCached = array();

    public static function testA(){
        $heroKk_ = self::randomSum(self::$purpleBoxHeroDefineArr);
        echo $heroKk_ . "\r\n";
        $heroNum_ = floor(array_sum(self::$purpleBoxHeroDefineArr[$heroKk_]));
        echo $heroNum_;
    }

    /**
     * 自动初始化每日的活跃灵魂石
     */
    public static function autoInitMagicDaySoul(){
        $timeArr = array(time(), strtotime("+1 day"), strtotime("+2 day"));
        $key = GlobalModule::TAVERN_MAGIC_DAY_SOUL;
        $heroTable = array(
            1 => 1,
            2 => 2,
            3 => 3,
            4 => 4,
            5 => 5,
            6 => 6,
            7 => 7,
            8 => 8,
            9 => 9,
            10 => 10,
            11 => 11,
            12 => 12,
            13 => 13,
            14 => 14,
            15 => 15,
            16 => 16,
            17 => 17,
            18 => 18,
            19 => 19,
            20 => 20,
            21 => 21,
            22 => 22,
            23 => 23,
            25 => 25,
            26 => 26,
            //27 => 27,
            28 => 28,
            29 => 29,
            30 => 30,
            44 => 44,
            45 => 45
        );

        //月最新
        $monthHotSoul = ParamModule::GetTavernMagicMonthSoulId();
        $monthHotHero = HeroModule::getHeroTidFromSoulId($monthHotSoul);
        if (isset($heroTable[$monthHotHero])) {
            unset($heroTable[$monthHotHero]);
        }

        $sqlStr = "INSERT IGNORE INTO `global` (`key`, `day`, `value`)  values ";
        $updateArr_ = array();
        foreach ($timeArr as $time_) {
            $day_ = GlobalModule::getDayFromTimeStamp($time_);
            //随机三种灵魂石
            $randKeyArr_ = array_rand($heroTable, 3);
            $needChipArr = array();
            foreach ($randKeyArr_ as $heroTid) {
                $needChipArr[] = DataModule::lookupDataTable(FRAGMENT_LUA_KEY, "Fragment ID", array($heroTid));
            }

            $chipStr = implode(";", $needChipArr);
            $updateArr_[] = "('{$key}','{$day_}','{$chipStr}')";
        }

        $sqlStr .= implode(",", $updateArr_);
        echo $sqlStr;
        MySQL::getInstance()->RunQuery($sqlStr);
    }


    /**
     * 初始化酒馆数据
     * @param  [type] $userId [description]
     * @return [type]         [description]
     */
    private static function initTavernTable($userId){
        $allTavernTb = array();
        $batch = new SQLBatch();
        $batch->init(SysPlayerTavern::insertSqlHeader(array('user_id', 'box_type', 'left_count', 'last_claim_time', 'free_claim_time', 'first_draw')));

        // init green box
        $tbTavern = new SysPlayerTavern();

        $tbTavern->setUserId($userId);
        $tbTavern->setBoxType(Down_TavernRecord_BoxType::green);
        $tbTavern->setLeftCount(ParamModule::GetTavernBronzeChance());
        $tbTavern->setLastClaimTime(0);
        $tbTavern->setFreeClaimTime(0);
        $tbTavern->setFirstDraw(0);
        $tbTavern->setPayNum(0);

        $batch->add($tbTavern);
        $allTavernTb[] = $tbTavern;

        // init purple box
        $tbTavern = new SysPlayerTavern();

        $tbTavern->setUserId($userId);
        $tbTavern->setBoxType(Down_TavernRecord_BoxType::purple);
        $tbTavern->setLeftCount(ParamModule::GetTavernGoldChance());
        $tbTavern->setLastClaimTime(0);
        $tbTavern->setFreeClaimTime(0);
        $tbTavern->setFirstDraw(0);
        $tbTavern->setPayNum(0);

        $batch->add($tbTavern);
        $allTavernTb[] = $tbTavern;

        $batch->end();
        $batch->save();

        return $allTavernTb;
    }

    /**
     * 初始化魂匣表数据
     *
     * @param $userId
     */
    private static function initMagicSoulTable($userId)
    {
        $tbTavern = new SysPlayerTavern();

        $tbTavern->setUserId($userId);
        $tbTavern->setBoxType(Down_TavernRecord_BoxType::magicsoul);
        if ($tbTavern->LoadedExistFields()) {
            return $tbTavern;
        }

        $tbTavern->setLeftCount(ParamModule::GetTavernMagicChance());
        $tbTavern->setLastClaimTime(0);
        $tbTavern->setFreeClaimTime(0);
        $tbTavern->setFirstDraw(0);
        $tbTavern->setPayNum(0);
        $tbTavern->inOrUp();

        return $tbTavern;
    }

    /**
     * 获取用户的酒馆数据
     *
     * @param $userId
     * @return array
     */
    public static function getTavernTable($userId){
        if (count(self::$TavernTableCached) > 0) {
            return self::$TavernTableCached;
        }

        $where = "`user_id` = '{$userId}' and box_type in (1,3)";
        $allTavernTb = SysPlayerTavern::loadedTable(null, $where);
        if (count($allTavernTb) <= 0) {
            $allTavernTb = self::initTavernTable($userId);
        }
        $tbTavern = self::initMagicSoulTable($userId);
        $allTavernTb[] = $tbTavern;
        //判断是否跨天，需要重置次数
        foreach ($allTavernTb as $kk => $tbPlayerTavern) {

            //绿色箱子，每日重置5次
            if ($tbPlayerTavern->getBoxType() == Up_TavernDraw_BoxType::green && $tbPlayerTavern->getLeftCount() < ParamModule::GetTavernBronzeChance() && SQLUtil::isTimeNeedReset($tbPlayerTavern->getFreeClaimTime())) {
                $tbPlayerTavern->setLeftCount(ParamModule::GetTavernBronzeChance());
                $tbPlayerTavern->inOrUp();
                $allTavernTb[$kk] = $tbPlayerTavern;
            }

            //紫色箱子,CD结束后再重置
            if ($tbPlayerTavern->getBoxType() == Up_TavernDraw_BoxType::purple && $tbPlayerTavern->getLeftCount() < ParamModule::GetTavernGoldChance()) {
                //判断CD时间是否已经结束
                if (($tbPlayerTavern->getFreeClaimTime() + ParamModule::GetTavernGoldCd()) <= time()) {
                    $tbPlayerTavern->setLeftCount(ParamModule::GetTavernGoldChance());
                    $tbPlayerTavern->inOrUp();
                    $allTavernTb[$kk] = $tbPlayerTavern;
                }
            }

            //神秘魂匣箱子,CD结束后再重置
            if ($tbPlayerTavern->getBoxType() == Up_TavernDraw_BoxType::magicsoul && $tbPlayerTavern->getLeftCount() < ParamModule::GetTavernMagicChance()) {
                //判断CD时间是否已经结束
                if (($tbPlayerTavern->getFreeClaimTime() + ParamModule::GetTavernMagicCd()) <= time()) {
                    $tbPlayerTavern->setLeftCount(ParamModule::GetTavernMagicChance());
                    $tbPlayerTavern->inOrUp();
                    $allTavernTb[$kk] = $tbPlayerTavern;
                }
            }
        }

        self::$TavernTableCached = $allTavernTb;

        return self::$TavernTableCached;
    }

    /**
     * 返回用户的酒馆数据到客户端
     *
     * @param $userId
     * @return array
     */
    public static function getAllTavernDownInfo($userId)
    {
        $allTb = self::getTavernTable($userId);

        $allTavernDown = array();

        /** @var TbPlayerTavern $tbTavern */
        foreach ($allTb as $tbTavern) {
            $downTavern = new Down_TavernRecord();
            $downTavern->setBoxType($tbTavern->getBoxType());
            $downTavern->setLeftCnt($tbTavern->getLeftCount());
            $downTavern->setLastGetTime($tbTavern->getFreeClaimTime());
            $downTavern->setHasFirstDraw($tbTavern->getFirstDraw());
            $allTavernDown[] = $downTavern;
        }
        return $allTavernDown;
    }

    /**
     * 获取指定颜色类型的箱子数据
     *
     * @param $userId
     * @param $boxId
     * @return TbPlayerTavern
     */
    private static function getTavernTableInfoByBoxId($userId, $boxId)
    {
        $tavernInfo = new SysPlayerTavern();

        $allTb = self::getTavernTable($userId);

        /** @var TbPlayerTavern $tbTavern */
        foreach ($allTb as $tbTavern) {
            if ($tbTavern->getBoxType() == $boxId) {
                $tavernInfo = $tbTavern;
                break;
            }
        }

        return $tavernInfo;
    }

    /**
     * 根据随机数生成比例规则来获取最终生成数的所在区间
     *
     * @param array $arr 比例或权值规则
     * @param array $exludeArr 要排除参与随机抽取的元素键值
     * @return int
     */
    private static function randomSum($arr, $exludeArr = array())
    {
        //对所有数字放大100倍
        $balance = 1000;

        //排除已经抽取过的数据
        if (count($exludeArr) > 0) {
            for ($i = 0; $i < count($exludeArr); $i++) {
                if (isset ($arr[$exludeArr[$i]])) {
                    unset ($arr[$exludeArr[$i]]);
                }
            }
        }

        $maxNum = 0;
        foreach ($arr as $vv) {
            $maxNum += $vv['rate'];
        }

        $num = mt_rand(1, $maxNum * $balance);
        $finalNum = $num / $balance;

        $value = 0;
        $index = 0;
        foreach ($arr as $index => $vv) {
            $value += $vv['rate'];
            if ($finalNum <= $value) {
                break;
            }
        }

        return $index;
    }

    public static function tavernDrawTestPurpleTen()
    {
        $returnArr = array(1 => 0, 2 => 0, 3 => 0, 4 => 0);

        $rewardArr = array();

        $heroTableOrg = DataModule::getInstance()->getDataSetting(HERO_UNIT_LUA_KEY);
        //遍历能招募的武将
        $heroTable = array();
        foreach ($heroTableOrg as $k2 => $hero2_) {
            if ($k2 > 0 && $k2 <= 100) {
                $heroTable[$k2] = $hero2_;
            }
        }

        $day = date("z");
        if ($day % 2 == 0) {
            $itemTable = DataModule::getInstance()->lookupDataTable(ITEM_GROUPS_LUA_KEY, 102);
        } else {
            $itemTable = DataModule::getInstance()->lookupDataTable(ITEM_GROUPS_LUA_KEY, 103);
        }


        //抽取出武将的规则来
        $heroKk_ = self::randomSum(self::$purpleBoxHeroDefineArr);
        $chooseDefineArr = self::$purpleBoxHeroDefineArr[$heroKk_];
        $heroNum_ = floor(array_sum($chooseDefineArr));

        $randomHeroArr = array();
        $randomItemArr = array();
        foreach ($itemTable as $item__) {
            if ($item__['type'] == "item") {
                $randomItemArr[] = $item__;
            } elseif ($item__['type'] == "hero") {
                $randomHeroArr[$heroTable[$item__['id']]['Initial Stars']][] = $item__;
            }
        }

        foreach ($chooseDefineArr as $star_ => $num_) {
            if ($num_ > 0 && isset($randomHeroArr[$star_])) {
                $excludeHeroArr_ = array();
                for ($pp = 0; $pp < $num_; $pp++) {
                    $itemKk_ = self::randomSum($randomHeroArr[$star_], $excludeHeroArr_);
                    $rewardArr['hero'][] = $randomHeroArr[$star_][$itemKk_]['id'];

                    $excludeHeroArr_[] = $itemKk_;
                }
            }
        }

        $itemNum_ = 10 - $heroNum_;


        foreach ($rewardArr['hero'] as $heroId_) {
            $returnArr[$heroTable[$heroId_]['Initial Stars']] += 1;
        }

        return $heroKk_;
    }


    public static function tavernDrawTest2()
    {

        $boxKey = 101;
        $today = date("Ymd");
        $dailyActivity = DataModule::lookupDataTable(DAILY_ACTIVITY_LUA_KEY, "tavern");


        if (!empty($dailyActivity) && isset($dailyActivity['green']) && isset($dailyActivity['green'][$today])) {
            $boxKey = $dailyActivity['green'][$today];
            $isActivity = true;
        }
        echo "green box key: {$boxKey}  \r\n";

        $itemTable = DataModule::getInstance()->lookupDataTable(ITEM_GROUPS_LUA_KEY, $boxKey);

        for ($i = 1; $i <= 10000; $i++) {
            $itemKk_ = self::randomSum($itemTable);
            if ($itemTable[$itemKk_]['type'] == "item") {
                $rewardArr['item'][] = array("itemId" => $itemTable[$itemKk_]['id'], "itemNum" => $itemTable[$itemKk_]['amout']);
            } elseif ($itemTable[$itemKk_]['type'] == "hero") {
                $rewardArr['hero'][] = $itemTable[$itemKk_]['id'];
            }
        }

        if (isset($rewardArr['hero'])) {
            $heroNum = count($rewardArr['hero']);
            echo "green box hero: {$heroNum}  \r\n";
        }


        $rewardArr = array();
        if (!empty($dailyActivity) && isset($dailyActivity['purple']) && isset($dailyActivity['purple'][$today])) {
            $boxKey = $dailyActivity['purple'][$today];
            $isActivity = true;
        } else {
            $day = date("z");
            if ($day % 2 == 0) {
                $boxKey = 102;
            } else {
                $boxKey = 103;
            }
        }

        echo "purple box key: {$boxKey}  \r\n";

        $itemTable = DataModule::getInstance()->lookupDataTable(ITEM_GROUPS_LUA_KEY, $boxKey);
        $randomArr_ = $itemTable;

        for ($i = 1; $i <= 10000; $i++) {
            $itemKk_ = self::randomSum($randomArr_);
            if (isset($randomArr_[$itemKk_]['Unit Type'])) {
                $rewardArr['hero'][] = $randomArr_[$itemKk_]['ID'];
            } elseif ($randomArr_[$itemKk_]['type'] == "item") {
                $rewardArr['item'][] = array("itemId" => $randomArr_[$itemKk_]['id'], "itemNum" => $randomArr_[$itemKk_]['amout']);
            } elseif ($randomArr_[$itemKk_]['type'] == "hero") {
                $rewardArr['hero'][] = $randomArr_[$itemKk_]['id'];
            }
        }


        if (isset($rewardArr['hero'])) {
            $heroNum = count($rewardArr['hero']);
            echo "purple box hero: {$heroNum}  \r\n";
        }


    }

    public static function tavernDraw($userId, $boxType, $drawType){
        if (empty($boxType)) {
            $boxType = Up_TavernDraw_BoxType::green;
        }

        if (empty($drawType)) {
            $drawType = Up_TavernDraw_DrawType::single;
        }

        $cost = 0; //消耗的货币数量
        $costType = "coin";
        $cdTime = 0;
        $drawKey_ = "Bronze";

        if ($boxType == Up_TavernDraw_BoxType::green) {
            $cdTime = ParamModule::GetTavernBronzeCd();
            $costType = "coin";
            $drawKey_ = "Bronze";
        } elseif ($boxType == Up_TavernDraw_BoxType::purple) {
            $cdTime = ParamModule::GetTavernGoldCd();
            $costType = "gems";
            $drawKey_ = "Gold";
        } elseif ($boxType == Up_TavernDraw_BoxType::magicsoul) {
            $cdTime = ParamModule::GetTavernMagicCd();
            $costType = "gems";
            $drawKey_ = "MagicSoul";
        }

        $dailyActivity = DataModule::lookupDataTable(DAILY_ACTIVITY_LUA_KEY, "tavern");
        $today = date("Ymd");

        $fireNum_ = 1;

        $isTen_ =($drawType == Up_TavernDraw_DrawType::single) ? "false" : "true";

        $drawDefineDataArr = DataModule::lookupDataTable(TAVERN_TYPE_KEY, 0, array($drawKey_, $isTen_, "false"));

        if (empty($drawDefineDataArr)) {
            Logger::getLogger()->error("tavernDraw Failed to load lua" . __LINE__);
            return null;
        }
        $tbPlayerTavern = self::getTavernTableInfoByBoxId($userId, $boxType);

        $oneDrawNum = MathUtil::bits($tbPlayerTavern->getFirstDraw(), 16, 16);
        $tenDrawNum = MathUtil::bits($tbPlayerTavern->getFirstDraw(), 0, 16);

        $rewardArr = array();

        //所有物品的定义表
        $allItemTable = DataModule::getInstance()->getDataSetting(ITEM_LUA_KEY);
        $heroTableOrg = DataModule::getInstance()->getDataSetting(HERO_UNIT_LUA_KEY);
        //遍历能招募的武将
        $heroTable = array();
        foreach ($heroTableOrg as $k2 => $hero2_) {
            if ($k2 > 0 && $k2 <= 100) {
                if (!isset($hero2_['rate'])) {
                    $hero2_['rate'] = 100;
                }
                $heroTable[$k2] = $hero2_;
            }
        }
        $isActivity = false; //是否在活动期间

        //绿色箱子
        if ($boxType == Up_TavernDraw_BoxType::green) { //绿箱子
            $boxKey = 101;
            if (!empty($dailyActivity) && isset($dailyActivity['green']) && isset($dailyActivity['green'][$today])) {
                $boxKey = $dailyActivity['green'][$today];
                $isActivity = true;
            }
            $itemTable = DataModule::getInstance()->lookupDataTable(ITEM_GROUPS_LUA_KEY, $boxKey);
            //限時免費抽獎  
            if ($drawType == Up_TavernDraw_DrawType::single && $tbPlayerTavern->getLeftCount() > 0 && ($tbPlayerTavern->getFreeClaimTime() + $cdTime) <= time()) { //判断是否是免费的
                $cost = 0;
                $tbPlayerTavern->setLeftCount($tbPlayerTavern->getLeftCount() - 1);
                $tbPlayerTavern->setFreeClaimTime(time());
                if ($oneDrawNum == 0) { //首次给火女
                    $rewardArr['hero'][] = 3;
                } elseif ($oneDrawNum == 1) { //再次抽取给小鹿的灵魂石
                    $rewardArr['item'][] = array("itemId" => 157, "itemNum" => 1);
                } else { //随机一个物品
                    $itemKk_ = self::randomSum($itemTable);
                    if ($itemTable[$itemKk_]['type'] == "item") {
                        $rewardArr['item'][] = array("itemId" => $itemTable[$itemKk_]['id'], "itemNum" => $itemTable[$itemKk_]['amout']);
                    } elseif ($itemTable[$itemKk_]['type'] == "hero") {
                        $rewardArr['hero'][] = $itemTable[$itemKk_]['id'];
                    }
                }

                $oneDrawNum++;
            } elseif ($drawType == Up_TavernDraw_DrawType::single) { //单次付费
                $randomGroup = $drawDefineDataArr["Chest Group ID"];
                $cost = $drawDefineDataArr['Cost'];
                //判断钱或金币数据
                $tbPlayer = PlayerModule::getPlayerTable($userId);
                if ($costType == "coin") {
                    if ($tbPlayer->getMoney() < $cost) {
                        Logger::getLogger()->error("tavernDraw no enough money, need {$cost}, have {$tbPlayer->getMoney()} " . __LINE__);
                        return null;
                    }
                }
                if ($costType == "gems") {
                    if ($tbPlayer->getGem() < $cost) {
                        Logger::getLogger()->error("tavernDraw no enough gems, need {$cost}, have {$tbPlayer->getMoney()} " . __LINE__);
                        return null;
                    }
                }
                //*******判断钱或金币数据********//                
                if ($oneDrawNum == 1) { //再次抽取给小鹿的灵魂石
                    $rewardArr['item'][] = array("itemId" => 157, "itemNum" => 1);
                } else {
                    $itemKk_ = self::randomSum($itemTable);
                    if ($itemTable[$itemKk_]['type'] == "item") {
                        $rewardArr['item'][] = array("itemId" => $itemTable[$itemKk_]['id'], "itemNum" => $itemTable[$itemKk_]['amout']);
                    } elseif ($itemTable[$itemKk_]['type'] == "hero") {
                        $rewardArr['hero'][] = $itemTable[$itemKk_]['id'];
                    }
                }
                $oneDrawNum++;
                $tbPlayerTavern->setPayNum($tbPlayerTavern->getPayNum() + 1);

            } else { //十连抽付费
                $randomGroup = $drawDefineDataArr["Chest Group ID"];
                $cost = $drawDefineDataArr['Cost'];
                //判断钱或金币数据
                $tbPlayer = PlayerModule::getPlayerTable($userId);
                if ($costType == "coin") {
                    if ($tbPlayer->getMoney() < $cost) {
                        Logger::getLogger()->error("tavernDraw no enough money, need {$cost}, have {$tbPlayer->getMoney()} " . __LINE__);
                        return null;
                    }
                }
                if ($costType == "gems") {
                    if ($tbPlayer->getGem() < $cost) {
                        Logger::getLogger()->error("tavernDraw no enough gems, need {$cost}, have {$tbPlayer->getMoney()} " . __LINE__);
                        return null;
                    }
                }
                //*******判断钱或金币数据********//                 
                //必得蓝装
                $randomArr_ = array();
                foreach ($itemTable as $item__) {
                    if ($item__['type'] == "item") {
                        if (isset($allItemTable[$item__['id']]) && isset($allItemTable[$item__['id']]['Quality']) && $allItemTable[$item__['id']]['Quality'] == 3) {
                            $randomArr_[] = $item__;
                        }
                    }
                }

                $itemKk_ = self::randomSum($randomArr_);
                if ($randomArr_[$itemKk_]['type'] == "item") {
                    $rewardArr['item'][] = array("itemId" => $randomArr_[$itemKk_]['id'], "itemNum" => $randomArr_[$itemKk_]['amout']);
                } elseif ($randomArr_[$itemKk_]['type'] == "hero") {
                    $rewardArr['hero'][] = $randomArr_[$itemKk_]['id'];
                }

                //再随机九个物品
                for ($num = 0; $num < 9; $num++) {
                    $itemKk_ = self::randomSum($itemTable);
                    if ($itemTable[$itemKk_]['type'] == "item") {
                        $rewardArr['item'][] = array("itemId" => $itemTable[$itemKk_]['id'], "itemNum" => $itemTable[$itemKk_]['amout']);
                    } elseif ($itemTable[$itemKk_]['type'] == "hero") {
                        $rewardArr['hero'][] = $itemTable[$itemKk_]['id'];
                    }
                }

                $tenDrawNum++;
                $tbPlayerTavern->setPayNum($tbPlayerTavern->getPayNum() + 1);
                $fireNum_ = 10;
            }
        }

        //紫色箱子
        if ($boxType == Up_TavernDraw_BoxType::purple) { //紫箱子
            if (!empty($dailyActivity) && isset($dailyActivity['purple']) && isset($dailyActivity['purple'][$today])) {
                $boxKey = $dailyActivity['purple'][$today];
                $isActivity = true;
            } else {
                $day = date("z");
                if ($day % 2 == 0) {
                    $boxKey = 102;
                } else {
                    $boxKey = 103;
                }
            }

            $itemTable = DataModule::getInstance()->lookupDataTable(ITEM_GROUPS_LUA_KEY, $boxKey);
            if ($drawType == Up_TavernDraw_DrawType::single && $tbPlayerTavern->getLeftCount() > 0 && ($tbPlayerTavern->getFreeClaimTime() + $cdTime) <= time()) { //判断是否是免费的
                $cost = 0;
                $tbPlayerTavern->setLeftCount($tbPlayerTavern->getLeftCount() - 1);
                $tbPlayerTavern->setFreeClaimTime(time());
                if ($oneDrawNum == 0) { //首次给小黑
                    $rewardArr['hero'][] = 2;
                } elseif ($oneDrawNum == 1) { //首次付费gems抽取必给三星将
                    //付费首抽从这几个中间抽取风行,电魂,斧王,骨弓,痛苦女王
                    $randomArr_ = array();
                    foreach ($heroTable as $hero_) {
                        if ($hero_['ID'] == 11 || $hero_['ID'] == 5 || $hero_['ID'] == 28 || $hero_['ID'] == 17 || $hero_['ID'] == 7) {
                            $randomArr_[] = $hero_;
                        }
                    }
                    $itemKk_ = self::randomSum($randomArr_);
                    $rewardArr['hero'][] = $randomArr_[$itemKk_]['ID'];
                } else { //随机一个物品
                    $itemKk_ = self::randomSum($itemTable);
                    if ($itemTable[$itemKk_]['type'] == "item") {
                        $rewardArr['item'][] = array("itemId" => $itemTable[$itemKk_]['id'], "itemNum" => $itemTable[$itemKk_]['amout']);
                    } elseif ($itemTable[$itemKk_]['type'] == "hero") {
                        $rewardArr['hero'][] = $itemTable[$itemKk_]['id'];
                    }
                }

                $oneDrawNum++;
            } elseif ($drawType == Up_TavernDraw_DrawType::single) { //单次付费
                $randomGroup = $drawDefineDataArr["Chest Group ID"];
                $cost = $drawDefineDataArr['Cost'];
                $randomArr_ = array();
                if ($oneDrawNum == 1) { //首次付费gems抽取必给三星将
                    //付费首抽从这几个中间抽取风行,电魂,斧王,骨弓,痛苦女王
                    foreach ($heroTable as $hero_) {
                        if ($hero_['ID'] == 11 || $hero_['ID'] == 5 || $hero_['ID'] == 28 || $hero_['ID'] == 17 || $hero_['ID'] == 7) {
                            $randomArr_[] = $hero_;
                        }
                    }
                } else {
                    //有几率获得武将
                    $randomArr_ = $itemTable;
                }
                $itemKk_ = self::randomSum($randomArr_);
                if (isset($randomArr_[$itemKk_]['Unit Type'])) {
                    $rewardArr['hero'][] = $randomArr_[$itemKk_]['ID'];
                } elseif ($randomArr_[$itemKk_]['type'] == "item") {
                    $rewardArr['item'][] = array("itemId" => $randomArr_[$itemKk_]['id'], "itemNum" => $randomArr_[$itemKk_]['amout']);
                } elseif ($randomArr_[$itemKk_]['type'] == "hero") {
                    $rewardArr['hero'][] = $randomArr_[$itemKk_]['id'];
                }
                $oneDrawNum++;
                $tbPlayerTavern->setPayNum($tbPlayerTavern->getPayNum() + 1);

            } else { //十连抽付费
                $randomGroup = $drawDefineDataArr["Chest Group ID"];
                $cost = $drawDefineDataArr['Cost'];
                //抽取出武将的规则来
                if ($isActivity) {
                    $heroKk_ = self::randomSum(self::$purpleBoxHeroDefineActivityArr);
                    $chooseDefineArr = self::$purpleBoxHeroDefineActivityArr[$heroKk_];
                } else {
                    $heroKk_ = self::randomSum(self::$purpleBoxHeroDefineArr);
                    $chooseDefineArr = self::$purpleBoxHeroDefineArr[$heroKk_];
                }

                $heroNum_ = floor(array_sum($chooseDefineArr));

                $randomHeroArr = array();
                $randomItemArr = array();
                foreach ($itemTable as $item__) {
                    if ($item__['type'] == "item") {
                        $randomItemArr[] = $item__;
                    } elseif ($item__['type'] == "hero") {
                        $randomHeroArr[$heroTable[$item__['id']]['Initial Stars']][] = $item__;
                    }
                }

                foreach ($chooseDefineArr as $star_ => $num_) {
                    if ($num_ > 0 && isset($randomHeroArr[$star_])) {
                        $excludeHeroArr_ = array();
                        for ($pp = 0; $pp < $num_; $pp++) {
                            $itemKk_ = self::randomSum($randomHeroArr[$star_], $excludeHeroArr_);
                            $rewardArr['hero'][] = $randomHeroArr[$star_][$itemKk_]['id'];

                            $excludeHeroArr_[] = $itemKk_;
                        }
                    }
                }

                $itemNum_ = 10 - $heroNum_;
                //先随机10个物品 如果发现没有抽取到大于一星武将,后面则替换一组数据
                $isSelectBestHero = true;
                //抽到的武将数组
                $chooseHeroArr_ = array();
                //抽到的物品总数量
                $chooseAllNum_ = 0;
                while ($chooseAllNum_ < $itemNum_) {
                    $itemKk_ = self::randomSum($randomItemArr);
                    if ($randomItemArr[$itemKk_]['type'] == "item") {
                        $rewardArr['item'][] = array("itemId" => $randomItemArr[$itemKk_]['id'], "itemNum" => $randomItemArr[$itemKk_]['amout']);
                    }
                    $chooseAllNum_ += 1;
                }
                if (!$isSelectBestHero) { //没有抽取到好的武将
                    //剔除多抽取的一组数据
                    array_pop($rewardArr['item']);
                    $randomArr_ = array();
                    if ($tenDrawNum == 0 && $oneDrawNum == 1) { //首次付费gems抽取必给三星将
                        //付费首抽从这几个中间抽取风行,电魂,斧王,骨弓,痛苦女王
                        foreach ($heroTable as $hero_) {
                            if ($hero_['ID'] == 11 || $hero_['ID'] == 5 || $hero_['ID'] == 28 || $hero_['ID'] == 17 || $hero_['ID'] == 7) {
                                $randomArr_[] = $hero_;
                            }
                        }
                    } else {
                        //必得大于一星武将
                        foreach ($itemTable as $item__) {
                            if ($item__['type'] == "hero" && $heroTable[$item__['id']]['Initial Stars'] > 1) {
                                $randomArr_[] = $item__;
                            }
                        }
                    }

                    $itemKk_ = self::randomSum($randomArr_);
                    if (isset($randomArr_[$itemKk_]['Unit Type'])) {
                        $rewardArr['hero'][] = $randomArr_[$itemKk_]['ID'];
                    } elseif ($randomArr_[$itemKk_]['type'] == "item") {
                        $rewardArr['item'][] = array("itemId" => $randomArr_[$itemKk_]['id'], "itemNum" => $randomArr_[$itemKk_]['amout']);
                    } elseif ($randomArr_[$itemKk_]['type'] == "hero") {
                        $rewardArr['hero'][] = $randomArr_[$itemKk_]['id'];
                    }
                }

                $tenDrawNum++;
                $tbPlayerTavern->setPayNum($tbPlayerTavern->getPayNum() + 1);

                $fireNum_ = 10;
            }
        }

        //神秘魂匣宝箱
        if ($boxType == Up_TavernDraw_BoxType::magicsoul) {
            $vipState = VipModule::getVIPModuleLimitByUserId($userId, _VIP_MODULE_TYPE::MAGIC_SOUL_BOX);
            if (empty($vipState)) {
                Logger::getLogger()->error("box draw magicsoul VIP not enough!");
                return null;
            }

            //可以抽取的灵魂石
            $randomSoulArr = array();
            
            //日活跃
            $soulStr = GlobalModule::getGlobalData(GlobalModule::TAVERN_MAGIC_DAY_SOUL);
            if ( !empty($soulStr) )
            {
                $randomSoulArr = explode ( ";", $soulStr );
            }
            else
            {
                Logger::getLogger()->error('global config for magic soul not found!');
            }

            //月最新
            $monthHotSoul = ParamModule::GetTavernMagicMonthSoulId();
            $monthHotHero = HeroModule::getHeroTidFromSoulId($monthHotSoul);

            //月度最新是否与已保存的天命id相同
            if ($tbPlayerTavern->getFateId() != $monthHotSoul) {
                $tbPlayerTavern->setFate(self::TAVERN_INIT_FATE);
                $tbPlayerTavern->setFateId($monthHotSoul);
            }

            if ($tbPlayerTavern->getFate() < self::TAVERN_INIT_FATE) {
                $tbPlayerTavern->setFate(self::TAVERN_INIT_FATE);
            }

            if ($tbPlayerTavern->getDoubleRate() < 10) {
                $tbPlayerTavern->setDoubleRate(10);
            }

            //判断有没有招募到月度武将
            $isCanGetHero = false;
            $tbPlayerHero = new SysPlayerHero();
            $tbPlayerHero->setUserId($userId);
            $tbPlayerHero->setTid($monthHotHero);
            if ($tbPlayerHero->LoadedExistFields()) {
                $isCanGetHero = false;
                $randomSoulArr[] = $monthHotSoul;
            } else {
                $isCanGetHero = true;
            }

            //已经获得的物品数量
            $getItemNum = 0;
            if ($tbPlayerTavern->getLeftCount() > 0 && ($tbPlayerTavern->getFreeClaimTime() + $cdTime) <= time()) { //判断是否是免费的
                $cost = 0;
                $tbPlayerTavern->setLeftCount($tbPlayerTavern->getLeftCount() - 1);
                $tbPlayerTavern->setFreeClaimTime(time());

                //免费抽取，不会获得英雄卡片，除非天运值达到100
                if ($tbPlayerTavern->getFate() == 100 && $isCanGetHero == true) {
                    $rewardArr['hero'][] = $monthHotHero;
                    $tbPlayerTavern->setFate(self::TAVERN_INIT_FATE);
                } else {
                    //免费抽取，只能获得一组英雄魂石
                    $indexKey_ = array_rand($randomSoulArr);
                    $getSoul = $randomSoulArr[$indexKey_];
                    $soulNum = rand(3, 8);
                    $rewardArr['item'][] = array("itemId" => $getSoul, "itemNum" => $soulNum);
                    $tbPlayerTavern->setFate($tbPlayerTavern->getFate() + 5);
                }

                $getItemNum = 1;

                $tenDrawNum++;
            } else {
                //付费
                $randomGroup = $drawDefineDataArr["Chest Group ID"];
                $cost = $drawDefineDataArr['Cost'];
                //出英雄卡片的几率=（天运值- 40）% （负值取0）
                $heroFateRate = max(0, $tbPlayerTavern->getFate() - 40);
                $getHeroRate = rand(0, 99);

                if (($tbPlayerTavern->getFate() == 100 || $getHeroRate < $heroFateRate) && $isCanGetHero == true) {
                    $rewardArr['hero'][] = $monthHotHero;
                    $tbPlayerTavern->setFate(self::TAVERN_INIT_FATE);
                } else {
                    $indexKey_ = array_rand($randomSoulArr);
                    $getSoul = $randomSoulArr[$indexKey_];
                    $soulNum = rand(3, 8);
                    if ($soulNum == 7) {
                        $soulNum = 8;
                    }
                    $rewardArr['item'][] = array("itemId" => $getSoul, "itemNum" => $soulNum);
                    $randomFate = rand(5, 9);
                    $tbPlayerTavern->setFate($tbPlayerTavern->getFate() + $randomFate);
                }

                $getItemNum = 1;

                //10%几率出第2组灵魂石，数量为3~4个（几率自加，例如本次没出2组则下次出现几率20%）
                $getDoubleRate = rand(0, 99);
                if ($getDoubleRate < $tbPlayerTavern->getDoubleRate()) {
                    $indexKey_ = array_rand($randomSoulArr);
                    $getSoul = $randomSoulArr[$indexKey_];
                    $soulNum = rand(3, 4);
                    $rewardArr['item'][] = array("itemId" => $getSoul, "itemNum" => $soulNum);
                    $tbPlayerTavern->setDoubleRate(10);
                    $getItemNum = 2;
                } else {
                    $tbPlayerTavern->setDoubleRate($tbPlayerTavern->getDoubleRate() + 10);
                }

                $tenDrawNum++;
                $tbPlayerTavern->setPayNum($tbPlayerTavern->getPayNum() + 1);
            }

            //其他格子用“经验奶酪”“零件”“核心”“虚空尘埃”“微光粉尘”来填充
            $fillArr = array(290, 384, 372, 368, 369);
            shuffle($fillArr);
            for ($get_ = $getItemNum; $get_ < 6; $get_++) {
                $fillItem_ = array_pop($fillArr);
                $rewardArr['item'][] = array("itemId" => $fillItem_, "itemNum" => 1);
            }

            if ($tbPlayerTavern->getFate() > 100) {
                $tbPlayerTavern->setFate(100);
            }

        }

        //星际商人
        if ($drawType == Up_TavernDraw_DrawType::stone && ($boxType == Up_TavernDraw_BoxType::stone_green || $boxType == Up_TavernDraw_BoxType::stone_blue || $boxType == Up_TavernDraw_BoxType::stone_purple)) {

            //验证星际商人商店的开启情况
            /** @var TbPlayerShop $tbPlayerShop */
            $tbPlayerShop = ShopModule::getCurrentPlayerShop($userId, 6);
            if (!$tbPlayerShop) {
                Logger::getLogger()->error("tavernDraw stone_green no open shop " . __LINE__);
                return null;
            }

            if (($tbPlayerShop->getExpireTime() + 100) < time()) {
                Logger::getLogger()->error("tavernDraw stone_green shop is closed " . __LINE__);
                return null;
            }

            //验证消耗灵魂石
            $needSoulId = intval($tbPlayerShop->getCurGoods());
            if ($needSoulId <= 0) {
                Logger::getLogger()->error("tavernDraw stone_green shop no have enough soul " . __LINE__);
                return null;
            }

            $needSoulNum = ShopModule::STAR_SOUL_STONE_GREEN;
            $startGroupIndex = 111;
            $endGroupIndex = 116;
            if ($boxType == Up_TavernDraw_BoxType::stone_green) {
                $needSoulNum = ShopModule::STAR_SOUL_STONE_GREEN;
                //物品组 111~116
                $startGroupIndex = 111;
                $endGroupIndex = 116;
            } elseif ($boxType == Up_TavernDraw_BoxType::stone_blue) {
                $needSoulNum = ShopModule::STAR_SOUL_STONE_BLUE;
                //物品组 121~126
                $startGroupIndex = 121;
                $endGroupIndex = 126;
            } elseif ($boxType == Up_TavernDraw_BoxType::stone_purple) {
                $needSoulNum = ShopModule::STAR_SOUL_STONE_PURPLE;
                //物品组 131~136
                $startGroupIndex = 131;
                $endGroupIndex = 136;
            }

            $soulArr[$needSoulId] = $needSoulNum;
            $state = ItemModule::subItem($userId, $soulArr, "tavernDraw_starStone");
            if (!$state) {
                Logger::getLogger()->error("tavernDraw stone_green shop no have enough soul " . __LINE__);
                return null;
            }

            $fireNum_ = 0;

            //获取对应物品组 随机物品
            for ($index_ = $startGroupIndex; $index_ <= $endGroupIndex; $index_++) {
                $itemTable = DataModule::getInstance()->lookupDataTable(ITEM_GROUPS_LUA_KEY, $index_);
                $itemKk_ = self::randomSum($itemTable);
                if ($itemTable[$itemKk_]['type'] == "item") {
                    $rewardArr['item'][] = array("itemId" => $itemTable[$itemKk_]['id'], "itemNum" => $itemTable[$itemKk_]['amout']);
                } elseif ($itemTable[$itemKk_]['type'] == "hero") {
                    $rewardArr['hero'][] = $itemTable[$itemKk_]['id'];
                }
            }

        }

        //统一消费处理
        if ($cost > 0) {
            $tbPlayer = PlayerModule::getPlayerTable($userId);
            if ($costType == "coin") {
                if ($tbPlayer->getMoney() < $cost) {
                    Logger::getLogger()->error("tavernDraw no enough money, need {$cost}, have {$tbPlayer->getMoney()} " . __LINE__);
                    return null;
                }
                PlayerModule::modifyMoney($userId, -$cost, "tavernDraw");
            }
            if ($costType == "gems") {
                if ($tbPlayer->getGem() < $cost) {
                    Logger::getLogger()->error("tavernDraw no enough gems, need {$cost}, have {$tbPlayer->getMoney()} " . __LINE__);
                    return null;
                }

                PlayerModule::modifyGem($userId, -$cost, "tavernDraw");
            }
        }
        //更新每日任务
        for ($pp = 0; $pp < $fireNum_; $pp++) {
            TaskModule::updateDailyTaskProgress($userId, DAILY_TASK_TAVERN_GROUP_USE);
        }
        if (count($rewardArr) > 0) { //发送奖励
            //记录下物品 进行debug
            if ($drawType == 1) {
                Logger::getLogger()->debug("tavernDraw_getReward::" . print_r($rewardArr, true));
            }
            //遍历一下,武将如果被招募则变更为对应的灵魂石,并且合并物品
            $addItemArr = array();
            $addHeroArr = array();
            $allHero = HeroModule::getAllHeroTable($userId);
            foreach ($rewardArr as $key => $addArr) {
                if ($key == "item") {
                    foreach ($addArr as $itemIdArr) {
                        if (isset($addItemArr[$itemIdArr['itemId']])) {
                            $addItemArr[$itemIdArr['itemId']] += $itemIdArr['itemNum'];
                        } else {
                            $addItemArr[$itemIdArr['itemId']] = $itemIdArr['itemNum'];
                        }
                    }
                }
                if ($key == "hero") {
                    foreach ($addArr as $key2 => $heroTid) {
                        //判断武将是否已经招募
                        if (isset($allHero[$heroTid])) { //此武将已经被招募转化为对应的灵魂石
                            $heroDefineArr = self::getHeroDefine($heroTid, $heroTable);
                            if (!empty($heroDefineArr)) {
                                //获取武将初始星级,
                                $initStar = isset($heroDefineArr['Initial Stars']) ? $heroDefineArr['Initial Stars'] : 1;
                                $soulNum = DataModule::lookupDataTable(HERO_STAR_LUA_KEY, "Convert Fragments", array($initStar));
                                //获取对应的灵魂石ID
                                $needChipTid = DataModule::lookupDataTable(FRAGMENT_LUA_KEY, "Fragment ID", array($heroTid));
                                $rewardArr['item'][] = array("itemId" => $needChipTid, "itemNum" => $soulNum);
                                if (isset($addItemArr[$needChipTid])) {
                                    $addItemArr[$needChipTid] += $soulNum;
                                } else {
                                    $addItemArr[$needChipTid] = $soulNum;
                                }
                            }

                            unset($rewardArr[$key][$key2]);
                        } else {
                            $addHeroArr[] = $heroTid;
                        }
                    }

                }
            }
            //批量添加物品
            ItemModule::addItem($userId, $addItemArr, "tavernDraw");
            //增加英雄
            foreach ($addHeroArr as $heroTid_) {
                HeroModule::addPlayerHero($userId, $heroTid_, "tavernDraw");
            }
        }
        //保存数据
        $firstDraw = MathUtil::makeBits(array(16, $oneDrawNum, 16, $tenDrawNum));
        $tbPlayerTavern->setFirstDraw($firstDraw);
        $tbPlayerTavern->setLastClaimTime(time());
        $tbPlayerTavern->inOrUp();

        //返回down数据客户端
        $downTavernReply = new Down_TavernDrawReply();
        foreach ($rewardArr as $key => $addArr) {
            if ($key == "item") {
                foreach ($addArr as $itemIdArr) {
                    $itArr = array(11, $itemIdArr['itemNum'], 10, $itemIdArr['itemId']);
                    $downTavernReply->appendItemIds(MathUtil::makeBits($itArr));
                }
            }
            if ($key == "hero") {
                $heroDownArr = HeroModule::getAllHeroDownInfo($userId, $addArr);
                foreach ($heroDownArr as $heroDownMsg) {
                    $itArr = array(11, 1, 10, $heroDownMsg->getTid());
                    $downTavernReply->appendItemIds(MathUtil::makeBits($itArr));
                    $downTavernReply->appendNewHeroes($heroDownMsg);
                }
            }
        }
        return $downTavernReply;
    }

    public static function getMagicSoulReplay()
    {
        $retReply = new Down_AskMagicsoulReply();

        //月最新
        $monthHotSoul = ParamModule::GetTavernMagicMonthSoulId();
        $retReply->appendId($monthHotSoul);

        //日活跃
        $soulStr = GlobalModule::getGlobalData(GlobalModule::TAVERN_MAGIC_DAY_SOUL);
        $randomSoulArr = explode(";", $soulStr);

        foreach ($randomSoulArr as $soul_) {
            $retReply->appendId($soul_);
        }

        return $retReply;
    }


    /**
     *
     * @param $tid
     * @param $heroTable
     * @return array
     */
    private static function getHeroDefine($tid, $heroTable)
    {
        $hero = array();
        foreach ($heroTable as $hero_) {
            if ($hero_['ID'] == $tid) {
                $hero = $hero_;
                break;
            }
        }

        return $hero;
    }


}