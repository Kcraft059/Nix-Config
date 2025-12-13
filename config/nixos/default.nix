{
  pkgs,
  lib,
  config,
  ...
}:
{
  imports = [
    ./nix-conf.nix
    ./nixos-system.nix
    ../common/stylix.nix
  ];
  nixos-system.enable = lib.mkDefault true;
  nixos-system.plasma6.enable = lib.mkDefault true;
  nixos-system.hyprland.enable = lib.mkDefault false;
  nix-conf.garbage-collect.enable = lib.mkDefault true;
  common.stylix.enable = lib.mkDefault false;
}
