   $env.config = {
     show_banner: false
           keybindings: [
             {
               name: fuzzy_ghq
                modifier: control
                    keycode: char_g
                    mode: emacs
                    event: {
                      send: executehostcommand,
                      cmd: "cd (ghq list --full-path | fzf | decode utf-8 | str trim)"
                    }
                  }
                ]
              }
              def --env ya [...args] {
                let tmp = (mktemp -t "yazi-cwd.XXXXX")
                yazi ...$args --cwd-file $tmp
                let cwd = (open $tmp)
                if $cwd != "" and $cwd != $env.PWD {
                  cd $cwd
                }
                rm -fp $tmp
              }
        $env.STARSHIP_SHELL = "nu"

        def create_left_prompt [] {
            starship prompt --cmd-duration $env.CMD_DURATION_MS $'--status=($env.LAST_EXIT_CODE)'
        }

        # Use nushell functions to define your right and left prompt
        $env.PROMPT_COMMAND = { || create_left_prompt }
        $env.PROMPT_COMMAND_RIGHT = ""

        # The prompt indicators are environmental variables that represent
        # the state of the prompt
        $env.PROMPT_INDICATOR = ""
        $env.PROMPT_INDICATOR_VI_INSERT = ": "
        $env.PROMPT_INDICATOR_VI_NORMAL = "〉"
        $env.PROMPT_MULTILINE_INDICATOR = "::: "

              module vterm {
                # Escape a command for outputting by vterm send
                def escape-for-send [
                  to_escape: string # The data to escape
                ] {
                  $to_escape | str replace --all '\\' '\\' | str replace --all '"' '\"'
                }

                # Send a command to vterm
                export def send [
                  command: string # Command to pass to vterm
                  ...args: string # Arguments to pass to vterm
                ] {
                  print --no-newline "\e]51;E"
                  print --no-newline $"\"(escape-for-send $command)\" "
                  for arg in $args {
                    print --no-newline $"\"(escape-for-send $arg)\" "
                  }
                  print --no-newline "\e\\"
                }

                # Clear the terminal window
                export def clear [] {
                  send vterm-clear-scrollback
                  tput clear
                }

                # Open a file in Emacs
                export def open [
                  filepath: path # File to open
                ] {
                  send "find-file" $filepath
                }
              }

              if $env.INSIDE_EMACS == "vterm" {
                use vterm
              }
      '';
