#!/bin/bash
# Author: Nick Zwart
# Date: 2019dec30
# Brief: Try to determine a suitable working directory to volume mount before
#        starting the dockerized vim.

set -eo pipefail

####################################################################### INCLUDE
# TODO: inject these as part of the install
# make the docker tags for this project
DOCKER_ACC='3x3t3r'
DOCKER_REP='ni'
DOCKER_TAG='latest'
DOCKER_REF="${DOCKER_ACC}/${DOCKER_REP}"


##################################################################### FUNCTIONS
# an os agnostic way of getting a full path
function fullpath {
    python3 -c "import os; print(os.path.realpath(os.path.expanduser('${1}')))"
}

# see if the mount point is under git version control
function gitsearch () {
    CUR=$1
    GITDIR='.git'
    LAST=
    # don't try the same directory twice
    while [ "${CUR}" != "${LAST}" ]; do
        if [ -d "${CUR}/${GITDIR}" ]; then
            echo "${CUR}"
            return
        fi
        LAST=${CUR}
        CUR=$(dirname ${CUR})
    done
}

# escape chars within a string for subsequent use in sed
function escape () {
    echo $(echo ${1} | sed 's/[\/&]/\\&/g')
}


########################################################################## MAIN
# assume the user will only give one arg and that it will be a file or
# directory path.
ARG=$1
MNT=$('pwd')  # by default use the current working dir
FNAME=  # by default there is no filename

# get a full path for determining mount points and correctly handling links
ARG=$(fullpath ${ARG})

# check for directory
if [ -d "${ARG}" ]; then

    # use the arg as a mount point
    MNT=${ARG}
    FNAME='.'  # put vim into directory listing mode

# check if the path is a file
elif [ -f "${ARG}" ]; then

    # split the filename and dir into basename and mount point
    MNT=$(dirname ${ARG})
    FNAME=$(basename ${ARG})

# if a path is given that does not exist, then assume its a file that will be
# created. Find the directory name and treat the basename as the new filename
elif [ -d "$(dirname ${ARG})" ]; then

    # split the filename and dir into basename and mount point
    MNT=$(dirname ${ARG})
    FNAME=$(basename ${ARG})

    # since user-mapping happens on some systems and not others; we can just
    # touch the file that is about to be created while in the user's
    # environment before going to the container
    NEW_FILE=${MNT}/${FNAME}
    echo "Making new file ${NEW_FILE}"
    touch "${NEW_FILE}"

fi

# mount at the git dir to allow for git ops
if [ -n "$(gitsearch ${MNT})" ]; then

    PARENT=$(gitsearch ${MNT})
    echo ".git was found in '${PARENT}', setting as mount point."
    FNAME="$(echo ${MNT} | sed "s/$(escape ${PARENT})//g")/${FNAME}"
    FNAME="$(echo ${FNAME} | sed 's/^\///g')"  # remove leading slash
    MNT=${PARENT}

fi

# if no args are given then mount the current directory
echo "MOUNT: ${MNT}"
echo "FILE: ${FNAME}"

# change detach keys from ctrl-p to something less obtrusive to vim
docker run -it --rm --detach-keys="ctrl-@" -v ${MNT}:/vimwd "${DOCKER_REF}" "${FNAME}"

# for some reason the terminal gets trashed when vim exists so it needs 'clear'
# or 'reset'
reset
