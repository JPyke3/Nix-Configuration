{
  description = "Home Manager configuration of jacobpyke";

  inputs = {
    # Specify the source of Home Manager and Nixpkgs.
    nixpkgs.url = "github:nixos/nixpkgs/nixos-23.11";
    nixpkgs_unstable.url = "github:nixos/nixpkgs/nixos-unstable";
    nur.url = "github:nix-community/nur";
    home-manager = {
      url = "github:nix-community/home-manager/release-23.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nix-colors.url = "github:misterio77/nix-colors";
    nixpkgs-firefox-darwin.url = "github:bandithedoge/nixpkgs-firefox-darwin";
    llama-cpp = {
      url = "github:ggerganov/llama.cpp";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    sops-nix = {
      url = "github:Mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = {
    nixpkgs,
    nixpkgs_unstable,
    home-manager,
    llama-cpp,
    ...
  } @ inputs: let
  in {
  	nixosConfigurations.jacob-singapore = nixpkgs.lib.nixosSystem {
	  system = "x86_64-linux";
	  pkgs = nixpkgs;
	  specialArgs = { inherit inputs; };
	  modules = [
	  	./systems/nixos/singapore/configuration.nix
		home-manager.nixosModule.home-manager
		{
			home-manager.useGlobalPkgs = true;
			home-manager.users.jacobpyke = ./systems/nixos/home.nix;
		}
	  ];
	};
    homeConfigurations."jacobpyke-macos" = home-manager.lib.homeManagerConfiguration {
      pkgs = nixpkgs.legacyPackages.aarch64-darwin;
      extraSpecialArgs = {
        inherit inputs;
        system = "aarch64-darwin";
      };

      modules = [
        ./systems/darwin/home.nix
        ./users/jacob/common-home.nix
      ];
    };
  };
}
