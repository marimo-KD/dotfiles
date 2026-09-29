{ pkgs, inputs, secrets, ... }:
{
  home = rec {
    username = "marimo";
    homeDirectory = "/Users/${username}";
    stateVersion = "23.11";
  };
  programs.home-manager.enable = true;
  imports = [
    ./programs/ghostty
    ./programs/bash
    ./programs/bat
    ./programs/carapace
    ./programs/codex
    ./programs/direnv
    ./programs/fd
    ./programs/fzf
    ./programs/git
    ./programs/gpg
    ./programs/helix
    # ./programs/latex
    ./programs/ripgrep
    ./programs/starship
    ./programs/zoxide
    ./programs/zsh
  ];
  home.packages = with pkgs; [
    inputs.neovim.packages.${pkgs.stdenv.system}.default
    tdf
    gnuplot
    lean4
    (prismlauncher.override {
      jdks = [
        graalvmPackages.graalvm-ce
        zulu
      ];
    })
  ];
  home.sessionVariables = {
    FAST_NOTE_SYNC_MCP_TOKEN_RO = secrets.fast_note_sync.bearer_ro;
    FAST_NOTE_SYNC_MCP_TOKEN_RW = secrets.fast_note_sync.bearer_rw;
  };
  sshAuthSock.initialization.bash = "export SSH_AUTH_SOCK=$HOME/Library/Containers/com.bitwarden.desktop/Data/.bitwarden-ssh-agent.sock";
}
