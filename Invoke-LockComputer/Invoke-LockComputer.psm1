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
            Mandatory=$true,
            ValueFromPipeline=$true,
            ValueFromPipelineByPropertyName=$true)]
        [string[]]$ComputerName = $env:ComputerName
    )
    
    begin {
        $Splatting = @{
            ClassName = 'Win32_Process'
            MethodName = 'Create'
            Arguments = @{
                CommandLine = 'C:\Windows\System32\rundll32.exe user32.dll,LockWorkStation'
            }
        }
    }

    process {
        foreach ($Computer in $ComputerName) {
            $Name = $Computer.ToUpper()
            if ($Name -ne $env:ComputerName) {
                $Splatting.ComputerName = $Name
            }
            else {
                $Splatting.ComputerName = $null
            }

            Invoke-CimMethod @Splatting
        }
    }
}
