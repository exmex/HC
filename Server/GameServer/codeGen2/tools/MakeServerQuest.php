<?php

function main()
{
	$quests = array("quest_first_neighborhood",
					"quest_catch_the_ball_before_the_bound",
	"quest_former_fellow_combattant",
	"quest_find_sacred_fountain",
	"quest_alliance",
	"quest_treasure_hunting",
	"quest_ally_needs_help",	
	"quest_gathering_information",
	"quest_altonerin_aleani",
	"quest_tane_highhowler",
	"quest_battle_in_ancient_site",
	"quest_altonerin_aleani",
	"quest_kyrusi_warhowl",
	"quest_obstruction_from_dragons",
	);
	
	
	$questxml = simplexml_load_file("F:/Work/frpg/client/dsFantasy/src/xml/questSettings.xml");
	$questset = array();
	
	foreach($questxml->quest as $quest){
		$name  = strval($quest['name']);
		$questset[$name] = $quest;
	}
	
	$data = "";
	foreach($quests as $qn){
		if(!isset($questset[$qn])){
			echo "invalid quest {$qn}\n";
			continue;
		}
		
		$data .= "{$qn}\r\n";
		
		$quest = $questset[$qn];
		$xml = simplexml_load_string("<tasks/>");	
		foreach($quest->tasks->task as $task){
			$t = $xml->addChild("task");
			$t['action'] = strval($task['action']);
			$t['type'] = strval($task['type']);
			$t['total'] = strval($task['total']);
			$t['count'] = 0;
		}
		
		$data .= $xml->asXML()."\r\n";
	}

	file_put_contents("f:/kkk.log",$data);
}


main();