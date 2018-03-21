<?php

function main()
{
	$xml = simplexml_load_file("F:/Work/arena.xml");
	
	for($i=11; $i <=50; $i++){
		$node = $xml->addChild("rewards");
		$node["rank"] = $i;
		$node["coins"] = 80000 + (50-$i)*5000;
		$node["reputation"] = 250 + (50-$i)*25;
	}
	
	
	$xml->asXML("F:/Work/arena.xml");
}


main();