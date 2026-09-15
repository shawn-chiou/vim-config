# vim-config

My Vim configuration. Vim only — not Neovim.

* `vimrc` — plugin declarations (via [vim-plug](https://github.com/junegunn/vim-plug)),
  global options and global mappings.
* `ftplugin/*.vim` — per-filetype indentation, checkers, format-on-write and
  buffer-local mappings.

## Deployment

The repo is not sourced in place. Copy the files to the standard Vim locations:

```sh
cp vimrc          ~/.vimrc
cp ftplugin/*.vim ~/.vim/ftplugin/
```

Verify with:

```sh
diff ~/.vimrc vimrc && diff -r ~/.vim/ftplugin ftplugin
```

On first launch `vimrc` downloads vim-plug into `~/.vim/autoload/` by itself; then
run `:PlugInstall` to fetch the plugins into `~/.vim/plugged/`.

## Vim itself

Needs `+python3`, `+terminal`, `+timers` and `+conceal`. Check with `vim --version`.

Vim **9.2+** is required by vimtex only; everything else works on 9.1. Debian trixie
packages 9.1, so LaTeX support there needs testing/sid, backports, or a source build —
check `vim --version` on your distribution before counting on vimtex. On 9.1 it fails
in a way that looks like a config bug rather than a version problem; see `CLAUDE.md`.

## Packages

| Purpose | macOS (Homebrew) | Debian / Ubuntu (apt) |
|---|---|---|
| Vim | `vim` | `vim-nox` |
| Build / tags / VCS | `cmake` `cscope` `universal-ctags` `git` `curl` `make` | `cmake` `cscope` `universal-ctags` `git` `curl` `make` `build-essential` |
| Python | `python-setuptools` | `python3` `python3-setuptools` |
| Python lint/format | `flake8` `autopep8` | `flake8` `python3-autopep8` |
| Shell lint/format | `shellcheck` `shfmt` | `shellcheck` `shfmt` |
| SQL format | `sqlfluff` | `sqlfluff` |
| PDF viewer (LaTeX) | `--cask skim` | `zathura` `zathura-pdf-poppler` |

```sh
# macOS
brew install vim cmake cscope universal-ctags git curl make \
             python-setuptools flake8 autopep8 shellcheck shfmt sqlfluff
brew install --cask skim                        # optional, LaTeX only

# Debian / Ubuntu
sudo apt install vim-nox cmake cscope universal-ctags git curl make build-essential \
                 python3 python3-setuptools flake8 python3-autopep8 \
                 shellcheck shfmt sqlfluff
sudo apt install zathura zathura-pdf-poppler    # optional, LaTeX only
```

Platform notes:

* **Prefer the package manager over `pip3 install`** for the Python tools. Homebrew's
  Python is `EXTERNALLY-MANAGED`, and Debian's is too.
* **macOS ships an Exuberant Ctags 5.8 at `/usr/bin/ctags`**, which does not understand
  the `--exclude` flags the `BufWritePost` rule in `vimrc` uses. Keep Homebrew's
  `universal-ctags` ahead of it on `PATH`.
* **Debian's base install ships `vim-tiny`**, which its own package description calls
  "a minimal version […] with a small subset of features", there only to provide the
  `vi` binary. `vim-nox` is the console variant carrying `+python3` and `+terminal`.
* **`autopep8` on Debian is a virtual package**; the binary comes from
  `python3-autopep8`.
* `vimrc` selects the PDF viewer per platform — Skim on macOS, zathura elsewhere —
  so no local edit is needed for either.

Missing tools fail **silently**: syntastic skips the checker and vim-autoformat leaves
the buffer alone, which looks identical to a broken config. Check the binary is on
`PATH` before debugging the Vim side.

## YouCompleteMe

vim-plug builds it through `./install.py --all`, which needs more than the list above:
a C++17 compiler, Go, Node.js + npm, Rust/cargo and a JDK.

```sh
# macOS
brew install go node rust openjdk

# Debian / Ubuntu
sudo apt install golang-go nodejs npm rustc cargo default-jdk
```

Use `./install.py --clang-completer` instead for C-family completion only. Rebuild
after any Vim or Python upgrade:

```sh
cd ~/.vim/plugged/YouCompleteMe && ./install.py --all
```

## LaTeX (optional)

A TeX distribution plus one of the viewers above — e.g. MacTeX on macOS, or
`texlive-latex-recommended` on Debian. Skip all of it if you do not edit `.tex`.
