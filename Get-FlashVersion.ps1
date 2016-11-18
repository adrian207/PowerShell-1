function Get-FlashVersion {
	<#
	.SYNOPSIS
		This function gets the Adobe Flash version on a local or remote machine.
		
	.DESCRIPTION
		This function gets the Adobe Flash version on a local or remote machine.
		
	.PARAMETER ComputerName
		
	.EXAMPLE
		Get-FlashVersion -ComputerName Computer1
		
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
			if(Test-Connection $Computer -count 1 -ErrorAction SilentlyContinue) {
				$filename = "\\$Computer\c$\windows\system32\macromed\flash\flash*.ocx"
				if(Test-Path $filename) {
					$file = Get-Item $filename
					$version = $file.versionInfo.fileversion -replace ",","."
				} else {
					$version = "Not Installed"
				}
			} else {
				$Version = "Offline"
			}
			
			$object = New-Object -TypeName PSObject -Property @{
				ComputerName = $Computer
				FlashVersion = $version
			}
			$object
		}
		
    }
	
}