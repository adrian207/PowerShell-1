function Invoke-DiskCleanup {
<#
.SYNOPSIS
	This function creates a sageset in the registry and then runs cleanmgr on a local or remote machine.

.DESCRIPTION
	This function creates a sageset in the registry and then runs cleanmgr on a local or remote machine.

.PARAMETER ComputerName

.EXAMPLE
	Invoke-DiskCleanup

.EXAMPLE
	Invoke-DiskCleanup -ComputerName COMPUTER01

.EXAMPLE
	Invoke-DiskCleanup -ComputerName COMPUTER01,COMPUTER02,COMPUTER03

.EXAMPLE
	Get-Content C:\computers.txt | Invoke-DiskCleanup
#>

	[CmdletBinding()]
	
	Param(
		[parameter(ValueFromPipeline=$true)]
		[string[]]$ComputerName = $Env:ComputerName
	)
	
	Process {
		$Keys = @(
			"Setup Log Files",
			"Downloaded Program Files",
			"Delivery Optimization Files",
			"Recycle Bin",
			"Temporary Files",
			"Thumbnail Cache",
			"Update Cleanup"
		)
		
		ForEach ($Computer in $ComputerName) {
			Try {
				$Name = $Computer.ToUpper()
				ForEach ($Key in $Keys) {	
					$Hklm = Join-Path -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\VolumeCaches" -ChildPath $key
					Write-Verbose -Message ( "PROCESS - {0} - Writing registry key {1}" -f $Name,$Hklm )
					
					Invoke-Command -ComputerName $Name -ArgumentList $Hklm -ScriptBlock {
						param($Hklm)
					
						$ItemPropertySplatting = @{
							Path = $Hklm
							Name = "StateFlags0001"
							Value = 2
							PropertyType = "DWord"
							ErrorAction = "SilentlyContinue"
						}
						New-ItemProperty @ItemPropertySplatting
					}
				}
				
				Write-Verbose -Message ( "PROCESS - {0} - Invoking cleanmgr /sagerun:1" -f $Name )
				$WmiMethodSplatting = @{
					Class = "Win32_Process"
					Name = "Create"
					ArgumentList = "cleanmgr /sagerun:1"
					ComputerName = $Name
				}
				Invoke-WmiMethod @WmiMethodSplatting | Out-Null
			}
			Catch {
				Write-Warning -Message ( "PROCESS - {0} - Something bad happened" -f $Name )
				Write-Warning -Message $Error[0].Exception.Message
			}
		}
	}
}

function Remove-SoftwareDistribution {
<#
.SYNOPSIS
	This function removes the SoftwareDistribution folder and all subfolders from the Windows directory on a local or remote machine.

.DESCRIPTION
	This function removes the SoftwareDistribution folder and all subfolders from the Windows directory on a local or remote machine.

.PARAMETER ComputerName

.EXAMPLE
	Remove-SoftwareDistribution

.EXAMPLE
	Remove-SoftwareDistribution -ComputerName COMPUTER01

.EXAMPLE
	Remove-SoftwareDistribution -ComputerName COMPUTER01,COMPUTER02,COMPUTER03

.EXAMPLE
	Get-Content C:\computers.txt | Remove-SoftwareDistribution
#>
	
	[CmdletBinding()]
	
	param(
		[parameter(ValueFromPipeline=$true)]
		[string[]]$ComputerName = $Env:ComputerName
	)
	
	process {
		ForEach ($Computer in $ComputerName) {
			Try {
				$Name = $Computer.ToUpper()
				Invoke-Command -Computer $Name -ScriptBlock {
					Stop-Service -Name "wuauserv"

					$SoftwareDistribution = Join-Path -Path $Env:WinDir -ChildPath SoftwareDistribution
					$Splatting = @{
						Path = $SoftwareDistribution
						Recurse = $true
					}
					Remove-Item @Splatting

					Start-Service -Name "wuauserv"
				}
			}
			Catch {
				Write-Warning -Message ( "PROCESS - {0} - Something bad happened" -f $name )
				Write-Warning -Message $Error[0].Exception.Message
			}
		}
	}
}

function Remove-CBSLogs {
<#
.SYNOPSIS
	This function removes all files from the CBS folder and all subfolders on a local or remote machine.

.DESCRIPTION
	This function removes all files from the CBS folder and all subfolders on a local or remote machine.

.PARAMETER ComputerName

.EXAMPLE
	Remove-CBSLogs

.EXAMPLE
	Remove-CBSLogs -ComputerName COMPUTER01

.EXAMPLE
	Remove-CBSLogs -ComputerName COMPUTER01,COMPUTER02,COMPUTER03

.EXAMPLE
	Get-Content C:\computers.txt | Remove-CBSLogs
#>
	
	[CmdletBinding()]
	
	param(
		[parameter(ValueFromPipeline=$true)]
		[string[]]$ComputerName = $Env:ComputerName
	)
	
	process {
		ForEach ($Computer in $ComputerName) {
			Try {
				$Name = $Computer.ToUpper()
				Invoke-Command -Computer $Name -ScriptBlock {
					Stop-Service -Name "Windows Modules Installer"

					$Cbs = Join-Path -Path $Env:WinDir -ChildPath "Logs\CBS"
					$Splatting = @{
						Path = $SoftwareDistribution
						Recurse = $true
					}
					Remove-Item @Splatting

					Start-Service -Name "Windows Modules Installer"
				}
			}
			Catch {
				Write-Warning -Message ( "PROCESS - {0} - Something bad happened" -f $name )
				Write-Warning -Message $Error[0].Exception.Message
			}
		}
	}
}
