{ pkgs, lib, ... }:
{
  imports = [
    ./yabai.nix
    ./aerospace.nix
    ./skhd.nix
  ];

  config.darwin-system.window-man = {
    enable = lib.mkEnableOption "Whether to enable the WM Service";
    type = lib.mkOption {
      type = lib.types.str;
      default = "yabai";
      example = lib.literalExpression ''yabai/aerospace'';
      description = ''
        Which wm should be used ?
      '';
    };
  };
  
  darwin-system.window-man.enable = lib.mkDefault false;
}
