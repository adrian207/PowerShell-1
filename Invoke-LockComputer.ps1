function Invoke-LockComputer
{
	<#
	.SYNOPSIS
		This function locks a local or remote machine.
		
	.DESCRIPTION
		This function locks a local or remote machine.
		
	.PARAMETER ComputerName
	
	.EXAMPLE
		Invoke-LockComputer
		
	.EXAMPLE
		Invoke-LockComputer -ComputerName Computer1
		
	.EXAMPLE
		Get-Content C:\computers.txt | Invoke-LockComputer
	#>

	[CmdletBinding()]
	
	param(
		[parameter(ValueFromPipeline=$True)]
		[string[]]$ComputerName = $Env:ComputerName
	)
	
	process {
		Try {
			ForEach ($Computer in $ComputerName) {
				Write-Verbose -Message ("{0} Locking the screen" -f $Computer)
				$splatting = @{
					Class = "Win32_Process"
					Name = "Create"
					ArgumentList = "C:\Windows\System32\rundll32.exe user32.dll,LockWorkStation"
					ComputerName = $Computer
				}
				Invoke-WmiMethod @splatting
			}
		}
		Catch {
			Write-Warning -Message "Something bad happened"
		}
	}

}
