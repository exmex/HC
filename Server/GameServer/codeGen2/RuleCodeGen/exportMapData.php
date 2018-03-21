<?php
require_once ("CMySQL.php");
define('MAP_SIZE', 120); // 地图大小

function main($argc,$argv)
{
	if($argc < 2){
		echo "user_id is null\n";
		return;
	}
	
	if($argc < 3){
		echo "output file path is null\n";
		return;
	}
	
	$user_id = $argv[1];
	
	echo "Getting map_data of {$user_id}...\n";
	
	$sql = "select map_data from player_farm where user_id='{$user_id}'";
	
	$qr = MySQL::getInstance()->RunQuery($sql);
	if(empty($qr)){
		echo "failed to query db!($sql)\n";
		return;
	}
	$ar = MySQL::getInstance()->FetchArray($qr);
	
	if(count($ar)==0){
		echo "no such user_id!\n";
		return;
	}
	
	$map_data = str_split($ar['map_data']);
	
	
	$output ="";
	
	for($y=0;$y<MAP_SIZE;$y++){		
		for($x=0;$x<MAP_SIZE;$x++){
			$output .= $map_data[getPositionId($x,$y)];
		}
		$output .= "\r\n";
	}
	
	file_put_contents($argv[2],$output);
	
	echo "success! output file:{$argv[2]}";
}

function getPositionId($x, $y)
{
	return $x + $y * MAP_SIZE;	// positionId从0开始计算
}


$ac = $argc;
$av = $argv;
main($ac,$av);