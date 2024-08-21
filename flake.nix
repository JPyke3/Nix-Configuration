{
  description = "Home Manager configuration of jacobpyke";

  nixConfig = {
    extra-substituters = [
      "https://jpyke3.cachix.org"
    ];
    extra-trusted-public-keys = [
      "jpyke3.cachix.org-1:SkUkQoQ6WbhSs7SGsMZ22H/DyJ7VNpT4/BaEvTCEQZY="
    ];
  };

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-24.05";
    unstable.url = "github:nixos/nixpkgs/nixos-unstable";
    nixpkgs-darwin.url = "github:nixos/nixpkgs/nixpkgs-24.05-darwin";
    nur = {
      url = "github:nix-community/nur";
    };
    home-manager = {
      url = "github:nix-community/home-manager/release-24.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    home-manager-unstable = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "unstable";
    };
    nix-darwin = {
      url = "github:LnL7/nix-darwin";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nix-colors = {
      url = "github:misterio77/nix-colors";
    };
    nixpkgs-firefox-darwin = {
      url = "github:bandithedoge/nixpkgs-firefox-darwin";
    };
    llama-cpp = {
      url = "github:ggerganov/llama.cpp";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    sops-nix = {
      url = "github:Mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    jovian = {
      url = "github:Jovian-Experiments/Jovian-NixOS/c8af9ea43d928f1e1f2c0ac100e75519ea76565d";
      inputs.nixpkgs.follows = "unstable";
    };
    kmonad = {
      url = "git+https://github.com/kmonad/kmonad?submodules=1&dir=nix";
    };
    base16 = {
      url = "github:SenchoPens/base16.nix";
    };
    stylix = {
      url = "github:danth/stylix/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    spicetify-nix = {
      url = "github:Gerg-L/spicetify-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    vpnconfinement = {
      url = "github:Maroka-chan/VPN-Confinement";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    flake-utils = {url = "github:numtide/flake-utils";};
    linger = {
      url = "github:mindsbackyard/linger-flake";
      inputs.flake-utils.follows = "flake-utils";
    };
    pihole = {
      url = "github:mindsbackyard/pihole-flake";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.flake-utils.follows = "flake-utils";
      inputs.linger.follows = "linger";
    };
  };

  outputs = {
    self,
    nixpkgs,
    unstable,
    home-manager,
    home-manager-unstable,
    llama-cpp,
    jovian,
    nix-darwin,
    nixpkgs-darwin,
    nur,
    kmonad,
    stylix,
    spicetify-nix,
    vpnconfinement,
    linger,
    pihole,
    ...
  } @ inputs: {
    # Desktop PC
    nixosConfigurations.jacob-singapore = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      specialArgs = {inherit inputs;};
      modules = [
        nur.nixosModules.nur
        ./systems/nixos/configuration.nix
        ./systems/nixos/singapore/configuration.nix
        stylix.nixosModules.stylix
        ./systems/stylix.nix
        home-manager.nixosModules.home-manager
        {
          home-manager.users.jacobpyke = import ./systems/nixos/singapore/home.nix;
          home-manager.backupFileExtension = "backup";
          home-manager.extraSpecialArgs = {
            inherit inputs;
            system = "x86_64-linux";
          };
        }
      ];
    };
    # Steam Deck LCD
    nixosConfigurations.jacob-switzerland = unstable.lib.nixosSystem {
      system = "x86_64-linux";
      specialArgs = {inherit inputs;};
      modules = [
        nur.nixosModules.nur
        ./systems/nixos/configuration.nix
        ./systems/nixos/switzerland/configuration.nix
        home-manager-unstable.nixosModules.home-manager
        {
          home-manager.users.jacobpyke = import ./systems/nixos/switzerland/home.nix;
          home-manager.extraSpecialArgs = {
            inherit inputs;
            system = "x86_64-linux";
          };
        }
      ];
    };
    # Steam Deck OLED
    nixosConfigurations.jacob-japan = unstable.lib.nixosSystem {
      system = "x86_64-linux";
      specialArgs = {inherit inputs;};
      modules = [
        nur.nixosModules.nur
        ./systems/nixos/configuration.nix
        ./systems/nixos/japan/configuration.nix
        home-manager-unstable.nixosModules.home-manager
        {
          home-manager.users.jacobpyke = import ./systems/nixos/japan/home.nix;
          home-manager.extraSpecialArgs = {
            inherit inputs;
            system = "x86_64-linux";
          };
        }
      ];
    };
    # Home Server / NAS
    nixosConfigurations.jacob-china = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      specialArgs = {inherit inputs;};
      modules = [
        nur.nixosModules.nur
        ./systems/nixos/configuration.nix
        ./systems/nixos/china/configuration.nix
        home-manager.nixosModules.home-manager
        {
          home-manager.users.jacobpyke = import ./systems/nixos/china/home.nix;
          home-manager.extraSpecialArgs = {
            inherit inputs;
            system = "x86_64-linux";
          };
        }
      ];
    };
    # Nix-Darwin Macbook Pro
    darwinConfigurations."jacob-germany" = nix-darwin.lib.darwinSystem {
      system = "aarch64-darwin";
      specialArgs = {inherit inputs;};
      modules = [
        stylix.darwinModules.stylix
        ./systems/darwin/kmonad.nix
        ./systems/darwin/configuration.nix
        ./systems/stylix.nix
        home-manager.darwinModules.home-manager
        {
          home-manager.backupFileExtension = "backup";
          home-manager.users.jacobpyke.imports = [
            ./users/jacob/common-home.nix
            ./systems/darwin/home.nix
          ];
          home-manager.extraSpecialArgs = {
            inherit inputs;
            system = "aarch64-darwin";
          };
        }
      ];
    };
    # Jovian Installer Image
    nixosConfigurations.steam-deck-live = unstable.lib.nixosSystem {
      system = "x86_64-linux";
      specialArgs = {inherit inputs;};
      modules = [
        (nixpkgs + "/nixos/modules/installer/cd-dvd/installation-cd-graphical-plasma5.nix")
        ./systems/nixos/configuration.nix
        ./systems/nixos/japan/configuration.nix
      ];
    };
  };
}
