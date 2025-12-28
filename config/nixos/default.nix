{
  pkgs,
  lib,
  config,
  ...
}:
{
  imports = [
    ../common/stylix.nix
    ./nixos-system.nix
    ./nix-conf.nix
    ./plasma.nix
  ];

  nixos-system.plasma6.enable = lib.mkDefault false;
  nixos-system.hyprland.enable = lib.mkDefault false;
  nix-conf.garbage-collect.enable = lib.mkDefault true;
  common.stylix.enable = lib.mkDefault false;
}
