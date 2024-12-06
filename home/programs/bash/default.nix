{pkgs, ...}: {
  programs.bash = {
    enable = true;
    # affects on interactive shell only
    initExtra = ''
      if [[ $(${pkgs.procps}/bin/ps --no-header --pid=$PPID --format=comm) != "nu" && -z ''${BASH_EXECUTION_STRING} ]]
      then
        exec nu
      fi
    '';
  };
}
