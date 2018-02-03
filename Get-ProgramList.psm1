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
        [Parameter(ValueFromPipeline=$true)]
		[string[]]$ComputerName = $env:ComputerName
    )

	begin {
		$GetCimInstanceParams = @{
			ClassName = "Win32_Product"
			Property  = "InstallDate"
		}
		$Count = $ComputerName.count
	}

    process {
		for ($i = 0; $i -lt $Count; $i++) {
			$Name = ($ComputerName[$i]).ToUpper()
			$PercentComplete = $i / $Count*100

			$WriteProgressParams = @{
				Activity        = "Searching Program List for {0}" -f $Name
				Status          = "{0}% Complete->" -f $PercentComplete
				PercentComplete = $PercentComplete
			}
			Write-Progress @WriteProgressParams

			if ($Name -ne $env:ComputerName) {
				$GetCimInstanceParams.ComputerName = $Name
			}
			else {
				$GetCimInstanceParams.ComputerName = $null
			}
			
			$Programs = Get-CimInstance @GetCimInstanceParams
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
