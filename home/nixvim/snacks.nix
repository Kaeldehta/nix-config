{ pkgs, config, ... }:
{

  programs.nixvim = {

    extraPackages = with pkgs; [
      ripgrep
      fd
    ];

    plugins.snacks = {
      enable = true;
      settings = {
        picker.enabled = true;
      };
    };

    keymaps = [
      {
        key = "<leader><leader>";
        action = config.lib.nixvim.mkRaw "function() Snacks.picker.files() end";
        mode = "n";
        options.desc = "Open Files picker";
      }
      {
        key = "<leader>,";
        action = config.lib.nixvim.mkRaw "function() Snacks.picker.buffers() end";
        mode = "n";
        options.desc = "Open Buffers picker";
      }
      {
        key = "<leader>g";
        action = config.lib.nixvim.mkRaw "function() Snacks.picker.grep() end";
        mode = "n";
        options.desc = "Open Grep";
      }
    ];

  };

}
