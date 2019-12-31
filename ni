#!/bin/bash
# Author: Nick Zwart
# Date: 2019dec30
# Brief: Try to determine a suitable working directory to volume mount before
#        starting the dockerized vim.

# assume the user will only give one arg and that it will be a file or
# directory path.
ARG=$1
MNT=$('pwd')  # by default use the current working dir
FNAME=  # by default there is no filename

# an os agnostic way of getting a full path
function fullpath {
    python3 -c "import os; print(os.path.realpath(os.path.expanduser('${1}')))"
}

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

fi

# if no args are given then mount the current directory
echo "MOUNT: ${MNT}"
echo "FILE: ${FNAME}"
docker run -it --rm -v ${MNT}:/vimwd 'vim' "${FNAME}"

# for some reason the terminal gets trashed when vim exists so it needs 'clear'
# or 'reset'
reset
