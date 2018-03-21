<?php
require_once($GLOBALS['GAME_ROOT'] . "DbModule/SQLUtil.php");
require_once($GLOBALS['GAME_ROOT'] . "DbModule/SysUserSettings.php");
require_once($GLOBALS['GAME_ROOT'] . "Classes/PlayerCacheModule.php");
/**
 * 用戶設置
 * @param [type]           $uin      [description]
 * @param Up_SystemSetting $settings [description]
 */
function UserSettingsApi($uin, Up_SystemSetting $settings){
    $settingsReply = new Down_SystemSettingReply();
    $settingsData = PlayerCacheModule::getSettings($uin);
    $request = $settings->getRequest();
    //if(isset($request)){
    //}
    $change = $settings->getChange();
    if(isset($change)){
        $key = $change->getKey();
        $val = $change->getValue();
        $settingsArr = null;
        if(empty($settingsData)){
            $settingsArr = array();
        }else{
            $settingsArr = json_decode($settingsData,true);
            $settingsArr[$key] = $val;
        }
        $settingsArr[$key] = $val;
        $settingsData = json_encode($settingsArr);
        $userSetting = new SysUserSettings();
        $userSetting->setUin($uin);
        $userSetting->setSettings($settingsData);
        $userSetting->inOrUp();
        $changeReply = new Down_SystemSettingChange();
        $changeReply->setResult(Down_Result::success);
        $settingsReply->setChange($changeReply);
    }
    Logger::getLogger()->debug("OnUserSettings");
    return $settingsReply;
}
