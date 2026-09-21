{ pkgs, ... }:
{

  imports = [
    ./niri.nix
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

  programs.yazi = {
    enable = true;
    enableZshIntegration = true;
    shellWrapperName = "y";

    extraPackages = with pkgs; [
      fd
      ripgrep
      fzf
      jq
      poppler-utils
      ffmpeg
      imagemagick
      p7zip
      exiftool
    ];

    settings = {
      mgr = {
        sort_by = "natural";
        sort_dir_first = true;
        linemode = "mtime";
        scrolloff = 5;
      };
      preview = {
        max_width = 1920;
        max_height = 1080;
      };
      opener.open = [
        {
          run = ''xdg-open "$@"'';
          desc = "Open";
          orphan = true;
        }
      ];
    };
  };

  xdg.desktopEntries.yazi = {
    name = "Yazi";
    genericName = "File Manager";
    comment = "Browse files";
    icon = "yazi";
    exec = "kitty --app-id=yazi -o confirm_os_window_close=0 -e yazi %f";
    terminal = false;
    categories = [
      "System"
      "FileTools"
      "FileManager"
    ];
    mimeType = [ "inode/directory" ];
  };

  xdg.mimeApps = {
    enable = true;
    defaultApplications = {
      "inode/directory" = "yazi.desktop";
      "x-scheme-handler/slack" = "slack.desktop";
      "x-scheme-handler/claude-cli" = "claude-code-url-handler.desktop";
    };
  };

  home.stateVersion = "25.05";

}
