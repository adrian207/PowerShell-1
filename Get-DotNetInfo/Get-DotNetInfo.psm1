function Get-DotNetInfo {
<#
.SYNOPSIS
    Gets the version of .NET Framework

.DESCRIPTION
    The Get-DotNetInfo cmdlet

.EXAMPLE
    Get-DotNetInfo

.EXAMPLE
    Get-DotNetInfo -ComputerName COMPUTER01

.EXAMPLE
    Get-DotNetInfo -ComputerName COMPUTER01,COMPUTER02,COMPUTER03

.NOTES
    https://docs.microsoft.com/en-us/dotnet/framework/migration-guide/how-to-determine-which-versions-are-installed
#>


    process {
        # Get Windows kernel version and build number
        $MajorVer = [System.Environment]::OSVersion.Version.Major
        $MinorVer = [System.Environment]::OSVersion.Version.Minor
        $WindowsBuild = [System.Environment]::OSVersion.Version.Build
        [decimal]$WindowsVersion = "{0}.{1}" -f $MajorVer,$MinorVer

        $45RegPath = 'HKLM:\SOFTWARE\Microsoft\NET Framework Setup\NDP\v4\Full'

        switch ($WindowsVersion) {
            10.0 { $WindowsRelease = 'Windows 10'; break }
            6.3 { $WindowsRelease = 'Windows 8.1'; break }
            6.2 { $WindowsRelease = 'Windows 8'; break }
            6.1 { $WindowsRelease = 'Windows 7'; break }
            6.0 { $WindowsRelease = 'Windows Vista'; break }
            Default { $WindowsRelease = 'Unknown' }
        }

        $Release = (Get-ItemProperty -Path $45RegPath -Name 'Release').Release
        switch ($x) {
            378389 { $Version = '4.5' }
            379893 { $Version = '4.5.2' }
            Default { $Version = 'Unknown' }
        }

        if (Test-Path -Path $45RegPath) {
            switch ($Release) {
                {($Release -eq 378675) -and ($WindowsVersion -eq 6.3)} { $Version = '4.5.1'; break }
                {($Release -eq 378758) -and ($WindowsVersion -le 6.1)} { $Version = '4.5.1'; break }
                {($Release -eq 393295) -and ($WindowsVersion -le 10.0)} { $Version = '4.6'; break }
                {($Release -eq 393297) -and ($WindowsVersion -lt 10.0)} { $Version = '4.6'; break }
                {($Release -eq 394254) -and ($WindowsVersion -ge 10.0)} { $Version = '4.6.1'; break }
                {($Release -eq 394271) -and ($WindowsVersion -lt 10.0)} { $Version = '4.6.1'; break }
                {($Release -eq 394802) -and ($WindowsVersion -ge 10.0)} { $Version = '4.6.2'; break }
                {($Release -eq 394806) -and ($WindowsVersion -lt 10.0)} { $Version = '4.6.2'; break }
                {($Release -eq 460798) -and ($WindowsBuild -ge 15063)} { $Version = '4.7'; break }
                {($Release -eq 460805) -and ($WindowsBuild -lt 15063)} { $Version = '4.7'; break }
                {($Release -eq 461308) -and ($WindowsBuild -ge 16299)} { $Version = '4.7.1'; break }
                {($Release -eq 461310) -and ($WindowsBuild -lt 16299)} { $Version = '4.7.1'; break }
                Default { $Release = "$45RegPath does not exist"; $Version = "$45RegPath does not exist" }
            }
        }

        [PSCustomObject]@{
            ComputerName   = $env:ComputerName
            '.NET Version' = $Version
            WindowsVersion = $WindowsRelease
            WindowsBuild   = $WindowsBuild
        }
    }
}
