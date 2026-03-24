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
    (prismlauncher.override {
      jdks = [jdk21 jdk25];
    })
  ];

  programs.mangohud = {
    enable = true;
  };

  home.stateVersion = "25.05";

}
