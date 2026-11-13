{
  # Every `Roaming` key from KeePassXC's src/core/Config.cpp is set here, so the
  # generated keepassxc.ini is the complete source of truth. The `Local` keys
  # (window geometry, last-opened databases, quick unlock, ...) deliberately are
  # not: KeePassXC reads those from $XDG_CACHE_HOME/keepassxc/keepassxc.ini and
  # ignores them in this file.
  #
  # Because the file lives in the Nix store it is read-only, so KeePassXC shows a
  # dismissable "Access error for config file" banner and the Application
  # Settings dialog will not persist anything. That is the trade-off for having
  # it fully declarative.
  programs.keepassxc = {
    enable = true;

    settings = {
      General = {
        # Matches CONFIG_VERSION. Without it KeePassXC runs its config migration
        # on every launch and tries to write to the read-only file.
        ConfigVersion = 2;

        SingleInstance = true;
        RememberLastDatabases = true;
        NumberOfRememberedLastDatabases = 5;
        RememberLastKeyFiles = true;
        OpenPreviousDatabasesOnStartup = true;

        AutoSaveAfterEveryChange = true;
        AutoSaveNonDataChanges = true;
        AutoSaveOnExit = true;
        AutoReloadOnChange = true;
        UseAtomicSaves = true;
        BackupBeforeSave = true;
        # {TIME} defaults to dd_MM_yyyy_hh-mm-ss, so backups accumulate instead
        # of overwriting a single .old.kdbx.
        BackupFilePathPattern = "{DB_FILENAME}.{TIME}.old.kdbx";

        SearchLimitGroup = false;
        OpenURLOnDoubleClick = true;
        URLDoubleClickAction = 0; # 0 open URL, 1 copy URL, 2 edit entry
        MinimizeOnOpenUrl = false;
        HideWindowOnCopy = false;
        MinimizeOnCopy = true;
        DropToBackgroundOnCopy = false;
        AutoGeneratePasswordForNewEntries = true;
        MinimizeAfterUnlock = false;
        UseGroupIconOnEntryCreation = true;
        FaviconDownloadTimeout = 10;
        # Suppresses the first-run "check for updates?" prompt; nix does updates.
        UpdateCheckMessageShown = true;

        AutoTypeEntryTitleMatch = true;
        AutoTypeEntryURLMatch = true;
        AutoTypeDelay = 25;
        AutoTypeStartDelay = 500;
        AutoTypeHideExpiredEntry = true;
        AutoTypeDialogSortColumn = 0;
        AutoTypeDialogSortOrder = 0; # Qt::AscendingOrder
        # Global auto-type needs X11-style global hotkeys, which niri does not
        # provide. 0/0 leaves the shortcut unbound.
        GlobalAutoTypeKey = 0;
        GlobalAutoTypeModifiers = 0;
        GlobalAutoTypeRetypeTime = 15;
      };

      GUI = {
        Language = "system";
        # "classic" uses the plain Qt palette so stylix's qtct theming applies.
        # "auto"/"light"/"dark" load KeePassXC's own stylesheet and override it.
        ApplicationTheme = "classic";
        CompactMode = false;
        MonospaceNotes = true;
        ColorPasswords = true;
        HidePasswords = true;
        HideUsernames = false;

        HideMenubar = false;
        HideToolbar = false;
        MovableToolbar = false;
        HideGroupPanel = false;
        HidePreviewPanel = false;
        ToolButtonStyle = 0; # Qt::ToolButtonIconOnly

        ShowTrayIcon = true;
        TrayIconAppearance = "monochrome-light";
        MinimizeToTray = true;
        MinimizeOnClose = true;
        MinimizeOnStartup = false;
        # Reads as "is an autostart entry present?" rather than being applied
        # from config; see programs.keepassxc.autostart / niri spawn-at-startup.
        LaunchAtStartup = false;

        CheckForUpdates = false;
        CheckForUpdatesIncludeBetas = false;

        SearchWaitForEnter = false;
        ShowExpiredEntriesOnDatabaseUnlock = true;
        ShowExpiredEntriesOnDatabaseUnlockOffsetDays = 3;
      };

      Security = {
        ClearClipboard = true;
        ClearClipboardTimeout = 10;
        ClearSearch = true;
        ClearSearchTimeout = 5;

        LockDatabaseIdle = true;
        LockDatabaseIdleSeconds = 900;
        LockDatabaseMinimize = false;
        LockDatabaseScreenLock = true;
        LockDatabaseOnUserSwitch = true;
        RelockAutoType = false;

        PasswordsHidden = true;
        PasswordEmptyPlaceholder = false;
        HidePasswordPreviewPanel = true;
        HideTotpPreviewPanel = false;
        # Upstream key names, double prefix and lowercase "type" included.
        Security_HideNotes = false;
        AutotypeAsk = true;
        AutoTypeSkipMainWindowConfirmation = false;

        IconDownloadFallback = false;
        NoConfirmMoveEntryToRecycleBin = true;
        EnableCopyOnDoubleClick = false;
      };

      Browser = {
        Enabled = true;
        # Home Manager installs the native messaging manifests (see
        # programs.brave.nativeMessagingHosts), so KeePassXC must not rewrite
        # them at startup -- it cannot, and would log an error every launch.
        UpdateBinaryPath = false;
        SupportBrowserProxy = true;
        UseCustomProxy = false;
        CustomProxyLocation = "";

        ShowNotification = true;
        UnlockDatabase = true;
        MatchUrlScheme = true;
        BestMatchOnly = false;
        SearchInAllDatabases = false;
        AllowExpiredCredentials = false;
        AlwaysAllowAccess = false;
        AlwaysAllowUpdate = false;
        HttpAuthPermission = false;
        SupportKphFields = true;
        NoMigrationPrompt = false;
        Browser_AllowLocalhostWithPasskeys = false;
      };

      SSHAgent = {
        Enabled = true;
        UseOpenSSH = true;
        UsePageant = false; # Windows only
      };

      # Secret Service provider, so KeePassXC can stand in for gnome-keyring.
      # Still has to be opted into per database under Database Settings.
      FdoSecrets = {
        Enabled = true;
        ShowNotification = true;
        ConfirmAccessItem = true;
        ConfirmDeleteItem = true;
        UnlockBeforeSearch = true;
      };

      KeeShare = {
        QuietSuccess = false;
      };

      PasswordGenerator = {
        Type = 0; # 0 password, 1 diceware
        Length = 24;
        LowerCase = true;
        UpperCase = true;
        Numbers = true;
        SpecialChars = true;
        EASCII = false;
        AdvancedMode = false;
        Braces = false;
        Punctuation = false;
        Quotes = false;
        Dashes = false;
        Math = false;
        Logograms = false;
        AdditionalChars = "";
        ExcludedChars = "";
        ExcludeAlike = true;
        EnsureEvery = true;

        WordCount = 7;
        WordList = "eff_large.wordlist";
        WordCase = 0; # 0 lower, 1 UPPER, 2 Title
        # Quoted on purpose: an unquoted trailing space is stripped by QSettings.
        WordSeparator = ''"-"'';
      };

      Messages = {
        NoLegacyKeyFileWarning = false;
      };
    };
  };
}
