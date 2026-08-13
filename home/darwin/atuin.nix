{ lib, config, ... }:
{
  programs.atuin.settings = lib.mkIf config.home-config.external-drive.enable {
    db_path = "/Volumes/Data/camille/Apps-Data/Atuin/history.db";
  };
}
