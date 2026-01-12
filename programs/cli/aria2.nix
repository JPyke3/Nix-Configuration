{
  config,
  pkgs,
  lib,
  ...
}: {
  # aria2 download manager with RPC for Firefox integration
  home.packages = [pkgs.aria2];

  # User-level systemd service (Linux only - won't break Darwin/Nix-On-Droid)
  systemd.user.services.aria2 = lib.mkIf pkgs.stdenv.isLinux {
    Unit = {
      Description = "aria2 Download Manager";
      After = ["network.target"];
    };

    Service = {
      Type = "simple";
      ExecStart = "${pkgs.aria2}/bin/aria2c --enable-rpc --rpc-listen-port=6800 --rpc-allow-origin-all --rpc-listen-all=false --dir=%h/Downloads --split=32 --min-split-size=4M --max-connection-per-server=16 --max-concurrent-downloads=16 --continue=true --file-allocation=falloc --disk-cache=64M --allow-overwrite=true";
      Restart = "on-failure";
      RestartSec = 5;
    };

    Install = {
      WantedBy = ["default.target"];
    };
  };
}
