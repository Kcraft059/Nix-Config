{
  pkgs,
  lib,
  config,
  ...
}:
{
  imports = [
    ./nix-conf.nix #
    ./nixos-system.nix
  ];
  nix-conf.garbage-collect.enable = lib.mkDefault true;
  nixos-system.enable = lib.mkDefault true;
  nixos-system.stylix.enable = lib.mkDefault false;
  nixos-system.plasma6.enable = lib.mkDefault true;
}
