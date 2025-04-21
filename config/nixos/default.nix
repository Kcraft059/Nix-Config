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
  nixos-system.enable = lib.mkDefault true;
  nix-conf.garbage-collect.enable = lib.mkDefault true;
}
