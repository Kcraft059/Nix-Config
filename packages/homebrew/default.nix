{ lib, ... }:
{
  imports = [
    ./homebrew.nix
  ];
  homebrew-pkgs.enable = lib.mkDefault true;
  homebrew-pkgs.coreUtils = lib.mkDefault true;
  homebrew-pkgs.casks.enable = lib.mkDefault true;
  homebrew-pkgs.brews.enable = lib.mkDefault true;
  homebrew-pkgs.masApps.enable = lib.mkDefault false;
}
