{ pkgs, lib, ... }:
{
  programs.atuin = {
    enable = true;
    enableZshIntegration = true;
    settings = {
    }
    // lib.optionals config.external-drive.enable {
      db_path = "/Volumes/Data/camille/Apps-Data/Atuin/history.db";
    };
  };
}
