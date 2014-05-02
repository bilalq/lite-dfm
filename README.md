LiteDFM
========

A lightweight plugin to remove distractions from Vim.

This is based loosely on *Distraction Free Mode* in Sublime Text.

A key differentiator from most other implementations of distraction free writing
in Vim is that support for vsplits remains uncrippled. This comes at the expense
of proper centering, though, so there's a tradeoff.

![Demo](https://raw.github.com/bilalq/lite-dfm/master/demo.gif)

Installation
------------

For Pathogen:

    git clone https://github.com/bilalq/lite-dfm ~/.vim/bundle

For Vundle, add this to your vimrc and run BundleInstall:

```vim
Bundle 'bilalq/lite-dfm'
```

Usage
-----

There are 3 commands that are exposed:
* `LiteDFM`
* `LiteDFMClose`
* `LiteDFMToggle`

For convenience, I would recommend setting up a mapping to quickly toggle.

```vim
nnoremap <Leader>z :LiteDFMToggle<CR>
```

If you dislike the fact that the last run command shows up as a message, use
this mapping instead:

```vim
nnoremap <Leader>z :LiteDFMToggle<CR>i<Esc>`^
```

If you're a tmux user and really want to get fancy, this should interest you:

```vim
nnoremap <Leader>z :LiteDFMToggle<CR>:silent !tmux set status > /dev/null 2>&1<CR>:redraw!<CR>
```

Customization
-------------

### Colors
You can manually specify the color to be used for hiding UI elements. There
are two global variables that can be used to override the one that is normally
detected. One is for CLI Vim, while the other is for gui Vim. You can set
these in your vimrc like so:

```vim
let g:lite_dfm_normal_bg_cterm = 234
let g:lite_dfm_normal_bg_gui = '#abcabc'
```

If you are using a value of none for your background color, this is the only
way you will be able to make this plugin properly hide your UI elements.

### Left offset
This plugin doesn't center, but instead offsets text from the left. You can
specify exactly how many columns you want this offset to be. Any value from 1 to
22 is valid. By default, 22 is used.

```vim
let g:lite_dfm_left_offset = 16
```

### Keeping the ruler
You may prefer to have the ruler on when you have LiteDFM active. You can do so
by adding this to your vimrc:

```vim
let g:lite_dfm_keep_ruler=1
```

Similar Plugins
---------------

* [VimRoom](http://projects.mikewest.org/vimroom/)
* [Distraction Free Writing with Vim](http://www.laktek.com/2012/09/05/distraction-free-writing-with-vim/)
* [goyo.vim](https://github.com/junegunn/goyo.vim)
