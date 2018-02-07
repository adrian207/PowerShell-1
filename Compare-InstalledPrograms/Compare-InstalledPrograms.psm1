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
            Mandatory=$true,
            ValueFromPipeline=$true,
            ValueFromPipelineByPropertyName=$true,
            Position=1)]
        [string]
        $IncludeEqual
    )

    process {
        $ReferenceObject = Get-ProgramList -ComputerName $ReferenceComputer
        $DifferenceObject = Get-ProgramList -ComputerName $DifferenceComputer

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
        $Splatting = @{
            ClassName = 'Win32_Product'
            Property  = 'InstallDate'
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
            
            Write-Verbose -Message ("PROCESS - {0} - Getting product information" -f $Name)
            foreach ( $_ in (Get-CimInstance @Splatting) ) {
                [PSCustomObject]@{
                    PSTypeName  = 'MyType'
                    Name        = $_.Name
                    Vendor      = $_.Vendor
                    Version     = $_.Version
                    InstallDate = $_.InstallDate
                }
            }
        }
    }
}
