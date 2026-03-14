{ pkgs, lib, ... }:
let
  inherit (lib)
    mkDefault
    mkOption
    mkEnableOption
    types
    ;
in
{
  imports = [
    ./yabai.nix
    ./aerospace.nix
    ./skhd.nix
    ./rift.nix
  ];

  options.darwin-system.window-man = {
    enable = mkEnableOption "Whether to enable the WM Service";
    type = mkOption {
      type = types.enum [
        "yabai"
        "aerospace"
        "rift"
      ];
      default = "yabai";
      description = "Macos WM";
    };
  };

  config = {
    darwin-system.window-man.enable = lib.mkDefault false;
  };
}
