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

$env.STARSHIP_SHELL = "nu"

def create_left_prompt [] {
  starship prompt --cmd-duration $env.CMD_DURATION_MS $'--status=($env.LAST_EXIT_CODE)' --terminal-width (term size).columns
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

module vprompt {
  # Complete escape sequence based on environment
  def complete-escape-by-env [
    arg: string # argument to send
  ] {
    let tmux: string = (if ($env.TMUX? | is-empty) { '' } else { $env.TMUX })
    let term: string = (if ($env.TERM? | is-empty) { '' } else { $env.TERM })
    if $tmux =~ "screen|tmux" {
      # tell tmux to pass the escape sequences through
      $"\ePtmux;\e\e]($arg)\a\e\\"
    } else if $term =~ "screen.*" {
      # GNU screen (screen, screen-256color, screen-256color-bce)
      $"\eP\e]($arg)\a\e\\"
    } else {
      $"\e]($arg)\e\\"
    }
  }

  # Output text prompt that vterm can use to track current directory
  export def left-prompt-track-cwd [] {
    $"(create_left_prompt)(complete-escape-by-env $'51;A(whoami)@(hostname):(pwd)')"
  }
}

if ('INSIDE_EMACS' in $env and $env.INSIDE_EMACS == 'vterm') {
  use vterm
  use vprompt
  $env.PROMPT_COMMAND = {|| vprompt left-prompt-track-cwd }
}
