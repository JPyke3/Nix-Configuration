{
  config,
  pkgs,
  ...
}: {
  # Create a simple RPC secret file for aria2
  # This is a local-only service, so a simple token is sufficient
  environment.etc."aria2/rpc-secret".text = "aria2-local-rpc-token";

  services.aria2 = {
    enable = true;
    rpcListenPort = 6800;
    rpcSecretFile = "/etc/aria2/rpc-secret";
    downloadDir = "/home/jacobpyke/Downloads";

    settings = {
      # RPC settings for Firefox extension
      "rpc-allow-origin-all" = true;
      "rpc-listen-all" = false; # Only localhost for security

      # Performance settings (matching CLI alias in zsh.nix)
      "split" = 32;
      "min-split-size" = "4M";
      "max-connection-per-server" = 16;
      "max-concurrent-downloads" = 16;

      # Additional useful settings
      "continue" = true; # Resume downloads
      "file-allocation" = "falloc"; # Fast file allocation
      "disk-cache" = "64M";
    };
  };
}
