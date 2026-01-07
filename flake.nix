{
  description = "Home Manager configuration of jacobpyke";

  nixConfig = {
    extra-substituters = [
      # "http://jacob-china:5000/main" # Self-hosted Attic cache (via Tailscale) - uncomment after setup
      "https://jpyke3.cachix.org"
    ];
    extra-trusted-public-keys = [
      # "main:ATTIC_PUBLIC_KEY" # Uncomment and replace after Attic setup
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
    kmonad = {
      url = "github:kmonad/kmonad?dir=nix";
    };
    base16 = {
      url = "github:SenchoPens/base16.nix";
    };
    stylix = {
      url = "github:danth/stylix/release-25.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    spicetify-nix = {
      url = "github:Gerg-L/spicetify-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    vpnconfinement = {
      url = "github:Maroka-chan/VPN-Confinement";
    };
    nix-rosetta-builder = {
      url = "github:cpick/nix-rosetta-builder";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixos-apple-silicon = {
      url = "github:oliverbestmann/nixos-apple-silicon";
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
    llama-cpp,
    jovian,
    nix-darwin,
    nixpkgs-darwin,
    nur,
    stylix,
    spicetify-nix,
    vpnconfinement,
    nix-rosetta-builder,
    nixos-apple-silicon,
    nix-cachyos-kernel,
    nixpkgs-citrix,
    ...
  } @ inputs: {
    # Desktop PC (Currently Unused)
    # nixosConfigurations.jacob-singapore = nixpkgs.lib.nixosSystem {
    #   system = "x86_64-linux";
    #   specialArgs = {inherit inputs;};
    #   modules = [
    #     nur.modules.nixos.default
    #     ./systems/nixos/configuration.nix
    #     ./systems/nixos/singapore/configuration.nix
    #     stylix.nixosModules.stylix
    #     ./systems/stylix.nix
    #     home-manager.nixosModules.home-manager
    #     {
    #       home-manager.users.jacobpyke = import ./systems/nixos/singapore/home.nix;
    #       home-manager.backupFileExtension = "backup";
    #       home-manager.extraSpecialArgs = {
    #         inherit inputs;
    #         system = "x86_64-linux";
    #       };
    #     }
    #   ];
    # };
    # ASUS ROG Laptop (CachyOS Migration)
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
    # Asahi Linux (Deprecated - no longer active)
    # nixosConfigurations.jacob-austria = unstable.lib.nixosSystem {
    #   system = "aarch64-linux";
    #   specialArgs = {inherit inputs;};
    #   modules = [
    #     nur.modules.nixos.default
    #     ./systems/nixos/configuration.nix
    #     ./systems/nixos/austria/configuration.nix
    #     nixos-apple-silicon.nixosModules.default
    #     stylix.nixosModules.stylix
    #     ./systems/stylix.nix
    #     home-manager-unstable.nixosModules.home-manager
    #     {
    #       home-manager.users.jacobpyke = import ./systems/nixos/austria/home.nix;
    #       home-manager.backupFileExtension = "backup";
    #       home-manager.extraSpecialArgs = {
    #         inherit inputs;
    #         system = "aarch64-linux";
    #       };
    #     }
    #   ];
    # };
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
