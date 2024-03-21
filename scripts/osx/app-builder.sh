#!/bin/sh

# This script is used to build the Starbound.app bundle for OSX.
# It should be run from the root of the Starbound source tree.

# The script will build the game and then create a .app bundle in the dist/ directory.

if [[ "$1" == "build-app" ]]; then
	echo "== Building Starbound.app bundle for OSX =="
	if [[ $(pwd) != *"/scripts/osx" ]]; then
		echo "This script should be run from the scripts/osx directory."
		cd "$(dirname "$0")"
	fi
	echo "Changed directory to: $(pwd)"
	if [[ $(pwd) != *"/scripts/osx" ]]; then
		echo "Failed to change directory."
		exit 1
	fi

	# The script will also copy the required Steam and Discord libraries into the .app bundle.

	if [[ -d "../../dist/starbound.app" ]]; then
		echo "Removing old Starbound.app bundle..."
		rm -rf ../../dist/Starbound.app
	fi
	echo "Building Starbound..."
	cp -r Starbound.app ../../dist/Starbound.app
	echo "Copying Starbound.app..."
	cp -r sbinit.config ../../dist/sbinit.config
	echo "Copying sbinit.config..."

	# Copy the required Steam and Discord libraries into the .app bundle.
	if [[ -f "../../dist/Starbound.app/Contents/MacOS/deleteme" ]]; then
		rm -rf ../../dist/Starbound.app/Contents/MacOS/deleteme
	else
		echo - Failed to get the MacOS folder
		exit 1
	fi

	cp -r ../../lib/osx/libsteam_api.dylib ../../dist/Starbound.app/Contents/MacOS/libsteam_api.dylib
	cp -r ../../lib/osx/libsteam_api.dylib ../../dist/libsteam_api.dylib
	if [[ $(uname -m) = "x86_64" ]]; then
		echo "Copying x64 libdiscord_game_sdk.dylib"
		cp -r ../../lib/osx/x64/libdiscord_game_sdk.dylib ../../dist/Starbound.app/Contents/MacOS/libdiscord_game_sdk.dylib
		cp -r ../../lib/osx/x64/libdiscord_game_sdk.dylib ../../dist/libdiscord_game_sdk.dylib
	else
		echo "Copying arm64 libdiscord_game_sdk.dylib"
		cp -r ../../lib/osx/arm64/libdiscord_game_sdk.dylib ../../dist/Starbound.app/Contents/MacOS/libdiscord_game_sdk.dylib
		cp -r ../../lib/osx/arm64/libdiscord_game_sdk.dylib ../../dist/libdiscord_game_sdk.dylib
	fi

	# Copy the game executable into the .app bundle.

	cd ../../dist
	cp starbound Starbound.app/Contents/MacOS/starbound

	if [[ -d "Starbound.app" ]]; then
	echo "Starbound.app bundle created successfully."
	exit 0
	else
	echo "Starbound.app bundle creation failed."
	exit 1
	fi
fi

# If the script is run without the "build" argument, it will just build the game.
if [[ "$1" == "sign" ]]; then
	if [[ $(pwd) != *"/dist" ]]; then
		echo "This script should be run from the dist directory."
		cd "`dirname \"$0\"`/../../dist"
		if [[ $(pwd) != *"/dist" ]]; then
			echo "Failed to change directory."
			exit 1
		fi
	fi
	if [[ -d "Starbound.app" ]]; then
		echo "Signing Starbound.app bundle..."
		codesign --force --deep --sign - Starbound.app
		if [[ $? -eq 0 ]]; then
			echo "Starbound.app bundle signed successfully."
			exit 0
		else
			echo "Starbound.app bundle signing failed."
			exit 1
		fi
	else
		echo "Starbound.app bundle not found."
		exit 1
	fi
fi

if [[ "$1" == "all" ]]; then
	if [[ $(pwd) != *"/scripts/osx" ]]; then
		echo "This script should be run from the scripts/osx directory."
		cd "$(dirname "$0")"
		if [[ $(pwd) != *"/scripts/osx" ]]; then
			echo "Failed to change directory."
			exit 1
		fi
	fi
	./app-builder.sh cmake macos-arm-release
	./app-builder.sh build-app
	./app-builder.sh sign
	if [[ $? -eq 0 ]]; then
		exit 0
	fi
	exit 1
fi

if [[ "$1" == "cmake" ]]; then
	echo "== Running CMake presets for OSX =="
	if [[ $(pwd) != *"/source" ]]; then
		echo "This script should be run from the source directory."
		cd "`dirname \"$0\"`/../../source"
		if [[ $(pwd) != *"/source" ]]; then
			echo "Failed to change directory."
			exit 1
		fi
	fi
	if [[ "$2" == "" ]]; then
		echo "Please specify a CMake preset."
		echo "Usage: ./app-builder.sh cmake [preset]"
		cmake --list-presets
		exit 1
	fi
	cmake --preset $2
	if [[ $? -eq 0 ]]; then
		echo "CMake preset $2 ran successfully."
		cd ../build/$2
		pwd
		if [[ $(pwd) == *"/build/$2" ]]; then
			cmake --build .
			if [[ $? -eq 0 ]]; then
				echo "Build $2 successful."
				exit 0
			else
				echo "Build $2 failed."
				exit 1
			fi
		else
			echo "Build directory not found."
			exit 1
		fi
		
	else
		echo "CMake preset $2 failed."
		exit 1
	fi
fi


echo "Usage: ./app-builder.sh [build-app|sign|cmake|all]"




