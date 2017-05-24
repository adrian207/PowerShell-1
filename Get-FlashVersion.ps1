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
		[Parameter(ValueFromPipeline=$True)]
		[string[]]$ComputerName = $Env:ComputerName,

        [Parameter()]
        [System.Management.Automation.PSCredential]
        [System.Management.Automation.Credential()]
        $Credentials
	)
    
	process {
		foreach ($Computer in $ComputerName) {
			$Name = $Computer.ToUpper()
			Write-Verbose -Message ("PROCESS - {0} - Getting Flash version" -f $Name)

			if ( Test-Connection -ComputerName $Name -Count 1 -ErrorAction SilentlyContinue ) {
				$Filename = "\\{0}\c$\windows\system32\macromed\flash\flash*.ocx" -f $Name

				if (Test-Path $Filename) {
					$File = Get-Item $Filename
					$Version = $file.versionInfo.fileversion -replace ",","."
				}
				else { $Version = "Not Installed" }
			}
			else { $Version = "Offline" }
			
			$Object = New-Object -TypeName PSObject -Property @{
				ComputerName = $Name
				FlashVersion = $Version
			}
			$Object
		}
	}
}
