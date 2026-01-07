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
    environment.systemPackages = with pkgs; [
      # Hardware interaction tools
      libgpiod
      i2c-tools
      rpi-keyboard-config
    ];

    hardware.i2c.enable = true;

    # Export pwm to sysfs

    hardware.raspberry-pi.config.all = {
      dt-overlays.pwm = {
        enable = true;
        params = {
          pin = {
            enable = true;
            value = 18;
          };
          func = {
            enable = true;
            value = 2;
          };
        };
      };
    };

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
