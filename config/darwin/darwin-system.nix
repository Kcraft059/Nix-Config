{
  pkgs,
  config,
  lib,
  ...
}:
let
  pkgsX86 = import pkgs.path {
    system = "x86_64-darwin";
    config = pkgs.config;
  };

  ## [IMPURE] (unsafe commands… etc)
  checkExists = path: builtins.exec ["sh" "-c" ((p: ''if [ -e "${p}" ]; then echo true; else echo false; fi'') path)];
  pathExist = path: (lib.mkIf (checkExists path)) path;

  external-drive = config.darwin-system.external-drive;
  defaults = config.darwin-system.defaults;

  wallpaper = config.darwin-system.defaults.wallpaper;
  syspkgs = config.environment.systemPackages;
  homepkgs = config.home-manager.users.camille.home.packages;

  system-activation = ''
    echo -e "Running postActivation scripts…" >&2
    mdutil -i off -V /nix # Ensure spotlight is turned off for nix-store

    # ${pkgs.skhd}/bin/skhd -r # Reloads skhd

    if [ -f /opt/homebrew/bin/tccutil ];then
      echo -e "Setting up tcc permissions…" >&2
      /opt/homebrew/bin/tccutil -i ${pkgs.bashNonInteractive}/bin/bash
      ${lib.optionalString config.home-manager.users.camille.programs.sketchybar.enable ''/opt/homebrew/bin/tccutil  -i ${pkgs.sketchybar}/bin/sketchybar''}
      ${lib.optionalString (builtins.elem pkgs.yabai syspkgs) ''/opt/homebrew/bin/tccutil  -i ${pkgs.yabai}/bin/yabai''}
      ${lib.optionalString (builtins.elem pkgs.skhd syspkgs) ''/opt/homebrew/bin/tccutil  -i ${pkgs.skhd}/bin/skhd''}
      ${lib.optionalString (builtins.elem pkgs.rift syspkgs) ''/opt/homebrew/bin/tccutil  -i ${pkgs.rift}/bin/rift''}
      ${lib.optionalString (builtins.elem pkgs.aerospace syspkgs) ''/opt/homebrew/bin/tccutil  -i ${pkgs.aerospace}/bin/aerospace''}
    fi


    ${lib.optionalString (wallpaper != "")
      ''osascript -e 'tell application "System Events" to set picture of every desktop to "${wallpaper}"' ''
    }
    ${lib.optionalString (builtins.elem pkgs.openjdk21 syspkgs) ''ln -sf ${pkgs.openjdk21}/Library/Java/JavaVirtualMachines/zulu-21.jdk /Library/Java/JavaVirtualMachines ''}
    ${lib.optionalString (builtins.elem pkgsX86.openjdk17 syspkgs) ''ln -sf ${pkgsX86.openjdk17}/Library/Java/JavaVirtualMachines/zulu-17.jdk /Library/Java/JavaVirtualMachines ''}
    ${lib.optionalString (builtins.elem pkgs.openjdk8 syspkgs) ''ln -sf ${pkgs.openjdk8}/Library/Java/JavaVirtualMachines/zulu-8.jdk /Library/Java/JavaVirtualMachines ''}
    ${lib.optionalString (builtins.elem pkgs.ffmpeg syspkgs) ''ln -sf ${pkgs.ffmpeg.lib}/lib/* /usr/local/lib/ ''} 
    ${lib.optionalString defaults.enable ''
      defaults write -g NSColorSimulateHardwareAccent -bool YES 
      defaults write -g NSColorSimulatedHardwareEnclosureNumber -int 7
    ''}
  '';

  application-script =
    let
      env = pkgs.buildEnv {
        name = "system-applications";
        paths = config.environment.systemPackages;
        pathsToLink = [ "/Applications" ];
      };
    in
    lib.mkForce (
      ''
        # Set up applications.
        echo "setting up /Applications..." >&2
        rm -rf /Applications/Nix\ Apps
        mkdir -p /Applications/Nix\ Apps
        find ${env}/Applications -maxdepth 1 -type l -exec readlink '{}' + |
        while read -r src; do
          app_name=$(basename "$src")
          echo "copying $src" >&2
          ${pkgs.mkalias}/bin/mkalias "$src" "/Applications/Nix Apps/$app_name"
        done
      ''
      + lib.optionalString external-drive.enable ''
        rm -rf /Applications/External\ Apps
        mkdir -p /Applications/External\ Apps
        find ${external-drive.path}/Applications -maxdepth 1 -type d -name '*.app' |
        while read -r src; do
          app_name=$(basename "$src")
          echo "copying $src" >&2
          ${pkgs.mkalias}/bin/mkalias "$src" "/Applications/External Apps/$app_name"
        done
      ''
    );
in
{
  options.darwin-system = {
    enable = lib.mkEnableOption "Whether to enable the Darwin-Config";
    defaults = {
      enable = lib.mkEnableOption "Whether to config of macos defaults";
      dock.enable = lib.mkEnableOption "Whether to config dock items";
      wallpaper = lib.mkOption {
        type = lib.types.path;
        default = "";
        example = lib.literalExpression ''/ressources/wallpaper.png'';
        description = ''
          Set the default wallpaper
        '';
      };
    };
    external-drive.enable = lib.mkEnableOption "Enable linking of outside ressources";
    external-drive.path = lib.mkOption {
      type = lib.types.str;
      default = "";
      example = lib.literalExpression '''';
      description = ''
        Mount point for the shared disk
      '';
    };
  };

  config = lib.mkIf config.darwin-system.enable {

    users.users.camille = {
      # Needed For Home-Manager
      name = "camille";
      home = "/Users/camille";
      gid = 20;
    };
    system.primaryUser = "camille";

    programs.zsh.enable = true;
    security.pam.services.sudo_local.touchIdAuth = true;

    networking = {
      knownNetworkServices = [
        # networksetup -listallnetworkservices
        "Wi-Fi"
        "iPhone USB"
        "USB 10/100/1000 LAN"
      ];
      dns = [
        "8.8.8.8"
        "1.1.1.1"
        "8.8.8.4"
      ];
      #computerName = hostName;
    };

    system.defaults = lib.mkIf defaults.enable {
      # Behaviour
      loginwindow.DisableConsoleAccess = false;
      finder = {
        ShowPathbar = true; # Finder
        QuitMenuItem = true;
        FXDefaultSearchScope = "SCcf";
        ShowExternalHardDrivesOnDesktop = true;
        ShowHardDrivesOnDesktop = true;
        ShowMountedServersOnDesktop = true;
        ShowRemovableMediaOnDesktop = true;
        NewWindowTarget = "Home";
        FXEnableExtensionChangeWarning = false;
        # AppleShowAllFiles = true;
      };
      WindowManager.EnableStandardClickToShowDesktop = false;
      loginwindow.GuestEnabled = false;
      SoftwareUpdate.AutomaticallyInstallMacOSUpdates = false;
      # Appearance
      NSGlobalDomain = {
        AppleICUForce24HourTime = true;
        AppleInterfaceStyle = "Dark";
        _HIHideMenuBar = config.home-manager.users.camille.programs.sketchybar.enable;
      };
      dock = lib.mkIf defaults.dock.enable {
        autohide = true;
        show-recents = false;
        wvous-bl-corner = 2; # Mission Control
        wvous-tr-corner = 14; # Quick Note
        wvous-tl-corner = 5; # Screen Saver
        wvous-br-corner = 4; # Desktop
        persistent-apps = [
          "/System/Applications/System Settings.app"
          "/System/Applications/App Store.app"
          "/System/Applications/Utilities/Disk Utility.app"
          (pathExist "/Applications/Ghostty.app")
          (lib.mkIf (builtins.elem pkgs.vscode syspkgs) "${pkgs.vscode}/Applications/Visual Studio Code.app")
          (pathExist "/Applications/Xcode.app")
          "/System/Applications/TextEdit.app"
          {
            spacer = {
              small = true;
            };
          }
          "/System/Applications/Passwords.app"
          (pathExist "/Applications/Firefox.app")
          "/System/Volumes/Preboot/Cryptexes/App/System/Applications/Safari.app"
          (pathExist "/Users/camille/Applications/YouTube.app")
          (pathExist "/Applications/Prism Launcher.app/")
          (pathExist "/Applications/Whisky.app/")
          "/System/Applications/Messages.app"
          "/System/Applications/Mail.app"
          "/System/Applications/Calendar.app"
          "/System/Applications/Reminders.app"
          {
            spacer = {
              small = true;
            };
          }
          "/System/Applications/Photos.app"
          "/System/Applications/Music.app"
          (lib.mkIf (builtins.elem pkgs.audacity config.home-manager.users.camille.home.packages) "${pkgs.audacity}/Applications/Audacity.app")
          (pathExist "/Applications/VLC.app")
          (lib.mkIf external-drive.enable "${external-drive.path}/Applications/Microsoft Word.app")
          (lib.mkIf external-drive.enable "${external-drive.path}/Applications/Microsoft PowerPoint.app")
          (lib.mkIf external-drive.enable "${external-drive.path}/Applications/Microsoft Excel.app")
          "/System/Applications/Notes.app"
          (pathExist "/Applications/PDFgear.app")
        ];
        persistent-others = [
          "${config.users.users.camille.home}/"
          "${config.users.users.camille.home}/Downloads"
        ];
      };
    };

    system.activationScripts.applications.text = application-script;
    system.activationScripts.postActivation.text = lib.mkAfter system-activation;

    #environment.etc."file_name".text = builtins.readFile config.sops.secrets.ftn-user1.path;
  };
}
