# windows shebang #

These don't exist, there is no concept of shebang on windows
However, you can use ASSOC, PATHEXT and FTYPE to `fake it`

I don't show it here but you can get windows to cycle through all the pathext by adding . (empty extension) as a executable type. Windows faithfully adds all executable extensions to ‘circ’ to make it run, but it doesn’t add the empty extension if you don’t tell it to. She the discussion in [nice ref to windows shebang]

[nice ref to windows shebang](http://whitescreen.nicolaas.net/programming/windows-shebangs)

[ms doc on ftype assoc and pathext](https://technet.microsoft.com/en-us/library/Bb490912.aspx)

# ASSOC PATHEXT and FTYPE

The following is adapted from above references

Note to run in Powershell you should either drop down into a cmd shell or use

    cmd /c <assoc, pathext, or ftype cmds>

Note you need admin access to change assoc, ftype and pathext

##Syntax##
    
    Ftype [FileType[=[OpenCommandString]]]


###Parameters###
**FileType**            : Specifies the file type you want to display or change.
**OpenCommandString**   : Specifies the open command to use when opening files of this type.
**/?**                  : Displays help at the command prompt.

##Remarks##
Within an OpenCommandString, ftype substitutes the following variables:

| variables       | Meaning |
| --------------- | -- |
|`%0 or %1`       |are replaced with the file name that you want to open.|
|`%*`             |is replaced with all of the parameters.|
|`%~ n`           |is replaced with all of the remaining parameters, starting with the nthth parameter, where n can be any number from 2 to 9. %2 is replaced with the first parameter, %3 with the second, and so on.|

##Examples##
To display the current file types that have open command strings defined, type:

    ftype

To display the current open command string for a specific file type, type:

    ftype FileType

To delete the open command string for a specific file type, type:

    ftype FileType=

Type:

    ASSOC .pl=PerlScript 
    FTYPE PerlScript=perl.exe %1 %* 

To invoke the Perl script, type:

    script.pl 1 2 3 

To eliminate the need to type the extensions, type:

    set PATHEXT=.pl;%PATHEXT% 

To invoke the Perl script, type:

    script 1 2 3     

On Z9PED16 I added the following

    assoc .sh=bash
    ftype bash=bash.exe %1 %*

Could also add

    assoc .py=python
    ftype python=python %1 %*


## Using ASSOC .c