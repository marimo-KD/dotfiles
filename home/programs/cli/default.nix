{pkgs, ...}: 
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
}; in {
  programs = {
    yazi.enable = true;
    gpg.enable = true;
    password-store.enable = true;
  };
  services.gpg-agent = {
    enable = (if pkgs.stdenv.isDarwin then false else true);
    pinentryPackage = pkgs.pinentry-tty;
  };
  home.packages = with pkgs; [
    bat
    fd
    fzf
    ripgrep
    gnuplot
  ] ++ [
    dptrp1py
  ];
}
