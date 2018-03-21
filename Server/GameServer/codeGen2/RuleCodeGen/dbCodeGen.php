<?php
date_default_timezone_set("EST");
require_once ("DBParser.php");	
		
	define('BASE_TPL_PATH',dirname(__FILE__)."/tpl/");
	define('BASE_OP_PATH','../../server2/db/');		
				
	$targetTables = array(); 
	if($argc > 1){
		for($i=1;$i<$argc;$i++){
			$targetTables[]=$argv[$i];
		}
	}	
	//$targetTables = array('player','player_arena_info','player_battle','player_cooldown','player_cultivation_times','player_diamond','player_equipments','player_farm','player_formation','player_heros','player_items','player_league','player_maps','player_quest_status','player_sacrifice','player_tech');
	
	$dbparser = new DBParser(BASE_TPL_PATH,BASE_OP_PATH); 

	$dbparser->parse($targetTables);
	
	echo "finished";
