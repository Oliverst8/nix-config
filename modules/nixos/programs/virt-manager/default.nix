{ ... }:
{
  programs.virt-manager.enable = true;

  users.groups.libvirtd.members = [ "ostarup" ];

  virtualisation.libvirtd.enable = true;

  virtualisation.spiceUSBRedirection.enable = true;
}
