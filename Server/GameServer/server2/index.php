<?php
//set time zone
date_default_timezone_set('Etc/GMT-12');
ini_set("error_reporting", E_ALL);
ini_set("display_errors", "1");
ini_set("track_errors", "1");
set_time_limit(0);

require_once('gateway.php');
exec_gate_way('WorldSvc');

?>
