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
    };

  };

}
