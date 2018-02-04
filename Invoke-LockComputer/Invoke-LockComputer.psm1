function Invoke-LockComputer {
<#
.SYNOPSIS
    This function locks a local or remote machine.

.DESCRIPTION
    This function locks a local or remote machine.

.PARAMETER ComputerName

.EXAMPLE
    Invoke-LockComputer

    Locks the local machine.

.EXAMPLE
    Invoke-LockComputer -ComputerName COMPUTER01
    
    Locks the remote machine COMPUTER01.

.EXAMPLE
    Invoke-LockComputer -ComputerName COMPUTER01,COMPUTER02,COMPUTER03

    Locks the remote machines COMPUTER01, COMPUTER02, and COMPUTER03.

.EXAMPLE
    Get-Content C:\computers.txt | Invoke-LockComputer

    Locks the remote machines listed in the text file.
#>

    [CmdletBinding()]
    
    param(
        [Parameter(
            ValueFromPipeline=$true)]
        [string[]]$ComputerName = $env:ComputerName
    )
    
    process {
        foreach ($Computer in $ComputerName) {
            $Name = $Computer.ToUpper()

            $Splatting = @{
                ClassName = "Win32_Process"
                MethodName = "Create"
                Arguments = @{
                    CommandLine = "C:\Windows\System32\rundll32.exe user32.dll,LockWorkStation"
                }
            }
            if ($Name -ne $env:ComputerName) {
                $Splatting.ComputerName = $Name

                if ( Test-Connection -ComputerName $Name -Count 1 ) {
                    Write-Verbose -Message ( "PROCESS - {0} - Locking the screen" -f $Name )
                }
                else {
                    Write-Warning -Message ( "PROCESS - {0} - Failed to connect to host" -f $Name )
                    continue
                }
            }

            Invoke-CimMethod @Splatting
        }
    }
}
