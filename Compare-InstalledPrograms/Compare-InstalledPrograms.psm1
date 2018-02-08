function Compare-InstalledPrograms {
<#
.SYNOPSIS
    This function 

.DESCRIPTION
    This function 

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
            ValueFromPipelineByPropertyName=$true,
            Position=1)]
        [string]
        $IncludeEqual = $false
    )

    begin {
        $ReferenceObject = Get-ProgramList -ComputerName $ReferenceComputer
        $DifferenceObject = Get-ProgramList -ComputerName $DifferenceComputer
    }

    process {
        $CompareObject = Compare-Object -ReferenceObject $ReferenceObject -DifferenceObject $DifferenceObject
        [PSCustomObject]@{
            PSTypeName    = 'CompareInstalledPrograms'
            Equals        = $CompareObject.Equals
            InputObject   = $CompareObject.InputObject
            SideIndicator = $CompareObject.SideIndicator
        }
    }
}

function Get-ProgramList {
<#
.SYNOPSIS
    This function gets a list of programs on a local or remote machine.

.DESCRIPTION
    This function gets a list of programs on a local or remote machine.

.PARAMETER ComputerName

.EXAMPLE
    Get-ProgramList

.EXAMPLE
    Get-ProgramList -ComputerName COMPUTER01

.EXAMPLE
    Get-ProgramList -ComputerName COMPUTER01,COMPUTER02,COMPUTER03

.EXAMPLE
    Get-Content C:\computers.txt | Get-ProgramList
#>

    param(
        [Parameter(
            Mandatory=$false,
            ValueFromPipeline=$true,
            ValueFromPipelineByPropertyName=$true)]
        [string[]]
        $ComputerName = $env:ComputerName
    )

    begin {
        $Path = "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\*"
        $Splatting = @{
            ArgumentList = $Path
        }
    }

    process {
        foreach ($Computer in $ComputerName) {
            $Name = $Computer.ToUpper()
            if ($Name -ne $env:ComputerName) {
                $Splatting.ComputerName = $Name
            }
            else {
                $Splatting.ComputerName = $null
            }

            Write-Verbose -Message ("PROCESS - {0} - Getting uninstall information..." -f $Name)
            Invoke-Command @Splatting -ScriptBlock {
                foreach ( $_ in (Get-ItemProperty -Path $Path) ) {
                    [PSCustomObject]@{
                        PSTypeName     = 'ProgramList'
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
