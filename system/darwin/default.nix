{ lib, ... }:
{
  imports = [
    ./nix.nix
    ./pkgs.nix
    ./system.nix
    ./wacom-driver.nix
    ./homebrew.nix
    ./window-man/default.nix
    ../common/default.nix
  ];
  darwin-system.enable = lib.mkDefault true;
  darwin-system.defaults.enable = lib.mkDefault true;
  darwin-system.defaults.dock.enable = lib.mkDefault false;
  darwin-system.external-drive.enable = lib.mkDefault false;
  darwin-system.wacom-driver.enable = lib.mkDefault false;
  darwin-system.wacom-driver.auto-run = lib.mkDefault false;

  nix-conf.garbage-collect.enable = lib.mkDefault true;

  homebrew-pkgs.enable = lib.mkDefault true;
  homebrew-pkgs.core = lib.mkDefault true;
  homebrew-pkgs.casks = lib.mkDefault true;
  homebrew-pkgs.brews = lib.mkDefault true;
  homebrew-pkgs.mas = lib.mkDefault false;
}
