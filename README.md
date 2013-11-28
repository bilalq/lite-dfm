LiteDFM
========

A lightweight way to remove distractions from Vim.

This is based loosely on *Distraction Free Mode* in Sublime Text.

Installation
------------

For Pathogen:

    git clone https://github.com/bilalq/lite-dfm ~/.vim/bundle

For Vundle, add this to your vimrc and run BundleInstall:

    Bundle 'bilalq/lite-dfm'

Usage
-----

There are 3 commands that are exposed:
* `LiteDFM`
* `LiteDFMClose`
* `LiteDFMToggle`

For convenience, I would recommend setting up a mapping to quickly toggle.

    nnoremap <Leader>z :LiteDFMToggle<CR>
