<?php

function main()
{
	$src = array("F:/Work/frpg/dsfantasy/client/dsFantasy/src/xml/data_df.xml",
	"F:/Work/frpg/dsfantasy/client/dsFantasy/src/xml/data.xml");
	
	foreach($src as $s){
		$xml = simplexml_load_file($s);
		foreach($xml->SWFLoader as $swf){
			if(strval($swf['load'])=="true"){
				echo strval($swf['name'])."\n";
			}
		}
	}
	
}


main();