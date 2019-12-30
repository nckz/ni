FROM ubuntu:bionic-20191029
MAINTAINER Nick Zwart

# make sure configuration scripts are non-interactive
RUN echo 'debconf debconf/frontend select Noninteractive' | debconf-set-selections

# install vim and any other desired packages
RUN apt-get update && apt-get install -y \
    --allow-downgrades \
    --no-install-recommends \
    vim

# copy the entrypoint script
COPY entrypoint /

# copy the vim config
COPY vimrc /root/.vimrc
COPY vim /root/.vim

# make a working directory
RUN mkdir -p /vimwd

#ENV TERM=xterm-256color

# do initial vim setup
ENTRYPOINT ["/entrypoint"]
