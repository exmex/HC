<?php


function main()
{
	$xml = simplexml_load_string("<commingnext/>");		
	$xmlen = simplexml_load_string("<commingnext/>");	
	$xmlpic = simplexml_load_string("<commingnext/>");	
	
	for($i = 0; $i < 10; $i++){
		$c = $xml->addChild("title");
		$c["id"] = $i;
		
		
		
		for($j = 1; $j <= 3; $j++){
			$cc = $c->addChild("item");
			
			$name = "commingnext_{$i}_{$j}";
			
			$cc["pic"] = $name;
			$cc["tips"] = $name;
			$ce = $xmlen->addChild("string");
			$ce["key"] = $name;
			$ce->addChild("english","TODO");
			
			$cp = $xmlpic->addChild("SWFLoader");
			$cp["name"] = $name;
			$cp["url"] = "assets/playWar/cityupgrade_icon/lv{$i}_0{$j}.swf";
			$cp["load"] = "false";
			$cp["md5"] = "";
		}
	}
	
	$xml->asXML("F:/Work/frpg/client/dsFantasy/src/xml/commingnext.xml");
	$xmlen->asXML("F:/Work/frpg/client/dsFantasy/src/xml/commingnext_en.xml");
	$xmlpic->asXML("F:/Work/frpg/client/dsFantasy/src/xml/commingnext_pic.xml");
}


main();