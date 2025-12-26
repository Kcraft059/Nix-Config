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

  disabledModules = [
    "nixos/modules/rename.nix"
  ];

  config = {
    ## RPI Boot loader & kernel - do not touch.
    boot.loader.raspberryPi.bootloader = "kernel";

    system.nixos.tags =
      let
        cfg = config.boot.loader.raspberryPi;
      in
      [
        "raspberry-pi-${cfg.variant}"
        cfg.bootloader
        config.boot.kernelPackages.kernel.version
      ];
  };
}
