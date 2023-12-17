{ config, lib, pkgs, modulesPath, ... }:

{
  imports = [ (modulesPath + "/installer/scan/not-detected.nix") ];



  # {{ KERNEL }}
  boot.initrd.availableKernelModules = [ "xhci_pci" "ahci" "usbhid" "usb_storage" "sd_mod" ];
  boot.initrd.kernelModules = [ ];
  boot.kernelModules = [ "kvm-intel" ];
  boot.extraModulePackages = [ ];
  # {{ KERNEL }}



  # {{ BOOT }}
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  # {{ BOOT }}



  # {{ FS }}
  fileSystems = {
    "/" = {
      device = "/dev/disk/by-uuid/bec723ed-3522-48c0-b0ec-42bf5660feb3";
      fsType = "ext4";
    };
    "/boot" = {
      device = "/dev/disk/by-uuid/CC71-7FBC";
      fsType = "vfat";
    };
  };

  swapDevices = [ ];
  # {{ FS }}



  # {{ NETWORK }}
  networking.hostName = "nixos"; # Define your hostname.
  networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;
  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  networking.useDHCP = lib.mkDefault true;
  # networking.interfaces.enp2s0.useDHCP = lib.mkDefault true;
  # networking.interfaces.wlo1.useDHCP = lib.mkDefault true;
  # {{ NETWORK }}



  # {{ SPECIFIC }}
  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  hardware.cpu.intel.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;

  hardware.opengl = {
    enable = true;
    driSupport = true;
    driSupport32Bit = true;
  };
  hardware.nvidia = {
    modesetting.enable = true;
    open = false;
    package = config.boot.kernelPackages.nvidiaPackages.stable;
  };
  # {{ SPECIFIC }}



  # {{ ZONE }}
  time.timeZone = "Europe/Moscow";

  i18n.defaultLocale = "en_US.UTF-8";
  i18n.extraLocaleSettings = {
    LC_ADDRESS = "en_US.UTF-8";
    LC_IDENTIFICATION = "en_US.UTF-8";
    LC_MEASUREMENT = "en_US.UTF-8";
    LC_MONETARY = "en_US.UTF-8";
    LC_NAME = "en_US.UTF-8";
    LC_NUMERIC = "en_US.UTF-8";
    LC_PAPER = "en_US.UTF-8";
    LC_TELEPHONE = "en_US.UTF-8";
    LC_TIME = "en_US.UTF-8";
  };
  # {{ ZONE }}



  # {{ X11 }}
  services.xserver = {
    enable = true;
    videoDrivers = [ "nvidia" ];
    excludePackages = with pkgs; [
      xterm
    ];
    displayManager.startx.enable = true;
  };
  # {{ X11 }}



  # {{ KEYBOARD }}
  services.xserver = {
    layout = "us,ru";
    xkbVariant = "qwerty";
    xkbOptions = "grp:alt_shift_toggle";
  };
  # {{ KEYBOARD }}



  # {{ SOUND }}
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    jack.enable = true;
    alsa.enable = true;
    pulse.enable = true;
    alsa.support32Bit = true;
  };
  # {{ SOUND }}



  # {{ USERS }}
  users.users.fidelicura = {
    isNormalUser = true;
    extraGroups = [ "audio" "video" "docker" ];
    packages = with pkgs; [];
  };
  # {{ USERS }}



  # {{ ROOT }}
  security.doas.enable = true;
  security.sudo.enable = false;
  security.doas.extraRules = [{
    users = [ "fidelicura" ];
    keepEnv = true;
    persist = true;
  }];
  # {{ ROOT }}



  # {{ PACKAGES }}
  nixpkgs.config.allowUnfree = true;
  environment.systemPackages = with pkgs; [
    # web
    git
    curl
    firefox
    # terminal
    alacritty
    helix
    # archive
    zip unzip
    rar unrar
    gnutar xz
    # desktop
    bspwm
    sxhkd
    picom-jonaburg
    dunst
    rofi
    eww
    zathura
    xwallpaper
    # languages
    gcc gnumake ccls
    go
    fasm
    zig zls
    python3
    rustc cargo rust-analyzer clippy
    # messengers
    telegram-desktop
    discordo
    # gaming
    steam-tui
    # theme
    gruvbox-dark-gtk
    gruvbox-dark-icons-gtk
    # utils
    bash
    calc
    stow
    bottom
    bunnyfetch
    transmission-gtk
  ];
  virtualisation.docker.enable = true;
  # {{ PACKAGES }}



  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # {{ SYSTEM }}
  system.stateVersion = "23.11";
  # {{ SYSTEM }}
}
