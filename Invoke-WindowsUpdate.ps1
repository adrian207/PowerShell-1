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
	Invoke-DetectNow -ComputerName COMPUTER1

.EXAMPLE
	Invoke-DetectNow -ComputerName COMPUTER1,COMPUTER2,COMPUTER3

.EXAMPLE
	Get-Content C:\computers.txt | Invoke-DetectNow
#>
	
	[CmdletBinding()]
	
	param(
		[parameter(ValueFromPipeline=$True)]
		[string[]]$ComputerName = $Env:ComputerName
	)
	
	process {
		Try {
			ForEach ($Computer in $ComputerName) {
				$Name = $Computer.ToUpper()
				Write-Verbose -Message ( "PROCESS - {0} - Invoking wuauclt.exe /ResetAuthorization /DetectNow" -f $Name )
				$CimClass = Get-CimClass -ClassName Win32_Process
				$Splatting = @{
					CimClass = $CimClass
					MethodName = "Create"
					Arguments = "wuauclt.exe /ResetAuthorization /DetectNow"
					ComputerName = $Name
				}
				Invoke-CimMethod @Splatting
			}
		}
		Catch {
			Write-Warning -Message ( "PROCESS - {0} - Something bad happened" -f $Name )
			Write-Warning -Message $Error[0].Exception.Message
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
	Invoke-ReportNow -ComputerName COMPUTER1

.EXAMPLE
	Invoke-ReportNow -ComputerName COMPUTER1,COMPUTER2,COMPUTER3

.EXAMPLE
	Get-Content C:\computers.txt | Invoke-ReportNow
#>
		
	[CmdletBinding()]
	
	param(
		[parameter(ValueFromPipeline=$True)]
		[string[]]$ComputerName = $Env:ComputerName
	)
	
	process {
		Try {
			ForEach ($Computer in $ComputerName) {
				$Name = $Computer.ToUpper()
				Write-Verbose -Message ( "PROCESS - {0} - Invoking wuauclt.exe /ReportNow" -f $Name )
				$CimClass = Get-CimClass -ClassName Win32_Process
				$Splatting = @{
					CimClass = $CimClass
					MethodName = "Create"
					Arguments = "wuauclt.exe /ReportNow"
					ComputerName = $Name
				}
				Invoke-CimMethod @Splatting
			}
		}
		Catch {
			Write-Warning -Message ( "PROCESS - {0} - Something bad happened" -f $Name )
			Write-Warning -Message $Error[0].Exception.Message
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
	Invoke-ReportNow -ComputerName COMPUTER1

.EXAMPLE
	Invoke-ReportNow -ComputerName COMPUTER1,COMPUTER2,COMPUTER3

.EXAMPLE
	Get-Content C:\computers.txt | Invoke-UpdateNow
#>
		
	[CmdletBinding()]
	
	param(
		[parameter(ValueFromPipeline=$True)]
		[string[]]$ComputerName = $Env:ComputerName
	)
	
	process {
		Try {
			ForEach ($Computer in $ComputerName) {
				$Name = $Computer.ToUpper()
				Write-Verbose -Message ( "PROCESS - {0} - Invoking wuauclt.exe /UpdateNow" -f $Name )
				$CimClass = Get-CimClass -ClassName Win32_Process
				$Splatting = @{
					CimClass = "Win32_Process"
					MethodName = "Create"
					Arguments = "wuauclt.exe /UpdateNow"
					ComputerName = $Name
				}
				Invoke-CimMethod @Splatting
			}
		}
		Catch {
			Write-Warning -Message ( "PROCESS - {0} - Something bad happened" -f $Name )
			Write-Warning -Message $Error[0].Exception.Message
		}	
	}	
}
