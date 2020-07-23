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

# copy the vim config
COPY vimrc /root/.vimrc
COPY vim /root/.vim

# for performing git commands from vim
COPY gitconfig /root/.gitconfig

# make a working directory
RUN mkdir -p /vimwd

# do initial vim setup
ENTRYPOINT ["/entrypoint"]
