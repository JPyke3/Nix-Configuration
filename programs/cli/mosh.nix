{pkgs, ...}: {
  # Mosh - Mobile Shell
  # Provides both client (mosh) and server (mosh-server) binaries
  # For incoming connections, UDP ports 60000-61000 must be open
  # (Already works over Tailscale since tailscale0 is a trusted interface)
  home.packages = [pkgs.mosh];
}
