{ inputs }:
self: super: {
  wifi-unredactor = super.callPackage ./wifi-unredactor.nix { /* inherit inputs; */ };
  smc-cli = super.callPackage ./smc-cli.nix { };
  # rift = super.callPackage ./smc-cli.nix { };
  menubar-cli = super.callPackage ./menubar-cli.nix { };
  krita-mac = super.callPackage ./krita-mac.nix { };
  fancyfolder = super.callPackage ./fancy-folder.nix { };
  backdrop-app = super.callPackage ./backdrop.nix { };
  battery-toolkit = super.callPackage ./battery-toolkit.nix { };
  rift = super.callPackage ./rift.nix { inherit inputs; };
}
