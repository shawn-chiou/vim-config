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

Global keys: `<F3>` NERDTree, `<F6>` Autoformat, `<F8>` Tagbar, `<F9>` toggles a terminal
running `claude`, `<C-n>`/`<C-p>` buffer cycling, `<leader>f{s,g,d,c,t,e,f,i}` cscope
queries.

`set nocompatible` and `let mapleader` sit at the very top of `vimrc`, before
`plug#begin()`, and must stay there. `<leader>` is expanded when a mapping is *defined*,
so a `mapleader` set further down silently binds every earlier mapping to the default
`\` instead. That is what used to put the cscope maps on `\f*` and let `\l` shadow
vimtex's whole `<localleader>l` prefix. `nocompatible` has to precede the plugin block
for the same class of reason: `vim -u vimrc` starts compatible, and plugins using line
continuations then fail with `E10`.

`<F9>` calls `s:ClaudeToggle()`, which hides the window rather than wiping the buffer, so
the claude session keeps running in the background; it only starts a new one once
`term_getstatus()` reports the job finished. The `tnoremap` counterpart is what makes it
closable from inside the terminal — without it the key is sent to claude as input.

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
| `tex.vim` | 2, expandtab | vimtex (options live in `vimrc`, not here) | vimtex's own `<localleader>l*` |
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

Verify what is actually active with `:SyntasticInfo` inside a real buffer — see
*Scripted checks* below for how to drive that non-interactively.

### Completion

YouCompleteMe (global, built with `./install.py --all`) is the **only** completion engine.
`Shawnc2/vim-deoplete` was previously declared for sh/python but that GitHub repo returns
404 and was never installed; it has been removed along with its dead `g:deoplete#*` settings.
Don't reintroduce deoplete: it is unmaintained, needs `nvim-yarp` + `vim-hug-neovim-rpc` +
`pynvim` under plain Vim, and conflicts with YCM.

YCM compiles against a specific Python, so **rebuild it after any Vim or Python upgrade**:

```sh
cd ~/.vim/plugged/YouCompleteMe && ./install.py --all
```

`install.py` needs `setuptools` in the interpreter Vim loads, or it silently degrades:
`Building regex module failed. Falling back to re builtin.` and a watchdog warning about
kqueue. Both are performance-only, but the fix is `brew install python-setuptools` — not
`pip3 install`, because Homebrew's Python is `EXTERNALLY-MANAGED`.

To check a build actually matches the running Vim, compare the interpreter Vim loads
(`:py3 import sys; print(sys.version)`) against the compiled artifacts — all three must
carry the same `cpython-3XX` tag:

```sh
ls ~/.vim/plugged/YouCompleteMe/third_party/ycmd/ycm_core*.so
find ~/.vim/plugged/YouCompleteMe/third_party/ycmd/third_party/regex-build -name '*.so'
find ~/.vim/plugged/YouCompleteMe/third_party/ycmd/third_party/watchdog_deps -name '_watchdog_fsevents*.so'
```

`:YcmDebugInfo` in a real buffer is the end-to-end check; the server logs it names should
contain no `falling back` lines. A `No semantic completer exists for filetypes:
['ycm_nofiletype']` error there is normal — it just means the buffer had no filetype.

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

### Vim version and environment

**vimtex requires Vim 9.2+** (`has('patch-9.2.0')`). On 9.1 it fails in a way that looks
like a config bug rather than a version problem: its `ftplugin/tex.vim` sets
`b:did_ftplugin = 1` *before* the version check, then `echoerr`s and `finish`es. So
`vimtex#init()` never runs, every `:Vimtex*` command is missing, `b:vimtex` is unset, and
`$VIMRUNTIME/ftplugin/tex.vim` is skipped too. Diagnose with `exists(':VimtexCompile')`
rather than by reading the config.

**A shell started from Vim's `:terminal` inherits `VIM` and `VIMRUNTIME`.** Since `<F9>`
opens claude that way, a claude session outliving a Vim upgrade keeps pointing at the old
runtime, and any `vim` run from it dies with
`E484: Can't open file .../vim91/syntax/syntax.vim`. Restart the outer Vim, or prefix with
`env -u VIMRUNTIME -u VIM`.

### Scripted checks

`vim -es` (Ex mode) loads no plugins, so it does not reflect a real session. `vim -u
<file>` starts compatible, which this `vimrc` now corrects on its first line — but pass
`-N` when sourcing any other file. Drive checks with
`vim --not-a-term -c '<cmd>' -c 'qa!' <file> </dev/null` and collect output through
`redir! > <path>` in a sourced script file rather than long `-c` strings, which are easy
to mis-quote. Anything depending on `VimEnter` timers — YCM's startup in particular —
cannot be verified this way at all; check those interactively.

### Known inconsistencies (verify before "fixing")

- `vimrc.bak` and `*.swp` files are untracked leftovers, not part of the config.

## External tool prerequisites

**Vim 9.2+** (vimtex's floor) with `+python3`, `+terminal`, `+timers` and `+conceal`.
`python-setuptools` must be present in the interpreter Vim loads, for YCM's build.

Beyond the README list (cmake, cscope, ctags, curl, gcc/g++, git, make, python 3.x, vim),
the ftplugins assume `flake8`, `autopep8`, `shellcheck`, `shfmt`, `sqlfluff`, `gofmt`, and
a LaTeX toolchain with Skim are on `PATH`. YouCompleteMe is built with
`./install.py --all` by vim-plug's `do` hook.

Missing tools fail **silently** — syntastic just skips the checker, which looks identical to
a broken config, so check the binary before debugging the Vim side. All of the above are
installed via Homebrew on the current machine:

```sh
brew install flake8 shellcheck shfmt autopep8 sqlfluff python-setuptools
```

Prefer `brew` over `pip3 install` for the Python-based tools: the formulae keep their own
venvs and link into `/opt/homebrew/bin`, matching how the rest of these are installed.
