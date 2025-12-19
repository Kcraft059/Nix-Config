{
  description = "Polyglot Nix-system config for all my devices - Kcraft059";

  # Note : on macos uninstalled nix-2.25.3 from nix-env

  inputs = {

    ################### Core Modules ###################
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";

    nix-darwin = {
      url = "github:nix-darwin/nix-darwin";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    ################### Utility Modules ###################

    sops-nix = {
      url = "github:Mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nix-homebrew.url = "github:zhaofengli-wip/nix-homebrew";
    nix-vscode-extensions.url = "github:nix-community/nix-vscode-extensions";
    stylix.url = "github:danth/stylix";

    /*
      LazyVim = {
         url = "github:matadaniel/LazyVim-module";
         inputs.nixpkgs.follows = "nixpkgs";
       };
    */

    ################### Overlays Modules ###################

    rust-overlay = {
      url = "github:oxalica/rust-overlay";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    crane = {
      url = "github:ipetkov/crane";
      #inputs.nixpkgs.follows = "nixpkgs";
    };

    ################### Homebrew taps ###################

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
    homebrew-sirakugir = {
      url = "github:Sikarugir-App/homebrew-sikarugir";
      flake = false;
    };
    homebrew-keith = {
      url = "github:keith/homebrew-formulae";
      flake = false;
    };
    homebrew-deskflow = {
      url = "github:deskflow/homebrew-tap";
      flake = false;
    };

    ################### Custom sources ###################

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
      sops-nix,
      home-manager,
      nix-homebrew,
      stylix,
      ...
    }@inputs: # Allow for access to optionnal inputs with inputs.optionnalInput
    let
      ### Default general purpose configs
      default-secret-conf =
        { config, lib, ... }:
        let
          sops-key-file =
            let
              file-path = builtins.getEnv "SOPS_KEY_FILE";
            in
            if file-path == "" then
              throw "No $SOPS_KEY_FILE env-var, it might mean this flake is evaluated as --pure"
            else
              lib.traceValFn (v: "SOPS keyFile set to: ${v}") file-path;
        in
        rec {
          # To edit secrets .yaml `nix-shell -p sops --run "sops secrets/secrets.yaml"`
          # When adding new keys : `nix-shell -p sops --run "sops updatekeys secrets/secrets.yaml"`
          sops.defaultSopsFile = ./secrets/secrets.yaml;
          sops.age.sshKeyPaths = [ ];
          sops.age.keyFile = sops-key-file;
          # https://github.com/Mic92/sops-nix?tab=readme-ov-file#set-secret-permissionowner-and-allow-services-to-access-it
          sops.secrets =
            let
              ssh-key-config = {
                mode = "0600";
                owner = config.users.users.camille.name;
                #gid = config.users.users.camille.gid;
              };
            in
            {
              "ftn/front-ssh" = ssh-key-config;
              "ftn/node-ssh" = ssh-key-config;
              ssh-id-ed25519 = ssh-key-config;
            };
        };

      default-nixpkg-conf = {
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
      darwinConfigurations =
        let
          system = "aarch64-darwin"; # Build system
        in

        rec {
          full = nix-darwin.lib.darwinSystem {
            ### Module parameter inheritance
            inherit system;
            specialArgs = {
              inherit
                self # Needed in nix-conf
                inputs # Needed throughout the config
                ;
            };

            ### Module & module configuration
            modules = [
              ## Pkgs set configuration
              {
                nixpkgs = {
                  inherit system;
                }
                // default-nixpkg-conf;
              }

              ## Secret module import
              sops-nix.darwinModules.sops
              default-secret-conf # Gets evaluated as a function

              ## Main system config
              ./config/darwin/default.nix
              rec {
                darwin-system.window-man = {
                  enable = true; # Might need to manually remove launchd services
                  type = "yabai";
                };
                #darwin-system.status-bar.enable = true;
                darwin-system.defaults.dock.enable = true;
                darwin-system.defaults.wallpaper = ./ressources/Abstract_Wave.jpg;
                darwin-system.external-drive.enable = true;
                darwin-system.external-drive.path = "/Volumes/Data";
                common.stylix.wallpaper = darwin-system.defaults.wallpaper;
              }

              ## Package config
              ./packages/nix/default.nix
              {
                NIXPKG.darwinApps.enable = true;
              }

              ## Homebrew packages config
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
                    "Sirakugir-App/homebrew-sirakugir" = inputs.homebrew-sirakugir;
                    "keith/homebrew-formulae" = inputs.homebrew-keith;
                    "deskflow/homebrew-tap" = inputs.homebrew-deskflow;
                  };
                };
              }
              ./packages/homebrew/default.nix
              {
                HMB.masApps.enable = true; # mdutil #check for spotlight indexing
              }

              ## Home-manager user config
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

              ## Stylix
              stylix.darwinModules.stylix
            ];
          };
          minimal = nix-darwin.lib.darwinSystem {
            ### Module parameter inheritance
            inherit system;
            specialArgs = {
              inherit
                self # Needed in nix-conf
                inputs # Needed throughout the config
                ;
            };
            ### Module & module configuration
            modules = [
              ## Pkgs set configuration
              {
                nixpkgs = {
                  inherit system;
                }
                // default-nixpkg-conf;
              }

              ## Secret module import
              sops-nix.darwinModules.sops
              default-secret-conf

              ## Main system config
              ./config/darwin/default.nix
              rec {
                darwin-system.window-man = {
                  enable = true; # Might need to manually remove launchd services
                  type = "yabai";
                };
                #darwin-system.status-bar.enable = true;
                darwin-system.defaults.dock.enable = true;
                darwin-system.defaults.wallpaper = ./ressources/Abstract_Wave.jpg;
                common.stylix.wallpaper = darwin-system.defaults.wallpaper;
                darwin-system.external-drive.enable = false;
              }

              ## Package config
              ./packages/nix/default.nix
              {
                NIXPKG.darwinApps.enable = false;
              }

              ## Homebrew packages config
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
                    "Sirakugir-App/homebrew-sirakugir" = inputs.homebrew-sirakugir;
                    "keith/homebrew-formulae" = inputs.homebrew-keith;
                    "deskflow/homebrew-tap" = inputs.homebrew-deskflow;
                  };
                };
              }
              ./packages/homebrew/default.nix
              {
                HMB.masApps.enable = false; # mdutil #check for spotlight indexing
                HMB.casks.enable = false;
                HMB.brews.enable = false;
              }

              ## Home-manager user config
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
                    home-config.darwinApps.enable = false;
                  };
                }
              )

              ## Stylix
              stylix.darwinModules.stylix
            ];
          };

          # Config assignation
          "MacBookAirCam-M3" = full;
          "MacRecovery" = minimal;
        };
      nixosConfigurations =
        let
          system = "x86_64-linux";
        in
        rec {
          full = nixpkgs.lib.nixosSystem {
            ### Module parameter inheritance
            inherit system;
            specialArgs = {
              inherit
                self # Needed in nix-conf
                inputs # Needed throughout the config
                ;
            };

            ### Module & module configuration
            modules = [
              ## Pkgs set configuration
              {
                nixpkgs = {
                  inherit system;
                }
                // default-nixpkg-conf;
              }

              ## Secret module import
              sops-nix.nixosModules.sops
              default-secret-conf

              ## Main system config
              ./config/nixos/default.nix
              {
                common.stylix.enable = true;
                common.stylix.wallpaper = ./ressources/Abstract_Wave.jpg;
                nixos-system.plasma6.enable = false;
                nixos-system.hyprland.enable = true;
              }

              ## Package config
              ./packages/nix/default.nix
              {
                NIXPKG.linuxApps.enable = true;
              }

              ## Home-manager user config
              home-manager.nixosModules.home-manager
              (
                { config, ... }:
                {
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
                      ./home/nixos/default.nix
                    ];
                    home-config.GUIapps.enable = true;
                    home-config.hyprland.enable = true;
                    home-config.hyprland.wallpaper = config.common.stylix.wallpaper;
                  };
                }
              )

              ## Stylix
              stylix.nixosModules.stylix
            ];
          };

          ### Config assignation
          "LenovoYogaCam-i7" = full;
        };
      # Expose the package set, including overlays, for convenience.
      darwinPackages = self.darwinConfigurations.full.pkgs;
    };
}
