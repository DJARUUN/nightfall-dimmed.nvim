function! nightfall_dimmed#get_configuration() "{{{
  return {
        \ 'background': get(g:, 'nightfall_dimmed_background', 'medium'),
        \ 'transparent_background': get(g:, 'nightfall_dimmed_transparent_background', 0),
        \ 'dim_inactive_windows': get(g:, 'nightfall_dimmed_dim_inactive_windows', 0),
        \ 'disable_italic_comment': get(g:, 'nightfall_dimmed_disable_italic_comment', 0),
        \ 'enable_italic': get(g:, 'nightfall_dimmed_enable_italic', 0),
        \ 'cursor': get(g:, 'nightfall_dimmed_cursor', 'auto'),
        \ 'sign_column_background': get(g:, 'nightfall_dimmed_sign_column_background', 'none'),
        \ 'spell_foreground': get(g:, 'nightfall_dimmed_spell_foreground', 'none'),
        \ 'ui_contrast': get(g:, 'nightfall_dimmed_ui_contrast', 'low'),
        \ 'show_eob': get(g:, 'nightfall_dimmed_show_eob', 1),
        \ 'float_style': get(g:, 'nightfall_dimmed_float_style', 'bright'),
        \ 'current_word': get(g:, 'nightfall_dimmed_current_word', get(g:, 'nightfall_dimmed_transparent_background', 0) == 0 ? 'grey background' : 'bold'),
        \ 'inlay_hints_background': get(g:, 'nightfall_dimmed_inlay_hints_background', 'none'),
        \ 'lightline_disable_bold': get(g:, 'nightfall_dimmed_lightline_disable_bold', 0),
        \ 'diagnostic_text_highlight': get(g:, 'nightfall_dimmed_diagnostic_text_highlight', 0),
        \ 'diagnostic_line_highlight': get(g:, 'nightfall_dimmed_diagnostic_line_highlight', 0),
        \ 'diagnostic_virtual_text': get(g:, 'nightfall_dimmed_diagnostic_virtual_text', 'grey'),
        \ 'disable_terminal_colors': get(g:, 'nightfall_dimmed_disable_terminal_colors', 0),
        \ 'better_performance': get(g:, 'nightfall_dimmed_better_performance', 0),
        \ 'colors_override': get(g:, 'nightfall_dimmed_colors_override', {}),
        \ }
endfunction "}}}
function! nightfall_dimmed#get_palette(background, colors_override) "{{{
  let palette1 = {
    \ 'bg_dim':     ['#1b1e2b',   '233'],
    \ 'bg0':        ['#1c1e26',   '235'],
    \ 'bg1':        ['#232933',   '236'],
    \ 'bg2':        ['#242832',   '237'],
    \ 'bg3':        ['#262635',   '238'],
    \ 'bg4':        ['#272f3b',   '239'],
    \ 'bg5':        ['#2c3040',   '240'],
    \ 'bg_visual':  ['#343848',   '52'],
    \ 'bg_red':     ['#3b2b34',   '52'],
    \ 'bg_green':   ['#283b3b',   '22'],
    \ 'bg_blue':    ['#243940',   '17'],
    \ 'bg_yellow':  ['#413d37',   '136'],
    \ }
  let palette2 = {
    \ 'fg':         ['#b6c4f2',   '223'],
    \ 'red':        ['#e06c75',   '167'],
    \ 'orange':     ['#d19a66',   '208'],
    \ 'yellow':     ['#ffd88c',   '214'],
    \ 'green':      ['#64d1a9',   '142'],
    \ 'aqua':       ['#56b6c2',   '108'],
    \ 'blue':       ['#56b6c2',   '109'],
    \ 'purple':     ['#c678dd',   '175'],
    \ 'grey0':      ['#54718c',   '243'],
    \ 'grey1':      ['#707a8c',   '245'],
    \ 'grey2':      ['#666a71',   '247'],
    \ 'statusline1':['#a7c080',   '142'],
    \ 'statusline2':['#d3c6aa',   '223'],
    \ 'statusline3':['#e67e80',   '167'],
    \ 'none':       ['NONE',      'NONE']
    \ } "}}}
  return extend(extend(palette1, palette2), a:colors_override)
