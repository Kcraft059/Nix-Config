{
  description = "Polyglot Nix-system config for all my devices - Kcraft059";

  # Note : on macos uninstalled nix-2.25.3 from nix-env

  inputs = {

    ## Modules
    # Core
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";

    nix-darwin = {
      url = "github:nix-darwin/nix-darwin";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Functionnality modules
    stylix.url = "github:danth/stylix";

    nix-vscode-extensions.url = "github:nix-community/nix-vscode-extensions";

    nix-homebrew.url = "github:zhaofengli-wip/nix-homebrew"; # Nix homebrew

    LazyVim = {
      url = "github:matadaniel/LazyVim-module";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Rust Packages

    rust-overlay = {
      url = "github:oxalica/rust-overlay";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    crane = {
      url = "github:ipetkov/crane";
      #inputs.nixpkgs.follows = "nixpkgs";
    };

    ## Homebrew taps

    homebrew-core = {
      url = "github:homebrew/homebrew-core";
      flake = false;
    };
    homebrew-cask = {
      url = "github:homebrew/homebrew-cask";
      flake = false;
    };
    homebrew-bundle = {
      url = "github:homebrew/homebrew-bundle";
      flake = false;
    };
    homebrew-fuse = {
      url = "github:gromgit/homebrew-fuse";
      flake = false;
    };
    homebrew-betterdisplay = {
      url = "github:waydabber/homebrew-betterdisplay";
      flake = false;
    };
    homebrew-kegworks = {
      url = "github:Kegworks-App/homebrew-kegworks";
      flake = false;
    };
    homebrew-keith = {
      url = "github:keith/homebrew-formulae";
      flake = false;
    };

    ## Custom sources

    sketchybar-config = {
      url = "github:Kcraft059/sketchybar-config";
      flake = false;
    };

    rift = {
      url = "github:acsandmann/rift";
      flake = false;
    };

  };

  outputs =
    {
      self,
      nixpkgs,
      nix-darwin,
      home-manager,
      nix-homebrew,
      stylix,
      ...
    }@inputs: # Allow for access to optionnal inputs with inputs.optionnalInput
    {
      darwinConfigurations =
        let
          system = "aarch64-darwin"; # Build system
          pkgs = import inputs.nixpkgs {
            inherit system;
            config = {
              allowUnfree = true;
              #allowUnsupportedSystem = true;
              #allowBroken = true;
            };
            overlays = [
              inputs.nix-vscode-extensions.overlays.default
              (import ./overlays/default.nix { inherit inputs; })
            ];
          };
        in
        {
          "MacBookAirCam-M3" = nix-darwin.lib.darwinSystem {
            inherit system;
            specialArgs = {
              inherit
                self # Needed in nix-conf
                inputs # Needed throughout the config
                pkgs # Is needed since we modify options above
                ;
            };
            modules = [
              ./config/darwin/default.nix
              {
                darwin-system.window-man = {
                  enable = true; # Might need to manually remove launchd services
                  type = "yabai";
                };
                #darwin-system.status-bar.enable = true;
                darwin-system.defaults.dock.enable = true;
                darwin-system.defaults.wallpaper = ./ressources/Abstract_Wave.jpg;
                darwin-system.external-drive.enable = true;
                darwin-system.external-drive.path = "/Volumes/Data";
              }
              ./packages/nix/default.nix
              {
                NIXPKG.darwinApps.enable = true;
              }
              ./packages/homebrew/default.nix
              {
                HMB.masApps.enable = false; # mdutil #check for spotlight indexing
              }
              home-manager.darwinModules.home-manager
              (
                { config, ... }:
                {
                  # Call as a function to access input recursively
                  home-manager.useGlobalPkgs = true;
                  home-manager.useUserPackages = true;
                  home-manager.backupFileExtension = "hmbackup";
                  home-manager.extraSpecialArgs = {
                    inherit inputs;
                    global-config = config;
                  };
                  home-manager.users.camille = {
                    # {...} can be replaced by import ./path/to/module.nix
                    imports = [
                      ./home/darwin/default.nix
                    ];
                    home-config.status-bar.enable = true;
                    home-config.GUIapps.enable = true;
                    home-config.darwinApps.enable = true;
                  };
                }
              )
              nix-homebrew.darwinModules.nix-homebrew
              {
                nix-homebrew = {
                  enable = true;
                  enableRosetta = true;
                  user = "camille";
                  mutableTaps = false;
                  taps = {
                    "homebrew/homebrew-core" = inputs.homebrew-core;
                    "homebrew/homebrew-cask" = inputs.homebrew-cask;
                    "homebrew/homebrew-bundle" = inputs.homebrew-bundle;
                    "gromgit/homebrew-fuse" = inputs.homebrew-fuse;
                    "waydabber/homebrew-betterdisplay" = inputs.homebrew-betterdisplay;
                    "Kegworks-App/homebrew-kegworks" = inputs.homebrew-kegworks;
                    "keith/homebrew-formulae" = inputs.homebrew-keith;
                  };
                };
              }
              stylix.darwinModules.stylix
            ];
          };
        };
      nixosConfigurations =
        let
          system = "x86_64-linux";
          pkgs = import inputs.nixpkgs {
            inherit system;
            config = {
              allowUnfree = true;
              #allowUnsupportedSystem = true;
              #allowBroken = true;
            };
            overlays = [
              inputs.nix-vscode-extensions.overlays.default
              (import ./overlays/default.nix { inherit inputs; })
            ];
          };
        in
        {
          "NixLaptop" = nixpkgs.lib.nixosSystem {
            inherit system;
            specialArgs = {
              inherit
                self # Needed in nix-conf
                inputs # Needed throughout the config
                pkgs # Is needed since we modify options above
                ;
            };
            modules = [
              ./config/nixos/default.nix
              {
                common.stylix.enable = true;
                nixos-system.plasma6.enable = false;
                nixos-system.hyprland.enable = true;
              }
              ./packages/nix/default.nix
              {
                NIXPKG.linuxApps.enable = true;
              }
              home-manager.nixosModules.home-manager
              ({ config, ... }:{
                home-manager.useGlobalPkgs = true;
                home-manager.useUserPackages = true;
                home-manager.backupFileExtension = "bak";
                home-manager.extraSpecialArgs = {
                  inherit inputs;
                  global-config = config;
                };
                home-manager.users.camille = {
                  # {...} can be replaced by import ./path/to/module.nix
                  imports = [
                    ./home/nixos/default.nix
                  ];
                  home-config.GUIapps.enable = true;
                  home-config.hyprland.enable = true;
                  };
              })
              stylix.nixosModules.stylix
            ];
          };
        };
      # Expose the package set, including overlays, for convenience.
      darwinPackages = self.darwinConfigurations."MacBookAirCam-M3".pkgs;
    };
}
