<?php
/**
 * performance analysis
 * @author LiangZhixian
 * 2010-11-11
 */
$actionArray = array();

function main($argc,$argv)
{
	global $actionArray;
	
	if($argc < 2){
		echo "please input the log file to analysis!\n";
		return;
	}
	
	$pfaTime = new PFATime();	
		
	if(is_dir($argv[1])){
		$dir = opendir($argv[1]);
		while(false != ($filename=readdir($dir))){
			$fn = $argv[1]."/".$filename;
			if(is_file($fn)){
				addfile($fn,$pfaTime);
			}			
		}
		closedir($dir);
	}
	else{
		addfile($argv[1],$pfaTime);
	}			
			
	$outcontext = "";
	$outcontext .= "TOTAL         : {$pfaTime->total}\r\n";
	$outcontext .= "MYSQL_CONNECT : {$pfaTime->mysql_connect} (".(round($pfaTime->mysql_connect/$pfaTime->total * 100,2))."%)\r\n";
	$outcontext .= "MYSQL_QUERY   : {$pfaTime->mysql_query} (".(round($pfaTime->mysql_query/$pfaTime->total *100,2))."%)\r\n";
	$outcontext .= "WRITE_LOG     : {$pfaTime->write_log} (".(round($pfaTime->write_log/$pfaTime->total *100,2))."%)\r\n";
	$runphp = $pfaTime->total - $pfaTime->mysql_connect - $pfaTime->mysql_query - $pfaTime->write_log;
	$outcontext .= "RUN_PHP       : {$runphp} (".(round($runphp/$pfaTime->total *100,2))."%)\r\n";
	
	$outcontext .= "\r\n\r\n";
	$outcontext .= "                      function    call    total    avg    mysql_connect  mysql_query  write_log   run_php\r\n";
	$outcontext .= "---------------------------------------------------------------------------------------------------------\r\n";
	foreach($actionArray as $k=>$a){
		$a->avg = (float)$a->pfat->total/(float)$a->count;
		$a->pfat->run_php = $a->pfat->total - $a->pfat->mysql_connect - $a->pfat->mysql_query - $a->pfat->write_log;
		
		$outcontext .= sprintf("%30s  %6d   %6.2f  %6.2f     %6.2f        %6.2f       %6.2f     %6.2f\r\n",
		            $a->name,$a->count,$a->pfat->total,$a->avg,$a->pfat->mysql_connect,
		            $a->pfat->mysql_query,$a->pfat->write_log,$a->pfat->run_php);
	}
	
	$nfileName = $argv[1]."_pfa.log";
	file_put_contents($nfileName,$outcontext);
	
	echo "{$nfileName}\n";
	echo $outcontext;
}

function addfile($filename,$pfaTime)
{
	global $actionArray;
	
	$file = fopen($filename,"r");
	if (!$file){
		echo "failed to open file {$filename}\n";
		return;
	}
	
	$lastAction = null;
	
	while(!feof($file)){
		$buffer = fgets($file);
		
		if (preg_match_all("|GameProtocolServer.*(On\w+)|",$buffer,$m)){		
			$n = $m[1][0];
			if (empty($actionArray[$n])){
				$ac = new Action();
				$ac->name = $n;
				$ac->count = 1;
				$ac->pfat = new PFATime();				
				$actionArray[$n] = $ac;
			}else{
				$ac = $actionArray[$n];		
				$ac->count += 1;		
			}
			$lastAction = $ac;
		}
		
		if (preg_match_all("|exec end time is:\s(\d+.\d+)|",$buffer,$m)){		
			$pfaTime->total += floatval($m[1][0]);
			$lastAction->pfat->total += floatval($m[1][0]);
		}
		if (preg_match_all("|MYSQL connect time:(\d+.\d+)|",$buffer,$m)){		
			$pfaTime->mysql_connect += floatval($m[1][0]);
			$lastAction->pfat->mysql_connect += floatval($m[1][0]);
		}
		if (preg_match_all("|query time:(\d+.\d+)|",$buffer,$m)){		
			$pfaTime->mysql_query += floatval($m[1][0]);
			$lastAction->pfat->mysql_query += floatval($m[1][0]);
		}
	//	if (preg_match_all("|WriteLogTime:(\d+.\d+)|",$buffer,$m)){		
		if (preg_match_all("|WriteLogTime:(.*)|",$buffer,$m)){				
			$v = floatval($m[1][0]);	
			$pfaTime->write_log += $v;
			$lastAction->pfat->write_log += $v;
			//echo "{$m[1][0]} = {$v}\n";
		}
	}
	
	fclose($file);	
	
}


class PFATime
{
	var $total = 0.0;
	var $mysql_connect = 0.0;
	var $mysql_query = 0.0;
	var $write_log = 0.0;
	var $run_php = 0.0;	
}

class Action
{
	var $name;
	var $count = 0;
	var $avg;
	var $pfat;	
}


$ac = $argc;
$av = $argv;
main($ac,$av);
