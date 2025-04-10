{
  pkgs,
  config,
  self,
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
  users.users.camille = {
    name = "camille";
    home = "/Users/camille";
  };

  system.defaults = {
    dock.autohide = true; # Dock
    dock.persistent-apps = [
      "/System/Applications/System Settings.app"
      "/System/Applications/App Store.app"
      "/Applications/About This Hack.app"
      #"/System/Applications/Utilities/Terminal.app"
      "/Applications/Ghostty.app"
      "/System/Applications/Utilities/Activity Monitor.app"
      #"/System/Applications/Utilities/Console.app"
      "/System/Applications/Utilities/Disk Utility.app"
      "/System/Volumes/Data/Applications/Xcode.app"
      "/System/Volumes/Data/Applications/Visual Studio Code.app"
      #"/System/Applications/Shortcuts.app"
      #"/System/Applications/Utilities/Screen Sharing.app"
      "/System/Applications/Passwords.app"
      "/System/Volumes/Data/Applications/Firefox.app"
      "/System/Volumes/Preboot/Cryptexes/App/System/Applications/Safari.app"
      "/Users/camille/Applications/YouTube.app"
      "/Applications/Prism Launcher.app/"
      "/Applications/Whisky.app/"
      "/System/Applications/Messages.app"
      "/System/Applications/FaceTime.app"
      #"/System/Applications/Contacts.app"
      "/System/Applications/Mail.app"
      "/System/Applications/Calendar.app"
      #"/System/Applications/Calculator.app"
      "/System/Applications/Reminders.app"
      "/System/Applications/Maps.app"
      #"/System/Applications/Freeform.app"
      "/System/Applications/Photos.app"
      "/System/Applications/Music.app"
      "/System/Volumes/Data/Applications/Ferromagnetic.app"
      #"/System/Volumes/Data/Applications/Wondershare Filmora X.app"
      "/Applications/Audacity.app"
      "/Applications/VLC.app"
      "/System/Volumes/Data/Applications/Microsoft Word.app"
      "/System/Volumes/Data/Applications/Microsoft PowerPoint.app"
      "/System/Volumes/Data/Applications/Microsoft Excel.app"
      "/System/Applications/Notes.app"
      "/System/Applications/TextEdit.app"
      "/System/Volumes/Data/Applications/PDFgear.app"
    ];
    WindowManager.EnableStandardClickToShowDesktop = false;
    loginwindow.GuestEnabled = false;
    NSGlobalDomain.AppleICUForce24HourTime = true;
    NSGlobalDomain.AppleInterfaceStyle = "Dark";
    finder.ShowPathbar = true; # Finder
    finder.QuitMenuItem = true; # Finder
    finder.FXDefaultSearchScope = "SCcf";
    #finder.AppleShowAllFiles = true;
  };

  system.activationScripts.postActivation.text = pkgs.lib.mkForce ''
    echo -ne "\033[38;5;5mrunning postActivation scripts…\033[0m " >&2
    ln -sf ${pkgs.openjdk23}/zulu-23.jdk /Library/Java/JavaVirtualMachines
    ln -sf ${pkgsX86.openjdk17}/zulu-17.jdk /Library/Java/JavaVirtualMachines
    ln -sf ${pkgs.openjdk8}/zulu-8.jdk /Library/Java/JavaVirtualMachines
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

  # Auto upgrade nix package and the daemon service.
  # services.nix-daemon.enable = true;
  # nix.package = pkgs.nix;

  # Necessary for using flakes on this system.
  nix.settings.experimental-features = "nix-command flakes";

  # Create /etc/zshrc that loads the nix-darwin environment.
  programs.zsh.enable = true; # default shell on catalina
  # programs.fish.enable = true;

  # Set Git commit hash for darwin-version.
  system.configurationRevision = self.rev or self.dirtyRev or null;

  # Used for backwards compatibility, please read the changelog before changing.
  # $ darwin-rebuild changelog
  system.stateVersion = 5;

  # The platform the configuration will be used on.
  nixpkgs.hostPlatform = "aarch64-darwin";

  #nixpkgs.config.allowUnsupportedSystem = true;
  #nixpkgs.config.allowBroken = true;

  nix.gc = {
    automatic = true;
    interval = {
      Weekday = 0;
      Hour = 0;
      Minute = 0;
    };
    options = "--delete-older-than 30d";
  };
}
