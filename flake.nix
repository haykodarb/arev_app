{
  description = "A basic flake with a shell";
  inputs.nixpkgs.url = "github:NixOS/nixpkgs/24.05";
  inputs.flake-utils.url = "github:numtide/flake-utils";
  inputs.flutter-old-nixpkgs.url = "github:NixOS/nixpkgs/a63a64b593dcf2fe05f7c5d666eb395950f36bc9";

  outputs = { self, nixpkgs, flake-utils, ... } @inputs:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = import nixpkgs {
          inherit system;
          config = {
            android_sdk.accept_license = true;
            allowUnfree = true;
          };
        };
        androidComposition = pkgs.androidenv.composeAndroidPackages
        {
          platformVersions = [ "29" "30" "31" "33" ];
          abiVersions = [ "armeabi-v7a" "arm64-v8a" "x86_64" ];
          buildToolsVersions = [ "29.0.2" "30.0.3" ];
          cmakeVersions = [ "3.18.1" "3.22.1" ]; 
          includeNDK = true;
          ndkVersions = [ "23.1.7779620" "26.1.10909125" ];
          includeSystemImages = false;
          includeEmulator = false;
          useGoogleAPIs = true;
        };
        androidSdk = androidComposition.androidsdk;
      in
      {
        devShells.default =
          with pkgs; mkShell {
            ANDROID_SDK_ROOT = "${androidSdk}/libexec/android-sdk";

            buildInputs = [
              bashInteractive
	      inputs.flutter-old-nixpkgs.legacyPackages.${system}.flutter37
	      glibc
              androidSdk
              google-chrome
              pkg-config
              gtk3
              jdk11
            ];
		
            shellHook = ''
		export CHROME_EXECUTABLE=$(which chromium); 
		export SHELL='/run/current-system/sw/bin/bash';
            '';
          };
      });
}
