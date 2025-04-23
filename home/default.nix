{ pkgs, lib, ... }:
{
    imports = [
        ./home-config.nix
    ];
    home-config.GUIapps.enable = lib.mkDefault false;
}
