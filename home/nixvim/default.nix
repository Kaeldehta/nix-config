{ ... }:

{

  imports = [ ./oil.nix ./lsp.nix ./mini.nix ];

  programs.nixvim = {
    enable = true;
    defaultEditor = true;
    colorschemes.catppuccin.enable = true;

    globals = { mapleader = " "; };

    opts = {
      number = true;
      relativenumber = true;
      swapfile = false;
    };

    plugins = { sleuth.enable = true; };

  };

}
