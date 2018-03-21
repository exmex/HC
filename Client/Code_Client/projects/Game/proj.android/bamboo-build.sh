
#hero bamboo auto build script
#by dany 2014-7-24
#


find_res()
{
	find . -type f -name "*.ccc" 
	find . -type f -name "*.luac"
	find . -type f -name "*.ccz"
	find . -type f -name "*.png"
	find . -type f -name "*.jpg"
	find . -type f -name "*alpha_mask"
	find . -type f -name "*.proto"
	#find . -type f -name "*.mp3"
	find . -type f -name "*.ogg"
	#find . -type f -name "*.m4a"
	find . -type f -name "*.fsh"
	find . -type f -name "*.vsh"
}

cleanup()
{
	echo "cleanup"

 	cd $1 
echo "OSNAME="$OSNAME 
if [ $OSNAME = "Darwin" ]; then 
	svn revert AndroidManifest.xml
	rm -rf assets 
	rm -rf $filelist
	rm -f  $srcfilelist
	svn update
	return 0
else
	rm -rf src
	rm -rf res
	svn revert AndroidManifest.xml
	rm -f jni/Application.mk
	rm -rf assets 
	 rm -rf $filelist
	 rm -f  $srcfilelist
	 svn update $svn_auth
fi
}


function mysed_inplace()
{

if [ $OSNAME = "Darwin" ]; then 
    #MACOS
    
    find $1  -name "$2" | xargs sed -i "" "$3" 
else
    find $1  -name "$2" | xargs sed -i  "$3" 
fi
}

check_version_format()
{
	isVersionNum=`echo $1 |awk -F '.' '{ if ( ( $1 < 0 ) || ( $2 < 0 ) || ( $3 < 0 ) || ( $4 < 0 )) print $0}'`
	if [ -z "$1" -o -n "$isVersionNum" ]
	then 
			echo "Please fill version number or not correct version number."
			exit 1;
	fi

}

makeobbfile()
{
	echo "making obb for release version: $obbversion  "

	rm -rf assets/.gitignore
	rm -rf assets/.svn
	rm -rf assets/.DS_Store

	rm -f tmp.zip
	zip -r -du  tmp.zip assets -i \*.ddx
	if [ $? -ne 0 ]; then
		echo "making $obbfilename failed"
		#	cleanup $CUR_DIR
		exit 1
	fi

	zip -r -du  -Z store tmp.zip assets -i \*.ddv
	if [ $? -ne 0 ]; then
		echo "making $obbfilename failed"
		#	cleanup $CUR_DIR
		exit 1
	fi
	
	mv tmp.zip  $obbfilename
	
	echo "Backup deploy_res to download Directory"
	rm -rf $CUR_DIR/backupres && mkdir  -p $CUR_DIR/backupres
	cp  $obbfilename $CUR_DIR/backupres/
	cp -r assets/deploy_res $CUR_DIR/backupres/
	echo "Backup deploy_res Directory: `ls -l $CUR_DIR/backupres/deploy_res/`"	
	
	rm -rf assets/deploy_res
	echo "created $obbfilename"

}


