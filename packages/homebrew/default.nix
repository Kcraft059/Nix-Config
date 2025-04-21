{ pkgs, lib, ... }:
{
    imports = [
        ./homebrew.nix
    ];
    HMB.enable = lib.mkDefault true;
    HMB.casks.enable = lib.mkDefault true;
    HMB.brews.enable = lib.mkDefault true;
    HMB.masApps.enable = lib.mkDefault false;
}
