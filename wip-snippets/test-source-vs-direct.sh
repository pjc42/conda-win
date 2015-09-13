if [[ -n $BASH_VERSION ]] && [[ "$(basename "$0" 2> /dev/null)" == "activate" ]]; then
    >&2 echo "Error: activate must be sourced. Run 'source activate envname'
instead of 'activate envname'.
"
    "$(dirname "$0")/conda" ..activate -h
    exit 1
fi