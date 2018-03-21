
APPNAME="Dota"

echo "请确认build_native.sh里NDK_ROOT&COCOS2DX_ROOT"

# options

#export NDK_ROOT=/cygdrive/D/adt-bundle-windows-x86-20130219/android-ndk-r8e
#export COCOS2DX_ROOT=/cygdrive/D/WorkSVN/CardGame_1/Branches/forJavascriptDev/client

buildexternalsfromsource=

usage(){
cat << EOF
usage: $0 [options]

Build C/C++ code for $APPNAME using Android NDK

OPTIONS:
-s	Build externals from source
-h	this help
EOF
}

while getopts "sh" OPTION; do
	case "$OPTION" in
	s)
		buildexternalsfromsource=1
	;;
	h)
		usage
		exit 0
	;;
		esac
done

# read local.properties

#xinzheng 2013-05-12
#$(warning  $(dirname "$0"))

_LOCALPROPERTIES_FILE=$(dirname "$0")"/local.properties"
echo $_LOCALPROPERTIES_FILE
if [ -f "$_LOCALPROPERTIES_FILE" ]
then
    [ -r "$_LOCALPROPERTIES_FILE" ] || die "Fatal Error: $_LOCALPROPERTIES_FILE exists but is unreadable"

    # strip out entries with a "." because Bash cannot process variables with a "."
    _PROPERTIES=`sed '/\./d' "$_LOCALPROPERTIES_FILE"`
    for line in "$_PROPERTIES"; do
        declare "$line";
    done
fi

# paths

if [ -z "${NDK_ROOT+aaa}" ];then
echo "NDK_ROOT not defined. Please define NDK_ROOT in your environment or in local.properties"
exit 1
fi

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
# ... use paths relative to current directory

export COCOS2DX_ROOT="$DIR"/../../../Code_Core

APP_ROOT="$DIR"/..
APP_ANDROID_ROOT="$DIR"

echo "DIR = $DIR"
echo "NDK_ROOT = $NDK_ROOT"
echo "COCOS2DX_ROOT = $COCOS2DX_ROOT"
echo "APP_ROOT = $APP_ROOT"
echo "APP_ANDROID_ROOT = $APP_ANDROID_ROOT"
echo "NdkGdb = $NdkGdb"
#echo "sdk.dir" = $sdk.dir

if [ $* != "clean" ]; then
	# make sure assets is exist
	#if [ -d "$APP_ANDROID_ROOT"/assets ]; then
	#    rm -rf "$APP_ANDROID_ROOT"/assets
	#fi
	
	#mkdir "$APP_ANDROID_ROOT"/assets
	
	# copy resources
	echo "copy resources:"
	echo "from ""$APP_ROOT"/Resources
	echo "to ""$APP_ANDROID_ROOT"/assets
	#for file in /cygdrive/D/WorkSVN/Debug_Alpha/Resources2/*
	for file in "$APP_ROOT"/../../Resource_Encrypt/*
	#for file in /cygdrive/D/WorkSVN/Debug_Alpha/AndroidResources20130706/*
	do
		if [ -d "$file" ]; then
		    cp -urf "$file" "$APP_ANDROID_ROOT"/assets
		fi
		
		if [ -f "$file" ]; then
		    cp -u "$file" "$APP_ANDROID_ROOT"/assets
		fi
	done
	
	#for file in "$APP_ROOT"/360Res/*
	#	do
	#	if [ -d "$file" ]; then
	#	    cp -urf "$file" "$APP_ANDROID_ROOT"/assets
	#	fi
	#	
	#	if [ -f "$file" ]; then
	#	    cp -u "$file" "$APP_ANDROID_ROOT"/assets
	#	fi
	#done

	#for file in "$APP_ROOT"/XiaoMiRes/*
	#	do
	#	if [ -d "$file" ]; then
	#	    cp -urf "$file" "$APP_ANDROID_ROOT"/assets
	#	fi
	#	
	#	if [ -f "$file" ]; then
	#	    cp -u "$file" "$APP_ANDROID_ROOT"/assets
	#	fi
	#done

	
	#for file in "$APP_ROOT"/sinaRes/*
	#	do
	#	if [ -d "$file" ]; then
	#	    cp -urf "$file" "$APP_ANDROID_ROOT"/assets
	#	fi
	#	
	#	if [ -f "$file" ]; then
	#	    cp -u "$file" "$APP_ANDROID_ROOT"/assets
	#	fi
	#done
	
	#for file in "$APP_ROOT"/oppoRes/*
	#	do
	#	if [ -d "$file" ]; then
	#	    cp -urf "$file" "$APP_ANDROID_ROOT"/assets
	#	fi
	#	
	#	if [ -f "$file" ]; then
	#	    cp -u "$file" "$APP_ANDROID_ROOT"/assets
	#	fi
	#done
	
	echo "copy resources done"
	chmod -R 777 "$APP_ANDROID_ROOT"/assets
	chmod -R 777 "$APP_ANDROID_ROOT"/obj
fi

echo "build cmd: "$*

#if [ $* == "clean" ]; then
	#echo "output local project all sources files: "
	#目录没改对，不用
	#sh "./jni/list.sh"
	#echo "output done"
#fi

if [[ "$buildexternalsfromsource" ]]; then
    echo "Building external dependencies from source"
    set -x
    "$NDK_ROOT"/ndk-build -C "$APP_ANDROID_ROOT" $* \
        "NDK_MODULE_PATH=${COCOS2DX_ROOT}:${COCOS2DX_ROOT}/cocos2dx/platform/third_party/android/source"
else
    echo "Using prebuilt externals"
    set -x
    "$NDK_ROOT"/ndk-build -C "$APP_ANDROID_ROOT" $* \
        "NDK_MODULE_PATH=${APP_ANDROID_ROOT}:${APP_ROOT}/..:${APP_ROOT}/../build"
fi




cp -u "$APP_ROOT"/360Res/libpaypalm_app_plugin_jar_360game.so "$APP_ANDROID_ROOT"/libs/armeabi
cp -u "$APP_ROOT"/360Res/libpaypalm_app_plugin_jar_360game.so "$APP_ANDROID_ROOT"/libs/armeabi-v7a


