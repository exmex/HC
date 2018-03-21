<?php 

	  //echo '\n hello world\n';
	  //$xmlPath="C:/ds/server/server2/rule/data/";
	  $xmlPath="../../../client/dsFantasy/src/xml/";
	  $itemDoc=new DOMDocument("1.0","UTF-8");
	  
	  $itemDoc->load($xmlPath."heros.xml");
	  if($itemDoc==null)
	  {
		echo 'item_src.xml not find';
		return;  
	  }
	  
  // $itemRoot=$itemDoc->documentElement;
   $xpath=new DOMXPath($itemDoc);
   $dataNodes=$xpath-> evaluate('/Heros/Hero');
   /**
   $enDoc=new DOMDocument('1.0','utf-8');
   $newNode=$enDoc->createElement("language");
   $enDoc->appendChild($newNode);**/
  
   $enDoc=new DOMDocument();
   $enDoc->load($xmlPath."en.xml");
   	$enHeros= $enDoc->getElementsByTagName("heros");
	$enNodes=$enHeros->item(0)->getElementsByTagName("String");
   $enData=getEnData($enNodes); 
   //echo  $enData;
   foreach ($dataNodes as $node)
   {
     $heroId=$node->getAttribute("id");
	 $heroName=$node->getAttribute("name");
	 $match= "/[\x80-\xff]/";
	 $heroName=trim(preg_replace($match,"",$heroName)); 
     
	  //echo  $enData[$heroId];
	  //echo "\r\n";
	  $enEL=checkEnData($heroId,$enData);
	  writeEn("hero_".$heroId,$heroName,$enDoc,$enHeros->item(0),$enEL);
   }
    $enDoc->formatOutput = true;
    $enDoc->saveXML();
	$enDoc->save($xmlPath.'en.xml');

 function writeEn($key,$content,$enDoc,$root,$enEl)
   {
	 
	 if(empty($enEl))
	 {
		echo "append";
		echo $key;
		echo "\r\n";
		$enEl=$enDoc->createElement("String");
		$enEl->setAttribute("key",$key);
		$root->appendChild($enEl);
		$englishEl=$enDoc->createElement("english");
		$englishEl->appendChild($enDoc->createTextNode($content));
		$enEl->appendChild($englishEl);
	 }
	 else
	 {
	   $english=$enEl->getElementsByTagName("english");
	   if(!empty($english))
		{
			$english->item(0)->nodeValue=$content;
	     }
		  
	 }
   }

  function getEnData($enNodes)
  {
    $datas=array();

	if(!empty($enNodes))
	{
		/**
		$xpath=new DOMXPath($xml);
		$enNodes=$xpath->evaluate('language/heros/String');**/
		//$enHeros=$xml->getElementsByTagName("heros");
		//$enNodes=$enHeros->item(0)->getElementsByTagName("String");
		foreach($enNodes as $hero)
		{
			//echo 'sdfsdfdfs';
			//echo ''.$hero->item(0)["key"];
			
			//$datas[$hero["key"]]=$hero;
			//echo $hero->attributes->item(0)->nodeValue;
			//echo "\r\n";
			//$key=$hero->attributes->item(0)->nodeValue;
			//echo $key;
			//echo "\r\n";
			$datas[]=$hero;
		}
	}
    return $datas;
  }

  function checkEnData($key,$enData)
  {
      //echo "checked: ".$key;
	  //echo "\r\n";
	 foreach($enData as $en)
	 {
		$enId=$en->attributes->item(0)->nodeValue;
		//echo $enId;
		//echo "\r\n";
		if("hero_".$key==$enId)
		{
		   //echo "get: ".$enId;
		  return $en;
		}
	 }
	 return  null;
  }

?>