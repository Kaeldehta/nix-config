{ pkgs, config, ... }:
{
  programs.nixvim = {

    extraPackages = [ pkgs.opencode ];

    extraPlugins = [
      (pkgs.vimUtils.buildVimPlugin {
        name = "99";
        src = pkgs.fetchFromGitHub {
          owner = "ThePrimeagen";
          repo = "99";
          rev = "0172d3caae2d8b967c9d47aa7557295f1481e5df";
          hash = "sha256-ppFQaLSie9tSm2nlTrZPU47QyOaeqNMQjJf4vaIXgFo=";
        };
        nvimSkipModule = [ "99.editor.lsp" ];
      })
    ];

    extraConfigLua = ''
      local _99 = require("99")
      local cwd = vim.uv.cwd()
      local basename = vim.fs.basename(cwd)

      _99.setup({
        model = "anthropic/claude-opus-4-7",
        logger = {
          level = _99.DEBUG,
          path = "/tmp/" .. basename .. ".99.debug",
          print_on_error = true,
        },
        md_files = { "AGENT.md" },
      })
    '';

    keymaps = [
      {
        key = "<leader>9s";
        action = config.lib.nixvim.mkRaw "function() require('99').search() end";
        mode = "n";
        options.desc = "99: Search";
      }
      {
        key = "<leader>9v";
        action = config.lib.nixvim.mkRaw "function() require('99').visual() end";
        mode = "v";
        options.desc = "99: Visual Replace";
      }
      {
        key = "<leader>9x";
        action = config.lib.nixvim.mkRaw "function() require('99').stop_all_requests() end";
        mode = "n";
        options.desc = "99: Stop All Requests";
      }
      {
        key = "<leader>9l";
        action = config.lib.nixvim.mkRaw "function() require('99').view_logs() end";
        mode = "n";
        options.desc = "99: View Logs";
      }
      {
        key = "<leader>9o";
        action = config.lib.nixvim.mkRaw "function() require('99').open() end";
        mode = "n";
        options.desc = "99: Open Previous Results";
      }
      {
        key = "<leader>9c";
        action = config.lib.nixvim.mkRaw "function() require('99').clear_previous_requests() end";
        mode = "n";
        options.desc = "99: Clear Previous Requests";
      }
    ];

  };
}
