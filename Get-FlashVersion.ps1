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
			$name = $Computer.ToUpper()
			if(Test-Connection -ComputerName $name -Count 1 -ErrorAction SilentlyContinue) {
				$filename = "\\{0}\c$\windows\system32\macromed\flash\flash*.ocx" -f $name
				if(Test-Path $filename) {
					$file = Get-Item $filename
					$version = $file.versionInfo.fileversion -replace ",","."
				}
				else { $version = "Not Installed" }
			}
			else { $Version = "Offline" }
			
			$object = New-Object -TypeName PSObject -Property @{
				ComputerName = $name
				FlashVersion = $version
			}
			$object
		}
		
	}
	
}
