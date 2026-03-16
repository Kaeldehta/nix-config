{ pkgs, ... }:

{
  imports = [ ./nixvim ];

  home.packages = with pkgs; [
    discord
    pre-commit
    postman
    slack
    uv
    pnpm
    nodejs_20
    jdk
  ];

  home.shellAliases = {
    lg = "lazygit";
  };

  programs.opencode = {
    enable = true;
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
    settings.user = {
      name = "Kaeldehta";
      email = "flo@visiolab.io";
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

}
