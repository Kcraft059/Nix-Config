{ pkgs, lib, global-config, ... }:
{
  imports = [
    ../default.nix
    ./home-config.nix
  ];
  home-config.GUIapps.enable = lib.mkDefault false;
  home-config.status-bar.enable = lib.mkDefault false;
  home-config.darwinApps.enable = lib.mkDefault false;
  home-config.fastfetch.logo = "${../configs/fastfetch-logo.txt}";
  home-config.fastfetch.osString = "/\\/\\acOS ";
  home-config.external-drive.enable = lib.mkDefault global-config.darwin-system.external-drive.enable;
  home-config.external-drive.path = lib.mkDefault global-config.darwin-system.external-drive.path;
}
