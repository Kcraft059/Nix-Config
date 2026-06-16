{ config, lib, ... }:
{
  options.HMB = {
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
      enable = config.HMB.enable;
      casks = # See https://nix-darwin.github.io/nix-darwin/manual/#opt-homebrew.casks
        lib.optionals config.HMB.coreUtils [
          "ghostty"
          "font-sf-pro"
          "BetterDisplay"
          "Raycast"
        ]
        ++ lib.optionals config.HMB.brews.enable [
          "macfuse"
        ]
        ++ lib.optionals config.HMB.casks.enable [
          # Utilities
          "disk-inventory-x"
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
          #"sirakugir"
          #"binary-ninja-free"
          #"picoscope"

          # Media
          "vlc"
          #"iina"
          "kid3"
          "gimp"
          #"makemkv"

          # Other
          "claude"
          "discord"
          "google-chrome"
          #"dockdoor"
          #"alcove"

          # Games
          "steamcmd"
          "prismlauncher"
          "steam"
          #"gog-galaxy"
        ];
      brews = # See https://nix-darwin.github.io/nix-darwin/manual/#opt-homebrew.brews
        lib.optionals config.HMB.coreUtils [
          #"tccutil"
        ]
        ++ lib.optionals config.HMB.brews.enable [
          #"batt"
          "betterdisplaycli"

          # System tooling
          "dyld-shared-cache-extractor"
          "ldid"

          "ext4fuse-mac" # sudo ext4fuse <diskXsX> <mountPoint> -o allow_other -o umask=000
          "sshfs-mac" # sshfs <user>@<host>:<dir> <mountPoint> -o identityFile=<pathToSSH-Key>
          "ntfs-3g-mac"

          # dependencies -> declare to prevent uninstall
          "ca-certificates"
          "libunistring"
          "gettext"
          "mpdecimal"
          "openssl@3"
          "pcre2"
          "python-packaging"
          "readline"
          "sqlite"
          "xz"
          "python@3.13"
          "glib"
        ]
        ++ lib.optionals config.HMB.masApps.enable [
          "mas"
        ]
        ++ lib.optionals config.home-manager.users.camille.programs.sketchybar.enable [
          "media-control"
        ];

      masApps = lib.mkIf config.HMB.masApps.enable {
        # See https://nix-darwin.github.io/nix-darwin/manual/#opt-homebrew.masApps
        # "unfortunately apps removed from this option will not be uninstalled automatically even if homebrew.onActivation.cleanup is set to "uninstall" or "zap""
        actions = 1586435171;
        Ferromagnetic = 1546537151;
        Pdf-Gear = 6469021132;
        prettyJsonSafari = 1445328303;
        Xcode = 497799835;
        Whatsapp = 310633997;
        KeyNote = 409183694;
        FolderQuickLook = 6753110395;
        wBlock = 6746388723;
        #AppleConfigurator = 1037126344;
        #amphetamine = 937984704;
        #Testflight = 899247664;
        #CrystalFetch = 6454431289;
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
