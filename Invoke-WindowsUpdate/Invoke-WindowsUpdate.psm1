
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
		[parameter(
			Mandatory=$false,
			ValueFromPipeline=$true,
			ValueFromPipelineByPropertyName=$true)]
		[string[]]
		$ComputerName = $env:ComputerName
	)
	
	begin {
		$CommandLine = 'wuauclt.exe /ResetAuthorization /DetectNow'
		$Splatting = @{
			CimClass = (Get-CimClass -ClassName 'Win32_Process')
			MethodName = 'Create'
			Arguments = @{
				CommandLine = $CommandLine
				CurrentDirectory = 'C:\windows\system32'
			}
		}
	}

	process {
		foreach ($Computer in $ComputerName) {
			$Name = $Computer.ToUpper()
			Write-Verbose -Message ( "PROCESS - {0} - Invoking command {1}" -f $Name,$CommandLine )

			if ($Name -ne $env:ComputerName) {
				$Splatting.ComputerName = $Name
			}
			else {
				$Splatting.ComputerName = $null
			}
			Invoke-CimMethod @Splatting
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
		[parameter(
			Mandatory=$false,
			ValueFromPipeline=$true,
			ValueFromPipelineByPropertyName=$true)]
		[string[]]
		$ComputerName = $env:ComputerName
	)
	
	begin {
		$CommandLine = 'wuauclt.exe /ReportNow'
		$Splatting = @{
			CimClass = (Get-CimClass -ClassName 'Win32_Process')
			MethodName = 'Create'
			Arguments = @{
				CommandLine = $CommandLine
				CurrentDirectory = 'C:\windows\system32'
			}
		}
	}

	process {
        foreach ($Computer in $ComputerName) {
			$Name = $Computer.ToUpper()
			Write-Verbose -Message ( "PROCESS - {0} - Invoking {1}" -f $Name,$CommandLine )
			
			if ($Name -ne $env:ComputerName) {
				$Splatting.ComputerName = $Name
			}
			else {
				$Splatting.ComputerName = $null
			}
			Invoke-CimMethod @Splatting
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
	Invoke-UpdateNow

.EXAMPLE
	Invoke-UpdateNow -ComputerName COMPUTER01

.EXAMPLE
	Invoke-UpdateNow -ComputerName COMPUTER01,COMPUTER02,COMPUTER03

.EXAMPLE
	Get-Content C:\computers.txt | Invoke-UpdateNow
#>
		
	[CmdletBinding()]
	
	param(
		[parameter(
			Mandatory=$false,
			ValueFromPipeline=$true,
			ValueFromPipelineByPropertyName=$true)]
		[string[]]
		$ComputerName = $env:ComputerName
	)
	
	begin {
		
		$Splatting = @{
			CimClass = (Get-CimClass -ClassName 'Win32_Process')
			MethodName = 'Create'
			Arguments = @{
				CommandLine = $CommandLine
				CurrentDirectory = 'C:\windows\system32'
			}
		}
	}

	process {
		foreach ($Computer in $ComputerName) {
			$Name = $Computer.ToUpper()
			Write-Verbose -Message ( "PROCESS - {0} - Invoking {1}" -f $Name,$CommandLine )
			
			if ($Name -ne $env:ComputerName) {
				$Splatting.ComputerName = $Name
			}
			else {
				$Splatting.ComputerName = $null
			}
			Invoke-CimMethod @Splatting
		}
	}
}
