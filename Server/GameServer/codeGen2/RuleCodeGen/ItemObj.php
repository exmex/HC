<?php

/**
 * ItemObj 物品描述 
 * @author LiangZhixian
 *
 */

class ItemObj {		
		
	var $id;
	var $type;
	var $rule;
	var $name;
	var $price;
	var $description;
	var $size;
	var $farmlevel;
	var $experience;
	var $consume;
	var $death = 0;
	var $icon;
	var $sell = 0;
	var $buy = 0;
	
	//收获设置
	var $hvtime;
	var $hvexpire;
	var $hvgold;
	var $hvitem;
	var $hvitemRate;
	var $hvitemCount;	
	
	var $star;	
	
	var $is_valid_item = false;
	
	function ItemObj($itemEle)
	{		
		if (!$itemEle)
		{
			return;
		}
		
		foreach ($itemEle->attributes as $attr)
		{					
			$an = strval($attr->nodeName);
			$this->$an = $attr->nodeValue;			
		}
		
		$harvest = $itemEle->getElementsByTagName("harvest");
		if ($harvest)
		{			
			foreach ($harvest->item(0)->attributes as $attr)
			{
				$an = strval($attr->nodeName);
				$this->$an = $attr->nodeValue;	
			}
		}
		
		/**
		 * :(  
		 * 有没有更好的办法呢？
		 */
		$starArray = $itemEle->getElementsByTagName("star");
		if ($starArray)
		{		
			$levelArr = $starArray->item(0)->getElementsByTagName("levelup");
			if ($levelArr)
			{				
				$this->star.="<star>\n";
				foreach($levelArr as $lu)
				{
					$this->star .= "<levelup ";
					foreach ($lu->attributes as $i){
						$this->star .= ($i->nodeName."=\\\"".$i->nodeValue."\\\" ");
					}
					$this->star .= "/>\n";					
				}

				$this->star.="</star>";
			}
		}

		$this->is_valid_item = isset($this->id);
		
	}
	
	function genItemUpdateSQL()
	{
		if (!$this->is_valid_item)
		{
			return;
		}
		
		$sql = "INSERT INTO `rule_item`(`id`,`type`,`rule`,`name`,`price`,`sell`,`buy`,`description`,`icon`) VALUES(".
		       "'".$this->id."',".
		       "'".$this->type."',".
		       "'".$this->rule."',".
		       "'".$this->name."',".
		       "'".$this->price."',".
		       "'".$this->sell."',".
		       "'".$this->buy."',".
		       "'".$this->description."',".
		       "'".$this->icon."'".
		       ") ON DUPLICATE KEY UPDATE ".
		       "`type`='".$this->type."',".
		       "`rule`='".$this->rule."',".
		       "`name`='".$this->name."',".
		       "`price`='".$this->price."',".
		       "`description`='".$this->description."',".
		       "`icon`='".$this->icon."'";		
		
		return $sql;
	}
	
	function genShopRuleSQL()
	{
	    if (!$this->is_valid_item)
		{
			return;
		}
		
		$sql = "INSERT INTO `shop`(`item_id`) VALUES('".$this->id."')".
		" ON DUPLICATE KEY UPDATE `item_id`='".$this->id."'";
		
		return $sql;		
	}

	public function toXML($dom,$root)
	{
		$itemEum = 	$dom->createElement("itemEum");
				
		$itemEum->setAttribute("id",$this->id);
		$itemEum->setAttribute("name",$this->name);
		$itemEum->setAttribute("type",$this->type);
		$itemEum->setAttribute("price",$this->price);
		$itemEum->setAttribute("sell",$this->sell);
		$itemEum->setAttribute("buy",$this->buy);
		$itemEum->setAttribute("desc",$this->description);		
		$itemEum->setAttribute("icon",$this->icon);		
		
		$root->appendChild($itemEum);				
	}

}

?>