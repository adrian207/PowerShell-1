function Invoke-LockComputer {
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
		ForEach ($Computer in $ComputerName) {
			Try {
				$Name = $Computer.ToUpper()
				Write-Verbose -Message ( "PROCCESS - {0} - Locking the screen" -f $Name )
				$CimClass = Get-CimClass -ClassName Win32_Process
				$Splatting = @{
					CimClass = $CimClass
					MethodName = "Create"
					Arguments = "C:\Windows\System32\rundll32.exe user32.dll,LockWorkStation"
					ComputerName = $Name
				}
				Invoke-CimMethod @Splatting
			}
			Catch {
				Write-Warning -Message ( "PROCESS - {0} - Something bad happened" -f $Name )
				Write-Warning -Message $Error[0].Exception.Message
			}
		}
	}
}
