#!/bin/bash
#
# $1: dir for original miui app 
# $2: dir for target miui app
#

XMLMERGYTOOL=$PORT_ROOT/tools/ResValuesModify/jar/ResValuesModify
pl=$PORT_ROOT/miuipolska/Polish/main
GIT_APPLY=$PORT_ROOT/tools/git.apply
MIUISRCDIR=$PORT_ROOT/miui/src

curdir=`pwd`

function adjustDpi() {
    hdpi=( $(ls out/$1/res/drawable-hdpi) )

    for PNG in "${hdpi[@]}"; do
        rm -f out/$1/res/drawable-xhdpi/$PNG
        rm -f out/$1/res/drawable-xxhdpi/$PNG
    done
#    rm out/$1/res/mipmap-mdpi
#    rm out/$1/res/mipmap-hdpi
#    rm out/$1/res/mipmap-xxhdpi
}

function addPolish() {
    for file in `find $pl -name $1.apk`
    do
	cp -u -r $file/* out/$1
	find out/$1/res -name "drawable-pl-xhdpi" | xargs rm -rf
	find out/$1/res -name "drawable-pl-xxhdpi" | xargs rm -rf
    done
}


if [ $1 = "Settings" ];then
	applyPatch $1 $2
	mergyXmlPart $1 $2
	
    cp $1/*.part out/
    cd out
    $GIT_APPLY Settings.part
    $GIT_APPLY fuzhuFC.part
    cd ..
    for file in `find $2 -name *.rej`
    do
	echo "Fatal error: Settings patch fail"
        exit 1
    done
    cp $1/*.part out/
    cd out
    $GIT_APPLY art.part
    cd ..
    for file in `find $2 -name *.rej`
    do
	echo "Fatal error: art patch fail"
        exit 1
    done

	$XMLMERGYTOOL $1/res/values $2/res/values
	$XMLMERGYTOOL $1/res/values-zh-rCN $2/res/values-zh-rCN
fi

if [ $1 = "Mms" ];then
	$XMLMERGYTOOL $1/res/values $2/res/values
fi

if [ $1 = "TeleService" ];then
    cp $1/*.patch out/
    cd out
    $GIT_APPLY LTE.patch
    $GIT_APPLY fixyuyinbohao.patch
    cd ..
    for file in `find $2 -name *.rej`
    do
	echo "Fatal error: LTE phone mingz patch fail"
        exit 1
    done
	$XMLMERGYTOOL $1/res/values $2/res/values
fi

if [ $1 = "ThemeManager" ];then
    $XMLMERGYTOOL $1/res/values $2/res/values
fi


if [ $1 = "MiuiSystemUI" ];then
    cp $1/*.patch out/
    cd out
    $GIT_APPLY addMenuKey.patch
    $GIT_APPLY nav_transf.patch
    cd ..
    for file in `find $2 -name *.rej`
    do
	echo "Fatal error: MiuiSystemUI patch fail"
        exit 1
    done

fi

if [ $1 = "MiuiHome" ];then
    cp $1/*.part out/
    cd out
    $GIT_APPLY MiuiHome.part
    cd ..
    for file in `find $2 -name *.rej`
    do
	echo "Fatal error: MiuiHome patch fail"
        exit 1
    done

	$XMLMERGYTOOL $1/res/values $2/res/values
fi

if [ $1 = "MiuiFramework" ];then
    cp $1/maguro.xml $2/assets/device_features/
fi

if [ $1 = "SecurityCenter" ];then
    cp $1/*.patch out/
    cd out
    $GIT_APPLY root_5s.patch
    cd ..
    for file in `find $2 -name *.rej`
    do
	echo "Fatal error: root_5s patch fail"
        exit 1
    done
fi
if [ $1 = "DeskClock" ];then
   cp $1/*.patch out/
    cd out
    $GIT_APPLY 1.patch
    cd ..
    for file in `find $2 -name *.rej`
    do
	echo "Fatal error: root_5s patch fail"
        exit 1
    done
fi
