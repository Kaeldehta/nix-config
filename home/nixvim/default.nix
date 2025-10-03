{ ... }:

{

  imports = [
    ./oil.nix
    ./lsp.nix
    ./mini.nix
  ];

  programs.nixvim = {
    enable = true;
    defaultEditor = true;
    colorschemes.catppuccin.enable = true;

    diagnostic.settings = {
      virtual_lines = {
        current_line = true;
      };

    };

    globals = {
      mapleader = " ";
    };

    keymaps = [
      {
        key = "<S-l>";
        action = "<cmd>bnext<CR>";
        mode = "n";
        options.desc = "Next Buffer";
      }
      {
        key = "<S-h>";
        action = "<cmd>bprev<CR>";
        mode = "n";
        options.desc = "Prev Buffer";
      }
      {
        key = "bd";
        action = "<cmd>bdelete<CR>";
        mode = "n";
        options.desc = "Close current buffer";
      }
    ];

    opts = {
      number = true;
      relativenumber = true;
      swapfile = false;
      winborder = "rounded";
      signcolumn = "yes";
    };

    plugins = {
      sleuth.enable = true;
      which-key.enable = true;
      ts-comments.enable = true;
      ts-autotag.enable = true;
      bufferline.enable = true;
      web-devicons.enable = true;
    };

  };

}
