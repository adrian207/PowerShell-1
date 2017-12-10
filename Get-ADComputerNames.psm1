function Get-ADComputerNames {
<#
.SYNOPSIS
	This function gets a list of names for all computers in Active Directory.

.DESCRIPTION
	This function gets a list of names for all computers in Active Directory.

.EXAMPLE
	Get-ADComputerNames

.EXAMPLE
	Get-ADComputerNames | Out-File -FilePath C:\computers.txt -Encoding utf8
#>

	[CmdletBinding()]
	
	param(
        [Parameter()]
        [System.Management.Automation.PSCredential]
        [System.Management.Automation.Credential()]
        $Credentials
    )
	
	process {
		try {		
			Write-Verbose ("PROCESS - Retrieving list of computer names in Active Directory")
			$Splatting = @{
				Filter = "OperatingSystem -NotLike '*server*'"
				Credential = $Credentials
			}
			$ComputerName = Get-ADComputer @Splatting
			$ComputerName.Name.ToUpper()
		}
		catch {
			Write-Warning "PROCESS - Something bad happened"
			Write-Warning -Message $Error[0].Exception.Message
		}
	}
}
