cd xcodegen
php xcodegen.php debug
cd ..
xproto.exe -m=idls\game.txt  -sl=php -sd=..\server2\protocol -sp=HG -ace=true  -cl=cpp -cp=HGX -cd=..\..\client\protocol  -stdafx=false -td=templates
copy "..\..\client\protocol\game_idl.pkg"  "..\..\client\tools\tolua++"
cd "..\..\client\tools\tolua++"
build.bat 
pause