{ pkgs, lib, ... }:
{
  imports = [
    ../default.nix
    ./home-config.nix
  ];
  home-config.GUIapps.enable = lib.mkDefault false;
  home-config.fastfetch.logo = "~/.config/fastfetch/darwin.txt";
  home-config.fastfetch.osString = "/\\/\\acOS ";
}
