function Get-DiskInfo {
<#
.SYNOPSIS
    This function gets the amount of free disk space on a local or remote machine.

.DESCRIPTION
    This function gets the amount of free disk space on a local or remote machine.

.PARAMETER ComputerName

.EXAMPLE
     Get-DiskInfo

.EXAMPLE
     Get-DiskInfo -ComputerName SERVER01

.EXAMPLE
     Get-DiskInfo -ComputerName SERVER01,SERVER02,SERVER03

.EXAMPLE
    Get-Content C:\computers.txt |  Get-DiskInfo
#>

    [CmdletBinding()]

    param(
        [parameter(
			Mandatory=$false,
			ValueFromPipeline=$true,
			ValueFromPipelineByPropertyName=$true,
			Position=0)]
        [String[]]
        $ComputerName = $env:ComputerName
    )

    process {
        $Splatting = @{
            ClassName = 'Win32_LogicalDisk'
            Filter    = "drivetype='3'"
        }

        foreach ($Computer in $ComputerName) {
            $Name = $Computer.ToUpper()
            Write-Verbose -Message ( "{0} - Getting disk space information" -f $Name )

            if ($Computer -ne $env:ComputerName) {
                $Splatting.ComputerName = $Name
            }
            else {
				$Splatting.PSObject.Properties.Remove('ComputerName')
            }

            foreach ( $_ in (Get-CimInstance @Splatting) ) {
                [PSCustomObject]@{
                    ComputerName = $Name
                    Drive        = $_.DeviceID
                    Size         = Convert-BytesToSize -Size $_.Size
                    FreeSpace    = Convert-BytesToSize -Size $_.FreeSpace
                }
            }
        }
    }
}

function Convert-BytesToSize {
<#
.SYNOPSIS
    Converts any integer size given to a user friendly size.

.DESCRIPTION
    The Convert-BytesToSize function converts any integer size given to a user friendly size.

.PARAMETER Size

.EXAMPLE
    PS C:\> Convert-BytesToSize -Size 134217728

    128MB

.EXAMPLE
    PS C:\> Convert-BytesToSize -Size 134217728 -Precision 3

    128MB
#>

    param(
        [parameter(
            Mandatory=$true,
            ValueFromPipelineByPropertyName=$true,
            Position = 0)]
        [int64]
        $Size,

        [parameter(
            Mandatory=$false,
            ValueFromPipelineByPropertyName=$true,
            Position = 1)]
        [int]
        $Precision = 2
    )

    switch ($Size) {
        {$Size -gt 1PB} { "$([math]::Round(($Size / 1PB),$Precision))PB"; break }
        {$Size -gt 1TB} { "$([math]::Round(($Size / 1TB),$Precision))TB"; break }
        {$Size -gt 1GB} { "$([math]::Round(($Size / 1GB),$Precision))GB"; break }
        {$Size -gt 1MB} { "$([math]::Round(($Size / 1MB),$Precision))MB"; break }
        {$Size -gt 1KB} { "$([math]::Round(($Size / 1KB),$Precision))KB"; break }
        Default { "$([math]::Round($Size,$Precision))Bytes" }
    }
}