setversion()
{
packageName=$1
appName=$2
BUILD_SVN_REV=$3

base_package_name="hero"


#BUILD_SVN_REV=${DIGI_ANDROID_BUILD_REV:-digi_android_build_rev_not_set}
#if [[ $BUILD_SVN_REV == "digi_android_build_rev_not_set" ]]; then
#	unset $BUILD_SVN_REV
#	eval $(svn info | grep "Last Changed Rev:" | grep -v grep | awk '{print "BUILD_SVN_REV="$4}')
echo "use SVN:$BUILD_SVN_REV"

appNameReplace="s/<string name=\"app_name\">\(.*\)<\/string>/<string name=\"app_name\">"$appName"<\/string>/g"
pkgReplace="s/com\.ucool\."$base_package_name"/com.ucool."$packageName"/g"


#echo $argl7
echo $appNameReplace
echo $pkgReplace

echo "obbversion" $obbversion


mysed_inplace  . "AndroidManifest.xml" 's/android:versionName=".*"/android:versionName="'$varVersion'"/g'
mysed_inplace  . "AndroidManifest.xml" 's/android:versionCode=".*"/android:versionCode="'$obbversion'"/g'
grep versionName AndroidManifest.xml
grep versionCode AndroidManifest.xml


grep android:versionCode AndroidManifest.xml

#alpha version
if [[ $packageName == "hcalpha" ]]; then
    echo "do replace of alpha"
    mysed_inplace  ./res "strings.xml" 's/name="app_fid">.*</name="app_fid">440261342782701</g'
    mysed_inplace  ./res "strings.xml" 's/name="app_id">.*</name="app_id">320445014722</g'
fi

#beta version
if [[ $packageName == "hcbeta" ]]; then
    echo "do replace of beta"
    mysed_inplace  ./res "strings.xml" 's/name="app_fid">.*</name="app_fid">441350096007159</g'
fi

#release version
if [[ $packageName == "hero" ]]; then
     echo "do replace of release"
     mysed_inplace  ./res "strings.xml" 's/name="app_fid">.*</name="app_fid">423346011140901</g'
fi


find ./res -name "strings.xml" | xargs grep "app_fid"


#change appname

mysed_inplace  ./res "strings.xml"  "$appNameReplace"

pwd

#change package name
if [[ $packageName != $base_package_name ]]; then
         pkgdir="src/com/ucool/$packageName"
		
         echo "remove old folder"
         rm  -rf $pkgdir

         mysed_inplace . "*.xml" "$pkgReplace"
         mysed_inplace . "*.java" "$pkgReplace"
         mysed_inplace . "*.aidl" "$pkgReplace"

         mv "src/com/ucool/$base_package_name" "$pkgdir"
         echo "moved src/com/ucool/$base_package_name to $pkgdir"
fi

}


buildtype=$1
apkname=bin/$2
dirbase=$3


OSNAME=`uname`
CUR_DIR=`pwd`

srcRoot=$CUR_DIR/../../..
resDir="$srcRoot/projects/hero/Resources"
compile_lua_script="$CUR_DIR/../proj.ios/AutoBuildShell/compile_lua.sh"
get_variable_php="php $CUR_DIR/get_variable_from_patch_log.php"
svnchangeFileList="$CUR_DIR/svnchangeFileList.txt"
versionluaFile="$resDir/data/versionAndroid.lua"
make_patch_php="php $CUR_DIR/makepatch.php"
svn_auth=" --username=builder --password=0wAeiUx929Hv  --non-interactive "
verStr=$4
obbversion=${5:-1}
isSave=${6:-"true"}
varVersion=`echo $verStr | awk -F'.' '{print $1"."$2"."$3}'`


echo "resDir $resDir "
echo "compile_lua_script $compile_lua_script "
echo "get_variable_php $get_variable_php "
echo "svnchangeFileList $svnchangeFileList "
echo "versionluaFile $versionluaFile "
echo "buildtype $buildtype"
echo "apkname $apkname"
echo "dirbase $dirbase"
echo "obbversion $obbversion"
echo "isSave: $isSave"
echo "varVersion: $varVersion"


if [ $OSNAME = "Darwin" ]; then 
	#MACOS
	xencbin="$CUR_DIR/../proj.ios/AutoBuildShell/encres"
	luacbin="$CUR_DIR/../proj.ios/AutoBuildShell/luac"
	echo "NDK_ROOT $NDK_ROOT "
	echo "ANDROID_SDK_ROOT $ANDROID_SDK_ROOT"
	BUILD_SVN_REV=`svn info $svn_auth $srcRoot | grep "^Revision:" | grep -v grep | awk '{print $2}'`
	if [ -z $BUILD_SVN_REV  ]; then 
    	 BUILD_SVN_REV=`svn info $svn_auth $srcRoot | grep "^版本:" | grep -v grep | awk '{print $2}'`
	fi


else
    #LINUX ON BAMBOO
    xencbin="$CUR_DIR/encres"
    luacbin="$CUR_DIR/luac"

	export NDK_ROOT=/mnt/disk7/android-ndk-r10
	export ANDROID_SDK_ROOT=/mnt/disk7/adt-bundle-linux-x86_64-20140702/sdk

	eval $(svn info $svn_auth $srcRoot | grep "Last Changed Rev:" | grep -v grep | awk '{print "BUILD_SVN_REV="$4}')
