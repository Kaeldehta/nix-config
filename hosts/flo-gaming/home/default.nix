{ pkgs, ... }:
{

  imports = [
    ./hyprland.nix
    ../../../home
  ];

  home.username = "florian";
  home.homeDirectory = "/home/florian";

  home.packages = with pkgs; [
    networkmanagerapplet
  ];

  programs.mangohud = {
    enable = true;
    enableSessionWide = true;
  };

  home.stateVersion = "25.05";

}
