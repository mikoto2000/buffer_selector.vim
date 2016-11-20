buffer_selector.vim
===================

シンプルで簡単に使えるバッファーセレクターです。

Usage:
------

`buffer_selector#OpenBufferSelector()` を、お好みのキーにマッピングしてください。

設定例 :

```vim
noremap <Leader>l <Esc>:call buffer_selector#OpenBufferSelector()<Enter>
```

`buffer_selector#OpenBufferSelector()` を実行すると、バッファー選択用のバッファーが開きます。

バッファー選択用バッファーで、表示したいバッファーにカーソルを合わせ `<Enter>` を押下してください。


License:
--------

Copyright (C) 2016 mikoto2000

This software is released under the MIT License, see LICENSE

このソフトウェアは MIT ライセンスの下で公開されています。 LICENSE を参照してください。


Author:
-------

mikoto2000 <mikoto2000@gmail.com>
