# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, inputs, lib, ... }:

{

  #  options = {
  #  desktop.environemnt = lib.mkOption {
  #      type = lib.types.str;
  #      default = "";
  #    };
  #  };
  options = {
    desktop.environment = lib.mkOption {
      type = lib.types.str;
      default = "";
    };
  };

  config.desktop.environment = "hyprland"; #Pick between kde or hyprland

  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
      inputs.home-manager.nixosModules.default

      #Nixos modules
      ../../modules/nixos/editors/vscode.nix

      #Bundles
      ../../modules/bundles/editors/terminal-editors/neovim.nix
      ../../modules/bundles/internet.nix
      ../../modules/bundles/terminal/terminal.nix
      ../../modules/nixos/editors/intellij.nix
      ../../modules/bundles/desktop-environment/desktop-environment.nix
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
    nix.settings.experimental-features = [ "nix-command" "flakes" ];

    # Configure network proxy if necessary
    # networking.proxy.default = "http://user:password@proxy:port/";
    # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

    # Enable networking
    #networking.networkmanager.enable = true;

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
    hardware.pulseaudio.enable = false;
    security.rtkit.enable = true;
    services.pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
      # If you want to use JACK applications, uncomment this
      #jack.enable = true;

      # use the example session manager (no others are packaged yet so this is enabled by default,
      # no need to redefine it in your config for now)
      #media-session.enable = true;
    };

    # Enable touchpad support (enabled default in most desktopManager).
    services.libinput.enable = true;

    # Define a user account. Don't forget to set a password with ‘passwd’.
    users.users.ostarup = {
      isNormalUser = true;
      description = "Oliver Starup";
      extraGroups = [ "networkmanager" "wheel" "input" ];
      packages = with pkgs; [
        kate
      #  thunderbird
      ];
    };


    home-manager = {
    # also pass inputs to home-manager modules
      extraSpecialArgs = {inherit inputs;};
      users = {
        "ostarup" = import ./home.nix;
      };
    };

    # Install firefox.
    programs.firefox.enable = true;

    # Allow unfree packages
    nixpkgs.config.allowUnfree = true;

    # List packages installed in system profile. To search, run:
    # $ nix search wget
    environment.systemPackages = with pkgs; [
    vim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
    git
    gh
    lazygit
    

    #Allows the use of mason and lsps with neovim
      steam-run

    #  wget
    ];

    # Some programs need SUID wrappers, can be configured further or are
    # started in user sessions.
    # programs.mtr.enable = true;
    # programs.gnupg.agent = {
    #   enable = true;
    #   enableSSHSupport = true;
    # };

    # List services that you want to enable:

    # Enable the OpenSSH daemon.
    # services.openssh.enable = true;

    # Open ports in the firewall.
    # networking.firewall.allowedTCPPorts = [ ... ];
    # networking.firewall.allowedUDPPorts = [ ... ];
    # Or disable the firewall altogether.
    # networking.firewall.enable = false;

    # This value determines the NixOS release from which the default
    # settings for stateful data, like file locations and database versions
    # on your system were taken. It‘s perfectly fine and recommended to leave
    # this value at the release version of the first install of this system.
    # Before changing this value read the documentation for this option
    # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
    system.stateVersion = "23.11"; # Did you read the comment?
  };
}
