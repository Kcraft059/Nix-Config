{
  pkgs,
  lib,
  global-config,
  themeUtils,
  config,
  ...
}:
let
  external-drive = config.home-config.external-drive;

  directLinkedDirs = [
    # Directly links ${diskPath}/camille/${file} to ~/${file}
    "Developper"
    "Documents"
    "Movies"
    "Nix-Config"
    "Pictures"
  ];

  linkedDirs = {
    "Library/Containers/com.isaacmarovitz.Whisky" = "camille/Apps-Data/Whisky";
    "Library/Application Support/PrismLauncher/instances" = "camille/Apps-Data/Prism/instances";
    "Library/Application Support/PrismLauncher/accounts.json" = "camille/Apps-Data/Prism/accounts.json";
    "Library/Application Support/PrismLauncher/iconthemes" = "camille/Apps-Data/Prism/iconthemes";
    "Library/Application Support/Steam/steamapps" = "camille/Apps-Data/Steam (Windows)/steamapps";
  };

  linkedHomeFiles =
    lib.genAttrs directLinkedDirs (name: {
      source = config.lib.file.mkOutOfStoreSymlink "${external-drive.path}/camille/${name}";
    })
    // lib.mapAttrs' (
      name: value:
      lib.nameValuePair (name) {
        source = config.lib.file.mkOutOfStoreSymlink "${external-drive.path}/${value}";
      }
    ) linkedDirs;

  theme = global-config.common.theme;

  # [THEME DEPENDENT]
  prismlauncher-theme = import ../configs/prismlauncher-theme.nix { inherit theme; };
  xcode-theme = import ../configs/xcode-theme.nix { inherit theme themeUtils; };

  xcode-theme-dir = pkgs.runCommand "xcode-themes" { } ''
    mkdir -p $out;
    cat > $out/Custom\ Theme.xccolortheme <<'EOF'
    ${xcode-theme}
    EOF
  '';
in
{
  config = {
    home.file = {
      "Library/Group Containers/UBF8T346G9.Office/User Content.localized/Themes.localized/Default Theme.potm".source =
        ../../ressources/Excel_Default.potm;
    }
    // (lib.optionalAttrs external-drive.enable linkedHomeFiles)
    // (lib.optionalAttrs theme.enable {
      "Library/Developer/Xcode/UserData/FontAndColorThemes".source = xcode-theme-dir;
      "Library/Application Support/PrismLauncher/themes/custom-theme/theme.json".text = prismlauncher-theme;
    });
  };
}
