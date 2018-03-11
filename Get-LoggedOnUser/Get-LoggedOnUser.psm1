function Get-LoggedOnUser {
<#
.SYNOPSIS
    This function gets the logged on user for a local or remote machine.

.DESCRIPTION
    This function gets the logged on user for a local or remote machine.

.EXAMPLE
    PS> Get-LoggedOnUser

    Returns the logged on user for the local machine.

.EXAMPLE
    PS> Get-LoggedOnUser -ComputerName COMPUTER01

    Returns the logged on user for the remote machine COMPUTER01.

.EXAMPLE
    PS> Get-LoggedOnUser -ComputerName COMPUTER01,COMPUTER02,COMPUTER03

.EXAMPLE
    PS> Out-Content -Path C:\computers.txt | Get-LoggedOnUser
#>

    [CmdletBinding()]

    param (
        [parameter(
            Mandatory=$false,
            ValueFromPipeline=$true,
            ValueFromPipelineByPropertyName=$true,
            Position=0
        )]
        [string[]]
        $ComputerName = $env:ComputerName
    )

    process {
        $Splatting = @{
            ClassName = 'Win32_ComputerSystem'
            ErrorAction = 'Stop'
        }

        foreach ($Computer in $ComputerName) {
            $Name = $Computer.ToUpper()
            if ($Name -ne $env:ComputerName) {
                $Splatting.ComputerName = $Name
            }
            else {
                $Splatting.ComputerName = $null
            }
            

            Write-Verbose -Message ("{0} - Getting logged on user" -f $Name)
            try {
                $CimInstance = Get-CimInstance @Splatting
                $ComputerStatus = 'Online'
            }
            catch {
                Write-Warning -Message ("{0} - Connection to WinRM service failed" -f $Name)
                $ComputerStatus = 'Offline'
            }

            [PSCustomObject]@{
                PSTypeName     = 'LoggedOnUser'
                ComputerName   = $Name
                LoggedOnUser   = $CimInstance.UserName
                ComputerStatus = $ComputerStatus
            }
        }
    }
}
