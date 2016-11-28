function Invoke-DetectNow {
	<#
	.SYNOPSIS
		This function detects installed Windows updates on a local or remote machine.
		
	.DESCRIPTION
		This function detects installed Windows updates on a local or remote machine.
		
	.PARAMETER ComputerName
		
	.EXAMPLE
		Invoke-DetectNow -ComputerName Computer1
		
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
				$name = $Computer.ToUpper()
				Write-Verbose ( "{0}: Invoking wuauclt.exe /ResetAuthorization /DetectNow" -f $name )
				$splatting = @{
					Class = "Win32_Process"
					Name = "Create"
					ArgumentList = "wuauclt.exe /ResetAuthorization /DetectNow"
					ComputerName = $name
				}
				Invoke-WmiMethod @splatting
			}
		}
		Catch {
			Write-Warning -Message ( "{0}: Something bad happened" -f $name )
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
		Invoke-ReportNow -ComputerName Computer1
		
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
				$name = $Computer.ToUpper()
				Write-Verbose -Message ( "{0}: Invoking wuauclt.exe /ReportNow" -f $name )
				$splatting = @{
					Class = "Win32_Process"
					Name = "Create"
					ArgumentList = "wuauclt.exe /ReportNow"
					ComputerName = $name
				}
				Invoke-WmiMethod @splatting
			}
		}
		Catch {
			Write-Warning -Message ( "{0}: Something bad happened" -f $name )
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
		Invoke-ReportNow -ComputerName Computer1
		
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
				$name = $Computer.ToUpper()
				Write-Verbose -Message ( "{0}: Invoking wuauclt.exe /UpdateNow" -f $name )
				$splatting = @{
					Class = "Win32_Process"
					Name = "Create"
					ArgumentList = "wuauclt.exe /UpdateNow"
					ComputerName = $name
				}
				Invoke-WmiMethod @splatting
			}
		}
		Catch {
			Write-Warning -Message ( "{0}: Something bad happened" -f $name )
			Write-Warning -Message $Error[0].Exception.Message
		}
		
	}
	
}
