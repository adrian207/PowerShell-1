#requires -version 5
function Get-DisplayInformation {
<#
.SYNOPSIS
	This function gets the display information from a local or remote machine.

.DESCRIPTION
	This function gets the display information from a local or remote machine.

.EXAMPLE
	Get-DisplayInformation

.EXAMPLE
	Get-DisplayInformation -ComputerName COMPUTER01

.EXAMPLE
    Get-DisplayInformation -ComputerName COMPUTER01,COMPUTER02,COMPUTER03

.EXAMPLE
    Get-Content -Path c:\something.txt | Get-DisplayInformation
#>

    [CmdletBinding()]

    param(
        [Parameter(
            Mandatory=$false,
            ValueFromPipeline=$true,
            ValueFromPipelineByPropertyName=$true)]
        [string[]]
        $ComputerName = $env:ComputerName
    )

    begin {
        $Splatting = @{
            ClassName = 'WmiMonitorId'
            Namespace = 'root\wmi'
        }
    }

    process {
        foreach ($Computer in $ComputerName) {
            $Name = $Computer.ToUpper()
            Write-Verbose -Message ( "PROCESS - {0} - Getting display information" -f $Name )

            if ($Name -ne $env:ComputerName) {
                $Splatting.ComputerName = $Name
            }
            else {
                $Splatting.ComputerName = $null
            }

            foreach ( $_ in (Get-CimInstance @Splatting) ) {
                [PSCustomObject]@{
                    ComputerName = $Name
                    Name = ($_.UserFriendlyName -notmatch '^0$' | ForEach {[char]$_}) -join ""
                    Manufacturer = ($_.ManufacturerName -notmatch '^0$' | ForEach {[char]$_}) -join ""
                    Serial = ($_.SerialNumberID -notmatch '^0$' | ForEach {[char]$_}) -join ""
                }
            }
        }
    }
}

function Get-VideoCard {
<#
.SYNOPSIS
    This function gets a list of video cards from a local or remote machine.

.DESCRIPTION
    This function gets a list of video cards from a local or remote machine.

.EXAMPLE
    Get-DisplayInformation

.EXAMPLE
    Get-DisplayInformation -ComputerName COMPUTER01

.EXAMPLE
    Get-DisplayInformation -ComputerName COMPUTER01,COMPUTER02,COMPUTER03

.EXAMPLE
    Out-Content -Path c:\something.txt | Get-DisplayInformation
#>

    [CmdletBinding()]

    param(
        [parameter(
            Mandatory=$false,
            ValueFromPipeline=$true,
            ValueFromPipelineByPropertyName=$true,
            Position=0)]
        [string[]]
        $ComputerName = $env:ComputerName
    )

    begin {
        $Splatting = @{
            ClassName = 'Win32_VideoController'
        }
    }

    process {
        foreach ($Computer in $ComputerName) {
            $Name = $Computer.ToUpper()
            Write-Verbose -Message ( "PROCESS - {0} - Getting video card information" -f $Name )

            if ($Name -ne $env:ComputerName) {
                $Splatting.ComputerName = $Name
            }
            else {
                $Splatting.ComputerName = $null
            }

            foreach ( $_ in (Get-CimInstance @Splatting) ) {
                switch ($_.Availability) {
                    1 { $Availability = 'Other' }
                    3 { $Availability = 'Running/Full Power' }
                    4 { $Availability = 'Warning ' }
                    5 { $Availability = 'In Test' }
                    6 { $Availability = 'Not Applicable' }
                    7 { $Availability = 'Power Off' }
                    8 { $Availability = 'Offline' }
                    9 { $Availability = 'Off Duty' }
                    10 { $Availability = 'Degraded ' }
                    11 { $Availability = 'Not Installed' }
                    12 { $Availability = 'Install Error' }
                    13 { $Availability = 'Power Save - Unknown' }
                    14 { $Availability = 'Power Save - Low Power Mode' }
                    15 { $Availability = 'Power Save - Standby' }
                    16 { $Availability = 'Power Cycle' }
                    17 { $Availability = 'Power Save - Warning' }
                    18 { $Availability = 'Paused ' }
                    19 { $Availability = 'Not Ready' }
                    20 { $Availability = 'Not Configured' }
                    21 { $Availability = 'Quiesced' }
                    Default { $Availability = 'Unknown' }
                }

                [PSCustomObject]@{
                    PSTypeName              = 'PSVideoController'
                    ComputerName            = $Name
                    Caption                 = $_.Caption
                    Status                  = $_.Status
                    Availability            = $Availability
                    Driver                  = $_.DriverVersion
                    DriverDate              = $_.DriverDate
                    HorizontalResolution    = $_.CurrentHorizontalResolution
                    VerticalResolution      = $_.CurrentVerticalResolution
                    CurrentBitsPerPixel     = $_.CurrentBitsPerPixel
                    'RAM Type'              = $_.VideoMemoryType
                    'Amount of RAM'         = $_.AdapterRAM
                    InstalledDisplayDrivers = ($_.InstalledDisplayDrivers).Split(',')
                }
            }
        }
    }
}
