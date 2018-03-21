<?php
/**
 * @author LiangZhixian
 * 2010-09-24
 */
require_once 'XMethod.php';
require_once 'XTypeMap.php';

class XInterfaceParser {
	
	var $handleMethodTpl;
	
	var $sendMethodTpl;
	
	var $handleMethodTpl_0;
	
	var $sendMethodTpl_0;
	
	var $actionDispacherTpl;
			
	var $serverHandleMethodTpl;
	
	var $serverSendMethodTpl;
	
	var $serverInterfaceTpl;
	
	var $methodDebugTpl;
	
	var $beanTpl;
	
	var $handleMethod;
	
	var $sendMethod;
	
	var $handleMethodObjs;
	
	var $sendMethodObjs;
	
	var $namespace = '';
	
	var $beanPath;	
	
	var $interfaceCmd;
	
	var $eventCmd;
	
	var $forserver = true; 	
	
	public $result = array();
	
		
	function XInterfaceParser($t,$n,$bp)
	{		
		$this->handleMethodTpl = file_get_contents($t."handle_method.ctpl");
		$this->sendMethodTpl = file_get_contents($t."send_method.ctpl");
		$this->handleMethodTpl_0 = file_get_contents($t."handle_method_0.ctpl");
		$this->sendMethodTpl_0 = file_get_contents($t."send_method_0.ctpl");		
		$this->beanTpl =  file_get_contents($t."xbean.ctpl");
		$this->serverHandleMethodTpl = file_get_contents($t."server_handle_method.ptpl");
		$this->serverSendMethodTpl = file_get_contents($t."server_send_method.ptpl");
		$this->serverInterfaceTpl = file_get_contents($t."interface.ptpl");
		$this->methodDebugTpl = file_get_contents($t."method_debug.ptpl");
		$this->namespace = $n;
		$this->beanPath = $bp;			
	}
	
	function begin()
	{
		$this->handleMethod = '';
		$this->sendMethod = '';		
		
		$this->interfaceCmd = "  interface _EMSG_ServerInterface\r\n	{\r\n";
		$this->eventCmd = "  interface _EMSG_ServerEvent\r\n	{\r\n";
		
		$this->result['XCMD_BEAN_CODE'] = '';
		$this->result['XCMD_DISPATCH_DEFINE_CODE'] = '';
		$this->result['XCMD_DISPATCH_IMP_CODE'] = '';
		$this->result['XCMD_EVENT_DEFINE_CODE'] = '';
		$this->result['XCMD_EVENT_IMP_CODE'] = '';
		$this->result['EN_XCMD_DEFINE_CODE']='';
		$this->result['SERVER_SEND_METHOD'] = '';
		$this->result['SERVER_HANDLE_METHOD'] = '';
		$this->result['SERVER_INTERFACE'] = '';
		$this->result['METHOD_DEBUG'] = '';
		
		$this->handleMethodObjs = array();
		$this->sendMethodObjs = array();
	}
	
	private function getHandleMethodName($name)
	{
		if (!$this->forserver)
		{
			return $name;			
		}
		
	    $reg = "/Send(\w+)/";
	    if (preg_match($reg,$name,$m))
	    {	    	
	    	return "On".$m[1];	    	
	    }
	   	   
	   	$n = "On".$name;

	   	return $n;		
	}

	private function getSendMethodName($name)
	{
	    if (!$this->forserver)
		{
			return $name;			
		}		
		
		$reg = "/On(\w+)/";
	    if (preg_match($reg,$name,$m))
	    {	    	
	    	return "Send".$m[1];	    	
	    }
	   
	   	return "Send".$name;	
		
	}	
	
	function end()
	{		
		$this->genBeans();
		
		$this->result['CMD_STRUCT_DEFINE'] = $this->interfaceCmd.$this->eventCmd;
					
		return $this->result;
	}
	
	function addData($fileData)
	{
		if (empty($fileData))
		{
			return;
		}        
		
		$reg_inter = "|\s*interface\s*ServerInterface\s*{(.*)}\s*;|U";
		$reg_event = "|\s*dispinterface\s*ServerEvent\s*{(.*)}\s*;|U";
		
		if(preg_match_all($reg_inter,$fileData,$match))
		{
			foreach($match[1] as $m)
			{
				$this->parseSendMethod($m);
			}
		}
		
	    if(preg_match_all($reg_event,$fileData,$match))
		{
			foreach($match[1] as $m)
			{
				$this->parseHandleMethod($m);
			}
		}		
		
	}
	
	private function parseSendMethod($data)
	{
		$reg = "|\s*INT\s+(.*);|U";		
		if(preg_match_all($reg,$data,$match))
		{
			foreach($match[1] as $m)
			{
				$t = $this->parseMethod($m,false);
				if (!empty($t))
				{
					$this->sendMethodObjs[] = $t;
				}
			}
		}
	}
	
	private function parseHandleMethod($data)
	{
	    $reg = "|\s*INT\s+(.*);|U";		
		if(preg_match_all($reg,$data,$match))
		{
			foreach($match[1] as $m)
			{
				$t = $this->parseMethod($m,true);
				if (!empty($t))
				{
					$this->handleMethodObjs[] = $t;
				}
			}
		}	
		
	}
	
