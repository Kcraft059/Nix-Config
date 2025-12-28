{ pkgs, lib, ... }:
{
  imports = [
    ../default.nix
    ./home-config.nix
  ];
}
