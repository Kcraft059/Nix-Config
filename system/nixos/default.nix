{ lib, ... }:
{
  imports = [
    ./system.nix
    ./nix.nix
    ./plasma.nix
    ../common/default.nix
  ];

  nixos-system.plasma6.enable = lib.mkDefault false;
  nix-conf.garbage-collect.enable = lib.mkDefault true;
}
