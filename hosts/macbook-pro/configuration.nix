{ pkgs, inputs, ... }:
{
  imports = [ ../../configuration.nix ];

  system.primaryUser = "florianstutzky";

  users.users.florianstutzky.home = "/Users/florianstutzky";

  # List packages installed in system profile. To search by name, run:
  # $ nix-env -qaP | grep wget
  environment.systemPackages = [
    pkgs.vim
    pkgs.rustup
    pkgs.ripgrep
    pkgs.fzf
    pkgs.ast-grep
    pkgs.kanata
    pkgs.git-lfs
    pkgs.ruff
    pkgs.python313
    pkgs.fd
    pkgs.jdk
    pkgs.nodejs_20
    pkgs.pnpm
    pkgs.tree-sitter
    pkgs.raycast
    pkgs.stow
    pkgs.typescript-language-server
    pkgs.biome
    pkgs.claude-code
    pkgs.nil
    pkgs.nixpkgs-fmt
    pkgs.google-cloud-sdk
  ];

  system.defaults = {
    dock.autohide = true;
    dock.persistent-apps = [
      "${pkgs.slack}/Applications/Slack.app"
      "/Applications/Xcode.app"
    ];
    dock.expose-group-apps = true;
    spaces.spans-displays = true;
  };

  services.aerospace = {
    enable = true;
    settings = {
      mode.main.binding = {
        alt-shift-1 = "move-node-to-workspace 1";
        alt-shift-2 = "move-node-to-workspace 2";
        alt-shift-3 = "move-node-to-workspace 3";
        alt-shift-4 = "move-node-to-workspace 4";
        alt-shift-5 = "move-node-to-workspace 5";
        alt-shift-6 = "move-node-to-workspace 6";
        alt-shift-7 = "move-node-to-workspace 7";
        alt-shift-8 = "move-node-to-workspace 8";
        alt-shift-9 = "move-node-to-workspace 9";

        alt-1 = "workspace 1";
        alt-2 = "workspace 2";
        alt-3 = "workspace 3";
        alt-4 = "workspace 4";
        alt-5 = "workspace 5";
        alt-6 = "workspace 6";
        alt-7 = "workspace 7";
        alt-8 = "workspace 8";
        alt-9 = "workspace 9";
      };
      default-root-container-layout = "tiles";
      default-root-container-orientation = "auto";
      # on-window-detected = [
      #   {
      #     "if".app-id = "com.mitchellh.ghostty";
      #     run = "move-node-to-workspace 2";
      #   }
      #   {
      #     "if".app-id = "com.apple.dt.Xcode";
      #     run = "move-node-to-workspace 5";
      #   }
      # ];

    };
  };

  homebrew = {
    enable = true;

    taps = [
      "anomalyco/tap"
    ];

    brews = [
      "opencode"
    ];

    casks = [
      "anydesk"
      "arturia-software-center"
      "docker-desktop"
      "tuist"
    ];

    masApps = {
      "Xcode" = 497799835;
      "Logic Pro" = 634148309;
      "MainStage" = 634159523;
    };

    onActivation.cleanup = "zap";
    onActivation.autoUpdate = true;
    onActivation.upgrade = true;

  };

  # Set Git commit hash for darwin-version.
  system.configurationRevision = inputs.self.rev or inputs.self.dirtyRev or null;

  # Used for backwards compatibility, please read the changelog before changing.
  # $ darwin-rebuild changelog
  system.stateVersion = 6;

  # The platform the configuration will be used on.
  nixpkgs.hostPlatform = "aarch64-darwin";
}
