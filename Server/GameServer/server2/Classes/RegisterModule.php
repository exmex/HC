<?php
/**
 * User: xumanli
 * Date: 14/12/26
 * 用户注册系统（处理已有设备和新设备）
 */

class RegisterModule
{
    private $module = null;
    //获取数据的方法
    function RegisterSystem($postArray)
    {
        $nowUnix = time();
        $nowDate = date('Y-m-d H:i:s');

        //设备Id
        $deviceId= 0;
        $devicedName = "device";
        $versionId = "1.0";
        $platformId = 0;
        $isNewDevice = false;
        $userLanguage = "";
        $userModel = "";
        $userOSVer = "";
        $tempSaveArray = array();
        $tempSaveArray["method"] = $devicedName;
       // StateModule::setState(StateModule::$basicMethod ,$devicedName);
       //获取$postArray json解除
        $postDataArray = json_decode($postArray, true);
        $tempSaveArray["version"] = $versionId;
        //判断是否获取用户的uuid 用户唯一标识id
        if (!isset($postDataArray["uuid"]))
        {
            $postDataArray["uuid"] = self::makeUuid();
        }
        else
        {
            if (strlen($postDataArray["uuid"]) != 32)
            {
                $postDataArray["uuid"] = md5($postDataArray["uuid"]);
             }
        }
        //uuid
        $uuid = $postDataArray["uuid"];
        //用户简单属性
        if(isset($_GET['Language'])){
            $userLanguage = $_GET['Language'];
        }
        if(isset($_GET['OSVer'])){
            $userOSVer = $_GET['OSVer'];
        }
        if(isset($_GET['Model'])){
            $userModel = $_GET['Model'];
        }
        //判断用户手机系统
        if(isset($_GET['device_type']))
        {
            if ($_GET['device_type'] == "android")
            {
                $platformId = 3;// -- adr
            }
            elseif($_GET['device_type'] == "ios")
            {
                $platformId = 1;// -- ios
                if (isset($_GET['Model'])) {
                    $modelType= strtolower($_GET['Model']);
                    if(strstr($modelType, 'ipad')!== false)
                    {
                        $platformId = 2;
                    }
                    elseif(strstr($modelType,'ipod')!== false)
                    {
                        $platformId = 4;
                    }
                }
            }
        }
        $platformArray = explode('_',$postDataArray['uin']);
        if(in_array('ios',$platformArray))
        {
            $platformId = 2;
        }
        else
        {
            $platformId = 1;
        }

        $sql = "SELECT uin FROM `device_id` WHERE uuid = '{$uuid}'";
        $result = MySQL::getInstance()->RunQuery($sql);
        $row = MySQL::getInstance()->FetchArray($result);
        if (empty($row))
        {
            $isNewDevice = true;
        }
        else
        {
            $uin = $row["uin"];
        }

        if ($isNewDevice == true)
        {
            //创建新用户
            $registerNum = 1;//注册记为登陆一次
            $userInfo = new SysUser();
            $registerIp =  isset($_SERVER['REMOTE_ADDR'])?$_SERVER['REMOTE_ADDR']:'127.0.0.1';
            $timeInfo = self::getTimeInfo($postDataArray["timeZone"]);

            //对user进行赋值
            $userInfo->setEmail("");
            $userInfo->setGameCenterId($postDataArray['uin']);
            $userInfo->setPassword("");
            $userInfo->setRegIp($registerIp);
            $userInfo->setLastLoginIp($registerIp);
            $userInfo->setRegTime($nowDate);
            $userInfo->setLastLoginTime($nowDate);
            $userInfo->setRegTimeStamp($nowUnix);
            $userInfo->setLastLoginTimeStamp($nowUnix);
            $userInfo->setLoginNums($registerNum);
            $userInfo->setUserZoneId($timeInfo[0]);
            $userInfo->setUserZone($timeInfo[1]);
            $userInfo->setCountry(CommonModule::getCountryCode());
            $userInfo->setPlatform($platformId);
            $userInfo->setLanguage($userLanguage);
            $userInfo->setModel($userModel);
            $userInfo->setOSVer($userOSVer);
            $userInfo->inOrUp();
            $uin = $userInfo->getUin();
            //绑定到device
            $sql = "insert into `device_id` (`uuid`, `uin`, `reg_ip`,`last_login_ip`,`platform_id`)
                                      values( '{$uuid}', '{$uin}','{$registerIp}','{$registerIp}','{$platformId}')";
            MySQL::getInstance()->RunQuery($sql);
            $deviceId = MySQL::getInstance()->GetInsertId();
        }
        //update sessionKey
        $sessionKey = 123123123;
        $sql = "update user set session_key = '{$sessionKey}',
                                    last_login_ip='{$registerIp}',
                                    last_login_time='{$nowDate}',
                                    last_login_time_stamp='{$nowUnix}',
                                    login_nums=login_nums+1
                                    WHERE uin = '{$uin}' ";
        MySQL::getInstance()->RunQuery($sql);
        //get userId
        $serverListInfo = self::getUserHadLoginServer($uin,$postDataArray['serverId']);
        if (!empty($serverListInfo) && $serverListInfo[0]['server_id']==$postDataArray['serverId'])
        {
            $serverId = $serverListInfo[0]['server_id'];
            $userId = $serverListInfo[0]['user_id'];
        }
        else
        {
            $serverId = $postDataArray['serverId'];
            $sql = "insert into user_server(`uin`,`server_id`,`reg_time`,`last_login_time`,`reg_ip`,`last_login_ip`,`platform`)
                                values('{$uin}','{$serverId}','{$nowUnix}','{$nowUnix}','{$registerIp}','{$registerIp}','{$platformId}')";
            MySQL::getInstance()->RunQuery($sql);
            $userId =MySQL::getInstance()->GetInsertId();
        }

        if(isset($_GET['device_type']) && $_GET['device_type'] == "android")
        {
            $rechargeProductionIdList = CommonModule::getRechargeProductionIdList(2);
        }
        else
        {
            $rechargeProductionIdList = CommonModule::getRechargeProductionIdList();
        }

        $tempSaveArray[ "error"] = "";
        $tempSaveArray[ "serverIP"] = "192.168.1.202";
        $tempSaveArray[ "serverPort"] = "10000";
        $tempSaveArray[ "uin"] = $uin;
        $tempSaveArray[ "sessionKey"] = $sessionKey;
        $tempSaveArray[ "userId"] = $userId;
        $tempSaveArray[ "serverId"] = $serverId;
        $tempSaveArray[ "deviceID"] = CommonModule::encrypt($deviceId,'lsjfla@#$$@Q$Q%*)1234567890@#$sdalfkj');
        $tempSaveArray[ "uuid"] = $postDataArray["uuid"];
        $tempSaveArray[ "rechargeProductionIdList"] = $rechargeProductionIdList;

       
        return  json_encode($tempSaveArray);

    }

