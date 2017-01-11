function Get-ADWorkstationNames {
	<#
	.SYNOPSIS
		This function gets a list of names for all computers in Active Directory.
		
	.DESCRIPTION
		This function gets a list of names for all computers in Active Directory.
		
	.EXAMPLE
		Get-ADWorkstationNames
		
	.EXAMPLE
		Get-ADWorkstationNames | Out-File -FilePath C:\computers.txt -Encoding utf8
	#>
		
	[CmdletBinding()]
	
	param()
	
	process {
		Try {
			$cred = Get-Credential
		
			Write-Verbose ("Retrieving list of computer names in Active Directory")
			$splatting = @{
				Filter = "OperatingSystem -NotLike '*server*'"
				Credential = $cred
			}
			$ComputerName = Get-ADComputer @splatting
			$ComputerName.name.ToUpper()
		}
		Catch {
			Write-Warning "Something bad happened"
			Write-Warning -Message $Error[0].Exception.Message
		}
	}
	
}