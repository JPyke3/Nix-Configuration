{
  description = "Home Manager configuration of jacobpyke";

  inputs = {
    # Specify the source of Home Manager and Nixpkgs.
    nixpkgs.url = "github:nixos/nixpkgs/nixos-23.11";
	nixpkgs_unstable.url = "github:nixos/nixpkgs/nixos-unstable";
    nur.url = "github:nix-community/nur";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nix-colors.url = "github:misterio77/nix-colors";
  };

  outputs = {
    nixpkgs,
	nixpkgs_unstable,
    home-manager,
	system,
    ...
  } @ inputs:
let
	inherit system;

in
  {
    homeConfigurations."jacobpyke" = home-manager.lib.homeManagerConfiguration {
      pkgs = nixpkgs.legacyPackages.x86_64-linux;
      extraSpecialArgs = {inherit inputs system;};

      modules = [
        ./linux-home.nix
        ./common-home.nix
      ];
    };
    homeConfigurations."jacobpyke-macos" = home-manager.lib.homeManagerConfiguration {
      pkgs = nixpkgs.legacyPackages.aarch64-darwin;
      extraSpecialArgs = {inherit inputs;};

      modules = [
        ./macos-home.nix
        ./common-home.nix
      ];
    };
  };
}
