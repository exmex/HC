<?php
/**
 * 
 * [This file was auto-generated. PLEASE DONT EDIT]
 * 
 * @author LiangZhixian
 *
 */
if(DEBUG){
	require_once($GLOBALS['GAME_ROOT']."log/Logger.php");
	require_once("GameProtocolDebug.php");
}
  interface _ECUSTOM_HEADER
	{
		const php_err_length="php-err-len";
		const proto_error_code="proto-erro-code";
		const content_type="Content-type: application/xproto";
		const content_length="Content-length";
		const socket_id="HTTP_SOCKET_ID";
		const proxy_id="HTTP_PROXY_ID";
		const x_proto_type="xproto";

	}
	
	function __CheckValidAction($cmd/*int*/)
	{
		$_SERVER['GAME_SERVER_INSTANCE']->CheckValidAction($cmd/*int*/);
	}

