{ pkgs, lib, ... }:
{
  home.packages = [ pkgs.fastfetch ];
  home.file.".config/fastfetch/logo.txt".source = ./configs/fastfetch-logo.txt;
  home.file.".config/fastfetch/config.jsonc".source = ./configs/fastfetch.jsonc;
}
