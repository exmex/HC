<?php

function main()
{
	$enskill = simplexml_load_file("F:/Work/frpg/dsfantasy/client/dsFantasy/src/xml/en.xml");
	$heroxml = simplexml_load_file("F:/Work/frpg/dsfantasy/client/dsFantasy/src/xml/heros.xml");
	
	$skillKeys = array();
	$unnameSkill = array();
	
	foreach($enskill->skills->String as $sk){
		$k = strval($sk['key']);
		$skillKeys[$k] = $sk;
	}
	
	foreach($heroxml->Hero as $hr){
		if(isset($hr['skill'])){
			$hk = "skill_".strval($hr['skill']);
			if(!isset($skillKeys[$hk])){
				$unnameSkill[$hk] = $hk;
			}
			
		}
	}

	foreach($unnameSkill as $k=>$v){
		$a = $enskill->skills->addChild("String");
		$a['key'] = $k;
		$a->addChild("english",$k);
	}
	
	$enskill->asXML("F:/Work/frpg/dsfantasy/client/dsFantasy/src/xml/en.xml");
	
	//echo count($skillKeys);
}


main();