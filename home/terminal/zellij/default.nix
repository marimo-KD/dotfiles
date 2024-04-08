{pkgs, ...}: {
  programs.zellij.enable = true;
  home.file.".config/zellij/config.kdl".text = ''
  default_shell "nu"
  default_mode "normal"
  default_layout "editor"
  theme "catppuccin-macchiato"
  keybinds clear-defaults=true {
    normal {
      bind "Alt n" { GoToNextTab; }
      bind "Alt p" { GoToPreviousTab; }

      bind "Alt h" { MoveFocus "Left"; }
      bind "Alt j" { MoveFocus "Down"; }
      bind "Alt k" { MoveFocus "Up"; }
      bind "Alt l" { MoveFocus "Right"; }

      bind "Alt v" { NewPane "Right"; }
      bind "Alt s" { NewPane "Down"; }

      bind "Alt x" { CloseFocus; }
      bind "Alt =" "Alt +" { Resize "Increase"; }
      bind "Alt -" { Resize "Decrease"; }
      bind "Alt R" { SwitchToMode "Pane"; }
      bind "Alt S" { SwitchToMode "Scroll"; }
      bind "Alt T" { SwitchToMode "Tab"; }
      bind "Alt d" { Detach; }
    }
    Pane {
      // Pane, Resize, Move
      bind "Alt n" { SwitchToMode "Normal"; }
      bind "h" { Resize "Increase Left"; }
      bind "j" { Resize "Increase Down"; }
      bind "k" { Resize "Increase Up"; }
      bind "l" { Resize "Increase Right"; }
      bind "H" { MovePane "Left"; }
      bind "J" { MovePane "Down"; }
      bind "K" { MovePane "Up"; }
      bind "L" { MovePane "Right"; }
      bind "=" "+" { Resize "Increase"; }
      bind "-" { Resize "Decrease"; }
      bind "f" { ToggleFocusFullscreen; }
      bind "Space" { ToggleFloatingPanes; }
    }
    scroll {
      bind "Alt n" { SwitchToMode "Normal"; }
      bind "j" { ScrollDown; }
      bind "k" { ScrollUp; }
      bind "d" { HalfPageScrollDown; }
      bind "u" { HalfPageScrollUp; }
      bind "G" { ScrollToBottom; }
      bind "/" { SwitchToMode "EnterSearch"; SearchInput 0; }
    }
    entersearch {
      bind "Esc" { SwitchToMode "Scroll"; }
      bind "Enter" { SwitchToMode "Search"; }
    }
    search {
      bind "Alt n" { SwitchToMode "Normal"; }
      bind "G" { ScrollToBottom; }
      bind "j" "Down" { ScrollDown; }
      bind "k" "Up" { ScrollUp; }
      bind "d" { HalfPageScrollDown; }
      bind "u" { HalfPageScrollUp; }
      bind "n" { Search "down"; }
      bind "N" { Search "up"; }
      bind "c" { SearchToggleOption "CaseSensitivity"; }
      bind "w" { SearchToggleOption "Wrap"; }
      bind "o" { SearchToggleOption "WholeWord"; }
    }
    tab {
      bind "Alt n" { SwitchToMode "Normal"; }
      bind "n" { NewTab; SwitchToMode "Normal"; }
      bind "x" { CloseTab; SwitchToMode "Normal"; }
      bind "s" { ToggleActiveSyncTab; SwitchToMode "Normal"; }
      bind "1" { GoToTab 1; SwitchToMode "Normal"; }
      bind "2" { GoToTab 2; SwitchToMode "Normal"; }
      bind "3" { GoToTab 3; SwitchToMode "Normal"; }
      bind "4" { GoToTab 4; SwitchToMode "Normal"; }
      bind "5" { GoToTab 5; SwitchToMode "Normal"; }
      bind "6" { GoToTab 6; SwitchToMode "Normal"; }
      bind "7" { GoToTab 7; SwitchToMode "Normal"; }
      bind "8" { GoToTab 8; SwitchToMode "Normal"; }
      bind "9" { GoToTab 9; SwitchToMode "Normal"; }
    }
  }
  '';
  home.file.".config/zellij/layouts/editor.kdl".text = ''
  layout {
    default_tab_template {
      children
      pane size=1 borderless=true {
        plugin location="file:${pkgs.zjstatus}/bin/zjstatus.wasm" {
          format_left  "{mode} #[fg=#8aadf4,bg=#1e2030]#[fg=#1e2030,bg=#8aadf4]{session}#[fg=#8aadf4,bg=#1e2030] {tabs}"
          format_right "#[fg=#8aadf4,bg=#1e2030]{datetime}"
          format_space "#[bg=#1e2030]"

          hide_frame_for_single_pane "false"

          mode_normal "#[fg=#8aadf4,bg=#1e2030]#[fg=#1e2030,bg=#8aadf4,bold]{name}#[fg=#8aadf4,bg=#1e2030]"

          tab_normal "#[fg=#6e738d,bg=#1e2030]#[fg=#1e2030,bg=#6e738d] {index}:{name} #[fg=#6e738d,bg=#1e2030] "
          tab_active "#[fg=#cad3f5,bg=#1e2030]#[fg=#1e2030,bg=#cad3f5,bold,italic] {index}:{name} #[fg=#cad3f5,bg=#1e2030] "

          datetime          "#[fg=#1e2030,bg=#8aadf4] {format} "
          datetime_format   "%Y %b %d (%A) %H:%M"
          datetime_timezone "Asia/Tokyo"
        }
      }
    }
    tab name="editor" focus=true {
      pane borderless=true
    }
    tab name="terminal" {
      pane
      pane size="20%"
    }
  }
  '';
}
