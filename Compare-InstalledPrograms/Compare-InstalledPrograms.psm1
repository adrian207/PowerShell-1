function Compare-InstalledPrograms {
<#
.SYNOPSIS
    Compares a list of installed programs on two computers.

.DESCRIPTION
    The Compare-InstalledPrograms cmdlet compares a list of installed programs on two computers.

.EXAMPLE
    PS C:\> Compare-InstalledPrograms -ReferenceComputer COMPUTER01 -DifferenceComputer COMPUTER02
#>

    [CmdletBinding()]

    param(
        [parameter(
            Mandatory=$true,
            ValueFromPipelineByPropertyName=$true,
            Position=0)]
        [string]
        $ReferenceComputer,

        [parameter(
            Mandatory=$true,
            ValueFromPipelineByPropertyName=$true,
            Position=1)]
        [string]
        $DifferenceComputer,

        [parameter(
            Mandatory=$false,
            ValueFromRemainingArguments=$true)]
        [string]
        $Splatting
    )

    process {
        $Splatting = @{
            ReferenceObject = Get-InstalledPrograms -ComputerName $ReferenceComputer
            DifferenceObject = Get-InstalledPrograms -ComputerName $DifferenceComputer
        }

        $CompareObject = Compare-Object @Splatting
        [PSCustomObject]@{
            PSTypeName    = 'CompareInstalledPrograms'
            InputObject   = $CompareObject.InputObject
            SideIndicator = $CompareObject.SideIndicator
        }
    }
}

function Get-InstalledPrograms {
<#
.SYNOPSIS
    Gets a list of programs on a local or remote machine.

.DESCRIPTION
    The Get-InstalledPrograms cmdlet gets a list of programs on a local or remote machine.

.PARAMETER ComputerName

.EXAMPLE
    Get-InstalledPrograms

.EXAMPLE
    Get-InstalledPrograms -ComputerName COMPUTER01

.EXAMPLE
    Get-InstalledPrograms -ComputerName COMPUTER01,COMPUTER02,COMPUTER03

.EXAMPLE
    Get-Content C:\computers.txt | Get-InstalledPrograms
#>

    [CmdletBinding()]

    param (
        [parameter(
            Mandatory=$false,
            ValueFromPipeline=$true,
            ValueFromPipelineByPropertyName=$true)]
        [string[]]
        $ComputerName = $env:ComputerName
    )

    process {
        $Splatting = @{
            ArgumentList = 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\*'
        }

        foreach ($Computer in $ComputerName) {
            $Name = $Computer.ToUpper()
            if ($Name -ne $env:ComputerName) {
                $Splatting.ComputerName = $Name
            }
            else {
                $Splatting.PSObject.Properties.Remove('ComputerName')
            }
            
            Write-Verbose -Message ("{0} - Getting uninstall information..." -f $Name)
            Invoke-Command @Splatting -ScriptBlock {
                param ($ArgumentList)
                foreach ( $_ in (Get-ItemProperty -Path $ArgumentList) ) {
                    if ($_.InstallDate) {
                        $InstallDate = [datetime]::ParseExact($_.InstallDate, 'yyyyMMdd', $null)
                    }
                    else {
                        $InstallDate = $null
                    }

                    [PSCustomObject]@{
                        PSTypeName     = 'InstalledPrograms'
                        ComputerName   = $Name
                        DisplayName    = $_.DisplayName
                        Publisher      = $_.Publisher
                        DisplayVersion = $_.DisplayVersion
                        InstallDate    = $InstallDate
                    }
                }
            }
        }
    }
}
