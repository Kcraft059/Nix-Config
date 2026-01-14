{
  pkgs,
  config,
  lib,
  ...
}:
{
  options.HMB = {
    enable = lib.mkEnableOption "Whether to enable the whole homebrew module";
    coreUtils = lib.mkEnableOption "Core utilities ?";
    brews.enable = lib.mkEnableOption "Whether to enable brews";
    casks.enable = lib.mkEnableOption "Whether to enable casks";
    masApps.enable = lib.mkEnableOption "Whether to enable masApps";
  };

  config = {
    homebrew = {
      enable = config.HMB.enable;
      casks =
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
          #"sirakugir"
          "the-unarchiver"
          "balenaetcher"
          "suspicious-package"
          #"binary-ninja-free"
          
          # Media
          "vlc"
          "iina"
          "kid3"
          #"audacity" # Provided by nix
          #"makemkv"
          "gimp"

          # Other
          "sf-symbols"
          "chatgpt"
          "discord"
          #"firefox"
          "google-chrome"
          "steamcmd"
          "prismlauncher"
          "gog-galaxy"
          "steam"
          #"Alcove"
        ];
      brews =
        lib.optionals config.HMB.coreUtils [
          "tccutil"
        ] ++
        lib.optionals config.HMB.brews.enable [
          "betterdisplaycli"
  
          "dyld-shared-cache-extractor"
          
          "ext4fuse-mac" # sudo ext4fuse <diskXsX> <mountPoint> -o allow_other -o umask=000
          "sshfs-mac" # sshfs <user>@<host>:<dir> <mountPoint> -o identityFile=<pathToSSH-Key>
          "ntfs-3g-mac"
          /*
            { # https://nix-darwin.github.io/nix-darwin/manual/#opt-homebrew.brews._.restart_service
              name = "batt";
              restart_service = "changed"; # maybe see environment.launchDaemons.<name>.enable instead
            }
          */

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
        ++ lib.optionals config.HMB.masApps.enable [ "mas" ]
        ++ lib.optionals config.home-manager.users.camille.programs.sketchybar.enable [ "media-control" ];

      masApps =
        lib.mkIf config.HMB.masApps.enable {
          actions = 1586435171;
          Ferromagnetic = 1546537151;
          #AppleConfigurator = 1037126344;
          Pdf-Gear = 6469021132;
          amphetamine = 937984704;
          Testflight = 899247664;
          prettyJsonSafari = 1445328303;
          Xcode = 497799835;
          Whatsapp = 310633997;
          KeyNote = 409183694;
          FolderQuickLook = 6753110395;
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
