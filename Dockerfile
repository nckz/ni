FROM ubuntu:bionic-20191029
MAINTAINER Nick Zwart <dr.nicky.z@gmail.com>

# make sure configuration scripts are non-interactive
RUN echo 'debconf debconf/frontend select Noninteractive' | debconf-set-selections

# install vim and any other desired packages
# - exuberant-ctags: easytags
# - git: git-grep searches
RUN apt-get update && apt-get install -y \
    --allow-downgrades \
    --no-install-recommends \
    vim \
    exuberant-ctags \
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
