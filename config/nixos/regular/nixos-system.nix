{ ... }:
{
  imports = [
    # Include the results of the hardware scan.
    ## [IMPURE]
    ./hardware-configuration.nix
  ];

  config = {
    # Bootloader settings
    boot.loader.systemd-boot.enable = true;
    boot.loader.efi.canTouchEfiVariables = true;
  };
}
