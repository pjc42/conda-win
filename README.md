# conda-win
Scripts for managing conda environments in windows Powershell and GitBash consoles.

Anaconda provides batch files which are not very convenient to use because you have to use cmd shell.
These scripts provide activate and deactivate in Powershell and GitBash consoles. 


## PSCondaScripts

This is a fork of [Liquidmantis/PSCondaEnvs](https://github.com/Liquidmantis/PSCondaEnvs).
Provides conda commands activate and deactivate in Powershell. This fork publishes the commands as PS functions so don't need to dropped into Scripts dir of conda install. Load in Powershell powershell_profile.ps1 to make available to all shells.

    activate <envname>
    deactivate

Uses three global variables

    $env:CONDA_CURRENT_ENV
    $env:CONDA_BASE_PATH
    $function:global:CONDA_BASE_PROMPT

`PSConda.psm1` and `PSConda.ps1` are identical except for Export-ModuleMember statement. Modules (.psm1) are more convenient than scripts for importing into environments so maintain only `PSConda.psm1`. If you want to use `PSConda.ps1` remember to *dot source* the script, see [understanding dot sourcing](http://ss64.com/ps/source.html).  

**Other Powershell References**

* [Understanding Powershell Profiles](http://blogs.technet.com/b/heyscriptingguy/archive/2012/05/21/understanding-the-six-powershell-profiles.aspx)
* [Short intro to PS Modules](http://mikefrobbins.com/2013/07/04/how-to-create-powershell-script-modules-and-module-manifests/)
* If scripts and modules don't run in your PS check the execution policy.
[PS Execution Policy](https://technet.microsoft.com/en-us/library/hh849812.aspx)


## GitBashCondaScripts

This is an adaption of PSCondaScripts to work in windows GitBash shell.
Provides conda commands activate and deactivate in GitBash. It publishes the commands 

    activate <envname>
    deactivate

as bash functions so don't need to dropped into Scripts dir of conda install. Load in .bashrc or similar to make available to all shells.

Contains custom PS1 which should be changed.

Uses environment variables to manage environments and rollback (same as PSCondaScripts)

    CONDA_CURRENT_ENV
    CONDA_BASE_PATH
    CONDA_BASE_PS1
  
