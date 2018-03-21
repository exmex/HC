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
  $doc_file='D:/quest_en_1-30.xls';
 Read_Excel_File($doc_file,$return);
 $enDoc=new DOMDocument('1.0','utf-8'); 
 $root=$enDoc->createElement("language");
 $enDoc->appendChild($root);
 for ($i=0;$i<count($return[language]);$i++)
 {
	
	if($i<1)
	{
	  continue;
	}

	writeQuestseting($return[language][$i],$enDoc,$root);
	/**
	for ($j=0;$j<count($return[language][$i]);$j++)
	{
		echo $return[language][$i][$j]."|";
		
	}
	echo '</br>';**/
	
}
    
    $enDoc->formatOutput = true;
    $enDoc->saveXML();
	$enDoc->save('d:/en.xml');
   
   function writeQuestseting($questContent,$enDoc,$root)
   {
    
	if(!$questContent)
	{
		
		return;
	}
	$questName='';
	for ($j=0;$j<count($questContent);$j++)
	{
		//echo $return[questsetting][$i][$j]."|";
		
        switch($j)
	   {
		 case 0:
         $questStr="quest_".str_replace(' ','_',strtolower($questContent[$j]));
		 $questRe=str_replace('!','_',$questStr);
		 $questName=$questRe;
		 echo "{$questName}\n";
		 $questElment=$enDoc->createElement("string");	
		 $questElment->setAttribute("key",$questName.'_intro_title');
		 $english=$enDoc->createElement('english');
		 $english->appendChild($enDoc->createTextNode($questContent[$j]));
		 $questElment->appendChild($english);
		 $root->appendChild($questElment);
		 $questElment_goal=$enDoc->createElement("string");	
		 $questElment_goal->setAttribute("key",$questName.'_goal');
		 $english_goal=$enDoc->createElement('english');
		 $english_goal->appendChild($enDoc->createTextNode($questContent[$j]));
		 $questElment_goal->appendChild($english_goal);
		 $root->appendChild($questElment_goal);
		 $questElment_finish_title=$enDoc->createElement("string");	
		 $questElment_finish_title->setAttribute("key",$questName.'_finish_title');
		 $english_finish_title=$enDoc->createElement('english');
		 $english_finish_title->appendChild($enDoc->createTextNode('Goal Complete!'));
		 $questElment_finish_title->appendChild($english_finish_title);
		 $root->appendChild($questElment_finish_title);
         break;
		 case 1:
		 $questElment_intro=$enDoc->createElement("string");	
		 $questElment_intro->setAttribute("key",$questName.'_intro');
		 $english_intro=$enDoc->createElement('english');
		 $english_intro->appendChild($enDoc->createTextNode($questContent[$j]));
		 $questElment_intro->appendChild($english_intro);
		 $root->appendChild($questElment_intro);
         break;
		 case 2:
		 $questElment_complete=$enDoc->createElement("string");	
		 $questElment_complete->setAttribute("key",$questName.'_finsh');
		 $english_complete=$enDoc->createElement('english');
		 $english_complete->appendChild($enDoc->createTextNode($questContent[$j]));
		 $questElment_complete->appendChild($english_complete);
		 $root->appendChild($questElment_complete);
         break;
		 case 3:
			$tasks=split(',',$questContent[$j]);
		    $at=count($tasks);
		     //echo "{$at}\n";
		     for($f=0;$f<count($tasks);$f++)
			 {
			   	 $questElment_task=$enDoc->createElement("string");
				 $index=$f+1; 
				 $questElment_task->setAttribute("key",$questName.'_'.$index.'_task');
				 $english_task=$enDoc->createElement('english');
				 $english_task->appendChild($enDoc->createTextNode($tasks[$f]));
				 $questElment_task->appendChild($english_task);
				  $root->appendChild($questElment_task);
			 }
		 break;	
		 case 4:
			 	 if($questContent[$j]=='None'||$questContent[$j]=='')
				 {
				    return;
				 }
	          	 $questElment_question=$enDoc->createElement("string"); 
				 $questElment_question->setAttribute("key",$questName.'_question');
				 $english_question=$enDoc->createElement('english');
				 $english_question->appendChild($enDoc->createTextNode($questContent[$j]));
				 $questElment_question->appendChild($english_question);
				 $root->appendChild($questElment_question);
         break;
	   }  

	}
    
   }
?>