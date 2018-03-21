<?php

function main()
{
	$questXml = simplexml_load_file("F:/Work/frpg/client/dsFantasy/src/xml/questSettings.xml");
	
	$quests = array();
	
	foreach($questXml->quest as $q){
		$name = strval($q['name']);
		$quests[$name] = $q;
	}
	
	$data = "";
	
	foreach($questXml->quest as $q){
		$name = strval($q['name']);
		$prev = strval($q['previous']);
		if(!isset($quests[$prev])){
			$data .= "{$name}->{$prev}\r\n";
		}
	}
	
	echo $data;
	
}


main();