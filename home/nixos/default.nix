{ pkgs, lib, global-config, ... }:
{
  imports = [
    ../default.nix
    ./home-config.nix
  ];

  options = {
    home-config.desktopManager.wallpaper = lib.mkOption {
      type = lib.types.path;
      default = "";
      example = lib.literalExpression ''/ressources/wallpaper.png'';
      description = ''
        Set the default wallpaper
      '';
    };
    home-config.userPicture = lib.mkOption {
      type = lib.types.path;
      default = "";
      example = lib.literalExpression ''/ressources/user-picture.png'';
      description = ''
        Sets the default user picture
      '';
    };
  };

  config = {
    home-config.GUIapps.enable = lib.mkDefault false;
    home-config.hyprland.enable = lib.mkDefault false;
    home-config.plasma.enable = lib.mkDefault false;
    home-config.fastfetch.osString = "|\\|ixOS  ";
    home-config.desktopManager.wallpaper = lib.mkDefault global-config.common.stylix.wallpaper;
  };
}
