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

  programs.brave = {
    enable = true;
    extensions = [
      { id = "nngceckbapebfimnlniiiahkandclblb"; }
      { id = "hlepfoohegkhhmjieoechaddaejaokhf"; }
    ];
  };

  programs.lazygit.enable = true;

  programs.git = {
    enable = true;
    userName = "Kaeldehta";
    userEmail = "flo@visiolab.io";
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
  };

  programs.kitty = {
    enable = true;
    shellIntegration = {
      enableZshIntegration = true;
    };
  };

}
