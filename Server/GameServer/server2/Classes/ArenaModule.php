<?php
/**
 * @Author:      jaylu
 * @Date:        2015-01-28 
 * @Description: Description
 * @email:       jay@xxxx.com
 */
require_once($GLOBALS['GAME_ROOT'] . "DbModule/SysPlayerArena.php");
require_once($GLOBALS['GAME_ROOT'] . "DbModule/SysArenaRecord.php");
require_once($GLOBALS['GAME_ROOT'] . "Classes/PlayerModule.php");
require_once($GLOBALS['GAME_ROOT'] . "Classes/MailModule.php");
require_once($GLOBALS['GAME_ROOT'] . "Classes/ShopModule.php");
//why add 
require_once($GLOBALS['GAME_ROOT'] . "DbModule/SysPlayerArenaFixed.php");
require_once($GLOBALS['GAME_ROOT'] . "DbModule/SysGuildInfo.php");

define("MAX_ARENA_FIGHT_COUNT", 5);
define("ARENA_FIGHT_INTERVAL", 600);
define("ARENA_CLEAR_CD_COST", 50);

define("ARENA_MAIL_LIFE_TIME", 604800);

define("ARENA_USER_BUFFER_KEY", 'ARENA_BUFFER_USER_');
define("ARENA_RECORD_KEY", 'ARENA_RECORD_ID_');

class ArenaModule{
    private static $ArenaTableCached = array();
    public static function getArenaTable($userId){
        if (isset(self::$ArenaTableCached[$userId])) {
            return self::$ArenaTableCached[$userId];
        }

        $tbPlyArena = new SysPlayerArena();
        $tbPlyArena->setUserId($userId);
        if ($tbPlyArena->loaded()) {

        } else {
            self::addNewPlayerToArena($userId);
            $tbPlyArena->loaded();
        }

        self::$ArenaTableCached[$userId] = $tbPlyArena;

        return $tbPlyArena;
    }
    /**
     * 挑战后排名
     * @param  [type] $serverId [description]
     * @param  [type] $rankList [description]
     * @return [type]           [description]
     */
    public static function getArenaTableByRankList($serverId, $rankList){
        $arenaList = array();
        if (count($rankList) <= 0) {
            return $arenaList;
        }
        $rankStr = implode(",", $rankList);
        $searchKey = "server_id = '{$serverId}' and rank in ($rankStr)";
        $arenaList = SysPlayerArena::loadedTable(null, $searchKey);
        foreach ($arenaList as $tbArena) {
            self::$ArenaTableCached[$tbArena->getUserId()] = $tbArena;
        }
        return $arenaList;
    }

    public static function addNewPlayerToArena($userId, $isRobot = 0){
        $serverId = PlayerCacheModule::getServerId($userId);
        $timeZoneId = intval($GLOBALS['USER_ZONE_ID']);
        $where = "`user_id` = '{$userId}' order by gs desc limit 5";
        $heroTables = SysPlayerHero::loadedTable(array("tid", "gs"), $where);
        $lineUpArr = array();
        $allGs = 0;
        foreach ($heroTables as $oneTable) {
            $lineUpArr[] = $oneTable->getTid();
            $allGs += $oneTable->getGs();
        }
        $lineUpStr = implode("|", $lineUpArr);
        $insertSql = "INSERT INTO `player_arena` (`user_id`, `zone_id`, `server_id`, `lineup`, `all_gs`, `is_robot`, `rank`) ";
        $insertSql .= "(select '{$userId}', '{$timeZoneId}', '{$serverId}', '{$lineUpStr}', '{$allGs}', '{$isRobot}', ";
        $insertSql .= "case when max(rank) IS NULL then 1 else max(rank) + 1 end ";
        $insertSql .= "from `player_arena` where `server_id`='{$serverId}')";
        MySQL::getInstance()->RunQuery($insertSql);
        $updateSql = "UPDATE `player_arena` SET `best_rank` = `rank` WHERE `user_id` = '{$userId}'";
        MySQL::getInstance()->RunQuery($updateSql);
    }

    /**
     * 更新竞技场排名
     * @param  [type] $serverTag [description]
     * @return [type]            [description]
     */
    public static function updateArenaRankByServer($serverTag){
        $sql = "select `user_id`, `rank` from `player_arena` where `server_id` = '{$serverTag}' order by rank";
        $qr = MySQL::getInstance()->RunQuery($sql);
        if (empty ($qr)) {
            echo "{$sql} failed.\n";
            return;
        }
        $ar = MySQL::getInstance()->FetchAllRows($qr);
        $rank = 1;
        $errorCount = 0;
        foreach ($ar as $a) {
            if ($rank != intval($a [1])) {
                MySQL::getInstance()->RunQuery("update player_arena set rank='{$rank}' where user_id='{$a[0]}'");
                $errorCount++;
            }
            $rank++;
        }
    }

