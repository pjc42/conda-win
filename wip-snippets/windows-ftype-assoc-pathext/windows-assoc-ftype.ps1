#Requires -Version 2.0   

# ref:  https://p0w3rsh3ll.wordpress.com/2012/04/18/assoc-and-ftype/

# 2015.09.11, I haven't used this just kept for reference        

/*            
Of course, you can use these old DOS commands, assoc and ftype, inside a powershell console. Actually, these 2 commands only query the registry and/or set some values.
I’ve always found frustrating that you have to type 2 commands before being able to associate a file extension to a new program.
For example, to associate .ext with a program and instruct Windows explorer to use notepad to open it whenever you double click on .ext file, you have to type assoc .ext=extfile and then ftype extfile=notepad %1.
To summarize and be more specific, the assoc command just sets and/or looks inside the HKLM\Software\classes\.ext default value.
Idem, the ftype DOS command just sets and/or looks inside the HKLM\Software\classes\extfile\open\command default value.
I propose the following function to achieve the same in 1 command instead of 2 and use the full power of powershell, i.e. objects.

# Create a new file extension .ext and let notepad open these type of files            
Get-Assoc -Set -Extension ".ext" -Program 'notepad %1'            
            
# List all the file extensions under C:\windows and show their associated program            
Get-Item $env:systemroot\* | Where-Object {$_ -isnot [System.IO.DirectoryInfo] } | Group-Object -Property Extension | Select-Object -ExpandProperty Name | Get-Assoc            
            
# Extension that exists in the registry and that has an explicit "noOpen" specified (under HKCR\.dat)            
Get-assoc -Find .dat            
            
# Unknown extension            
Get-assoc -Find .etl            
            
# Extension that exists in the registry but that has an explicit NoOpen under its file type (under HKCR\dllfile)            
Get-assoc -Find .dll


*/


            
Function Get-Assoc             
{            
[CmdletBinding(DefaultParameterSetName='Find', SupportsTransactions=$false)]            
param(            
   [Parameter(ParameterSetName='Find', ValueFromPipeline=$true, Mandatory=$false, Position=0)]            
    [system.string[]]${Find},            
            
   [Parameter(ParameterSetName='Set', ValueFromPipeline=$false, Mandatory=$true, Position=0)]            
    [System.Management.Automation.SwitchParameter]${Set},            
            
   [Parameter(ParameterSetName='Set', ValueFromPipeline=$false, Mandatory=$true, Position=1)]            
   [ValidatePattern('^\.([a-z0-9]){1,}$')]            
    [system.string]${Extension},            
            
            
   [Parameter(ParameterSetName='Set', ValueFromPipeline=$false, Mandatory=$true, Position=2)]            
    [system.string]${Program}            
            
            
)            
    begin            
    {            
        # Check if we've got the value from the pipeline            
        $direct = $PSBoundParameters.ContainsKey('Find')            
    }            
    process            
    {            
        switch ($PsCmdlet.ParameterSetName)            
        {             
            Find {            
                $resultsar = @()            
                foreach ($item in $Find)            
                {            
                    # Reset variables            
                    $foundassoc = $foundprog = $assoc = $null            
                    # Write-Verbose -Message "Dealing with $item" -Verbose:$true            
                    try            
                    {            
                        $foundassoc = Get-ItemProperty -LiteralPath ("HKLM:\Software\Classes\"  + $item) -ErrorAction Stop            
                    }            
                    catch             
                    {            
                       if ($direct) { Write-Host -ForegroundColor Red -Object "File association not found for extension for $item"}            
                    }            
                    if ($foundassoc -ne $null)            
                    {            
                        if ($foundassoc.Count -ne 0)            
                        {            
                            $assoc = $foundassoc.'(default)'            
                            if ($assoc -ne $null)            
                            {            
                                try            
                                {            
                                    $foundprog = @(Get-ItemProperty -LiteralPath ("HKLM:\Software\Classes\"  + $assoc + "\shell\open\command") -ErrorAction Stop)            
                                }             
                                catch             
                                {            
                                    if($direct){ Write-Host -ForegroundColor Red -Object "File type `'$assoc`' not found or no open command associated with it."}            
                                }            
                                if ($foundprog -ne $null)            
                                {            
                                    $resultsar +=  New-Object -TypeName PSObject -Property @{            
                                        Extension = $item            
                                        Association = $assoc            
                                        Program = $foundprog.'(default)'            
                                    }            
                                } else {            
                                    $resultsar +=  New-Object -TypeName PSObject -Property @{            
                                        Extension = $item            
                                        Association = $assoc            
                                        Program = "NoOpen"            
                                    }            
                                }            
                            } else {            
                                $resultsar +=  New-Object -TypeName PSObject -Property @{            
                                    Extension = $item            
                                    Association = "NoOpen"            
                                    Program = ""            
                                }            
                            }            
                        }            
                    } else {            
                        $resultsar +=  New-Object -TypeName PSObject -Property @{            
                            Extension = $item            
                            Association = "Unknown"            
                            Program = ""            
                        }            
                    }            
                }            
                # Output results            
                return $resultsar            
            } # end of find            
            Set {            
                # Define some common parameters            
                $extraparams = @{}            
                $extraparams += @{Force = $true ; Verbose  = $false ; ErrorAction = 'Stop'}            
                $key = "HKLM:\Software\Classes\" + $Extension            
                $assocfile = ($Extension -replace "\.","") + "file"            
                if (-not(Test-Path -Path $key))            
                {            
                    try            
                    {            
                        New-Item -Path $key @extraparams | Out-Null            
                    }            
                    catch            
                    {            
                        # Unable to achieve above command            
                        switch ($_)            
                        {            
                            {$_.CategoryInfo.Reason -eq 'UnauthorizedAccessException' } { $reason = "access is denied" }            
                            default { $reason  = $_.Exception.Message }            
                        }            
                        Write-Host -ForegroundColor Red -Object "Failed to create key $key because $reason.`nNote that admin rights are required for this operation."            
                    }            
                }            
                if (Test-Path -Path $key)            
                {            
                    try            
                    {            
                        Set-ItemProperty -Path $key -Name '(default)' -Value $assocfile @extraparams            
                    }            
                    catch            
                    {            
                        # Unable to achieve above command            
                        switch ($_)            
                        {            
                            {$_.CategoryInfo.Reason -eq 'UnauthorizedAccessException' } { $reason = "access is denied" }            
                            default { $reason  = $_.Exception.Message }            
                        }            
                        Write-Host -ForegroundColor Red -Object "Failed to set association $Extension because $reason"            
                    }            
                    # If previous operation where we set the value succeeded, continue as we are sure that we have admin rights            
                    if (-not($?))            
                    {            
                        $programkey = "HKLM:\Software\Classes\" + $assocfile + "\shell\open\command"            
                        if (-not(Test-Path -Path $programkey))            
                        {            
                                New-Item -Path $programkey @extraparams | Out-Null            
            
                        }             
                        if (Test-Path -Path $programkey)            
                        {            
                                Set-ItemProperty -Path $programkey -Name '(default)' -Value $program @extraparams            
                        }            
                    }            
                }            
            } # end of set            
        } # end of switch            
    } # end of process            
    end {}            
} # end of function
