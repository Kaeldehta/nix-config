{pkgs, ...}: {

  nixpkgs.config.allowUnfree = true;

  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  services.tailscale.enable = true;

  fonts.packages = with pkgs; [
    nerd-fonts.fira-code
  ];
}
