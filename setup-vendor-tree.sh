#!/bin/sh

set -e

platformDir="`readlink -e $PWD/../../..`"
vendorDir="$platformDir/vendor"

if [ "`basename "$platformDir"`" != "platform" ]; then
  echo "Couldn't find platform directory" >&2
  exit 1
fi

simg2img="$platformDir/out/host/linux-x86/bin/simg2img"

uri="http://developer.nvidia.com/sites/default/files/akamai/tools/files/Tegra/tegra-osinstaller-ventana-ics-1.0-linux-2012-01-19-11617556.run"
sha="73a99559e7cbdb781892bddd0cc15793483b193c"
installer="`basename "$uri"`"
force=0
gapps=0

while getopts "fgu:" opt; do
  case "$opt" in
  f) force=1;;
  g) gapps=1;;
  u) uri="$OPTARG";;
  esac
done

if [ -d "$vendorDir" -a $force -eq 0 ]; then
  echo "Vendor tree already exists" >&2
  exit 1
fi

if [ ! -e "$simg2img" ]; then
  echo "Couldn't find simg2img, build the platform then rerun this" >&2
  exit 1
fi

if [ ! -e "$installer" ]; then
  wget -O "$installer" "$uri"
fi

if [ "`sha1sum "$installer" | awk '{print $1}'`" != "$sha" ]; then
  echo "Installer checksum failed. Try redownloading." >&2
  exit 1
fi

tmpDir="`mktemp -d`"
sysDir="$tmpDir/system"
sysMnt="$tmpDir/sysmnt"
mkdir "$sysDir" "$sysMnt"

echo "Extracting Ventana Android image"
chmod +x "$installer"
HOME="$tmpDir" "./$installer" --mode unattended --needflash no --installdriver no --tryflashagain no --tryenableperfagain no

sysImg="$tmpDir/NVPACK/Android_OS_Images/Ventana/ics-rel-14r7-2012-01-18-11-46-30-11688736-ventana/system.img"

