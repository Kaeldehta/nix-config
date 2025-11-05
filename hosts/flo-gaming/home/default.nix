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
    rusty-path-of-building
    modrinth-app
  ];

  programs.mangohud = {
    enable = true;
  };

  home.stateVersion = "25.05";

}
