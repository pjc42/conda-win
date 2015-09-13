# Determine the directory containing this script
if [[ -n $BASH_VERSION ]]; then
    _SCRIPT_LOCATION=${BASH_SOURCE[0]}
    _SCRIPT_LOCATION="${BASH_SOURCE[0]}";
    if ([ -h "${_SCRIPT_LOCATION}" ]) then
      while([ -h "${_SCRIPT_LOCATION}" ]) do _SCRIPT_LOCATION=`readlink "${_SCRIPT_LOCATION}"`; done
    fi
    pushd . > /dev/null
    cd `dirname ${_SCRIPT_LOCATION}` > /dev/null
    _SCRIPT_LOCATION=`pwd`;
    popd  > /dev/null
    # DEBUG
    echo "_SCRIPT_LOCATION : ${_SCRIPT_LOCATION}"
else
    echo "Only bash is supported"
    return 1
fi

_THIS_DIR=$(dirname "$_SCRIPT_LOCATION")
echo 'this is the script location'
echo $_SCRIPT_LOCATION
echo $_THIS_DIR
echo $(dirname "$_THIS_DIR")
