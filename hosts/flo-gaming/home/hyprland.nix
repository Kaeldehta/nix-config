{ ... }:
{

  gtk.enable = true;
  home.pointerCursor.gtk.enable = true;

  catppuccin.cursors.enable = true;
  catppuccin.waybar.mode = "createLink";

  home.sessionVariables.NIXOS_OZONE_WL = "1";

  programs.hyprshot.enable = true;

  programs.rofi.enable = true;

  programs.waybar = {
    enable = true;
    systemd.enable = true;
    style = ./waybar.css;
    settings = {
      mainBar = {
        layer = "top";
        position = "top";
        height = 30;
        modules-left = [ "hyprland/workspaces" ];
        modules-center = [ "hyprland/window" ];
        modules-right = [
          "clock"
          "temperature"
          "tray"
        ];
      };
    };
  };

  services.swaync = {
    enable = true;
  };

  wayland.windowManager.hyprland = {
    enable = true;
    package = null;
    portalPackage = null;
    settings = {
      "$mod" = "SUPER";
      "$terminal" = "kitty";
      "$menu" = "rofi -show drun";
      "$fileManager" = "$terminal bash -c yazi; exit";
      bind = [
        "$mod, Q, exec, $terminal"
        "$mod, M, exit,"
        "$mod, space, exec, $menu"
        "$mod, C, killactive,"
        "$mod, E, exec, $fileManager"
        "$mod, h, movefocus, l"
        "$mod, j, movefocus, d"
        "$mod, k, movefocus, u"
        "$mod, l, movefocus, r"
        "$mod, f, fullscreen"
      ]
      ++ (builtins.concatLists (
        builtins.genList (
          i:
          let
            ws = i + 1;
          in
          [
            "$mod, code:1${toString i}, workspace, ${toString ws}"
            "$mod SHIFT, code:1${toString i}, movetoworkspace, ${toString ws}"
          ]
        ) 9
      ));
      bindm = [
        "$mod, mouse:272, movewindow"
        "$mod, mouse:273, resizewindow"
      ];
      monitor = [
        "DP-3,preferred,auto,auto"
        "HDMI-A-1,preferred,auto,auto"
      ];
      general = {
        no_border_on_floating = true;
        "col.active_border" = "$accent";
      };
      decoration = {
        rounding = 5;
      };
      windowrule = [
        "suppressevent maximize, class:*"
        "nofocus,class:^$,title:^$,xwayland:1,floating:1,fullscreen:0,pinned:0"
      ];
    };

  };

}
