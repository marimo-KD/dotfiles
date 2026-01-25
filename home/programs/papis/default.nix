{
  pkgs,
  config,
  lib,
  inputs,
  ...
}:
let
  python = pkgs.python3.override {
    self = python;
    packageOverrides = pyfinal: pyenv: {
      papis = inputs.papis.packages.${pkgs.system}.default;
      papis-zotero = inputs.papis-zotero.packages.${pkgs.system}.default;
    };
  };
  papis = (python.withPackages (ps: [ ps.papis-zotero ]));
in
lib.mkMerge [
  {
    home.packages = [ papis ];
  }

  (lib.mkIf pkgs.stdenv.isDarwin {
    home.file."Library/Application Support/papis/config".text = ''
      [papers]
      add-file-name="{doc[author]:.2}{doc[title]:.15}"
      add-folder-name = "{doc[author]:.2}-{doc[title]:.15}"
      dir=~/Documents/papers

      [settings]
      default-library=papers
      editor=hx
    '';

    launchd.agents.papis-zotero = {
      enable = true;
      config = {
        Label = "com.papis.papis-zotero";
        ProgramArguments = [
          "${papis}/bin/papis"
          "zotero"
          "serve"
        ];
        ProcessType = "Background";
        EnvironmentVariables = {
          PATH = "${config.home.homeDirectory}/.nix-profile/bin:/nix/var/nix/profiles/default/bin:/usr/bin:/bin:/usr/sbin:/sbin";
        };
        RunAtLoad = true;
        KeepAlive = true;
      };
    };
  })
]
