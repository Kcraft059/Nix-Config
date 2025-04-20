{
  description = "Polyglot Nix-system config for all my devices - Kcraft059";

  inputs = {

    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";

    nix-darwin.url = "github:nix-darwin/nix-darwin";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs";

    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    nix-homebrew.url = "github:zhaofengli-wip/nix-homebrew"; # Nix homebrew
    nix-homebrew.inputs.nixpkgs.follows = "nixpkgs";

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
  };

  outputs =
    {
      self,
      nixpkgs,
      nix-darwin,
      home-manager,
      nix-homebrew,
      homebrew-core,
      homebrew-cask,
      homebrew-bundle,
      homebrew-fuse,
      ...
    }@inputs: # Allow for access to optionnal inputs with inputs.optionnalInput
    let
      overlays = [
        #(import ./overlays/mas.nix)
        (import ./overlays/fancy-folder.nix)
        (import ./overlays/battery-toolkit.nix)
      ];
    in
    {
      darwinConfigurations =
        let
          system = "aarch64-darwin";
          pkgs = import nixpkgs {
            inherit system overlays;
            config.allowUnfree = true;
          };
        in
        {
          "MacOSCam" = nix-darwin.lib.darwinSystem {
            specialArgs = {
              inherit self pkgs;
            };
            modules = [
              ./config/default.nix
              {
                darwin-system.enable = true;
              }
              ./packages/default.nix
              {
                HMB.masApps.enable = true; # mdutil #check for spotlight indexing
                NIXPKG.darwinApps.enable = true;
              }
              home-manager.darwinModules.home-manager
              {
                home-manager.useGlobalPkgs = true;
                home-manager.useUserPackages = true;
                home-manager.users.camille = {
                  # {...} can be replaced by import ./path/to/module.nix
                  imports = [
                    ./home/default.nix
                  ];
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
                    "homebrew/homebrew-core" = homebrew-core;
                    "homebrew/homebrew-cask" = homebrew-cask;
                    "homebrew/homebrew-bundle" = homebrew-bundle;
                    "gromgit/homebrew-fuse" = homebrew-fuse;
                  };
                };
              }
            ];
          };
        };
      nixosConfigurations =
        let
          system = "x86_64-linux";
          pkgs = import nixpkgs {
            inherit system overlays;
            config.allowUnfree = true;
          };
        in
        {
          "NixOSCAm" = {
            specialArgs = {
              inherit self pkgs;
            };
            modules = [
              ./config/default.nix
              ./packages/default.nix {
                HMB.enable = false;
              }
              home-manager.nixosModules.home-manager {
                home-manager.useGlobalPkgs = true;
                home-manager.useUserPackages = true;
              }
            ];
          };
        };
      # Expose the package set, including overlays, for convenience.
      darwinPackages = self.darwinConfigurations."MacOSCam".pkgs;
    };
}
