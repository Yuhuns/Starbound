@echo off

cd /d %~dp0
cd ..\..

set dist_folder=dist
set PATH=%PATH%;C:\Program Files\7-Zip

mkdir mods
mkdir storage
mkdir win64

xcopy dist\*.dll win64 /s /y
xcopy dist\*.exe win64 /s /y
xcopy dist\*.pdb win64 /s /y
copy dist\sbinit.config win64\sbinit.config

7z a -r -tzip game_windows_x86_64.zip assets mods storage win64

rmdir /s /q storage
rmdir /s /q mods
rmdir /s /q win64

echo Done