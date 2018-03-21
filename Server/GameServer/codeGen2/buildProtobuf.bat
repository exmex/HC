cd protobuf\export
php ..\protoc-php.php ..\csproto\up.proto
php ..\protoc-php.php ..\csproto\down.proto
php ..\protoc-php.php ..\csproto\bcup.proto
php ..\protoc-php.php ..\csproto\bcdown.proto
xcopy /y *.* ..\..\..\server2\pb_proto\
pause