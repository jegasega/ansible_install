#!/bin/bash
# Script for installing Ansible so it can be used through Virtual environment
# Without making any changes on the host machine

# Detecting OS version and the way to install packages

# set -x

ANSIBLE_ENVIRONMENT_NAME='ansible_infra'

function check_errors
{
if [ "$?" -ne 0 ]; then

        echo "Command $0 failure !!!!" >> $LOG
        exit 1
else

        echo "OK" >> $LOG
fi
}

function run_command()
{
        echo "$@"
        echo "$@" >> $LOG
        eval "$@" 2>> $LOG
        check_errors
}

if [ -f /etc/os-release ]; then

    . /etc/os-release
    
    if [ $NAME == 'Ubuntu' ]; then
        PACKAGE_MANAGER='apt-get'
        PACKAGE_NAME='virtualenv'
	LOG='/var/log/syslog'
    fi
elif [ -f /etc/redhat-release ]; then

    PACKAGE_MANAGER='yum'
    PACKAGE_NAME='python-virtualenv'
    LOG='/var/log/messages'

else
    echo "System is not supported yet"
    exit 1
fi

run_command "sudo ${PACKAGE_MANAGER} install ${PACKAGE_NAME} -y"
run_command "cd ~"
run_command "virtualenv ${ANSIBLE_ENVIRONMENT_NAME}"
run_command "pip install --upgrade pip"
run_command "source ~/${ANSIBLE_ENVIRONMENT_NAME}/bin/activate"
run_command "pip install ansible"


echo -e "To start using newly created environment you'll need to run command\n\e[33m\e[1msource  ~/${ANSIBLE_ENVIRONMENT_NAME}/bin/activate\e[0m\e[39m\nevery time you want to use ansible\nOr you can just add it to your .bashrc file"

