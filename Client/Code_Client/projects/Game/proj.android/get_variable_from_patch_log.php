<?php

$varname = $_SERVER['argv'][1];

if(strpos($varname,"release")!= false ||strpos($varname,"beta")!= false )
{
	require("db.rel.inc.php");

	if($varname=="max_binary_version_release")
	{
		$sql = "SELECT max(binary_version) as maxversion FROM client_patch_log_android";

	}
	else if($varname=="max_data_version_release")
	{
		$sql = "SELECT max(version) as maxversion FROM client_patch_log_android ";
	}	
	else if($varname=="max_svn_version_release")
	{
		$sql = "SELECT max(svn_version) as maxversion FROM client_patch_log_android ";
	}		
	else if($varname=="max_binary_version_beta")
	{
		$sql = "SELECT max(binary_version) as maxversion FROM client_patch_log_android_temp ";
	}
	else if($varname=="max_data_version_beta")
	{
		$sql = "SELECT max(version) as maxversion FROM client_patch_log_android_temp ";
	}	
	else if($varname=="max_svn_version_beta")
	{
		$sql = "SELECT max(svn_version) as maxversion FROM client_patch_log_android_temp ";
	}		
}
else
{	
	require("db.inc.php");
	
	if($varname=="max_binary_version")
	{
		$sql = "SELECT max(binary_version) as maxversion FROM client_patch_log_android ";
	}
	else if($varname=="max_data_version")
	{
		$sql = "SELECT max(version) as maxversion FROM client_patch_log_android ";
	}	
	else if($varname=="max_svn_version")
	{
		$sql = "SELECT max(svn_version) as maxversion FROM client_patch_log_android ";
	}	
	
}

$maxversion=0;
try{	
	
	$result = mysql_query($sql);

	if(!$result)
		gotodie(mysql_error());
	while($row = mysql_fetch_array($result))
	{
	      if($maxversion <  $row['maxversion'])
		{
	         $maxversion=$row['maxversion'];
	         break;
		}
	}
	mysql_free_result($result);
	echo $maxversion;
	mysql_close($con);
		
} catch (Exception $e){
	exit(1);		
}



