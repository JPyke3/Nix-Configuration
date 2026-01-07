{
  description = "Home Manager configuration of jacobpyke";

  nixConfig = {
    extra-substituters = [
      "http://jacob-china:5000/main" # Self-hosted Attic cache (via Tailscale)
      "https://jpyke3.cachix.org" # Cachix fallback
    ];
    extra-trusted-public-keys = [
      "main:cTGyR3LMgVRA9oIu0U65WPKezuI9zl4EAlVb6y6I2kk="
      "jpyke3.cachix.org-1:SkUkQoQ6WbhSs7SGsMZ22H/DyJ7VNpT4/BaEvTCEQZY="
    ];
    trusted-users = [
      "root"
      "jacobpyke"
    ];
  };

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-25.11";
    unstable.url = "github:nixos/nixpkgs/nixos-unstable";
    nixpkgs-darwin.url = "github:nixos/nixpkgs/nixpkgs-25.11-darwin";
    nur = {
      url = "github:nix-community/nur";
    };
    home-manager = {
      url = "github:nix-community/home-manager/release-25.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    home-manager-unstable = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "unstable";
    };
    nix-darwin = {
      url = "github:LnL7/nix-darwin/nix-darwin-25.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nix-colors = {
      url = "github:misterio77/nix-colors";
    };
    nixpkgs-firefox-darwin = {
      url = "github:bandithedoge/nixpkgs-firefox-darwin";
    };
    sops-nix = {
      url = "github:Mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    jovian = {
      url = "github:Jovian-Experiments/Jovian-NixOS";
      inputs.nixpkgs.follows = "unstable";
    };
    kmonad = {
      url = "github:kmonad/kmonad?dir=nix";
    };
    stylix = {
      url = "github:danth/stylix/release-25.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    vpnconfinement = {
      url = "github:Maroka-chan/VPN-Confinement";
    };
    nix-rosetta-builder = {
      url = "github:cpick/nix-rosetta-builder";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    # CachyOS optimized kernel
    nix-cachyos-kernel = {
      url = "github:xddxdd/nix-cachyos-kernel/release";
    };
    # NixOS 24.11 for citrix_workspace (needs webkitgtk_4_0 which was removed in 25.x)
    nixpkgs-citrix = {
      url = "github:nixos/nixpkgs/nixos-24.11";
    };
  };

  outputs = {
    self,
    nixpkgs,
    unstable,
    home-manager,
    home-manager-unstable,
    jovian,
    nix-darwin,
    nixpkgs-darwin,
    nur,
    stylix,
    vpnconfinement,
    nix-rosetta-builder,
    nix-cachyos-kernel,
    nixpkgs-citrix,
    ...
  } @ inputs: {
    # ASUS ROG Laptop
    nixosConfigurations.jacob-norway = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      specialArgs = {inherit inputs;};
      modules = [
        nur.modules.nixos.default
        ./systems/nixos/configuration.nix
        ./systems/nixos/norway/configuration.nix
        stylix.nixosModules.stylix
        ./systems/stylix.nix
        home-manager.nixosModules.home-manager
        ({...}: let
          pkgs_unstable = import unstable {
            system = "x86_64-linux";
            config.allowUnfree = true;
            config.allowBroken = true;
            config.permittedInsecurePackages = ["libsoup-2.74.3"];
          };
          pkgs_citrix = import nixpkgs-citrix {
            system = "x86_64-linux";
            config.allowUnfree = true;
            config.permittedInsecurePackages = ["libsoup-2.74.3"];
          };
        in {
          home-manager.users.jacobpyke = import ./systems/nixos/norway/home.nix;
          home-manager.backupFileExtension = "backup";
          home-manager.extraSpecialArgs = {
            inherit inputs pkgs_unstable pkgs_citrix;
          };
        })
      ];
    };
    # Steam Deck OLED
    nixosConfigurations.jacob-japan = unstable.lib.nixosSystem {
      system = "x86_64-linux";
      specialArgs = {inherit inputs;};
      modules = [
        nur.modules.nixos.default
        ./systems/nixos/configuration.nix
        ./systems/nixos/japan/configuration.nix
        home-manager-unstable.nixosModules.home-manager
        {
          home-manager.users.jacobpyke = import ./systems/nixos/japan/home.nix;
          home-manager.extraSpecialArgs = {
            inherit inputs;
          };
        }
      ];
    };
    # Home Server / NAS
    nixosConfigurations.jacob-china = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      specialArgs = {inherit inputs;};
      modules = [
        nur.modules.nixos.default
        ./systems/nixos/configuration.nix
        ./systems/nixos/china/configuration.nix
        home-manager.nixosModules.home-manager
        {
          home-manager.users.jacobpyke = import ./systems/nixos/china/home.nix;
          home-manager.extraSpecialArgs = {
            inherit inputs;
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
        nix-rosetta-builder.darwinModules.default
        home-manager.darwinModules.home-manager
        {
          home-manager.backupFileExtension = "backup";
          home-manager.users.jacobpyke.imports = [
            ./users/jacob/common-home.nix
            ./systems/darwin/home.nix
          ];
          home-manager.extraSpecialArgs = {
            inherit inputs;
          };
        }
      ];
    };
  };
}
