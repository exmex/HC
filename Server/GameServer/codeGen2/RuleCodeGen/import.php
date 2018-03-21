<?php

require_once 'config.php';
require_once 'CMySQL.php';

function main() 
{
	$FILE = "../rule_src/ItemRule.xml";
	
	importItemRuleToDB ( $FILE );
	
	genNewItemXml($FILE,ITEM_RULE_DEST);
	
}

function genNewItemXml($fileImport,$fileExport)
{
	$xml = simplexml_load_file($fileImport);
	
	$items = $xml->children();
	
	foreach($items as $item)
	{
		$item['id'] = ($item['type'].".".$item['name']);		
	}
		
	$xml->asXml($fileExport);
}

function importItemRuleToDB($file) 
{
	MySQL::getInstance ()->RunQuery ( "DELETE FROM `rule_item`" );
	
	$xmls = file_get_contents ( $file );
	
	$k = str_replace ( "\r\n", " ", $xmls );
	
	if (preg_match_all ( "|<item (.*)>(.*)<\/item>|U", $k, $items )) 
	{
		foreach ( $items [0] as $item ) 
		{
			if (preg_match("/<item([^\>]*)/",$item,$hds))
			{
				$head = $hds[1];
				if (preg_match ( "/name=\"([^\"]*)/", $head, $ns )) 
				{
					$name = $ns [1];
					$type = "";
					
					if (preg_match ( "/display_name=\"([^\"]*)/", $head, $ds )) 
					{
						$display_name = $ds [1];
					} else {
						$display_name = $name;
					}
					
					if (preg_match ( "/type=\"([^\"]*)/", $head, $ts )) 
					{
						$type = $ts [1];
					}
					else 
					{
						echo "item type not found:" . $item . "\n";
					}
				
					$item = str_replace ( "\"", "\\\"", $item );
					$item = str_replace ( "\'", "\\\'", $item );
				
					$sql = "INSERT INTO `rule_item`(`id`,`name`,`data`) VALUES('" . $type . "." . $name . "','" . $display_name . "','" . $item . "')" . "ON DUPLICATE KEY UPDATE `name`='" . $display_name . "',`data`='" . $item . "'";
				
					MySQL::getInstance ()->RunQuery ( $sql );
				} 
				else 
				{
					echo "item name not found:" . $item . "\n";
				}
			}
			else
			{
				echo "invalid item:" . $item . "\n";
			}
			
		}
	} else {
		echo "un match";
	}
}

main();

?>