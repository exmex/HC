<?php
/**
 * @author LiangZhixian
 * 2010-09-24
 */
require_once 'XMethod.php';
require_once 'XTypeMap.php';

class SetMemberBean
{	
	var $hash;
	var $name;
	var $type;
	var $convert;
}

class XBean {
	
	var $class_name;	
	var $raw_fields;
	var $fields;	
	var $construct_code;
	var $bean_fields_define_code;
	var $bean_set_code;
	var $bean_get_code;
	var $bean_size_code;	
	var $bean_from_buffer_code;
	var $bean_to_buffer_code;

	var $parent_class_code;
	
	var $bean_free_code;
	
	var $parent;
	var $has_parent = false;
	
	var $cmd = "-1";
	var $is_cmd = true;
	var $command_code;
	
	var $new_instance_code;
	
	var $debug_string_code;	
			
	public function genDetails()
	{
		$this->construct_code = $this->genConstructCode();
		$this->bean_fields_define_code = $this->genFieldsDefineCode();
		$this->bean_set_code = $this->genSetCode();
		$this->bean_get_code = $this->genGetCode();
		$this->bean_size_code = $this->genSizeCode();		
		$this->bean_from_buffer_code = $this->genFromBufferCode();
		$this->bean_to_buffer_code = $this->genToBufferCode();
		$this->bean_free_code = $this->genBeanFreeCode();		
		/*$this->parent_class_code = $this->genParentClassCode();
		$this->command_code = $this->genCommandCode();
		$this->new_instance_code = $this->genNewInstanceCode();		
		$this->debug_string_code = $this->genDebugStringCode();	
		
		if (empty($this->bean_fields_code))
		{
			$this->bean_fields_code = $this->genFieldsCode();
		}	*/
		
	}
	
	function str_hash($value)
	{
		$len = strlen($value);
		$v = 0;
		for($i = 0; $i < $len;$i++){
			$v = 3*$v + ord($value[$i]) - $len;
		}
	
		return $v;
	}
	
	private function genFieldsDefineCode()
	{
		$s = '';			
								
		foreach($this->fields as $p)
		{		
		   if (!empty(TypeMap::$TYPE_MAP[$p->type]))
			{
				$t = TypeMap::$TYPE_MAP[$p->type];
			}
			else
			{
				$t = $p->type;
			}
			
			if($p->isArray)
			{				
				$s .= "	zval * {$p->name}; //array\r\n";								
			}
			else
			{
				if ($p->isObject){
					$s .= "	zval * {$p->name}; //{$p->type}_Object\r\n";
				}else{
					$s .= "	zval * {$p->name};\r\n";
				}
			}			
						
		}					
				
		return $s;
	}
	
	private function genFieldsCode()
	{
		$s = '';	
		
		$i = 1;
		$max = sizeof($this->fields);
		
		foreach($this->fields as $p)
		{		
			
			$s .= $p->type;			
			
			if ($p->isArray)
			{
				$s .= "[]";
			}			
			
			$s .=" ".$p->name;
			
			if($i < $max)
			{
				$s .= ",";
			}
			
			$i ++;
		}					
				
		return $s;
	}
	
	private function genParentClassCode()
	{
		$s = '';	

		if ($this->has_parent)
		{
			$s .= "extends ".$this->parent;
		}
		
		return $s;		
	}
	
	private function genCommandCode()
	{
		$s = '';	
		
		if ($this->is_cmd)
		{
			$s .= sprintf("	public static int COMMAND = %s;",$this->cmd);
		}
		
		return $s;
	}
	