	private function parseMethod($data,$issend)
	{
		$array = explode("=",$data);
		
		$method = new Method();
		
		$method->cmd = $array[1];
		
		$reg_name = "/^\w+/";
		
		if (preg_match($reg_name,$data,$m))
		{
			$method->name = $m[0];
			if ($issend){
				$method->method_name = $this->getSendMethodName($m[0]);		
			}else{
				$method->method_name = $this->getHandleMethodName($m[0]);		
			}
		}		
		
		$reg_params = "/\((.*)\)/";
		if (preg_match($reg_params,$data,$m))
		{			
			$method->Parameters = $this->parseParameters($m[1]);
			
		}		
		
		$method->genDetails();		
		
		return $method;
		
	}
	
	private function parseParameters($data)
	{
		$array = explode(",",$data);
		
		$parameters = array();
		
		$reg = "/\w+\s*\[\s*\]/";
				
		foreach($array as $a)
		{
			$a = trim($a);

			$arr = explode(" ",$a);
			
			if(count($arr) == 2)
			{
				$p = new Parameter();	
				$p->type = $arr[0];	
				if(preg_match($reg,$arr[1],$m))
				{
					if(preg_match("/\w+/",$arr[1],$n))
					{
						$p->name = $n[0];
					}
					else
					{
						$p->name = $m[0];
					}
					
					$p->isArray = true;
				}	
				else
				{
					$p->name = $arr[1];
					$p->isArray = false;
				}
				
			    if (!empty(TypeMap::$TYPE_MAP[$p->type]))
				{					
					$p->isObject = false;
					$p->type = TypeMap::$TYPE_MAP[$p->type];
				}
				else 
				{				
					$p->isObject = true;
				}				
								
				$parameters[] = $p;
			}

		}	
		
		return $parameters;
		
	}
	
	private function genDispachCodes()
	{
	    $s = '';
	    if (!$this->forserver){
	    foreach ($this->handleMethodObjs as $ho)
	    {
	    	$s .= sprintf("                case %s: _%s(buffer); break;\r\n",
	    	              $ho->cmd,
	    	              $ho->name);
	    }
	    }
	    else{	    
	    foreach ($this->sendMethodObjs as $ho)
	    {
	    	$s .= sprintf("                case %s: _%s(buffer); break;\r\n",
	    	              $ho->cmd,
	    	              $this->getHandleMethodName($ho->name));
	    }
	    }
	    
	    return $s;
	}
	
	private function genBeans()
	{
		$CMSG_MAX = 0;
		$SMSG_MAX = 0;
		foreach ($this->handleMethodObjs as $ho)
		{
			$bean = $ho->toBean();
			
			if (count($bean->fields) > 0)
			{
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
			
				$this->result['XCMD_BEAN_CODE'] .= $tpl;
				$this->result['XCMD_EVENT_IMP_CODE'] .= $ho->genSendMethodCode($this->sendMethodTpl);		
			}
			else
			{
				$this->result['XCMD_EVENT_IMP_CODE'] .= $ho->genSendMethodCode($this->sendMethodTpl_0);	
			}
			
			$this->result['XCMD_EVENT_DEFINE_CODE'] .= $ho->genEventDefineCode();	
			$this->result['EN_XCMD_DEFINE_CODE'] .= $ho->genXcmdDefineCode();	
			$this->result['SERVER_SEND_METHOD'] .= $ho->genServerSendMethodCode($this->serverSendMethodTpl);		
			$this->eventCmd .= 	$ho->genEventCmdCode();
			if (intval($ho->cmd) > $SMSG_MAX){
				$SMSG_MAX = intval($ho->cmd);
			}
			
			$this->result['METHOD_DEBUG'] .= $ho->genDebugStringCode($this->methodDebugTpl);
		}	

		foreach ($this->sendMethodObjs as $so)
		{
			$bean = $so->toBean();
			
			if (count($bean->fields) > 0)
			{
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
			
				$this->result['XCMD_BEAN_CODE'] .= $tpl;
				$this->result['XCMD_DISPATCH_IMP_CODE'] .= $so->genHandleMethodCode($this->handleMethodTpl);	
			}
			else
			{
				$this->result['XCMD_DISPATCH_IMP_CODE'] .= $so->genHandleMethodCode($this->handleMethodTpl_0);	
			}
			$this->result['XCMD_DISPATCH_DEFINE_CODE'] .= $so->genDispatchDefineCode();	
			$this->result['SERVER_HANDLE_METHOD'] .= $so->genServerHandleMethodCode($this->serverHandleMethodTpl);
			$this->result['SERVER_INTERFACE'] .= $so->genServerHandleMethodCode($this->serverInterfaceTpl);
			$this->interfaceCmd .= 	$so->genInterfaceCmdCode();
			if (intval($so->cmd) > $CMSG_MAX){
				$CMSG_MAX = intval($so->cmd);
			}
			
			$this->result['METHOD_DEBUG'] .= $so->genDebugStringCode($this->methodDebugTpl);
		}
		
		$CMSG_MAX += 1;
		$SMSG_MAX += 1;
		
		$this->eventCmd .= "		const SMSG_MAX ={$SMSG_MAX};\r\n	}\r\n";
		$this->interfaceCmd .= 	"		const CMSG_MAX ={$CMSG_MAX};\r\n	}\r\n";		
	}

}

?>