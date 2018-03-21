<?php 
modityJsfl();
$maps=getreplaceSourceList();
//$maps=array();
$GLOBALS["projectPath"]="../../../client/dsFantasy/";

foreach($maps as $map)
{
	$path=$map["srcPath"];
	$path2=$GLOBALS["projectPath"]."src/assets/playWar/push_map/map_normal/map_normal_".$map["mapResId"];
	$res_name="map_normal_".$map["mapResId"];	
    
	$data_other_xml_path=$GLOBALS["projectPath"]."src/xml/data.xml";
	$dataOtherXml=new DOMDocument("1.0","UTF-8");
	$dataOtherXml->load($data_other_xml_path);
	
	$map_road_path=$GLOBALS["projectPath"]."src/xml/maps_road.xml";
	$maproadXml=new DOMDocument("1.0","UTF-8");
	$maproadXml->load($map_road_path);

	$map_path=$GLOBALS["projectPath"]."src/xml/maps.xml";
    $mapsXml=new DOMDocument("1.0","UTF-8");
	$mapsXml->load($map_path);
	
	if(!is_dir($path2))
	{
		mkdir($path2);			
	}
	$mapFile=array();
	$maxcol=1;
	$maxrow=1;
	$maxWidth=0;
	$maxHeight=0;
	if(is_dir($path))
	{
		if($dh=opendir($path))
		{
        
			while(($file=readdir($dh))!==false)
			{
				if($file!="."&&$file!="..")
				{
				   $strs=explode("_",$file);
				   $row=intval(str_replace("r", "", $strs[1]));
				   $col=intval(str_replace("c", "", $strs[2]));
				   $sourceP=$path."/".$file;
				  $mapFile[]=array("row"=>$row,"col"=>$col,"sourcePath"=>$sourceP);
				  $list=getimagesize($sourceP);
				  if($maxcol<$col)
				  {
					$maxcol=$col;
					$maxHeight=$list[1]*$col;
				  }
				  if($maxrow<$row)
				  {
					$maxrow=$row;
					$maxWidth=$list[0]*$row;
				  }
	
				}
		 }
	
	 closedir($dh);
  }
}
/**
echo "-----param----";
echo "\r\n";
echo "mapResId: ".$map["mapResId"];
echo "\r\n";
echo "maxcol: ".$maxcol." maxrow: ".$maxrow;
echo "\r\n";
echo "maxHeight: ".$maxHeight." maxWidth: ".$maxWidth;
echo "\r\n";
echo "fileCount: ".count($mapFile);
echo "\r\n";
echo "-----end----";**/
$loaderData=createDataToDataXml($dataOtherXml,$map["mapResId"],$res_name,strval($maxcol),strval($maxrow),
	   strval($maxWidth),strval($maxHeight));


foreach($mapFile as $f)
{
  $id=($f["row"]-1)*$maxcol+($f["col"]-1);
   /** 
   echo "id: ".$id;
   echo "\r\n";**/
   $targetP=$path2."/".$res_name."_".$id.'.png';

   if(!file_exists($f["sourcePath"]))
   {
	continue;
   }
   //echo "srcpath: ".$f["sourcePath"]."targetpath: ".$targetP;
   //echo "\r\n";
   copy($f["sourcePath"],$targetP);
   addDataUrl($dataOtherXml,$loaderData,$id);

}
   synmapsAndMapRoadXml($mapsXml,$maproadXml,$res_name,
	$maxcol,$maxrow,$maxWidth,$maxHeight,$map["mapId"]);
    $dataOtherXml->formatOutput = true;
    $dataOtherXml->saveXML();
	$dataOtherXml->save($data_other_xml_path);

	$mapsXml->formatOutput = true;
    $mapsXml->saveXML();
	$mapsXml->save($map_path);

	$maproadXml->formatOutput = true;
    $maproadXml->saveXML();
	$maproadXml->save($map_road_path);
}
 
