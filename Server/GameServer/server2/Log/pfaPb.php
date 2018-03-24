<?php
$actionArray = array();

$tempActionArray = array();
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
	$outcontext .= "MEMCACHE_READ : {$pfaTime->memcache_read} (".(round($pfaTime->memcache_read/$pfaTime->total *100,2))."%)\r\n";
	$outcontext .= "MEMCACHE_WRITE: {$pfaTime->memcache_write} (".(round($pfaTime->memcache_write/$pfaTime->total *100,2))."%)\r\n";
	$outcontext .= "WRITE_LOG     : {$pfaTime->write_log} (".(round($pfaTime->write_log/$pfaTime->total *100,2))."%)\r\n";
	
	
	$runphp = $pfaTime->total - $pfaTime->mysql_connect - $pfaTime->mysql_query - $pfaTime->write_log - $pfaTime->memcache_read - $pfaTime->memcache_write;
	$outcontext .= "RUN_PHP       : {$runphp} (".(round($runphp/$pfaTime->total *100,2))."%)\r\n";
	
	$outcontext .= "\r\n\r\n";
	$outcontext .= "                      function    call    total    avg    mysql_connect  mysql_query  write_log   run_php  memcach_read memcache_write \r\n";
	$outcontext .= "--------------------------------------------------------------------------------------------------------------------------------------\r\n";
	foreach($actionArray as $k=>$a){
		$a->avg = (float)$a->pfat->total/(float)$a->count;
		$a->pfat->run_php = $a->pfat->total - $a->pfat->mysql_connect - $a->pfat->mysql_query - $a->pfat->write_log - $a->pfat->memcache_read-$a->pfat->memcache_write;
		
		$outcontext .= sprintf("%30s  %6d   %6.2f  %6.2f     %6.2f        %6.2f       %6.2f     %6.2f    %6.2f     %6.2f\r\n",
		            $a->name,$a->count,$a->pfat->total,$a->avg,$a->pfat->mysql_connect,
		            $a->pfat->mysql_query,$a->pfat->write_log,$a->pfat->run_php,$a->pfat->memcache_read,$a->pfat->memcache_write);
	}
	
	$nfileName = $argv[1]."_pfa.log";
	file_put_contents($nfileName,$outcontext);
	
	echo "{$nfileName}\n";
	echo $outcontext;
}


function getLastAction($thrId)
{
	global $tempActionArray;
	global $actionArray;
	$lastInfo =null;
	if(isset($tempActionArray[$thrId]))
	{
		$lastInfo  =$tempActionArray[$thrId] ;
		unset($tempActionArray[$thrId]);
	}

	if($lastInfo==null || count($lastInfo)<1)
	{
		return null;
	}
	
	$n= $lastInfo[0];
	
	
	
 			if (empty($actionArray[$n])){
 				$ac = new Action();
 				$ac->name = $n;
 				$ac->count = 1;
 		//		$ac->total = $cost;
 				$ac->pfat = new PFATime();
 				$actionArray[$n] = $ac;
 			}else{
 				$ac = $actionArray[$n];
 				$ac->count += 1;
 			//	$ac->total += $cost;
 			}

 	return $ac;
 			
}


function addfile($filename,$pfaTime)
{
	global $actionArray;
	global $tempActionArray;
	$file = fopen($filename,"r");
	if (!$file){
		echo "failed to open file {$filename}\n";
		return;
	}
	
	$lastThrId = null;
	
	while(!feof($file)){
		$buffer = fgets($file);
		$m =array();
		


 		if(preg_match('/\[([0-9]+)\] OnProtoBuff Get Up_UpMsg Data/', $buffer,$m))
 		{

 		//	var_dump($m);
 			$lastThrId = $m[1];
 			continue;
 		}
 		
 		
		if(preg_match('/Up_((?:(?!UpMsg).)+)[ ]+\{.*/',$buffer, $m))
		{
			//var_dump($m);
			//array_push($tempActionArray, array("name"=>$m[1],"thrId"=>$lastThrId));
			if(!isset($tempActionArray[$lastThrId]))
			{
				$tempActionArray[$lastThrId] = array();
			}
			array_push($tempActionArray[$lastThrId], $m[1]);
			continue;
		}
		
		
		if(preg_match('/INFO.*\[([0-9]+)\] exec end time is: ([.0-9\-E]+) MYSQL connect time:([.0-9\-E]+) query time:([.0-9\-E]+) WriteLogTime:([.0-9\-E]+) mcReadTime:([.0-9\-E]+) mcWriteTime:([.0-9\-E]+)/',$buffer,$m)
		)
		{

			$pfaTime->total += floatval($m[2]);
			$pfaTime->mysql_connect += floatval($m[3]);
			$pfaTime->mysql_query += floatval($m[4]);
			$pfaTime->write_log += floatval($m[5]);
			$pfaTime->memcache_read += floatval($m[6]);
			$pfaTime->memcache_write += floatval($m[7]);
				
			$thrId = $m[1];
			$lastAction= getLastAction($thrId);

			if($lastAction!=null)
			{
			
				$lastAction->pfat->total += floatval($m[2]);
				$lastAction->pfat->mysql_connect += floatval($m[3]);
				$lastAction->pfat->mysql_query += floatval($m[4]);
				$lastAction->pfat->write_log += floatval($m[5]);
				$lastAction->pfat->memcache_read += floatval($m[6]);
				$lastAction->pfat->memcache_write += floatval($m[7]);
				
			}
		
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
	var $memcache_read=0.0;
	var $memcache_write=0.0;
	var $run_php = 0.0;	
}

class Action
{

	var $name;
	var $count = 0;
	var $avg;
	//var $total;
	var $pfat;	
}



$ac = $argc;
$av = $argv;
main($ac,$av);


