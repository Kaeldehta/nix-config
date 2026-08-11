{ ... }:
{

  programs.nixvim = {

    keymaps = [
      {
        action = "<cmd>Pick files<CR>";
        key = "<leader><leader>";
        mode = "n";
        options.desc = "Open Files picker";
      }
      {
        action = "<cmd>Pick buffers<CR>";
        key = "<leader>,";
        mode = "n";
        options.desc = "Open Buffers picker";
      }
      {
        action = "<cmd>Pick grep<CR>";
        key = "<leader>g";
        mode = "n";
        options.desc = "Open Grep";
      }
    ];

    plugins.mini = {
      enable = true;
      modules = {
        pick = {
          # Reuse match results as the prompt grows/shrinks. Noticeable on the
          # big item sets that `Pick grep` and reference lookups produce.
          options.use_cache = true;
        };
        pairs = { };
        # Extra pickers on top of mini.pick (LSP references, symbols, ...).
        extra = { };
        # mini.pick prefers MiniIcons over nvim-web-devicons when present, and
        # it's what gives the symbol pickers their LSP kind icons.
        icons = { };
      };
    };

  };

}
