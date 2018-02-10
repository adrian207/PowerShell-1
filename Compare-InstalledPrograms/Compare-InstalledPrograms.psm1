function Compare-InstalledPrograms {
<#
.SYNOPSIS
    This function compares a list of installed programs on two computers.

.DESCRIPTION
    This function compares a list of installed programs on two computers.

.EXAMPLE
    Compare-InstalledPrograms -ReferenceComputer COMPUTER01 -DifferenceComputer COMPUTER02
#>
    
    [CmdletBinding()]

    param(
        [parameter(
            Mandatory=$true,
            ValueFromPipeline=$true,
            ValueFromPipelineByPropertyName=$true,
            Position=0)]
        [string]
        $ReferenceComputer,

        [parameter(
            Mandatory=$true,
            ValueFromPipeline=$true,
            ValueFromPipelineByPropertyName=$true,
            Position=1)]
        [string]
        $DifferenceComputer,

        [parameter(
            Mandatory=$false,
            ValueFromPipeline=$true,
            ValueFromPipelineByPropertyName=$true)]
        [string]
        $IncludeEqual = $false
    )

    begin {
        $ReferenceObject = Get-InstalledPrograms -ComputerName $ReferenceComputer
        $DifferenceObject = Get-InstalledPrograms -ComputerName $DifferenceComputer
    }

    process {
        $CompareObject = Compare-Object -ReferenceObject $ReferenceObject -DifferenceObject $DifferenceObject
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
    This function gets a list of programs on a local or remote machine.

.DESCRIPTION
    This function gets a list of programs on a local or remote machine.

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

    param(
        [parameter(
            Mandatory=$false,
            ValueFromPipeline=$true,
            ValueFromPipelineByPropertyName=$true)]
        [string[]]
        $ComputerName = $env:ComputerName
    )

    begin {
        $Splatting = @{
            ArgumentList = 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\*'
        }
    }

    process {
        foreach ($Computer in $ComputerName) {
            $Name = $Computer.ToUpper()
            if ($Name -ne $env:ComputerName) {
                $Splatting.ComputerName = $Name
            }
            else {
                $Splatting.PSObject.Properties.Remove('ComputerName')
            }
            
            Write-Verbose -Message ("PROCESS - {0} - Getting uninstall information..." -f $Name)
            Invoke-Command @Splatting -ScriptBlock {
                foreach ( $_ in (Get-ItemProperty -Path $args[0]) ) {
                    [PSCustomObject]@{
                        PSTypeName     = 'InstalledPrograms'
                        DisplayName    = $_.DisplayName
                        Publisher      = $_.Publisher
                        DisplayVersion = $_.DisplayVersion
                        InstallDate    = $_.InstallDate
                    }
                }
            }
        }
    }
}
