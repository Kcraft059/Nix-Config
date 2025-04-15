{
  pkgs,
  config,
  lib,
  ...
}:
{
  options.HMB = {
    enable = lib.mkEnableOption "Whether to enable the whole homebrew module";
    brews.enable = lib.mkEnableOption "Whether to enable brews";
    casks.enable = lib.mkEnableOption "Whether to enable casks";
    masApps.enable = lib.mkEnableOption "Whether to enable masApps";
  };

  config = lib.mkIf config.HMB.enable {
    homebrew = {
      enable = true;
      casks = lib.optionals config.HMB.casks.enable [
        "macfuse"
        "vlc"
        "iina"
        "visual-studio-code"
        "the-unarchiver"
        "BetterDisplay"
        "Stats"
        "Raycast"
        "kid3"
        "multimc"
        "prismlauncher"
        "audacity"
        "whisky"
        "hex-fiend"
        "lulu"
        "disk-inventory-x"
        "sf-symbols"
        "knockknock"
        "chatgpt"
        "discord"
        "gimp"
        "ghostty"
        "Alcove"
        "suspicious-package"
        "firefox"
        "google-chrome" # Ewww… WebHID Only
        #"binary-ninja-free"
      ];
      brews =
        lib.optionals config.HMB.brews.enable [
          "powerlevel10k"
          "ext4fuse-mac" # sudo ext4fuse <diskXsX> <mountPoint> -o allow_other
          "ntfs-3g-mac" # "libunistring" "gettext"
          "sshfs-mac" # sshfs <user>@<host>:<dir> <mountPoint> -o identityFile=<pathToSSH-Key>

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
        ++ lib.optionals config.HMB.masApps.enable [ "mas" ];

      masApps = lib.mkIf config.HMB.masApps.enable {
        actions = 1586435171;
        Ferromagnetic = 1546537151;
        AppleConfigurator = 1037126344;
        Pdf-Gear = 6469021132;
        amphetamine = 937984704;
        Testflight = 899247664;
        prettyJsonSafari = 1445328303;
        whatsapp = 310633997;
      };

      taps = [
        "homebrew/homebrew-cask"
        "homebrew/homebrew-core"
        "homebrew/homebrew-bundle"
        "gromgit/homebrew-fuse"
      ];
      onActivation.autoUpdate = true;
      onActivation.upgrade = true;
      onActivation.cleanup = "zap";
    };
  };
}
