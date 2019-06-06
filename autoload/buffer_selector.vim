function buffer_selector#OpenBufferSelector() abort
    """ 呼び出し元のウィンドウ ID を記憶
    let s:caller_window_id = win_getid()

    """ 変数 buffer_list に ``:ls`` の結果を格納
    let buffer_list=""
    redir => buffer_list
    silent ls
    redir END

    """ 新しいバッファを作成
    if bufexists(bufnr('__BUFFER_SELECTOR_BUFFER_LIST__'))
        bwipeout! __BUFFER_SELECTOR_BUFFER_LIST__
    endif
    silent bo new __BUFFER_SELECTOR_BUFFER_LIST__

    """ __BUFFER_SELECTOR_BUFFER_LIST__ に ``:ls`` の結果を表示
    silent put!=buffer_list

    """ 先頭と末尾が空行になるのでそれを削除
    normal G"_dd
    normal gg"_dd

    """ ウィンドウサイズ調整
    call buffer_selector#FitWinCol()

    """ バッファリスト用バッファの設定
    setlocal noshowcmd
    setlocal noswapfile
    setlocal buftype=nofile
    setlocal bufhidden=delete
    setlocal nobuflisted
    setlocal nomodifiable
    setlocal nowrap
    setlocal nonumber

    """ 選択したバッファに移動
    map <buffer> <Return> :call buffer_selector#OpenBuffer()<Return>

    """ バッファ削除
    map <buffer> d :call buffer_selector#DeleteBuffer()<Return>

    """ バッファリストを閉じる
    map <buffer> q :call buffer_selector#CloseBufferSelector()<Return>
endfunction

function buffer_selector#CloseBufferSelector() abort
    """ バッファリストを閉じる
    :bwipeout!

    """ 呼び出し元ウィンドウをアクティブにする
    call win_gotoid(s:caller_window_id)
endfunction

function buffer_selector#OpenBuffer() abort
    let buffer_no = buffer_selector#GetBufNo()
    :bwipeout!

    """ 呼び出し元ウィンドウをアクティブにする
    call win_gotoid(s:caller_window_id)

    """ バッファを開く
    execute ":buffer " . buffer_no
endfunction

function buffer_selector#DeleteBuffer() abort
    let buffer_no = buffer_selector#GetBufNo()
    execute "bdelete!" . buffer_no
    setlocal modifiable
    .delete_
    setlocal nomodifiable

    """ ウィンドウサイズ調整
    call buffer_selector#FitWinCol()
endfunction

function buffer_selector#GetBufNo() abort
    let line = getline(line('.'))
    let splited_line = split(line, ' ', 0)
    return get(splited_line, 0)
endfunction

""" ウィンドウサイズ調整
function buffer_selector#FitWinCol() abort
    let current_win_height=winheight('%')
    let line_num=line('$')
    if current_win_height - line_num > 0
        execute "normal z" . line_num . "\<Return>"
    endif
endfunction
