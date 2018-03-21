<?php
require_once ("../RuleCodeGen/CMySQL.php");

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
	$userId = $argv[1];
	$file = $argv[2];
	
	$data = "";	
	$data .= dumpTable($userId,"player");
	$data .= dumpTable($userId,"player_farm",true);
	$data .= dumpTable($userId,"farm_object");
	$data .= dumpTable($userId,"player_items",true);
	$data .= dumpTable($userId,"player_quest_status",true);
	$data .= dumpTable($userId,"player_battle",true);
	$data .= dumpTable($userId,"player_equipments",true);
	$data .= dumpTable($userId,"player_heros",true);
	$data .= dumpTable($userId,"player_tech",true);
	$data .= dumpTable($userId,"player_complete_quest",true);
	$data .= dumpTable($userId,"player_maps",true);
	$data .= dumpTable($userId,"player_tower",true);
	$data .= dumpTable($userId,"player_diamond",true);
	
	
	file_put_contents($file,$data);
	
}

function dumpTable($user_id,$tableName,$removeId=false)
{
		
	$qr = MySQL::getInstance ()->RunQuery ( "DESC ".$tableName );
	$res = MySQL::getInstance ()->FetchAllRows ( $qr );
		
	if (empty($res))
	{
		echo "Error parse table ".$tableName."\n";
		return;
	}
	
	$fields = array();
	$field_data = "(";
	
	$idIndex = 0;
	$index = 0;
		
	foreach ($res as $tableInfo ){		
		$index++;			
		if($removeId){
			if(strval($tableInfo['Field']) == "id"){		
				$idIndex = $index;	
				continue;
			}
		}
		$fields[] = $tableInfo['Field'];	
		$field_data .= "`{$tableInfo['Field']}`,";			
	}
	$field_data .= ")";
	$field_data = str_replace(",)",")",$field_data);
	
	$qr = MySQL::getInstance ()->RunQuery ( "select * from {$tableName} where user_id='{$user_id}'");
	$res = MySQL::getInstance ()->FetchAllRows ( $qr );
	
	if(count($res) == 0){
		return "";
	}

	$record_data = "";	
	$isequipments = ($tableName === "player_items");
	$isfarmobj = ($tableName === "farm_object");
	$userid = "";
	
	$cc = 0;
	
	foreach($res as $record){
		$rd = "(";		
		foreach($fields as $f){			
			$s = addslashes($record[$f]);
			$s = str_replace("\r",'',$s);	
			$s = str_replace("\n",'',$s);
			if($isequipments){
				if($f == "owner"){
					$rd .= "'-1',";
					continue;
				}else if($f == "owner_type"){
					$rd .= "'1',";
					continue;
				}else if($f == "slot"){
					$dddd = $cc+1;
					$rd .= "'{$dddd}',";
					continue;
				}				
			}
			if($f=="user_id"){
				$userid = $s;
				$rd .= "'TEMPUSERID',";
			}else{
				$rd .= "'{$s}',";
			}
		}
		$rd .= "),";
		$record_data .= $rd;
		$cc++;
	}
	
	$record_data .= ";";
	
	$record_data = str_replace(",)",")",$record_data);
	$record_data = str_replace(",;",";",$record_data);
	
	if($isfarmobj && !empty($userid)){
		$record_data = str_replace($userid.".","TEMPUSERID.",$record_data);		
	}
	
	return "INSERT INTO {$tableName} {$field_data} VALUES {$record_data}\r\n";
}


$ac = $argc;
$av = $argv;
main($ac,$av);