{ config, lib, ... }:
{
  options.homebrew-pkgs = {
    enable = lib.mkEnableOption "Whether to enable the whole homebrew module";
    coreUtils = lib.mkEnableOption "Core utilities ?";
    brews.enable = lib.mkEnableOption "Whether to enable brews";
    casks.enable = lib.mkEnableOption "Whether to enable casks";
    masApps.enable = lib.mkEnableOption "Whether to enable masApps";
  };

  config = {
    # Pre-activation patches
    system.activationScripts.homebrew.text = lib.mkBefore (
      ''
        echo -e "Running Patches for Homebrew bundle..." >&2
      ''
      + (lib.concatStringsSep "\n" (
        map (
          tap: "su - ${config.nix-homebrew.user} -c '/opt/homebrew/bin/brew trust ${tap.name} > /dev/null';"
        ) config.homebrew.taps
      ))
      + lib.optionalString (builtins.any (c: c.name == "macfuse") config.homebrew.casks) ''
        echo -e "Patching macFuse dependency..." >&2
        touch /usr/local/include/fuse.h
      ''
    );

    homebrew = {
      enable = config.homebrew-pkgs.enable;
      casks = # See https://nix-darwin.github.io/nix-darwin/manual/#opt-homebrew.casks
        lib.optionals config.homebrew-pkgs.coreUtils [
          "ghostty"
          "font-sf-pro"
          "BetterDisplay"
          "Raycast"
        ]
        ++ lib.optionals config.homebrew-pkgs.brews.enable [
          "macfuse"
        ]
        ++ lib.optionals config.homebrew-pkgs.casks.enable [
          # Utilities
          "lulu"
          "knockknock"
          "hex-fiend"
          "deskflow"
          "appcleaner"
          "whisky"
          "the-unarchiver"
          "balenaetcher"
          "suspicious-package"
          "protonvpn"
          "sf-symbols"
          "macusb"
          "disk-inventory-x"
          #"picoscope"

          # Media
          "vlc"
          "kid3"
          "gimp"

          # Other
          "claude"
          "discord"

          # Games
          "steamcmd"
          "steam"
          "gog-galaxy"
        ];
      brews = # See https://nix-darwin.github.io/nix-darwin/manual/#opt-homebrew.brews
        lib.optionals config.homebrew-pkgs.coreUtils [
          # System tooling
          "dyld-shared-cache-extractor"
        ]
        ++ lib.optionals config.homebrew-pkgs.brews.enable [
          "betterdisplaycli"

          # "ext4fuse-mac" # sudo ext4fuse <diskXsX> <mountPoint> -o allow_other -o umask=000
          # "sshfs-mac" # sshfs <user>@<host>:<dir> <mountPoint> -o identityFile=<pathToSSH-Key>
          # "ntfs-3g-mac"
          #
          # # dependencies -> declare to prevent uninstall
          # "ca-certificates"
          # "libunistring"
          # "gettext"
          # "mpdecimal"
          # "openssl@3"
          # "pcre2"
          # "python-packaging"
          # "readline"
          # "sqlite"
          # "xz"
          # "python@3.13"
          # "glib"
        ]
        ++ lib.optionals config.homebrew-pkgs.masApps.enable [
          "mas"
        ]
        ++ lib.optionals config.home-manager.users.camille.programs.sketchybar.enable [
          "media-control"
        ];

      masApps = lib.mkIf config.homebrew-pkgs.masApps.enable {
        # See https://nix-darwin.github.io/nix-darwin/manual/#opt-homebrew.masApps
        # "unfortunately apps removed from this option will not be uninstalled automatically even if homebrew.onActivation.cleanup is set to "uninstall" or "zap""
        actions = 1586435171;
        Ferromagnetic = 1546537151;
        Pdf-Gear = 6469021132;
        prettyJsonSafari = 1445328303;
        Xcode = 497799835;
        wBlock = 6746388723;
      };

      taps = [
        "homebrew/homebrew-cask"
        "homebrew/homebrew-core"
        "homebrew/homebrew-bundle"
        "gromgit/homebrew-fuse"
        "waydabber/homebrew-betterdisplay"
        "Sirakugir-App/homebrew-sirakugir"
        "deskflow/homebrew-tap"
        "keith/formulae"
      ];
      onActivation.autoUpdate = true;
      onActivation.upgrade = true;
      onActivation.cleanup = "zap";
    };
  };
}
