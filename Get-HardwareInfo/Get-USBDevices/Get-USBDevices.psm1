function Get-USBDevices {
<#
.SYNOPSIS
    Gets a list of USB devices from a local or remote machine.

.DESCRIPTION
    The Get-USBDevices cmdlet gets a list of USB devices from a local or remote machine.

.EXAMPLE
    PS C:\> Get-USBDevices

    This command gets a list of USB devices from the local machine.

.EXAMPLE
    PS C:\> Get-USBDevices -ComputerName COMPUTER01

    This command gets a list of USB devices from the remote machine COMPUTER01.

.EXAMPLE
    PS C:\> Get-USBDevices -ComputerName COMPUTER01,COMPUTER02,COMPUTER03

    This command gets a list of USB devices from the remote machines COMPUTER01, COMPUTER2, and COMPUTER3.

.EXAMPLE
    PS C:\> Get-Content -Path C:\something.txt | Get-USBDevices

    This command gets a list of USB devices from the remote machines in the text file.
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
            Class = 'Win32_USBControllerDevice'
        }

        foreach ($Computer in $ComputerName) {
            $Name = $Computer.ToUpper()
            if ($Name -ne $env:ComputerName) {
                $Splatting.ComputerName = $Name
            }
            else {
                $Splatting.Remove('ComputerName')
            }

            $Devices = Get-WmiObject @Splatting | ForEach-Object { [wmi]$_.Dependent }
            foreach ( $_ in $Devices ) {
                [PSCustomObject]@{
                    PSTypeName   = 'USBDevice'
                    ComputerName = $Name
                    Name         = $_.Name
                    Description  = $_.Description
                    Manufacturer = $_.Manufacturer
                    Service      = $_.Service
                    DeviceID     = $_.DeviceID
                }
            }
        }
    }
}