fi

chmod +x $xencbin
chmod +x $luacbin
chmod +x deploy.sh

echo "use SVN verison :$BUILD_SVN_REV"


deployPath="deploy_res"
filelist=$CUR_DIR/deploy_res_filelist.txt
srcfilelist=$CUR_DIR/srcfilelist.txt



if [ $OSNAME = "Darwin" ]; then 
	echo "no need to calversion at macosx "
else 

	if [ $buildtype = "release" ]; then
	
	
		check_version_format $verStr		
		
		last_svn_version=`$get_variable_php max_svn_version_release`
		if [ $? -ne 0 ]; then
			echo "$get_variable_php max_svn_version failed."
			exit 1
		fi	
		last_binary_version=`$get_variable_php max_binary_version_release`
		if [ $? -ne 0 ]; then
			echo "$get_variable_php max_binary_version failed."
			exit 1
		fi	
		last_data_version=`$get_variable_php max_data_version_release`
		if [ $? -ne 0 ]; then
			echo "$get_variable_php max_data_version failed."
			exit 1
		fi		


		#取二进制发版号
		reA=`echo $verStr | awk -F '.' '{print $1}' `
		reB=`echo $verStr | awk -F '.' '{print $2}' `
		reC=`echo $verStr | awk -F '.' '{print $3}' `
		binary_version=` echo "$reA * 100 + $reB * 10 + $reC " | bc `
		data_version=`echo $verStr | awk -F '.' '{print $4}' `



	elif [ $buildtype = "beta" ]; then
	
	  check_version_format $verStr		
		
		last_svn_version=`$get_variable_php max_svn_version_beta`
		if [ $? -ne 0 ]; then
			echo "$get_variable_php max_svn_version_beta failed."
			exit 1
		fi	
		last_binary_version=`$get_variable_php max_binary_version_beta`
		if [ $? -ne 0 ]; then
			echo "$get_variable_php max_binary_version_beta failed."
			exit 1
		fi	
		last_data_version=`$get_variable_php max_data_version_beta`
		if [ $? -ne 0 ]; then
			echo "$get_variable_php max_data_version_beta failed."
			exit 1
		fi		
		
		#取二进制发版号
		verStr=$4
		reA=`echo $verStr | awk -F '.' '{print $1}' `
		reB=`echo $verStr | awk -F '.' '{print $2}' `
		reC=`echo $verStr | awk -F '.' '{print $3}' `
		binary_version=` echo "$reA * 100 + $reB * 10 + $reC " | bc `
		data_version=`echo $verStr | awk -F '.' '{print $4}' `


		
	else

		#自动发版 alpha
		last_svn_version=`$get_variable_php max_svn_version`
		if [ $? -ne 0 ]; then
			echo "$get_variable_php max_svn_version failed."
			exit 1
		fi	
		last_binary_version=`$get_variable_php max_binary_version`
		if [ $? -ne 0 ]; then
			echo "$get_variable_php max_binary_version failed."
			exit 1
		fi	
		last_data_version=`$get_variable_php max_data_version`
		if [ $? -ne 0 ]; then
			echo "$get_variable_php max_data_version failed."
			exit 1
		fi		
		
		binary_version=$last_binary_version
		data_version=$last_data_version


	fi



	if [ $last_svn_version -eq 0 -a $binary_version -eq 0 -a $buildtype = "alpha" ]; then
		echo "this is the first build."
		let binary_version++
		let data_version++
	elif [ $last_svn_version = $BUILD_SVN_REV -a $buildtype = "alpha" ]; then
		echo "svn doesn't changed"
		exit 0;
	else
		svn  diff $svn_auth -r $last_svn_version:$BUILD_SVN_REV --summarize $srcRoot > $svnchangeFileList

		echo "svn change list from $last_svn_version to $BUILD_SVN_REV:"
		cat $svnchangeFileList;
		
		allchangedNUm=`grep -v "data/version.lua" $svnchangeFileList | wc -l`
		if [ $allchangedNUm -eq 0 -a $buildtype = "alpha" ]; then 
			echo  "nothing changed except version.lua, just finish the building"
			exit 0
		fi

		nativeChangedNum=`grep -E "\.cpp$|\.h$|\.mm$|\.c$|\.m$|\.hpp$" $svnchangeFileList | wc -l `
		echo "nativeChangedNum $nativeChangedNum"

		if [ $nativeChangedNum -ne 0  -a $buildtype = "alpha" ]; then
			echo "Binary file will be changed "
			let binary_version++
		fi


		dataChangeNum=`grep "projects/hero/Resources"  $svnchangeFileList | wc -l`
		echo "dataChangeNum $dataChangeNum"
		if [ $dataChangeNum -ne 0 -a $buildtype = "alpha" ]; then
			echo "Resources changed "
			let data_version++
		fi
	fi



	echo "binary_version $binary_version"
	echo "data_version $data_version"		
	echo "last_svn_version $last_svn_version"
	echo "last_binary_version $last_binary_version"
	echo "last_data_version $last_data_version"



	#
	#定义versionStr
	#
			
	if [ $binary_version != $last_binary_version -o $data_version != $last_data_version ]; then

		
		#alpha发版
		if [ $buildtype = "alpha" ]; then
				
				#
				#计算versionStr
				#		

				verA=`echo "$binary_version / 100 "| bc `
				verB=`echo "( $binary_version - $verA*100 ) / 10" | bc `
				verC=`echo "( $binary_version - $verA*100 - $verB*10 )" | bc `
				verD=$data_version
				verStr="$verA.$verB.$verC.$verD"	

		fi



		echo "building version: $verStr"

		#修改version.lua文件
		#
		verStr="base_version = \"$verStr\""
		echo $verStr
		echo $verStr >  $versionluaFile
		echo "cat version.lua"
		cat $versionluaFile

	fi
