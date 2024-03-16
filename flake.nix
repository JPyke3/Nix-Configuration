{
  description = "Home Manager configuration of jacobpyke";

  inputs = {
    # Specify the source of Home Manager and Nixpkgs.
    nixpkgs.url = "github:nixos/nixpkgs/nixos-23.11";
    unstable.url = "github:nixos/nixpkgs/nixos-unstable";
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
    jovian = {
      url = "github:Jovian-Experiments/Jovian-NixOS";
      inputs.nixpkgs.follows = "unstable";
    };
  };

  outputs = {
    self,
    nixpkgs,
    unstable,
    home-manager,
    llama-cpp,
    jovian,
    ...
  } @ inputs: {
    # Desktop PC
    nixosConfigurations.jacob-singapore = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      specialArgs = {inherit inputs;};
      modules = [
        ./systems/nixos/configuration.nix
        ./systems/nixos/singapore/configuration.nix
        home-manager.nixosModules.home-manager
        {
          home-manager.users.jacobpyke = import ./systems/nixos/singapore/home.nix;
          home-manager.extraSpecialArgs = {
            inherit inputs;
            system = "x86_64-linux";
          };
        }
      ];
    };
    # Steam Deck
    nixosConfigurations.jacob-switzerland = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      specialArgs = {inherit inputs;};
      modules = [
        ./systems/nixos/configuration.nix
        ./systems/nixos/switzerland/configuration.nix
        home-manager.nixosModules.home-manager
        {
          home-manager.users.jacobpyke = import ./systems/nixos/switzerland/home.nix;
          home-manager.extraSpecialArgs = {
            inherit inputs;
            system = "x86_64-linux";
          };
        }
      ];
    };
    # Macbook Pro
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
