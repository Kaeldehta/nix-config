{ pkgs, ... }:

{
  imports = [ ./nixvim ./hyprland.nix ];

  home.username = "florian";
  home.homeDirectory = "/home/florian";

  fonts.fontconfig.enable = true;

  home.packages = with pkgs; [
    lazygit
    brave
    networkmanagerapplet
    discord
    # TODO: Move to yazi extraPackages
    fzf
  ];

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
    shellIntegration = { enableZshIntegration = true; };
    font = {
      size = 16;
      name = "FiraCode Nerd Font";
    };
  };

  home.stateVersion = "25.05";

}

