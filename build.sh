#!/bin/bash
# This script is modified from https://github.com/ivan-hc/Chrome-appimage/raw/fe079615eb4a4960af6440fc5961a66c953b0e2d/chrome-builder.sh


APP=clash-verge
VER="${VERSION:-v1.6.6}"
mkdir ./tmp
cd ./tmp
wget "https://github.com/AppImage/AppImageKit/releases/download/continuous/appimagetool-$(uname -m).AppImage" -O appimagetool
chmod a+x ./appimagetool
wget "https://github.com/clash-verge-rev/clash-verge-rev/releases/download/${VER}/clash-verge_${VER#v}_amd64.deb"
ar x ./*.deb
tar xf ./data.tar.*
mv usr $APP.AppDir
cp $APP.AppDir/share/applications/$APP.desktop $APP.AppDir
cp $APP.AppDir/share/icons/hicolor/128x128/apps/$APP.png $APP.AppDir

cat >> ./$APP.AppDir/AppRun << 'EOF'
#!/bin/sh
APP=clash-verge
HERE="$(dirname "$(readlink -f "${0}")")"
exec "${HERE}"/bin/clash-verge
EOF
chmod a+x ./$APP.AppDir/AppRun

echo "Create a tarball"
cd ./$APP.AppDir
tar cJvf ../$APP-$VER-x86_64.tar.xz .
cd ..
mv ./$APP-$VER-x86_64.tar.xz ..

# echo "Create an AppImage"
ARCH=x86_64 ./appimagetool -n --verbose ./$APP.AppDir ../$APP-$VER-x86_64.AppImage
cd ..
rm -rf ./tmp
