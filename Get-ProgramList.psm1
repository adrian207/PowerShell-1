function Get-ProgramList {
<#
.SYNOPSIS
	This function gets a list of programs on a local or remote machine.

.DESCRIPTION
	This function gets a list of programs on a local or remote machine.

.PARAMETER ComputerName

.EXAMPLE
	Get-ProgramList

.EXAMPLE
	Get-ProgramList -ComputerName COMPUTER01

.EXAMPLE
	Get-ProgramList -ComputerName COMPUTER01,COMPUTER02,COMPUTER03

.EXAMPLE
	Get-Content C:\computers.txt | Get-ProgramList
#>

    param(
        [Parameter(ValueFromPipeline=$True)]
		[string[]]$ComputerName = $env:ComputerName
    )

    process {
		$Splatting = @{
			ClassName = "Win32_Product"
			Property  = "InstallDate"
		}

		foreach ($Computer in $ComputerName) {
			$Name = $Computer.ToUpper()
			Write-Verbose -Message ( "PROCESS - {0} - Getting program list" -f $Name )

			if ($Name -ne $env:ComputerName) {
				$Splatting.ComputerName = $Name
			}
			else {
				$Splatting.ComputerName = $null
			}
			
			$Programs = Get-CimInstance @Splatting
			foreach ($Program in $Programs) {
				$Property = [ordered]@{
					Name        = $Program.Name
					Vendor      = $Program.Vendor
					Version     = $Program.Version
					InstallDate = $Program.InstallDate
				}
				New-Object -TypeName "PSObject" -Property $Property
			}
        }
    }
}
