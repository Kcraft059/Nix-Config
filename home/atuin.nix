{ pkgs, lib, config, ... }:
{
  programs.atuin = {
    enable = true;
    enableZshIntegration = true;
    settings = {
    }
    // lib.optionals config.home-config.external-drive.enable {
      db_path = "/Volumes/Data/camille/Apps-Data/Atuin/history.db";
    };
  };
}
