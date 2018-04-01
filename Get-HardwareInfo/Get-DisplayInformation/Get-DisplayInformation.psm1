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
        [Alias('IPAddress','__Server','CN')]
        [string[]]
        $ComputerName = $env:ComputerName
    )

    process {
        $Splatting = @{
            ClassName = 'WmiMonitorId'
            Namespace = 'root\wmi'
        }

        foreach ($Computer in $ComputerName) {
            $Name = $Computer.ToUpper()
            if ($Name -ne $env:ComputerName) {
                $Splatting.ComputerName = $Name
            }
            else {
                $Splatting.ComputerName = $null
            }

            Write-Verbose -Message ( "{0} - Getting display information" -f $Name )
            foreach ( $_ in (Get-CimInstance @Splatting) ) {
                switch ( (($_.ManufacturerName -notmatch '^0$' | ForEach {[char]$_}) -join '') ) {
                    # https://community.spiceworks.com/how_to/148349-get-desktop-monitor-information-powershell-script
                    'AAC' { $ManufacturerName = 'AcerView' }
                    {($_ -eq 'ACR') -or ($_ -eq 'CMO')} { $ManufacturerName = 'Acer' }
                    {($_ -eq 'ACI') -or ($_ -eq 'AUO')} { $ManufacturerName = 'Asus' }
                    'APP' { $ManufacturerName = 'Apple Computer' }
                    'CPQ' { $ManufacturerName = 'Compaq' }
                    'DEL' { $ManufacturerName = 'Dell' }
                    'HWP' { $ManufacturerName = 'HP' }
                    'LEN' { $ManufacturerName = 'Lenovo' }
                    {($_ -eq 'SAN') -or ($_ -eq 'SAM')} { $ManufacturerName = 'Samsung' }
                    'SNY' { $ManufacturerName = 'Sony' }
                    'SRC' { $ManufacturerName = 'Shamrock' }
                    'SUN' { $ManufacturerName = 'Sun Microsystems' }
                    'SEC' { $ManufacturerName = 'Hewlett-Packard' }
                    'TAT' { $ManufacturerName = 'Tatung' }
                    {($_ -eq 'TOS') -or ($_ -eq 'TSB')} { $ManufacturerName = 'Toshiba' }
                    'VSC' { $ManufacturerName = 'ViewSonic' }
                    '_YV' { $ManufacturerName = 'Fujitsu' }
                    Default { $ManufacturerName = 'Unknown' }
                }

                [PSCustomObject]@{
                    PSTypeName        = 'DisplayInformation'
                    ComputerName      = $Name
                    InstanceName      = $_.InstanceName
                    UserFriendlyName  = ($_.UserFriendlyName -notmatch '^0$' | ForEach {[char]$_}) -join ''
                    ManufacturerName  = $ManufacturerName
                    ProductCodeID     = ($_.ProductCodeID -notmatch '^0$' | ForEach {[char]$_}) -join ''
                    SerialNumberID    = ($_.SerialNumberID -notmatch '^0$' | ForEach {[char]$_}) -join ''
                    WeekOfManufacture = $_.WeekOfManufacture
                    YearOfManufacture = $_.YearOfManufacture
                    OutputType        = Get-MonitorConnection -InstanceName $_.InstanceName
                }
            }
        }
    }
}

function Get-MonitorConnection {
    param(
        [string]
        $ComputerName,

        [string]
        $InstanceName
    )

    process {
        $Splatting = @{
            ClassName = 'WmiMonitorConnectionParams'
            Namespace = 'root\wmi'
        }
        if ($Computer -ne $env:ComputerName) {
            $Splatting.ComputerName = $Computer
        }

        foreach ($_ in Get-CimInstance @Splatting) {
            if ($InstanceName -eq $_.InstanceName) {
                # https://docs.microsoft.com/en-us/windows-hardware/drivers/ddi/content/d3dkmdt/ne-d3dkmdt-_d3dkmdt_video_output_technology
                switch ($_.VideoOutputTechnology) {
                    -2 { $OutputType = 'Uninitialized' }
                    0 { $OutputType = 'VGA' }
                    1 { $OutputType = 'S-Video' }
                    2 { $OutputType = 'Composite Video' }
                    3 { $OutputType = 'Component Video' }
                    4 { $OutputType = 'DVI' }
                    5 { $OutputType = 'HDMI' }
                    6 { $OutputType = 'LVDS' }
                    # 8 { $OutputType = 'D_JPN' }
                    9 { $OutputType = 'SDI' }
                    10 { $OutputType = 'DisplayPort External' }
                    11 { $OutputType = 'DisplayPort' }
                    Default { $OutputType = 'Other' }
                }
                $OutputType
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
    Get-VideoCard

.EXAMPLE
    Get-VideoCard -ComputerName COMPUTER01

.EXAMPLE
    Get-VideoCard -ComputerName COMPUTER01,COMPUTER02,COMPUTER03

.EXAMPLE
    Out-Content -Path c:\something.txt |Get-VideoCard
#>

    [CmdletBinding()]

    param(
        [parameter(
            Mandatory=$false,
            ValueFromPipeline=$true,
            ValueFromPipelineByPropertyName=$true,
            Position=0)]
        [Alias('IPAddress','__Server','CN')]
        [string[]]
        $ComputerName = $env:ComputerName
    )

    process {
        foreach ($Computer in $ComputerName) {
            $Splatting = @{
                ClassName = 'CIM_VideoController'
                ComputerName = $null
            }

            $Name = $Computer.ToUpper()
            Write-Verbose -Message ( "{0} - Getting video card information" -f $Name )
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
                    10 { $Availability = 'Degraded' }
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

                switch ($_.VideoMemoryType) {
                    1 { $VideoMemoryType = 'Other' }
                    3 { $VideoMemoryType = 'VRAM' }
                    4 { $VideoMemoryType = 'DRAM' }
                    5 { $VideoMemoryType = 'SRAM' }
                    6 { $VideoMemoryType = 'WRAM' }
                    7 { $VideoMemoryType = 'EDO RAM' }
                    8 { $VideoMemoryType = 'Burst Synchronous DRAM' }
                    9 { $VideoMemoryType = 'Pipelined Burst SRAM' }
                    10 { $VideoMemoryType = 'CDRAM' }
                    11 { $VideoMemoryType = '3DRAM' }
                    12 { $VideoMemoryType = 'SDRAM' }
                    13 { $VideoMemoryType = 'SGRAM' }
                    Default { $VideoMemoryType = 'Unknown' }
                }

                [PSCustomObject]@{
                    PSTypeName              = 'PSVideoController'
                    ComputerName            = $Name
                    Caption                 = $_.Caption
                    Status                  = $_.Status
                    Availability            = $Availability
                    DriverVersion           = $_.DriverVersion
                    DriverDate              = $_.DriverDate
                    HorizontalResolution    = $_.CurrentHorizontalResolution
                    VerticalResolution      = $_.CurrentVerticalResolution
                    CurrentBitsPerPixel     = $_.CurrentBitsPerPixel
                    VideoMemoryType         = $VideoMemoryType
                    AdapterRAM              = $_.AdapterRAM
                    InstalledDisplayDrivers = ($_.InstalledDisplayDrivers).Split(',')
                }
            }
        }
    }
}