	private function genSizeCode()
	{
		$s = '';
						
		foreach ($this->fields as $param)
		{		    
		    if($param->isArray)
		    {
		    	$s .= "	len += 4; //{$param->name} array header\r\n";

		    	if ($param->isObject){
		    		$s .= "	len += ARRAY_LEN(obj->{$param->name} TSRMLS_CC,0,2,{$param->type}_Size_s); //{$param->name} array size\r\n";
		    	}
		    	else if(TypeMap::_XIS_STRING($param->type)){
		    		$s .= "	len += ARRAY_LEN(obj->{$param->name} TSRMLS_CC,0,1,NULL); //{$param->name} array size\r\n";
		    	}
		    	else{
		    		$size = TypeMap::$SIZE_MAP[$param->type];
		    		$s .= "	len += ARRAY_LEN(obj->{$param->name} TSRMLS_CC,{$size},0,NULL); //{$param->name} array size\r\n";
		    	}
		    	
		    }	
		    else if ($param->isObject)
		    {		    		
		    	$s .= "	len += {$param->type}_Size_s(obj->{$param->name} TSRMLS_CC); //{$param->name}\r\n";		 
		    }		
		    else if(TypeMap::_XIS_STRING($param->type))
		    {
		    	$s .= "	STRING_SIZE(obj->{$param->name}); //{$param->name}\r\n";		    	
		    }
		    else
		    {
		    	$s .= sprintf("	len += %s; //%s\r\n",
		    	      TypeMap::$SIZE_MAP[$param->type],
		    	      $param->name);
		    }
		}
		
		return $s;
	}
	
	private function genNewInstanceCode()
	{
		$s = '';	
			
		foreach($this->fields as $p)
		{					
			$s .= sprintf("    	instance.%s = %s;\r\n",$p->name,$p->name);		
		}					
				
		return $s;
	}

	private function genToBufferCode()
	{
		$s = '';		
						
		foreach ($this->fields as $param)
		{
			if ($param->isArray){
				if ($param->isObject){					
					$s .= "		PROP_TO_BUFF_SAFE(dst_obj->{$param->name},earray,eobject,0, {$param->type}_ToBuffer_s)\r\n";		  		  
				}else{
					$t = TypeMap::$E_TYPE_MAP[$param->type];
					$s .= "		PROP_TO_BUFF_SAFE(dst_obj->{$param->name},earray,{$t},0, NULL)\r\n";	
				}
			}else if ($param->isObject){
				$s .= "		PROP_TO_BUFF_SAFE(dst_obj->{$param->name},eobject,eobject,0, {$param->type}_ToBuffer_s)\r\n";		  
			}else{				
				$t = TypeMap::$E_TYPE_MAP[$param->type];
				$s .= "		PROP_TO_BUFF_SAFE(dst_obj->{$param->name},{$t},{$t},0, NULL)\r\n";		    			
			}
			
		}
		return $s;
	}
	
	private function genFromBufferCode()
	{
		$s = '';		
				
		foreach ($this->fields as $param)
		{
			if ($param->isArray){
				if ($param->isObject){					
					$s .= "		PROP_FROM_BUFF_SAFE(src_obj->{$param->name},earray,eobject,0, {$param->type}_FromBuffer_s)\r\n";		 		  
				}else{
					$t = TypeMap::$E_TYPE_MAP[$param->type];
					$s .= "		PROP_FROM_BUFF_SAFE(src_obj->{$param->name},earray,{$t},0, NULL)\r\n";	
				}
			}else if ($param->isObject){
				$s .= "		PROP_FROM_BUFF_SAFE(src_obj->{$param->name},eobject,eobject,0, {$param->type}_FromBuffer_s)\r\n";		  
			}else{				
				$t = TypeMap::$E_TYPE_MAP[$param->type];
				$s .= "		PROP_FROM_BUFF_SAFE(src_obj->{$param->name},{$t},{$t},0, NULL)\r\n";		    			
			}
		}
		
		return $s;
	}
	
	public function genDebugStringCode($debugTpl)
	{
		$s = '';	
				
		foreach ($this->fields as $param)
		{
			if($param->isArray)
		    {		    	
		    	$s .= sprintf("	\$__xsd .= \"%s=(\";\r\n",$param->name);
		    	if ($param->isObject)
		    	{		    		
		    		$s .= "	foreach(\$bean->{$param->name} as \$_elm) \$__xsd .= {$param->type}_ToDebugString(\$_elm).\",\";\r\n";
		    	}
		    	else
		    	{
		    		$s .= "	foreach(\$bean->{$param->name} as \$_elm) \$__xsd .= strval(\$elm).\",\";\r\n";		    		
		    	}		
		    	$s .= "	\$__xsd .=\"),\";\r\n";    	
		    }
		    else if($param->isObject)
		    {
		    	$s .= "	\$__xsd .= \"{$param->name}=\".{$param->type}_ToDebugString(\$bean->{$param->name}).\",\";\r\n";	 
		    }
		    else
		    {
		    	$s .= "	\$__xsd .= \"{$param->name}={\$bean->{$param->name}},\";\r\n";		    	
		    }			
			
		}		
		
		$tpl = $debugTpl;
		$tpl = str_replace("/*::BEAN_NAME::*/",$this->class_name,$tpl);
		$tpl = str_replace("/*::DEBUG_CODE::*/",$s,$tpl);
		
				
		return $tpl;		
	}
	
