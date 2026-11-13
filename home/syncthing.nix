{ lib, ... }:

let
  # Device IDs are not secret. Get one with `syncthing --device-id` (or the web
  # UI at http://127.0.0.1:8384 -> Actions -> Show ID) and add it here; every
  # device listed is shared the KeePass folder. A host's own entry is harmless.
  devices = {
    # flo-gaming.id = "XXXXXXX-XXXXXXX-XXXXXXX-XXXXXXX-XXXXXXX-XXXXXXX-XXXXXXX-XXXXXXX";
    # macbook-pro.id = "...";
    # iphone.id = "...";
  };
in
{
  services.syncthing = {
    enable = true;

    settings = {
      inherit devices;

      folders.keepass = {
        path = "~/Sync/keepass";
        label = "KeePass";
        devices = lib.attrNames devices;
        # Keeps replaced/deleted copies in .stversions, thinned out over a year,
        # so a bad save that syncs everywhere can still be rolled back.
        versioning = {
          type = "staggered";
          params = {
            cleanInterval = "3600";
            maxAge = "31536000";
          };
        };
        ignorePatterns = [
          # KeePassXC's BackupBeforeSave copies; each device keeps its own.
          "*.old.kdbx"
        ];
      };

      options = {
        urAccepted = -1;
      };
    };
  };
}
