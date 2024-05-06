{pkgs, ...}: let
  nur = import inputs.nur {
    nurpkgs = pkgs;
    pkgs = pkgs;
  };
in {
  environment.systemPackages = with pkgs; [
    nur.repos.jpyke3.kanata-bin
  ];

  environment.etc."keyboard.kbd" = {
    enable = true;
    source = builtins.readFile ./keyboard.kbd;
  };

  environment.launchDaemons."com.jpyke3.kanata" = {
    enable = true;
    text = ''
      <?xml version="1.0" encoding="UTF-8"?>
      <!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
      <plist version="1.0">
      <dict>
          <key>Label</key>
          <string>com.example.mylaunchdaemon</string>
          <key>ProgramArguments</key>
          <array>
              <string>${nur.repos.jpyke3.kanata-bin}/bin/kanata</string>
              <string>--cfg</string>
              <string>/etc/keyboard.kbd</string>
          </array>
          <key>RunAtLoad</key>
          <true/>
      </dict>
      </plist>
    '';
  };
}
