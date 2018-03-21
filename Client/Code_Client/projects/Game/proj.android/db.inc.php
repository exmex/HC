<?php

function gotodie($msg)
{
	echo $msg. "\n";
	exit(1);
}


//$mysql_host="216.66.6.237";
$mysql_host="heromysqlmasterdev";
//$mysql_host="127.0.0.1";
$mysql_user="hero";
$mysql_db="hero_devel";
$mysql_password="herodevel2014";
$con = mysql_connect($mysql_host,$mysql_user,$mysql_password);
if (!$con)
{
  gotodie('Could not connect: ' . mysql_error());

}

mysql_select_db($mysql_db, $con) or gotodie(mysql_error());

