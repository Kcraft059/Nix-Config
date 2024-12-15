{
  description = "Example Darwin system flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    nix-darwin.url = "github:LnL7/nix-darwin";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs";
    nix-homebrew.url = "github:zhaofengli-wip/nix-homebrew" ; #Nix homebrew
    homebrew-core = {
      url = "github:homebrew/homebrew-core";
      flake = false;
    };
    homebrew-cask = {
      url = "github:homebrew/homebrew-cask";
      flake = false;
    };
    homebrew-bundle = {
      url = "github:homebrew/homebrew-bundle";
      flake = false;
    };
    homebrew-fuse = {
      url = "github:gromgit/homebrew-fuse";
      flake = false;
    }; 
  };

  outputs = inputs@{ self, nix-darwin, nixpkgs, nix-homebrew, homebrew-core, homebrew-cask, homebrew-bundle, homebrew-fuse, ... }:
  let
    configuration = { pkgs, config, ... }: {

      nixpkgs.config.allowUnfree = true ;

      # List packages installed in system profile. To search by name, run:
      # $ nix-env -qaP | grep wget
      environment.systemPackages =
        [ pkgs.mailsy
          pkgs.mkalias
          pkgs.yt-dlp
          pkgs.neofetch
          pkgs.imagemagick
          pkgs.ffmpeg
          pkgs.htop
          pkgs.screen
          pkgs.github-cli
          pkgs.audacity # Gui
          pkgs.gimp
          #pkgs.kid3  
        ];
      
      homebrew = {
        enable = true;
        casks = [
        "macfuse"
        "firefox"
        "vlc"
        "iina"
        "visual-studio-code"
        "the-unarchiver"
        "BetterDisplay"
        "Stats"
        "Raycast"
        "kid3"
        ];
        brews = [
        "ext4fuse-mac"
        "sshfs-mac"
        "ntfs-3g-mac"
        "mas"
        ]; 
        masApps = {
        #Ferromagnetic = 1546537151;
        #AppleConfigurator = 1037126344;
        #Copyclip = 595191960;
        Dropover = 1355679052;
        }; 
        onActivation.cleanup = "zap";
        #onActivation.autoUpdate = true;
        #onActivation.upgrade = true;
      };

      
      system.defaults = {
        dock.autohide = true; #Dock
        dock.persistent-apps = [
        "/System/Applications/System Settings.app"
        "/System/Applications/App Store.app"
        "/Applications/About This Hack.app"
        "/System/Applications/Utilities/Terminal.app"
        "/System/Applications/Utilities/Activity Monitor.app"
        "/System/Applications/Utilities/Console.app"
        "/System/Applications/Utilities/Disk Utility.app"
        "/System/Volumes/Data/Applications/Xcode.app"
        "/System/Volumes/Data/Applications/Visual Studio Code.app"
        "/System/Applications/Shortcuts.app"
        "/System/Applications/Utilities/Screen Sharing.app"
        "/System/Applications/Passwords.app"
        "/System/Volumes/Data/Applications/Firefox.app"
        "/System/Volumes/Preboot/Cryptexes/App/System/Applications/Safari.app"
        "/Users/camille/Applications/YouTube.app"
        #"/Applications/Mini Motorways.app"
        "/System/Applications/Messages.app"
        "/System/Applications/FaceTime.app"
        "/System/Applications/Contacts.app"
        "/System/Applications/Mail.app"
        "/System/Applications/Calendar.app"
        "/System/Applications/Calculator.app"
        "/System/Applications/Reminders.app"
        "/System/Applications/Maps.app"
        "/System/Applications/Freeform.app"
        "/System/Applications/Photos.app"
        "/System/Applications/Music.app"
        "/System/Volumes/Data/Applications/Ferromagnetic.app"
        #"/System/Volumes/Data/Applications/Wondershare Filmora X.app"
        "${pkgs.audacity}/Applications/Audacity.app"
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
        finder.ShowPathbar = true; #Finder
        finder.QuitMenuItem = true; #Finder
        finder.FXDefaultSearchScope = "SCcf";
        finder.AppleShowAllFiles = true; 
      };
      
      /*
      system.activationScripts.script.text = ''
        echo Test
      '';
      */
      
      system.activationScripts.applications.text = let
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
      services.nix-daemon.enable = true;
      # nix.package = pkgs.nix;

      # Necessary for using flakes on this system.
      nix.settings.experimental-features = "nix-command flakes";

      # Create /etc/zshrc that loads the nix-darwin environment.
      programs.zsh.enable = true;  # default shell on catalina
      # programs.fish.enable = true;

      # Set Git commit hash for darwin-version.
      system.configurationRevision = self.rev or self.dirtyRev or null;

      # Used for backwards compatibility, please read the changelog before changing.
      # $ darwin-rebuild changelog
      system.stateVersion = 5;

      # The platform the configuration will be used on.
      nixpkgs.hostPlatform = "x86_64-darwin";
      
      #nixpkgs.config.allowUnsupportedSystem = true;
      #nixpkgs.config.allowBroken = true;
    };
  in
  {
    # Build darwin flake using:
    # $ darwin-rebuild build --flake .#simple
    darwinConfigurations."MacMiniCam" = nix-darwin.lib.darwinSystem {
      modules = [ 
        configuration
        nix-homebrew.darwinModules.nix-homebrew
        {
          nix-homebrew = {
            
            enable = true; # Install Homebrew under the default prefix

            enableRosetta = false; # Apple Silicon Only: Also install Homebrew under the default Intel prefix for Rosetta 2

            user = "camille"; # User owning the Homebrew prefix

            taps = {
              "homebrew/homebrew-core" = homebrew-core;
              "homebrew/homebrew-cask" = homebrew-cask;
              "homebrew/homebrew-bundle" = homebrew-bundle;
              "gromgit/homebrew-fuse" = homebrew-fuse;
            };

            # Optional: Enable fully-declarative tap management
            #
            # With mutableTaps disabled, taps can no longer be added imperatively with `brew tap`.
            mutableTaps = false;

          };
        } 
        ];
    };

    # Expose the package set, including overlays, for convenience.
    darwinPackages = self.darwinConfigurations."MacMiniCam".pkgs;
  };
}
