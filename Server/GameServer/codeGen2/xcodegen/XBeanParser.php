<?php
/**
 * @author LiangZhixian
 * 2010-09-24
 */
require_once ("XBean.php");
require_once ("XMethod.php");
require_once ("XTypeMap.php");

class XBeanParser {
	
	var $beanTpl;
	
	var $registerTpl;
	
	var $beanDebugTpl;
	
	var $name_space;
	
	var $bean_path;
	
	var $bean_list = array();
	
	var $result;	
	
	function XBeanParser($t,$n,$bp)
	{		
		$this->beanTpl = file_get_contents($t."bean.ctpl");
		$this->registerTpl = file_get_contents($t."init.ctpl");
		$this->beanDebugTpl = file_get_contents($t."bean_debug.ptpl");
		$this->name_space = $n;
		$this->bean_path = $bp;		
	}
	
	public function begin()
	{
		$this->result = array();		
		$this->result['BEAN']='';
		$this->result['INIT']='';
		$this->result['BSFUNC']='';
		$this->result['BEANDEBUG']='';
	}
	
	public function end()
	{
		foreach($this->bean_list as $name =>$bean)
		{
			if($bean->parent){
				$this->addParentFields($bean,$bean->parent);
			}
			
			$bean->genDetails();
	    
	    	$tpl = $this->beanTpl;	    
			$tpl = str_replace("/*::BEAN_NAME::*/",$bean->class_name,$tpl);
			$tpl = str_replace("/*::CONSTRUCT_CODE::*/",$bean->construct_code,$tpl);
			$tpl = str_replace("/*::STRUCT_FIELD_CODE::*/",$bean->bean_fields_define_code,$tpl);	
			$tpl = str_replace("/*::SET_CODE::*/",$bean->bean_set_code,$tpl);		
			$tpl = str_replace("/*::GET_CODE::*/",$bean->bean_get_code,$tpl);		
			$tpl = str_replace("/*::SIZE_CODE::*/",$bean->bean_size_code,$tpl);		
			$tpl = str_replace("/*::FROM_BUFFER_CODE::*/",$bean->bean_from_buffer_code,$tpl);		
			$tpl = str_replace("/*::TO_BUFFER_CODE::*/",$bean->bean_to_buffer_code,$tpl);	
			$tpl = str_replace("/*::BEAN_FREE_CODE::*/",$bean->bean_free_code,$tpl);		
			$tpl = str_replace(",)",")",$tpl);
						
			$this->result['BEAN'] .= $tpl;			
			
			$tpl = $this->registerTpl;
			$tpl = str_replace("/*::BEAN_NAME::*/",$bean->class_name,$tpl);
			
			$this->result['INIT'] .= $tpl;		
			$this->result['BSFUNC'] .= 	$bean->genBeanSfunctions();
			
			$this->result['BEANDEBUG'] .= $bean->genDebugStringCode($this->beanDebugTpl);
		}	
		
		return $this->result;
	}
	
	public function addData($fileData)
	{
		if (empty($fileData))
		{
			return;
		}				
		
		$reg = "|\s*struct\s+(.*){(.*)}(\s*);|U";
		
		if (preg_match_all($reg,$fileData,$m))
		{
			$i = 0;
			foreach ($m[1] as $name)
			{								
				$b=$this->parseBean(trim($name),$m[2][$i]);			
				if ($b){
					$this->bean_list[$b->class_name] = $b;
				}					
				$i++;
			}
		}		
					
	}
	
	private function addParentFields($bean,$parent)
	{
		if (!isset($this->bean_list[$parent])){
			return;
		}		
		$pb = $this->bean_list[$parent];
		$parameters = array_merge($pb->raw_fields,$bean->fields);

		$bean->fields = $parameters;
	
		if ($pb->parent){
			$this->addParentFields($bean,$pb->parent);
		}
	}
	
	private function parseBean($name,$fields)
	{				
		
		$name = trim($name);
		if (empty($name) || strlen($name) < 0)
		{
			return;			
		}
				
		$reg_parent_class = "/public\s+(\w+)/";
				
		if (preg_match($reg_parent_class,$name,$m))
		{
			$parent_class_name = $m[1];			
		}
		
		$reg_class_name = "/\w+/";
		if (preg_match($reg_class_name,$name,$m))
		{
			$class_name = $m[0];			
		}
		
	    if (empty($class_name) || strlen($class_name) < 0)
		{
			return;			
		}
		
		$reg_fields = "|(\w+)\s+(\w+\s*\[?\s*\]?)\s*;|U";
		
		$reg_field_array = "/(\w+)\s*\[/";
		
		$parameters = array();
		
		if (preg_match_all($reg_fields,$fields,$match))
		{
			$i = 0;
			
			foreach($match[2] as $fieldName)
			{
				$param = new Parameter();
				
				if (preg_match($reg_field_array,$fieldName,$fm))
				{
					$param->name = $fm[1];
					$param->isArray = true;
				}
				else
				{
					$param->name = $fieldName;
					$param->isArray = false;
				}
				
				
				if (!empty(TypeMap::$TYPE_MAP[$match[1][$i]]))
				{
					$param->type = TypeMap::$TYPE_MAP[$match[1][$i]];
					$param->isObject = false;
				}
				else
				{
					$param->type = $match[1][$i];
					$param->isObject = true;
				}
				
				$parameters[] = $param;
				
				$i++;
			}
		}
		
		$bean = new XBean();
		
		$bean->class_name = $class_name;
	    if(!empty($parent_class_name))
	    {
	    	$bean->parent = $parent_class_name;
	    	$bean->has_parent = true;
	    }
	    
	    $bean->raw_fields = $parameters;
	    $bean->fields = $parameters;
	    	    
	    return $bean;
	}

}

?>