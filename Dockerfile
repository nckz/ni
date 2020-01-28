FROM alpine:3.11
MAINTAINER Nick Zwart <dr.nicky.z@gmail.com>

RUN apk --update add \
    bash \
    vim \
    ctags \
    git

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
