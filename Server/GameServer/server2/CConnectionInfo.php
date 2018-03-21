<?php

require_once($GLOBALS['GAME_ROOT'] . "CMySQL.php");
require_once($GLOBALS['GAME_ROOT'] . "Log/Logger.php");
require_once($GLOBALS['GAME_ROOT'] . "Protocol/proxy_idl.php");

class ConnectionInfo
{

    public $user_id = '-1';
    public $state = _ECONNECTION_STAT::NONE;
    public $socket_id;
    public $proxy_id;
    public $type = 1;
    public $ukey = '';
    public $address = '0.0.0.0:0';

    function ConnectionInfo()
    {
        if (empty($_SERVER [_ECUSTOM_HEADER::socket_id]) || empty($_SERVER [_ECUSTOM_HEADER::proxy_id])) {
            //Logger::getLogger()->error("socket_id or proxy_id is unset!");
            return;
        }

        MySQL::selectDefaultDb();

        $this->socket_id = $_SERVER [_ECUSTOM_HEADER::socket_id];
        $this->proxy_id = $_SERVER [_ECUSTOM_HEADER::proxy_id];
        $this->address = $_SERVER ["REMOTE_ADDR"] . ":" . $_SERVER["REMOTE_PORT"];

	//if ( isset($GLOBALS['USER_ID']) )
        //{
        //	$this->user_id = $GLOBALS['USER_ID'];
        //}
        if (true) {
            return;
        }

        $this->ukey = sprintf(" WHERE proxy_id='%s' and socket_id='%s' and type='%d'", $this->proxy_id, $this->socket_id, $this->type);

        $query = "SELECT user_id,state FROM player_connection_info" . $this->ukey;
        $rs = MySQL::getInstance()->RunQuery($query);
        $arr = MySQL::getInstance()->FetchArray($rs);

        if (empty($arr) || count($arr) == 0) {
            //goto connected state automatically.
            $this->state = _ECONNECTION_STAT::CONNECTED;
            $this->create();
            Logger::getLogger()->debug("create connection info");
            return;
        }

        $this->user_id = $arr ['user_id'];
        $this->state = $arr ['state'];

        $GLOBALS['USER_ID'] = $this->user_id;
    }

    function create()
    {
        $query = "INSERT INTO player_connection_info(user_id,proxy_id,socket_id,type,state,address,create_time) "
            . "VALUES('$this->user_id','$this->proxy_id','$this->socket_id','1','$this->state','$this->address',now())"
            . " ON DUPLICATE KEY UPDATE state='$this->state'";

        MySQL::selectDefaultDb();
        MySQL::getInstance()->RunQuery($query);
    }

    function changeState($s)
    {
        if ($this->state != $s) {
            $this->state = $s;
            $query = "UPDATE player_connection_info set state='{$s}', user_id='{$this->user_id}' where proxy_id='{$this->proxy_id}' and socket_id='{$this->socket_id}' and type='{$this->type}'";
            MySQL::selectDefaultDb();
            MySQL::getInstance()->RunQuery($query);
        }
    }

    function setUserToConnection($u)
    {
        $this->user_id = $u;
        $GLOBALS['USER_ID'] = $this->user_id;
    }

    function delete()
    {
        $query = "DELETE FROM player_connection_info WHERE proxy_id='{$this->proxy_id}' and socket_id='{$this->socket_id}' and type={$this->type}";
        MySQL::selectDefaultDb();
        MySQL::getInstance()->RunQuery($query);
    }

}
