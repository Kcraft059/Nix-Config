# Rift configuration module
{
  pkgs,
  config,
  lib,
  ...
}:
let
  common = import ./common-options.nix { inherit config pkgs; };

  # Enable options
  enable-rift = common.enable-rift && common.enable-wm;
in
{
  imports = [ ./rift-modules/rift.nix ];

  config = {
    services.rift = {
      enable = enable-rift;
      config = "AAAA";
    }
  }
}
