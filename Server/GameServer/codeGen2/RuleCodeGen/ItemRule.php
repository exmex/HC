<?php

/**
 * @author LiangZhixian
 */
require_once 'CMySQL.php';
require_once 'config.php';
require_once 'ItemObj.php';

class ItemRule {
	
	var $xmlDoc;
	var $destXmlFile;
	
	function ItemRule()
	{
		$this->xmlDoc = new DOMDocument(); 
	}

	public function loadItemRuleSrc($srcFile,$destFile)
	{
		if (!MySQL::getInstance()->link){
			print("connect to db error!\n");
			return false;
		}
		
		$this->xmlDoc->load($srcFile);		
		$this->destXmlFile = $destFile;		
	}
			
	public function parse()
	{
		$itemArray = $this->xmlDoc->getElementsByTagName("item");
		
		$destXmlDoc = new DOMDocument("1.0","UTF-8");
		
		$docRoot = $destXmlDoc->createElement("itemDefineI18n");
		$destXmlDoc->appendChild($docRoot);
				
				
		foreach ($itemArray as $item)
		{
			$itemobj = new ItemObj($item);
			
		    //update shop
			$sql = $itemobj->genShopRuleSQL();
			if ($sql)
			{
				MySQL::getInstance()->RunQuery($sql);
			}
			
			//update rule_item
			$sql = $itemobj->genItemUpdateSQL();
			if ($sql)
			{
				MySQL::getInstance()->RunQuery($sql);
			}
			
			$itemobj->toXML($destXmlDoc,$docRoot);
		}
		
		$destXmlDoc->save($this->destXmlFile);
	}

	public function resetRule()
	{
		//reset rule_item
		MySQL::getInstance()->RunQuery("DELETE FROM rule_item");
	}

}

?>