{ pkgs, lib, ... }:
{
  imports = [
    ./nixpackages.nix
  ];
  NIXPKG.coreUtils = lib.mkDefault true;
  NIXPKG.additionnals.enable = lib.mkDefault true;
  NIXPKG.GUIapps.enable = lib.mkDefault true;
  NIXPKG.darwinApps.enable = lib.mkDefault false;
  NIXPKG.linuxApps.enable = lib.mkDefault false;
}