    /**
     * 原子表操作，交换对战双方的rank值
     */
    public static function updateArenaRankAtomic($user1, $user2){
        $sql = "update `player_arena` a, `player_arena` b ";
        $sql .= "set a.rank = b.rank, b.rank = a.rank, "; // b.win_count = 0, ";
        $sql .= "a.best_rank = case when a.best_rank > b.rank then b.rank else a.best_rank end ";
        $sql .= "where a.user_id = '{$user1}' and b.user_id = '{$user2}' and a.rank > b.rank";
        MySQL::getInstance()->RunQuery($sql);
        return MySQL::getInstance()->GetAffectRows();
    }

    // rand oppo
    public static function randUserOppoRankList($myRank){
        $enemyRule = DataModule::getInstance()->lookupDataTable(PVP_ENEMY_LUA_KEY, null, array(1));
        $enemyCount = intval($enemyRule["Enemy Count"]);
        $retArr = array();
        if ($myRank <= ($enemyCount + 1)) {
            for ($i = ($enemyCount + 1); $i >= 1; $i--) {
                if ($myRank > $i) {
                    $retArr[] = $i;
                }
            }
        }else{
            $rankArr = array();
            $rankArr[] = $myRank;
            for ($i = 1; $i <= $enemyCount; $i++) {
                $rankArr[] = floor($myRank * $enemyRule["Enemy {$i} Rank"]);
            }
            for ($i = 0; $i < $enemyCount; $i++) {
                $maxRank = $rankArr[$i] - 1;
                $minRank = $rankArr[$i + 1];
                $randRank = mt_rand($minRank, $maxRank);
                $retArr[] = $randRank;
            }
        }
        if(empty($retArr)){
            $numbers=range(2,20);//生成一个2到20的数组
            for ($index = 0; $index < 3; $index++) {
            shuffle($numbers);//随机打乱数组
            $retArr[] = $numbers[0];//输出数组中下标是0的元素
            unset($numbers[0]);//删除数组中下标是0的元素
            }
        }
        return $retArr;
    }

    // update new oppos
    public static function getUserAllOppoInfo($userId){
        $tbArena = self::getArenaTable($userId);
        $rankList = self::randUserOppoRankList($tbArena->getRank());
        $tbList = self::getArenaTableByRankList($tbArena->getServerId(), $rankList);
        $retArr = array();
        foreach ($tbList as $tbArena) {
            $retArr[$tbArena->getRank()] = self::getDownLadderOppoInfo($tbArena->getUserId(), $tbArena);
        }
        ksort($retArr);
        return $retArr;
    }

    public static function getDownLadderOppoInfo($userId, SysPlayerArena $tbArena = null){
        if (empty($tbArena)) {
            $tbArena = self::getArenaTable($userId);
        }
        $downInfo = new Down_LadderOpponent();
        $downInfo->setUserId($userId);
        $downInfo->setSummary(PlayerModule::getUserSummaryObj($userId, $tbArena->getIsRobot()));
        $downInfo->setRank($tbArena->getRank());
        $downInfo->setWinCnt($tbArena->getWinCount());
        $downInfo->setIsRobot($tbArena->getIsRobot());
        $allGs = 0;
        $heroTidList = explode("|", $tbArena->getLineup());
        $tbHeroList = HeroModule::getAllHeroTable($userId, $heroTidList);
        foreach ($tbHeroList as $tbHero) {
            $heroSummary = new Down_HeroSummary();
            $heroSummary->setTid($tbHero->getTid());
            $heroSummary->setRank($tbHero->getRank());
            $heroSummary->setLevel($tbHero->getLevel());
            $heroSummary->setStars($tbHero->getStars());
            $heroSummary->setGs($tbHero->getGs());
            $heroSummary->setState($tbHero->getState());
            $downInfo->appendHeros($heroSummary);
            $allGs += $tbHero->getGs();
        }
        if ($tbArena->getAllGs() != $allGs) {
            $tbArena->setAllGs($allGs);
            $tbArena->save();
        }
        $downInfo->setGs($allGs);
        return $downInfo;
    }

    public static function createPvpRecord($userId, $myHeroIdList, $oppoUserId, &$heroIdStr){
        $pvpRecord = new Down_PvpRecord();
        $pvpRecord->setCheckid(0);
        $pvpRecord->setUserid($userId);
        $pvpRecord->setOppoUserid($oppoUserId);
        $randSeed = mt_rand(1, 999);
        $pvpRecord->setRseed($randSeed);
        $myTbArena = self::getArenaTable($userId);
        $pvpRecord->setSelfRobot($myTbArena->getIsRobot());
        $myHeroList = HeroModule::getAllHeroDownInfo($userId, $myHeroIdList);
        foreach ($myHeroList as $downHero) {
            $pvpRecord->appendSelfHeroes($downHero);
        }

        $oppoTbArena = self::getArenaTable($oppoUserId);
        $pvpRecord->setOppoRobot($oppoTbArena->getIsRobot());
        $heroList = explode("|", $oppoTbArena->getLineup());
        $oppoHeroList = HeroModule::getAllHeroDownInfo($oppoUserId, $heroList);
        foreach ($oppoHeroList as $downHero) {
            $pvpRecord->appendOppoHeroes($downHero);
        }
        $heroIdStr = implode("-", $myHeroIdList) . "|" . $oppoUserId;
        return $pvpRecord;
    }