	private function genConstructCode()
	{
		$s = '';
		
		foreach ($this->fields as $param)
		{
			if ($param->isArray ){
				$s .= "		NEW_ZVAL_ARRAY(obj->{$param->name});\r\n";
			}else if ($param->isObject){
				$s .= "		NEW_ZVAL_OBJECT(obj->{$param->name},\"{$param->type}\",{$param->type}_construct_s);\r\n";
			}else if (TypeMap::_XIS_STRING($param->type)){
				$s .= "		NEW_ZVAL_EMPTY_STRING(obj->{$param->name});\r\n";
			}else {
				$f = TypeMap::$TYPE_CONSTRUCT_MAP[$param->type];		
				$s .= "		{$f}(obj->{$param->name},0);\r\n";
			}			
		}
				
		return $s;
	}
	
	private function genSetCode()
	{
		$s = '';
		
		$hash_arr = array();
				
		foreach ($this->fields as $param)
		{	
			$hash = $this->str_hash($param->name);
			if (isset($hash_arr[$hash])){
				echo "conflict hash value {$hash_arr[$hash]} and {$param->name}\n";
			}
			$smb = new SetMemberBean();
			$smb->hash = $hash;
			$smb->name = $param->name;
			
						
			if ($param->isArray){
				$smb->type = "IS_ARRAY";
				$smb->convert = "convert_to_array";
			}else if ($param->isObject){
				$smb->type = "IS_OBJECT";
				$smb->convert = "convert_to_object";
			}else{
				$smb->type = TypeMap::$IS_TYPE_MAP[$param->type];
				$smb->convert = TypeMap::$CV_TYPE_MAP[$param->type];
			}						
								
			$hash_arr[$hash] = $smb;			
		}
		
		ksort($hash_arr);
		
		foreach ($hash_arr as $h=>$member)
		{			
			$s .= "			case {$h}:{SET_MEMBER(obj->{$member->name},{$member->type},{$member->convert})} break;\r\n";				
		}
				
		return $s;
	}
	
	private function genGetCode()
	{
		$s = '';
		
		$hash_arr = array();
				
		foreach ($this->fields as $param)
		{	
			$hash = $this->str_hash($param->name);
			if (isset($hash_arr[$hash])){
				echo "conflict hash value {$hash_arr[$hash]} and {$param->name}\n";
			}
			$hash_arr[$hash] = $param->name;			
		}
		
		ksort($hash_arr);
		
		foreach ($hash_arr as $h=>$name)
		{			
			$s .= "			case {$h}:{ RETURN_ZVAL(obj->{$name},1,0);}\r\n";				
		}
				
		return $s;		
	}
	
	private function genBeanFreeCode()
	{
		$s = '';
		
		foreach ($this->fields as $param)
		{
			$s .= "    FREE_MEMBER(obj->{$param->name})\r\n";
		}
		
		return $s;
	}
	
	public function genBeanSfunctions()
	{
		$s = '';
		
		$s .= "int {$this->class_name}_Size_s(zval * zobj TSRMLS_DC);\r\n";
		$s .= "int {$this->class_name}_FromBuffer_s(zval *zsrc_obj TSRMLS_DC, const char *__src,  int  __maxlen, int *__ret_size);\r\n";
		$s .= "int {$this->class_name}_ToBuffer_s(zval *zdst_obj TSRMLS_DC, char *__dst,  int  __maxlen, int *__ret_size);\r\n";
		
		return $s;
	}

}

?>