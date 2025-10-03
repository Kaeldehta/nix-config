{ pkgs, config, ... }:
{
  programs.nixvim = {

    extraPackages = with pkgs; [ nixfmt ];

    lsp = {
      servers = {
        nil_ls = {
          enable = true;
          settings = {
            settings = {
              nil.formatting.command = [ "nixfmt" ];
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
        }
        {
          key = "gD";
          lspBufAction = "declaration";
          mode = "n";
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
    };

    plugins.treesitter = {
      enable = true;
      settings.highlight.enable = true;
    };


  };

}
