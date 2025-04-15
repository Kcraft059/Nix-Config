{ pkgs, lib, ... }:
{
    imports = [
        ./home-config.nix
    ];
    home-config.darwinApps.enable = lib.mkDefault false;
}
