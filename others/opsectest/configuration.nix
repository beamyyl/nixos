{ config, lib, pkgs, ... }:
let
  sources = import ./npins;
  snapdFlake = import sources.flake-compat {
    src = sources.nix-snapd;
  };
in
{
  imports = [ ./hardware-configuration.nix snapdFlake.outputs.nixosModules.default ];
  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.efi.efiSysMountPoint = "/boot/efi";
  boot.loader.grub.enable = true;
  boot.loader.grub.efiSupport = true;
  boot.loader.grub.device = "nodev";
  system.stateVersion = "26.05";
  boot.kernelPackages = pkgs.linuxPackages_latest;
  networking.hostName = "nixos"; 
  networking.networkmanager.enable = true;
  nixpkgs.config.allowUnfree = true;
  security.sudo.wheelNeedsPassword = false;
#  hardware.graphics = {
#    enable = true;
#    enable32Bit = true;
#  };
#  hardware.nvidia = {
#    modesetting.enable = true;
#    open = true;
#    nvidiaSettings = true;
#  };
  time.timeZone = "Europe/Bucharest";
  programs.fish.enable = true;
  services.pipewire = {
    enable = true;
    pulse.enable = true;
  };
  users.users.beamy = {
    isNormalUser = true;
    extraGroups = [ "wheel" "audio" "video" "input" ];
    shell = pkgs.fish;
  };
  systemd.services.fix-snapd-crash = {
  description = "opsec opsec";
  after = [ "snapd.service" ];
  wantedBy = [ "multi-user.target" ];
  serviceConfig = {
    Type = "oneshot";
    RemainAfterExit = true;
    ExecStart = pkgs.writeShellScript "clean-snapd" ''
      ${pkgs.coreutils}/bin/sleep 5
      if [ -f /var/lib/snapd/nix-systemd-system/snap.mesa-2404.component-monitor.service ]; then
        ${pkgs.coreutils}/bin/rm -f /var/lib/snapd/nix-systemd-system/snap.mesa-2404.component-monitor.service
        ${pkgs.systemd}/bin/systemctl reset-failed snapd
        ${pkgs.systemd}/bin/systemctl restart snapd
      fi
    '';
   };
  };

  environment.systemPackages = with pkgs;
  [ neovim curl fastfetch firefox ptyxis rofi kitty gnome-tweaks git gparted discord gcc gpp pcmanfm cava slurp grim wl-clipboard mission-center npins ];
  # apps Apps
  fonts.packages = with pkgs; [ nerd-fonts.iosevka nerd-fonts.adwaita-mono ];

  environment.gnome.excludePackages = with pkgs;
  [ gnome-weather gnome-console gnome-calendar gnome-font-viewer gnome-maps epiphany baobab gnome-maps gnome-music gnome-tour gnome-characters yelp gnome-contacts gnome-connections gnome-disk-utility gnome-user-docs ];
  services.desktopManager.gnome.enable = true;
  programs.niri.enable = true;
  services.displayManager.gdm.enable = true;
  services.snap.enable = true;
}
