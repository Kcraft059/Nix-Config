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
    environment.systemPackages =
      with pkgs;
      [
        # Hardware interaction tools
        libgpiod
        i2c-tools
        rpi-keyboard-config
        raspberrypi-utils
      ]
      ++ [
        config.boot.kernelPackages.kernel.dev # Might cause long compilation
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
    boot.loader.raspberry-pi.bootloader = "kernel";
    boot.kernelPatches = [
      {
        name = "allow devmem";
        structuredExtraConfig = {
          STRICT_DEVMEM = lib.kernel.no;
          IO_STRICT_DEVMEM = lib.kernel.no;
        };
      }
    ];

    system.nixos.tags =
      let
        cfg = config.boot.loader.raspberry-pi;
      in
      [
        "raspberry-pi-${cfg.variant}"
        cfg.bootloader
        config.boot.kernelPackages.kernel.version
      ];
  };
}
