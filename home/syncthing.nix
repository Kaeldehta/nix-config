{ lib, ... }:

let
  # Device IDs are not secret. Get one with `syncthing device-id` (or the web
  # UI at http://127.0.0.1:8384 -> Actions -> Show ID) and add it here; every
  # device listed is shared the KeePass folder. A host's own entry is harmless.
  devices = {
    flo-gaming.id = "W6AB4KB-D2AWIBT-6JVYEWH-XDKNHV4-DXHCD7E-T3IFH44-OGH56RM-H4K6NQR";
    # macbook-pro.id = "...";
    iphone.id = "KEEOPEI-BLHWOI2-K5SVZIV-FGV6JNI-TXCH3H3-CPOUCDA-INEKUHO-PN7MHQC";
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
