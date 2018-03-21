<?php
  
  //$items=simplexml_load_file('item_src.xml');

 
   $amations=array("decoration.tennis_court", "decoration.baseball_field", "decoration.windmill", "decoration.squirrel_pole", "decoration.pet_4", "decoration.basketball_court", "decoration.pet_3", "decoration.playground", "decoration.pet_1", "decoration.pet_2", "decoration.gift_sheep", "decoration.gift_goat", "decoration.gift_cow", "decoration.gift_cock", "decoration.gift_pig", "decoration.gift_horse", "decoration.gift_kangaroo", "decoration.gift_bull", "decoration.polar_bears", "decoration.bandstand","decoration.flag_pole", "decoration.tiered_fountain", "decoration.big_fountain");
  
    function checkDataDfXml()
	{
	  //echo '\n hello world\n';
	 
	  $itemDoc=new DOMDocument();
	  $itemDoc->load('item2.xml');
	  if($itemDoc==null)
	  {
		echo 'item_src.xml not find';
		return;  
	  }
	  
  // $itemRoot=$itemDoc->documentElement;
   $xpath=new DOMXPath($itemDoc);
   $nodes=$xpath-> evaluate('/items/item');
 
   $out_PATH='assets/';
   

   
  //$resoures=simplexml_load_file('data_df.xml');
  /**
   $dataDoc=new DOMDocument();
   $dataDoc->load('data_df.xml');
  // $itemRoot=$itemDoc->documentElement;
  

   
  //$resoures=simplexml_load_file('data_df.xml');
  if($dataDoc==null)
  {
    echo 'item_src.xml not find';
	return;  
   }
   $d_xpath=new DOMXPath($dataDoc);
   $root=$dataDoc->getElementsByTagName("data")->item(0);
   $dataDoc->formatOutput=true;**/

   //$children= $itemRoot->childNodes;
   $dataDoc=new DOMDocument();
   $dataDoc->load('data_df.xml');
  if($dataDoc==null)
  {
    echo 'item_src.xml not find';
	return;  
   }

  
   $d_xpath=new DOMXPath($dataDoc);
   $root=$dataDoc->getElementsByTagName("data")->item(0);
   $defDoc=new DOMDocument();
   try
	{
   $defDoc->load('../xml/definitions/farmObjDef.xml');
	}
	catch(Exception $ex)
	{
	  echo 'file has some problem';
	  return;
	}


   foreach($nodes as $it)
   {
	    $item_id=$it->getAttribute('id');
		$item_type=$it->getAttribute('type');
		echo "itemId $item_id: \n";
		 //print_r('\n\r');
		$typePath='';
    
	if($defDoc)
			 {
			  if($item_type=='packet'||$item_type=='expansion'||$item_type=='collectable'
			  ||$item_type=='tool'||$item_type=='buff'||$item_type=='energy'||$item_type=='equipment'
			  ||$item_type=='fragment'||$item_type=='stone')
			  {
			   continue;
			  }
			 $result=checkFarmDef($defDoc,$item_id);
			
			 if(!$result)
			 {
			  echo "\n farmdef not find: $item_id: \n";
			 }
				
		}
     
	  $is_frm=false;
	  $is_ico=false;
	  $dataNodes=$d_xpath-> evaluate('/data/SWFLoader');
	   
	   
	   foreach($dataNodes as $data)
	   {
	       $orName=$data->getAttribute('name');
		     //   echo "\n $orName: \n";
		   if($item_id==""|| $orName=="")
		   {
		     echo "\n without name: $item_id \n";
			 continue;
		   }
	
		   $sliptNames=explode('_frm',$orName);
		   $flag=strpos($orName,'_frm');
		   
		  
		   if(!$flag&&$orName== $item_id)
		   {
             //print_r(" item_id: ");
		     //print_r($item_id);
			
			    $is_ico=true;
			
		  
			//echo "\nitem $item_id: \n";
		   } 
		  
		   if($flag&&$sliptNames[0]== $item_id)
		   {
			  //echo "\nfrmArry $sliptNames[0]: \n";
				
				$is_frm=true;
		   }
		 
	   }

	    if(!$is_ico)
		   {
		   
		     if($item_type!='constructionsite'&&
				 $item_type!='wilderness'&&$item_type!='fragment')
			 {
			 $newIco=$dataDoc->createElement('SWFLoader');
			 $newIco->setAttribute('name',$item_id);
			 $newIco->setAttribute('load','false');
			 $newIco->setAttribute('md5','');
		     if($item_type=='plot_contract'||$item_type=='collectable'||
				 $item_type=='tool'||$item_type=='buff'||$item_type=='road'||$item_type=='plot'||$item_type=='expansion')
		     {
				$typePath="shopItemAssets/".$item_type."/";  
	         }
			 else if($item_type=='packet')
			 {
			 $typePath='playWar/package/';
			 }
			 else if($item_type=='equipment')
			 {
			   $typePath="playWar/".$item_type."/"; 
			 }
			 else
			 {
			    $typePath="playWar/battle_building_icon/".$item_type."/";  
			 }
			 $newIco->setAttribute('url',$out_PATH.$typePath.$item_id.".swf");
			
			 if($newIco)
		     {
			 $root->appendChild($newIco);
		     echo "\nChecking $item_id: \n";
			 }
			   
			 }
		    
		   }
   
	   if(!$is_frm)
		   {
		   echo "\n".$item_id."_frm"."\n";
			 if($item_type=='packet'||$item_type=='expansion'||$item_type=='collectable'
			 ||$item_type=='tool'||$item_type=='buff'||$item_type=='energy'||$item_type=='equipment'
			 ||$item_type=='fragment'||$item_type=='stone')
			 {
			   continue;
			 }
			
		     $newFrm=$dataDoc->createElement('SWFLoader');
			 $newFrm->setAttribute('name',"{$item_id}_frm");
			 $newFrm->setAttribute('load','false');
			 $newFrm->setAttribute('md5','');
			  if($item_type=='constructionsite'||$item_type=='road'||$item_type=='plot_contract'||
				  $item_type=='wilderness'||$item_type=='plot'||$item_type=='plot_contract')
		     {
				$typePath="farmItemAssets/$item_type/";  
	         }
			 else
			 {
			   $typePath="playWar/battle_building/".$item_type."/";  
			 }
			 $newFrm->setAttribute('url',$out_PATH.$typePath.$item_id."_frm.swf");
			 if($newFrm!=null)
			 {
			 $root->appendChild($newFrm);
			 }
		    echo "\n".$item_id."_frm"."\n";
		   }
	}
	
	if($dataDoc)
	{
	$dataDoc->saveXML();
    $dataDoc->save('data_df.xml');
	}
	if($defDoc)
	{
	echo 'save file';
	$defDoc->saveXML();
	$defDoc->save('../xml/definitions/farmObjDef.xml');
	}
	}

    function checkFarmDef($doc,$itemId)
	{
	 $d_xpath=new DomXPath($doc);
	 
	 $root=$doc->getElementsByTagName("definitions")->item(0);
	 
	 $defNodes=$d_xpath-> evaluate('/definitions/objectDefinition');

	 if($defNodes)
	 {
		foreach($defNodes as $def)
		{
	   $defName=$def->getAttribute('name');
	   if($defName==$itemId)
	   {
	
		 return true;
	   }

	 }
	 
	 }
	 
	 $newNode=$doc->createElement("objectDefinition");
	 $newNode->setAttribute("name",$itemId);
     if(findMontion($itemId))
     {
	  $newNode->setAttribute("animated","true");
	 }
	 $displayModel=$doc->createElement("displayModel");
	 $displayModel->setAttribute('name',$itemId.'_frm');
	 $sprite=$doc->createElement("sprite");
	 $sprite->setAttribute('angle','0');
	 $sprite->setAttribute('src',$itemId.'_frm');
	 $sprite->setAttribute('shadowsrc','');
	 $displayModel->appendChild($sprite);
	 $newNode->appendChild($displayModel);

	 $collisionModel=$doc->createElement("collisionModel");
	 $cilinder=$doc->createElement("cilinder");
	 $cilinder->setAttribute('radius','1');
	 $cilinder->setAttribute('height','0');
	 $collisionModel->appendChild($cilinder);
     $newNode->appendChild($collisionModel);
      
	 $root->appendChild($newNode);
	 return false;
	}
   
     function  findMontion($itemId)
	 {
	    foreach($GLOBALS['amations'] as $id)
		{
		   if($id==$itemId)
		   {
			   return true;
		   }
		}
		return false;
	 }
     
 checkDataDfXml();
  
?>