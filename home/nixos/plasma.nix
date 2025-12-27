{
  config,
  libs,
  pkgs,
  ...
}:
{
  options = { 
    home-config.plasma.enable = lib.mkEnableOption ''Enable Plasma configuration and its plugins'';
  };
  config = lib.mkIf config.home-config.plasma.enable {
    xdg.configFile."../.gtkrc-2.0".force = true;
  };
}
