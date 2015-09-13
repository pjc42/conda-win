# ref: http://www.cyberciti.biz/faq/unix-linux-bash-function-number-of-arguments-passed/

# Each bash shell function has the following set of shell variables:
# [a] All function parameters or arguments can be accessed via $1, $2, $3,..., $N.
# [b] $* or $@ holds all parameters or arguments passed to the function.
# [c] $# holds the number of positional parameters passed to the function.
# [d] An array variable called FUNCNAME ontains the names of all shell functions currently in the execution call stack.

## Define a function called foo()
foo(){
    echo "Function name:  ${FUNCNAME}"
    echo "The number of positional parameter : $#"
    echo "All parameters or arguments passed to the function: '$@'"
    argCnt=1
    for i in "$@"; do
        echo "arg ${argCnt} is ${i}"
        argCnt=$((argCnt + 1))
    done  
  echo
}
 
## Call or invoke the function ##
## Pass the parameters or arguments  ##
foo nixCraft
foo 1 2 3 4 5
foo "this" "is" "a" "test"
 


function foo2() {
    echo "Function name: ${FUNCNAME}"
    if [[ $# < 1 ]] ; then
        echo "cmd count less than 1, cmd count = $#"
    else
        echo "cmd count greater than or equal 1, cmd count = $#"
    fi
}

foo2 1 2 3
foo2 how the heck
foo2 ok
foo2
