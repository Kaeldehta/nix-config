{ ... }:
{
  programs.nixvim = {

    keymaps = [
      {
        action = "<cmd>Oil --float<CR>";
        key = "<leader>e";
        mode = "n";
        options.desc = "Opens Oil (floating window)";
      }
    ];

    plugins.oil.enable = true;

  };

}
