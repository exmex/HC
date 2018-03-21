<?php
require_once( dirname('.') . '/Api/SiteInterface.php');

$userId = $_REQUEST['userId'];

$goodsId= explode(".",$_REQUEST['transactionType']);

$_REQUEST['transactionType'] = $goodsId[0];

$transactionType = $_REQUEST['transactionType'];
$orderId = $_REQUEST['orderId'];
$payPf = $_REQUEST['payPf'];
writeLog($payPf,$_REQUEST);
$GLOBALS['USER_ID'] = $userId;
$GLOBALS['SERVERID'] = $_REQUEST['serverid'];

$siteInterface = new SiteInterface();
$ret = $siteInterface->updateUserPayMoneyAndVipLevel($userId, $transactionType,$orderId,$payPf);

var_dump($ret);
function writeLog($pf,$params)
{
                $logArr['pf']=$pf;
                $logArr['content']=$params;
                $logArr['datetime']=date("Y-m-d H:i:s");

                $logjson= json_encode($logArr)."\n";
                $date = date("Ymd");
                $file = dirname('.') . "/log/logs/".$pf."/".$date.".log";
                $path = dirname('.') . "/log/logs/".$pf."/";
                if(!is_readable($path))
                {
                        is_file($path) or mkdir($path,0777);
                }

                error_log($logjson,3,$file);

}
?>
