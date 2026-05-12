{ pkgs, lib, ... }:
{
  imports = [
  ];

  config = {
    # Special ovverides for system
    programs.firefox.package = pkgs.firefox-bin;
    programs.ghostty.enable = lib.mkForce false;
  };
}
