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
	Get-FreeSpace -ComputerName SERVER01
		
.EXAMPLE
	Get-FreeSpace -ComputerName SERVER01,SERVER02,SERVER03
		
.EXAMPLE
	Get-Content C:\computers.txt | Get-FreeSpace
#>

	[CmdletBinding()]
	
	param(
		[Parameter(ValueFromPipeline=$true)]
		[String[]]$ComputerName = $env:ComputerName,

        [Parameter()]
        [System.Management.Automation.PSCredential]
        [System.Management.Automation.Credential()]
        $Credentials
	)
	
	process {
		foreach ($Computer in $ComputerName) {
            $Name = $Computer.ToUpper()
			Write-Verbose -Message ( "{0} - Getting disk space information" -f $Name )

			try {
				$Splatting = @{
					Class = "Win32_LogicalDisk"
					Filter = "drivetype='3'"
					ComputerName = $Name
				}
				$Disks = Get-WmiObject @Splatting
				foreach ($Disk in $Disks) {
					[pscustomobject]@{
						ComputerName = $Name
						Drive = $Disk.DeviceID
						Size = $Disk.Size
						FreeSpace = "{0} GB" -f [math]::round($Disk.FreeSpace / 1GB)
					}
				}
			}
			catch {
				Write-Warning -Message ( "{0} - Something bad happened" -f $Name )
				Write-Warning -Message $Error[0].Exception.Message
			}
		}
	}
}
