{
  pkgs,
  lib,
  config,
  ...
}:
{
  programs.atuin = {
    enable = true;
    enableZshIntegration = true;
    settings = {
      enter_accept = true;
      style = "auto";
    }
    // lib.optionalAttrs config.home-config.external-drive.enable {
      db_path = "/Volumes/Data/camille/Apps-Data/Atuin/history.db";
    };
  };
}
