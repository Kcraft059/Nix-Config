{ pkgs, lib, ... }:
{
  imports = [
    ../default.nix
    ./home-config.nix
  ];
  home-config.GUIapps.enable = lib.mkDefault false;
  hyprland.enable = lib.mkDefault false;
}
