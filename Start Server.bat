echo off
cd Server

cd Database
start mysql_start.bat

cd ..\
cd Webserver
start php -S 127.0.0.1:80 -t "%cd%"

cd ..\
cd Proxy-Emulator\ProxyEmulator\bin\Debug
start ProxyEmulator.exe
cd ..\..\..\

cd ..\
cd memcached
start memcached.exe

cd ..\
cd GameServer\server2
start php -S 127.0.0.1:8080 -t "%cd%"