    public static function getDownLadderRecord($userId, SysArenaRecord $record){
        $ladderRecord = new Down_LadderRecord();
        $ladderRecord->setBtTime($record->getBtTime());
        $ladderRecord->setDetaRank($record->getUpRank());
        if ($userId == $record->getUserId()) {
            $ladderRecord->setUserId($record->getOppoId());
            $ladderRecord->setSummary(PlayerModule::getUserSummaryObj($record->getOppoId(), $record->getOppoRobot()));
            if ($record->getBtResult() == Down_BattleResult::victory) {
                $ladderRecord->setBtResult(Down_BattleResult::victory);
            }else{
                $ladderRecord->setBtResult(Down_BattleResult::defeat);
            }
        }else{
            $ladderRecord->setUserId($record->getUserId());
            $ladderRecord->setSummary(PlayerModule::getUserSummaryObj($record->getUserId(), $record->getUserRobot()));
            if ($record->getBtResult() == Down_BattleResult::victory) {
                $ladderRecord->setBtResult(Down_BattleResult::defeat);
            } else {
                $ladderRecord->setBtResult(Down_BattleResult::victory);
            }
        }
        $ladderRecord->setReplayId($record->getId());
        return $ladderRecord;
    }

    // 补完一个完整的PVPRecord结构
    public static function addArenaRecord(Down_PvpRecord $pvpRecord, $result, $upRank){
        $tbPly1 = PlayerModule::getPlayerTable($pvpRecord->getUserid());
        $tbPly2 = PlayerModule::getPlayerTable($pvpRecord->getOppoUserid());
        $newRecord = new SysArenaRecord();
        $newRecord->setUserId($tbPly1->getUserId());
        $newRecord->setUserName($tbPly1->getNickname());
        $newRecord->setUserAvatar($tbPly1->getAvatar());
        $newRecord->setUserLevel($tbPly1->getLevel());
        $newRecord->setUserRobot($pvpRecord->getSelfRobot());
        $newRecord->setOppoId($tbPly2->getUserId());
        $newRecord->setOppoName($tbPly2->getNickname());
        $newRecord->setOppoAvatar($tbPly2->getAvatar());
        $newRecord->setOppoLevel($tbPly2->getLevel());
        $newRecord->setOppoRobot($pvpRecord->getOppoRobot());
        $newRecord->setBtResult($result);
        $newRecord->setBtTime(time());
        $newRecord->setUpRank($upRank);
        $newRecord->inOrUp();
        $pvpRecord->setCheckid($newRecord->getId());
        $key = ARENA_RECORD_KEY . $newRecord->getId();
        self::setArenaPvpRecord($key, $pvpRecord);
    }

    //todo 只是查询功能 
    public static function getArenaRankInfo($userId){
    	if (isset(self::$ArenaTableCached[$userId])) {
    		return self::$ArenaTableCached[$userId];
    	}
    	$tbPlyArena = new SysPlayerArena();
    	$tbPlyArena->setUserId($userId);
    	if($tbPlyArena->loaded()){
    		$tbPlyRankInfo=$tbPlyArena;
    	}else{
    		$tbPlyRankInfo='';
    	}
    	return $tbPlyRankInfo;
    }
    
