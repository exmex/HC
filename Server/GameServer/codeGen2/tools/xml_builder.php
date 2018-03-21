<?php

function build_xml($dir, $filename, $ext) {
	$xml = "";
	if ($ext === ".swf") {
		//<SWFLoader name="quest_icon_franchise_expert" url="assets/missions/quest_icon_franchise_expert.swf" load="false"/>
		$xml = "<SWFLoader ";
	} else if ($ext === ".mp3") {
		$xml = "<MP3Loader ";
	} else if ($ext === ".xml") {
		$xml = "<XMLLoader ";
	} else if ($ext === ".zip") {
		$xml = "<DataLoader ";
	} else {
		return "";
	}
	
	return $xml."name=\"".$filename."\" url=\"".$dir.$filename.$ext."\" load=\"false\" />";
}

$doc = "";

function recursive_dir($dir){
	$allow_ext = array(".swf", ".mp3", ".xml", ".zip");
	
	$handle = @opendir($dir);
	if (!$handle){
		return "";
	}
	
	global $doc;
	
	do {
		$file = readdir($handle);
		if ($file === false) {
			break;
		}
		if (($file !== ".") && ($file !== "..")) {
			$file = $dir.$file;
			if (is_dir($file)) {
				recursive_dir($file);
			} else {
				$name = strrchr($file, DIRECTORY_SEPARATOR);
				if ($name != false) {
					$name = substr($name, 1, strrpos($name, '.') - 1);
					$ext = strrchr($file, '.');					
					if (($dir !== false) && ($ext !== false)) {
						if (in_array(strtolower($ext), $allow_ext)) {
							$doc = $doc.build_xml($dir, $name, $ext);
						}
					}
				}
			}
		}
	} while (true);	

	@closedir($handle);
	
	return "";
}

$doc = "<?xml version=\"1.0\" encoding=\"UTF-8\"?><data>";
recursive_dir("..\\assets\\");
echo $doc."</data>";
?>