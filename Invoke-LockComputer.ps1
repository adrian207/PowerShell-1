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
	Invoke-LockComputer -ComputerName COMPUTER1

.EXAMPLE
	Invoke-LockComputer -ComputerName COMPUTER1,COMPUTER2,COMPUTER3

.EXAMPLE
	Get-Content C:\computers.txt | Invoke-LockComputer
#>

	[CmdletBinding()]
	
	Param(
		[parameter(ValueFromPipeline=$True)]
		[string[]]$ComputerName = $Env:ComputerName
	)
	
	Process {
		Try {
			ForEach ($Computer in $ComputerName) {
				$Name = $Computer.ToUpper()
				Write-Verbose -Message ( "PROCCESS - {0} - Locking the screen" -f $Name )
				$Splatting = @{
					Class = "Win32_Process"
					Name = "Create"
					ArgumentList = "C:\Windows\System32\rundll32.exe user32.dll,LockWorkStation"
					ComputerName = $Name
				}
				Invoke-WmiMethod @Splatting
			}
		}
		Catch {
			Write-Warning -Message ( "PROCESS - {0} - Something bad happened" -f $Name )
			Write-Warning -Message $Error[0].Exception.Message
		}	
	}
}
