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

    # Enable the X11 windowing system (login primarly)
    services.xserver = {
      enable = true;
      xkb = {
        layout = "fr";
        variant = "";
      };
    };

    # Enable plasma desktop manager
    services.desktopManager.plasma6.enable = true;
    services.displayManager.sddm = {
      enable = true;
      wayland.enable = true;
    };

/*     stylix.targets = {
      qt.enable = true;
      qt.platform = "kde";
    }; */
  };
}
