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
          "hex-fiend"
          #"visual-studio-code"
          #"ghostty"
          "ghostty@tip"
          "font-sf-pro"
        ]
        ++ lib.optionals config.HMB.brews.enable [
          "macfuse@dev"
        ]
        ++ lib.optionals config.HMB.casks.enable [
          "vlc"
          "iina"
          "the-unarchiver"
          "BetterDisplay"
          "Stats"
          "Raycast"
          "kid3"
          "multimc"
          "prismlauncher"
          "audacity"
          "whisky"
          "lulu"
          "disk-inventory-x"
          "sf-symbols"
          "knockknock"
          "chatgpt"
          "discord"
          "gimp"
          "Alcove"
          "suspicious-package"
          "firefox"
          "balenaetcher"
          "google-chrome" # Ewww… WebHID Only
          "steamcmd"
          "gog-galaxy"
          #"dockdoor"
          "appcleaner"
          #"logitech-g-hub"
          #"kegworks"
          #"binary-ninja-free"
        ];
      brews =
        #lib.optionals config.HMB.coreUtils [ ] ++
        lib.optionals config.HMB.brews.enable [
          #"powerlevel10k"
          "betterdisplaycli"
          "dyld-shared-cache-extractor"
          "ext4fuse-mac" # sudo ext4fuse <diskXsX> <mountPoint> -o allow_other -o umask=000
          "ntfs-3g-mac" # "libunistring" "gettext"
          "sshfs-mac" # sshfs <user>@<host>:<dir> <mountPoint> -o identityFile=<pathToSSH-Key>
          /* { # https://nix-darwin.github.io/nix-darwin/manual/#opt-homebrew.brews._.restart_service
            name = "batt";
            restart_service = "changed"; # maybe see environment.launchDaemons.<name>.enable instead 
          } */

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
        ++ lib.optionals config.home-manager.users.camille.programs.sketchybar.enable [ "media-control" ] ;

      masApps =
        #lib.mkIf config.HMB.coreUtils { } //
        lib.mkIf config.HMB.masApps.enable {
          actions = 1586435171;
          Ferromagnetic = 1546537151;
          AppleConfigurator = 1037126344;
          Pdf-Gear = 6469021132;
          amphetamine = 937984704;
          Testflight = 899247664;
          prettyJsonSafari = 1445328303;
          whatsapp = 310633997;
          KeyNote = 409183694;
        };

      taps = [
        "homebrew/homebrew-cask"
        "homebrew/homebrew-core"
        "homebrew/homebrew-bundle"
        "gromgit/homebrew-fuse"
        "waydabber/homebrew-betterdisplay"
        "Kegworks-App/homebrew-kegworks"
      ];
      onActivation.autoUpdate = true;
      onActivation.upgrade = true;
      onActivation.cleanup = "zap";
    };
  };
}
