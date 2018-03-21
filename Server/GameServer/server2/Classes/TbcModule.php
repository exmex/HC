<?php
/**
 * 远征
 */

require_once($GLOBALS['GAME_ROOT'] . "DbModule/SysPlayerTbc.php");
require_once($GLOBALS['GAME_ROOT'] . "DbModule/SysPlayerHireHero.php");
require_once($GLOBALS['GAME_ROOT'] . "Classes/DataModule.php");;
require_once($GLOBALS['GAME_ROOT'] . "Classes/HeroModule.php");
require_once($GLOBALS['GAME_ROOT'] . "Classes/ShopModule.php");
require_once($GLOBALS['GAME_ROOT'] . "Classes/PlayerModule.php");

class TbcModule
{
    private static $myBasePower = 0;
    private static $myPower = 0;
    
	/**初始化生成远征对手**/
    public static function GenerateStages($userId, $first, $oppos)
    {
        $ret = array();
        //td.读远征规则表，生成Stages
        $DataModule = DataModule::getInstance();
        $rewardTb= $DataModule->getDataSetting(CRUSADE_REWARD_LUA_KEY);
        $isVip = 0; //
        $rewards = $first ? $rewardTb[1] : $rewardTb[0];
        for ($i = 0; $i < 15; $i++) {
            $tbcStage = new Down_TbcStage();

            $oppo = $oppos[$i];

            $reward = $rewards[$i + 1][$isVip];
            $tbcStage->setStatus(Down_TbcStage_Status::unpassed);

            $tbcReward = new Down_TbcReward();
            $tbcReward->setType(Down_TbcReward_Type::gold);
            //td.远征金币公式在此
            $level = PlayerCacheModule::getPlayerLevel($userId);
            $golds = round(2000 * ($level / 5) * $reward["Gold Ratio"] + ($oppo[2] - self::$myBasePower));
            Logger::getLogger()->debug("GenerateStages==>target=" . $oppo[2] . ";self=" . self::$myBasePower . "; gold:" . $golds . ";rate=" . $reward["Gold Ratio"]);
            $tbcReward->setParam1($golds);
            $tbcReward->setParam2(0);
            $tbcStage->appendRewards($tbcReward);

            for ($idx = 1; $idx <= 5; $idx++) {
                if ($reward["Type {$idx}"]) {
                    $tbcReward2 = new Down_TbcReward();
                    $amount = intval($reward["Amount {$idx}"]);
                    if ($reward["Type {$idx}"] == "CrusadePoint") {
                        if ($amount == 0) {
                            continue;
                        }
                        $tbcReward2->setType(Down_TbcReward_Type::crusadepoint);
                        $tbcReward2->setParam1($amount);
                    }
                    if ($reward["Type {$idx}"] == "ChestBox") {
                        $tbcReward2->setType(Down_TbcReward_Type::chestbox);
                        $tbcReward2->setParam1($reward["ID {$idx}"]);
                    }
                    $tbcStage->appendRewards($tbcReward2);
                }
            }
            array_push($ret, $tbcStage);
        }
        return $ret;
    }

    /*
     * 生成远征对手
     */
    public static function generateOppoHeros($userId)
    {
        self::$myPower = self::getMyPower($userId);
        $count = 15;
        $MaxPower = self::$myPower * mt_rand(95, 105) / 100.0;
        $divisor = round(($MaxPower) / ($count * 10));
        $serverId = PlayerCacheModule::getServerId($userId);
        $sql = "select user_id,lineup,all_gs,is_robot,count(distinct  round(all_gs/{$divisor})) from player_arena  where server_id = {$serverId} and user_id != {$userId} and all_gs < {$MaxPower} GROUP BY round(all_gs/{$divisor}) ORDER BY all_gs desc;";
        Logger::getLogger()->debug("generateOppoHeros::userid=" . $userId . ", myBasePower=" . self::$myBasePower . ", sql=" . $sql);
        $top15Oppos = SQLUtil::sqlExecuteArray($sql);
        $result = array();
        if (count($top15Oppos) >= 15) {
            for ($i = 0; $i < 15; $i++) {
                $oppo = $top15Oppos[$i];
                $oppoId = $oppo['user_id'];
                $oppoHeroIds = explode("|", $oppo['lineup']);
                $oppoHeros = array();
                foreach ($oppoHeroIds as $heroId) {
                    $oppoHeros[$heroId] = array(10000, 0, 0);
                }
                $oppoGS = $oppo['all_gs'];
                $is_robot = $oppo['is_robot'];
                $result[] = array($oppoId, $oppoHeros, $oppoGS, $is_robot);
            }
            return array_reverse($result);
        }
        Logger::getLogger()->debug("generateHeros failed: mypow:" . self::$myPower . ",just find " . count($top15Oppos) . " oppos");
        return "";
    }
    
