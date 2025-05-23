#!/bin/bash

# variable declarations
XCFRAMEWORK_PATH="tealium-xcframeworks"
ZIP_PATH="tealium.xcframework.zip"
CERTIFICATE="Apple Distribution: Tealium (XC939GDC9P)"

# zip all the xcframeworks
function zip_xcframeworks {
    if [[ -d "${XCFRAMEWORK_PATH}" ]]; then
        ditto -ck --rsrc --sequesterRsrc --keepParent "${XCFRAMEWORK_PATH}" "${ZIP_PATH}" 
        rm -rf "${XCFRAMEWORK_PATH}"
    fi
}

# do the work
surmagic xcf

# Code Sign
for frameworkname in "$XCFRAMEWORK_PATH"/*.xcframework; do
    echo "Codesigning $frameworkname"
    codesign --timestamp -s "$CERTIFICATE" "$frameworkname" --verbose
    codesign -v "$frameworkname" --verbose
done

zip_xcframeworks

echo ""
echo "Done! Upload ${ZIP_PATH} to GitHub when you create the release."