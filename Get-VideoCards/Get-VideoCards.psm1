#requires -version 3

function Get-VideoCards {
<#
.SYNOPSIS
	This function gets a list of video cards from a local or remote machine.

.DESCRIPTION
	This function gets a list of video cards from a local or remote machine.

.EXAMPLE
	Get-DisplayInformation -ComputerName COMPUTER01

.EXAMPLE
    Get-DisplayInformation -ComputerName COMPUTER01,COMPUTER02,COMPUTER03
#>

    [CmdletBinding()]

    Param(
        [parameter(ValueFromPipeline=$True)]
        [String[]]$ComputerName = $env:ComputerName
    )

    Process {
        ForEach ($Computer in $ComputerName) {
            Try {
                $Name = $Computer.ToUpper()
                Write-Verbose -Message ( "PROCESS - {0} - Getting video card information" -f $Name )

                $CimSession = New-CimSession -ComputerName $Name

                # Get video card information
                $VideoCardSplatting = @{
		            ClassName = "win32_VideoController"
                    CimSession = $CimSession
                }
                $VideoCards = Get-CimInstance @VideoCardSplatting
                Write-Host $Name
                ForEach ($Card in $VideoCards) {
                    [pscustomobject]@{
                        Name = $Card.Caption
                        Driver = $Card.DriverVersion
                        HorizontalResolution = $Card.CurrentHorizontalResolution
                        VerticalResolution = $Card.CurrentVerticalResolution
                    }
                }
            }
            Catch {
                Write-Warning -Message ( "PROCESS - {0} - Something bad happened" -f $Name )
				Write-Warning -Message $Error[0].Exception.Message
            }
        }
    }
}
