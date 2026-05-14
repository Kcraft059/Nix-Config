{ inputs }:
self: super: {
  rpi-keyboard-config = super.callPackage ./rpi-keyboard-config.nix { };
  menubar-cli = super.callPackage ./menubar-cli.nix { };
  ft-haptic = super.callPackage ./ft-haptic.nix { };
  raycast = super.callPackage ./raycast.nix { };
  rift = super.callPackage ./rift.nix { inherit inputs; };
}
