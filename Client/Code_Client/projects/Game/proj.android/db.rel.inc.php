<?php

function gotodie($msg)
{
	echo $msg. "\n";
	exit(1);
}


$mysql_host="heromysqlmaster";
//$mysql_host="127.0.0.1";
$mysql_user="hero";
$mysql_db="hero";
$mysql_password="hero3n#4g7&ks";
$con = mysql_connect($mysql_host,$mysql_user,$mysql_password);
if (!$con)
{
  gotodie('Could not connect: ' . mysql_error());

}

mysql_select_db($mysql_db, $con) or gotodie(mysql_error());
