{
  config,
  pkgs,
  inputs,
  lib,
  ...
}:

{

  options = {
    desktop.environment = lib.mkOption {
      type = lib.types.str;
      default = "";
    };
  };

  imports = [

    #Add home-manager
    inputs.home-manager.nixosModules.default

    #Custom modules
    inputs.sddm-sugar-candy-nix.nixosModules.default

    #-------------------------------------------------------

    ./genPackageFile.nix

    ../network
    ../desktop
    ../programs/neovim

    #Custom pkgs
    ../../../pkgs/gottis

    #ITU
    ../ITU/4semester
  ];

  config = {

    # Bootloader.
    boot.loader.grub.enable = true;
    boot.loader.grub.device = "nodev";
    boot.loader.grub.useOSProber = true;
    boot.loader.efi.canTouchEfiVariables = true;
    boot.loader.grub.efiSupport = true;

    networking.hostName = "nixos"; # Define your hostname.
    # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

    # Enable nix flakes
    nix.settings.experimental-features = [
      "nix-command"
      "flakes"
    ];

    #Make touchpad work after sleep
    powerManagement.powerUpCommands = "sudo rmmod atkbd; sudo modprobe atkbd reset=1";

    # Set your time zone.
    time.timeZone = "Europe/Copenhagen";

    # Select internationalisation properties.
    i18n.defaultLocale = "en_DK.UTF-8";

    i18n.extraLocaleSettings = {
      LC_ADDRESS = "da_DK.UTF-8";
      LC_IDENTIFICATION = "da_DK.UTF-8";
      LC_MEASUREMENT = "da_DK.UTF-8";
      LC_MONETARY = "da_DK.UTF-8";
      LC_NAME = "da_DK.UTF-8";
      LC_NUMERIC = "da_DK.UTF-8";
      LC_PAPER = "da_DK.UTF-8";
      LC_TELEPHONE = "da_DK.UTF-8";
      LC_TIME = "da_DK.UTF-8";
    };

    # Configure keymap in X11
    services.xserver.xkb = {
      layout = "dk";
      variant = "";
    };

    # Configure console keymap
    console.keyMap = "dk-latin1";

    # Enable CUPS to print documents.
    services.printing.enable = true;

    # Enable bluetooth
    hardware.bluetooth.enable = true;

    # Enable sound with pipewire.
    services.pulseaudio.enable = false;
    security.rtkit.enable = true;
    services.pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
      jack.enable = true;
    };

    # Enable touchpad support (enabled default in most desktopManager).
    services.libinput.enable = true;

    # Enbale zsh
    programs.zsh.enable = true;

    # Define a user account. Don't forget to set a password with ‘passwd’.
    users.users.ostarup = {
      isNormalUser = true;
      description = "Oliver Starup";
      extraGroups = [
        "networkmanager"
        "wheel"
        "input"
        "docker"
      ];
      shell = pkgs.zsh;
      packages = with pkgs; [ kate ];
    };

    #Set default text editor to neovim
    programs.neovim.enable = true;
    programs.neovim.defaultEditor = true;

    # Install firefox.
    programs.firefox.enable = true;

    #Enable docker
    virtualisation.docker.enable = true;

    # Allow unfree packages
    nixpkgs.config.allowUnfree = true;

    # List packages installed in system profile. To search, run:
    # $ nix search wget
    environment.systemPackages = [
      pkgs.vim # Text editor
      pkgs.git
      pkgs.gh
      pkgs.lazygit
      pkgs.steam-run # Allows the use of mason and lsps with neovim
      pkgs.libsForQt5.okular
      pkgs.pavucontrol
      pkgs.libsForQt5.dolphin # File browser
      pkgs.power-profiles-daemon # Power profiles
      pkgs.mpv # Video player
      pkgs.direnv
      pkgs.nixfmt-rfc-style # Formatter for nix
      pkgs.nil #Nix language server
      pkgs.tree # Tree command
      pkgs.docker
      pkgs.ghostty # Terminal
      pkgs.starship # Terminal theme
      pkgs.tlp # Makes laptop more power efficent
      pkgs.unzip

      pkgs.yazi # Tui file manager
      pkgs.spotify-player # TUI spotfiy https://github.com/aome510/spotify-player

      pkgs.vscode-fhs # Vscode using it own plugins
      pkgs.jetbrains.goland
    ];

    #Install fonts
    fonts.packages = with pkgs; [ nerd-fonts.meslo-lg ];

    # This value determines the NixOS release from which the default
    # settings for stateful data, like file locations and database versions
    # on your system were taken. It‘s perfectly fine and recommended to leave
    # this value at the release version of the first install of this system.
    # Before changing this value read the documentation for this option
    # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
    system.stateVersion = "23.11"; # Did you read the comment?

    programs.nix-ld.enable = true;
  };
}