    // 实时排名21点时候的数据导入每日表中
    public static function getArenaSetArenaFixed($serverId){
    	$rankArr = array();
    	$where = "server_id = '{$serverId}' order by rank limit 50";
    	$tbArenaList = SysPlayerArena::loadedTable(array('user_id', 'zone_id','server_id', 'rank','best_rank', 'reward_rank_list','fight_count', 'last_fight_time','buy_count','last_buy_time', 'win_count', 'lineup', 'all_gs', 'is_robot'), $where);
    	$userArr = array();
    	$fixedSql = MySQL::getInstance()->RunQuery("select * from `player_arena_fixed` where `server_id` = '{$serverId}'");
    	$ar = MySQL::getInstance()->FetchArray($fixedSql);
    	if (!$ar || count($ar)==0) {
    		$insertSql = "INSERT INTO `player_arena_fixed` (`user_id`, `zone_id`,`server_id`, `rank`,`best_rank`, `reward_rank_list`,`fight_count`, `last_fight_time`, `buy_count`,`last_buy_time`, `win_count`, `lineup`, `all_gs`, `is_robot`) values";
    		foreach ($tbArenaList as $tbArena) {
    			$InsertArr[] = "('{$tbArena->getUserId()}','{$tbArena->getZoneId()}','{$tbArena->getServerId()}','{$tbArena->getRank()}','{$tbArena->getBestRank()}','{$tbArena->getRewardRankList()}','{$tbArena->getFightCount()}','{$tbArena->getLastFightTime()}','{$tbArena->getBuyCount()}','{$tbArena->getLastBuyTime()}','{$tbArena->getWinCount()}','{$tbArena->getLineup()}','{$tbArena->getAllGs()}','{$tbArena->getIsRobot()}')";
    			  		
    		}
    		$insertSql .=implode(",", $InsertArr);
    		MySQL::getInstance()->RunQuery($insertSql);
    	}else{
    		foreach ($tbArenaList as $tbArena) {
    		MySQL::getInstance()->RunQuery("update player_arena_fixed set user_id='{$tbArena->getUserId()}',zone_id='{$tbArena->getZoneId()}',best_rank='{$tbArena->getBestRank()}',reward_rank_list='{$tbArena->getRewardRankList()}',fight_count='{$tbArena->getFightCount()}',last_fight_time='{$tbArena->getLastFightTime()}',buy_count='{$tbArena->getBuyCount()}',last_buy_time='{$tbArena->getLastBuyTime()}',win_count='{$tbArena->getWinCount()}',lineup='{$tbArena->getLineup()}',all_gs='{$tbArena->getAllGs()}',is_robot='{$tbArena->getIsRobot()}' where rank='{$tbArena->getRank()}' and  server_id='{$tbArena->getServerId()}'");
    			}
    	}
    	$userArr = array();
    	/** @var TbPlayerArena $tbArena */
    	//$summaryArr = PlayerModule::getUserSummaryArr($userArr);
    	/*$userListStr = implode(",", $userArr);
    	 $sqlKey = "user_id in ($userListStr)";
    	$tbPlayerList = TbPlayer::loadedTable(array('user_id', 'nickname', 'level', 'avatar'), $sqlKey);
    
    	$tbSortArr = array();*/
    	/** @var TbPlayer $tbPlayer */
    	/*foreach ($tbPlayerList as $tbPlayer) {
    	 $tbSortArr[$tbPlayer->getUserId()] = $tbPlayer;
    	}
    	foreach ($userArr as $rank => $userId) {
    	$rankArr[$rank] = $summaryArr[$userId];
    	}*/
//     	ksort($rankArr);
//     	return $rankArr;
    }
    
    
    //全员总战力排行榜 每天执行一次
    public static function fightingStrengthRank($server_id){
    	$sqlKey = "server_id = '{$server_id}'";
    	$tbHeroList = SysPlayer::loadedTable(array("user_id"),$sqlKey);
        $tempTbHeroListArray = array();
         foreach ($tbHeroList as $value) {
              $TbsqlKey = "user_id = '{$value->getUserId()}'";
              $tbHeroGsList = SysPlayerHero::loadedTable(array("gs"),$TbsqlKey);
              $totalGs = 0;
              foreach($tbHeroGsList as $val){
                   $totalGs += $val->getGs();
              }
              $tempTbHeroListArray[$value->getUserId()]=$totalGs;
        }
        arsort($tempTbHeroListArray);
        $rank = 1;
        foreach($tempTbHeroListArray as $key=>$val){
           $sqlWhere = "user_id = '$key'";
           $tbUserRobotArray = SysUserServer::loadedTable(array("reg_time"),$sqlWhere);
           $tbNot = $tbUserRobotArray[0]->getRegTime();
           	$tbNot ==0 ? $tbIsRobot=1 : $tbIsRobot=0;
           $sql = "select `rank` from player_fighting_strength_rank where `user_id` =".$key;
           $qr = MySQL::getInstance()->RunQuery($sql);
            //if (empty ($qr)) {
                //echo "{$sql} failed.\n";
                //return;
            //}
           $ar = MySQL::getInstance()->FetchAllRows($qr);
           $last_rank = $ar[0]['rank'];
           $date=date("Y-m-d H:i:s");
           $sql = "insert into player_fighting_strength_rank (`user_id`,`server_id`,`gs`,`rank`,`last_rank`,`is_robot`) values ('$key','$server_id','$val','$rank','".$last_rank."','".$tbIsRobot."')  ON DUPLICATE KEY UPDATE `server_id`='$server_id',`gs`='$val',`rank`='$rank',`last_rank`='".$last_rank."',`query_time`='".$date."'";
           MySQL::getInstance()->RunQuery($sql);
           $rank+=1;
        }

    }

