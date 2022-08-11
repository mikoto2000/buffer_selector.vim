vim9script

var caller_window_id = -1

export def OpenBufferSelector()
    ### 呼び出し元のウィンドウ ID を記憶
    caller_window_id = win_getid()

    ### 変数 buffer_list に ``:ls`` の結果を格納
    var buffer_list = ""
    redir => buffer_list
    silent ls
    redir END

    ### 新しいバッファを作成
    if bufexists(bufnr('__BUFFER_SELECTOR_BUFFER_LIST__'))
        bwipeout! __BUFFER_SELECTOR_BUFFER_LIST__
    endif
    silent bo new __BUFFER_SELECTOR_BUFFER_LIST__

    ### __BUFFER_SELECTOR_BUFFER_LIST__ に ``:ls`` の結果を表示
    silent put!=buffer_list

    ### 先頭と末尾が空行になるのでそれを削除
    normal G"_dd
    normal gg"_dd

    ### ウィンドウサイズ調整
    call buffer_selector#FitWinCol()

    ### バッファリスト用バッファの設定
    setlocal noshowcmd
    setlocal noswapfile
    setlocal buftype=nofile
    setlocal bufhidden=delete
    setlocal nobuflisted
    setlocal nomodifiable
    setlocal nowrap
    setlocal nonumber

    ### 選択したバッファに移動
    map <buffer> <Return> :call buffer_selector#OpenBuffer()<Return>

    ### バッファ削除
    map <buffer> d :call buffer_selector#DeleteBuffer()<Return>

    ### バッファリストを閉じる
    map <buffer> q :call buffer_selector#CloseBufferSelector()<Return>
enddef

export def CloseBufferSelector()
    ### バッファリストを閉じる
    :bwipeout!

    ### 呼び出し元ウィンドウをアクティブにする
    call win_gotoid(caller_window_id)
enddef

export def OpenBuffer()
    const buffer_no = GetBufNo()
    :bwipeout!

    ### 呼び出し元ウィンドウをアクティブにする
    call win_gotoid(caller_window_id)

    ### バッファを開く
    execute ":buffer " .. buffer_no
enddef

export def DeleteBuffer()
    const buffer_no = GetBufNo()
    execute "bdelete!" .. buffer_no
    setlocal modifiable
    delete
    setlocal nomodifiable

    ### ウィンドウサイズ調整
    call buffer_selector#FitWinCol()
enddef

def GetBufNo(): string
    const line = getline(line('.'))
    const splited_line = split(line, ' ', 0)
    return get(splited_line, 0)
enddef

### ウィンドウサイズ調整
export def FitWinCol()
    const current_win_height = winheight(0)
    const line_num = line('$')
    if current_win_height - line_num > 0
        execute "normal z" .. line_num .. "\<Return>"
    endif
enddef

