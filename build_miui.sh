#!/bin/bash
cd ../..
export PATH=$PATH:/home/fyt/android-sdk-linux/tools:/home/fyt/android-sdk-linux/platform-tools
cd patchromV6
. build/envsetup.sh -p GN_fyt
cd GN
make clean
make myota BUILD_NUMBER=5.5.8


cp ota/last_target_files.zip out/


cd out
/home/fyt/patchromV6/tools/releasetools/ota_from_target_files -k ~/patchromV6/build/security/testkey -i last_target_files.zip target_files.zip miui-ota-GN-544-4.4.zip