endfunction "}}}

function! nightfall_dimmed#highlight(group, fg, bg, ...) "{{{
  execute 'highlight' a:group
        \ 'guifg=' . a:fg[0]
        \ 'guibg=' . a:bg[0]
        \ 'ctermfg=' . a:fg[1]
        \ 'ctermbg=' . a:bg[1]
        \ 'gui=' . (a:0 >= 1 ?
          \ a:1 :
          \ 'NONE')
        \ 'cterm=' . (a:0 >= 1 ?
          \ a:1 :
          \ 'NONE')
        \ 'guisp=' . (a:0 >= 2 ?
          \ a:2[0] :
          \ 'NONE')
endfunction "}}}

function! nightfall_dimmed#syn_gen(path, last_modified, msg) "{{{
  " Generate the `after/syntax` directory.
  let full_content = join(readfile(a:path), "\n") " Get the content of `colors/nightfall_dimmed.vim`
  let syn_conent = []
  let rootpath = nightfall_dimmed#syn_rootpath(a:path) " Get the path to place the `after/syntax` directory.

  call substitute(full_content, '" syn_begin.\{-}syn_end', '\=add(syn_conent, submatch(0))', 'g') " Search for 'syn_begin.\{-}syn_end' (non-greedy) and put all the search results into a list.

  for content in syn_conent
    let syn_list = []
    call substitute(matchstr(matchstr(content, 'syn_begin:.\{-}{{{'), ':.\{-}{{{'), '\(\w\|-\)\+', '\=add(syn_list, submatch(0))', 'g') " Get the file types. }}}}}}

    for syn in syn_list
      call nightfall_dimmed#syn_write(rootpath, syn, content) " Write the content.
    endfor
  endfor

  call nightfall_dimmed#syn_write(rootpath, 'text', "let g:nightfall_dimmed_last_modified = '" . a:last_modified . "'") " Write the last modified time to `after/syntax/text/nightfall_dimmed.vim`

  let syntax_relative_path = has('win32') ? '\after\syntax' : '/after/syntax'

  if a:msg ==# 'update'
    echohl WarningMsg | echom '[nightfall_dimmed] Updated ' . rootpath . syntax_relative_path | echohl None
    call nightfall_dimmed#ftplugin_detect(a:path)
  else
    echohl WarningMsg | echom '[nightfall_dimmed] Generated ' . rootpath . syntax_relative_path | echohl None
    execute 'set runtimepath+=' . fnamemodify(rootpath, ':p') . 'after'
  endif
endfunction "}}}

function! nightfall_dimmed#syn_write(rootpath, syn, content) "{{{
  " Write the content.
  let syn_path = a:rootpath . '/after/syntax/' . a:syn . '/nightfall_dimmed.vim' " The path of a syntax file.
  " create a new file if it doesn't exist
  if !filereadable(syn_path)
    call mkdir(a:rootpath . '/after/syntax/' . a:syn, 'p')
    call writefile([
          \ "if !exists('g:colors_name') || g:colors_name !=# 'nightfall_dimmed'",
          \ '    finish',
          \ 'endif'
          \ ], syn_path, 'a') " Abort if the current color scheme is not nightfall_dimmed.
    call writefile([
          \ "if index(g:nightfall_dimmed_loaded_file_types, '" . a:syn . "') ==# -1",
          \ "    call add(g:nightfall_dimmed_loaded_file_types, '" . a:syn . "')",
          \ 'else',
          \ '    finish',
          \ 'endif'
          \ ], syn_path, 'a') " Abort if this file type has already been loaded.
  endif
  " If there is something like `call nightfall_dimmed#highlight()`, then add
  " code to initialize the palette and configuration.
  if matchstr(a:content, 'nightfall_dimmed#highlight') !=# ''
    call writefile([
          \ 'let s:configuration = nightfall_dimmed#get_configuration()',
          \ 'let s:palette = nightfall_dimmed#get_palette(s:configuration.background, s:configuration.colors_override)'
          \ ], syn_path, 'a')
  endif
  " Append the content.
  call writefile(split(a:content, "\n"), syn_path, 'a')
  " Add modeline.
  call writefile(['" vim: set sw=2 ts=2 sts=2 et tw=80 ft=vim fdm=marker fmr={{{,}}}:'], syn_path, 'a')