    private function getUserHadLoginServer($uin,$serverId)
    {
        $sql = "select * from  user_server  where uin='{$uin}'  and server_id = '{$serverId}'";
        $result = MySQL::getInstance()->RunQuery($sql);
        $row    = MySQL::getInstance()->FetchAllRows($result);

        return $row;
    }


    private function getTimeInfo($timeZone)
    {
        $timeInfo = array();
        date_default_timezone_set("EST");
        @date_default_timezone_set(strval($timeZone));
        $clientZone = date_default_timezone_get();
        $sql = "select * from `time_zone_list` where `time_zone`='{$clientZone}'";
        $result = MySQL::getInstance()->RunQuery($sql);
        $row = MySQL::getInstance()->FetchAllRows($result);
        if (empty($row))
        {
            $insertSql = "insert into `time_zone_list` (`time_zone`) values ('{$clientZone}')";
            if(MySQL::getInstance()->RunQuery($insertSql))
            {
                $timeInfo[0] = MySQL::getInstance()->GetInsertId();
                $timeInfo[1] = $clientZone;
            }
        }
        else
        {
            $timeZoneId = $row[0]['id'];
            $timeInfo[0] = $timeZoneId;
            $timeInfo[1] = $clientZone;
        }

        return $timeInfo;
    }

    /**
     * php补充uuid
     * @return string
     */
    private function makeUuid()
    {
        $uuid = md5(time().strtolower(uniqid(rand(), true)));

        return  $uuid;
    }



}
?>