     //全员星星数排行榜 每天执行一次
    public static function starsRank($server_id){
    	$where = "server_id = '{$server_id}'";
    	$tbHeroList = SysPlayer::loadedTable(array("user_id"),$where);
        $tempTbHeroStarsListArray = array();
         foreach ($tbHeroList as $value) {
              $TbsqlKey = "user_id = '{$value->getUserId()}'";
              $tbHeroStarsList = SysPlayerHero::loadedTable(array("stars"),$TbsqlKey );
              $totalStars = 0;
              foreach($tbHeroStarsList as $val)
              {
                   $totalStars += $val->getStars();
              }
              $tempTbHeroStarsListArray[$value->getUserId()]=$totalStars;
        }
        arsort($tempTbHeroStarsListArray);
        $rank = 1;
        foreach($tempTbHeroStarsListArray as $key=>$val){
           $sqlWhere = "user_id = '$key'";
           $tbUserRobotArray = SysUserServer::loadedTable(array("reg_time"),$sqlWhere);
           $tbNot = $tbUserRobotArray[0]->getRegTime();
           $tbNot ==0 ? $tbIsRobot=1 : $tbIsRobot=0;
           $sql = "select `rank` from player_stars_rank where `user_id` =".$key;
           $qr = MySQL::getInstance()->RunQuery($sql);
            //if (empty ($qr)) {
                //echo "{$sql} failed.\n";
                //return;
            //}
           $ar = MySQL::getInstance()->FetchAllRows($qr);
           $last_rank = $ar[0]['rank'];
           $date=date("Y-m-d H:i:s");
            $sql = "insert into player_stars_rank(`user_id`,`server_id`,`stars`,`rank`,`last_rank`,`is_robot`) values ('$key','$server_id','$val','$rank','".$last_rank."',".$tbIsRobot.")  ON DUPLICATE KEY UPDATE `server_id`='$server_id',`stars`='$val',`rank`='$rank',`last_rank`='".$last_rank."',`query_time`='".$date."'";
            MySQL::getInstance()->RunQuery($sql);
            $rank+=1;
        }
    }

//全员前5名战斗力总和排行榜
 public static function fightingStrengthRankLimit($server_id){
    	$sqlKey = "server_id = '{$server_id}'";
    	$tbHeroList = SysPlayer::loadedTable(array("user_id"),$sqlKey);
        $tempTbHeroArray = array();
         foreach ($tbHeroList as $value) {
              $TbsqlKey = "user_id = '{$value->getUserId()}' order by gs desc limit 5";
              $tbHeroGsList = SysPlayerHero::loadedTable(array("gs"),$TbsqlKey );
              $totalgsArray = array();
              $totalgs = 0;
              foreach($tbHeroGsList as $val){
              	$totalgs += $val->getGs();
              }
              $tempTbHeroArray[$value->getUserId()]=$totalgs;
        }
        arsort($tempTbHeroArray);
        $rank = 1;
        foreach($tempTbHeroArray as $key=>$val){
           $sqlWhere = "user_id = '$key'";
           $tbUserRobotArray = SysUserServer::loadedTable(array("reg_time"),$sqlWhere);
           $tbNot = $tbUserRobotArray[0]->getRegTime();
           $tbNot ==0 ? $tbIsRobot=1 : $tbIsRobot=0;
           $sql = "select `rank` from player_fighting_strength_rank_limit where `user_id` =".$key;
           $qr = MySQL::getInstance()->RunQuery($sql);
            //if (empty ($qr)) {
                //echo "{$sql} failed.\n";
              //  return;
           // }
           $ar = MySQL::getInstance()->FetchAllRows($qr);
           $last_rank=$ar[0]["rank"];
           $date=date("Y-m-d H:i:s");
           $sql = "insert into player_fighting_strength_rank_limit (`user_id`,`server_id`,`gs`,`rank`,`last_rank`,`is_robot`) values ('$key','$server_id','$val','$rank','".$last_rank."',".$tbIsRobot.") ON DUPLICATE KEY UPDATE  `server_id`='$server_id',`gs`='$val',`rank`='$rank',`last_rank`='".$last_rank."',`query_time`='".$date."'";
           MySQL::getInstance()->RunQuery($sql);
           $rank+=1;
        }

    }
    //公会排行榜 
    public static function guildVitalityRank($server_id){
    	$where = "server_id = '{$server_id}'";
    	$tbVitalityList = SysGuildInfo::loadedTable(array("id","vitality"),$where);
    	$tempTbVitalityArray = array();
    	foreach ($tbVitalityList as $value){
    		$tempTbVitalityArray[$value->getId()]=$value->getVitality();
    	}
    	
    	foreach($tempTbVitalityArray as $key=>$val){
    		$sql = "select `vitality0`,`vitality1`,`vitality2`,`vitality3`,`rank` from guild_vitality_rank where `guild_id` =".$key;
    		$qr = MySQL::getInstance()->RunQuery($sql);
    		$ar = MySQL::getInstance()->FetchAllRows($qr);
    		$rankInfo [$key]=$val-$ar[0]['vitality0'];
    		$sql = "insert into guild_vitality_rank (`guild_id`,`server_id`,`vitality0`,`vitality1`,`vitality2`,`vitality3`,`rank`) values ('$key','$server_id',0,0,0,'$val',0) ON DUPLICATE KEY UPDATE  `vitality0`='".$ar[0]['vitality1']."',`vitality1`='".$ar[0]['vitality2']."',`vitality2`='".$ar[0]['vitality3']."',`vitality3`='".$val."',`last_rank`='".$ar[0]['rank']."'";
    		MySQL::getInstance()->RunQuery($sql);
    	
    	}
    	arsort($rankInfo);
    	$rank=1;
    	$date=date("Y-m-d H:i:s");
    	foreach ($rankInfo as $k=>$v){
    		MySQL::getInstance()->RunQuery("update guild_vitality_rank set rank='$rank',`query_time`='$date' where `guild_id` =".$k);
    		$rank++;
    	}
    }
    /**
     * 前50名玩家排名
     * @param  [type] $userId [description]
     * @return [type]         [description]
     */
    public static function getTopRank50UserSummary($userId){
        $rankArr = array();
        $serverId = PlayerCacheModule::getServerId($userId);
        $sqlKey = "server_id = '{$serverId}' order by rank limit 50";
        $tbArenaList = SysPlayerArena::loadedTable(array('user_id', 'rank', 'is_robot'), $sqlKey);
        $userArr = array();
        foreach ($tbArenaList as $tbArena) {
            $userArr[$tbArena->getRank()] = $tbArena->getUserId();
            $rankArr[$tbArena->getRank()] = PlayerModule::getUserSummaryObj($tbArena->getUserId(), $tbArena->getIsRobot());
        }
        //$summaryArr = PlayerModule::getUserSummaryArr($userArr);
        /*$userListStr = implode(",", $userArr);
        $sqlKey = "user_id in ($userListStr)";
        $tbPlayerList = TbPlayer::loadedTable(array('user_id', 'nickname', 'level', 'avatar'), $sqlKey);
        $tbSortArr = array();*/
        /** @var TbPlayer $tbPlayer */
        /*foreach ($tbPlayerList as $tbPlayer) {
            $tbSortArr[$tbPlayer->getUserId()] = $tbPlayer;
        }
        foreach ($userArr as $rank => $userId) {
            $rankArr[$rank] = $summaryArr[$userId];
        }*/
        ksort($rankArr);
        return $rankArr;
    }
    
    

