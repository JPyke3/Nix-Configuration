{
  pkgs,
  inputs,
  system,
  ...
}: {
  imports = [
    ./mac-defaults.nix
    ../../programs/cli/homebrew.nix
    ../../programs/daemon/yabai.nix
    ../../programs/daemon/kanata/kanata.nix
    ../../programs/daemon/jellyfin-mpv-shim.nix
    ../../programs/daemon/tabby/tabby.nix
    ../../programs/daemon/tdarr-node-macos.nix

    # TODO: Add
    # ../../programs/daemon/download-cleaner.nix
  ];

  nixpkgs.hostPlatform = "aarch64-darwin";

  nixpkgs.overlays = [
    inputs.nixpkgs-firefox-darwin.overlay
  ];

  environment.systemPackages = with pkgs; [
    coreutils
    parallel
    alejandra
    pipx
    ffmpeg
    rclone
  ];

  # Create necessary directories
  system.activationScripts.createMountDirs = {
    enable = true;
    text = ''
      mkdir -p /Users/jacobpyke/.tdarr/media
      mkdir -p /Users/jacobpyke/.tdarr/temp
      chown jacobpyke:staff /Users/jacobpyke/.tdarr/media
      chown jacobpyke:staff /Users/jacobpyke/.tdarr/temp
      chmod 755 /Users/jacobpyke/.tdarr/media
      chmod 755 /Users/jacobpyke/.tdarr/temp
    '';
  };

  # Launchd agent for rclone mount
  launchd.user.agents.rclone-mount-media = {
    command = ''
      ${pkgs.rclone}/bin/rclone mount jacob-china:/mypool/media /Users/jacobpyke/.tdarr/media \
        --vfs-cache-mode full \
        --vfs-cache-max-size 100G \
        --vfs-read-chunk-size 128M \
        --vfs-read-chunk-size-limit 1G \
        --buffer-size 512M \
        --transfers 4 \
        --checkers 8 \
        --dir-cache-time 72h \
        --timeout 10s \
        --contimeout 10s \
        --low-level-retries 10 \
        --stats 0 \
        --uid 1000 \
        --gid 1000 \
        --umask 002 \
        --allow-other
    '';
    serviceConfig = {
      UserName = "jacobpyke";
      StandardOutPath = "/Users/jacobpyke/.logs/rclone-mount-media.out";
      StandardErrorPath = "/Users/jacobpyke/.logs/rclone-mount-media.err";
      RunAtLoad = true;
      KeepAlive = true;
    };
  };

  launchd.user.agents.rclone-mount-temp = {
    command = ''
      ${pkgs.rclone}/bin/rclone mount jacob-china:/mypool/temp /Users/jacobpyke/.tdarr/temp \
        --vfs-cache-mode full \
        --vfs-cache-max-size 50G \
        --vfs-read-chunk-size 64M \
        --vfs-read-chunk-size-limit 512M \
        --buffer-size 256M \
        --transfers 4 \
        --checkers 8 \
        --dir-cache-time 24h \
        --timeout 10s \
        --contimeout 10s \
        --low-level-retries 10 \
        --stats 0 \
        --uid 1000 \
        --gid 1000 \
        --umask 002 \
        --allow-other
    '';
    serviceConfig = {
      UserName = "jacobpyke";
      StandardOutPath = "/Users/jacobpyke/.logs/rclone-mount-temp.out";
      StandardErrorPath = "/Users/jacobpyke/.logs/rclone-mount-temp.err";
      RunAtLoad = true;
      KeepAlive = true;
    };
  };

  users.users.jacobpyke = {
    name = "jacobpyke";
    home = "/Users/jacobpyke";
  };

  services.nix-daemon.enable = true;
  nix.package = pkgs.nix;

  # Create /etc/zshrc that loads the nix-darwin environment.
  programs.zsh.enable = true; # default shell on catalina

  # Used for backwards compatibility, please read the changelog before changing.
  # $ darwin-rebuild changelog
  system.stateVersion = 4;
}
