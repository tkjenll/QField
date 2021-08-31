#!/bin/bash

BASEPATH=$1

wget https://github.com/AppImage/AppImageKit/releases/download/continuous/appimagetool-x86_64.AppImage
wget https://github.com/linuxdeploy/linuxdeploy/releases/download/continuous/linuxdeploy-x86_64.AppImage
wget https://github.com/linuxdeploy/linuxdeploy-plugin-qt/releases/download/continuous/linuxdeploy-plugin-qt-x86_64.AppImage
chmod +x appimagetool-x86_64.AppImage
chmod +x linuxdeploy-x86_64.AppImage
chmod +x linuxdeploy-plugin-qt-x86_64.AppImage

cp linux/qfield.desktop $BASEPATH/

ln -s bin/qfield $BASEPATH/AppRun
./linuxdeploy-x86_64.AppImage --appdir $BASEDIR --plugin qt
ARCH=x86_64 ./appimagetool-x86_64.AppImage $BASEPATH
