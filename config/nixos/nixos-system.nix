{
  pkgs,
  config,
  lib,
  inputs,
  ...
}:
{
  imports = [
    ./nix-conf.nix
    ./plasma.nix
  ];

  options = {
    nixos-system.hyprland.enable = lib.mkEnableOption "Whether to enable the Nixos-Config";
  };

  config = {

    ## Networking
    networking.networkmanager.enable = true;
    # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

    # Open ports in the firewall.
    networking.firewall.allowedTCPPorts = [ 22 ];
    networking.firewall.allowedUDPPorts = [ 22 ];

    # Enable the OpenSSH daemon.
    services.openssh.enable = true;
    services.openssh.allowSFTP = true;

    ## General system config
    # No sudo shutdown when on device
    security.rtkit.enable = true;

    # Internationalisation properties.
    time.timeZone = "Europe/Paris";
    i18n.defaultLocale = "en_US.UTF-8";
    i18n.extraLocaleSettings = {
      LC_ADDRESS = "fr_FR.UTF-8";
      LC_IDENTIFICATION = "fr_FR.UTF-8";
      LC_MEASUREMENT = "fr_FR.UTF-8";
      LC_MONETARY = "fr_FR.UTF-8";
      LC_NAME = "fr_FR.UTF-8";
      LC_NUMERIC = "fr_FR.UTF-8";
      LC_PAPER = "fr_FR.UTF-8";
      LC_TELEPHONE = "fr_FR.UTF-8";
      LC_TIME = "fr_FR.UTF-8";
    };

    console.keyMap = "fr";

    ## Hardware config
    # Audio + video
    hardware.graphics.enable = true;

    environment.systemPackages = with pkgs; [
      mesa
      mesa-demos
    ];

    services.pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
      wireplumber.enable = true;
    };
    services.pulseaudio.enable = false;

    # Enable CUPS to print documents.
    services.printing.enable = true;

    # Bluetooth
    hardware.bluetooth.enable = true; # enables support for Bluetooth
    hardware.bluetooth.powerOnBoot = true;

    ## User config
    programs.zsh.enable = true;
    users.defaultUserShell = pkgs.zsh;

    # Define a user account. Don't forget to set a password with ‘passwd’.
    users.users.camille = {
      isNormalUser = true;
      description = "Camille T";
      hashedPasswordFile = config.sops.secrets.camille-passwd.path;
      extraGroups = [
        "networkmanager"
        "wheel"
      ];
    };

    ## Hyprland config

    programs.hyprland = {
      enable = config.nixos-system.hyprland.enable;
      #package = inputs.hyprland.packages."${pkgs.system}".hyprland;
      xwayland.enable = config.nixos-system.hyprland.enable;
      #nvidiaPatches = true;
      /*
        xwayland = {
          hidpi = true;
          enable = true;
        };
      */
    };

    /*
      xdg.portal = {
        enable = true;
        xdgOpenUsePortal = true;

        extraPortals = [
          pkgs.xdg-desktop-portal-hyprland
        ];
      };
    */

    # This value determines the NixOS release from which the default
    # settings for stateful data, like file locations and database versions
    # on your system were taken. It‘s perfectly fine and recommended to leave
    # this value at the release version of the first install of this system.
    # Before changing this value read the documentation for this option
    # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
    system.stateVersion = "25.05"; # Did you read the comment?
  };
}
