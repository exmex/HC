<?php
/**
 * @author LiangZhixian
 * 2010-09-24
 */
require_once ("XBeanParser.php");
require_once ("XInterfaceParser.php");
require_once ("XEnumParser.php");

function main($argc,$argv)
{		
	$BASE_TPL_PATH = dirname(__FILE__)."/tpl/";
	$BASE_IDL_PATH = dirname(dirname(__FILE__)).'/idls/';
	$BASE_OP_PATH = dirname(dirname(dirname(__FILE__)))."/server2/xprotocol/";	
	$DEBUG = false;
	
	if($argc > 1){
		$DEBUG = (strcasecmp($argv[1],"DEBUG")==0);		
	}
		
	codeGen($BASE_TPL_PATH,$BASE_IDL_PATH,$BASE_OP_PATH,$DEBUG);
	
	echo "finished";
}


function codeGen($tpl_path,$idl,$output,$DEBUG=false)
{	
	$beanParser = new XBeanParser($tpl_path,'',$output);
	$interfaceParser = new XInterfaceParser($tpl_path,'',$output);
	$enumParser = new XEnumParser($tpl_path,'',$output);
			
	$beanParser->begin();
	$interfaceParser->begin();
	$enumParser->begin();
	
	$indexFile = file($idl."game.txt");
		
	foreach ($indexFile as $line)
	{
		$fn = trim($line);
		if (!empty($fn) && strlen($fn) > 0)
		{			
			$file = file_get_contents($idl.$fn);
			$file = filterComments($file);					  
		    $beanParser->addData($file);		   
		    $interfaceParser->addData($file);
		    $enumParser->addData($file);
		}
	}	
	
	$bean_result = $beanParser->end();	
	$itf_result = $interfaceParser->end();	
	$constants_result = $enumParser->end();
	
	$beancode  = $bean_result['BEAN'];
	$beancode .= $itf_result['XCMD_BEAN_CODE'];
		
	$tpl = file_get_contents($tpl_path."xproto.c");		
	$tpl = str_replace("/*::EN_XCMD_DEFINE_CODE::*/",$itf_result['EN_XCMD_DEFINE_CODE'],$tpl);
	$tpl = str_replace("/*::XCMD_DISPATCH_DEFINE_CODE::*/",$itf_result['XCMD_DISPATCH_DEFINE_CODE'],$tpl);
	$tpl = str_replace("/*::XCMD_DISPATCH_IMP_CODE::*/",$itf_result['XCMD_DISPATCH_IMP_CODE'],$tpl);
	$tpl = str_replace("/*::XCMD_EVENT_IMP_CODE::*/",$itf_result['XCMD_EVENT_IMP_CODE'],$tpl);	
	$tpl = str_replace("/*::CLASS_ENTRY_DEFINE_CODE::*/",$bean_result['INIT'],$tpl);
	$tpl = str_replace("/*::BEAN_DEFINE_CODE::*/",$beancode,$tpl);
	file_put_contents($output."xproto.c",$tpl);
	
	$tpl = file_get_contents($tpl_path."php_xproto.h");	
	$tpl = str_replace("/*::XCMD_EVENT_DEFINE_CODE::*/",$itf_result['XCMD_EVENT_DEFINE_CODE'],$tpl);
	$tpl = str_replace("/*::BEAN_S_FUNCTION_CODE::*/",$bean_result['BSFUNC'],$tpl);
	file_put_contents($output."php_xproto.h",$tpl);
	
	
	$constants = file_get_contents($tpl_path."GameProtocolConstants.php");	
	$constants .= $constants_result;
	$constants .= $itf_result['CMD_STRUCT_DEFINE'];
	file_put_contents($output."GameProtocolConstants.php",$constants);
	
	$tpl = file_get_contents($tpl_path."GameProtocolServer.php");		
	$tpl = str_replace("/*::EVENT_CODE::*/",$itf_result['SERVER_SEND_METHOD'],$tpl);
	$tpl = str_replace("/*::DISPATCH_CODE::*/",$itf_result['SERVER_HANDLE_METHOD'],$tpl);
	if (!$DEBUG) $tpl = filterDebugInfo($tpl);
	file_put_contents($output."GameProtocolServer.php",$tpl);
	
	$cinterface = file_get_contents($tpl_path."GameProtocolInterface.php");	
	$cinterface .= $itf_result['SERVER_INTERFACE'];
	if (!$DEBUG) $cinterface = filterDebugInfo($cinterface);
	file_put_contents($output."GameProtocolInterface.php",$cinterface);	
	
	$gfdebug = file_get_contents($tpl_path."GameProtocolDebug.php");	
	$gfdebug .= $bean_result['BEANDEBUG'];
	$gfdebug .= $itf_result['METHOD_DEBUG'];
	file_put_contents($output."GameProtocolDebug.php",$gfdebug);	
	
	
	$cmds = "";
	foreach($interfaceParser->sendMethodObjs as $so){
		$cmds .= "CMSG_{$so->name}={$so->cmd}\r\n";
	}
	file_put_contents($output."cmd.txt",$cmds);
}	 		

function filterComments($data)
{
	$d = preg_replace("/\/\/(.*)/", "",$data);
	$d = preg_replace("/\/\*(.*)\*\//sU", "", $d);	
	$d = str_replace("\r\n"," ",$d);
	$d = str_replace("\n"," ",$d);	
	
	return $d;
}

function filterDebugInfo($data)
{
	$d = preg_replace("/if\(DEBUG\){(.*)}/sU", "", $data);	
	$d = preg_replace("/(\s*)if\(DEBUG\)(.*)/", "",$d);
		
	return $d;
}

$ac = $argc;
$av = $argv;

main($ac,$av);

?>
