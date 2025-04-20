{
  pkgs,
  lib,
  config,
  ...
}:
{
  options = {
    nixos-system.enable = lib.mkEnableOption "Whether to enable the Nixos-Config";
    darwin-system.enable = lib.mkEnableOption "Whether to enable the Nixos-Config";
  };

  imports =
    [
      ./nix-conf.nix
    ]
    ++ lib.optionals config.darwin-system.enable [
      ./darwin-system.nix
      {
        darwin-system.enable = lib.mkDefault false;
        darwin-system.defaults.enable = lib.mkDefault true;
        darwin-system.defaults.dock.enable = lib.mkDefault true;
      }
    ]
    ++ lib.optionals config.nixos-system.enable [
      ./nixos-system.nix
      {
        nixos-system.enable = lib.mkDefault true;
      }
    ];
  nix-conf.garbage-collect.enable = lib.mkDefault true;

}
