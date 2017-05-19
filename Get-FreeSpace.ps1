function Get-FreeSpace {
	<#
	.SYNOPSIS
		This function gets the amount of free disk space on a local or remote machine.
		
	.DESCRIPTION
		This function gets the amount of free disk space on a local or remote machine.
		
	.PARAMETER ComputerName
	
	.EXAMPLE
		Get-FreeSpace
		
	.EXAMPLE
		Get-FreeSpace -ComputerName Server1
		
	.EXAMPLE
		Get-FreeSpace -ComputerName Server1,Server2,Server3
		
	.EXAMPLE
		Get-Content C:\computers.txt | Get-FreeSpace
	#>

	[CmdletBinding()]
	
	param(
		[parameter(ValueFromPipeline=$True)]
		[string[]]$ComputerName = $Env:ComputerName
	)
	
	process {
		ForEach ($Computer in $ComputerName) {
			Try {
				$Name = $Computer.ToUpper()
				Write-Verbose -Message ( "{0}: Getting disk space information" -f $Name )

				$Splatting = @{
					Class = "Win32_LogicalDisk"
					Filter = "drivetype='3'"
					ComputerName = $Name
				}
				$Disks = Get-WmiObject @splatting
				ForEach ($Disk in $Disks) {
					[pscustomobject]@{
						ComputerName = $Name
						Drive = $Disk.DeviceID
						FreeSpace = "{0} GB" -f [math]::round($Disk.freespace / 1GB)
					}
				}
			}
			Catch {
				Write-Warning -Message ( "{0}: Something bad happened" -f $Name )
				Write-Warning -Message $Error[0].Exception.Message
			}
		}
	}
}
