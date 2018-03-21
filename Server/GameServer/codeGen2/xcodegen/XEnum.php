<?php
/**
 * @author LiangZhixian
 * 2010-09-24
 */
class Emember
{
	var $name;
	
	var $value;	
};

class XEnum 
{
	var $name;	
	
	var $members;	

	var $member_codes;
	
	public function genDetails()
	{
		$this->member_codes = $this->genMemberCode();
	}

	private function genMemberCode()
	{
		$s = '';
		
		foreach($this->members as $member)
		{
			$s .= "		const {$member->name} ={$member->value};\r\n";			
		}
		
		return $s;
	}
}

?>