{ lib, ... }:
{
  imports = [
    ./nixpackages.nix
  ];
  system-pkgs.coreUtils = lib.mkDefault true;
  system-pkgs.additionnals.enable = lib.mkDefault true;
  system-pkgs.GUIapps.enable = lib.mkDefault true;
  system-pkgs.darwinApps.enable = lib.mkDefault false;
  system-pkgs.linuxApps.enable = lib.mkDefault false;
}
