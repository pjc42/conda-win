
# pjc 2015.09.09

# manages conda environments on windows in gitbash shell
# creates two bash functions:
#   sh-activate envname
#   sh-deactivate 
# which activate and deactivate conda environments


# adapted from activate.ps1 and deactive.ps1 in project:
#   ref: https://github.com/Liquidmantis/PSCondaEnvs

# I forked this project, see here:
#   ref: https://github.com/pjc42/PSCondaEnvs

# this script has to do what is in activate.bat in sh bash cmds so that
# you can activate and deactivate conda envs via gitbash shell on wins

# Ensure that this script is sourced, not executed

function sh-activate() {
    # activates a conda environment on Windows using gitbash
    if [[ $# < 1 ]] ; then
        echo "Usage: sh-activate envname"
        return 1
    fi

    # get target env name as first arg to sh-activate func
    target_envname="$1"

    # assumes that path_anaconda3 is set, this is set in the .bashrc or something like that
    anacondaInstallPath=$path_anaconda_3

    # build anaconda env path
    anaconda_envs="${anacondaInstallPath}/envs"

    # build abs path to new env
    anaconda_target_env_path="${anaconda_envs}/${target_envname}"

    # test if valid conda env
    if [[ ! -f "$anaconda_target_env_path/python.exe"  ]]; then
        echo "ERROR: ${FUNCNAME}, invalid environment name"
        echo "No environment named ${target_envname} exists in ${anaconda_envs}"
        echo "Usage: sh-activate envname"
        return 1
    fi

    # test if an existing env is active
    # assumes CONDA_CURRENT_ENV contains name of env if active
    if [[ ! -z "$CONDA_CURRENT_ENV" ]]; then
        # ! empty string
        # CONDA_CURRENT_ENV contains a value so we need to sh-deactivate it
        sh-deactivate
    fi

    # target_envname will become the new current conda environment
    CONDA_CURRENT_ENV="${target_envname}"
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

    echo "  CONDA_CURRENT_ENV= ${CONDA_CURRENT_ENV}"
    # echo "CONDA_BASE_PATH ${CONDA_BASE_PATH}"
    # echo "CONDA_BASE_PS1 ${CONDA_BASE_PS1}"   

}



function sh-deactivate() {
    # deactivates a conda environment on Windows using gitbash

    echo "Deactivating environment ${CONDA_CURRENT_ENV} ..."
    # echo "Will attempt rollback unset CONDA_CURRENT_ENV, CONDA_BASE_PATH, CONDA_BASE_PS1"

    # test if a conda env is active
    # assumes CONDA_CURRENT_ENV contains name of env if active
    if [[ -z "$CONDA_CURRENT_ENV" ]]; then
        # empty string
        # CONDA_CURRENT_ENV does not contain a value so nothing to deactivate
        echo "ERROR: ${FUNCNAME}"
        echo "ERROR: CONDA_CURRENT_ENV does not contain a value"
        echo "nothing to deactivate"
        echo "continuing to check CONDA_BASE_PATH, CONDA_BASE_PS1"
    else
        echo "  unset CONDA_CURRENT_ENV: $CONDA_CURRENT_ENV"
        unset CONDA_CURRENT_ENV
    fi

    # test if CONDA_BASE_PATH
    if [[ -z "$CONDA_BASE_PATH" ]]; then
        # empty string, not path to restore
        echo "ERROR: ${FUNCNAME}"
        echo "ERROR: CONDA_BASE_PATH does not contain a value"
        echo "cannot roll back PATH to base value"
        echo "continuing to check CONDA_BASE_PS1"  
    else
        # roll back the PATH to path in CONDA_BASE_PATH and unset
        PATH="${CONDA_BASE_PATH}"
        unset CONDA_BASE_PATH
        echo "  rolled back PATH, unset CONDA_BASE_PATH"    
    fi

    # test if CONDA_BASE_PS1
    if [[ -z "$CONDA_BASE_PS1" ]]; then
        # empty string, not path to restore
        echo "ERROR: ${FUNCNAME}"
        echo "ERROR: CONDA_BASE_PS1 does not contain a value"
        echo "cannot roll back prompt PS1 to base value"
    else
        # rollback the prompt to CONDA_BASE_PS1 and unset
        PS1="${CONDA_BASE_PS1}"
        unset CONDA_BASE_PS1   
        echo "  rolled back PS1, unset CONDA_BASE_PS1"         
    fi

}

export -f sh-activate
export -f sh-deactivate