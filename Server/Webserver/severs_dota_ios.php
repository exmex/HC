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
			"state" => "general",
		),
	),
	"severVerson" => "1.000.0",
	"updateAddress" => "1",
	"defaultSeverID" => 1,
	"rootAddress" => "1",
));
?>