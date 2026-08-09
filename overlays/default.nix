{ inputs }:
self: super: {
  rpi-keyboard-config = super.callPackage ./rpi-keyboard-config.nix { };
  menubar-cli = super.callPackage ./menubar-cli.nix { };
  ft-haptic = super.callPackage ./ft-haptic.nix { };
  raycast = super.callPackage ./raycast.nix { };
  rift = super.callPackage ./rift.nix { inherit inputs; };
  libresprite-app = super.callPackage ./libresprite-app.nix { };
  wacom-tablet-driver = super.callPackage ./wacom-tablet-driver.nix { };

  yabai-patch = import ./yabai.nix { inherit super; };
}
