{ config, lib, pkgs, ... }:

{
  imports =
    [ 
      ./hardware-configuration.nix
    ];

  boot.loader.grub = {
    enable = true;
    device = "nodev";
    efiSupport = true;
  };
  boot.loader.efi = {
    canTouchEfiVariables = true;
    efiSysMountPoint = "/boot/efi";
  };

  # Load the AMD graphics driver early in the boot sequence to prevent Xorg crashes
  boot.initrd.kernelModules = [ "amdgpu" ];
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
    extraGroups = [ "networkmanager" "wheel" "libvirtd" ];
    shell = pkgs.zsh;
    packages = with pkgs; [
      tree
    ];
  };

  programs.zsh = {
    enable = true;
    ohMyZsh = {
      enable = true;
      theme = "agnoster";
      plugins = [ "git" "sudo" "docker" "kubectl" ];
    };
    shellAliases = {
      ff = "fastfetch";
      syu = "sudo nixos-rebuild switch --upgrade";
      sf = "synfetch";
    };
  };

  environment.sessionVariables = {
    PATH = [ "$HOME/.local/bin" ];
    # Forces Electron and Chromium apps to run natively on Wayland when you use it
    NIXOS_OZONE_WL = "1";
  };

  # Some custom builds
#  nixpkgs.overlays = [
#    (final: prev: {
#      dwm = prev.dwm.overrideAttrs (oldAttrs: {
#        src = builtins.path { path = "/home/beamy/dwm/dwm"; };
#      });
#      st = prev.st.overrideAttrs (oldAttrs: {
#        src = builtins.path { path = "/home/beamy/dwm/st"; };
#      });
#    })
#  ];

  environment.systemPackages = with pkgs; [
    neovim 
    wget
    fastfetch
    pfetch
    screenfetch
    alacritty
    foot
    pcmanfm
    picom
    xset
    xclip
    maim
    slurp
    grim
    wl-clipboard
    firefox
    librewolf
    git
    gcc
    gpp
    gnome-tweaks
    gnome-extension-manager
    ptyxis
    papirus-icon-theme
    spotify
    unzip
    unrar
    tmux
    rofi
#    dwm
#    st
    noctalia-shell
    cava
    xwallpaper
#    (pkgs.callPackage /home/beamy/beamwm/beamwm.nix {})
    xwayland-satellite
    wlr-randr
    openjdk21
#    dnsmasq
#    bridge-utils
#    netcat-openbsd
#    virt-viewer
    cmatrix
  ];
  # programs Programs apps Apps ^

  # Virtualisation
#  virtualisation.libvirtd = {
#    enable = true;
#    qemu = {
#      package = pkgs.qemu_kvm;
#      runAsRoot = true;
#    };
#  };
#  programs.virt-manager.enable = true;

  # Polkit agent (mates)
#  security.polkit.enable = true;
#  systemd.user.services.polkit-mate-authentication-agent-1 = {
#  description = "polkit-mate-authentication-agent-1";
#  wantedBy = [ "graphical-session.target" ];
#  wants = [ "graphical-session.target" ];
#  after = [ "graphical-session.target" ];
#  serviceConfig = {
#    Type = "simple";
#    ExecStart = "${pkgs.mate-polkit}/libexec/polkit-mate-authentication-agent-1";
#    Restart = "on-failure";
#    RestartSec = 1;
#    TimeoutStopSec = 10;
#  };
#  };

  # Fonts
  fonts.packages = with pkgs; [
    nerd-fonts.iosevka
    nerd-fonts.adwaita-mono
  ];

  # Drivers & GPU Configuration
  nixpkgs.config.allowUnfree = true;

  hardware.graphics = {
    enable = true;
    enable32Bit = true;
  };

  hardware.nvidia = {
    modesetting.enable = true;
    open = true; 
    nvidiaSettings = true;
#    prime = {
#      offload = {
#        enable = true;
#        enableOffloadCmd = true;
#      };
#      amdBusId = "PCI:4:0:0";
#      nvidiaBusId = "PCI:1:0:0";
#    };
  };
  services.xserver.videoDrivers = [ "amdgpu" "nvidia" ];

  # Conflicts
  programs.ssh.askPassword = pkgs.lib.mkForce "${pkgs.kdePackages.ksshaskpass}/bin/ksshaskpass";

  # NixOS state version
  system.stateVersion = "26.05";

  # Services and DE's / WM's
  services.flatpak.enable = true;
#  services.avahi = {
#  enable = true;
#  nssmdns4 = true;
#  openFirewall = true;
#  };
  programs.xwayland.enable = true;
  services.printing.enable = true;
  services.xserver.enable = true;
  services.xserver.displayManager.lightdm.enable = false;
  services.displayManager.sddm.enable = true;
  services.desktopManager.plasma6.enable = true;
  services.desktopManager.gnome.enable = true;
  services.xserver.displayManager.startx.enable = true;
  services.xserver.desktopManager.xfce.enable = true;
#  services.xserver.windowManager.dwm.enable = true;
  programs.hyprland.enable = true;
  programs.niri.enable = true;
#  services.displayManager.sessionPackages = [ (pkgs.callPackage /home/beamy/beamwm/beamwm.nix {}) ];
}
