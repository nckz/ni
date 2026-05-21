FROM alpine:3.22
LABEL maintainer="Nick Zwart <dr.nicky.z@gmail.com>"

# Core runtime: neovim + tools used by the config (git for git-grep,
# ripgrep for Telescope, shellcheck for nvim-lint sh, python for linters/
# formatters invoked by nvim-lint/conform.nvim).
RUN apk --update add --no-cache \
    bash \
    neovim \
    ripgrep \
    fd \
    shellcheck \
    git \
    python3 \
    py3-pip

# Python linter (flake8) and formatter (black) invoked by nvim-lint /
# conform.nvim respectively. Built in a virtualenv to satisfy alpine's
# PEP 668 externally-managed environment.
RUN python3 -m venv /opt/pyenv \
    && /opt/pyenv/bin/pip install --no-cache-dir flake8 black \
    && ln -s /opt/pyenv/bin/flake8 /usr/local/bin/flake8 \
    && ln -s /opt/pyenv/bin/black  /usr/local/bin/black

# copy the entrypoint script
COPY entrypoint /

# for performing git commands from vim
COPY gitconfig /etc/gitconfig

# make a working directory
RUN mkdir -p /vimwd

# copy the configs to a destination accessible by any user.
# Neovim looks in $XDG_CONFIG_HOME/nvim (~/.config/nvim by default).
ARG CONF_DIR=/.config/nvim
RUN mkdir -p $CONF_DIR
COPY init.vim $CONF_DIR/init.vim
COPY vim/colors    $CONF_DIR/colors
COPY vim/plugin    $CONF_DIR/plugin
COPY vim/autoload  $CONF_DIR/autoload
COPY vim/ftplugin  $CONF_DIR/ftplugin
COPY vim/snippets  $CONF_DIR/snippets

# link to root in case ni is started as sudo/root
RUN mkdir -p /root/.config && ln -s /.config/nvim /root/.config/nvim

# Install neovim plugins via the native pack mechanism.
# - Telescope.nvim (file finder; replaces CtrlP)
# - plenary.nvim   (Telescope dependency)
# - nvim-lint      (diagnostics; replaces ALE linters)
# - conform.nvim   (format-on-save; replaces ALE fixers)
RUN mkdir -p $CONF_DIR/pack/git-plugins/start \
    && git clone --depth 1 https://github.com/nvim-telescope/telescope.nvim.git \
        $CONF_DIR/pack/git-plugins/start/telescope.nvim \
    && git clone --depth 1 https://github.com/nvim-lua/plenary.nvim.git \
        $CONF_DIR/pack/git-plugins/start/plenary.nvim \
    && git clone --depth 1 https://github.com/mfussenegger/nvim-lint.git \
        $CONF_DIR/pack/git-plugins/start/nvim-lint \
    && git clone --depth 1 https://github.com/stevearc/conform.nvim.git \
        $CONF_DIR/pack/git-plugins/start/conform.nvim

# Allow any user to write to plugins and read the config
RUN chmod 777 -R $CONF_DIR

# Pass all args to nvim via the entrypoint
ENTRYPOINT ["/entrypoint"]
