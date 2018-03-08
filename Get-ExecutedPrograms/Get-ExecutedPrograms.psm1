function Get-MuiCache {
<#
.SYNOPSIS
    This function gets a list of recently executed programs from the MUI cache.

.DESCRIPTION
    This function gets a list of recently executed programs from the MUI cache.

.EXAMPLE
    PS> Get-MuiCache | Out-File -Path c:\something.csv
#>

    [CmdletBinding()]

    param()
    
    process {
        $RegistryKeyPaths = @(
            'HKCU:\SOFTWARE\Classes\Local Settings\Software\Microsoft\Windows\Shell\MuiCache',
            'HKCU:\SOFTWARE\Microsoft\Windows\ShellNoRoam\MUICache'
        )

        foreach ($RegistryKeyPath in $RegistryKeyPaths) {
            if (Test-Path -Path $RegistryKeyPath) {
                $InputObject = Get-Item -Path $RegistryKeyPath
                $KeyProperties = Select-Object -InputObject $InputObject -ExpandProperty Property
                
                foreach ($KeyProperty in $KeyProperties) {
                    switch -wildcard ($KeyProperty) {
                        '*.FriendlyAppName' { $Split = $KeyProperty -Split('.FriendlyAppName') }
                        '*.ApplicationCompany' { $Split = $KeyProperty -Split('.ApplicationCompany') }
                    }
                    
                    Get-FileInformation -Path ( Get-Item -Path $Split[0] )
                }
            }
            else {
                Write-Warning -Message ("PROCESS - {0} path does not exist" -f $RegistryKeyPath)
            }
        }
    }
}

function Get-CompatibilityAssistant {
<#
.SYNOPSIS
    This function gets a list of recently executed programs from the Compatibility Assistant.

.DESCRIPTION
    This function gets a list of recently executed programs from the Compatibility Assistant.

.EXAMPLE
    PS> Get-CompatibilityAssistant

.EXAMPLE
    PS> Get-CompatibilityAssistant | Out-File -Path c:\something.csv
#>

    [CmdletBinding()]

    param()

    process {
        $RegistryKeyPaths = @(
            'HKCU:\Software\Microsoft\Windows NT\CurrentVersion\AppCompatFlags\Compatibility Assistant\Persisted',
            'HKCU:\Software\Microsoft\Windows NT\CurrentVersion\AppCompatFlags\Compatibility Assistant\Store'
        )

        foreach ($RegistryKeyPath in $RegistryKeyPaths) {
            if (Test-Path -Path $RegistryKeyPath) {
                $InputObject = Get-Item -Path $RegistryKeyPath
                $KeyProperties = Select-Object -InputObject $InputObject -ExpandProperty Property
                
                foreach ($KeyProperty in $KeyProperties) {
                    Get-FileInformation -Path (Get-Item -Path $KeyProperty)
                }
            }
            else {
                Write-Warning -Message ("PROCESS - {0} path does not exist" -f $RegistryKeyPath)
            }
        }
    }
}

function Get-FileInformation {
<#
.SYNOPSIS
    This function returns file properties.

.DESCRIPTION
    This function returns file properties.

.EXAMPLE
    Get-FileInformation -Path c:\windows\system32\calc.exe
#>

    [CmdletBinding()]

    param(
        [parameter(
            Mandatory=$true,
            ValueFromPipeline=$true,
            ValueFromPipelineByPropertyName=$true)]
        [string]
        $Path
    )

    $_ = Get-Item -Path $Path
    
    [PSCustomObject]@{
        TypeName          = 'FileInformation'
        FullName          = $_.FullName
        LastWriteTime     = $_.LastWriteTime
        CreationTime      = $_.CreationTime
        FileSize          = "{0:N0}" -f $_.Length
        Attributes        = $_.Attributes
        ProductName       = $_.VersionInfo.ProductName
        ProductVersion    = $_.VersionInfo.ProductVersion
        FileDescription   = $_.VersionInfo.FileDescription
        FileVersion       = $_.VersionInfo.FileVersion
        CompanyName       = $_.VersionInfo.CompanyName
        LastAccessTime    = $_.LastAccessTime
    }
}
