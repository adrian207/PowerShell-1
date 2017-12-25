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
    Invoke-LockComputer -ComputerName COMPUTER01
    
.EXAMPLE
    Invoke-LockComputer -ComputerName COMPUTER01,COMPUTER02,COMPUTER03

.EXAMPLE
    Get-Content C:\computers.txt | Invoke-LockComputer
#>

    [CmdletBinding()]
    
    param(
        [Parameter(
            ValueFromPipeline=$true)]
        [string[]]$ComputerName = $env:ComputerName
    )
    
    process {
        foreach ($Computer in $ComputerName) {
            $Name = $Computer.ToUpper()

            $Splatting = @{
                ClassName = "Win32_Process"
                MethodName = "Create"
                Arguments = @{
                    CommandLine = "C:\Windows\System32\rundll32.exe user32.dll,LockWorkStation"
                }
            }
            if ( $Name -ne $env:ComputerName) {
				$Splatting.Add("ComputerName",$Name)

				if ( Test-Connection -ComputerName $Name -Count 1 ) {
					Write-Verbose -Message ( "PROCCESS - {0} - Locking the screen" -f $Name )
				}
				else {
					Write-Warning -Message ( "PROCESS - {0} - Failed to connect to host" -f $Name )
					continue
				}

			}
			
			Invoke-CimMethod @Splatting
        }
    }
}