    /*
     * 计算玩家的战力，用于匹配远征对手
    * @ps $combatPower = $sumTop5 * 5 / (5 + ($count - 5) / 27) + $sumTop15 * 2 / $count;
    */
    public static function getMyPower($userId)
    {
    	//$sql = "select sum(a.gs) from (select gs from player_hero where user_id = '{$userId}' order by gs desc limit 0,5) as a";
    	$sql = "select gs from player_hero where user_id = '{$userId}' order by gs desc limit 20";
    	$gsTop20 = SQLUtil::sqlExecuteArray($sql);
    	$count = count($gsTop20);
    	$arrTop5 = array_slice($gsTop20, 0, 5);
    	$arrTop15 = array_slice($gsTop20, 5);
    	$sumTop5 = 0;
    	$sumTop15 = 0;
    	foreach ($arrTop5 as $a) {
    		$sumTop5 += $a[0];
    	}
    	foreach ($arrTop15 as $a) {
    		$sumTop15 += $a[0];
    	}
    	self::$myBasePower = $sumTop5;
    	//td:远征战力公式在此，根据需要调整
    	$combatPower = $sumTop5 + $sumTop15 / 20;
    	return $combatPower;
    }
    

    public static function getOppo($userId, $stageId)
    {
        $tbcTb = self::getPlayerTbcTable($userId);
        $oppos = json_decode($tbcTb->getOppoHeros(), true);
        $oppo = $oppos[$stageId - 1];

        $tbcOppo = new Down_TbcQueryOppo();
        $summary = PlayerModule::getUserSummaryObj($oppo[0], $oppo[3]);
        $tbcOppo->setSummary($summary);

        $heros = HeroModule::getAllHeroDownInfo($oppo[0], array_keys($oppo[1]));
        foreach ($heros as $hero) {
            $oppoHero = new Down_TbcOppoHero();
            $oppoHero->setBase($hero);
            $dyna = new Down_HeroDyna();
            $dyna->setHpPerc($oppo[1][$hero->getTid()][0]);
            $dyna->setMpPerc($oppo[1][$hero->getTid()][1]);
            $dyna->setCustomData($oppo[1][$hero->getTid()][2]);
            $oppoHero->setDyna($dyna);
            $tbcOppo->appendOppos($oppoHero);
            $tbcOppo->setIsRobot($oppo[3]);
        }
        return $tbcOppo;
    }

    private static function getStagesString($stages)
    {
        return json_encode($stages);
    }

    public static function getStagesFromString($stages)
    {
        $tbcStages = array();
        $jstages = json_decode($stages, true);
        foreach ($jstages as $jstage) {
            $tbcStage = new Down_TbcStage();
            $tbcStage->setStatus($jstage['values'][1]);
            foreach ($jstage['values'][2] as $jreward) {
                $tbcReward = new Down_TbcReward();
                $tbcReward->setType($jreward['values'][1]);
                $tbcReward->setParam1($jreward['values'][2]);
                $tbcReward->setParam2($jreward['values'][3]);
                $tbcStage->appendRewards($tbcReward);
            }
            array_push($tbcStages, $tbcStage);
        }
        return $tbcStages;
    }

    private static function getTbcSelfHeros($userId, $heros_str)
    {
        $heros_dynas = json_decode($heros_str, true);
        $SysAllHeros = HeroModule::getAllHeroTable($userId);
        $heros = array();
        foreach ($SysAllHeros as $SysHero) {
            $heroId = $SysHero->getTid();
            $hero = new Down_TbcSelfHero();
            $hero->setTid($heroId);
            $dyna = new Down_HeroDyna();
            if (isset($heros_dynas[$heroId])) {
                $dyna->setHpPerc(intval($heros_dynas[$heroId][0]));
                $dyna->setMpPerc(intval($heros_dynas[$heroId][1]));
                $dyna->setCustomData(intval($heros_dynas[$heroId][2]));
            } else {
                $dyna->setHpPerc(10000);
                $dyna->setMpPerc(0);
                $dyna->setCustomData(0);
            }
            $hero->setDyna($dyna);
            array_push($heros, $hero);
        }
        return $heros;
    }

