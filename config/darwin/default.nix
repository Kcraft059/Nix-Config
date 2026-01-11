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
    #./window-man.nix
    ./window-man/default.nix
    ../common/stylix.nix
  ];
  darwin-system.enable = lib.mkDefault true;
  darwin-system.defaults.enable = lib.mkDefault true;
  darwin-system.defaults.dock.enable = lib.mkDefault false;
  darwin-system.external-drive.enable = lib.mkDefault false;
  nix-conf.garbage-collect.enable = lib.mkDefault true;
  common.stylix.enable = lib.mkDefault true;
}