    public static function getFixedTopRank50UserSummary($userId){
    	$rankArr = array();
    	$serverId = PlayerCacheModule::getServerId($userId);
    	$sqlKey = "server_id = '{$serverId}' order by rank limit 50";
    	$tbArenaList = SysPlayerArenaFixed::loadedTable(array('user_id', 'rank', 'is_robot'), $sqlKey);
    	$userArr = array();
    	foreach ($tbArenaList as $tbArena) {
    		$userArr[$tbArena->getRank()] = $tbArena->getUserId();
    		$rankArr[$tbArena->getRank()] = PlayerModule::getUserSummaryObj($tbArena->getUserId(), $tbArena->getIsRobot());
    	}
    	//$summaryArr = PlayerModule::getUserSummaryArr($userArr);
    	/*$userListStr = implode(",", $userArr);
    	 $sqlKey = "user_id in ($userListStr)";
    	$tbPlayerList = TbPlayer::loadedTable(array('user_id', 'nickname', 'level', 'avatar'), $sqlKey);
    	$tbSortArr = array();*/
    	/** @var TbPlayer $tbPlayer */
    	/*foreach ($tbPlayerList as $tbPlayer) {
    	 $tbSortArr[$tbPlayer->getUserId()] = $tbPlayer;
    	}
    	foreach ($userArr as $rank => $userId) {
    	$rankArr[$rank] = $summaryArr[$userId];
    	}*/
    	ksort($rankArr);
    	return $rankArr;
    }
    

    // 删除前一天的数据数据(24h前的数据)
    public static function clearOverdueArenaInfo(){
        $sql = "delete from `arena_record` where `bt_time` <= (unix_timestamp() - 86400)"; // 只保留最近1天的竞技场记录
        MySQL::getInstance()->RunQuery($sql);
    }

