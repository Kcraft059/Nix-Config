{
  pkgs,
  config,
  lib,
  global-config,
  ...
}:
let
  clangd-config = ''
    BasedOnStyle: LLVM
    IndentWidth: 2
    ColumnLimit: 0          # disables auto line wrapping
    BreakBeforeBraces: Attach
    DerivePointerAlignment: false
    PointerAlignment: Left
    BinPackParameters: false
    AllowShortBlocksOnASingleLine : Always
    AllowShortIfStatementsOnASingleLine : AllIfsAndElse
  '';
in
rec {
  stylix.targets.vscode.enable = false;

  programs.vscode = {
    package = pkgs.vscode;
    enable = config.home-config.GUIapps.enable;
    profiles.default = {
      userSettings =
        let
          font =
            lib.optionalString (builtins.elem pkgs.nerd-fonts.jetbrains-mono global-config.fonts.packages)
              lib.mkForce
              "JetBrainsMono Nerd Font";
        in
        {
          # Style
          "workbench.colorTheme" = "Rosé Pine Moon";
          "editor.fontSize" = 13.0;
          "debug.console.fontSize" = 13.0;
          "markdown.preview.fontSize" = 13.0;
          "scm.inputFontSize" = 13.0;
          "terminal.integrated.fontSize" = 13.0;
          "explorer.confirmDragAndDrop" = false;
          "explorer.confirmDelete" = false;
          "editor.fontFamily" = font;
          "debug.console.fontFamily" = font;
          "chat.editor.fontFamily" = font;
          "scm.inputFontFamily" = font;
          "editor.inlayHints.fontFamily" = font;
          "editor.inlineSuggest.fontFamily" = font;

          # Behaviour
          "git.openRepositoryInParentFolders" = "always";
          "git.confirmSync" = false;
          "git.suggestSmartCommit" = true;
          "workbench.startupEditor" = "none";
          "chat.disableAIFeatures" = true;

          # Code Format prefs
          "editor.tabSize" = 2;
          "editor.detectIndentation" = false;
          "editor.wordWrapColumn" = 250;

          "[c]" = {
            "editor.defaultFormatter" = "llvm-vs-code-extensions.vscode-clangd";
          };
          "clangd.arguments" = [
            "--fallback-style=Google"
          ];
          "C_Cpp.intelliSenseEngine" = "disabled";

          "shfmt.executablePath" = "${pkgs.shfmt}/bin/shfmt";

          #"C_Cpp.vcFormat.newLine.beforeCatch" = false;
          #"C_Cpp.vcFormat.newLine.beforeElse" = false;
          #"C_Cpp.clang_format_style" = "{ BasedOnStyle: Google, ColumnLimit: 0}";
        };
      extensions = with pkgs.vscode-marketplace; [
        # To use, needs to overlay inputs.nix-vscode-extensions.overlays.default

        mvllow.rose-pine # Theme

        jnoortheen.nix-ide # Nix code formating + completion
        llvm-vs-code-extensions.vscode-clangd # C/C++ (obj) completion + formating
        bmewburn.vscode-intelephense-client # PHP completion + formating
        mkhl.shfmt # Shell completion + formating
        ## ms-vscode.cpptools

        ## ms-python.python
        dnicolson.binary-plist # Allow modification of binary plists

        ## ms-vscode.cpptools-extension-pack
        ## SPGoding.datapack-language-server # Not added yet to the packages repo

      ];
    };
  };

  # Only build file if clangd extension
  home.file.".clang-format".text =
    lib.optionalString (builtins.elem pkgs.vscode-marketplace.llvm-vs-code-extensions.vscode-clangd programs.vscode.profiles.default.extensions) clangd-config;

  home.activation.externalDriveLinks =
    lib.mkIf
      (
        (builtins.elem pkgs.vscode-marketplace.llvm-vs-code-extensions.vscode-clangd programs.vscode.profiles.default.extensions)
        && config.home-config.external-drive.enable
      )
      (
        lib.hm.dag.entryAfter [
          "writeBoundary"
        ] ''ln -sfn "${pkgs.writeText "clang-format" clangd-config}" "$HOME/Developper/.clang-format"''
      );
}
