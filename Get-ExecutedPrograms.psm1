function Get-MuiCache {
<#
.SYNOPSIS
    This function gets a list of recently executed programs.

.DESCRIPTION
    This function gets a list of recently executed programs.

.EXAMPLE
    PS> Get-MuiCache | Out-File -Path c:\something.csv
#>

    [CmdletBinding()]

    param()
    
    process {
        $RegistryKeyPaths = @(
            "HKCU:\SOFTWARE\Classes\Local Settings\Software\Microsoft\Windows\Shell\MuiCache",
            "HKCU:\SOFTWARE\Microsoft\Windows\ShellNoRoam\MUICache"
        )

        foreach ($RegistryKeyPath in $RegistryKeyPaths) {
            if (Test-Path -Path $RegistryKeyPath) {
                $InputObject = Get-Item -Path $RegistryKeyPath
                $KeyProperties = Select-Object -InputObject $InputObject -ExpandProperty Property
                
                foreach ($KeyProperty in $KeyProperties) {
                    switch -wildcard ($KeyProperty) {
                        "*.FriendlyAppName" { $Split = $KeyProperty -Split(".FriendlyAppName") }
                        "*.ApplicationCompany" { $Split = $KeyProperty -Split(".ApplicationCompany") }
                    }
                    
                    Get-FileProperty -Path ( Get-Item -Path $Split[0] )
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
    This function gets a list of recently executed programs.

.DESCRIPTION
    This function gets a list of recently executed programs.

.EXAMPLE
    PS> Get-CompatibilityAssistant | Out-File -Path c:\something.csv
#>

    [CmdletBinding()]

    param()

    process {
        $RegistryKeyPaths = @(
            "HKCU:\Software\Microsoft\Windows NT\CurrentVersion\AppCompatFlags\Compatibility Assistant\Persisted",
            "HKCU:\Software\Microsoft\Windows NT\CurrentVersion\AppCompatFlags\Compatibility Assistant\Store"
        )

        foreach ($RegistryKeyPath in $RegistryKeyPaths) {
            if (Test-Path -Path $RegistryKeyPath) {
                $InputObject = Get-Item -Path $RegistryKeyPath
                $KeyProperties = Select-Object -InputObject $InputObject -ExpandProperty Property
                
                foreach ($KeyProperty in $KeyProperties) {
                    if (Test-Path -Path $KeyProperty) {
                        Get-FileProperty -Path (Get-Item -Path $KeyProperty)
                    }
                }
            }
            else {
                Write-Warning -Message ("{0} path does not exist" -f $RegistryKeyPath)
            }
        }
    }
}

function Get-FileProperty  {
<#
.SYNOPSIS
    This function returns certain file properties.

.DESCRIPTION
    This function returns certain file properties.

.EXAMPLE
    Get-FileProperty -Path c:\windows\system32\calc.exe
#>

    [CmdletBinding()]

    param(
        [parameter(Mandatory=$true)]
        [string]$Path
    )

    $_ = Get-Item -Path $Path
    
    $Property = [ordered]@{
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
    New-Object -TypeName PSObject -Property $Property
}
