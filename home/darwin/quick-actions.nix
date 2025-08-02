{
  pkgs,
  lib,
  config,
  ...
}:
{
  home.file."Library/Services/Force Unmount.workflow".source = ../configs/Force-Unmount.workflow;
  home.file."Library/Services/Make Symlink.workflow".source = ../configs/Make-SymLink.workflow;
}
