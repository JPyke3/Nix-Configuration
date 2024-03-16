{pkgs, lib, inputs, ...}: {
  home.packages = [
    pkgs.swaynotificationcenter
    pkgs.swww
    pkgs.waybar
    pkgs.steam
    pkgs.armcord
    pkgs.runelite
    pkgs.obsidian
    inputs.llama-cpp.packages.x86_64-linux.rocm
  ];

  # Override for Obisidian, Electron 25 is EOL
  nixpkgs.config.permittedInsecurePackages = lib.optional (pkgs.obsidian.version == "1.4.16") "electron-25.9.0";

  imports = [
    ../home.nix
    ../../../programs/desktop/hyprland.nix
    ../../../programs/desktop/waybar/main.nix
  ];
}
