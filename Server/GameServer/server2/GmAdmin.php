<?php
require_once( dirname('.') . '/Api/SiteInterface.php');
// $userId = $_REQUEST['userId'];
// $transactionType = $_REQUEST['transactionType'];
// $orderId = $_REQUEST['orderId'];
// $payPf = $_REQUEST['payPf'];



// $siteInterface = new SiteInterface();
// $ret = $siteInterface->updateUserPayMoneyAndVipLevel($userId, $transactionType,$orderId,$payPf);

// var_dump($ret);
$type = $_REQUEST['type'];
if(!empty($type))
{	
	if($type==1) //充值
	{
		
		$params= $_REQUEST['params'];
		$params_decode=explode(';',$params);
		
		foreach ($params_decode as $k=>$v)
		{
			$paramsInfo=explode(':',$v);
			$payInfo[$paramsInfo[0]]=$paramsInfo[1];
		}
		
		$userId = $payInfo['userId'];
		$transactionType = $payInfo['transactionType']; //商品ID
		$orderId = $payInfo['orderId'];
		$payPf = $payInfo['payPf'];
		
		$GLOBALS['USER_ID'] = $userId;
		$GLOBALS['SERVERID'] = $payInfo['serverid'];
		
		$siteInterface = new SiteInterface();
		$ret = $siteInterface->updateUserPayMoneyAndVipLevel($userId, $transactionType,$orderId,$payPf);	
		if($ret['S']==true)
		{
			$info['status']=1;
			echo json_encode($info);
		}else 
		{
			$info['status']=0;
			echo json_encode($info);
		}
	}else if($type==2) //加钻
	{
		
		$params= $_REQUEST['params'];
		$params_decode=explode(';',$params);
		
		foreach ($params_decode as $k=>$v)
		{
			$paramsInfo=explode(':',$v);
			$payInfo[$paramsInfo[0]]=$paramsInfo[1];
		}
		
		
		$gem = $payInfo['gem'];
		$userId = $payInfo['userId'];
		$GLOBALS['USER_ID'] = $userId;
		$GLOBALS['SERVERID'] = $payInfo['serverid'];
		$siteInterface = new SiteInterface();
		$ret = $siteInterface->modifyGem($userId, $gem);
		$info['status']=1;
		echo json_encode($info);
	}
	else if($type==3) //加金币
	{
		$params= $_REQUEST['params'];
		$params_decode=explode(';',$params);
		
		foreach ($params_decode as $k=>$v)
		{
			$paramsInfo=explode(':',$v);
			$payInfo[$paramsInfo[0]]=$paramsInfo[1];
		}
		
		
		$money = $payInfo['money'];
		$userId = $payInfo['userId'];
		$siteInterface = new SiteInterface();
		$ret = $siteInterface->modifyMoney($userId, $money);
		
		
			$info['status']=1;
			echo json_encode($info);
		
	}
	else if($type==4) //加等级
	{
		$params= $_REQUEST['params'];
		$params_decode=explode(';',$params);
	
		foreach ($params_decode as $k=>$v)
		{
			$paramsInfo=explode(':',$v);
			$payInfo[$paramsInfo[0]]=$paramsInfo[1];
		}
	
		$level = $payInfo['level'];
		$userId = $payInfo['userId'];
		$siteInterface = new SiteInterface();
		$ret = $siteInterface->modifyPlyLevel($userId, $level);
		if($ret==1)
		{
			$info['status']=1;
			echo json_encode($info);
		}else 
		{
			$info['status']=0;
			echo json_encode($info);
		}
	
	}
	else if($type==5) //加经验
	{
		$params= $_REQUEST['params'];
		$params_decode=explode(';',$params);
	
		foreach ($params_decode as $k=>$v)
		{
			$paramsInfo=explode(':',$v);
			$payInfo[$paramsInfo[0]]=$paramsInfo[1];
		}
	
	
		$exp = $payInfo['exp'];
		$userId = $payInfo['userId'];
		$siteInterface = new SiteInterface();
		$ret = $siteInterface->modifyPlyExp($userId, $exp);
	
		if($ret==true)
		{
			$info['status']=1;
			echo json_encode($info);
		}else
		{
			$info['status']=0;
			echo json_encode($info);
		}
	
	}
	else if($type==6) //竞技场点数增加//	arena_point 竞技场| 
	{
		
		$params= $_REQUEST['params'];
		$params_decode=explode(';',$params);
	
		foreach ($params_decode as $k=>$v)
		{
			$paramsInfo=explode(':',$v);
			$payInfo[$paramsInfo[0]]=$paramsInfo[1];
		}
	
	
		$arena_point = $payInfo['arena_point'];
		$userId = $payInfo['userId'];
		$siteInterface = new SiteInterface();
		$ret = $siteInterface->modifyPlyArenaPoint($userId, $arena_point);
	
		if($ret==true)
		{
			$info['status']=1;
			echo json_encode($info);
		}else
		{
			$info['status']=0;
			echo json_encode($info);
		}
	
	}
	else if($type==7) //远征点数增加crusade_point 燃烧的远征 |
	{
		$params= $_REQUEST['params'];
		$params_decode=explode(';',$params);
	
		foreach ($params_decode as $k=>$v)
		{
			$paramsInfo=explode(':',$v);
			$payInfo[$paramsInfo[0]]=$paramsInfo[1];
		}
	
	
		$crusade_point = $payInfo['crusade_point'];
		$userId = $payInfo['userId'];
		$siteInterface = new SiteInterface();
		$ret = $siteInterface->modifyPlyCrusadePoint($userId, $crusade_point);
	
		if($ret==true)
		{
			$info['status']=1;
			echo json_encode($info);
		}else
		{
			$info['status']=0;
			echo json_encode($info);
		}
	
	}
	else if($type==8) //公会点数增加 guild_point 公会
	{
		$params= $_REQUEST['params'];
		$params_decode=explode(';',$params);
	
		foreach ($params_decode as $k=>$v)
		{
			$paramsInfo=explode(':',$v);
			$payInfo[$paramsInfo[0]]=$paramsInfo[1];
		}
	
	
		$guild_point = $payInfo['guild_point'];
		$userId = $payInfo['userId'];
		$siteInterface = new SiteInterface();
		$ret = $siteInterface->modifyPlyGuildPoint($userId, $guild_point);
	
		if($ret==true)
		{
			$info['status']=1;
			echo json_encode($info);
		}else
		{
			$info['status']=0;
			echo json_encode($info);
		}
	
	}
	else if($type=='mail')
	{
		$params= $_REQUEST['params'];
		$params_decode=explode(';',$params);
		foreach ($params_decode as $k=>$v)
		{
			$paramsInfo=explode(':',$v);
			$payInfo[$paramsInfo[0]]=$paramsInfo[1];
		}
		$userId = $payInfo['userId'];
		$title = $payInfo['title'];
		$sender = $payInfo['sender'];
		
		$content = $payInfo['content'];
		$expireTime =strtotime($payInfo['expireTime']);
		$gem = $payInfo['gem'];
		$money = $payInfo['money'];
		$items = $payInfo['items'];
		$items = str_replace(",",";",$items);
		$items = str_replace("-",":",$items);
		$serverid = '';
		$siteInterface = new SiteInterface();
		$ret = $siteInterface->GmSetMail($userId, $title,$sender,$content,$expireTime,$gem,$money,$items,$serverid,$type);
		
		if($ret==true)
		{
			$info['status']=1;
			echo json_encode($info);
		}else
		{
			$info['status']=0;
			echo json_encode($info);
		}
		
		
	}
	else if($type=='allmail')
	{
		$params= $_REQUEST['params'];
		$params_decode=explode(';',$params);
	
		foreach ($params_decode as $k=>$v)
		{
			$paramsInfo=explode(':',$v);
			$payInfo[$paramsInfo[0]]=$paramsInfo[1];
		}
	
		$userId = $payInfo['userId'];
		$title = $payInfo['title'];
		$sender = $payInfo['sender'];
		$content = $payInfo['content'];
		$expireTime =strtotime($payInfo['expireTime']);
		$gem = $payInfo['gem'];
		$money = $payInfo['money'];
		$items = $payInfo['items'];
		$serverid = $payInfo['serverid'];
		$items=str_replace(",",";",$items);
		$items=str_replace("-",":",$items);
		
		$siteInterface = new SiteInterface();
		$ret = $siteInterface->GmSetMail($userId, $title,$sender,$content,$expireTime,$gem,$money,$items,$serverid,$type);
	
		if($ret==true)
		{
			$info['status']=1;
			echo json_encode($info);
		}else
		{
			$info['status']=0;
			echo json_encode($info);
		}
	
	
	}
	
	else if($type=='allservermail')
	{
		$params= $_REQUEST['params'];
		$params_decode=explode(';',$params);
	
		foreach ($params_decode as $k=>$v)
		{
			$paramsInfo=explode(':',$v);
			$payInfo[$paramsInfo[0]]=$paramsInfo[1];
		}
	
		$userId = $payInfo['userId'];
		$title = $payInfo['title'];
		$sender = $payInfo['sender'];
		$content = $payInfo['content'];
		$expireTime =strtotime($payInfo['expireTime']);
		$gem = $payInfo['gem'];
		$money = $payInfo['money'];
		$items = $payInfo['items'];
		$serverid = $payInfo['serverid'];
		$items=str_replace(",",";",$items);
		$items=str_replace("-",":",$items);
		$siteInterface = new SiteInterface();
		$ret = $siteInterface->GmSetMail($userId, $title,$sender,$content,$expireTime,$gem,$money,$items,$serverid,$type);
	
		if($ret==true)
		{
			$info['status']=1;
			echo json_encode($info);
		}else
		{
			$info['status']=0;
			echo json_encode($info);
		}
	
	
	}
}
else   //查询
{
	$params= $_REQUEST['params'];
	$params_decode=explode(';',$params);
	
	foreach ($params_decode as $k=>$v)
	{
		$paramsInfo=explode(':',$v);
		$payInfo[$paramsInfo[0]]=$paramsInfo[1];
	}
	$siteInterface = new SiteInterface();
	if(!empty($payInfo['nickname']))
	{
		$nickname=$payInfo['nickname'];
		$serverid=$payInfo['serverid'];
		$ret = $siteInterface->GmUserName($nickname,$serverid);
		$user_id=$ret;
		
	}else if(!empty($payInfo['puid']))
	{
		$puid=$payInfo['puid'];
		$serverid=$payInfo['serverid'];
		$ret = $siteInterface->GmUserPuid($puid,$serverid);
		$user_id=$ret;
	}
	else if (!empty($payInfo['user_id']))
	{
		$user_id=$payInfo['user_id'];
	}

	$ret = $siteInterface->GmSelectUser($user_id);
	echo json_encode($ret);
	
}

?>
