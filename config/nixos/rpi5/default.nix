{
  pkgs,
  lib,
  config,
  ...
}:
{
  imports = [
    ../default.nix
    ./nixos-system.nix
  ];
}
