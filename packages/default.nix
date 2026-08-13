{ lib, ... }:
{
  imports = [
    ./nix.nix
    ./homebrew.nix
  ];
  system-pkgs.coreUtils = lib.mkDefault true;
  system-pkgs.additionnals.enable = lib.mkDefault true;
  system-pkgs.GUIapps.enable = lib.mkDefault true;
  system-pkgs.darwinApps.enable = lib.mkDefault false;
  system-pkgs.linuxApps.enable = lib.mkDefault false;
  homebrew-pkgs.enable = lib.mkDefault true;
  homebrew-pkgs.coreUtils = lib.mkDefault true;
  homebrew-pkgs.casks.enable = lib.mkDefault true;
  homebrew-pkgs.brews.enable = lib.mkDefault true;
  homebrew-pkgs.masApps.enable = lib.mkDefault false;
}