    // add player arena daily rank reward mail
    public static function updateDailyRankReward($timeZoneId){
        $qr = MySQL::getInstance()->RunQuery("select count(1) from `player_arena` where `zone_id` = '{$timeZoneId}'");
        if (!$qr) {
            return false;
        }
        $ar = MySQL::getInstance()->FetchArray($qr);
        if (!$ar) {
            return false;
        }
        $PLAYER_SET = 1000;
        $totalPlayers = intval($ar [0]);
        $blocks = ceil($totalPlayers / $PLAYER_SET);
        if ($blocks == 0) {
            return false;
        }
        //分块加载
        $curTime = time();
        for ($i = 0; $i < $blocks; $i++) {
            $start = $i * $PLAYER_SET;
            $sqlKey = "zone_id = '{$timeZoneId}' LIMIT {$start}, {$PLAYER_SET}";
            $tbArenaList = SysPlayerArena::loadedTable(array("user_id", "rank", "reward_rank_list"), $sqlKey);
            /** @var TbPlayerArena $tbArena */
            foreach ($tbArenaList as $tbArena) {
                if ($tbArena->getRewardRankList() == "") {
                    $rewardArr = array();
                } else {
                    $rewardArr = explode("|", $tbArena->getRewardRankList());
                }
                $rewardInfo = strval($tbArena->getRank()) . ":" . $curTime;
                $rewardArr [] = $rewardInfo;
                if (count($rewardArr) < 4) {
                    $tbArena->setRewardRankList(implode("|", $rewardArr));
                    $tbArena->save();
                }
            }
        }
        return true;
    }

    public static function updateRewardListToMail($userId){
        $userLevel = PlayerCacheModule::getPlayerLevel($userId);
        $isPVPOpen = PlayerModule::checkFuncOpen($userLevel, "PVP");
        if (!$isPVPOpen) {
            return;
        }
        $tbArena = self::getArenaTable($userId);
        if ($tbArena->getRewardRankList() == "") {
            return;
        }
        $rewardList = explode("|", $tbArena->getRewardRankList());
        $rewardTable = DataModule::getInstance()->getDataSetting(PVP_RANK_REWARD_LUA_KEY);
        ksort($rewardTable);
        $batch = new SQLBatch();
        $insertArr = array('user_id', 'type', 'mail_cfg_id', 'mail_params', 'mail_time', 'expire_time', 'money', 'diamonds', 'items', 'points', 'status');
        $batch->init(SysPlayerMail::insertSqlHeader($insertArr));
        foreach ($rewardList as $oneReward) {
            $rewardInfo = explode(":", $oneReward);
            if (count($rewardInfo) != 2) {
                continue;
            }

            $mail = new SysPlayerMail();
            $mail->setUserId($tbArena->getUserId());
            $mail->setType(1);
            $mail->setMailCfgId(8);
            $rank = intval($rewardInfo[0]);
            $param = "1:1:{$rank}";
            $mail->setMailParams($param);
            $curTime = intval($rewardInfo[1]);
            $expireTime = $curTime + ARENA_MAIL_LIFE_TIME;
            $mail->setMailTime($curTime);
            $mail->setExpireTime($expireTime);
            $rewardInfo = self::getDailyRankReward($rank, $rewardTable);
            $mail->setMoney($rewardInfo[0]);
            $mail->setDiamonds($rewardInfo[1]);
            $mail->setPoints($rewardInfo[2]);
            $mail->setItems($rewardInfo[3]);
            $mail->setStatus(0);
            $batch->add($mail);
        }
        $batch->end();
        $batch->save();
        $tbArena->setRewardRankList("");
        $tbArena->save();
//        NotifyModule::addNotify($userId, NOTIFY_TYPE_MAIL);
    }

    public static function getDailyRankReward($rank, &$table){
        $retArr = array(0, 0, "", "");
        foreach ($table as $rankRewardInfo) {
            if ($rank > intval($rankRewardInfo["Floor Rank"])) {
                continue;
            }
            for ($index = 1; $index <= 5; $index++) {
                $rewardType = strval($rankRewardInfo["Reward Type {$index}"]);
                $rewardId = intval($rankRewardInfo["Reward ID {$index}"]);
                $rewardAmount = max(0, intval($rankRewardInfo["Reward Amount {$index}"]));
                switch ($rewardType) {
                    case "Diamond":
                        $retArr[1] = $rewardAmount;
                        break;

                    case "Gold":
                        $retArr[0] = $rewardAmount;
                        break;

                    case "ArenaPoint":
                        $retArr[2] = "1:{$rewardAmount};2:0";
                        break;

                    case "Item":
                        $retArr[3] .= "{$rewardId}:{$rewardAmount};";
                        break;

                    default:
                        break;
                }
            }
            break;
        }
        return $retArr;
    }

    public static function getBestRankReward($lastBestRank, $curBestRank){
        $rewardTable = DataModule::getInstance()->getDataSetting(PVP_BEST_RANK_REWARD_LUA_KEY);
        krsort($rewardTable);
        $allReward = 0;
        foreach ($rewardTable as $rewardInfo) {
            $floorRank = $rewardInfo["Floor Rank"];
            $rewardUnit = $rewardInfo["Reward Amount"];

            if ($lastBestRank <= $floorRank) {
                continue;
            }
            if ($curBestRank < $floorRank) {
                $rewardRank = $lastBestRank - $floorRank;
                $allReward += ceil($rewardUnit * $rewardRank);
                $lastBestRank = $floorRank;
            } else {
                $rewardRank = $lastBestRank - $curBestRank;
                $allReward += ceil($rewardUnit * $rewardRank);
                break;
            }
        }
        return $allReward;
    }

