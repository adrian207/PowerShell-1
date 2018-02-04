#requires -version 3

function Get-DisplayInformation {
<#
.SYNOPSIS
	This function gets the display information from a local or remote machine.

.DESCRIPTION
	This function gets the display information from a local or remote machine.

.EXAMPLE
	Get-DisplayInformation -ComputerName COMPUTER01

.EXAMPLE
    Get-DisplayInformation -ComputerName COMPUTER01,COMPUTER02,COMPUTER03
#>

    [CmdletBinding()]

    param(
        [Parameter(
			ValueFromPipeline=$true)]
        [String[]]$ComputerName = $env:ComputerName,

        [Parameter()]
        [System.Management.Automation.PSCredential]
        [System.Management.Automation.Credential()]
        $Credentials
    )

    process {
        foreach ($Computer in $ComputerName) {
            try {
                $Name = $Computer.ToUpper()
                Write-Verbose -Message ( "PROCESS - {0} - Getting display information" -f $Name )
                
				$CimSession = New-CimSession -ComputerName $Name -Credential $Credentials

                # Get monitor information
				$Splatting = @{
					ClassName = "WmiMonitorId"
					CimSession = $CimSession
					Namespace = "root\wmi"
				}
                $Monitors = Get-CimInstance @Splatting

                foreach ($Monitor in $Monitors) {
                    [pscustomobject]@{
                        Name = ($Monitor.UserFriendlyName -notmatch '^0$' | ForEach {[char]$_}) -join ""
                        Manufacturer = ($Monitor.ManufacturerName -notmatch '^0$' | ForEach {[char]$_}) -join ""
                        Serial = ($Monitor.SerialNumberID -notmatch '^0$' | ForEach {[char]$_}) -join ""
                    }
                }
            }
            catch {
                Write-Warning -Message ( "PROCESS - {0} - Something bad happened" -f $Name )
				Write-Warning -Message $Error[0].Exception.Message
            }
        }
    }
}
