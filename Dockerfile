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

# the user's home dir
ARG CONF_DIR=/vimconf

# make a container user and home dir
RUN adduser -D --home $CONF_DIR knight

# change container user
USER knight

# copy the vim config
COPY --chown=knight:knight vim $CONF_DIR/.vim
COPY --chown=knight:knight vimrc $CONF_DIR/.vimrc

# install https://github.com/dense-analysis/ale
RUN mkdir -p $CONF_DIR/.vim/pack/git-plugins/start
RUN git clone --depth 1 https://github.com/dense-analysis/ale.git $CONF_DIR/.vim/pack/git-plugins/start/ale

# do initial vim setup
ENTRYPOINT ["/entrypoint"]
