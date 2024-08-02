{...}: {
  services.transmission = {
    enable = true;
    group = "media-server";
    openFirewall = true;
    openRPCPort = true; #Open firewall for RPC
    settings = {
      #Override default settings
      rpc-bind-address = "0.0.0.0"; #Bind to own IP
      rpc-whitelist = "127.0.0.1,10.0.0.1,100.114.95.59"; #Whitelist your remote machine (10.0.0.1 in this example)
      download-dir = "/mypool/downloads";
    };
  };
}
