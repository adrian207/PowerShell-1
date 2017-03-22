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
                
				$CimSession = New-CimSession -ComputerName $Name

                # Get monitor information
				$Splatting = @{
					ClassName = "WmiMonitorId"
					CimSession = $CimSession
					Namespace = "root\wmi"
				}
                $Monitors = Get-CimInstance @Splatting

                ForEach ($Monitor in $Monitors) {
                    [pscustomobject]@{
                        Name = ($Monitor.UserFriendlyName -notmatch '^0$' | ForEach {[char]$_}) -join ""
                        Manufacturer = ($Monitor.ManufacturerName -notmatch '^0$' | ForEach {[char]$_}) -join ""
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