fi #end if Darwin

echo "version file:"
cat $versionluaFile


#编译so
if [ $OSNAME = "Darwin" ]; then 

	# mysed_inplace $srcRoot "GateKeeper.h"  "s/IS_ALPHA_VERION 1/IS_ALPHA_VERION 0/g"
	# mysed_inplace $srcRoot "GateKeeper.h"  "s/http:\/\/alpha.hero.ucool.com/https:\/\/hc.ucool.com/g" 

	 if [ -f libs/armeabi/libcocos2dlua.so ]; then
	 	echo "MACOS , do not compile so again to save time, you need to compile it manually you want"
	 else
	 	echo "MACOS , no so found, compile it again"
	 	
	 	rm -rf obj
#copy from else...


		if [ $buildtype = "alpha" ]; then
			echo "building  alpha client so"
			

			./build_native.sh NDK_DEBUG=1
			if [ $? -ne 0 ]; then
				echo "building so failed"
				cleanup $CUR_DIR
				exit 1
			fi
			
			
		elif [ $buildtype = "beta" ]; then


			echo "build android beta client apk "

			mysed_inplace $srcRoot "GateKeeper.h"  "s/IS_ALPHA_VERION 1/IS_ALPHA_VERION 0/g"						
			mysed_inplace $srcRoot "GateKeeper.h"  "/http/s/\(http:.*\/\/\)\(.*\)\(\.ucool\.com.*\)/\1betahero\3/g"

			echo "building beta in linux , turn off COCOS2D_DEBUG "
			mysed_inplace  jni Application.mk 's/armeabi x86/armeabi/g' 
			mysed_inplace  jni Application.mk 's/\-DCOCOS2D_DEBUG=1//g'
			./build_native.sh NDK_DEBUG=0
			
			if [ $? -ne 0 ]; then
				echo "building so failed"
				cleanup $CUR_DIR
				exit 1
			fi

		

		elif [ $buildtype = "release" ]; then
			echo "build android release client so "

			mysed_inplace $srcRoot "GateKeeper.h"  "s/IS_ALPHA_VERION 1/IS_ALPHA_VERION 0/g"
			mysed_inplace $srcRoot "GateKeeper.h"  "/http/s/\(http:.*\/\/\)\(.*\)\(\.ucool\.com.*\)/\1hc\3/g"

			

			echo "building release in linux , turn off COCOS2D_DEBUG "
			mysed_inplace  jni Application.mk 's/armeabi x86/armeabi/g' 
			mysed_inplace  jni Application.mk 's/\-DCOCOS2D_DEBUG=1//g'
			./build_native.sh NDK_DEBUG=0
			
			if [ $? -ne 0 ]; then
				echo "building so failed"
				cleanup $CUR_DIR
				exit 1
			fi
		fi


	 fi
