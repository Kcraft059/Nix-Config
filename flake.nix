{
  description = "Polyglot Nix-system config for all my devices - Kcraft059";

  # Note : on macos uninstalled nix-2.25.3 from nix-env

  inputs = {

    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";

    nix-darwin.url = "github:nix-darwin/nix-darwin";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs";

    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    stylix.url = "github:danth/stylix";

    nix-vscode-extensions.url = "github:nix-community/nix-vscode-extensions";

    nix-homebrew.url = "github:zhaofengli-wip/nix-homebrew"; # Nix homebrew

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

    sketchybar-config = {
      url = "github:Kcraft059/sketchybar-config";
      flake = false;
    };

    # hyprland.url = "github:hyprwm/Hyprland";

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
          system = "aarch64-darwin";
        in
        {
          "MacBookAirCam-M3" = nix-darwin.lib.darwinSystem {
            specialArgs = {
              inherit self system inputs;
            };
            modules = [
              ./config/darwin/default.nix
              {
                darwin-system.window-man.enable = true;
                #darwin-system.status-bar.enable = true;
                darwin-system.defaults.dock.enable = true;
                darwin-system.defaults.wallpaper = ./ressources/wallhaven.png;
              }
              ./packages/nix/default.nix
              {
                NIXPKG.darwinApps.enable = true;
              }
              ./packages/homebrew/default.nix
              {
                HMB.masApps.enable = true; # mdutil #check for spotlight indexing
              }
              home-manager.darwinModules.home-manager
              {
                home-manager.useGlobalPkgs = true;
                home-manager.useUserPackages = true;
                home-manager.backupFileExtension = "hmbackup";
                home-manager.extraSpecialArgs = { inherit inputs; };
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
                  };
                };
              }
              stylix.darwinModules.stylix
            ];
          };
          "MacBookAirCam-M3-Test" = nix-darwin.lib.darwinSystem {
            specialArgs = {
              inherit self system inputs;
            };
            modules = [
              ./config/darwin/default.nix
              {
                common.stylix.enable = false;
                #darwin-system.status-bar.enable = true;
                darwin-system.defaults.wallpaper = ./ressources/wallhaven.png;
              }
              ./packages/nix/default.nix
              {
                NIXPKG.additionnals.enable = false;
                NIXPKG.GUIapps.enable = false;
              }
              ./packages/homebrew/default.nix
              {
                HMB.brews.enable = false;
                HMB.casks.enable = false;
              }
              home-manager.darwinModules.home-manager
              {
                home-manager.useGlobalPkgs = true;
                home-manager.useUserPackages = true;
                home-manager.users.camille = {
                  # {...} can be replaced by import ./path/to/module.nix
                  imports = [
                    ./home/darwin/default.nix
                  ];
                  home-config.status-bar.enable = false;
                  home-config.GUIapps.enable = true;
                };
              }
              nix-homebrew.darwinModules.nix-homebrew
              {
                nix-homebrew = {
                  enable = true;
                  enableRosetta = true;
                  user = "camille";
                  mutableTaps = true;
                  taps = {
                    "homebrew/homebrew-core" = inputs.homebrew-core;
                    "homebrew/homebrew-cask" = inputs.homebrew-cask;
                    "homebrew/homebrew-bundle" = inputs.homebrew-bundle;
                    "gromgit/homebrew-fuse" = inputs.homebrew-fuse;
                    "waydabber/homebrew-betterdisplay" = inputs.homebrew-betterdisplay;
                    "Kegworks-App/homebrew-kegworks" = inputs.homebrew-kegworks;
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
        in
        {
          "NixLaptop" = nixpkgs.lib.nixosSystem {
            specialArgs = {
              inherit self system inputs;
            };
            modules = [
              ./config/nixos/default.nix
              {
                nixos-system.stylix.enable = true;
                nixos-system.plasma6.enable = false;
                nixos-system.hyprland.enable = true;
              }
              ./packages/nix/default.nix
              {
                NIXPKG.linuxApps.enable = true;
              }
              home-manager.nixosModules.home-manager
              {
                home-manager.useGlobalPkgs = true;
                home-manager.useUserPackages = true;
                home-manager.backupFileExtension = "bak";
                home-manager.users.camille = {
                  # {...} can be replaced by import ./path/to/module.nix
                  imports = [
                    ./home/nixos/default.nix
                  ];
                  home-config.GUIapps.enable = true;
                  home-config.hyprland.enable = true;
                };
              }
              stylix.nixosModules.stylix
            ];
          };
        };
      # Expose the package set, including overlays, for convenience.
      darwinPackages = self.darwinConfigurations."MacBookAirCam-M3".pkgs;
    };
}
