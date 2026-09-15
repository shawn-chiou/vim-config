# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Repository purpose

Personal Vim configuration (Vim only, **not** Neovim — see README). There is no build,
lint, or test tooling; the "product" is `vimrc` plus the `ftplugin/` directory.

## Deployment model

The repo is **not** sourced in place. Files are copied to the standard Vim locations:

```sh
cp vimrc            ~/.vimrc
cp ftplugin/*.vim   ~/.vim/ftplugin/
```

Both trees are currently byte-identical to the deployed copies. When changing anything
here, re-copy so the live config stays in sync, and verify with:

```sh
diff ~/.vimrc vimrc && diff -r ~/.vim/ftplugin ftplugin
vim -Nu vimrc +q          # syntax-check the vimrc without touching the live config
```

Note `vimrc` contains `let &rtp .= ',' . expand('<sfile>:p:h')`, which appends the
*directory of the sourced file* to `runtimepath`. Under the copy-based deployment that
resolves to `$HOME`, not to this repo — so `ftplugin/` is only found because it lives at
`~/.vim/ftplugin`. Don't assume the repo path is on `runtimepath`.

## Architecture

### `vimrc` — global layer

Bootstraps [vim-plug](https://github.com/junegunn/vim-plug) (auto-downloads
`~/.vim/autoload/plug.vim` on first launch, plugins into `~/.vim/plugged`), declares all
plugins, sets global options, and defines global mappings.

Plugin declarations are grouped by language and **lazy-loaded via `{ 'for': <filetype> }`**.
This is deliberate (commit `484afe5`): adding a plugin for a language means adding it under
that language's section with the matching `for` key, so it only loads with the filetype.
Common/always-on plugins (airline, NERDTree, gitgutter, fugitive, tagbar, cscope.vim,
vim-autoformat, YouCompleteMe) sit in the `====== common ======` block with no `for`.

Global keys: `<F3>` NERDTree, `<F6>` Autoformat, `<F8>` Tagbar, `<F9>` terminal running
`claude`, `<C-n>`/`<C-p>` buffer cycling, `<leader>f{s,g,d,c,t,e,f,i}` cscope queries.
`mapleader` is `,`.

### `ftplugin/*.vim` — per-filetype layer

