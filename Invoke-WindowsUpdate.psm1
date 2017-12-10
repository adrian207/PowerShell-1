function Invoke-DetectNow {
<#
.SYNOPSIS
	This function detects installed Windows updates on a local or remote machine.

.DESCRIPTION
	This function detects installed Windows updates on a local or remote machine.

.PARAMETER ComputerName

.EXAMPLE
	Invoke-DetectNow

.EXAMPLE
	Invoke-DetectNow -ComputerName COMPUTER01

.EXAMPLE
	Invoke-DetectNow -ComputerName COMPUTER01,COMPUTER02,COMPUTER03

.EXAMPLE
	Get-Content C:\computers.txt | Invoke-DetectNow
#>
	
	[CmdletBinding()]
	
	param(
		[parameter(ValueFromPipeline=$True)]
		[string[]]$ComputerName = $Env:ComputerName
	)
	
	process {
		foreach ($Computer in $ComputerName) {
			try {
				$Name = $Computer.ToUpper()
				Write-Verbose -Message ( "PROCESS - {0} - Invoking wuauclt.exe /ResetAuthorization /DetectNow" -f $Name )

				$Splatting = @{
					CimClass = (Get-CimClass -ClassName Win32_Process)
					MethodName = "Create"
					Arguments = @{ CommandLine = 'wuauclt.exe /ResetAuthorization /DetectNow';
									CurrentDirectory = "C:\windows\system32" }
					ComputerName = $Name
				}
				Invoke-CimMethod @Splatting
			}
			catch {
				Write-Warning -Message ( "PROCESS - {0} - Something bad happened" -f $Name )
				Write-Warning -Message $Error[0].Exception.Message
		    }
		}
	}
}

function Invoke-ReportNow {
<#
.SYNOPSIS
	This function reports the Windows update status of a local or remote machine to WSUS.

.DESCRIPTION
	This function reports the Windows update status of a local or remote machine to WSUS.

.PARAMETER ComputerName

.EXAMPLE
	Invoke-ReportNow

.EXAMPLE
	Invoke-ReportNow -ComputerName COMPUTER01

.EXAMPLE
	Invoke-ReportNow -ComputerName COMPUTER01,COMPUTER02,COMPUTER03

.EXAMPLE
	Get-Content C:\computers.txt | Invoke-ReportNow
#>
		
	[CmdletBinding()]
	
	param(
		[Parameter(ValueFromPipeline=$True)]
		[String[]]$ComputerName = $Env:ComputerName
	)
	
	process {
        foreach ($Computer in $ComputerName) {
			try {
				$Name = $Computer.ToUpper()
				Write-Verbose -Message ( "PROCESS - {0} - Invoking wuauclt.exe /ReportNow" -f $Name )
                
				$Splatting = @{
					CimClass = (Get-CimClass -ClassName Win32_Process)
					MethodName = "Create"
					Arguments = @{ CommandLine = 'wuauclt.exe /ReportNow';
									CurrentDirectory = "C:\windows\system32" }
					ComputerName = $Name
				}
				Invoke-CimMethod @Splatting
			}
			catch {
				Write-Warning -Message ( "PROCESS - {0} - Something bad happened" -f $Name )
				Write-Warning -Message $Error[0].Exception.Message
			}
		}
	}
}

function Invoke-UpdateNow {
<#
.SYNOPSIS
	This function forces a local or remote machine to update Windows now.

.DESCRIPTION
	This function forces a local or remote machine to update Windows now.

.PARAMETER ComputerName

.EXAMPLE
	Invoke-ReportNow

.EXAMPLE
	Invoke-ReportNow -ComputerName COMPUTER01

.EXAMPLE
	Invoke-ReportNow -ComputerName COMPUTER01,COMPUTER02,COMPUTER03

.EXAMPLE
	Get-Content C:\computers.txt | Invoke-UpdateNow
#>
		
	[CmdletBinding()]
	
	param(
		[Parameter(ValueFromPipeline=$True)]
		[String[]]$ComputerName = $Env:ComputerName
	)
	
	process {
		foreach ($Computer in $ComputerName) {
			try {
				$Name = $Computer.ToUpper()
				Write-Verbose -Message ( "PROCESS - {0} - Invoking wuauclt.exe /UpdateNow" -f $Name )
                
				$Splatting = @{
					CimClass = (Get-CimClass -ClassName Win32_Process)
					MethodName = "Create"
					Arguments = @{ CommandLine = 'wuauclt.exe /UpdateNow';
									CurrentDirectory = "C:\windows\system32" }
					ComputerName = $Name
				}
				Invoke-CimMethod @Splatting
			}
            catch {
				Write-Warning -Message ( "PROCESS - {0} - Something bad happened" -f $Name )
				Write-Warning -Message $Error[0].Exception.Message
            		}	
		}
	}	
}
