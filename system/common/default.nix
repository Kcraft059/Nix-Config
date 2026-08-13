{ lib, ... }: {
  imports = [
    ./nix.nix
    ./pkgs.nix
    ./theme/default.nix
  ];
  system-pkgs.core = lib.mkDefault true;
  system-pkgs.additionnals = lib.mkDefault false;
  system-pkgs.gui = lib.mkDefault false;
}
