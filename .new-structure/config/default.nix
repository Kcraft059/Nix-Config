{ pkgs, lib, ... }:
{
    imports = [
        ./nix-conf.nix
        ./darwin-system.nix
    ];
    nix-conf.garbage-collect.enable = lib.mkDefault true;
    darwin-system.enable = lib.mkDefault false;
    darwin-system.defaults.enable = lib.mkDefault true;
    darwin-system.defaults.dock.enable = lib.mkDefault true;
}
