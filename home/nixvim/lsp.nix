{ pkgs, config, ... }:
{
  programs.nixvim = {

    extraPackages = with pkgs; [
      nixfmt
      oxlint
      oxfmt
      tsgolint
    ];

    # JDT LS (Java) — invoked automatically by plugins.jdtls below for *.java files.
    # We run it under JDK 25 to match `.java-version` used by GTNH RFG-based projects
    # (the nixpkgs derivation otherwise pins Zulu JDK 21).
    plugins.jdtls = {
      enable = true;
      jdtLanguageServerPackage = pkgs.jdt-language-server;
      settings = {
        cmd = [
          "${pkgs.jdt-language-server}/bin/jdtls"
          "--java-executable"
          "${pkgs.jdk25}/bin/java"
        ];
        settings = {
          java = {
            # Tell JDT LS which JDKs we have available. The convention plugin marks
            # the project as source=17 / target=1.8 (Jabel), so JavaSE-17 must exist.
            configuration.runtimes = [
              {
                name = "JavaSE-1.8";
                path = "${pkgs.jdk8}";
              }
              {
                name = "JavaSE-17";
                path = "${pkgs.jdk25}";
                default = true;
              }
            ];
            # Don't auto-build on save — Gradle owns the build for RFG projects.
            autobuild.enabled = false;
          };
        };
      };
    };

    lsp = {
      servers = {
        nixd = {
          enable = true;
          config = {
            settings = {
              nixd = {
                formatting.command = [ "nixfmt" ];
                nixpkgs.expr = "import <nixpkgs> { }";
              };
            };
          };
        };
        tsc.enable = true;
        biome.enable = true;
        oxlint.enable = true;
        oxfmt.enable = true;
        lua_ls.enable = true;
        astro.enable = true;
        tinymist = {
          enable = true;
          config.settings = {
            formatterMode = "typstyle";
          };
        };
      };

      keymaps = [
        {
          key = "gd";
          action = config.lib.nixvim.mkRaw "function() Snacks.picker.lsp_definitions() end";
          mode = "n";
          options.desc = "Go to definition";
        }
        {
          key = "gD";
          action = config.lib.nixvim.mkRaw "function() Snacks.picker.lsp_declarations() end";
          mode = "n";
          options.desc = "Go to declaration";
        }
        {
          key = "grr";
          action = config.lib.nixvim.mkRaw "function() Snacks.picker.lsp_references() end";
          mode = "n";
          options.desc = "Show references";
        }
        {
          key = "gri";
          action = config.lib.nixvim.mkRaw "function() Snacks.picker.lsp_implementations() end";
          mode = "n";
          options.desc = "Go to implementation";
        }
        {
          key = "grt";
          action = config.lib.nixvim.mkRaw "function() Snacks.picker.lsp_type_definitions() end";
          mode = "n";
          options.desc = "Go to type definition";
        }
        {
          key = "gO";
          action = config.lib.nixvim.mkRaw "function() Snacks.picker.lsp_symbols() end";
          mode = "n";
          options.desc = "Document symbols";
        }
        {
          key = "<leader>ls";
          action = config.lib.nixvim.mkRaw "function() Snacks.picker.lsp_workspace_symbols() end";
          mode = "n";
          options.desc = "Workspace symbols";
        }
      ];
    };

    autoCmd = [
      {
        event = [ "BufWritePre" ];
        callback = config.lib.nixvim.mkRaw ''
          function(args)
            -- Highest-priority attached client formats the buffer, so a project
            -- with an oxfmt config is not formatted a second time by biome.
            local formatters = { "oxfmt", "biome", "nixd", "lua_ls", "tinymist" }
            local attached = {}
            for _, client in ipairs(vim.lsp.get_clients { bufnr = args.buf }) do
              attached[client.name] = true
            end
            for _, name in ipairs(formatters) do
              if attached[name] then
                vim.lsp.buf.format { bufnr = args.buf, name = name }
                return
              end
            end
          end
        '';
      }
    ];

    plugins.lspconfig.enable = true;

    # Live preview for Typst. Drives its own `tinymist preview` server (separate
    # from the LSP above) and talks to it over websocat, which is what gives
    # bidirectional cursor<->preview sync. Both binaries come from Nix, so the
    # plugin never tries to download them at runtime.
    plugins.typst-preview = {
      enable = true;
      settings = {
        follow_cursor = true;
        invert_colors = "never";
      };
    };

    keymaps = [
      {
        key = "<leader>tp";
        action = "<cmd>TypstPreviewToggle<CR>";
        mode = "n";
        options.desc = "Typst: Toggle live preview";
      }
      {
        key = "<leader>tf";
        action = "<cmd>TypstPreviewFollowCursorToggle<CR>";
        mode = "n";
        options.desc = "Typst: Toggle follow cursor";
      }
      {
        key = "<leader>ts";
        action = "<cmd>TypstPreviewSyncCursor<CR>";
        mode = "n";
        options.desc = "Typst: Sync preview to cursor";
      }
    ];

    plugins.blink-cmp = {
      enable = true;
      settings = {
        keymap = {
          preset = "enter";
        };
      };
    };

    plugins.treesitter = {
      enable = true;
      highlight.enable = true;
      grammarPackages = with config.programs.nixvim.plugins.treesitter.package.builtGrammars; [
        astro
        bash
        css
        diff
        git_config
        git_rebase
        gitcommit
        gitignore
        html
        java
        javascript
        jsdoc
        json
        kdl
        lua
        luadoc
        markdown
        markdown_inline
        nix
        query
        regex
        scss
        toml
        tsx
        typescript
        typst
        vim
        vimdoc
        yaml
        zsh
      ];
    };

  };

}
