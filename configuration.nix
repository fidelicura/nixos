{
  config,
  lib,
  pkgs,
  modulesPath,
  ...
}: {
  # ===> HARDWARE #
  imports = [
    (modulesPath + "/installer/scan/not-detected.nix")
  ];
  hardware.cpu.amd.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
  # ===> HARDWARE #

  # ===> PARTITION #
  fileSystems = {
    "/" = {
      "device" = "/dev/disk/by-label/MAIN";
      "fsType" = "xfs";
    };
    "/boot" = {
      "device" = "/dev/disk/by-label/UEFI";
      "fsType" = "vfat";
    };
  };
  # ===> PARTITION #

  # ===> BOOT #
  boot.initrd.availableKernelModules = [
    "nvme" "xhci_pci" "thunderbolt"
    "usb_storage" "sd_mod" "rtsx_pci_sdmmc"
  ];
  boot.initrd.kernelModules = [ "amdgpu" ];
  boot.kernelModules = [ "kvm-amd" ];
  boot.extraModulePackages = [ ];
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  # ===> BOOT #

  # ===> NETWORK #
  networking.useDHCP = lib.mkDefault true;
  networking.hostName = "asspain";
  networking.networkmanager.enable = true;
  networking.firewall.enable = false;
  # ===> NETWORK #

  # ===> LOCALIZATION #
  time.timeZone = "Europe/Moscow";
  i18n.defaultLocale = "en_US.UTF-8";
  # ===> LOCALIZATION #

  # ===> SECURITY #
  security.rtkit.enable = true;
  # ===> SECURITY #
  
  # ===> SOUND #
  hardware.pulseaudio.enable = false;
  sound.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    pulse.enable = true;
    alsa.support32Bit = true;
  };
  # ===> SOUND #

  # ===> USER #
  users.users.fidelicura = {
    isNormalUser = true;
    extraGroups = [ "wheel" "docker" ];
  };
  # ===> USER #

  # ===> DESKTOP #
  services.xserver = {
    enable = true;
    displayManager.gdm.enable = true;
    desktopManager.gnome.enable = true;
    xkb = {
      layout = "us,ru";
    };
  };
  environment.gnome.excludePackages =
  (with pkgs; [
    gnome-tour
    gnome-connections
  ]) ++ (with pkgs.gnome; [
    epiphany
    geary
    evince
  ]);
  # ===> DESKTOP #

  # ===> VIRTUALIZATION #
  virtualisation.libvirtd.enable = true;
  programs.virt-manager.enable = true;
  virtualisation.docker.rootless = {
    enable = true;
    setSocketVariable = true;
  };
  # ===> VIRTUALIZATION #

  # ===> PACKAGE #
  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  nixpkgs.config.allowUnfree = true;
  environment.systemPackages = with pkgs; [
    # {{ USUAL }}
    stow
    helix
    firefox-esr
    telegram-desktop
    wireproxy
    coreutils diffutils findutils binutils fzf
    zip unzip rar unrar gnutar xz atool
    # {{ DEVELOPMENT }}
    git
    gcc clang rustup python3 go
    gnumake cmake just mage
    gnupatch libtool
    lldb gdb
    lld mold
    pkgconf autoconf automake
    clang-tools
  ];
  # ===> PACKAGE #

  # ===> SYSTEM #
  system.copySystemConfiguration = true;
  system.stateVersion = "23.11";
  # ===> SYSTEM #
}
