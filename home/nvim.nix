{
  pkgs,
  lib,
  global-config,
  ...
}:
let
  theme = global-config.common.theme;

  nvim-plugins = [
    {
      package = pkgs.vimPlugins.nvim-treesitter.withPlugins (p: [
        p.javascript
        p.nix
        p.c
        p.lua
        p.bash
        p.json
        p.html
        p.css
        p.markdown
      ]);
      name = "nvim-treesitter";
      extraLua = ''
        vim.api.nvim_create_autocmd('FileType', {
          pattern = { 'javascript', 'nix', 'lua', 'c', 'bash', 'json', 'html', 'css', 'markdown' },
          callback = function() vim.treesitter.start() end,
        })
      '';
    }
    {
      package = pkgs.vimPlugins.neo-tree-nvim;
      name = "neo-tree";
      options = { };
    }
    {
      package = pkgs.vimPlugins.telescope-nvim;
      name = "telescope";
      extraLua = ''
        local builtin = require('telescope.builtin')
        vim.keymap.set('n', '<leader>ff', builtin.find_files, { desc = 'Telescope find files' })
        vim.keymap.set('n', '<leader>fg', builtin.live_grep, { desc = 'Telescope live grep' })
      '';
      autoLoad = false;
      extraPackages = [ pkgs.ripgrep ];
    }
    {
      package = pkgs.vimPlugins.blink-cmp;
      name = "blink.cmp";
      options = {
        keymap = {
          preset = "none";
          "<C-p>" = [
            "show"
            "fallback"
          ];
          "<C-e>" = [
            "cancel"
            "fallback"
          ];
          "<Up>" = [
            "select_prev"
            "fallback"
          ];
          "<Down>" = [
            "select_next"
            "fallback"
          ];
          "<CR>" = [
            "accept"
            "fallback"
          ];
        };
        completion = {
          list = {
            selection = {
              preselect = true;
              auto_insert = true;
            };
          };
          menu = {
            auto_show = false;
          };
          documentation = {
            auto_show = true;
            auto_show_delay_ms = 500;
          };
        };
        sources = {
          default = [
            "lsp"
            "path"
            "snippets"
            "buffer"
          ];
        };
        fuzzy = {
          implementation = "prefer_rust_with_warning";
        };
      };
    }
    {
      package = pkgs.vimPlugins.lualine-nvim;
      name = "lualine";
    }
    {
      package = pkgs.vimPlugins.which-key-nvim;
      name = "which-key";
      options = { };
    }
    {
      package = pkgs.vimPlugins.nvim-web-devicons;
      name = "web-devicons";
      autoLoad = false;
    }
  ]
  ++ lib.optionals (theme.nvim-theme != null) [
    ({ extraLua = "vim.cmd.colorscheme('${theme.nvim-theme.name}')"; } // theme.nvim-theme)
  ];

  nvim-lsps = [
    {
      name = "nixd";
      package = pkgs.nixd;
      luaOptions = ''
        {
        	cmd = { 'nixd' },
        	filetypes = { 'nix' },
        	capabilities = vim.lsp.protocol.make_client_capabilities(),
          settings = {
            nixd = {
              nixpkgs = {
                expr = 'import <nixpkgs> {}',
              },
            },
          },
        }
      '';
    }
    {
      name = "clangd";
      package = pkgs.clang;
      luaOptions = ''
        {
        	cmd = { 'clangd' },
        	filetypes = { 'c' },
        	capabilities = vim.lsp.protocol.make_client_capabilities(),
        }
      '';
    }
  ];

  nvim-options = ''
    vim.o.number = true
    vim.o.relativenumber = true
    vim.o.cursorline = true
    vim.o.list = true

    vim.o.ignorecase = true
    vim.o.smartcase = true

    vim.o.tabstop = 2
    vim.o.shiftwidth = 2

    vim.opt.completeopt = { 'menuone', 'noselect', 'popup' }
    vim.opt.exrc = true
  '';

  nvim-keymaps = ''
    vim.g.mapleader = " "
    vim.keymap.set("n","<leader>ft", "<cmd>Neotree toggle<cr>" )
    vim.keymap.set('n',"gf", vim.lsp.buf.format)
    vim.keymap.set("n", "grD", "<cmd>lua vim.lsp.buf.declaration()<CR>")
    vim.keymap.set("n", "grd", "<cmd>lua vim.lsp.buf.definition()<CR>")
  '';

  nvim-lsp-configs = lib.concatStringsSep "\n" (
    map (lsp: ''
      vim.lsp.config('${lsp.name}', ${lsp.luaOptions})
      vim.lsp.enable('${lsp.name}')
    '') nvim-lsps
  );
  nvim-plugin-extrapkgs = builtins.concatLists (
    builtins.filter (pkg: pkg != null) (map (plugin: plugin.extraPackages or null) nvim-plugins)
  );
  nvim-lsp-pkgs = map (lsp: lsp.package) nvim-lsps;
  nvim-plugin-pkgs = builtins.filter (pkg: pkg != null) (
    map (plugin: plugin.package or null) nvim-plugins
  );
  nvim-plugin-configs = lib.concatStringsSep "\n" (
    map (
      plugin:
      let
        cfg_name =
          builtins.replaceStrings [ "-" " " "." "/" "@" ] [ "_" "_" "_" "_" "_" ]
            "${plugin.name}_cfg";
      in
      lib.concatStringsSep "\n" (
        builtins.filter (text: text != null) [
          (
            if (plugin.options or null) != null then
              "local ${cfg_name} = ${lib.generators.toLua { } plugin.options}"
            else
              null
          )
          (if (plugin.initLua or null) != null then plugin.initLua cfg_name else null)
          (
            if (plugin.options or null) != null then
              "require('${plugin.name}').setup(${cfg_name})"
            else if (plugin.autoLoad or true) != false then
              "require('${plugin.name}').setup()"
            else
              null
          )
          (plugin.extraLua or null)
        ]
      )
    ) nvim-plugins
  );
  nvim-config = lib.concatStringsSep "\n" [
    nvim-options
    nvim-keymaps
    nvim-lsp-configs
    nvim-plugin-configs
  ];
in
{
  stylix.targets.neovim.enable = false;

  programs.neovim = {
    enable = true;
    extraPackages = nvim-lsp-pkgs ++ nvim-plugin-extrapkgs;
    plugins = nvim-plugin-pkgs;
    initLua = nvim-config;
  };
}
