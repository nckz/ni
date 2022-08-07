FROM alpine:3.11
MAINTAINER Nick Zwart <dr.nicky.z@gmail.com>

RUN apk --update add --no-cache \
    bash \
    vim \
    shellcheck \
    git \
    python3 \
    py3-pip

# get the python linters of interest
RUN apk add --no-cache --virtual .build-deps \
        gcc \
        musl-dev \
        python3-dev \
    && pip3 install --upgrade pip && pip3 install --no-cache-dir flake8 black \
    && apk del .build-deps

# copy the entrypoint script
COPY entrypoint /

# for performing git commands from vim
COPY gitconfig /etc/gitconfig

# make a working directory
RUN mkdir -p /vimwd

# copy the configs to a destination accessible by any user
# the user's home dir
ARG CONF_DIR=/
COPY vim $CONF_DIR/.vim
COPY vimrc $CONF_DIR/.vimrc

# link to root in case ni is started as sudo/root
RUN cd /root && ln -s /.vim
RUN cd /root && ln -s /.vimrc

# Install Ale
# https://github.com/dense-analysis/ale
RUN mkdir -p $CONF_DIR/.vim/pack/git-plugins/start
RUN git clone --depth 1 https://github.com/dense-analysis/ale.git $CONF_DIR/.vim/pack/git-plugins/start/ale

# Allow any user to write to plugins
RUN chmod 777 -R $CONF_DIR/.vim
RUN chmod +r -R $CONF_DIR/.vimrc

# Pass all args to vim via the entrypoint
ENTRYPOINT ["/entrypoint"]
