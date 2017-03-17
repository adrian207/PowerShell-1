function Get-ProgramList {
<#
.SYNOPSIS
	This function gets a list of programs on a local or remote machine.

.DESCRIPTION
	This function gets a list of programs on a local or remote machine.

.PARAMETER ComputerName

.EXAMPLE
	Get-ProgramList -ComputerName COMPUTER01

.EXAMPLE
	Get-ProgramList -ComputerName COMPUTER01,COMPUTER02,COMPUTER03

.EXAMPLE
	Get-Content C:\computers.txt | Get-ProgramList
#>

    Param(
        [parameter(ValueFromPipeline=$True)]
		[string[]]$ComputerName = $Env:ComputerName
    )

    Process {
        ForEach ($Computer in $ComputerName) {
            Try {
                $Name = $Computer.ToUpper()
                Write-Verbose -Message ( "PROCESS - {0} - Getting program list" -f $Name )
                
				Invoke-Command -Computer $Name -ScriptBlock {
					$Hklm = "HKLM:\Software\Wow6432Node\Microsoft\Windows\CurrentVersion\Uninstall\*"
					$Programs = Get-ItemProperty -Path $Hklm
					ForEach ($Program in $Programs) {
						$Info = [ordered]@{
							Name = $Program.DisplayName
							Version = $Program.DisplayVersion
							Publisher = $Program.Publisher
							InstallDate = $Program.InstallDate
						}
						New-Object -TypeName PSObject -Property $Info
					}
				}
            }
            Catch {
                Write-Warning -Message ( "PROCESS - {0} - Something bad happened" -f $Name )
                Write-Warning -Message $Error[0].Exception.Message
            }
        }
    }
}