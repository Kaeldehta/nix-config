{ pkgs, ... }:

{
  imports = [ ./nixvim ];
  fonts.fontconfig.enable = true;

  home.packages = with pkgs; [
    discord
    # TODO: Move to yazi extraPackages
    fzf
    pre-commit
    postman
    slack
    uv
  ];

  programs.chromium = {
    enable = true;
    package = pkgs.brave;
    extensions = [
      { id = "nngceckbapebfimnlniiiahkandclblb"; }
    ];
  };

  programs.lazygit.enable = true;

  catppuccin = {
    kitty.enable = true;
    brave.enable = true;
  };

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
