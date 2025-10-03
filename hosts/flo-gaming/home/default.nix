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

  home.stateVersion = "25.05";

}
