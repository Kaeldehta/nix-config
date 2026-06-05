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
        vtsls.enable = true;
        biome.enable = true;
        lua_ls.enable = true;
        astro.enable = true;
      };

      keymaps = [
        {
          key = "gd";
          lspBufAction = "definition";
          mode = "n";
          options.desc = "Go to definition";
        }
        {
          key = "gD";
          lspBufAction = "declaration";
          mode = "n";
          options.desc = "Go to declaration";
        }
      ];
    };

    autoCmd = [
      {
        event = [ "BufWritePost" ];
        callback = config.lib.nixvim.mkRaw "function() vim.lsp.buf.format { 
          filter = function(client) return client.name ~= 'vtsls' and client.name ~= 'astro' and client.name ~= 'jdtls' end
          } end";
      }
    ];

    plugins.lspconfig.enable = true;

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
