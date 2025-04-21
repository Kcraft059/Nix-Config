{ pkgs, lib, ... }:
{
    imports = [
        ./home-config.nix
    ];
    home-config.darwinApps.enable = lib.mkDefault false;
    home-config.linuxApps.enable = lib.mkDefault false;
}