function checkIsExistInDataXml($data,$mapResId)
{
   $slicelds=$data->getElementsByTagName("SliceLoader");
   foreach($slicelds as $sliceld)
   {
	  if($sliceld->getAttribute("mapId")==$mapResId)
	  {
	      return $sliceld;
	  }
   }
   return null;
}

function createDataToDataXml($data,$mapResId,$name,
$maxCol,$maxRow,$mapWidth,$mapHeight)
{
    $dataLoader=checkIsExistInDataXml($data,$mapResId);
	if(empty($dataLoader))
	{
	    $dataLoader=$data->createElement("SliceLoader");
		$root=$data->getElementsByTagName("data");
		$root->item(0)->appendChild($dataLoader);
	}

	   $dataLoader->setAttribute("mapId",$mapResId);
	   $dataLoader->setAttribute("bgResName",$name);
	   $dataLoader->setAttribute("col",$maxCol);
	   $dataLoader->setAttribute("row",$maxRow);
	   $dataLoader->setAttribute("mapWidth",$mapWidth);
	   $dataLoader->setAttribute("mapHeight",$mapHeight);
	   return  $dataLoader;
}

function addDataUrl($dom,$node,$loaderId)
{
	   $url=null;
	   if(empty($dom))
	   {
		return;
	   }
	   $mapResId=$node->getAttribute("mapId");
	   $urls=$node->getElementsByTagName("url");
       foreach($urls as $u)
	   {
	      if($u->getAttribute("sliceId")==$loaderId)
		  {
		    $url=$u;
			break;
		  }
	   }
	   if(empty($url))
	   {
		 $url=$dom->createElement("url");
		 $node->appendChild($url);
	   }
	   $url->setAttribute("sliceId",$loaderId);
	   $url->setAttribute("url","assets/playWar/push_map/map_normal/map_normal_{$mapResId}/map_normal_{$mapResId}_{$loaderId}.swf");
	   $url->setAttribute("md5","");
}

function synmapsAndMapRoadXml($maps,$maps_road,$resname,$maxcol,$maxrow,$width,$height,$mapId)
{
   $maproot=$maps->getElementsByTagName("maps");
   $mapEls=$maproot->item(0)->getElementsByTagName("map");
   $mapIds=split(",",$mapId);
   $records=array();
   $roadroot=$maps_road->getElementsByTagName("maps");
   foreach($mapEls as $el)
   {
      foreach($mapIds as $mId)
	  {
		if($el->getAttribute("id")==$mId)
		{
		  $records[]=$mId;
		  if($el->getAttribute("row")!=strval($maxrow)||
			  $el->getAttribute("col")!=strval($maxcol))
		  {
				$el->setAttribute("row",strval($maxrow));
				$el->setAttribute("col",strval($maxcol));
				$el->setAttribute("mapWidth",strval($width));
				$el->setAttribute("mapHeight",strval($height));
			
				$npclist=$el->getElementsByTagName("npc");
				foreach($npclist as $npc)
			    {
					$heros=$npc->getElementsByTagName("hero");
					foreach($heros as $hero)
					{
						$patrol=$hero->getAttribute("patrol");
						if(!empty($patrol))
						{
							$hero->setAttribute("patrol","[]");
						}
					}
				}
				
				$maproads=$roadroot->item(0)->getElementsByTagName("map");
				foreach($maproads as $road)
			    {
					if($el->getAttribute("id")==
						$road->getAttribute("id"))
					{
						$road_map=$road->getElementsByTagName("road_map");
						$road_map->item(0)->nodeValue="[]";
						$eventItems=$road->getElementsByTagName("item");
						foreach($eventItems as $eventItem)
						{
							$eventItem->setAttribute("data","[]");
						}
					}
				}
		  }
	  }
	  }

   }
	foreach($mapIds as $mid)
	{
	  $find=false;
	  foreach($records as $rid)
	  {
	     if($rid==$mid)
		 {
		    $find=true;
		 }
	  }
	  if(!$find)
	  {
	      $mel=$maps->createElement("map");
		  $mel->setAttribute("id",$mid);
		  $mel->setAttribute("guideId","");
		  $mel->setAttribute("name","");
		  $mel->setAttribute("bgResName",$resname);
		  $mel->setAttribute("depend","0");
		  $mel->setAttribute("branch","0");
		  $mel->setAttribute("instance","1");
		  $mel->setAttribute("fromMap","");
		  $mel->setAttribute("gridWidth","40");
		  $mel->setAttribute("gridHeight","40");
		  $mel->setAttribute("birthX","0");
		  $mel->setAttribute("birthY","0");
		  $mel->setAttribute("mapWidth",strval($width));
		  $mel->setAttribute("mapHeight",strval($height));
		  $mel->setAttribute("col",strval($maxcol));
		  $mel->setAttribute("row",strval($maxrow));
		  $maproot->item(0)->appendChild($mel);
		  $roadEl=$maps_road->createElement("map");
		  $roadEl->setAttribute("id",$mid);
		  $rMapEl=$maps_road->createElement("road_map");
		  $rMapEl->nodeValue="[]";
		  $roadEl->appendChild($rMapEl);
		  $roadroot->item(0)->appendChild($roadEl);
	  }
	}
}

