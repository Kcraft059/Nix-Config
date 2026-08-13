{
  pkgs,
  config,
  lib,
  global-config,
  ...
}:
let
  theme = global-config.common.theme;
in
{
  stylix.targets.vscode.enable = false;

  programs.vscode = {
    package = pkgs.vscode;
    enable = config.home-config.gui;
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
          "workbench.colorTheme" = lib.optionalString (
            theme.enable && theme.vs-theme.name != ""
          ) theme.vs-theme.name;
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

          "luahelper.format.continuation_indent_width" = 2;
          "luahelper.format.indent_width" = 2;

          "nix.enableLanguageServer" = true;
          "nix.serverPath" = "nixd";
          "nix.serverSettings" = {
            nixd = {
              formatting.command = "nixfmt";
              /*
                options = {
                             nix-darwin.expr = "(builtins.getFlake \${workspaceFolder}).darwinConfigurations.default";
                             nixos.expr = "(builtins.getFlake \${workspaceFolder}).nixosConfigurations.default";
                             home-manager.expr = "(builtins.getFlake \${workspaceFolder}).options.home-manager.users.type.getSubOptions []";
                           };
              */
            };
          };

          #"C_Cpp.vcFormat.newLine.beforeCatch" = false;
          #"C_Cpp.vcFormat.newLine.beforeElse" = false;
          #"C_Cpp.clang_format_style" = "{ BasedOnStyle: Google, ColumnLimit: 0}";
        };
      extensions =
        (with pkgs.vscode-marketplace; [
          # To use, needs to overlay inputs.nix-vscode-extensions.overlays.default

          jnoortheen.nix-ide # Nix code formating + completion
          llvm-vs-code-extensions.vscode-clangd # C/C++ (obj) completion + formating

          mkhl.shfmt # Shell completion + formating
          yinfei.luahelper # Lua formating
          golang.go # Golang support
        ])
        # [THEME DEPENDENT]
        ++ lib.optionals (theme.enable && theme.vs-theme.package != null) [
          theme.vs-theme.package
        ];
    };
  };

  home.packages = with pkgs; [
    nixfmt # Nix formating
    nixd
  ];
}
