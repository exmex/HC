<?php




$currentFileList=array();
$fn = $_SERVER['argv'][1];
$svnVersion = $_SERVER['argv'][2];
$binaryVersion= $_SERVER['argv'][3];
$releaseType= $_SERVER['argv'][4];
$dataVersion= $_SERVER['argv'][5];
#echo $fn;


if($releaseType=="alpha")
{
	require("db.inc.php");
	$tableName="client_patch_log_android";
}else if($releaseType=="beta")
{
	require("db.rel.inc.php");
	$tableName="client_patch_log_android_temp";
}else if($releaseType=="release")
{
	require("db.rel.inc.php");
	$tableName="client_patch_log_android";
}

print_r(array($msyql_host,$mysql_user,$mysql_password));
print_r($_SERVER);



$str = file_get_contents($fn);
$lines = explode("\n", $str);

foreach($lines as $line)
{
	if($line=="")
		continue;
	$vs = explode("@@@@",$line);
	$currentFileList[$vs[0]] = array('filename'=>$vs[0], 'hash'=>$vs[1], 'rawfilename'=>$vs[2],'size'=>$vs[3]);
}

//echo "input file list: \n";
//print_r($currentFileList);

$oldFileList=array();



//echo "filelist from db list: \n";
//print_r($oldFileList);


try {
	$result = mysql_query("select max(version) as max_version, now() as ct  from 	$tableName");
	$updateTime = "";
	if(!$result)
		gotodie(mysql_error());
	while($row = mysql_fetch_array($result))
	{
		$maxVersion = intval($row['max_version']);
		$updateTime = $row['ct'];
	}
	mysql_free_result($result);
	if($updateTime=="")
		$updateTime=date('Y-m-d H:i:s');
	$maxVersion++;
} catch (Exception $e) {
	exit(1);
}

if($releaseType=="release" || $releaseType=="beta" )
{
	if($maxVersion > $dataVersion){
		echo "Error maxVersion $maxVersion > dataVersion $dataVersion";
		exit(1);
	}
	$maxVersion = $dataVersion;
}



try {
	$result = mysql_query("SELECT * FROM $tableName where active=1 and version < $dataVersion");
	if(!$result)
		gotodie(mysql_error());
	while($row = mysql_fetch_array($result))
	{
		$filename = $row['filename'];
		
		if( !isset($oldFileList[$filename]) ||  intval($oldFileList[$filename]['version']) < $ver )  	
		{
			$oldFileList[$filename] = $row;
		}
	}
	
	mysql_free_result($result);

} catch (Exception $e) {
	exit(1);
}


echo "maxVersion is $maxVersion \n";

$modifyFileList=array();

foreach($currentFileList as $k=>$v)
{
	if(!isset($oldFileList[$k]) || $oldFileList[$k]['hash']!=$v['hash'])
	{
		if(!isset($oldFileList[$k]) )
			echo "file added: $k\n";
		else
			echo "file modified: $k\n";
		$modifyFileList[] = $v;
	}
}

//echo "modifyFileList: \n";
//print_r($modifyFileList);



try {
	foreach ($modifyFileList as $row) {
		$filename = $row['filename'];
		$hash = $row['hash'];
		$rawfilename = $row['rawfilename'];
		$size = $row['size'];
		$sql = "update $tableName set active=0 where active=1 and filename='$filename'";
		$result = mysql_query($sql);
		if(!$result) gotodie(mysql_error() . $sql);
	
		$sql = "delete from $tableName where filename='$filename' and version=$maxVersion and binary_version=$binaryVersion";
		$result = mysql_query($sql);
		if(!$result) gotodie(mysql_error() . $sql);
		
		$sql = "insert into $tableName(version, filename, hash, active, update_time,svn_version,raw_filename,binary_version,`size`)  "
		                          . " values($maxVersion, '$filename','$hash',1, '$updateTime',$svnVersion, '$rawfilename',$binaryVersion,$size)";
		$result = mysql_query($sql);
		if(!$result) gotodie(mysql_error(). $sql);
	}
	
	
	mysql_close($con);
} catch (Exception $e) {
	exit(1);
}

exit(0);