function getMd5ByDir($dir)
{
 	  //echo $dir;
	//echo "\r\n";
  if(is_dir($dir))
  {
  // echo "sfsddfsdff".$dir;
	$md5Files=array();
	if($dh=opendir($dir))
	{
		while(($file=readdir($dh))!==false)
		{
		   if($file!="."&&$file!=".."
				&&$file!='.svn')
		  {
			  if(is_file($file))
			  {
				$md5Files[]=md5_file($dir.'/'.$file);
			  }
		   }
		}
	
	}
	closedir($dh);
	return md5(implode(",",$md5Files));
  }
   //echo "none";
	// echo "\r\n";
  return "";
}

function getreplaceSourceList()
{
    //$filePath=iconv('utf-8', 'gbk',"工具脚本/推图背景打包/conf/map_resource.xml");
	$filePath="../../../client/工具脚本/推图背景打包/conf/map_resource.xml";
	$resouceXml=new DOMDocument("1.0","UTF-8");
	$resouceXml->load($filePath);
    $source=array();
	if(empty($resouceXml))
	{
	 return $source;
	}
	$root=$resouceXml->getElementsByTagName("resources")->item(0);
	$resources=$root->getElementsByTagName("resource");
	$find=false;
	foreach($resources as $r)
    {
	 $md5=$r->getAttribute("md5");
	 $path=iconv('utf-8', 'gbk',$r->getAttribute("srcPath"));
	 $getMd5=getMd5ByDir($path);
	 if(strval($md5)==strval($getMd5))
	 {
		 continue;
	 }
	 $find=true;
	 $source[]=array("mapResId"=>$r->getAttribute("resId"),
		 "srcPath"=>$path,"md5"=>$getMd5,"mapId"=>$r->getAttribute("mapid"));
	     $r->setAttribute("md5",$getMd5);
	}
	if($find)
	{
		$resouceXml->formatOutput = true;
		$resouceXml->saveXML();
		$resouceXml->save($filePath);
	}
	return  $source;
}
function modityJsfl()
{
 //$path=iconv('utf-8','gbk',"工具脚本/推图背景打包/export_shortcut.jsfl");
$path="../../../client/工具脚本/推图背景打包/export_shortcut.jsfl";


  //echo $path;
 //echo "\r\n";
//$path="../../codeGen2/jsfl/a.txt";
  if(!file_exists($path))
  {
   // echo "ddfdfdf";
	return;
  }
  $realPath=pathinfo( __FILE__ , 1) ;
  $ps=split("\\\\",strval($realPath));
  // echo $realPath;
  // echo "\r\n";
  $rootPath=str_replace(":","",$ps[0]);
  $url1=$rootPath."|/".$ps[1]."/";
// echo $url1;
  $tstr=file_get_contents($path);
  $newStr=str_replace("{path}",$url1,$tstr);
  $ff=fopen($path,'w');
  if($ff)
  {
   	fwrite($ff,$newStr);
	fclose($ff);
  }
  
}

?>