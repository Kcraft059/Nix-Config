{
  pkgs,
  lib,
  config,
  ...
}:
{
  home.file."Library/Services/Force Unmount.workflow".source = ../../resources/Force-Unmount.workflow;
  home.file."Library/Services/Make Symlink.workflow".source = ../../resources/Make-SymLink.workflow;
}