    public static function getArenaPvpRecordByID($id){
        $arenaRecord = new SysArenaRecord();
        $arenaRecord->setId($id);
        if (!$arenaRecord->loaded()) {
            return null;
        }
        $key = ARENA_RECORD_KEY . $id;
        $pvpRecord = self::getArenaPvpRecord($key);
        if (empty($pvpRecord)) {
            return null;
        }
        $pvpRecord->setUserName($arenaRecord->getUserName());
        $pvpRecord->setLevel($arenaRecord->getUserLevel());
        $pvpRecord->setAvatar($arenaRecord->getUserAvatar());
        $pvpRecord->setVip(0);
        $pvpRecord->setOppoName($arenaRecord->getOppoName());
        $pvpRecord->setOppoLevel($arenaRecord->getOppoLevel());
        $pvpRecord->setOppoAvatar($arenaRecord->getOppoAvatar());
        $pvpRecord->setOppoVip(0);
        $pvpRecord->setResult($arenaRecord->getBtResult());
        return $pvpRecord;
    }

    public static function setArenaPvpRecord($key, Down_PvpRecord $pvpRecord){
        $memStr = $pvpRecord->serializeToString();
        CMemcache::getInstance()->setData($key, $memStr, MEMCACHE_EXPIRE_TIME * 2);
    }

    public static function getArenaPvpRecord($key){
        $memStr = CMemcache::getInstance()->getData($key);
        if ($memStr) {
            $pvpRecord = new Down_PvpRecord();
            $pvpRecord->parseFromString($memStr);
            return $pvpRecord;
        } else {
            return null;
        }
    }

    public static function getArenaPvpRecordArr($keyArr){
        $pvpArr = array();
        $memArr = CMemcache::getInstance()->getDataArr($keyArr);
        if ($memArr) {
            foreach ($memArr as $key => $value) {
                if ($value) {
                    $pvpRecord = new Down_PvpRecord();
                    $pvpRecord->parseFromString($value);
                    $pvpArr[$key] = $pvpRecord;
                }
            }
        }
        return $pvpArr;
    }
    
    //大礼包邮件奖励
    public static function PackageReward($server_id){
    	$ContinueReward = DataModule::lookupDataTable(ACTIVITY_INFO_CONFIG_LUA_KEY,  "ChristmasMailReward");
    	$sqlKey = "select * from `activity_log` where server_id = '{$server_id}' and version  ='".$ContinueReward['version']."'  order by activity_score desc limit ".$ContinueReward['rankLimit'];
    	
    	$fixedSql = MySQL::getInstance()->RunQuery($sqlKey);
    	$ar = MySQL::getInstance()->FetchAllRows($fixedSql);
    	$keyCount = count($ar);
    	$now = date("Ymd");
    	$RankKey=1;
    	$score=$ar[0]['activity_score'];
    	$Num=0;
    	foreach ($ar as $k=>$v){
    		if($score!=$v['activity_score']){
    			$score=$v['activity_score'];
    			$RankKey+=$Num;
    			$arr[$RankKey][] =$v;
    			$Num=1;
    		}else{
    			$arr[$RankKey][] =$v;
    			$Num++;
    		}
    	}
    	if($now==$ContinueReward['rewardTime']){
	    	if($ar){
	    		foreach ($arr as $k=>$ar){
			    		foreach ($ar as $v){
			    			if($v['redward_status'] != 1){
							ksort($ContinueReward['reward']);
				    			foreach ($ContinueReward['reward'] as $key=>$val){
				    				if($k <= $key){
				    					$mail = new SysPlayerMail();
				    					$mail->setUserId($v['user_id']);
				    					$mail->setType(0);
				    					$curTime = time();
				    					$expireTime = $curTime + 3600 * 24 * 365;
				    					$mail->setMailTime($curTime);
				    					$mail->setExpireTime($expireTime);
				    					$mail->setTitle($val['mail']['title']);
				    					$mail->setFrom("System");
				    					$mail->setContent($val['mail']['content']);
				    					$mail->setMoney($val['money']);
				    					$mail->setDiamonds($val['gem']);
				    					$itemStr='';
				    					foreach ($val['items'] as $ks => $vs) {
				    						$itemStr .= "{$ks}:{$vs};";
				    					}
				    					$mail->setItems($itemStr);
				    					$mail->setStatus(0);
				    					$mail->inOrUp();
				    					$updatetSql = "update activity_log set redward_status=1 where user_id = '".$v['user_id']."' and version = '".$ContinueReward['version']."'";
				    					MySQL::getInstance()->RunQuery($updatetSql);
				    					
				    					break;
				    				}	
				    			}
			    			}
			    		}
	    		}
	    	}
	   } 
    }
    //end
}