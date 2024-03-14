{ pkgs, ... }:
{
	programs.lf = {
		enable = true;
		previewer = {
			source = pkgs.writeShellScriptBin "pv.sh" ''
					#!/usr/bin/env bash
					case "$1" in
						*.tar*) tar tf "$1" ;;
						*.zip) ${pkgs.unzip}/bin/unzip -l "$1" ;;
						*.rar) ${pkgs.unrar}/bin/unrar l "$1" ;;
						*.7z) ${pkgs.p7zip}/bin/7z l "$1" ;;
						*.pdf) ${pkgs.mupdf}/bin/mupdf-gl "$1" ;;
						*.jpg|*.jpeg|*.png|*.gif|*.bmp|*.tiff|*.webp) kitten icat "${1}" ;;
					esac
				'';
		};
	};
}
