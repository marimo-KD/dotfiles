{
  trivialBuild,
  fetchFromGitHub,
}:trivialBuild rec {
  pname = "setup.el";
  version = "2022-04-14";
  src = fetchFromGitHub {
    owner = "zk-phi";
    repo = "setup";
    rev = "d5311e2ec32107f334e5030e3425f946633b5844";
    hash = "sha256-X2SojvDedC/lt0nNJD1P6de/nEgvcVU6WVZmQrTxq3I=";
  };
}
