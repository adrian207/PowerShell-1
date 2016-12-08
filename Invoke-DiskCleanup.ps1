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
		Invoke-DiskCleanup -ComputerName Computer1
		
	.EXAMPLE
		Invoke-DiskCleanup -ComputerName Computer1,Computer2,Computer3
		
	.EXAMPLE
		Get-Content C:\computers.txt | Invoke-DiskCleanup
	#>

	[CmdletBinding()]
	
	param(
		[parameter(ValueFromPipeline=$True)]
		[string[]]$ComputerName = $Env:ComputerName
	)
	
	process {
		Try {
			$keys = @(
				"Setup Log Files",
				"Downloaded Program Files",
				"Delivery Optimization Files",
				"Recycle Bin",
				"Temporary Files",
				"Thumbnail Cache",
				"Update Cleanup"
			)
			
			ForEach ($Computer in $ComputerName) {
				$name = $Computer.ToUpper()
				ForEach ($key in $keys) {	
					$hklm = Join-Path -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\VolumeCaches" -ChildPath $key
					Write-Verbose -Message ( "{0}: Writing registry key {1}" -f $name,$hklm )
					
					Invoke-Command -ComputerName $name -ArgumentList $hklm -ScriptBlock {
						param($hklm)
					
						$ItemPropertySplatting = @{
							Path = $hklm
							Name = "StateFlags0001"
							Value = 2
							PropertyType = "DWord"
							ErrorAction = "SilentlyContinue"
						}
						New-ItemProperty @ItemPropertySplatting
					}
				}
				
				Write-Verbose -Message ( "{0}: Invoking cleanmgr /sagerun:1" -f $name )
				$WmiMethodSplatting = @{
					Class = "Win32_Process"
					Name = "Create"
					ArgumentList = "cleanmgr /sagerun:1"
					ComputerName = $name
				}
				Invoke-WmiMethod @WmiMethodSplatting | Out-Null
			}
		}
		Catch {
			Write-Warning -Message ( "{0}: Something bad happened" -f $name )
			Write-Warning -Message $Error[0].Exception.Message
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
		Remove-SoftwareDistribution -ComputerName Computer1
	
	.EXAMPLE
		Remove-SoftwareDistribution -ComputerName Computer1,Computer2,Computer3
		
	.EXAMPLE
		Get-Content C:\computers.txt | Remove-SoftwareDistribution
	#>
	
	[CmdletBinding()]
	
	param(
		[parameter(ValueFromPipeline=$True)]
		[string[]]$ComputerName = $Env:ComputerName
	)
	
	process {
		ForEach ($Computer in $ComputerName) {
			$Name = $Computer.ToUpper()
			Invoke-Command -Computer $Name -ScriptBlock {
				Stop-Service -Name "wuauserv"
				
				$SoftwareDistribution = Join-Path -Path $Env:WinDir -ChildPath SoftwareDistribution
				$Splatting = @{
					Path = $SoftwareDistribution
					Recurse = $True
				}
				Remove-Item @Splatting
				
				Start-Service -Name "wuauserv"
			}
		}
	}
}
