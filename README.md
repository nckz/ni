<p align="center">
  <img width="460" src="./ni.png">
  </p>

<p align="center">
    <i>My cursed vim setup wrapped in a docker image.</i>
</p>


# ni
`ni` is yet another prepackaged vim setup. The difference between this one an
others is that it uses a configuration of vim that is too much a part of my
muscle memory for me to leave behind.

## What It Does
This package contains a launcher script that makes it easy to use this vim
config on any docker ready host e.g.:

```bash
$ ni
$ ni .
$ ni ~/.my_hidden_file
$ ni ~/my_softlinked_file
$ ni ../../my_dir
$ ni ../../my_softlinked_dir
$ ni my_new_file
```

The target file or directories will be appropriately volume mounted in the
container by the launch script `ni`.

## Git Aware
`ni` is git-aware so when it starts it will check to see if the target path is
under a git repository and then set the docker mount.  This allows for git
based vim functions such as git-grep.

## Packages
This version of vim uses the following packages:

* [Ale](https://github.com/dense-analysis/ale/blob/master/README.md)
    * python
        * black formatting on save
        * flake8 linter
    * bash
        * shellcheck
    * remove_trailing_lines
* [CtrlP](https://github.com/kien/ctrlp.vim)
* [Solarized](https://ethanschoonover.com/solarized/)
* `ghmarkdown` syntax highlighting

## Mappings of Note
The following mappings are the most interesting:

* Ale Toggle - `,at`
* CtrlP - `,p`
    * CtrlPClearCache - `,cc`
* GitGrep when cursor is on the word
    * `*` highlight search in the same document
    * `^` highlight search in multiple documents (in the same git repo)
    * `&` highlight search using the system `grep` command
* paste toggle - F2
* spell - F6
    * nospell - F7

# Installation
To install, issue the following command:

```bash
sudo bash -c "curl -s https://raw.githubusercontent.com/nckz/ni/master/ni > /usr/local/bin/ni && chmod a+x /usr/local/bin/ni"
```
