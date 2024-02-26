{ pkgs, ...  }:
pkgs.stdenv.mkDerivation {
  name = "AeroSpace";
  src = pkgs.fetchzip {
	url = "https://github.com/nikitabobko/AeroSpace/releases/download/v0.8.7-Beta/AeroSpace-v0.8.7-Beta.zip";
	sha256 = "sha256-x/1M1vDUd68Qykv0YIJvn4S/+Bu73jMsFyj3gwTCwjo=";
  };

  nativeBuildInputs = [ pkgs.darwin.signingUtils ];

  installPhase = ''
	mkdir -p $out/Applications
	cp -r AeroSpace.app $out/Applications

    codesign --force -s - ./bin/aerospace
    codesign --force -s - $out/Applications/AeroSpace.app
	'';

  dontFixup = true;

  meta = with pkgs.lib; {
	homepage = "https://github.com/nikitabobko/AeroSpace";
	description = "AeroSpace is an i3-like tiling window manager for macOS";
	platforms = platforms.darwin;
  };
}
