#
# Makefile for GN
#

# The original zip file, MUST be specified by each product
local-zip-file     := stockrom.zip

# The output zip file of MIUI rom, the default is porting_miui.zip if not specified
local-out-zip-file := MIUI_maguro.zip

# the location for local-ota to save target-file
local-previous-target-dir := ~/workspace/ota_base/maguro_4.4

# All apps from original ZIP, but has smali files chanded
#local-modified-apps := Camera2 Gallery2
local-modified-apps :=

local-modified-priv-apps :=

local-modified-jars :=

# All apks from MIUI
local-density := XHDPI

local-miui-removed-apps := 

local-miui-removed-priv-apps := 

local-miui-modified-apps := MiuiFramework MiuiHome MiuiSystemUI TeleService SecurityCenter DeskClock Music

local-miui-modified-apps := MiuiFramework MiuiHome MiuiSystemUI TeleService SecurityCenter DeskClock Music 

include phoneapps.mk

# To include the local targets before and after zip the final ZIP file, 
# and the local-targets should:
# (1) be defined after including porting.mk if using any global variable(see porting.mk)
# (2) the name should be leaded with local- to prevent any conflict with global targets
local-pre-zip := local-pre-zip-misc
local-after-zip:= local-put-to-phone

# The local targets after the zip file is generated, could include 'zip2sd' to 
# deliver the zip file to phone, or to customize other actions

include $(PORT_BUILD)/porting.mk

# Target to test if full ota package will be generate
myota: target_files
	@echo ">>> To build out target file: myota.zip ..."
	$(BUILD_TARGET_FILES) $(INCLUDE_THIRDPART_APP) Miui_maguro_$(BUILD_NUMBER)_024e8529e9_4.4.zip
	@echo "<<< build target file completed!"

# To define any local-target
#updater := $(ZIP_DIR)/META-INF/com/google/android/updater-script
#pre_install_data_packages := $(TMP_DIR)/pre_install_apk_pkgname.txt
local-pre-zip-misc:
	cp other/build.prop $(ZIP_DIR)/system/build.prop
	
	cp other/boot.img $(ZIP_DIR)/boot.img

	cp -rf other/system $(ZIP_DIR)/

	rm -rf $(ZIP_DIR)/system/addon.d
	rm -rf $(ZIP_DIR)/system/bin/*_test
	rm -rf $(ZIP_DIR)/system/lib/libjni_latinime.so
	rm -rf $(pre_install_data_packages)