Vim auto-sources `ftplugin/<filetype>.vim` when a buffer's filetype is set. Each file owns
one language's indentation, syntastic checker, format-on-write autocmd, and buffer-local
`<leader>` mappings (defined with `<buffer>` so they don't leak across filetypes).

Comments in these files are written in Traditional Chinese; match that style when editing.

Per-file responsibilities:

| File | Indent | Checker / tooling | Buffer maps |
|---|---|---|---|
| `python.vim` | 4, expandtab | syntastic/flake8, autopep8 (max-line-length 120) on `BufWritePre` | `<leader>r` run |
| `sh.vim` | 2, expandtab | syntastic/shellcheck (`-x`), Autoformat on write | `<leader>r` run |
| `go.vim` | 4, **noexpandtab** | vim-go, `:GoFmt` on write | `<leader>b/t/r` build/test/run |
| `sql.vim` | 4, expandtab | Autoformat on write (no syntastic — see below) | (run maps commented out) |
| `markdown.vim` | — | wrap/linebreak/spell | `<leader>p` MarkdownPreview |
| `tex.vim` | 2, expandtab | vimtex, viewer `skim` (macOS; zathura line kept commented for Linux) | `<leader>l{l,k,v,c}` |
| `make.vim` | 8, noexpandtab | vim-dispatch; Autoformat on write (no syntastic) | `<leader>m/c/t` make / clean / test |

Global `autocmd BufRead` rules in `vimrc` also set indentation by extension for web files
(2 spaces) and php/css/scss/py (4 spaces). These can conflict with `setlocal` in an
ftplugin — the ftplugin runs on `FileType`, so prefer putting per-language indentation
there rather than adding more `BufRead` rules.

### Linting: how syntastic is wired

`vimrc` declares syntastic **once**, in the `common` block, lazy-loaded for exactly the two
filetypes that have a working checker:

```vim
Plug 'vim-syntastic/syntastic', { 'for': ['sh', 'python'] }
```

Do **not** re-declare it in a language section. vim-plug keys `s:plugs` by plugin name, so a
second `Plug 'vim-syntastic/syntastic', {...}` silently overwrites the first and narrows the
filetype list. To enable a new language, add its filetype to that one list.

Load-time globals (`g:syntastic_enable_signs`, `check_on_open`, `check_on_wq`,
`auto_loc_list`, `aggregate_errors`) live in `vimrc` next to the ycm block. Only
`g:syntastic_<ft>_checkers` and `g:syntastic_<ft>_<checker>_*` belong in an ftplugin —
those are read at check time, so the lazy-load ordering is safe for them.

`g:ycm_show_diagnostics_ui = 0` in `vimrc` is required, not optional: it stops YouCompleteMe
from fighting syntastic over diagnostics (`:help syntastic-ycm`).

Do not add `set statusline+=%{SyntasticStatuslineFlag()}` — airline owns the statusline, and
the function is undefined (`E117`) in buffers where syntastic was never lazy-loaded.

Filetypes deliberately **without** syntastic:

- **sql** — syntastic only ships `sqlint` and `tsqllint`; `sqlfluff` is not a syntastic
  checker. `sqlfluff` stays as a formatting tool only.
- **make** — syntastic has no `make` checker (`syntax_checkers/` has no `make/` directory).

Verify what is actually active with `:SyntasticInfo` inside a real buffer. Note that
`vim -es` (Ex mode) does not load plugins, so scripted checks must use
`vim --not-a-term ... </dev/null`.

### Completion

YouCompleteMe (global, built with `./install.py --all`) is the **only** completion engine.
`Shawnc2/vim-deoplete` was previously declared for sh/python but that GitHub repo returns
404 and was never installed; it has been removed along with its dead `g:deoplete#*` settings.
Don't reintroduce deoplete: it is unmaintained, needs `nvim-yarp` + `vim-hug-neovim-rpc` +
`pynvim` under plain Vim, and conflicts with YCM.

### Formatting

`vim-autoformat` is global and already knows how to drive the external formatters, so a
language usually needs **no** extra plugin — just the binary on `PATH` and a
`BufWritePre ... Autoformat` line in its ftplugin. Its shell default is

```vim
let g:formatdef_shfmt = '"shfmt -i ".(&expandtab ? shiftwidth() : "0")'
```

which picks up the ftplugin's own `shiftwidth`/`expandtab`, so `sh.vim` gets `shfmt -i 2`
for free. `z0mbix/vim-shfmt` was removed for exactly this reason — it only added a manual
`:Shfmt` command on top of what Autoformat already did.

`g:autoformat_autoindent`, `g:autoformat_retab` and `g:autoformat_remove_trailing_spaces`
are all `0` in `vimrc`, which disables vim-autoformat's fallback. A missing formatter
binary therefore leaves the buffer untouched rather than silently re-indenting it.

### Known inconsistencies (verify before "fixing")

- `vimrc.bak` and `*.swp` files are untracked leftovers, not part of the config.

## External tool prerequisites

Beyond the README list (cmake, cscope, ctags, curl, gcc/g++, git, make, python 3.x, vim),
the ftplugins assume `flake8`, `autopep8`, `shellcheck`, `shfmt`, `sqlfluff`, `gofmt`, and
a LaTeX toolchain with Skim are on `PATH`. YouCompleteMe is built with
`./install.py --all` by vim-plug's `do` hook.

Missing tools fail **silently** — syntastic just skips the checker, which looks identical to
a broken config, so check the binary before debugging the Vim side. All of the above are
installed via Homebrew on the current machine:

```sh
brew install flake8 shellcheck shfmt autopep8 sqlfluff
```

Prefer `brew` over `pip3 install` for the Python-based tools: the formulae keep their own
venvs and link into `/opt/homebrew/bin`, matching how the rest of these are installed.
