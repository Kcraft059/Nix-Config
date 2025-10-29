{ pkgs, lib, ... }:
{
  programs.atuin = {
    enable = true;
    enableZshIntegration = true;
    settings = {
      db_path = "/Volumes/Data/camille/Apps-Data/Atuin/history.db";
    };
  };
}
