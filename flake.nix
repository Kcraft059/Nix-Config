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

    nixos-raspberrypi = {
      url = "github:nvmd/nixos-raspberrypi/main";
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

    plasma-manager = {
      url = "github:nix-community/plasma-manager";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.home-manager.follows = "home-manager";
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

  ################### Additionnal binary caches ###################
  nixConfig = {
    extra-substituters = [ "https://nixos-raspberrypi.cachix.org" ];
    extra-trusted-public-keys = [
      "nixos-raspberrypi.cachix.org-1:4iMO9LXa8BqhU+Rpg6LQKiGa2lsNh/j2oiYLNOQ5sPI="
    ];
  };

  outputs =
    {
      self,
      nixpkgs,
      nix-darwin,
      nixos-raspberrypi,
      sops-nix,
      home-manager,
      plasma-manager,
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
              ## [IMPURE]
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
                mode = "0400";
                owner = config.users.users.camille.name;
                group = "wheel";
              };
            in
            {
              "ftn/front-ssh" = ssh-key-config;
              "ftn/node-ssh" = ssh-key-config;
              ssh-id-ed25519 = ssh-key-config;
              github-token = ssh-key-config;
              camille-passwd.neededForUsers = true;
            };
        };

      default-nixpkg-conf = {
        #inherit system;
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

          full-generic = {
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
                darwin-system.defaults.wallpaper = ./ressources/Breeze.png;
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
          minimal-generic = {
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
                darwin-system.defaults.wallpaper = ./ressources/Breeze.png;
                common.stylix.wallpaper = darwin-system.defaults.wallpaper;
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
        in
        rec {
          # Config assignation
          full = nix-darwin.lib.darwinSystem full-generic;
          minimal = nix-darwin.lib.darwinSystem minimal-generic;

          "MacBookAirCam-M3" = full;
          "MacBookAirCam-M3-minimal" = nix-darwin.lib.darwinSystem (
            minimal-generic
            // {
              modules = minimal-generic.modules ++ [
                {
                  darwin-system.external-drive.enable = true;
                  darwin-system.external-drive.path = "/Volumes/Data";
                }
              ];
            }
          );

          "MacExternal" = nix-darwin.lib.darwinSystem (
            full-generic
            // {
              modules = minimal-generic.modules ++ [
                {
                  darwin-system.external-drive.enable = lib.mkForce false;
                }
              ];
            }
          );

        };
      nixosConfigurations =
        let
          full-generic = {
            ### Module parameter inheritance
            #inherit system;
            specialArgs = {
              inherit
                self # Needed in nix-conf
                inputs # Needed throughout the config
                ;
            };

            ### Module & module configuration
            modules = [
              # [COMPLETE] Pkgs set configuration

              ## Secret module import
              sops-nix.nixosModules.sops
              default-secret-conf

              ## Main system config
              # ./config/nixos/default.nix # Is not general enough
              {
                common.stylix.enable = true;
                common.stylix.wallpaper = ./ressources/Breeze.png;
                nixos-system.plasma6.enable = true;
                nixos-system.hyprland.enable = false;
              }

              ## Package config
              ./packages/nix/default.nix
              {
                NIXPKG.linuxApps.enable = true;
                NIXPKG.GUIapps.enable = true;
              }

              ## Home-manager user config
              home-manager.nixosModules.home-manager
              (
                { config, ... }:
                {
                  home-manager.useGlobalPkgs = true;
                  home-manager.useUserPackages = true;
                  home-manager.backupFileExtension = "hmbackup";
                  home-manager.sharedModules = [ plasma-manager.homeModules.plasma-manager ];
                  home-manager.extraSpecialArgs = {
                    inherit inputs;
                    global-config = config;
                  };
                  home-manager.users.camille = {
                    # [COMPLETE] import config for user camille
                    home-config.GUIapps.enable = true;
                    home-config.plasma.enable = true;
                    home-config.userPicture = ./ressources/vflower-1.jpg;
                  };
                }
              )

              ## Stylix
              stylix.nixosModules.stylix
            ];
          };
        in
        rec {
          full =
            let
              system = "x86_64-linux";
            in
            nixpkgs.lib.nixosSystem (
              full-generic
              // {
                inherit system;
                modules = full-generic.modules ++ [
                  {
                    ## Pkgs set configuration
                    nixpkgs = {
                      inherit system;
                    }
                    // default-nixpkg-conf;

                    ## Hostname config
                    networking.hostName = "LenovoYogaCam-i7";

                    ## Home manager config
                    home-manager.users.camille.imports = [ ./home/nixos/regular/default.nix ];
                  }

                  ## Main system config
                  ./config/nixos/regular/default.nix
                ];
              }
            );

          full-rpi5 =
            let
              system = "aarch64-linux";

              ## Lib patch for removed options (bootloader)
              lib = nixpkgs.lib;
              baseLib = nixpkgs.lib;
              origMkRemovedOptionModule = baseLib.mkRemovedOptionModule;
              patchedLib = lib.extend (
                final: prev: {
                  mkRemovedOptionModule =
                    optionName: replacementInstructions:
                    let
                      key = "removedOptionModule#" + final.concatStringsSep "_" optionName;
                    in
                    { options, ... }:
                    (origMkRemovedOptionModule optionName replacementInstructions { inherit options; })
                    // {
                      inherit key;
                    };
                }
              );

            in
            nixos-raspberrypi.lib.nixosSystem (
              full-generic
              // {
                inherit system;
                lib = patchedLib;

                # Append required special-args
                specialArgs = full-generic.specialArgs // {
                  inherit nixos-raspberrypi;
                };

                # Append other modules
                modules = full-generic.modules ++ [
                  {
                    imports = with nixos-raspberrypi.nixosModules; [
                      raspberry-pi-5.base
                      raspberry-pi-5.page-size-16k
                      raspberry-pi-5.display-vc4
                      raspberry-pi-5.bluetooth
                    ];

                    nixpkgs = {
                      inherit system;
                    }
                    // default-nixpkg-conf;

                    ## Hostname config
                    networking.hostName = "RpiCam-500plus";

                    ## Home manager config
                    home-manager.users.camille.imports = [ ./home/nixos/rpi5/default.nix ];
                  }

                  ## Main system config
                  ./config/nixos/rpi5/default.nix
                ];
              }
            );

          ### Config assignation

          "LenovoYogaCam-i7" = full;
          "RpiCam-500plus" = full-rpi5;
        };
      # Expose the package set, including overlays, for convenience.
      darwinPackages = self.darwinConfigurations.full.pkgs;
    };
}
