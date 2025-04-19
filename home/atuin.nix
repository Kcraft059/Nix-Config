{ pkgs, lib, ... }:
{
  programs.atuin = {
    enable = true;
    enableZshIntegration = true;
    /* config = {
    db_path = "~/.history.db";
    }; */
  };
}
