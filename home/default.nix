{ pkgs, ... }:

{
  imports = [ ./nixvim ];
  fonts.fontconfig.enable = true;

  catppuccin.enable = true;

  home.packages = with pkgs; [
    discord
    pre-commit
    postman
    slack
    uv
    pnpm
    nodejs_20
  ];

  home.shellAliases = {
    lg = "lazygit";
  };

  programs.brave = {
    enable = true;
    extensions = [
      { id = "nngceckbapebfimnlniiiahkandclblb"; }
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
    font = {
      size = 16;
      name = "FiraCode Nerd Font";
    };
  };

}
