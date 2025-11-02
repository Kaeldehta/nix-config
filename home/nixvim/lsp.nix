{ pkgs, config, ... }:
{
  programs.nixvim = {

    extraPackages = with pkgs; [ nixfmt-rfc-style ];

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
          filter = function(client) return client.name ~= 'vtsls' end
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
      settings.highlight.enable = true;
    };

  };

}