    /**
     * @param $userId
     * @param $resetTime
     * @return SysPlayerHireHero
     */
    public static function getMyHireHero($userId, $resetTime)
    {
        $SysPlayerHireHeroArr = SysPlayerHireHero::loadedTable(null, " user_id = '{$userId}' and hire_from = '1' and hire_time > '{$resetTime}'");
        if (count($SysPlayerHireHeroArr) > 0) {
            return $SysPlayerHireHeroArr[0];
        }
    }

    public static function getTbcHireHero($userId, $hire_hero_str, $resetTime)
    {
        $heros_dynas = json_decode($hire_hero_str, true);
        $hire = self::getMyHireHero($userId, $resetTime);
        if (isset($hire)) {
            $heroId = $hire->getHireHeroTid();

            $hireData = new Down_HireData();
            $hireData->setName(PlayerCacheModule::getPlayerName($hire->getHireUserId()));
            $hireData->setUid($hire->getHireUserId());

            $hireHero = new Down_HireHero();
            $heros = HeroModule::getAllHeroDownInfo($hire->getHireUserId(), array($heroId));

            if (count($heros) > 0) {
                $hireHero->setBase($heros[0]);
                $dyna = new Down_HeroDyna();
                if (isset($heros_dynas[$heroId])) {
                    $dyna->setHpPerc(intval($heros_dynas[$heroId][0]));
                    $dyna->setMpPerc(intval($heros_dynas[$heroId][1]));
                    $dyna->setCustomData(intval($heros_dynas[$heroId][2]));
                } else {
                    $dyna->setHpPerc(10000);
                    $dyna->setMpPerc(0);
                    $dyna->setCustomData(0);
                }
                $hireHero->setDyna($dyna);
                $hireData->setHero($hireHero);
            }
            return $hireData;
        }
        return null;
    }
    public static function getTbcInfo($userId, $reset = false)
    {
        $curTime = time();
        $tbc = new Down_TbcInfo();
        $tbcSys = self::getPlayerTbcTable($userId);
        $stages = null;
        $oppos = null;
        if (!isset($tbcSys)) { //第一次，初始化
            $tbcSys = new SysPlayerTbc();

            $tbcSys->setUserId($userId);
            $oppos = self::generateOppoHeros($userId);
            $stages = self::GenerateStages($userId, true, $oppos);
            $tbcSys->setCurStage(1);
            $tbcSys->setSelfHeros(json_encode(array()));
            $tbcSys->setStages(self::getStagesString($stages));
            $tbcSys->setOppoHeros(json_encode($oppos));
            $tbcSys->setHireHeros("");
            $tbcSys->setResetTimes(1);
            $tbcSys->setLastResetTime($curTime);
            $tbcSys->inOrUp();
        }
        if ($reset) {
            $oppos = self::generateOppoHeros($userId);
            $first = $tbcSys->getResetTimes() == 0;
            $stages = self::GenerateStages($userId, $first, $oppos);
            $tbcSys->setCurStage(1);
            $tbcSys->setSelfHeros(json_encode(array()));
            $tbcSys->setStages(self::getStagesString($stages));
            $tbcSys->setOppoHeros(json_encode($oppos));
            $tbcSys->setHireHeros("");
            $tbcSys->setResetTimes($tbcSys->getResetTimes() + 1);
            $tbcSys->setLastResetTime($curTime);
            $tbcSys->inOrUp();
        } else {
            if (SQLUtil::isTimeNeedReset($tbcSys->getLastResetTime())) { //需要重置
                $tbcSys->setResetTimes(0); //只自动重置次数
                $tbcSys->inOrUp();
            }
        }
        if ($stages == null) {
            $stages = self::getStagesFromString($tbcSys->getStages());
        }

        $tbc->setCurStage($tbcSys->getCurStage());
        $tbc->setResetTimes($tbcSys->getResetTimes());

        $heros = self::getTbcSelfHeros($userId, $tbcSys->getSelfHeros());
        foreach ($heros as $hero) {
            $tbc->appendHeroes($hero);
        }

        foreach ($stages as $stage) {
            $tbc->appendStages($stage);
        }

        $hireHero = self::getTbcHireHero($userId, $tbcSys->getSelfHeros(), $tbcSys->getLastResetTime());
        if (isset($hireHero)) {
            $hireHero->getHero()->getBase()->setState(Down_HeroStatus::hire);
            $tbc->setHireHero($hireHero);
        }
        return $tbc;
    }

    public static function getPlayerTbcTable($userId)
    {
    	$searchKey = "`user_id` = {$userId}";
    	$tbcTbs = SysPlayerTbc::loadedTable(null, $searchKey);
    	if (count($tbcTbs) > 0) {
    		return $tbcTbs[0];
    	}
    	return null;
    }
}
 