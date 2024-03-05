cd /d %~dp0
cd ..\..

cd build
IF %ERRORLEVEL% NEQ 0 exit /b %ERRORLEVEL%

call "C:\Program Files\Microsoft Visual Studio\2022\Community\VC\Auxiliary\Build\vcvars64.bat"

"C:\Program Files\CMake\bin\cmake.exe" --build . --config %1