else
	rm -rf obj
	if [ $buildtype = "alpha" ]; then
		echo "building  alpha client apk"
		

		./build_native.sh NDK_DEBUG=1
		if [ $? -ne 0 ]; then
			echo "building so failed"
			cleanup $CUR_DIR
			exit 1
		fi

	elif [ $buildtype = "release" ]; then
		echo "build android release client apk "

		mysed_inplace $srcRoot "GateKeeper.h"  "s/IS_ALPHA_VERION 1/IS_ALPHA_VERION 0/g"		
		mysed_inplace $srcRoot "GateKeeper.h"  "/http/s/\(http:.*\/\/\)\(.*\)\(\.ucool\.com.*\)/\1hc\3/g"

		

		echo "building release in linux , turn off COCOS2D_DEBUG "
		mysed_inplace  jni Application.mk 's/armeabi x86/armeabi/g' 
		mysed_inplace  jni Application.mk 's/\-DCOCOS2D_DEBUG=1//g'
		./build_native.sh NDK_DEBUG=0
		
		if [ $? -ne 0 ]; then
			echo "building so failed"
			cleanup $CUR_DIR
			exit 1
		fi
	
	elif [ $buildtype = "beta" ]; then
		echo "build android beta client apk "

		mysed_inplace $srcRoot "GateKeeper.h"  "s/IS_ALPHA_VERION 1/IS_ALPHA_VERION 0/g"		
		mysed_inplace $srcRoot "GateKeeper.h"  "/http/s/\(http:.*\/\/\)\(.*\)\(\.ucool\.com.*\)/\1betahero\3/g"

		

		echo "building release in linux , turn off COCOS2D_DEBUG "
		mysed_inplace  jni Application.mk 's/armeabi x86/armeabi/g' 
		mysed_inplace  jni Application.mk 's/\-DCOCOS2D_DEBUG=1//g'
		./build_native.sh NDK_DEBUG=0
		
		if [ $? -ne 0 ]; then
			echo "building so failed"
			cleanup $CUR_DIR
			exit 1
		fi
	fi
fi





if [ -d "$CUR_DIR"/assets ]; then
	echo "assets exists already by ndk build"
else
	echo "no assets folder, cp it from $CUR_DIR/../Resources "
	cp -r $CUR_DIR/../Resources assets
fi


#编译lua 
#加密和准备资源
#
cd  assets

#modify lua before build
if [ $buildtype = "release" -o $buildtype = "beta" ]; then
	mysed_inplace data  "configloaderAndroid.lua" "s/debug_mode[ ]*=[ ]*true/debug_mode = false/g" 
	cat  data/configloaderAndroid.lua 
fi



		
#
#先清理目标目录
# 
subdirs="0 1 2 3 4 5 6 7 8 9 a b c d e f"

