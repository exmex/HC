<?php
require_once ("CMySQL.php");

function main($argc,$argv)
{
	if($argc < 2){
		echo "user_id is null\n";
		return;
	}
	if($argc < 3){
		echo "neighbor id is null\n";
		return;
	}
	
	$userId = $argv[1];
	$neighborId = $argv[2];
	
	$usFbuid = checkUserFbuid($userId);
	$nbFbuid = checkUserFbuid($neighborId);
	
	if(checkIsNeighbors($usFbuid,$nbFbuid)){
		echo "already is neighbors!\n";
		return;
	}
	
		
	$qr = MySQL::getInstance()->RunQuery("insert into user_neighbors set fbuid='{$usFbuid}',fbuid_neighbor='{$nbFbuid}',neighbor_state=1;");	
	if($qr){
		echo "add neighbors success !\n";
		return;		
	}
	
	echo "add neighbors failed!\n";
	
}

function checkIsNeighbors($ufbuid,$nfbuid)
{
	$qr = MySQL::getInstance()->RunQuery("select count(*) from user_neighbors  where fbuid='{$ufbuid}' and fbuid_neighbor='{$nfbuid}'");	
	if(!$qr){
		return false;
	}	
	
	$ar = MySQL::getInstance()->FetchArray($qr);		
	if(count($ar)>0){
		return intval($ar[0]) > 0;
	}
	
	return false;	
}

function checkUserFbuid($userId)
{
	$qr = MySQL::getInstance()->RunQuery("select fbuid from user where id='{$userId}'");
	if($qr){
		$ar = MySQL::getInstance()->FetchArray($qr);		
		if(count($ar)>0){
			return $ar[0];
		}
	}

	MySQL::getInstance()->RunQuery("insert into user(id,fbuid) values('{$userId}','{$userId}')");
	
	return $userId;
}


$ac = $argc;
$av = $argv;
main($ac,$av);