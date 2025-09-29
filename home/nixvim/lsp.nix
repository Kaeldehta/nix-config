{ pkgs, ... }: {

  programs.nixvim = {

    extraPackages = with pkgs; [ nixfmt ];

    lsp = {
      servers = {
        nil_ls = {
          enable = true;
          settings = { settings = { nil.formatting.command = [ "nixfmt" ]; }; };
        };
        vtls.enable = true;
        biome.enable = true;
        lua_ls.enable = true;
      };
    };

    keymaps = [{
      action = { __raw = "vim.lsp.buf.format"; };
      key = "<leader>f";
      mode = "n";
    }];

    autoCmd = [{
      event = [ "BufWritePost" ];
      callback = { __raw = "function() vim.lsp.buf.format() end"; };
    }];

    plugins.lspconfig.enable = true;

  };

}
