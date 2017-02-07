function Get-FlashVersion {
<#
.SYNOPSIS
	This function gets the Adobe Flash version on a local or remote machine.

.DESCRIPTION
	This function gets the Adobe Flash version on a local or remote machine.

.PARAMETER ComputerName

.EXAMPLE
	Get-FlashVersion

.EXAMPLE
	Get-FlashVersion -ComputerName Computer1

.EXAMPLE
	Get-FlashVersion -ComputerName Computer1,Computer2,Computer3

.EXAMPLE
	Get-Content C:\computers.txt | Get-FlashVersion
#>
	
	[CmdletBinding()]

	param(
		[parameter(ValueFromPipeline=$True)]
		[string[]]$ComputerName = $Env:ComputerName
	)
    
	process {
		ForEach ($Computer in $ComputerName) {
			$Name = $Computer.ToUpper()
			Write-Verbose -Message ("PROCESS - {0} - Getting Flash version" -f $Name)
			If ( Test-Connection -ComputerName $Name -Count 1 -ErrorAction SilentlyContinue ) {
				$Filename = "\\{0}\c$\windows\system32\macromed\flash\flash*.ocx" -f $Name
				If (Test-Path $Filename) {
					$File = Get-Item $Filename
					$Version = $file.versionInfo.fileversion -replace ",","."
				}
				Else { $Version = "Not Installed" }
			}
			Else { $Version = "Offline" }
			
			$Object = New-Object -TypeName PSObject -Property @{
				ComputerName = $Name
				FlashVersion = $Version
			}
			$Object
		}
	}
}
