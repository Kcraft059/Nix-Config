{
  pkgs,
  config,
  self,
  lib,
  ...
}:
let
  pkgsX86 = import pkgs.path {
    system = "x86_64-darwin";
    config = pkgs.config;
  };
  pkgsArm = import pkgs.path {
    system = "aarch64-darwin";
    config = pkgs.config;
  };
in
{
  # Auto upgrade nix package and the daemon service.
  # services.nix-daemon.enable = true;
  # nix.package = pkgs.nix;
  nix = {
    settings = {
      experimental-features = "nix-command flakes";
    };
    extraOptions = lib.optionalString (pkgs.system == "aarch64-darwin") ''
      extra-platforms = x86_64-darwin aarch64-darwin
    '';
    optimise = {
      automatic = true;
      interval = {
        #Weekday = 1;
        Hour = 6;
        #Minute = 0;
      };
    };
    gc = {
      automatic = true;
      interval = {
        #Weekday = 1;
        Hour = 6;
        #Minute = 0;
      };
      options = "--delete-older-than 15d";
    };
  };

  nixpkgs.hostPlatform = "aarch64-darwin";
  #nixpkgs.config.allowUnsupportedSystem = true;
  #nixpkgs.config.allowBroken = true;

  # Create /etc/zshrc that loads the nix-darwin environment.
  programs.zsh.enable = true;
  # Set Git commit hash for darwin-version.
  system.configurationRevision = self.rev or self.dirtyRev or null;
  # Used for backwards compatibility, please read the changelog before changing.
  # $ darwin-rebuild changelog
  system.stateVersion = 5;

  # Macos System defaults and Extras

  users.users.camille = {
    # Needed For Home-Manager
    name = "camille";
    home = "/Users/camille";
  };

  security.pam.services.sudo_local.touchIdAuth = true;

  system.defaults = {
    # Behaviour
    loginwindow.DisableConsoleAccess = false;
    finder = {
      ShowPathbar = true; # Finder
      QuitMenuItem = true; # Finder
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
    };
    dock = {
      autohide = true; # Dock
      show-recents = false;
      wvous-bl-corner = 2; # Mission Control
      wvous-tr-corner = 14; # Quick Note
      wvous-tl-corner = 5; # Screen Saver
      wvous-br-corner = 4; # Desktop
      persistent-apps = [
        "/System/Applications/System Settings.app"
        "/System/Applications/App Store.app"
        "/Applications/About This Hack.app"
        "/System/Applications/Utilities/Disk Utility.app"
        "/Applications/Ghostty.app"
        "/System/Volumes/Data/Applications/Visual Studio Code.app"
        "/System/Applications/TextEdit.app"
        {
          spacer = {
            small = true;
          };
        }
        "/System/Applications/Passwords.app"
        "/System/Volumes/Data/Applications/Firefox.app"
        "/System/Volumes/Preboot/Cryptexes/App/System/Applications/Safari.app"
        "/Users/camille/Applications/YouTube.app"
        "/Applications/Prism Launcher.app/"
        "/Applications/Whisky.app/"
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
        "/Applications/Audacity.app"
        "/Applications/VLC.app"
        "/System/Volumes/Data/Applications/Microsoft Word.app"
        "/System/Volumes/Data/Applications/Microsoft PowerPoint.app"
        "/System/Volumes/Data/Applications/Microsoft Excel.app"
        "/System/Applications/Notes.app"
        "/System/Volumes/Data/Applications/PDFgear.app"
      ];

      persistent-others = [
        "/Applications/More Apps…"
        "${config.users.users.camille.home}/"
        "${config.users.users.camille.home}/Downloads"
      ];

    };
  };

  system.activationScripts.postActivation.text = pkgs.lib.mkAfter ''
    echo -ne "\033[38;5;5mrunning postActivation scripts…\033[0m " >&2
    ln -sf ${pkgs.openjdk23}/zulu-23.jdk /Library/Java/JavaVirtualMachines
    ln -sf ${pkgsX86.openjdk17}/zulu-17.jdk /Library/Java/JavaVirtualMachines
    ln -sf ${pkgs.openjdk8}/zulu-8.jdk /Library/Java/JavaVirtualMachines
    ln -sf ${pkgs.ffmpeg.lib}/lib/* /usr/local/lib/ 
  '';

  system.activationScripts.applications.text =
    let
      env = pkgs.buildEnv {
        name = "system-applications";
        paths = config.environment.systemPackages;
        pathsToLink = "/Applications";
      };
    in
    pkgs.lib.mkForce ''
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
    '';
}
