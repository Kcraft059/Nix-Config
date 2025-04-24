{ pkgs, lib, ... }:
{
  programs.btop = {
    enable = true;
    extraConfig = ''
      #? Config file for btop v. 1.4.0
    '';
    settings = {
      color_theme = lib.mkDefault "Default";
      theme_background = false;
      proc_tree = true;
    };
  };
}
