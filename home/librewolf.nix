{ pkgs, ... }:

let
  addons = pkgs.firefox-addons;

  # uBlock Origin is installed by LibreWolf itself.
  commonExtensions = with addons; [
    refined-github
    vimium
  ];

  # Relax LibreWolf's privacy defaults enough to stay logged in to web apps.
  settings = {
    "privacy.sanitize.sanitizeOnShutdown" = false;
    "privacy.resistFingerprinting" = false;
    "webgl.disabled" = false;
    # Enable Home Manager installed extensions without a prompt.
    "extensions.autoDisableScopes" = 0;
  };
in
{
  programs.librewolf = {
    enable = true;

    profiles = {
      private = {
        id = 0;
        isDefault = true;
        inherit settings;
        extensions.packages = commonExtensions ++ [ addons.keepassxc-browser ];
      };

      work = {
        id = 1;
        inherit settings;
        extensions.packages = commonExtensions ++ [ addons.onepassword-password-manager ];
      };
    };
  };
}
