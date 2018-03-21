<?php
/**
 * @author LiangZhixian
 * 2010-09-24
 */
require_once ("XEnum.php");

class XEnumParser {
	
	var $enumTpl;
	
	var $enum_path;
	
	var $name_space;
	
	var $result;
	
	function XEnumParser($t,$n,$ep)
	{
		$this->enumTpl =  file_get_contents($t."constant.ptpl");		
		$this->enum_path = $ep;		
		$this->name_space = $n;
	}
	
	public function begin()
	{
		$this->result = '';
	}
	
	public function end()
	{
		return $this->result;
	}
	
	public function addData($fileData)
	{
		if (empty($fileData))
		{
			return;
		}

		$reg = "|\s*enum\s+(.*){(.*)}(\s*);|U";
		
		if (preg_match_all($reg,$fileData,$m))
		{
			$i = 0;
			foreach ($m[1] as $name)
			{								
				$this->parseEnum(trim($name),$m[2][$i]);								
				$i++;
			}
		}
	}
	
	private function parseEnum($name,$fields)
	{
		$name = trim($name);
		if (empty($name) || strlen($name) < 0)
		{
			return;			
		}
		
		if (preg_match("/\w+/",$name,$m))
		{
			$enum_name = $m[0];			
		}		
				
		$reg = "|(\w+.*),|U";
		
		$members = array();

		$maxIndex = 0;
		
		if (preg_match_all($reg,$fields,$m))
		{
						
			foreach ($m[1] as $field)
			{
				$mem = new Emember();		
						
				$arr = explode("=",$field);
				$n =  trim($arr[0]);	
				$a = explode(" ",$n);
				
				$mem->name = trim($a[count($a)-1]);	
							
				if (count($arr) == 1)
				{					
					
					$mem->value = strval($maxIndex);
					$maxIndex++;				
				}
				else if (count($arr) == 2)
				{
					$v = trim($arr[1]);					
					$mem->value = $v;
					if (intval($v) > $maxIndex)
					{
						$maxIndex = intval($v);
					}
					$maxIndex++;
				}
				$members[] = $mem;
			}
		}
		
		
		
		$enum = new XEnum();
		$enum->name = $enum_name;
		$enum->members = $members;
		$enum->genDetails();
		
		$tpl = $this->enumTpl;		
		$tpl = str_replace("/*::ENUM_NAME::*/",$enum->name,$tpl);
		$tpl = str_replace("/*::ENUM_MEMBERS::*/",$enum->member_codes,$tpl);	
		$tpl = str_replace(",)",")",$tpl);

				
		$this->result .= $tpl;		
	}

}

?>