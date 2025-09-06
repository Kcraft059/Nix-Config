{
  pkgs,
  config,
  lib,
  ...
}:
{
  programs.vscode = {
    package = pkgs.vscode;
    enable = config.home-config.GUIapps.enable ;
    profiles.default = {
      userSettings = {
        "workbench.colorTheme" = lib.mkForce "Rosé Pine Moon";
        "editor.fontSize" = lib.mkForce 13.0;
        "debug.console.fontSize" = lib.mkForce 13.0;
        "markdown.preview.fontSize" = lib.mkForce 13.0;
        "scm.inputFontSize" = lib.mkForce 13.0;
        "terminal.integrated.fontSize" = lib.mkForce 13.0;
        "git.openRepositoryInParentFolders" = "always";
        "explorer.confirmDragAndDrop" = false;
        "git.confirmSync" = false;
        "explorer.confirmDelete" = false;
        "editor.detectIndentation" = false;
        "editor.tabSize" = 2;
        "git.suggestSmartCommit" = true;
        "shfmt.executablePath" = "${pkgs.shfmt}/bin/shfmt";
      };
      extensions = with pkgs.vscode-marketplace; [
        # To use, needs to overlay inputs.nix-vscode-extensions.overlays.default
        jnoortheen.nix-ide
        mvllow.rose-pine
        bmewburn.vscode-intelephense-client
        mkhl.shfmt
        /* SPGoding.datapack-language-server # Not added yet to the packages repo */
      ];
    };
  };
}
