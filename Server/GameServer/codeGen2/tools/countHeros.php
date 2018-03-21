<?php

function main()
{
	$xml = simplexml_load_file("F:/Work/frpg/dsfantasy/client/dsFantasy/src/xml/maps.xml");
	foreach($xml->map as $map){
		foreach($map->npcs->npc as $npc){
			$heroid = trim(strval($npc['heroId']));
			if(!empty($heroid)){
				echo "{$heroid}\n";
			}
		}
	}
	
}


main();