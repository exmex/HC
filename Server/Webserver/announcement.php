<?php
header("Content-type: Application/json");

echo json_encode(array(
	"announcementConfig" => array(
		array("Msg" => "Hello "),
		array("Msg" => "World!"),
	),
));
?>