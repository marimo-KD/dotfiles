set laststatus=2
set noshowmode

function! GenStatusline()
  return StatuslineMode() . "\ %<%F\ %m%r%h\ %= %{strlen(&fenc)?&fenc:'none'}\ %y\ " . LspStatus() . "\ %c:%l/%L"
endfunction

function! StatuslineMode()
  let mode_name = ""
  let c = "StatuslineOther"
  if mode()==#"n"
    let mode_name = "NORMAL"
    let c = "StatuslineNormal"
  elseif mode()==#"v"
    let mode_name = "VISUAL"
    let c = "StatuslineVisual"
  elseif mode()==#"V"
    let mode_name = "V-LINE"
    let c = "StatuslineVisual"
  elseif mode()=="\<c-v>"
    let mode_name = "V-BLOCK"
    let c = "StatuslineVisual"
  elseif mode()==#"i"
    let c = "StatuslineInsert"
    if skkeleton#is_enabled()
      let mode_name = "INSERT(skk)"
    else
      let mode_name = "INSERT"
    endif
  elseif mode()==#"c"
    let mode_name = "COMMAND"
    let c = "StatuslineCommand"
  elseif mode()==#"R"
    let mode_name = "REPLACE"
    let c = "StatuslineReplace"
  elseif mode()==?"s" || mode()=="\<c-s>"
    let mode_name = "SELECT"
  elseif mode()==#"t"
    let mode_name = "TERMINAL"
  elseif mode()==#"!"
    let mode_name = "SHELL"
  endif
  return '%#' . c . '# ' . mode_name . ' %*'
endfunction

function! LspStatus() abort
  let sl = ''
  if has('nvim') && luaeval('not vim.tbl_isempty(vim.lsp.buf_get_clients(0))')
    let error_count = luaeval('#vim.diagnostic.get(nil, {severity = vim.diagnostic.severity.ERROR})')
    let warn_count = luaeval('#vim.diagnostic.get(nil, {severity = vim.diagnostic.severity.WARN})')
    let sl.='%#StatuslineLSPError# ' . error_count
    let sl.=' '
    let sl.='%#StatuslineLSPWarning# ' . warn_count . '%*'
  else
      let sl.='%#StatuslineLSP#OFF%*'
  endif
  return sl
endfunction


"          Normal
highlight! StatuslineNormal  ctermbg=darkgray   ctermfg=black guibg=darkgray   guifg=black gui=bold
"          Visual
highlight! StatuslineVisual  ctermbg=lightgreen ctermfg=black guibg=lightgreen guifg=black gui=bold
"          Insert
highlight! StatuslineInsert  ctermbg=cyan       ctermfg=black guibg=cyan       guifg=black gui=bold
"          Command
highlight! StatuslineCommand ctermbg=darkgray   ctermfg=black guibg=darkgray   guifg=black gui=bold
"          Replace
highlight! StatuslineReplace ctermbg=red        ctermfg=black guibg=red        guifg=black gui=bold
"          Others
highlight! StatuslineOther   ctermbg=red        ctermfg=black guibg=red        guifg=black gui=bold

hi link StatuslineLSPError Error
hi link StatuslineLSPWarning WarningMsg


set statusline=%!GenStatusline()
