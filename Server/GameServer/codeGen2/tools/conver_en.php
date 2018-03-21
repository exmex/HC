<?php
   /**
   $word = new COM("word.application") or die("无法定位WORD安装路径！");
    //echo "\word $word->Version: \n";
   $word->Visible=false;
   $doc_file='d:/php_example/word/1-10_part1.docx';
   $word->Documents->OPen($doc_file);
   $doc_file_contents=$word->ActiveDocument->Content->Text;
   print_r(split('\r\n', $doc_file_contents));
   $word->Quit();**/
   $fp=fopen("d:/php_example/word/city_build_en.txt",'r');
   $enDoc=new DOMDocument('1.0','utf-8');
   $newNode=$enDoc->createElement("language");
    $enDoc->appendChild($newNode);
   if($fp)
   {
      while(!feof($fp))
	  {
		$readline=fgets($fp);
		//echo $readline;
		//print_r($readline);
		writeEn($readline,$enDoc,$newNode);
	  }

   }
    $enDoc->formatOutput = true;
    $enDoc->saveXML();
	$enDoc->save('d:/php_example/word/en.xml');
   function writeEn($enline,$enDoc,$root)
   {
	 $contents=explode(':',$enline);
	 $no=$contents[0];
	  //echo "{$no}\n";
	 //preg_match('/(\(1-10\)|\(1-10 ADDED\)) \w+.jpg/',$no,$matches);
	 //echo "{$matches[0]}\n";
	 preg_match('/\w+.jpg/',$no,$matches);
	 $stepNu= str_replace(".jpg","",$matches[0]);
	 $text='';
	 if(count($contents)>2)
	 {
		$text=$contents[2];
	 }
	 else
	 {
		$text=$contents[1];
	 }
	 //echo "{$text}\n";
	 //echo "{$stepNu}\n";
	 
	 if(strpos($text,"No text"))
	 {
	    return;
	 }
	 $enEl=$enDoc->createElement("String");

	 //echo "{$stepNu}\n";
	 $enEl->setAttribute("key","guide_step_".strtolower($stepNu));
	 $root->appendChild($enEl);
	 $englishEl=$enDoc->createElement("english");

	 $englishEl->appendChild($enDoc->createTextNode($text));
     $enEl->appendChild($englishEl);
   }
?>