{ lib, ... }:
let
  noctaliaMsg =
    verb:
    [
      "noctalia"
      "msg"
    ]
    ++ verb;

  # Mod+N focuses workspace N, Mod+Ctrl+N moves the current column there.
  workspaceBinds = lib.listToAttrs (
    lib.concatMap (ws: [
      (lib.nameValuePair "Mod+${toString ws}" { focus-workspace._args = [ ws ]; })
      (lib.nameValuePair "Mod+Ctrl+${toString ws}" { move-column-to-workspace._args = [ ws ]; })
    ]) (lib.range 1 9)
  );
in
{

  # Noctalia replaces the bar, launcher, notification daemon and lock screen in
  # this session.
  programs.noctalia = {
    enable = true;
    # Runs as a user service: restarts on failure and on config changes, and is
    # ordered against graphical-session.target.
    systemd.enable = true;
    settings = {
      shell = {
        polkit_agent = true;
        settings_show_advanced = true;
      };
      bar.main = {
        position = "top";
        start = [
          "launcher"
          "workspaces"
        ];
        center = [ "clock" ];
        end = [
          "media"
          "tray"
          "notifications"
          "clipboard"
          "network"
          "bluetooth"
          "volume"
          "control-center"
          "session"
        ];
      };
    };
  };

  wayland.windowManager.niri = {
    enable = true;
    # Portals and the session unit come from programs.niri in
    # hosts/flo-gaming/configuration.nix. The package is left at its default so
    # checkConfig validates config.kdl at build time; it resolves to the same
    # store path as the system one.
    portalPackage = null;
    systemd.enable = false;

    settings = {
      input = {
        mouse.accel-speed = -0.5;
        focus-follows-mouse = { };
      };

      layout = {
        gaps = 8;
        focus-ring.width = 2;
      };

      prefer-no-csd = { };
      hotkey-overlay.skip-at-startup = { };

      # Applies to everything niri spawns, unlike home.sessionVariables which
      # only reaches processes started from a login shell.
      environment.NIXOS_OZONE_WL = "1";

      binds = {
        "Mod+Shift+Slash".show-hotkey-overlay = { };

        # Applications.
        "Mod+T" = {
          _props.hotkey-overlay-title = "Open a Terminal";
          spawn = [ "kitty" ];
        };
        "Mod+E" = {
          _props.hotkey-overlay-title = "Open the File Manager";
          spawn = [
            "kitty"
            "-e"
            "yazi"
          ];
        };

        # Noctalia panels and actions.
        "Mod+Space" = {
          _props.hotkey-overlay-title = "Open the Launcher";
          spawn = noctaliaMsg [
            "panel-toggle"
            "launcher"
          ];
        };
        "Super+Alt+L" = {
          _props.hotkey-overlay-title = "Lock the Screen";
          spawn = noctaliaMsg [
            "session"
            "lock"
          ];
        };
        "Mod+N".spawn = noctaliaMsg [
          "panel-toggle"
          "control-center"
          "notifications"
        ];
        "Mod+Shift+V".spawn = noctaliaMsg [
          "panel-toggle"
          "clipboard"
        ];
        "Mod+Escape".spawn = noctaliaMsg [
          "panel-toggle"
          "session"
        ];
        "Print".spawn = noctaliaMsg [ "screenshot-region" ];
        "Ctrl+Print".spawn = noctaliaMsg [ "screenshot-fullscreen" ];

        # Audio. Routed through noctalia so its OSD shows.
        "XF86AudioRaiseVolume" = {
          _props.allow-when-locked = true;
          spawn = noctaliaMsg [ "volume-up" ];
        };
        "XF86AudioLowerVolume" = {
          _props.allow-when-locked = true;
          spawn = noctaliaMsg [ "volume-down" ];
        };
        "XF86AudioMute" = {
          _props.allow-when-locked = true;
          spawn = noctaliaMsg [ "volume-mute" ];
        };
        "XF86AudioMicMute" = {
          _props.allow-when-locked = true;
          spawn = noctaliaMsg [ "mic-mute" ];
        };

        # Backlight, and external monitors over DDC/CI.
        "XF86MonBrightnessUp" = {
          _props.allow-when-locked = true;
          spawn = noctaliaMsg [ "brightness-up" ];
        };
        "XF86MonBrightnessDown" = {
          _props.allow-when-locked = true;
          spawn = noctaliaMsg [ "brightness-down" ];
        };

        # Windows and columns.
        "Mod+Q" = {
          _props.repeat = false;
          close-window = { };
        };
        "Mod+O" = {
          _props.repeat = false;
          toggle-overview = { };
        };
        "Mod+V".toggle-window-floating = { };
        "Mod+Shift+Tab".switch-focus-between-floating-and-tiling = { };
        "Mod+W".toggle-column-tabbed-display = { };
        "Mod+F".maximize-column = { };
        "Mod+Shift+F".fullscreen-window = { };
        "Mod+M".maximize-window-to-edges = { };
        "Mod+Ctrl+F".expand-column-to-available-width = { };
        "Mod+C".center-column = { };
        "Mod+Ctrl+C".center-visible-columns = { };

        # Focus.
        "Mod+Left".focus-column-left = { };
        "Mod+Down".focus-window-down = { };
        "Mod+Up".focus-window-up = { };
        "Mod+Right".focus-column-right = { };
        "Mod+H".focus-column-left = { };
        "Mod+J".focus-window-down = { };
        "Mod+K".focus-window-up = { };
        "Mod+L".focus-column-right = { };
        "Mod+Home".focus-column-first = { };
        "Mod+End".focus-column-last = { };

        # Move within the workspace.
        "Mod+Ctrl+Left".move-column-left = { };
        "Mod+Ctrl+Down".move-window-down = { };
        "Mod+Ctrl+Up".move-window-up = { };
        "Mod+Ctrl+Right".move-column-right = { };
        "Mod+Ctrl+H".move-column-left = { };
        "Mod+Ctrl+J".move-window-down = { };
        "Mod+Ctrl+K".move-window-up = { };
        "Mod+Ctrl+L".move-column-right = { };
        "Mod+Ctrl+Home".move-column-to-first = { };
        "Mod+Ctrl+End".move-column-to-last = { };

        # Monitors.
        "Mod+Shift+Left".focus-monitor-left = { };
        "Mod+Shift+Down".focus-monitor-down = { };
        "Mod+Shift+Up".focus-monitor-up = { };
        "Mod+Shift+Right".focus-monitor-right = { };
        "Mod+Shift+H".focus-monitor-left = { };
        "Mod+Shift+J".focus-monitor-down = { };
        "Mod+Shift+K".focus-monitor-up = { };
        "Mod+Shift+L".focus-monitor-right = { };
        "Mod+Shift+Ctrl+Left".move-column-to-monitor-left = { };
        "Mod+Shift+Ctrl+Down".move-column-to-monitor-down = { };
        "Mod+Shift+Ctrl+Up".move-column-to-monitor-up = { };
        "Mod+Shift+Ctrl+Right".move-column-to-monitor-right = { };
        "Mod+Shift+Ctrl+H".move-column-to-monitor-left = { };
        "Mod+Shift+Ctrl+J".move-column-to-monitor-down = { };
        "Mod+Shift+Ctrl+K".move-column-to-monitor-up = { };
        "Mod+Shift+Ctrl+L".move-column-to-monitor-right = { };

        # Workspaces.
        "Mod+Page_Down".focus-workspace-down = { };
        "Mod+Page_Up".focus-workspace-up = { };
        "Mod+U".focus-workspace-down = { };
        "Mod+I".focus-workspace-up = { };
        "Mod+Ctrl+Page_Down".move-column-to-workspace-down = { };
        "Mod+Ctrl+Page_Up".move-column-to-workspace-up = { };
        "Mod+Ctrl+U".move-column-to-workspace-down = { };
        "Mod+Ctrl+I".move-column-to-workspace-up = { };
        "Mod+Shift+Page_Down".move-workspace-down = { };
        "Mod+Shift+Page_Up".move-workspace-up = { };
        "Mod+Shift+U".move-workspace-down = { };
        "Mod+Shift+I".move-workspace-up = { };

        # Mouse wheel.
        "Mod+WheelScrollDown" = {
          _props.cooldown-ms = 150;
          focus-workspace-down = { };
        };
        "Mod+WheelScrollUp" = {
          _props.cooldown-ms = 150;
          focus-workspace-up = { };
        };
        "Mod+Ctrl+WheelScrollDown" = {
          _props.cooldown-ms = 150;
          move-column-to-workspace-down = { };
        };
        "Mod+Ctrl+WheelScrollUp" = {
          _props.cooldown-ms = 150;
          move-column-to-workspace-up = { };
        };
        "Mod+WheelScrollRight".focus-column-right = { };
        "Mod+WheelScrollLeft".focus-column-left = { };
        "Mod+Ctrl+WheelScrollRight".move-column-right = { };
        "Mod+Ctrl+WheelScrollLeft".move-column-left = { };
        "Mod+Shift+WheelScrollDown".focus-column-right = { };
        "Mod+Shift+WheelScrollUp".focus-column-left = { };
        "Mod+Ctrl+Shift+WheelScrollDown".move-column-right = { };
        "Mod+Ctrl+Shift+WheelScrollUp".move-column-left = { };

        # Column contents.
        "Mod+BracketLeft".consume-or-expel-window-left = { };
        "Mod+BracketRight".consume-or-expel-window-right = { };
        "Mod+Comma".consume-window-into-column = { };
        "Mod+Period".expel-window-from-column = { };

        # Sizing.
        "Mod+R".switch-preset-column-width = { };
        "Mod+Shift+R".switch-preset-column-width-back = { };
        "Mod+Ctrl+Shift+R".switch-preset-window-height = { };
        "Mod+Ctrl+R".reset-window-height = { };
        "Mod+Minus".set-column-width = "-10%";
        "Mod+Equal".set-column-width = "+10%";
        "Mod+Shift+Minus".set-window-height = "-10%";
        "Mod+Shift+Equal".set-window-height = "+10%";

        # Session.
        "Mod+Shift+Escape" = {
          _props.allow-inhibiting = false;
          toggle-keyboard-shortcuts-inhibit = { };
        };
        "Mod+Shift+E".quit = { };
        "Ctrl+Alt+Delete".quit = { };
        "Mod+Shift+P".power-off-monitors = { };
      }
      // workspaceBinds;
    };
  };

}
