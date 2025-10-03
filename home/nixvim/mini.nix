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
        pick = { };
        pairs = { };
      };
    };

  };

}
