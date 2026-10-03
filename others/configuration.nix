{ config, lib, pkgs, ... }:
{
  imports = [ ./hardware-configuration.nix ];
  boot.loader.grub.enable = true;
  boot.loader.grub.device = "nodev";
  boot.loader.grub.efiSupport = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.efi.efiSysMountPoint = "/boot/efi";
  boot.kernelPackages = pkgs.linuxPackages_latest;
  nixpkgs.config.allowUnfree = true;
  networking.hostName = "nixos";
  system.stateVersion = "26.05";
  networking.networkmanager.enable = true;
  security.sudo.wheelNeedsPassword = false;
  time.timeZone = "Europe/Bucharest";
  hardware.graphics.enable = true;
  services.xserver.videoDrivers = [ "nvidia" ];
  hardware.graphics.enable32Bit = true;
  hardware.nvidia = {
    modesetting.enable = true;
    open = true;
    nvidiaSettings = false;
  };
  services.pipewire = {
    enable = true;
    pulse.enable = true;
  };
  programs.fish.enable = true;
  users.users.beamy = {
    isNormalUser = true;
    extraGroups = [ "wheel" ];
    shell = pkgs.fish;
  };
  environment.systemPackages = with pkgs; [ neovim wget git gcc gpp fastfetch firefox ptyxis gnome-tweaks unzip gnome-extension-manager unrar ];
  # apps Apps
  fonts.packages = with pkgs; [ nerd-fonts.iosevka nerd-fonts.adwaita-mono ];
  
  services.displayManager.gdm.enable = true;
  services.flatpak.enable = true;
  services.desktopManager.gnome.enable = true;
  environment.gnome.excludePackages = with pkgs; [ gnome-weather gnome-console gnome-maps gnome-calendar gnome-font-viewer epiphany baobab gnome-music gnome-tour gnome-characters yelp gnome-contacts gnome-connections gnome-disk-utility gnome-user-docs simple-scan showtime ];
}
