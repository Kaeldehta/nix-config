{ ... }:
{

  programs.nixvim = {

    keymaps = [
      {
        action = "<cmd>Pick files<CR>";
        key = "<leader><leader>";
        mode = "n";
      }
    ];

    plugins.mini = {
      enable = true;
      modules = {
        pick = { };
        pairs = {};
        tabline = {};
      };
    };

  };

}
