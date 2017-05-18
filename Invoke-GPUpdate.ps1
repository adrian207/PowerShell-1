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
	
	Param(
		[parameter(ValueFromPipeline=$True)]
		[string[]]$ComputerName = $Env:ComputerName
	)
	
	Process {
		ForEach ($Computer in $ComputerName) {
			$Name = $Computer.ToUpper()
			Write-Verbose -Message ( "{0}: Invoking gpupdate /force" -f $Name )
			
			$Splatting = @{
				Class = "Win32_Process"
				Name = "Create"
				ArgumentList = "gpupdate /force"
				ComputerName = $Name
			}
			Invoke-WmiMethod @Splatting | Out-Null
		}	
	}
}
