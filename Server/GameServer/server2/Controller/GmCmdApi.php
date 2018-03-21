<?php
require_once($GLOBALS['GAME_ROOT'] . "Classes/GmCmdModule.php");

function GmCmdApi(Up_GmCmd $pPacket)
{
    $userId = $GLOBALS['USER_ID'];
    Logger::getLogger()->debug("OnGmCmd user id:{$userId}," . print_r($pPacket, true));
    
    $set_money = $pPacket->getSetMoney();
    if ( isset($set_money) )
    {
    	GmCmdModule::modifyMoney($userId, $set_money->getType(), $set_money->getAmount());
    }
    
    $set_vitality = $pPacket->getSetVitality();
    if ( isset($set_vitality) )
    {
    	GmCmdModule::modifyVitality($userId, $set_vitality);
    }
    
    $set_player_exp = $pPacket->getSetPlayerExp();
    if ( isset($set_player_exp) )
    {
    	GmCmdModule::modifyExp($userId, $set_player_exp);
    }
   
    $set_player_level = $pPacket->getSetPlayerLevel();
    if ( isset($set_player_level) && $set_player_level > 0)
    {
    	GmCmdModule::modifyLevel($userId, $set_player_level);
    }
    
    $set_items = $pPacket->getSetItems();
    if ( isset($set_items) )
    {
		GmCmdModule::addItems($userId, $set_items);
    }
    
    $set_hero_info = $pPacket->getSetHeroInfo();
    if ( isset($set_hero_info) )
    {
    	GmCmdModule::modifyHeros($userId, $set_hero_info);
    }
    
    $unlock_all_stages = $pPacket->getUnlockAllStages();
    if ( isset($unlock_all_stages) )
    {
    	GmCmdModule::unlockStages($userId, $unlock_all_stages);
    }
    
    //add
    $unlock_all_elitestages = $pPacket->getUnlockAllEliteStages();
    if ( isset($unlock_all_elitestages) )
    {
    	GmCmdModule::unlockElitesStages($userId, $unlock_all_elitestages);
    }
    
    
    $get_all_heroes = $pPacket->getGetAllHeroes();
    if ( isset($get_all_heroes) )
    {
    	GmCmdModule::addAllHeros($userId);
    }
    
    $reset_device = $pPacket->getResetDevice();
    if ( isset($reset_device) )
    {
    	GmCmdModule::resetUser($userId);
    }
    
    $open_mystery_shop = $pPacket->getOpenMysteryShop();
    if ( $open_mystery_shop )
    {
    	GmCmdModule::openShop($userId, $open_mystery_shop);
    }
    
    $set_recharge_sum = $pPacket->getSetRechargeSum();
    if ( isset($set_recharge_sum) )
    {
    	GmCmdModule::setRechargeSum($userId, $set_recharge_sum);
    }
    
    $reset_sweep = $pPacket->getResetSweep();
    if ( isset($reset_sweep) )
    {
    	GmCmdModule::resetSweep($userId);
    }
}