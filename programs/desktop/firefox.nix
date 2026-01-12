{
  config,
  pkgs,
  ...
}: {
  programs.firefox = {
    enable = true;
    package = pkgs.firefox;
    profiles = {
      default = {
        id = 0;
        name = "default";
        isDefault = true;
        extensions.packages = with pkgs.nur.repos.rycee.firefox-addons; [
          bitwarden
          ublock-origin
          darkreader
          aria2-integration
          vimium
          sponsorblock
          buster-captcha-solver
          privacy-redirect
        ];
        extensions.force = true; # Allow Stylix to manage extension settings for Firefox Color
        settings = {
          "toolkit.legacyUserProfileCustomizations.stylesheets" = true;
          "media.ffmpeg.vaapi.enabled" = true;
          "gfx.webrender.all" = true;
          "gfx.webrender.force-legacy-layers" = true;
          "browser.fullscreen.autohide" = false;
          "browser.sessionstore.max_resumed_crashes" = 0;
        };
        # userChrome removed - Stylix handles theming via stylix.targets.firefox
      };
    };
  };
}
