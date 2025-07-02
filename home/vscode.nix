{
  pkgs,
  config,
  lib,
  ...
}:
{
  programs.vscode = {
    #package = pkgs.vscode;
    enable = true;
    profiles.default = {
      userSettings = {
        "workbench.colorTheme" = lib.mkForce "Rosé Pine Moon";
        "editor.fontSize" = lib.mkForce 12.0;
        "git.openRepositoryInParentFolders" = "always";
        "explorer.confirmDragAndDrop" = false;
        "git.confirmSync" = false;
        "explorer.confirmDelete" = false;
        "editor.detectIndentation" = false;
        "editor.tabSize" = 2;
        "git.suggestSmartCommit" = true;
      };
      extensions = [
        # To use, needs to overlay inputs.nix-vscode-extensions.overlays.default
        pkgs.vscode-marketplace.jnoortheen.nix-ide
        pkgs.vscode-marketplace.mvllow.rose-pine
        #pkgs.vscode-marketplace.dracula-theme.theme-dracula
      ];
    };
  };
}
