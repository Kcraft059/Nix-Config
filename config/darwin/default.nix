{
  pkgs,
  lib,
  config,
  ...
}:
{
  imports = [
    ./nix-conf.nix #
    ./darwin-system.nix
  ];
  darwin-system.enable = lib.mkDefault true;
  darwin-system.defaults.enable = lib.mkDefault true;
  darwin-system.defaults.dock.enable = lib.mkDefault false;
  nix-conf.garbage-collect.enable = lib.mkDefault true;
}