for x in $subdirs
do
	rm -rf $deployPath/$x/*
done

echo "编译lua成为luac";

$compile_lua_script $luacbin
if [ $? -ne 0 ]; then
	echo "compile lua failed"
	cleanup $CUR_DIR
	exit 1
fi

#
#加密资源
#
echo "encrypt resource and cp to target path $deployPath"
ls .
find_res | grep -v "ios_icon"  | grep -v  "fonts" | grep -v "DS_Store" | grep -v "\.svn"  | sed 's/\.\///g'  >  $srcfilelist
#cat  $srcfilelist

$xencbin  $srcfilelist  $deployPath > $filelist
if [ $? -ne 0 ]; then
	echo "encypt resources failed"
	cleanup $CUR_DIR
	exit 1
fi




echo "remove source resouces "
ls .  | sed 's/deploy_res//g' | sed 's/fonts//g' |  xargs rm -rf 

echo "ddv number:"
find . -name "*.ddv" | wc -l 
echo "ddx number:"
find . -name "*.ddx" | wc -l
ls .


cd $CUR_DIR


#编译apk
#
if [ $buildtype = "alpha" ]; then
	setversion "hcalpha" "hc_alpha" $BUILD_SVN_REV
	if [ $? -ne 0 ]; then
		echo "set version failed"
		cleanup $CUR_DIR
		exit 1
	fi

	if [ $OSNAME = "Darwin" ]; then 
		packagename="com.ucool.hcalpha"	
		obbfilename="main.$obbversion.$packagename.obb"
		makeobbfile
	fi

	ant clean release -Dfile.encoding=UTF-8  -Dsdk.dir=$ANDROID_SDK_ROOT
	if [ $? -ne 0 ]; then
		echo "building apk failed"
		cleanup $CUR_DIR
		exit 1
	fi

	rm -rf src/com/ucool/hcalpha


elif [ $buildtype = "beta" ]; then
	echo "build android beta client"
	setversion "hcbeta" "Heroes Charge" $BUILD_SVN_REV
	if [ $? -ne 0 ]; then
		echo "set version failed"
		cleanup $CUR_DIR
		exit 1
	fi	
	
	echo "start building beta client"
	ant clean release  -Dfile.encoding=UTF-8  -Dsdk.dir=$ANDROID_SDK_ROOT
	if [ $? -ne 0 ]; then
		echo "building apk failed"
		cleanup $CUR_DIR
		exit 1
	fi	
	echo "end build beta client"


elif [ $buildtype = "release" ]; then

	packagename="com.ucool.hero"	
	obbfilename="main.$obbversion.$packagename.obb"
	echo "oobfilename: $obbfilename"
	makeobbfile

	
	echo "build android release client"
	setversion "hero" "Heroes Charge" $BUILD_SVN_REV
	if [ $? -ne 0 ]; then
		echo "set version failed"
		cleanup $CUR_DIR
		exit 1
	fi	
	
	echo "start building release client"
	ant clean release  -Dfile.encoding=UTF-8  -Dsdk.dir=$ANDROID_SDK_ROOT
	if [ $? -ne 0 ]; then
		echo "building apk failed"
		cleanup $CUR_DIR
		exit 1
	fi	
	echo "end build release client"
	
fi






#发布 apk
#
if [ $OSNAME = "Darwin" ]; then 
	#macos 是本地build的，不需要不发布
	echo "do not do deploy at MACOSX apk is: $apkname"
	echo ./deploy.sh  $apkname "hero.html" $dirbase "hero" $BUILD_SVN_REV $srcRoot
	cleanup $CUR_DIR
	exit 0

fi

./deploy.sh  $apkname "hero.html" $dirbase "hero" $BUILD_SVN_REV $srcRoot $obbfilename 
	
if [ $? -ne 0 ]; then
		echo "deploy failed"
		cleanup $CUR_DIR
		exit 1
fi




cd $CUR_DIR/assets

echo "同步资源到下载目录"
cp -r $CUR_DIR/backupres/* $CUR_DIR/assets/
rsync -vaz --progress  ./* $dirbase/


if [ $isSave = "false" ]; then

	echo "binary build only. "
	echo "result is at  $1/build/Release-iphoneos"
	exit 0;
fi



echo "记录发版信息到数据库"

if [ $binary_version != $last_binary_version -o $data_version != $last_data_version ]; then

		echo "记录当前发版信息到数据库"
		$make_patch_php $filelist $BUILD_SVN_REV $binary_version $buildtype $data_version		
		if [ $? -ne 0 ]; then	
				echo "$make_patch_php FAILED."
				cleanup $CUR_DIR
				exit 1
		fi

	#
	#提交version 文件
	#
	echo "提交版本文件"

	svn commit --no-auth-cache  --username=builder_commit --password=0wAeipx964Hv -m "Add bamboo building $verStr successuflly" $versionluaFile
	if [ $? -ne 0 ]; then	
		echo "SVN commit Failed."
		cleanup $CUR_DIR
		exit 1
	fi
fi







cleanup $CUR_DIR




