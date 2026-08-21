{ pkgs, config, ... }:
{
  programs.nixvim = {

    extraPackages = with pkgs; [ nixfmt ];

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
        # TypeScript 7 native LSP (typescript-go; `tsc`/`tsgo` are the same binary).
        # Not known to nvim-lspconfig,
        # so we spell out cmd/filetypes/root_markers ourselves.
        tsc = {
          enable = true;
          config = {
            # Pick the language-server binary, preferring a project-local one so
            # that e.g. Effect's `effect-tsgo patch --typescript` (which patches
            # the local `typescript` install in place) is used, giving the Effect
            # language service.
            #
            #   1. local `node_modules/.bin/tsgo`  (native-preview style install)
            #   2. local `node_modules/.bin/tsc`   ONLY if it reports v7+, i.e. it
            #      is the Go/native compiler that speaks `--lsp`. A local `tsc`
            #      from classic TypeScript (<=6) has no LSP mode and exits 1, so
            #      it must be skipped (e.g. TS 5.x in a pnpm monorepo package).
            #   3. the Nix-pinned typescript-go binary as a fallback.
            cmd = config.lib.nixvim.mkRaw ''
              function(dispatchers, cfg)
                local cmd = "${pkgs.typescript-go}/bin/tsc"
                if (cfg or {}).root_dir then
                  local local_tsgo = vim.fs.joinpath(cfg.root_dir, "node_modules/.bin", "tsgo")
                  local local_tsc = vim.fs.joinpath(cfg.root_dir, "node_modules/.bin", "tsc")
                  if vim.fn.executable(local_tsgo) == 1 then
                    cmd = local_tsgo
                  elseif vim.fn.executable(local_tsc) == 1 then
                    local version = vim.fn.system({ local_tsc, "--version" })
                    local major = tonumber((version or ""):match("Version (%d+)"))
                    if major and major >= 7 then
                      cmd = local_tsc
                    end
                  end
                end
                return vim.lsp.rpc.start({ cmd, "--lsp", "--stdio" }, dispatchers)
              end
            '';
            filetypes = [
              "javascript"
              "javascriptreact"
              "javascript.jsx"
              "typescript"
              "typescriptreact"
              "typescript.tsx"
            ];
            root_markers = [
              "tsconfig.json"
              "jsconfig.json"
              "package.json"
              ".git"
            ];
          };
        };
        biome.enable = true;
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
            local formatters = {
              nixd = true,
              biome = true,
              lua_ls = true,
              tinymist = true,
            }
            vim.lsp.buf.format {
              bufnr = args.buf,
              filter = function(client) return formatters[client.name] end,
            }
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
        invert_colors = "auto";
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
    };

  };

}