endfunction "}}}

function! nightfall_dimmed#syn_rootpath(path) "{{{
  " Get the directory where `after/syntax` is generated.
  if (matchstr(a:path, '^/usr/share') ==# '') " Return the plugin directory. The `after/syntax` directory should never be generated in `/usr/share`, even if you are a root user.
    return fnamemodify(a:path, ':p:h:h')
  else " Use vim home directory.
    if has('nvim')
      return stdpath('config')
    else
      return expand('~') . '/.vim'
    endif
  endif
endfunction "}}}

function! nightfall_dimmed#syn_newest(path, last_modified) "{{{
  " Determine whether the current syntax files are up to date by comparing the last modified time in `colors/nightfall_dimmed.vim` and `after/syntax/text/nightfall_dimmed.vim`.
  let rootpath = nightfall_dimmed#syn_rootpath(a:path)
  execute 'source ' . rootpath . '/after/syntax/text/nightfall_dimmed.vim'
  return a:last_modified ==# g:nightfall_dimmed_last_modified ? 1 : 0
endfunction "}}}

function! nightfall_dimmed#syn_clean(path, msg) "{{{
  " Clean the `after/syntax` directory.
  let rootpath = nightfall_dimmed#syn_rootpath(a:path)
  " Remove `after/syntax/**/nightfall_dimmed.vim`.
  let file_list = split(globpath(rootpath, 'after/syntax/**/nightfall_dimmed.vim'), "\n")
  for file in file_list
    call delete(file)
  endfor
  " Remove empty directories.
  let dir_list = split(globpath(rootpath, 'after/syntax/*'), "\n")
  for dir in dir_list
    if globpath(dir, '*') ==# ''
      call delete(dir, 'd')
    endif
  endfor
  if globpath(rootpath . '/after/syntax', '*') ==# ''
    call delete(rootpath . '/after/syntax', 'd')
  endif
  if globpath(rootpath . '/after', '*') ==# ''
    call delete(rootpath . '/after', 'd')
  endif
  if a:msg
    let syntax_relative_path = has('win32') ? '\after\syntax' : '/after/syntax'
    echohl WarningMsg | echom '[nightfall_dimmed] Cleaned ' . rootpath . syntax_relative_path | echohl None
  endif
endfunction "}}}

function! nightfall_dimmed#syn_exists(path) "{{{
  return filereadable(nightfall_dimmed#syn_rootpath(a:path) . '/after/syntax/text/nightfall_dimmed.vim')
endfunction "}}}

function! nightfall_dimmed#ftplugin_detect(path) "{{{
  " Check if /after/ftplugin exists.
  " This directory is generated in earlier versions, users may need to manually clean it.
  let rootpath = nightfall_dimmed#syn_rootpath(a:path)
  if filereadable(nightfall_dimmed#syn_rootpath(a:path) . '/after/ftplugin/text/nightfall_dimmed.vim')
    let ftplugin_relative_path = has('win32') ? '\after\ftplugin' : '/after/ftplugin'
    echohl WarningMsg | echom '[nightfall_dimmed] Detected ' . rootpath . ftplugin_relative_path | echohl None
    echohl WarningMsg | echom '[nightfall_dimmed] This directory is no longer used, you may need to manually delete it.' | echohl None
  endif
endfunction "}}}

" vim: set sw=2 ts=2 sts=2 et tw=80 ft=vim fdm=marker fmr={{{,}}}:
