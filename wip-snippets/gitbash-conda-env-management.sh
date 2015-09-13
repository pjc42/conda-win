#!/bin/bash

# pjc 2015.09.09
# adapted from activate.sh on conda OSX and activate.bat on WIN
# this script has to do what is in activate.bat in sh bash cmds so that
# you can activate and deactivate conda envs via gitbash shell on wins

# Ensure that this script is sourced, not executed
# Also note that errors are ignored as `activate foo` doesn't generate a bad
# value for $0 which would cause errors.


function sh-activate() {
    # activates a conda environment on Windows using gitbash
    if [[ $# < 1 ]] ; then
        echo "Usage: sh-activate envname"
        exit 1
    fi

    # get target env name as first arg to sh-activate func
    target_envname="$1"

    # assumes that path_anaconda3 is set
    anacondaInstallPath=$path_anaconda3

    # build anaconda env path
    anaconda_envs=$anacondaInstallPath + '/envs'

    # build abs path to new env
    anaconda_target_env_path=$anaconda_envs + '/${target_envname}'

    # test if valid conda env
    if [[ ! -f "$anaconda_target_env_path/python.exe"  ]]; then
        echo "ERROR: ${FUNCNAME}, invalid environment name"
        echo "No environment named ${target_envname} exists in ${anaconda_envs}"
        echo "Usage: sh-activate envname"
        exit 1
    fi

    # test if an existing env is active
    # assumes CONDA_CURRENT_ENV contains name of env if active
    if [[ ! -z "$CONDA_CURRENT_ENV" ]]; then
        # CONDA_CURRENT_ENV contains a value so we need to sh-deactivate it
        sh-deactivate
    fi

    CONDA_CURRENT_ENV=anaconda_target_env
    echo "Activating environment ${CONDA_CURRENT_ENV}..."

    # fix the PATH
    # save the current path as the CONDA_BASE_PATH
    CONDA_BASE_PATH=$PATH
    # prepend the target env to front of existing path, CONDA_BASE_PATH
    PATH="${anaconda_target_env_path};${anaconda_target_env_path}/Scripts;${CONDA_BASE_PATH}"

    # fix the prompt PS1
    CONDA_BASE_PS1="${PS1}"
    PS1="\[\033[1;36m\][\h][\u]\[\033[32m\][\w]\[\033[0m\]\n (${target_envname}) $ \[\033[0m\]"

    export CONDA_CURRENT_ENV
    export CONDA_BASE_PATH
    export CONDA_BASE_PS1

}

