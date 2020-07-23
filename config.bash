#!/bin/bash
# Author: Nick Zwart
# Date: 2019dec31
# Brief: a common environment setup function


########################################################################## PATH

function config {

# make the docker tags for this project
DOCKER_ACC='3x3t3r'
DOCKER_REP='ni'
export DOCKER_TAG='latest'
export DOCKER_REF="${DOCKER_ACC}/${DOCKER_REP}"

# Get the directory of THIS script. Assume its located in the project root.
SWD="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
PROJECT_ROOT="$SWD"

# install files and targets
export CMD_SRC="${PROJECT_ROOT}/${DOCKER_REP}"
export CMD_DEST="/usr/local/bin/${DOCKER_REP}"

}
