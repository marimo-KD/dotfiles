{pkgs, inputs,...}:
let papis = (pkgs.python3.withPackages (
  ps: [
    inputs.papis.packages.${pkgs.system}.default
    inputs.papis-zotero.packages.${pkgs.system}.default
  ]
)); in {
  programs.papis = {
    enable = true;
    package = papis;
    libraries = {
      papers = {
        isDefault = true;
        settings = {
          dir = "~/Documents/papers";
          database-backend = "whoosh";
          add-file-name = "{doc[author]}{doc[title]}";
        };
      };
    };
    settings = {
      editor = "hx";
    };
  };
}
