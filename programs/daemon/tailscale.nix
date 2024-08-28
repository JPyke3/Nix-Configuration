{...}: {
  services.tailscale = {
    enable = true;
    permitCertUid = ["caddy" "jacobpyke"];
  };
}
