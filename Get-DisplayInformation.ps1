#requires -version 3

function Get-DisplayInformation {
<#
.SYNOPSIS
	This function gets a list of names for all computers in Active Directory.

.DESCRIPTION
	This function gets a list of names for all computers in Active Directory.

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
                Write-Verbose -Message ( "PROCESS - {0} - Getting display information" -f $Name )
                
                $Splatting = @{
                    #CimSession = New-CimSession -ComputerName $Name
                }
                # Get video card information
                $VideoCards = Get-CimInstance -ClassName win32_VideoController
                ForEach ($Card in $VideoCards) {
                    $Info = [ordered]@{
                        Name = $Card.Caption
                        Driver = $Card.DriverVersion
                        HorizontalResolution = $Card.CurrentHorizontalResolution
                        VerticalResolution = $Card.CurrentVerticalResolution
                    }
                    New-Object -TypeName PSObject -Property $Info
                }

                # Get monitor information
                $Monitors = Get-CimInstance -ClassName WmiMonitorId -Namespace "root\wmi"
                ForEach ($Monitor in $Monitors) {
                    New-Object -TypeName PSObject -Property @{
                        Manufacturer = ($Monitor.ManufacturerName -notmatch '^0$' | ForEach {[char]$_}) -join ""
                        Name = ($Monitor.UserFriendlyName -notmatch '^0$' | ForEach {[char]$_}) -join ""
                        Serial = ($Monitor.SerialNumberID -notmatch '^0$' | ForEach {[char]$_}) -join ""
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

function Get-ScreenShot {
<#
.SYNOPSIS
	This function gets a list of names for all computers in Active Directory.

.DESCRIPTION
	This function gets a list of names for all computers in Active Directory.

.EXAMPLE
	Get-ScreenShot -ComputerName COMPUTER01

.EXAMPLE
    Get-ScreenShot -ComputerName COMPUTER01,COMPUTER02,COMPUTER03
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
                Write-Verbose -Message ( "PROCESS - {0} - Getting display information" -f $Name )


            }
            Catch {
                Write-Warning -Message ( "PROCESS - {0} - Something bad happened" -f $Name )
				Write-Warning -Message $Error[0].Exception.Message
            }
        }
    }
}