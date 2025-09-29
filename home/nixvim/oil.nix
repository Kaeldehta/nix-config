{ ... }: {
  programs.nixvim = {

    keymaps = [{
      action = "<cmd>Oil --float<CR>";
      key = "<leader>e";
      mode = "n";
    }];

    plugins.oil.enable = true;

  };

}
