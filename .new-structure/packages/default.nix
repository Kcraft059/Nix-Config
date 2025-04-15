{ pkgs, lib, ... }:
{
    imports = [
        ./homebrew.nix
        ./nixpackages.nix
    ];
    NIXPKG.GUIapps.enable = lib.mkDefault true;
    NIXPKG.darwinApps.enable = lib.mkDefault false;
    HMB.enable = lib.mkDefault true;
    HMB.casks.enable = lib.mkDefault true;
    HMB.brews.enable = lib.mkDefault true;
    HMB.masApps.enable = lib.mkDefault false;
}
