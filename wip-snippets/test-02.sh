# Determine the directory containing this script
if [[ -n $BASH_VERSION ]]; then
    _SCRIPT_LOCATION=${BASH_SOURCE[0]}
    echo 'branch 1'
    echo $BASH_VERSION
    echo $_SCRIPT_LOCATION
else
    echo "Only bash and zsh are supported"
    return 1
fi

echo "The script you are running has basename `basename $0`, dirname `dirname $0`"
echo "The present working directory is `pwd`"


# this version really works
# ref: http://stackoverflow.com/questions/59895/can-a-bash-script-tell-what-directory-its-stored-in
echo 'hse....'
SCRIPT_PATH="${BASH_SOURCE[0]}";
if ([ -h "${SCRIPT_PATH}" ]) then
  while([ -h "${SCRIPT_PATH}" ]) do SCRIPT_PATH=`readlink "${SCRIPT_PATH}"`; done
fi
pushd . > /dev/null
cd `dirname ${SCRIPT_PATH}` > /dev/null
SCRIPT_PATH=`pwd`;
popd  > /dev/null

echo "the final path is $SCRIPT_PATH"

