
<h1><img src=https://images.weserv.nl/?url=https://github.com/rwf93/starbound/blob/master/logo.png?raw=true?v=4&h=24&w=24&fit=cover&mask=circle&maxage=7d>Starbound</h1>

A somewhat comprehensive guide on how to build the game from source.  
This might contain modifications to the source code that make it not interoperable with the base game.

## Build Instructions:
### Windows x86_64
Install [Visual Studio 2023](https://c2rsetup.officeapps.live.com/c2r/downloadVS.aspx?sku=community&channel=Release&version=VS2022&source=VSLandingPage&add=Microsoft.VisualStudio.Workload.ManagedDesktop&add=Microsoft.VisualStudio.Workload.Azure&add=Microsoft.VisualStudio.Workload.NetWeb&includeRecommended=true&cid=2030)  
Install [CMake](https://github.com/Kitware/CMake/releases/download/v3.27.0-rc2/cmake-3.27.0-rc2-windows-x86_64.msi)  
Optionally, Install [QT 5.6.0](https://download.qt.io/new_archive/qt/5.6/5.6.0/qt-opensource-windows-x86-msvc2015_64-5.6.0.exe)  
Optionally, Install [Ninja](https://github.com/ninja-build/ninja/releases) if using Visual Studio Code (pip can be used to install it as well)

### Visual Studio
Work in progress...

### Visual Studio Code (ONLY x64 SUPPORT)
Open a terminal
Setup your build : ./scripts/windows/setup_ninja.bat or ./scripts/windows/setup.bat
Build : ./scripts/windows/build.bat
Compile your game to share : ./scripts/windows/compile_game.bat

Run : starbound.exe

### MACOS x86_64 (Intel/Universel) / MACOS arm64 (SILICON M1/M2/M3)
Build : ./scripts/osx/setup-and-build.sh build
Zip : ./scripts/osx/setup-and-build.sh zip (to share your app) !! warning !! You need to sign-it with codesign

Run : ./dist/starbound or click on the Starbound.app in the dist folder.

### Linux (x64 and ARM)
Work in progress...

### Discord
yuhuns

### Credits for the base source code
Thanks to [rwf93](https://github.com/rwf93/Starbound)