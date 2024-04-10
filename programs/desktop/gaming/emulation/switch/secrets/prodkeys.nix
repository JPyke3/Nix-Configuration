{...}: {
  sops.secrets."emulation/switch" = {
    path = "${config.home.homeDirectory}/.local/emulation/keys/prod.keys";
  };
}
