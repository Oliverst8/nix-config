{ lib, config, ... }:
let
  cfg = config.zsh;
in
{
  options = {
    zsh.enable = lib.mkEnableOption "Enable zsh";
  };
  config = lib.mkIf cfg.enable {
    programs.zsh = {
      enable = true;
      enableCompletion = true;
      autosuggestion.enable = true;
      syntaxHighlighting.enable = true;
      shellAliases = {
        ll = "ls -l";
        update = "nh os switch ~/nixos -H " + config.systemFolder.name + " --ask";
        nxdry = "sudo nixos-rebuild dry-activate --flake ~/nixos/#" + config.systemFolder.name;
        g = "lazygit";
        y = "yazi";
        sp = "spotify_player";
        sus = "python -c 'print(chr(sum(range(ord(min(str(not())))))))'";
        stim = "asciiquarium";
        fslex = "dotnet /home/ostarup/ITU/psd/ProgramsAsDataCodeE2025/fsharp/fslex.dll";
        fsyacc = "dotnet /home/ostarup/ITU/psd/ProgramsAsDataCodeE2025/fsharp/fsyacc.dll";
      };
      #history = {
      #  size = 10000;
      #  path = "${config.xdg.dataHome}/zsh/history";
      #};
      oh-my-zsh = {
        enable = true;
        plugins = [
          "git"
          "sudo"
          "copypath"
          "copyfile"
          "colorize"
          "colored-man-pages"
          "gh"
          "direnv"
        ];
      };

      initContent = ''
        # jetlink <link|launcher-command|session-id> [-o]
        # Resolves a Code With Me invitation into a full join link (with #p=..&fp=..).
        # -o / --open  launches JetBrains Gateway with the result.
        jetlink() {
          emulate -L zsh

          local open=0 input=""
          local -a rest
          while (( $# )); do
            case $1 in
              -o|--open) open=1 ;;
              --) shift; rest+=("$@"); break ;;
              *) rest+=("$1") ;;
            esac
            shift
          done
          input="$rest"

          if [[ -z $input ]]; then
            print -u2 -- "Paste Code With Me link or launcher command:"
            IFS= read -r input || return 1
          fi

          local host="https://code-with-me.global.jetbrains.com"
          local sid
          if [[ $input =~ 'code-with-me\.global\.jetbrains\.com/([A-Za-z0-9_-]+)' ]]; then
            sid=$match[1]
          elif [[ $input =~ '^[A-Za-z0-9_-]+$' ]]; then
            sid=$input
          fi
          if [[ -z $sid ]]; then
            print -u2 -- "jetlink: no session id found in input"
            return 1
          fi

          local url="$host/$sid/cwm-client-launcher-linux.sh?arch_type=$(uname -m)"
          local script
          if (( $+commands[curl] )); then
            script=$(curl -fsSL -- "$url" 2>/dev/null)
          else
            script=$(wget -qO- -- "$url" 2>/dev/null)
          fi

          local link
          if [[ -z $script ]]; then
            print -u2 -- "jetlink: launcher fetch failed (session expired?); using bare link"
            link="$host/$sid"
          elif [[ $script =~ '(https://code-with-me[A-Za-z0-9:/._#?&=%-]*fp=[0-9A-Fa-f]{64}[A-Za-z0-9:/._#?&=%-]*)' ]]; then
            link=$match[1]
          else
            local fp prod=IU
            [[ $script =~ '([0-9A-Fa-f]{64})' ]] && fp=$match[1]
            [[ $script =~ 'p=([A-Z]{2})' ]] && prod=$match[1]
            if [[ -n $fp ]]; then
              link="$host/$sid#p=$prod&fp=$fp&newUi=true"
            else
              print -u2 -- "jetlink: no fingerprint in launcher; Gateway will resolve the bare link"
              link="$host/$sid"
            fi
          fi

          print -r -- "$link"
          if (( $+commands[wl-copy] )); then
            print -rn -- "$link" | wl-copy && print -u2 -- "(copied to clipboard)"
          fi
          if (( open )); then
            if (( $+commands[gateway] )); then
              command gateway "$link" >/dev/null 2>&1 &!
            else
              print -u2 -- "jetlink: gateway not on PATH (add pkgs.jetbrains.gateway)"
              return 1
            fi
          fi
        }
      '';
    };
    programs.atuin = {
      enable = true;
    };
  };
}
