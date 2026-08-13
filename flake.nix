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
      url = "github:nvmd/nixos-raspberrypi/nixos-unstable";
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
    extra-substituters = [
      "https://nix-community.cachix.org"
      "https://nixos-raspberrypi.cachix.org"
    ];
    extra-trusted-public-keys = [
      "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
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

      theme-file = ./system/common/theme/gruvbox.nix;

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
              builtins.trace "Error: No/Empty $SOPS_KEY_FILE env-var, it might mean this flake is evaluated as --pure. This will fail upon rebuild." file-path
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
          sops.defaultSopsFile = ./secrets.yaml;
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

            # System
            ./system/darwin/default.nix

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
              ({ pkgs, lib, ... }: {
                ## Main system config
                darwin-system.window-man = {
                  enable = true; # Might need to manually remove launchd services
                  type = "yabai";
                };
                darwin-system.defaults.dock.enable = true;
                darwin-system.external-drive.enable = true;
                darwin-system.external-drive.path = "/Volumes/Data";
                darwin-system.wacom-driver.enable = true;

                ## Packages config
                nix.linux-builder = {
                  enable = true;
                  package =
                    let
                      fixedPkgs = pkgs.extend (
                        final: prev: {
                          qemu = prev.qemu.overrideAttrs (old: {
                            buildInputs = (old.buildInputs or [ ]) ++ [ prev.apple-sdk_15 ];
                          });
                        }
                      );
                    in
                    fixedPkgs.darwin.linux-builder;
                  config = {
                    virtualisation.cores = lib.mkForce 8;
                    virtualisation.memorySize = lib.mkForce 8192; # 8GB RAM while you're at it
                  };
                  ephemeral = true;
                  maxJobs = 6;
                };
                launchd.daemons.linux-builder.serviceConfig.RunAtLoad = lib.mkForce false;
                launchd.daemons.linux-builder.serviceConfig.KeepAlive = lib.mkForce false;

                ## Homebrew packages config
                homebrew-pkgs.mas = true;

                ## Home-manager user config
                home-manager.users.camille = {
                  home-config.status-bar.enable = true;
                  home-config.gui = true;
                };
              })
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

                ## System packages
                system-pkgs.gui = false;
                system-pkgs.additionnals = false;

                ## Homebrew packages config
                homebrew-pkgs.mas = false; # mdutil check for spotlight indexing
                homebrew-pkgs.casks = false;
                homebrew-pkgs.brews = false;

                ## Home-manager user config
                home-manager.users.camille = {
                  home-config.status-bar.enable = true;
                  home-config.gui = false;
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

          "MacBookAirCam-M3" = mkFinalConfig nix-darwin.lib.darwinSystem full-generic (
            { lib, ... }: {
              networking.hostName = "MacBookAirCam-M3";
              common.theme.wallpaper = lib.mkForce ./system/common/theme/wallpapers/Golden_Gate_Light.png;
            }
          );

          "MacBookAirCam-M3-minimal" = mkFinalConfig nix-darwin.lib.darwinSystem minimal-generic {
            networking.hostName = "MacBookAirCam-M3";
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

          default = mkFinalConfig nix-darwin.lib.darwinSystem full-generic { };
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
                system-pkgs.gui = true;
                system-pkgs.additionnals = true;

                ## Home-manager user config
                home-manager.users.camille = {
                  home-config.gui = true;
                  home-config.plasma = true;
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
              ./system/nixos/regular/default.nix

              {
                ## Home manager config
                home-manager.users.camille.imports = [ ./home/nixos/regular/default.nix ];
              }
            ];
          };

          ################### NixOS full-generic-regular ###################
          # MARK: NixOS full-generic-rpi5

          full-generic-rpi5 = full-generic // {
            ### Module config
            system = "aarch64-linux";

            # Append required special-args
            specialArgs = full-generic.specialArgs // {
              inherit nixos-raspberrypi;
            };

            modules = full-generic.modules ++ [
              ## Main system config
              ./system/nixos/rpi5/default.nix
              {
                imports = with nixos-raspberrypi.nixosModules; [
                  raspberry-pi-5.base
                  raspberry-pi-5.page-size-16k
                  raspberry-pi-5.display-vc4
                  raspberry-pi-5.bluetooth
                ];

                ## Home manager config
                home-manager.users.camille.imports = [ ./home/nixos/rpi5/default.nix ];

                ## Patches
                nixpkgs.overlays = [
                  (
                    final: prev:
                    let
                      patchedQtbase = prev.qt6.qtbase.overrideAttrs (
                        oldAttrs:
                        if oldAttrs.version == "6.11.0" then
                          {
                            patches = (oldAttrs.patches or [ ]) ++ [
                              # https://codereview.qt-project.org/c/qt/qtbase/+/726211/1
                              (prev.fetchpatch {
                                name = "qtbase-gerrit-726211.patch";
                                url = "https://codereview.qt-project.org/changes/qt%2Fqtbase~726211/revisions/1/patch?download&raw";
                                hash = "sha256-xRYPWuFZGf7JZmYBiGoSaN/3v3c7+GxtHIYFtaekP70=";
                              })
                            ];
                          }
                        else
                          oldAttrs
                      );

                      overrideQtScope =
                        scope:
                        let
                          patchedScope = scope.overrideScope (
                            qfinal: qprev: {
                              qtbase = patchedQtbase;
                            }
                          );
                        in
                        # preserve original .override functions
                        # required by python-packages.nix and other deep framework evaluators
                        patchedScope // (if scope ? override then { inherit (scope) override; } else { });
                    in
                    {
                      jdk17 = prev.jdk17.overrideAttrs (_: {
                        enableParallelBuilding = false;
                      });
                      sdl3 = prev.sdl3.overrideAttrs (old: {
                        doCheck = false;
                      });
                      qt6 = overrideQtScope prev.qt6;
                      qt6Packages = overrideQtScope prev.qt6Packages;
                    }
                  )
                ];
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
      # Eg `nix build nix build .#ft-haptics`

      packages = {
        aarch64-darwin = self.darwinConfigurations.full.pkgs;
        aarch64-linux = self.nixosConfigurations.full-rpi5.pkgs;
        x86_64-linux = self.nixosConfigurations.full-regular.pkgs;
      };
    };
}
