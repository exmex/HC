<?php
header("Content-type: Application/json");

echo json_encode(array(
	"version" => 1,
	"severs" => array(
		array(
			"id" => 1,
			"name" => "Local",
			"address" => "127.0.0.1",
			"port" => 10001,
			/*
			- general
			- new
			- full
			*/
			"state" => "general",
			//"order" => 0,
		),
	),
	"severVerson" => "1.000.0",
	"updateAddress" => "1",
	"defaultSeverID" => 1,
	"rootAddress" => "1",
	//"inStoreUpdate" => "",
	"announcement" => "Hello World!",
	
	//std::string serverInGeyKey = "serverInGray" + langType;
	//"serverInGrayen-US" => "",
	//"serverInGrayde-DE" => "",
	
	//std::string annKey = "internalAnnouncementFilePath" + langType;
	"internalAnnouncementFilePathen-US" => "http://127.0.0.1/announcement.php",
	//"internalAnnouncementFilePathde-DE" => "",
	//"internalAnnouncementVersion" => 1,
	
	//std::string serverInUpdatKey = "serverInUpdate" + langType;
	//"serverInUpdateen-US" => "",
	//"serverInUpdatede-DE" => "",
));
?>