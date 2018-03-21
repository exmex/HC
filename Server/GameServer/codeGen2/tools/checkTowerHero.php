<?php

function main()
{
	$heroxml = simplexml_load_file("F:/Work/frpg/server/server2/battle/rule/data/heros.xml");
	$heros = array();
	
	foreach($heroxml->Hero as $hero){
		$id = strval($hero['id']);
		$heros[$id] = $hero;
	}
	
	$data = "";
	
	$towerxml =  simplexml_load_file("F:/Work/frpg/server/server2/battle/rule/data/tower.xml");
	
	foreach($towerxml->level as $lv){
		$slv = strval($lv['name']);
		foreach($lv->floor as $floor){
			$sf = strval($floor['name']);
			foreach($floor->hero as $h){	
				$hid = strval($h['id']);
				if(!isset($heros[$hid])){
					$data .= "Level:{$slv} Floor:{$sf} Hero:{$hid}\n";					
				}
			}
		}
	}
	
	echo $data;
}


main();