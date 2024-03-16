{
pkgs,
...
}: {
  home.packages = [
	pkgs.steam
	pkgs.armcord
	pkgs.runelite
  ];

  imports = [
	../home.nix
  ];
}
