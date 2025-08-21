{
  pkgs,
  lib,
  config,
  ...
}:
{
  imports = [
    ./nix-conf.nix
    ./darwin-system.nix
    ./window-man.nix
    ../common/stylix.nix
  ];
  darwin-system.enable = lib.mkDefault true;
  darwin-system.window-man.enable = lib.mkDefault false;
  darwin-system.defaults.enable = lib.mkDefault true;
  darwin-system.defaults.dock.enable = lib.mkDefault false;
  nix-conf.garbage-collect.enable = lib.mkDefault true;
  common.stylix.enable = lib.mkDefault true;
}
