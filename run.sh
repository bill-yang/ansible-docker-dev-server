#!/bin/bash

################################################################################
# This script run develop environment
################################################################################

#### Variables ####
PROGNAME=${0##*/}

# ansible playbook folder
PLAYBOOK_DIR=~/workspace/projects/devops/ansible

#### functions ####
start() {
    # goto the playbook folder
    cd ${PLAYBOOK_DIR}
    # web server
    ansible-playbook playbook-docker-lemp.yml
    # go back to previous folder
    cd - >/dev/null
}

elk() {
    # goto the playbook folder
    cd ${PLAYBOOK_DIR}
    # elk
    ansible-playbook playbook-docker-elk.yml
    # go back to previous folder
    cd - >/dev/null
}

deploy() {
    # goto the playbook folder
    cd ${PLAYBOOK_DIR}
    # application
    ansible-playbook playbook-docker-deploy.yml 
    # go back to previous folder
    cd - >/dev/null
}

start_deploy() {
    # goto the playbook folder
    cd ${PLAYBOOK_DIR}
    # web server
    ansible-playbook playbook-docker-lemp.yml
    # application
    ansible-playbook playbook-docker-deploy.yml 
    # go back to previous folder
    cd - >/dev/null
}

clean() {
    while true; do
        read -p "Do you really want to remove all docker containers/images? (y/n)" yn
        case $yn in
            [Yy]* ) break;;
            [Nn]* ) exit;;
            * ) echo "Please answer yes or no.";;
        esac
    done

    echo "Start delete all docker containers and images ..."
    # to start a fresh new install
    # delete all containers
    docker container rm -vf $(docker ps -a -q)
    # delete all images
    docker image rm -f $(docker images -a -q)
}

help_message() {
    cat <<- _EOF_
$PROGNAME
    Script to install dotfiles to current system.

OPTIONS:
    -h      Display this help message and exit
    -s      Start develop environment
    -d      Deploy web applications
    -e      Run ELK applications
    -a      Start and deploy
    -c      Clean/remove all docker containers and images

_EOF_
  return
}

# reset OPTIND
OPTIND=1
# Parse command-line
if [ $# -lt 1 ]
then
    help_message
    exit
fi
while getopts ":sedach:" opt; do
    case "${opt}" in
        s)
            # Start the environment
            start
            exit
            ;;
        e)
            # ELK applications
            elk
            exit
            ;;
        d)
            # Devploy applications
            deploy
            exit
            ;;
        a)
            # Start and devploy
            start_deploy
            exit
            ;;
        c)
            # Clean all docker containers and images
            clean
            exit
            ;;
        h)
            help_message
            exit
            ;;
        *)
            help_message
            exit 1
            ;;
    esac
done
shift "$((OPTIND-1))"
