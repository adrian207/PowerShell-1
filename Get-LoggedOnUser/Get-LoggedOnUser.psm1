function Get-LoggedOnUser {
<#
.SYNOPSIS
    Gets the logged on users for a local or remote machine.

.DESCRIPTION
    The Get-LoggedOnUser cmdlet gets the logged on users for a local or remote machine.

.EXAMPLE
    PS C:\> Get-LoggedOnUser

    Returns the logged on users for the local machine.

.EXAMPLE
    PS C:\> Get-LoggedOnUser -ComputerName COMPUTER01

    Returns the logged on users for the remote machine COMPUTER01.

.EXAMPLE
    PS C:\> Get-LoggedOnUser -ComputerName COMPUTER01,COMPUTER02,COMPUTER03

    Returns the logged on users for the remote machines COMPUTER01, COMPUTER02, and COMPUTER03.

.EXAMPLE
    PS C:\> Out-Content -Path C:\computers.txt | Get-LoggedOnUser
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
            ClassName = 'Win32_LoggedOnUser'
            ErrorAction = 'Continue'
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
                LoggedOnUser   = $CimInstance.Antecedent.Name | Select-Object -Unique
                ComputerStatus = $ComputerStatus
            }
        }
    }
}

function Invoke-LogOffUser {
<#
.SYNOPSIS
    Logs off users on a local or remote machine.

.DESCRIPTION
    The Get-LoggedOnUser logs off users on a local or remote machine.

.EXAMPLE
    PS C:\> Invoke-LogOffUser -ComputerName COMPUTER01

    Logs off users on the remote machine COMPUTER01.

.EXAMPLE
    PS C:\> Invoke-LogOffUser -ComputerName COMPUTER01,COMPUTER02,COMPUTER03

    Logs off users on the remote machines COMPUTER01, COMPUTER02, and COMPUTER03.

.EXAMPLE
    PS C:\> Out-Content -Path C:\computers.txt | Invoke-LogOffUser
#>

    [CmdletBinding()]

    param (
        [parameter(
            Mandatory=$false,
            ValueFromPipelineByPropertyName=$true,
            Position=1
        )]
        [string[]]
        $ComputerName = $env:ComputerName
    )

    process {
        $Splatting = @{
            ClassName  = 'Win32_OperatingSystem'
            MethodName = 'Win32Shutdown'
            Arguments  = @{ Flags = 4 }
            Confirm    = $true
        }

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
