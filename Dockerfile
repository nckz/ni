FROM alpine:3.11
MAINTAINER Nick Zwart <dr.nicky.z@gmail.com>

RUN apk --update add --no-cache \
    bash \
    vim \
    shellcheck \
    git

# install https://github.com/dense-analysis/ale
RUN mkdir -p ~/.vim/pack/git-plugins/start && \
    git clone --depth 1 https://github.com/dense-analysis/ale.git ~/.vim/pack/git-plugins/start/ale

# copy the entrypoint script
COPY entrypoint /

# make a container user and home dir
ARG CONF_DIR=/vimconf
RUN adduser -D --home $CONF_DIR knight

# copy the vim config
COPY vim $CONF_DIR/.vim
COPY vimrc $CONF_DIR/.vimrc

# for performing git commands from vim
COPY gitconfig /etc/gitconfig

# make a working directory
RUN mkdir -p /vimwd

# change container user
USER knight

# do initial vim setup
ENTRYPOINT ["/entrypoint"]
