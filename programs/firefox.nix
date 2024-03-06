{
  config,
  pkgs,
  inputs,
  ...
}: {
  programs.firefox = {
    enable = true;
    package = pkgs.firefox-bin;
    profiles = {
      default = {
        id = 0;
        name = "default";
        isDefault = true;
        extensions = with pkgs.nur.repos.rycee.firefox-addons; [
          bitwarden
          ublock-origin
          darkreader
          aria2-integration
          vimium
        ];
        settings = {
          "toolkit.legacyUserProfileCustomizations.stylesheets" = true;
          "media.ffmpeg.vaapi.enabled" = true;
          "gfx.webrender.all" = true;
          "gfx.webrender.force-legacy-layers" = true;
          "browser.fullscreen.autohide" = false;
        };
        userChrome = with config.colorScheme.colors; ''
          toolbar#TabsToolbar
          {
          	-moz-appearance: none !important;
          	background-color: #${base00} !important;
          }

          #toolbar-menubar, #menubar-items, #main-menubar {
          	background-color: #${base00} !important;
          	background-image: none !important;
          }

          .tabbrowser-tab .tab-content{
          	color: #${base06} !important;
          }

          .tab-background[selected]{ background: #${base01} !important }


          .tabbrowser-tab:not([selected]):hover {
          	background-color: #${base01} !important;
          }

          .titlebar-buttonbox{ display: none !important; }

          .subviewbutton-iconic > .toolbarbutton-icon{ fill: blue !important; }

          #urlbar-background, #searchbar {
          	--toolbar-field-background-color: #${base01} !important;
          }
          :root{
            --toolbar-field-color: #${base06} !important;
            --toolbar-bgcolor: #${base00} !important;
          }

          /******* button icon colors detailed version ********/
          #containers-panelmenu,
          #web-apps-button,
          #e10s-button,
          #panic-button,
          #cut-button,
          #zoom-out-button,
          #zoom-in-button,
          #stop-button,
          #stop-button .toolbarbutton-animatable-image,
          #stop-reload-button[animate]>#reload-button[displaystop]+#stop-button>.toolbarbutton-animatable-box>.toolbarbutton-animatable-image,
          #save-page-button,
          #back-button,
          #forward-button,
          #new-window-button,
          #tabs-newtab-button,
          #alltabs-button,
          #navigator-toolbox #TabsToolbar:not(:-moz-lwtheme) #alltabs-button,
          #navigator-toolbox #TabsToolbar:not(:-moz-lwtheme) .tabbrowser-arrowscrollbox>.scrollbutton-up,
          #navigator-toolbox #TabsToolbar:not(:-moz-lwtheme) .tabbrowser-arrowscrollbox>.scrollbutton-down,
          #downloads-button,
          #downloads-button[indicator="true"]:not([attention="success"]) #downloads-indicator-icon,
          #copy-button,
          #find-button,
          #sidebar-button,
          #fullscreen-button,
          #PanelUI-customize,
          #password-notification-icon,
          #PanelUI-fxa-status,
          #sync-button,
          #tabview-button,
          #paste-button,
          #email-link-button,
          #reload-button,
          #reload-button .toolbarbutton-animatable-image,
          #add-ons-button,
          #open-file-button,
          #home-button,
          #feed-button,
          #history-button,
          #history-panelmenu,
          #library-button,
          #privatebrowsing-button,
          #print-button,
          #webide-button,
          #PanelUI-menu-button,
          #nav-bar-overflow-button,
          #bookmarks-menu-button,
          #bookmarks-button,
          #bookmarks-menu-button>.toolbarbutton-menubutton-dropmarker>.dropmarker-icon,
          #developer-button,
          #preferences-button,
          #identity-icon-label
          #characterencoding-button {
          	fill: #${base06} !important; /*color you want*/
          	fill-opacity: 1 !important;
          	/*opacity: 1 !important;*/
          }

          #PersonalToolbar .toolbarbutton-text {
          	color: #${base06} !important;
          }

        '';
      };
    };
  };
}
