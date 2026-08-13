{
  config,
  lib,
  ...
}:
{
  options.homebrew-pkgs = {
    enable = lib.mkEnableOption "Whether to enable the whole homebrew module";
    core = lib.mkEnableOption "Core utilities ?";
    brews = lib.mkEnableOption "Whether to enable brews";
    casks = lib.mkEnableOption "Whether to enable casks";
    mas = lib.mkEnableOption "Whether to enable masApps";
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
      casks =
        lib.optionals config.homebrew-pkgs.core [
          "ghostty"
          "font-sf-pro"
          "BetterDisplay"
        ]
        ++ lib.optionals config.homebrew-pkgs.brews [
          "macfuse"
        ]
        ++ lib.optionals config.homebrew-pkgs.casks [
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
      brews =
        lib.optionals config.homebrew-pkgs.core [
          "dyld-shared-cache-extractor"
        ]
        ++ lib.optionals config.homebrew-pkgs.brews [
          "betterdisplaycli"
        ]
        ++ lib.optionals config.homebrew-pkgs.mas [
          "mas"
        ]
        ++ lib.optionals config.home-manager.users.camille.programs.sketchybar.enable [
          "media-control"
        ];

      masApps = lib.mkIf config.homebrew-pkgs.mas {
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
