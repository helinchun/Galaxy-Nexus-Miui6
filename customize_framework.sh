#!/bin/bash
# $1: dir for miui
# $2: dir for original

APKTOOL="$PORT_ROOT/tools/apktool --quiet"
GIT_APPLY=$PORT_ROOT/tools/git.apply
BUILD_OUT=out

SEP_FRAME="framework2.jar.out"

function appendSmaliPart() {
    cd overlay
    for file in `find $1/smali -name *.part`
    do
        filepath=`dirname $file`
        filename=`basename $file .part`
        dstfile="out/$filepath/$filename"
        cat $file >> $dstfile
    done
}

function overlaySmali() {
    for file in `find $1/smali -name *.smali`
    do
        filepath=`dirname $file`
        cp -f $file out/$filepath
    done
}

function applyPatch() {
	for file in $1/*.patch
	do
		cp $file out/
		cd out
		git.apply `basename $file`
        for file2 in `find $2 -name *.rej`
        do
            echo "$file2 fail"
            exit 1
        done
		cd ..
	done
}

if [ $2 = "$BUILD_OUT/framework" ]
then
    # remove all files at out/framework those exist in framework2.jar.out
    for file2 in `find framework2.jar.out -name *.smali`; do
            file=${file2/framework2.jar.out/$BUILD_OUT\/framework}
            echo "rm file: $file"
            rm -rf "$file"
    done

    # remove all files at out/framework those exist in telephony-common.jar.out
    for file2 in `find telephony-common.jar.out -name *.smali`; do
            file=${file2/telephony-common.jar.out/$BUILD_OUT\/framework}
            echo "rm file: $file"
            rm -rf "$file"
    done
    # move some smali to create a separate $SEP_FRAME.jar
    # including: smali/miui smali/android/widget
	mkdir -p "$BUILD_OUT/$SEP_FRAME/smali/android"
	rm -rf $BUILD_OUT/$SEP_FRAME/smali/android/widget
	#overlay
    cp -rf ../android/Editor/* $BUILD_OUT/framework/smali/android/widget/
	#mv "$BUILD_OUT/framework/smali/miui" "$BUILD_OUT/$SEP_FRAME/smali"
	#replace mms
#	rm -rf "$BUILD_OUT/framework/smali/com/google/android/mms"

fi

if [ $2 = "$BUILD_OUT/framework2" ]
then
    # remove all files at out/framework1 those exist in framework.jar.out
    for file2 in `find framework.jar.out -name *.smali`; do
            file=${file2/framework.jar.out/$BUILD_OUT\/framework2}
            echo "rm file: $file"
            rm -rf "$file"
    done
    # remove all files at out/framework_ext those exist in telephony-common.jar.out
    for file2 in `find telephony-common.jar.out -name *.smali`; do
            file=${file2/telephony-common.jar.out/$BUILD_OUT\/framework2}
            echo "rm file: $file"
            rm -rf "$file"
    done


	# mv "$BUILD_OUT/$SEP_FRAME/smali/miui/"  "$BUILD_OUT/framework_ext/smali/miui"
	#replace mms
#	cp -rf "$BUILD_OUT/framework_miui/smali/com/google/android/mms" "$BUILD_OUT/framework2/smali/com/google/android"

    #cp framework_ext/dataapk.part $BUILD_OUT
    #cd $BUILD_OUT
    #$GIT_APPLY dataapk.part
    #cd ..
    #for file in `find $2 -name *.rej`
    #do
	#echo "Fatal error: Settings patch fail"
    #    exit 1
    #fix wrong ids
fi

if [ $2 = "$BUILD_OUT/telephony-common" ]
then
#	for file in `find $2 -name IccCard*`; do
#		sed -i "s/com\/android\/internal\/telephony\/IccCardConstants\$State;/com\/android\/internal\/telephony\/IccCard\$State;/g" $file
#	done
	
for file2 in `find framework -name *.smali`; do
            file=${file2/framework/$BUILD_OUT\/telephony-common}
            echo "rm file: $file"
            rm -rf "$file"
    done	
fi

