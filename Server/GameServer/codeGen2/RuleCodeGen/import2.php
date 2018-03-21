<?php
date_default_timezone_set("EST");

require_once 'config.php';
require_once 'CMySQL.php';

function main() {
    $FILE_SRC = "../../../client/dsFantasy/src/xml/item_src.xml";
    $FILE_EQP = "../../../client/dsFantasy/src/xml/equipments.xml";
    $FILE_FRG = "../../../client/dsFantasy/src/xml/frg_equipments.xml";
    $FILE_ELI = "../../../client/dsFantasy/src/xml/elixir.xml";
    $FILE_CAM = "../../../client/dsFantasy/src/xml/campaign.xml";
	$FILE_MOUNT = "../../../client/dsFantasy/src/xml/mount.xml";

    $files = array($FILE_SRC, $FILE_EQP, $FILE_FRG, $FILE_ELI, $FILE_CAM,$FILE_MOUNT);

    if (!checkValidXml($files)) {
        echo "ERROR in xml, import failed!\n";
        return;
    } 
    // importItemRuleToDB ( $files );
    genNewItemXml($files);
	
	getHeroData();
}

function getHeroData() {
    return;
    $HEROS_FILE_SRC = "../../../client/dsFantasy/src/xml/heros.xml";
    $TAVERN_FILE_SRC = "../../../client/dsFantasy/src/xml/tavernheros.xml";

	$herosDoc = simplexml_load_file($HEROS_FILE_SRC);
	$tavernDoc = simplexml_load_file($TAVERN_FILE_SRC);
	if (!empty($herosDoc) && !empty($tavernDoc)) {
		foreach($herosDoc->Hero as $hero) {
			$heroId = strval($hero['id']);

			foreach($tavernDoc->Hero as $tavernHero) {
				$tavernId = strval($tavernHero['id']);
				if ($heroId == $tavernId) {
					$hero["grade"] = intval($tavernHero["tavernType"]);
					break;
				}
			}
		}
	}
	
	$herosDoc->asXML($HEROS_FILE_SRC);
	$herosDoc->asXML("../../server2/rule/data/heros.xml");
}

function genNewItemXml($files) {
    $langFile = "../../../client/dsFantasy/src/xml/en.xml";

    $clientItem = "../../../client/dsFantasy/src/xml/item2.xml";
    $serverItem = "../../../client/dsFantasy/src/xml/ItemRule.xml";

    $landXml = simplexml_load_file($langFile);
    $lands = array();

    if (isset($landXml -> items)) {
        unset($landXml -> items);
    }

    if (!isset($landXml -> auto)) {
        echo "failed to generate lang file!{$langFile} must exit <auto> node!";
        return;
    }

    if (isset($landXml -> auto -> items)) {
        unset($landXml -> auto -> items);
    }

    $landItems = $landXml -> auto -> addChild("items");

    $xmlcontent = "";
    foreach($files as $file) {
        if (empty($xmlcontent)) {
            $xmlcontent = file_get_contents($file);
        }else {
            $xmlcontent = str_replace("</items>", "", $xmlcontent);
            $curcontent = file_get_contents($file);
            $curcontent = preg_replace("/(<\?xml.*<items>)/sU", "", $curcontent);
            $xmlcontent .= $curcontent;
        }
    }

    $xml = simplexml_load_string($xmlcontent);
    $xml -> asXML($serverItem);

    foreach($xml -> item as $item) {
        if (isset($item['name'])) {
            $iname = trim($item['name']);
        }else {
            $iname = "[PLEASE ADD]";
        }
        $landKey = "{$item['id']}_friendlyname";
        $lk = $landItems -> addChild("string");
        $lk['key'] = $landKey;
        $lk -> addChild("english", $iname);
        unset($item['name']); 
        // if(isset($item['use'])){
        // unset($item['use']);
        // }
    }
    $landXml -> asXML($langFile);

    $xml -> asXML($clientItem);
}

function checkValidXml($files) {
    $ids = array();

    $pass = true;

    foreach($files as $file) {
        $xml = simplexml_load_file($file);
        foreach($xml -> item as $item) {
            $id = strval($item['id']);
            $name = strval($item['name']);
            if (isset($ids[$id])) {
                echo "id confict:{$id} {$name}\n";
                $pass = false;
            }else {
                $ids[$id] = $name;
            }
        }
    }

    $xml = simplexml_load_file($files[0]);

    foreach($xml -> item as $item) {
        if (isset($item -> construction)) {
            $c = strval($item -> construction);
            if (!isset($ids[$c])) {
                echo "Construction Item Not Found:{$item['id']}=>{$c}\n";
                $pass = false;
            }
        }
    }

    return $pass;
}

function importItemRuleToDB($files) {
    MySQL :: getInstance () -> RunQuery ("DELETE FROM `rule_item`");

    foreach($files as $file) {
        $xml = simplexml_load_file($file);

        $items = $xml -> children();
        foreach($items -> item as $item) {
            $id = $item['id'];
            $data = $item -> asXml();
            $id = addslashes($id);
            $data = addslashes($data);
            $sql = "INSERT INTO `rule_item`(`id`,`data`) VALUES('{$id}','{$data}')" . "ON DUPLICATE KEY UPDATE `data`='{$data}'";

            MySQL :: getInstance () -> RunQuery ($sql);
        }
    }

    /**
     * $xmls = file_get_contents ( $file );
     * 
     * $k = str_replace ( "\r\n", " ", $xmls );
     * 
     * if (preg_match_all ( "|<item (.*)\/>|U", $k, $items )) 
     * {
     * foreach ( $items [0] as $item ) 
     * {						
     * $head = $item;
     * if (preg_match ( "/name=\"([^\"]*)/", $head, $ns )) 
     * {
     * $name = addslashes($ns [1]);
     * 
     * if (preg_match ( "/id=\"([^\"]*)/", $head, $ds )) 
     * {
     * $id = $ds [1];
     * } 					
     * 
     * $item = addslashes($item);
     * 
     * $sql = "INSERT INTO `rule_item`(`id`,`name`,`data`) VALUES('{$id}','{$name}','{$item}')" . "ON DUPLICATE KEY UPDATE `name`='{$name}',`data`='{$item}'";
     * 
     * MySQL::getInstance ()->RunQuery ( $sql );
     * } 
     * else 
     * {
     * echo "item name not found:" . $item . "\n";
     * }
     * 
     * }
     * } else {
     * echo "un match";
     * }
     */
}

main();

?>
