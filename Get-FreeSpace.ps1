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
		Try {
			ForEach ($Computer in $ComputerName) {
				$name = $Computer.ToUpper()
				Write-Verbose -Message ( "{0}: Getting disk space information" -f $name )
				$splatting = @{
					Class = "Win32_LogicalDisk"
					Filter = "drivetype='3'"
					ComputerName = $name
				}
				
				$disks = Get-WmiObject @splatting
				ForEach ($disk in $disks) {
					$object = New-Object PSObject -Property @{
						ComputerName = $name
						Drive = $disk.DeviceID
						FreeSpace = "{0} GB" -f [math]::round($disk.freespace / 1GB)
					}
					$object
				}
			}
		}
		Catch {
			Write-Warning -Message ( "{0}: Something bad happened" -f $name )
			Write-Warning -Message $Error[0].Exception.Message
		}
		
	}
	
}