echo "Extracting system image"
owner="$USER"
sudo mount -o loop "$sysImg" "$sysMnt"
sudo cp -a "$sysMnt"/* "$sysDir"
sudo umount "$sysMnt"
sudo chown -R "$owner" "$sysDir"

echo "Setting up ASUS vendor"
rm -rf "$vendorDir/asus/tf101"
mkdir -p "$vendorDir/asus/tf101"
asusBoardConfig="$vendorDir/asus/tf101/BoardConfigVendor.mk"
asusDeviceMk="$vendorDir/asus/tf101/device-vendor.mk"
echo "# Auto-Generated" >"$asusBoardConfig"
echo "# Auto-Generated" >"$asusDeviceMk"

setupComponentVendor()
{
  vendor="$1"
  shift
  files=( $@ )

  echo "Setting up $vendor vendor"
  rm -rf "$vendorDir/$vendor/tf101"
  mkdir -p "$vendorDir/$vendor/tf101"
  boardConfig="$vendorDir/$vendor/tf101/BoardConfigVendor.mk"
  deviceMk="$vendorDir/$vendor/tf101/device-blobs.mk"
  echo "# Auto-Generated" >"$boardConfig"
  echo "# Auto-Generated" >"$deviceMk"
  echo "LOCAL_PATH := vendor/$vendor/tf101" >>"$deviceMk"
  echo "-include vendor/$vendor/tf101/BoardConfigVendor.mk" >>"$asusBoardConfig"
  echo "\$(call inherit-product-if-exists, vendor/$vendor/tf101/device-blobs.mk)" >>"$asusDeviceMk"

  for f in ${files[@]}; do
    destDir="$vendorDir/$vendor/tf101/proprietary/`dirname "$f"`"
    mkdir -p "$destDir"
    cp -v "$sysDir/$f" "$destDir"
    echo "PRODUCT_COPY_FILES += \$(LOCAL_PATH)/proprietary/${f}:system/${f}" >>"$deviceMk"
  done
}

nvidia_files=(
  "etc/firmware/nvmm_aacdec.axf"
  "etc/firmware/nvmm_adtsdec.axf"
  "etc/firmware/nvmm_h264dec.axf"
  "etc/firmware/nvmm_h264dec2x.axf"
  "etc/firmware/nvmm_jpegdec.axf"
  "etc/firmware/nvmm_jpegenc.axf"
  "etc/firmware/nvmm_manager.axf"
  "etc/firmware/nvmm_mp3dec.axf"
  "etc/firmware/nvmm_mpeg2dec.axf"
  "etc/firmware/nvmm_mpeg4dec.axf"
  "etc/firmware/nvmm_reference.axf"
  "etc/firmware/nvmm_service.axf"
  "etc/firmware/nvmm_sorensondec.axf"
  "etc/firmware/nvmm_vc1dec.axf"
  "etc/firmware/nvmm_vc1dec_2x.axf"
  "etc/firmware/nvmm_wavdec.axf"
  "etc/firmware/nvmm_wmadec.axf"
  "etc/firmware/nvmm_wmaprodec.axf"
  "etc/firmware/nvrm_avp.bin"

  "lib/hw/gralloc.tegra.so"
  "lib/hw/hwcomposer.tegra.so"

  "lib/egl/libEGL_tegra.so"
  "lib/egl/libGLESv1_CM_tegra.so"
  "lib/egl/libGLESv2_tegra.so"

  "lib/libardrv_dynamic.so"
  "lib/libcgdrv.so"
  "lib/libnvapputil.so"
  "lib/libnvasfparserhal.so"
  "lib/libnvaviparserhal.so"
  "lib/libnvavp.so"
  "lib/libnvcpud.so"
  "lib/libnvcpud_client.so"
  "lib/libnvddk_2d.so"
  "lib/libnvddk_2d_v2.so"
  "lib/libnvdispmgr_d.so"

  "lib/libnvmm.so"
  "lib/libnvmm_asfparser.so"
  "lib/libnvmm_audio.so"
  "lib/libnvmm_aviparser.so"
  "lib/libnvmm_camera.so"
  "lib/libnvmm_contentpipe.so"
  "lib/libnvmm_image.so"
  "lib/libnvmm_manager.so"
  "lib/libnvmm_misc.so"
  "lib/libnvmm_msaudio.so"
  "lib/libnvmm_parser.so"
  "lib/libnvmm_service.so"
  "lib/libnvmm_utils.so"
  "lib/libnvmm_vc1_video.so"
  "lib/libnvmm_video.so"
  "lib/libnvmm_vp6_video.so"
  "lib/libnvmm_writer.so"

  "lib/libnvmmlite.so"
  "lib/libnvmmlite_audio.so"
  "lib/libnvmmlite_image.so"
  "lib/libnvmmlite_msaudio.so"
  "lib/libnvmmlite_utils.so"
  "lib/libnvmmlite_video.so"

  "lib/libnvodm_dtvtuner.so"
  "lib/libnvodm_hdmi.so"
  "lib/libnvodm_imager.so"
  "lib/libnvodm_misc.so"
  "lib/libnvodm_query.so"

  "lib/libnvomx.so"
  "lib/libnvomxadaptor.so"
  "lib/libnvomxilclient.so"

  "lib/libnvos.so"
  "lib/libnvparser.so"

  "lib/libnvrm.so"
  "lib/libnvrm_graphics.so"

  "lib/libnvsm.so"
  "lib/libnvtestio.so"
  "lib/libnvtestresults.so"
  "lib/libnvtvmr.so"
  "lib/libnvwinsys.so"
  "lib/libnvwsi.so"
  "lib/libstagefrighthw.so"
)

broadcom_files=(
  "etc/firmware/bcm4329.hcd"
)

setupComponentVendor "nvidia" ${nvidia_files[@]}
setupComponentVendor "broadcom" ${broadcom_files[@]}

if [ $gapps -eq 1 ]; then
  rm -rf "$tmpDir/"/*

  gUri="http://goo-inside.me/gapps/gapps-ics-20120207-signed.zip"
  gZip="`basename "$gUri"`"

  if [ ! -e "$gZip" ]; then
    wget -O "$gZip" "$gUri"
  fi

  unzip "$gZip" -d "$tmpDir"
  pushd "$tmpDir"
  cp -av optional/face/* system/
  popd

  mkdir -p "$vendorDir/google/proprietary"
  cp -av "$tmpDir/system"/* "$vendorDir/google/proprietary/"

  gBlobs="$vendorDir/google/device-blobs.mk"
  gMk="$vendorDir/google/proprietary/Android.mk"
  echo "# Auto-Generated" >"$gBlobs"
  echo "LOCAL_PATH := vendor/google" >>"$gBlobs"
  echo "TF101_HAVE_GAPPS := true" >>"$gBlobs"
  echo "# Auto-Generated" >"$gMk"
  echo "LOCAL_PATH := \$(call my-dir)" >>"$gMk"
  pushd "$vendorDir/google/proprietary/"
  find -mindepth 1 ! -type d | while read f; do
    fname="`echo $f | sed 's/\.\///'`"
    ext="${fname##*.}"

    if [ "$fname" = "Android.mk" ]; then
      # Skip the makefile being generated
      continue
    fi

    if [ "$ext" = "apk" ]; then
      # This relies upon packages/* being included before vendor/*
      # It's a little horrid...

      echo "include \$(CLEAR_VARS)" >>"$gMk"
      echo "LOCAL_MODULE := Google`basename "$fname" .apk`" >>"$gMk"
      echo "LOCAL_MODULE_STEM := `basename "$fname" .apk`" >>"$gMk"
      echo "LOCAL_MODULE_CLASS := APPS" >>"$gMk"
      echo "LOCAL_MODULE_TAGS := optional" >>"$gMk"
      echo "LOCAL_MODULE_SUFFIX := \$(COMMON_ANDROID_PACKAGE_SUFFIX)" >>"$gMk"
      echo "LOCAL_SRC_FILES := $fname" >>"$gMk"
      echo "LOCAL_CERTIFICATE := PRESIGNED" >>"$gMk"
      echo "include \$(BUILD_PREBUILT)" >>"$gMk"
      echo "PRODUCT_PACKAGES += Google`basename "$fname" .apk`" >>"$gBlobs"
    else
      echo "PRODUCT_COPY_FILES += \$(LOCAL_PATH)/proprietary/${fname}:system/${fname}" >>"$gBlobs"
    fi
  done
  popd

  echo "\$(call inherit-product-if-exists, vendor/google/device-blobs.mk)" >>"$asusDeviceMk"
fi

rm -rf "$tmpDir"
