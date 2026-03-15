{
  description = "Multi Devices/OS Nix-Config for all my all my personnal devices - Camille - Kcraft⁰⁵⁹";

  /**
    This config implements common settings over multiple devices, tho
    it is good practice to import system-specific modules only, and
    call common modules, from system-specific volumes. Any common module
    should then be compatible with any system.

    Device specific configs are merged from generic-configs and implements
    device-specific options, such that generic-configs can be like their
    name specifies it: generic.

    Tags: [IMPURE], [THEME DEPENDENT], [TODO]
  */

  ################### Inputs ###################
  # MARK: Inputs

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

    ################### Overlays Modules ###################

    rust-overlay = {
      url = "github:oxalica/rust-overlay";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    crane = {
      url = "github:ipetkov/crane";
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
      url = "github:Kcraft059/sketchybar-config/lua-port";
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

  ################### Outputs ###################
  # MARK: Outputs
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
    }@inputs:
    let
      ### Values & helpers
      mkFinalConfig =
        builder: config-base: option-set:
        builder (config-base // { modules = config-base.modules ++ [ option-set ]; });

      theme-file = ./config/common/theme/gruvbox.nix;

      ################### Default general purpose configs ###################
      # MARK: Default general purpose configs

      ## Global nixpkgs config, independent from system
      default-nixpkg-conf = {
        config = {
          allowUnfree = true;
        };
        overlays = [
          inputs.nix-vscode-extensions.overlays.default
          (import ./overlays/default.nix { inherit inputs; })
        ];
      };

      ## Sops secrets config - necessary for system build
      default-secret-conf =
        { config, lib, ... }:
        let
          # Sops key configuration, fetched from env VAR since it shouldn't be in store. Which makes it impure.
          ## [IMPURE]
          file-path = builtins.getEnv "SOPS_KEY_FILE";

          sops-key-file =
            if file-path == "" then
              throw "No $SOPS_KEY_FILE env-var, it might mean this flake is evaluated as --pure"
            else
              lib.traceValFn (v: "SOPS keyFile set to: ${v}") file-path;

          # Default key configuration for user
          user-key-config = {
            mode = "0400";
            owner = config.users.users.camille.name;
            group = "wheel";
          };
        in
        {
          sops.defaultSopsFile = ./secrets/secrets.yaml;
          sops.age.sshKeyPaths = [ ];
          sops.age.keyFile = sops-key-file;
          sops.secrets = {
            "ftn/front-ssh" = user-key-config;
            "ftn/node-ssh" = user-key-config;
            ssh-id-ed25519 = user-key-config;
            github-token = user-key-config;
            camille-passwd.neededForUsers = true;
          };
        };
    in
    {
      darwinConfigurations =
        let
          ################### Default darwin-config ###################
          # MARK: Darwin Configs

          system = "aarch64-darwin";

          ### Default module import
          default-modules = [
            ### Modules import
            # Utils
            sops-nix.darwinModules.sops
            home-manager.darwinModules.home-manager
            nix-homebrew.darwinModules.nix-homebrew
            stylix.darwinModules.stylix

            # Personnal
            ./config/darwin/default.nix
            ./packages/nix/default.nix
            ./packages/homebrew/default.nix

            ### Modules config
            default-secret-conf

            (
              {
                pkgs,
                config,
                themeUtils,
                ...
              }:
              {
                ## Nixpks config
                nixpkgs = default-nixpkg-conf;

                ## Theme config
                common.theme = import theme-file { inherit pkgs; };

                ## Home-manager top-config
                home-manager = {
                  useGlobalPkgs = true;
                  useUserPackages = true;
                  backupFileExtension = "hmbackup";
                  extraSpecialArgs = {
                    inherit inputs themeUtils;
                    global-config = config;
                  };
                  users.camille.imports = [
                    ./home/darwin/default.nix
                  ];
                };

                ## Nix-homebrew top-config
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
            )
          ];

          ################### Full config generic ###################
          # MARK: Darwin full-generic

          full-generic = {
            ### Module config
            inherit system; # Inherit system for pkgs

            # Inherit needed module args from top-level
            specialArgs = {
              inherit self inputs;
            };

            modules = default-modules ++ [
              ### Modules config
              {
                ## Main system config
                darwin-system.window-man = {
                  enable = true; # Might need to manually remove launchd services
                  type = "yabai";
                };
                darwin-system.defaults.dock.enable = true;
                darwin-system.external-drive.enable = true;
                darwin-system.external-drive.path = "/Volumes/Data";

                ## Packages config
                NIXPKG.darwinApps.enable = true;

                ## Homebrew packages config
                HMB.masApps.enable = true; # mdutil #check for spotlight indexing

                ## Home-manager user config
                home-manager.users.camille = {
                  home-config.status-bar.enable = true;
                  home-config.GUIapps.enable = true;
                  home-config.darwinApps.enable = true;
                };
              }
            ];
          };

          ################### Minimal config generic ###################
          # MARK: Darwin minimal-generic

          minimal-generic = {
            ### Module config
            inherit system; # Inherit system for pkgs

            # Inherit needed module args from top-level
            specialArgs = {
              inherit self inputs;
            };

            modules = default-modules ++ [
              ### Modules config

              {
                ## Main system config
                darwin-system.window-man = {
                  enable = true; # Might need to manually remove launchd services
                  type = "yabai";
                };
                darwin-system.defaults.dock.enable = true;

                ## Package config
                NIXPKG.darwinApps.enable = false;

                ## Homebrew packages config
                HMB.masApps.enable = false; # mdutil check for spotlight indexing
                HMB.casks.enable = false;
                HMB.brews.enable = false;

                ## Home-manager user config
                home-manager.users.camille = {
                  home-config.status-bar.enable = true;
                  home-config.GUIapps.enable = true;
                  home-config.darwinApps.enable = true;
                };
              }
            ];
          };
        in
        {
          ################### Config assignation ###################
          # MARK: Config assignation

          full = nix-darwin.lib.darwinSystem full-generic;
          minimal = nix-darwin.lib.darwinSystem minimal-generic;

          "MacBookAirCam-M3" = mkFinalConfig nix-darwin.lib.darwinSystem full-generic {
            networking.hostName = "MacBookAirCam-M3";
          };

          "MacBookAirCam-M3-minimal" = mkFinalConfig nix-darwin.lib.darwinSystem minimal-generic {
            networking.hostName = "MacBookAirCam-M3-minimal";
            darwin-system.external-drive.enable = true;
            darwin-system.external-drive.path = "/Volumes/Data";
          };

          "MacExternal" = mkFinalConfig nix-darwin.lib.darwinSystem full-generic (
            { lib, ... }:
            {
              networking.hostName = "MacExternal";
              darwin-system.external-drive.enable = lib.mkForce false;
            }
          );
        };

      nixosConfigurations =
        let
          ################### Default NixOS config ###################
          # MARK: NixOS configs

          default-modules = [
            ### Modules import
            # Utils
            sops-nix.nixosModules.sops
            stylix.nixosModules.stylix
            home-manager.nixosModules.home-manager

            # Personnal
            # ./config/nixos/default.nix # Is not general enough
            ./packages/nix/default.nix

            ### Modules config
            default-secret-conf

            (
              {
                pkgs,
                config,
                themeUtils,
                ...
              }:
              {
                ## Nixpks config
                nixpkgs = default-nixpkg-conf;

                ## Theme
                common.theme = import theme-file { inherit pkgs; };

                ## Home-manager top-config
                home-manager = {
                  useGlobalPkgs = true;
                  useUserPackages = true;
                  backupFileExtension = "hmbackup";
                  sharedModules = [ plasma-manager.homeModules.plasma-manager ];
                  extraSpecialArgs = {
                    inherit inputs themeUtils;
                    global-config = config;
                  };
                };
              }
            )
          ];

          ################### NixOS full-generic ###################
          # MARK: NixOS full-generic

          full-generic = {
            ### Module config
            # Inherit needed module args from top-level
            specialArgs = {
              inherit self inputs;
            };

            modules = default-modules ++ [
              {
                ## Main system config
                nixos-system.plasma6.enable = true;

                ## Package config
                NIXPKG.linuxApps.enable = true;
                NIXPKG.GUIapps.enable = true;

                ## Home-manager user config
                home-manager.users.camille = {
                  home-config.GUIapps.enable = true;
                  home-config.plasma.enable = true;
                  home-config.userPicture = ./resources/vflower-1.jpg;
                };
              }
            ];
          };

          ################### NixOS full-generic-regular ###################
          # MARK: NixOS full-generic-regular

          full-generic-regular = full-generic // {
            ### Module config
            system = "x86_64-linux"; # Inherit system for pkgs

            modules = full-generic.modules ++ [
              ## Main system config
              ./config/nixos/regular/default.nix

              {
                ## Home manager config
                home-manager.users.camille.imports = [ ./home/nixos/regular/default.nix ];
              }
            ];
          };

          ################### NixOS full-generic-regular ###################
          # MARK: NixOS full-generic-rpi5

          full-generic-rpi5 =
            let
              patchedLib = nixpkgs.lib.extend (
                final: prev: {
                  mkRemovedOptionModule =
                    optionName: replacementInstructions:
                    { options, ... }:
                    (prev.mkRemovedOptionModule optionName replacementInstructions { inherit options; })
                    // {
                      key = "removedOptionModule#" + final.concatStringsSep "_" optionName;
                    };
                }
              );
            in
            full-generic
            // {
              ### Module config
              system = "aarch64-linux";
              lib = patchedLib;

              # Append required special-args
              specialArgs = full-generic.specialArgs // {
                inherit nixos-raspberrypi;
              };

              modules = full-generic.modules ++ [
                ## Main system config
                ./config/nixos/rpi5/default.nix
                {
                  imports = with nixos-raspberrypi.nixosModules; [
                    raspberry-pi-5.base
                    raspberry-pi-5.page-size-16k
                    raspberry-pi-5.display-vc4
                    raspberry-pi-5.bluetooth
                  ];

                  ## Home manager config
                  home-manager.users.camille.imports = [ ./home/nixos/rpi5/default.nix ];
                }
              ];
            };
        in
        {
          ################### Config assignation ###################
          # MARK: Config assignation

          full-regular = nixpkgs.lib.nixosSystem full-generic-regular;
          full-rpi5 = nixos-raspberrypi.lib.nixosSystem full-generic-rpi5;

          "LenovoYogaCam-i7" = mkFinalConfig nixpkgs.lib.nixosSystem full-generic-regular {
            networking.hostName = "LenovoYogaCam-i7";
          };

          "RpiCam-500plus" = mkFinalConfig nixos-raspberrypi.lib.nixosSystem full-generic-rpi5 {
            networking.hostName = "RpiCam-500plus";
          };
        };

      ################### Pkgs set exposition ###################
      # MARK: Pkgs set exposition
      # Expose the package set, including overlays, for convenience.
      # Eg `nix build darwinPkgs.aarch64.ft-haptics`

      darwinPkgs.aarch64 = self.darwinConfigurations.full.pkgs;
      linuxPkgs = {
        aarch64 = self.nixosConfigurations.full-rpi5.pkgs;
        x86_64 = self.nixosConfigurations.full-regular.pkgs;
      };
    };
}
