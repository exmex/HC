<?php
/**
 * @author LiangZhixian
 * 2010-09-24
 */
require_once 'XTypeMap.php';
require_once 'XBean.php';

class Parameter
{
	var $type;

	var $name;
	
	var $isArray;	
	
	var $isObject;
	
};

class Method 
{
	var $Parameters;
	var $name;
	var $cmd;
	
	var $method_name;
	var $packet_class;
	var $method_params;
	var $packet_members;
	var $method_params_no_type;
	var $bean;
				
	public function genDetails()
	{
		$this->packet_class = $this->genMethodPacketName();
		$this->method_params = $this->genMethodParameters();	
		$this->packet_members = $this->genMethodPacketMembers();
		$this->method_params_no_type = $this->genMethodParametersNoType();				
	}
	
	public function getMethodName()
	{
		return $this->name;
	}
	
	public function genMethodPacketName()
	{
		return "XPACKET_".$this->name;
	}
	
	private function genMethodParameters()
	{
		$s = '';	
		
		$i = 1;
		$max = sizeof($this->Parameters);
		
		foreach($this->Parameters as $p)
		{		
			if (!empty(TypeMap::$TYPE_MAP[$p->type]))
			{
				$s .= TypeMap::$TYPE_MAP[$p->type];
			}
			else
			{
				$s .= $p->type;
			}
			
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
	
	private function genMethodPacketMembers()
	{
		$s = '';	
		
		$i = 1;
		$max = sizeof($this->Parameters);
		
		foreach($this->Parameters as $p)
		{		
			$s .= "xbean.".$p->name;
			
			if($i < $max)
			{
				$s .= ",";
			}
			
			$i ++;
		}					
				
		return $s;		
	}
	
    private function genMethodParametersNoType()
	{
		$s = '';	
		
		$i = 1;
		$max = sizeof($this->Parameters);
		
		foreach($this->Parameters as $p)
		{		
			$s .= $p->name;
			
			if($i < $max)
			{
					$s .= ",";
			}			
			
			$i ++;
		}					
				
		return $s;		
	}
	
	public function genHandlerMethodFunctionCode($name)
	{
		$s = sprintf("		public int %s(%s)\r\n		{\r\n			return 0;\r\n		}\r\n\r\n",
		       $name,$this->method_params);
		
		return $s;
	}
	
	public function toBean()
	{
		if ($this->bean){
			return $this->bean;
		}
		
		$this->bean = new XBean();
		
		$this->bean->class_name = $this->genMethodPacketName();
		$this->bean->fields = $this->Parameters;
		$this->bean->bean_fields_code = $this->method_params;
		$this->bean->cmd = $this->cmd;
		$this->bean->is_cmd = true;
		$this->bean->genDetails();	

		return $this->bean;
	}
	
	private function genReadParamCode()
	{
		$z = '"';
		$p = '';
		foreach($this->bean->fields as $param)
		{
			$z .= "z";		
			$p .= "&obj->{$param->name},";	
		}		
		$z .= '",';	

		return $z.$p;
	}
	
	private function genParamDefineCode()
	{
		$result = array();
		$result[0] = count($this->bean->fields);
		$result[1] = "";
		
		$i = 0;
		
		foreach($this->bean->fields as $param)
		{			
			$result[1] .= "	params[{$i}] = &obj->{$param->name};\r\n";	
			$i ++;
		}	
				
		return $result;
	}
	
	public function genSendMethodCode($sendMethodTpl)
	{
		$tpl = $sendMethodTpl;
		
		$bean = $this->toBean();
		
		$tpl = str_replace("/*::METHOD_NAME::*/",$this->method_name,$tpl);
		$tpl = str_replace("/*::BEAN_NAME::*/",$bean->class_name,$tpl);
		$tpl = str_replace("/*::READ_PARAM_CODE::*/",$this->genReadParamCode(),$tpl);
		$tpl = str_replace("/*::XCMD_CODE::*/",$bean->cmd,$tpl);
		$tpl = str_replace("/*::BEAN_FREE_CODE::*/",$bean->bean_free_code,$tpl);
		
		return $tpl;
	}
	
	public function genHandleMethodCode($handleMethodTpl)
	{
		$tpl = $handleMethodTpl;
		
		$bean = $this->toBean();
		
		$tpl = str_replace("/*::METHOD_NAME::*/",$this->method_name,$tpl);
		$tpl = str_replace("/*::BEAN_NAME::*/",$bean->class_name,$tpl);
		$r = $this->genParamDefineCode();
		$tpl = str_replace("/*::PARAMS_DEFINE_CODE::*/",$r[1],$tpl);
		$tpl = str_replace("/*::PARAMS_NUM_CODE::*/",$r[0],$tpl);
		$tpl = str_replace("/*::BEAN_FREE_CODE::*/",$bean->bean_free_code,$tpl);
		
		return $tpl;
	}
	
	public function genDispatchDefineCode()
	{				
		return "		case {$this->cmd}: return __{$this->method_name}(__src TSRMLS_CC, (int)phdr->len);\r\n";		
	}
	
	public function genEventDefineCode()
	{
		return "PHP_FUNCTION(__{$this->method_name});\r\n";
	}

	public function genXcmdDefineCode()
	{
		return "	PHP_FE(__{$this->method_name},NULL)\r\n";
	}
	
	private function genServerParamDefineCode()
	{
		$s = '';
		$max = count($this->bean->fields);
		
		if ($max == 0){
			return $s;
		}
		
		foreach($this->bean->fields as $param)
		{			
			$type = $param->type;
			if (isset(TypeMap::$TYPE_MAP[$type])){				
				$type = TypeMap::$TYPE_MAP[$type];			
			}
			
			if ($param->isArray){
				$type .= "[]";
			}
			$s .= "\${$param->name}/*{$type}*/,";
		}	

		$len = strlen($s);
		$s = substr($s,0,$len-1);
		
		return $s;		
	}
		
	public function genServerSendMethodCode($stpl)
	{
		
		$bean = $this->toBean();

		$param = $this->genServerParamDefineCode();
		
		$tpl = $stpl;
		$tpl = str_replace("/*::METHOD_NAME::*/",$this->method_name,$tpl);		
		$tpl = str_replace("/*::PARAM_DEFINE::*/",$param,$tpl);		
		
		return $tpl;
	}
	
	public function genServerHandleMethodCode($stpl)
	{
		
		$bean = $this->toBean();

		$param = $this->genServerParamDefineCode();
		
		$tpl = $stpl;
		$tpl = str_replace("/*::METHOD_NAME::*/",$this->method_name,$tpl);		
		$tpl = str_replace("/*::PARAM_DEFINE::*/",$param,$tpl);		
		
		return $tpl;
	}
	
	public function genInterfaceCmdCode()
	{
		return "		const CMSG_{$this->name} ={$this->cmd};\r\n";		
	}
	
	public function genEventCmdCode()
	{
		return "		const SMSG_{$this->name} ={$this->cmd};\r\n";		
	}
	
	private function debugCode()
	{
		$s = '';
		
		foreach($this->bean->fields as $param)
		{	
			if ($param->isArray)
			{
				$s .= "	\$__xsd .= \"{$param->name}=(\";\r\n";
				if($param->isObject){
					$s .= "	foreach(\${$param->name} as \$_elm) \$__xsd .= {$param->type}_ToDebugString(\$_elm).\",\";\r\n";
				}else{
					$s .= "	foreach(\${$param->name} as \$_elm) \$__xsd .= strval(\${$param->name});\r\n";
				}
				$s .= "	\$__xsd .= \"),\";\r\n";
			}
			else if($param->isObject)
			{
				$s .= "	\$__xsd .= \"{$param->name}=\".{$param->type}_ToDebugString(\${$param->name}).\",\";\r\n";				
			}
			else
			{
				$s .= "	\$__xsd .= \"{$param->name}={\${$param->name}},\";\r\n";
			}
		}

		return $s;
	}
	
	public function genDebugStringCode($dtpl)
	{
		$bean = $this->toBean();
		
		$param = $this->genServerParamDefineCode();
		$debug = $this->debugCode();
				
		$tpl = $dtpl;
		$tpl = str_replace("/*::METHOD_NAME::*/",$this->method_name,$tpl);		
		$tpl = str_replace("/*::PARAM_DEFINE::*/",$param,$tpl);		
		$tpl = str_replace("/*::DEBUG_CODE::*/",$debug,$tpl);	
		
		return $tpl;
	}
}

?>