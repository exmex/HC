<?php
require_once ("CMySQL.php");

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
	
	//$data = dumpTable($userId,"player");
	//$data .= dumpTable($userId,"player_farm");
	$data .= dumpTable($userId,"farm_object");
	
	file_put_contents($file,$data);
	
}

function dumpTable($user_id,$tableName)
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
	
	foreach ($res as $tableInfo ){		
		$fields[] = $tableInfo['Field'];	
		$field_data .= "{$tableInfo['Field']},";				
	}
	$field_data .= ")";
	$field_data = str_replace(",)",")",$field_data);
	
	$qr = MySQL::getInstance ()->RunQuery ( "select * from {$tableName} where user_id='{$user_id}'");
	$res = MySQL::getInstance ()->FetchAllRows ( $qr );

	$record_data = "";	
	foreach($res as $record){
		$rd = "\r\n(";
		foreach($fields as $f){
			$s = addslashes($record[$f]);
			$rd .= "'{$s}',";
		}
		$rd .= "),";
		$record_data .= $rd;
	}
	
	$record_data .= ";";
	
	$record_data = str_replace(",)",")",$record_data);
	$record_data = str_replace(",;",";",$record_data);
	
	return "INSERT INTO {$tableName} {$field_data} VALUES {$record_data}\r\n\r\n";
}


$ac = $argc;
$av = $argv;
main($ac,$av);