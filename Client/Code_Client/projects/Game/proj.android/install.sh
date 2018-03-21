adb install -r bin/hero-release.apk 
if [ $? -ne 0 ]; then
   adb uninstall com.ucool.hero
fi
adb shell mkdir /mnt/shell/emulated/0/Android/obb/com.ucool.hero
adb push  main.2.com.ucool.hero.obb /mnt/shell/emulated/0/Android/obb/com.ucool.hero
