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
	
	$data = dumpTable($userId,"farm_object");
	$data->asXML($file);
}

function dumpTable($user_id, $tableName)
{
	$qr = MySQL::getInstance()->RunQuery("select * from {$tableName} where user_id='{$user_id}'");
	$res = MySQL::getInstance()->FetchAllRows($qr);
	if (count($res) == 0) {
		return "";
	}

	$targetTasksXml = "<?xml version='1.0' encoding='utf-8'?><farm_object></farm_object>";
	$targetXml = simplexml_load_string($targetTasksXml);
	foreach($res as $record){
		$taskElement = $targetXml->addChild("item");
		$taskElement->addAttribute("id", $record["type_id"]);
		$slot = $record["slot"];
		$taskElement->addAttribute("X", floor($slot % 120));
		$taskElement->addAttribute("Y", floor($slot / 120));
		$taskElement->addAttribute("direction", $record["direction"]);
		$taskElement->addAttribute("level", $record["level"]);
	}
	return $targetXml;
}


$ac = 3;
$av = array(0, '9030', 'F:/Work/All_Dev/dsfantasy/server/server2/template/xmlReset/5501/farm_object.xml');
main($ac,$av);