{ pkgs, lib, ... }:
{
  imports = [
    ./btop.nix
  ];

  btop.enable = lib.mkDefault false;
}
