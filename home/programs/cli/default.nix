{pkgs, lib, ...}:
let dptrp1py = pkgs.python3Packages.buildPythonPackage rec {
  pname = "dpt-rp1-py";
  version = "0.1.16";
  format = "setuptools";
  src = pkgs.fetchPypi {
    inherit pname version;
    hash = "sha256-k8qyiVU8lUfmdtVqRmZM5N9kSgmudxkOc6E+hYhIq8M=";
  };
  build-system = with pkgs.python3Packages; [
    setuptools
    wheel
  ];
  dependencies = with pkgs.python3Packages; [
    httpsig
    requests
    pbkdf2
    urllib3
    pyyaml
    anytree
    fusepy
    zeroconf
    tqdm
    setuptools
  ];
  doCheck = false;
};
in lib.mkMerge [{
  programs = {
    yazi.enable = true;
    gpg.enable = true;
    password-store.enable = true;
    zoxide.enable = true;
    bat = {
      enable = true;
      catppuccin.enable = false;
    };
    fzf = {
      enable = true;
      catppuccin.enable = false;
    };
    ripgrep.enable = true;
    fd.enable = true;
  };
  services.gpg-agent = {
    enable = pkgs.stdenv.isLinux;
    pinentryPackage = pkgs.pinentry-tty;
  };
  home.packages = [
    dptrp1py
  ];
}

(lib.mkIf pkgs.stdenv.isDarwin {
    home.file.".gnupg/gpg-agent.conf".text = ''
      pinentry-program ${pkgs.pinentry_mac}/Applications/pinentry-mac.app/Contents/MacOS/pinentry-mac
    '';
    home.packages = [
      pkgs.gnupg
      pkgs.pinentry_mac
    ];
  })
]
