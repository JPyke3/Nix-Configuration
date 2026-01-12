{
  config,
  pkgs,
  ...
}: {
  programs.firefox = {
    enable = true;
    package = pkgs.firefox;

    policies = {
      # Disable built-in password manager (use Bitwarden instead)
      PasswordManagerEnabled = false;
      OfferToSaveLogins = false;

      # Disable Firefox Relay email masks
      FirefoxRelay = {
        Enabled = false;
      };

      ExtensionSettings = {
        # Bitwarden - Password Manager
        "{446900e4-71c2-419f-a6a7-df9c091e268b}" = {
          install_url = "https://addons.mozilla.org/firefox/downloads/latest/bitwarden-password-manager/latest.xpi";
          installation_mode = "force_installed";
        };
        # uBlock Origin - Ad Blocker
        "uBlock0@raymondhill.net" = {
          install_url = "https://addons.mozilla.org/firefox/downloads/latest/ublock-origin/latest.xpi";
          installation_mode = "force_installed";
        };
        # Dark Reader - Dark Mode
        "addon@darkreader.org" = {
          install_url = "https://addons.mozilla.org/firefox/downloads/latest/darkreader/latest.xpi";
          installation_mode = "force_installed";
        };
        # SponsorBlock - Skip Sponsored Segments
        "sponsorBlocker@ajay.app" = {
          install_url = "https://addons.mozilla.org/firefox/downloads/latest/sponsorblock/latest.xpi";
          installation_mode = "force_installed";
        };
        # Buster - CAPTCHA Solver
        "{e58d3966-3d76-4cd9-8552-1582fbc800c1}" = {
          install_url = "https://addons.mozilla.org/firefox/downloads/latest/buster-captcha-solver/latest.xpi";
          installation_mode = "force_installed";
        };
        # Aria2 Integration - Download Manager
        "{e2488817-3d73-4013-850d-b66c5e42d505}" = {
          install_url = "https://addons.mozilla.org/firefox/downloads/latest/aria2-integration/latest.xpi";
          installation_mode = "force_installed";
        };
        # Privacy Badger - EFF Tracker Blocker
        "jid1-DoFfMgPSuB05pA@jetpack" = {
          install_url = "https://addons.mozilla.org/firefox/downloads/latest/privacy-badger17/latest.xpi";
          installation_mode = "force_installed";
        };
        # ClearURLs - Remove Tracking from URLs
        "{74145f27-f039-47ce-a470-a662b129930a}" = {
          install_url = "https://addons.mozilla.org/firefox/downloads/latest/clearurls/latest.xpi";
          installation_mode = "force_installed";
        };
      };
    };

    profiles = {
      default = {
        id = 0;
        name = "default";
        isDefault = true;
        extensions.force = true;
        settings = {
          "toolkit.legacyUserProfileCustomizations.stylesheets" = true;
          "media.ffmpeg.vaapi.enabled" = true;
          "gfx.webrender.all" = true;
          "gfx.webrender.force-legacy-layers" = true;
          "browser.fullscreen.autohide" = false;
          "browser.sessionstore.max_resumed_crashes" = 0;
        };
      };
    };
  };
}
