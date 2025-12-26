{
  config,
  lib,
  pkgs,
  ...
}:
let
  plasma-enable = config.nixos-system.plasma6.enable;
in
{
  options = {
    nixos-system.plasma6.enable = lib.mkEnableOption "Whether to enable the Nixos-Config";
  };

  config = lib.mkIf plasma-enable {

    stylix.targets.kde.enable = false;
    stylix.targets.kde.useWallpaper = false;
    
    # Enable the X11 windowing system.
    services.xserver = {
      enable = true;
      xkb = {
        layout = "fr";
        variant = "";
      };
    };

    services.desktopManager.plasma6.enable = true;
    services.displayManager.sddm = {
      enable = true;
      #wayland.enable = true;
    };

    environment.systemPackages = with pkgs; [
      kdePackages.qtstyleplugin-kvantum
    ];

    /*
      xdg.portal = {
        enable = true;
        extraPortals = [ pkgs.kdePackages.xdg-desktop-portal-kde ];
      };
    */
  };
}
