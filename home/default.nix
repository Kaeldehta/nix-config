{ pkgs, ... }:

{
  imports = [ ./nixvim ];

  home.packages = with pkgs; [
    discord
    pre-commit
    postman
    slack
    stripe-cli
    uv
    pnpm
    nodejs_22
    jdk25
    gh
    terraform
    terragrunt
    pnpm
  ];

  home.shellAliases = {
    lg = "lazygit";
  };

  programs.mcp = {
    enable = true;
    servers = {
      linear = {
        url = "https://mcp.linear.app/mcp";
      };
    };
  };

  programs.mise = {
    enable = true;
    enableZshIntegration = true;
  };

  programs.claude-code = {
    enable = true;
    enableMcpIntegration = true;
  };

  programs.opencode = {
    enable = true;
    enableMcpIntegration = true;
  };

  programs.zoxide = {
    enable = true;
    enableZshIntegration = true;
  };

  programs.brave = {
    enable = true;
    extensions = [
      { id = "nngceckbapebfimnlniiiahkandclblb"; }
      { id = "hlepfoohegkhhmjieoechaddaejaokhf"; }
      { id = "aeeninnnlhgaojlolnbpljadhbionlal"; }
      { id = "dbepggeogbaibhgnhhndojpepiihcmeb"; }
    ];
  };

  programs.lazygit.enable = true;

  programs.git = {
    enable = true;
    settings = {
      user = {
        name = "Kaeldehta";
        email = "flo@visiolab.io";
      };
      init.defaultBranch = "main";
    };
    signing = {
      key = "~/.ssh/id_ed25519.pub";
      format = "ssh";
      signByDefault = true;
    };
    lfs.enable = true;
  };

  programs.zsh = {
    enable = true;
    enableCompletion = true;
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;
  };

  programs.yazi = {
    enable = true;
    enableZshIntegration = true;
    extraPackages = with pkgs; [ fzf ];
    shellWrapperName = "y";
  };

  programs.kitty = {
    enable = true;
    shellIntegration = {
      enableZshIntegration = true;
    };
  };

  programs.jujutsu = {
    enable = true;
    settings = {
user = {
      email = "flo@visiolab.io";
      name = "Kaeldehta";
    };
    };
      };

}
