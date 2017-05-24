function Invoke-GPUpdate {
<#
.SYNOPSIS
	This function forces Group Policy settings to update on a local or remote machine.
		
.DESCRIPTION
	This function forces Group Policy settings to update on a local or remote machine.
		
.PARAMETER ComputerName
	
.EXAMPLE
	Invoke-GPUpdate
		
.EXAMPLE
	Invoke-GPUpdate -ComputerName Computer1
		
.EXAMPLE
	Invoke-GPUpdate -ComputerName Computer1,Computer2,Computer3
		
.EXAMPLE
	Get-Content C:\computers.txt | Invoke-GPUpdate
#>

	[CmdletBinding()]
	
	param(
		[Parameter(ValueFromPipeline=$True)]
		[String[]]$ComputerName = $Env:ComputerName,

        [Parameter()]
        [System.Management.Automation.PSCredential]
        [System.Management.Automation.Credential()]
        $Credentials
	)
	
	process {
		foreach ($Computer in $ComputerName) {
			$Name = $Computer.ToUpper()
			Write-Verbose -Message ( "{0}: Invoking gpupdate /force" -f $Name )
			
			$Splatting = @{
				Class = "Win32_Process"
				Name = "Create"
				ArgumentList = "gpupdate /force"
				ComputerName = $Name
                Credential = $Credentials
			}
			Invoke-WmiMethod @Splatting | Out-Null
		}	
	}
}
