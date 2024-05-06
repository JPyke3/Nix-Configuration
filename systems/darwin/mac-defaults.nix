{...}: {
  system = {
    keyboard = {
      remapCapsLockToEscape = true;
    };
    defaults = {
      # Dock Settings
      dock = {
        autohide = true;
        mineffect = "scale";
        orientation = "left";
        minimize-to-application = true;
        persistent-apps = [
          "/Users/jacobpyke/Applications/Home Manager Apps/Firefox.app"
          "/Users/jacobpyke/Applications/Home Manager Apps/Kitty.app"
          "/System/Applications/Messages.app"
          "/System/Applications/System Settings.app"
        ];
        show-recents = false;

        # Disable Hover actions
        wvous-bl-corner = 1;
        wvous-br-corner = 1;
        wvous-tl-corner = 1;
        wvous-tr-corner = 1;
      };

      NSGlobalDomain = {
        AppleICUForce24HourTime = true;
        AppleInterfaceStyleSwitchesAutomatically = true;
        AppleMeasurementUnits = "Centimeters";
        AppleTemperatureUnit = "Celsius";
        NSAutomaticCapitalizationEnabled = false;
        NSAutomaticDashSubstitutionEnabled = false;
        NSAutomaticPeriodSubstitutionEnabled = false;
        NSAutomaticQuoteSubstitutionEnabled = false;
        NSAutomaticSpellingCorrectionEnabled = false;
        NSNavPanelExpandedStateForSaveMode = true;
        NSNavPanelExpandedStateForSaveMode2 = true;
        _HIHideMenuBar = true;
      };

      finder = {
        AppleShowAllExtensions = true;
        AppleShowAllFiles = true;
        CreateDesktop = false;
        FXDefaultSearchScope = "SCcf"; # Search current folder
        FXEnableExtensionChangeWarning = false;
        FXPreferredViewStyle = "Nlsv"; # List View
        ShowPathbar = true;
        ShowStatusBar = true;
      };

      loginwindow = {
        GuestEnabled = false;
      };

      menuExtraClock = {
        Show24Hour = true;
        ShowAMPM = false;
        ShowDate = 0; # Show the date only when space allows
      };

      screencapture = {
        location = "/Users/jacobpyke/Pictures";
        type = "png";
      };

      SoftwareUpdate = {
        AutomaticallyInstallMacOSUpdates = true;
      };
    };
  };
}
