{
  description = "MacBook Air M3 personnal config • Kcraft059";

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

  # Define architectures
  pkgsX86 = import nixpkgs {
    system = "x86_64-darwin";
  };

  pkgsArm = import nixpkgs {
    system = "aarch64-darwin";
  };

    configuration = { pkgs, config, ... }: {

      nixpkgs.config.allowUnfree = true ;

      # List packages installed in system profile. To search by name, run:
      # $ nix-env -qaP | grep wget


      environment.systemPackages =
        [ pkgs.mailsy
          pkgs.bat
          pkgs.mkalias
          pkgs.yt-dlp
          pkgs.fastfetch
          pkgs.imagemagick
          pkgs.ffmpeg
          pkgs.htop
          pkgs.btop
          pkgs.screen
          pkgs.github-cli
          pkgs.openjdk8
          pkgs.php
          pkgs.neovim
          #pkgs.oh-my-zsh
          #pkgs.zsh-powerlevel10k
          pkgsX86.openjdk17
          pkgs.openjdk23
          pkgs.tree
          #pkgs.alacritty # GUI
        ];

      fonts.packages = [
          pkgs.nerd-fonts.jetbrains-mono
          pkgs.monocraft
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
          #"alacritty"
          "ghostty"
          "Alcove"
          "suspicious-package"
          #"binary-ninja-free"
        ];
        brews = [
          #"tree"
          #"imagemagick"
          "powerlevel10k"
          "mas"
          #"tmux"

          "ext4fuse-mac" 
          # sudo ext4fuse <diskXsX> <mountPoint> -o allow_other
          "sshfs-mac" /* dependencies -> declare to prevent uninstall */ "ca-certificates" "libunistring" "gettext" "mpdecimal" "openssl@3" "pcre2" "python-packaging" "readline" "sqlite" "xz" "python@3.13" "glib"
          # sshfs <user>@<host>:<dir> <mountPoint> -o identityFile=<pathToSSH-Key> 
          "ntfs-3g-mac" /* "libunistring" "gettext" */
        ]; 
        masApps = {
          actions = 1586435171;
          Ferromagnetic = 1546537151;
          AppleConfigurator = 1037126344;
          Pdf-Gear = 6469021132;
          amphetamine = 937984704;
          Testflight = 899247664;
          prettyJsonSafari = 1445328303;
          #whatsapp = 310633997;
          #Copyclip = 595191960
          #Dropover = 1355679052;
          #ColorFolder = 1570945548;
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

      
      system.defaults = {
        dock.autohide = true; #Dock
        dock.persistent-apps = [
        "/System/Applications/System Settings.app"
        "/System/Applications/App Store.app"
        "/Applications/About This Hack.app"
        "/System/Applications/Utilities/Terminal.app"
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
        finder.ShowPathbar = true; #Finder
        finder.QuitMenuItem = true; #Finder
        finder.FXDefaultSearchScope = "SCcf";
        #finder.AppleShowAllFiles = true; 
      };
      
      system.activationScripts.postActivation.text = pkgs.lib.mkForce ''
        echo -ne "\033[38;5;5mrunning postActivation scripts…\033[0m " >&2
        ln -sf ${pkgs.openjdk23}/zulu-23.jdk /Library/Java/JavaVirtualMachines
        ln -sf ${pkgsX86.openjdk17}/zulu-17.jdk /Library/Java/JavaVirtualMachines
        ln -sf ${pkgs.openjdk8}/zulu-8.jdk /Library/Java/JavaVirtualMachines
      '';

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
      # services.nix-daemon.enable = true;
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
      nixpkgs.hostPlatform = "aarch64-darwin";
      
      #nixpkgs.config.allowUnsupportedSystem = true;
      #nixpkgs.config.allowBroken = true;

      nix.gc = {
        automatic = true;
        interval = { Weekday = 0; Hour = 0; Minute = 0; };
        options = "--delete-older-than 30d";
      };
      
    };
  in
  {
    # Build darwin flake using:
    # $ darwin-rebuild build --flake .#simple
    darwinConfigurations."MacOSCam" = nix-darwin.lib.darwinSystem {
      modules = [ 
        configuration
        nix-homebrew.darwinModules.nix-homebrew
        {
          nix-homebrew = {
            
            enable = true; # Install Homebrew under the default prefix

            enableRosetta = true; # Apple Silicon Only: Also install Homebrew under the default Intel prefix for Rosetta 2

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
    darwinPackages = self.darwinConfigurations."MacOSCam".pkgs;
  };
}
