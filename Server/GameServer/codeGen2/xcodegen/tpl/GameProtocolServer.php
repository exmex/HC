<?php
/**
 * 
 * [This file was auto-generated. PLEASE DONT EDIT]
 * 
 * @author LiangZhixian
 *
 */
require_once ("GameProtocolConstants.php");
if(DEBUG){
	require_once($GLOBALS['GAME_ROOT']."log/Logger.php");
	require_once("GameProtocolDebug.php");
}
class GameProtocolServer 
{
	public $response_data = '';	
	
	public function HandleReceivedData($post_data)
	{
		return __HandleReceiveDataAndDispatch($post_data);
	}
	
	public function CheckValidAction($cmd/*int*/)
	{
		return 0;
	}	
/*::EVENT_CODE::*/
	
/*::DISPATCH_CODE::*/
}

?>