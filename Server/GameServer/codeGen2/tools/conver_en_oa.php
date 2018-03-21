<?php
	require "excel_class.php";
   /**
   $excel = new COM("Excel.application") or die("无法定位WORD安装路径！");
    //echo "\word $word->Version: \n";
   //$excel->Visible=false;
   $sheet1='questsetting';
   $doc_file='d:/php_example/word/quest.xls';
   $Workbook =$excel-> Workbooks-> Open( "$doc_file")   or   Die( "Did   not   open     $doc_file   $Workbook "); 
   $Worksheet=$Workbook-> Worksheets($sheet1); **/
  $doc_file='d:/php_example/word/quest_2.xls';
 Read_Excel_File($doc_file,$return);
 $enDoc=new DOMDocument('1.0','utf-8'); 
 $root=$enDoc->createElement("quests");
 $enDoc->appendChild($root);
 for ($i=0;$i<count($return[questsetting]);$i++)
 {
	
	if($i<2)
	{
	  continue;
	}

	writeQuestseting($return[questsetting][$i],$enDoc,$root);
	/**
	for ($j=0;$j<count($return[questsetting][$i]);$j++)
	{
		echo $return[questsetting][$i][$j]."|";
		
	}
	echo '</br>'**/;
	
}
    
    $enDoc->formatOutput = true;
    $enDoc->saveXML();
	$enDoc->save('d:/php_example/word/questSettings.xml');
   
   function writeQuestseting($questContent,$enDoc,$root)
   {
    $questElment=null;
	if($questContent)
	{
		$questElment=$enDoc->createElement("quest");

	}
	else
    {
	  return;
	}
	for ($j=0;$j<count($questContent);$j++)
	{
		//echo $return[questsetting][$i][$j]."|";
        switch($j)
	   {
		 case 0:
		 $questElment->setAttribute("name","quest_".str_replace(' ','_',$questContent[$j]));
		 $questElment->setAttribute("url","quest_".str_replace(' ','_',$questContent[$j]));
		 $questElment->setAttribute("autoShowPopup",'false');
		 $questElment->setAttribute("comleteDelay",'true');
		 $questElment->setAttribute("questType",'');
		 $introElement=$enDoc->createElement("intro");
		 $introElement->setAttribute('text',"quest_".str_replace(' ','_',$questContent[$j]));
		 $introElement->setAttribute('questIconUrl','');
		 $questElment->appendChild($introElement);
         break;
		 case 1:
			//echo "previous: {$questContent[$j]}\n";
		    $perviousName="quest_".$questContent[$j];
		    if(strpos('none',$questContent[$j]))
			{
				$perviousName='none';
			}
			$questElment->setAttribute("previous",$perviousName);
         break;
		 case 2:
			 $tasks=explode('\n',$questContent[$j]);
		     $tasksEl=$enDoc->createElement("tasks");
			 $questElment->appendChild($tasksEl);
			
		     for($f=0;$f<count($tasks);$f++)
			 {
			     //echo "{$tasks[$f]}\n";
				 $taskItems=explode(',',$tasks[$f]);
				 $count=count($taskItems);
				 echo "{$count}\n";
				 $taskEl=$enDoc->createElement("task");
				 $tasksEl->appendChild($taskEl);
				 for($z=0;$z<count($taskItems);$z++)
				 {
				    //echo "task：{$taskItems[$z]}\n";
					 
					 $taskItem=explode("=",$taskItems[$z]);
					 
					 //$count=count($taskItem);
					  //echo "task: {$$taskItems[z]}\n";
					 $key=$taskItem[0];
					 $value='';
	                 if(count($taskItem)>1)
					 {
					  $value=$taskItem[1];
					 }
					 if($key=='')
					{
						continue;
					}
					 $taskEl->setAttribute($key,$value);
				 }
			 }
         break;
		 case 3:
			$rewards=$enDoc->createElement("resourceReward");
		    $questElment->appendChild($rewards);
			
			$rewardStrs=explode("=",$questContent[$j]);
			
			$key1=$rewardStrs[0];
			$value1='';
	        if(count($rewardStrs)>1)
			{
				$value1=$rewardStrs[1];
			}
			$reward=$enDoc->createElement("questRewards");
			$rewards->appendChild($reward);
			if($key1=='')
			{
			   continue;
			}
			$reward->setAttribute($key1,$value1);	

		 break;
		 case 4:
			$complete=$enDoc->createElement("complete");
		    $questElment->appendChild($complete);
			echo "{$questContent[$j]}\n";
			$completes=explode(',',$questContent[$j]);
			for($k=0;$k<count($completes);$k++)
			{
				$completeItem=explode("=",$completes[$k]);
				$key2=$completeItem[0];
			    $value2='';
	            if(count($completeItem)>1)
			    {
					$value2=$completeItem[1];
				}
				if($key2=='')
			    {
					continue;
				}
			
				$complete->setAttribute($key2,$value2);
		   }
		 break;	
	   }  

	}
     $root->appendChild($questElment);
   }
?>