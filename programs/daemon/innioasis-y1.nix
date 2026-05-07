# Innioasis Y1 flashing support (MTKclient / Innioasis Updater).
# Grants non-root access to MediaTek BROM/preloader devices (VID 0x0e8d)
# so firmware_downloader.py can talk to the Y1 over USB without sudo.
{...}: {
  users.groups.plugdev = {};
  users.users.jacobpyke.extraGroups = ["plugdev"];

  services.udev.extraRules = ''
    # MediaTek BROM/preloader — Innioasis Y1 flashing via MTKclient
    SUBSYSTEM=="usb", ATTR{idVendor}=="0e8d", MODE="0660", GROUP="plugdev"
  '';
}
