{
  config,
  lib,
  pkgs,
  ...
}:
{
  imports = [
    # Include the results of the hardware scan.
    ## [IMPURE]
    /etc/nixos/hardware-configuration.nix
  ];

  config = {
  };
}
