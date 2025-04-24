{ pkgs, lib, ... }:
{
  imports = [
    ../default.nix
    ./home-config.nix
  ];
  home-config.GUIapps.enable = lib.mkDefault false;
  home-config.hyprland.enable = lib.mkDefault false;
  home-config.fastfetch.osString = "|\\|ixOS  ";
}
