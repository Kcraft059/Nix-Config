{
  config,
  lib,
  pkgs,
  ...
}:
{
  options = { 
    home-config.plasma.enable = lib.mkEnableOption ''Enable Plasma configuration and its plugins'';
  };
  config = lib.mkIf config.home-config.plasma.enable {
    stylix.targets.gtk.enable = false;
    #home.file.".gtkrc-2.0".force = lib.mkForce true;
  };
}
