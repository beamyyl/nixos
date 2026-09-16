{ config, lib, pkgs, ... }:
{
  imports = [ ./hardware-configuration.nix ];
  boot.loader.grub.enable = true;
  boot.loader.grub.device = "nodev";
  boot.loader.grub.efiSupport = true;
  boot.loader.grub.useOSProber = false;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.efi.efiSysMountPoint = "/boot/efi";
  system.stateVersion = "26.05";
  boot.kernelPackages = pkgs.linuxPackages_latest;
  networking.hostName = "nixos";
  nixpkgs.config.allowUnfree = true;
  networking.networkmanager.enable = true;
  time.timeZone = "Europe/Bucharest";
  security.sudo.wheelNeedsPassword = false;
  services.pipewire = {
    enable = true;
    pulse.enable = true;
  };
  users.users.beamy = {
    isNormalUser = true;
    extraGroups = [ "networkmanager" "input" "wheel" "libvirtd" ];
    shell = pkgs.fish;
  };
  programs.fish = {
    enable = true;
    shellAliases = {
      syu="sh -c 'sudo nixos-rebuild switch'";
      ff="fastfetch";
      java = "steam-run java";
      };
  };
  environment.sessionVariables = { PATH = [ "$HOME/.local/bin" ]; };
  environment.systemPackages = with pkgs; [ neovim wget fastfetch alacritty foot pcmanfm xclip maim slurp grim wl-clipboard firefox git gcc gpp papirus-icon-theme unzip unrar tmux rofi cava xwallpaper xwayland-satellite wlr-randr openjdk25 dnsmasq bridge-utils netcat-openbsd virt-viewer cmatrix steam-run-free appimage-run gamemode mission-center linuxPackages.cpupower noctalia ];
  # programs Programs apps Apps ^

  virtualisation.libvirtd = {
    enable = true;
    qemu = {
      package = pkgs.qemu_kvm;
      runAsRoot = true;
    };
  };
  programs.virt-manager.enable = true;

  fonts.packages = with pkgs; [ nerd-fonts.iosevka nerd-fonts.adwaita-mono ];
  hardware.graphics = {
    enable = true;
    enable32Bit = true;
  };
  hardware.nvidia = {
    modesetting.enable = true;
    open = true;
    nvidiaSettings = true;
  };

  services.xserver.enable = true;
  programs.xwayland.enable = true;
  services.flatpak.enable = true;
  services.displayManager.gdm.enable = true;
  services.desktopManager.gnome.enable = true;
  programs.niri.enable = true;
  programs.hyprland.enable = true;
  programs.steam.enable = true;
}
