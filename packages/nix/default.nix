{ pkgs, lib, ... }:
{
    imports = [
        ./nixpackages.nix
    ];
    NIXPKG.GUIapps.enable = lib.mkDefault true;
    NIXPKG.darwinApps.enable = lib.mkDefault false;
}
