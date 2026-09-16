{ config, lib, pkgs, ... }:
{
  imports =
    [ 
      ./hardware-configuration.nix
    ];

nixpkgs.config.allowUnfree = true;

  boot.loader = {
   grub = {
    enable = true;
    device = "nodev";
    efiSupport = true;
    configurationName = "NixOS";
    useOSProber = false;
   };
   efi = {
    canTouchEfiVariables = true;
    efiSysMountPoint = "/boot/efi";
   };
  };

  boot.kernelPackages = pkgs.linuxPackages_latest;
  networking.hostName = "nixos";

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
      syu="sudo nixos-rebuild switch";
      ff="fastfetch";
      java = "steam-run java";
      };
  };
  environment.sessionVariables = {
    PATH = [ "$HOME/.local/bin" ];
  };

  environment.systemPackages = with pkgs; [
    neovim 
    wget
    fastfetch
    alacritty
    foot
    pcmanfm
    xclip
    maim
    slurp
    grim
    wl-clipboard
    firefox
    git
    gcc
    gpp
    papirus-icon-theme
    unzip
    unrar
    tmux
    rofi
    cava
    xwallpaper
    xwayland-satellite
    wlr-randr
    openjdk25
    dnsmasq
    bridge-utils
    netcat-openbsd
    virt-viewer
    cmatrix
    steam-run-free
    appimage-run
    gamemode
    mission-center
    linuxPackages.cpupower
#    noctalia
  ];
  # programs Programs apps Apps ^

  nixpkgs.config.packageOverrides = pkgs: {
    steam = pkgs.steam.override {
      extraPkgs = pkgs: with pkgs; [
        xorg.libXxf86vm 
        libGL
      ];
    };
  };

  virtualisation.libvirtd = {
    enable = true;
    qemu = {
      package = pkgs.qemu_kvm;
      runAsRoot = true;
    };
  };
  programs.virt-manager.enable = true;

  security.polkit.enable = true;
  systemd.user.services.polkit-mate-authentication-agent-1 = {
  description = "polkit-mate-authentication-agent-1";
  wantedBy = [ "graphical-session.target" ];
  wants = [ "graphical-session.target" ];
  after = [ "graphical-session.target" ];
  serviceConfig = {
    Type = "simple";
    ExecStart = "${pkgs.mate-polkit}/libexec/polkit-mate-authentication-agent-1";
    Restart = "on-failure";
    RestartSec = 1;
    TimeoutStopSec = 10;
    };
  };

  fonts.packages = with pkgs; [
    nerd-fonts.iosevka
    nerd-fonts.adwaita-mono
  ];

  hardware.graphics = {
    enable = true;
    enable32Bit = true;
  };
  hardware.nvidia = {
    modesetting.enable = true;
    open = true;
    nvidiaSettings = true;
  };
  services.xserver.videoDrivers = [ "nvidia" ];

  system.stateVersion = "26.05";

#  services.xserver.enable = true;
#  services.xserver.displayManager.lightdm.enable = false;
  programs.xwayland.enable = true;
  services.flatpak.enable = true;
  services.displayManager.sddm.enable = true;
  services.desktopManager.plasma6.enable = true;
  programs.niri.enable = true;
  programs.steam.enable = true;
}
