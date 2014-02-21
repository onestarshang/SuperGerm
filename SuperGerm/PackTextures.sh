#!/bin/sh

TP="/usr/local/bin/TexturePacker"
cd ${PROJECT_DIR}/${PROJECT}

if [ "${ACTION}" = "clean" ]; then
echo "cleaning..."

rm -f Resources/sprites*.pvr.ccz
rm -f Resources/sprites*.plist

rm -f Resources/background*.pvr.ccz
rm -f Resources/background*.plist

# ....
# add all files to be removed in clean phase
# ....
else
#ensure the file exists
if [ -f "${TP}" ]; then
echo "building..."
# create assets
${TP} --smart-update \
--format cocos2d \
--texture-format pvr2ccz \
--main-extension "-ipadhd" \
--autosd-variant 0.5:-hd \
--autosd-variant 0.25: \
--data Resources/sprites-ipadhd.plist \
--sheet Resources/sprites-ipadhd.pvr.ccz \
--dither-fs-alpha \
--opt RGBA4444 \
TextureFun_Art/sprites/*.png

${TP} --smart-update \
--format cocos2d \
--texture-format pvr2ccz \
--main-extension "-ipadhd" \
--autosd-variant 0.5:-hd \
--autosd-variant 0.25: \
--data background-ipadhd.plist \
--sheet background-ipadhd.pvr.ccz \
--dither-fs \
--opt RGB565 \
--border-padding 0 \
--width 2048 \
--height 2048 \
TextureFun_Art/background/*.png
# ....
# add other sheets to create here
# ....

exit 0
else
#if here the TexturePacker command line file could not be found
echo "TexturePacker tool not installed in ${TP}"
echo "skipping requested operation."
exit 1
fi

fi
exit 0
