#requires -version 3

function Watch-Folder {
<#
.SYNOPSIS
	This function watches a folder for changes.

.DESCRIPTION
	This function watches a folder for changes.

.EXAMPLE
    Watch-Folder -Path C:\Windows\Temp
#>

    [CmdletBinding()]

    param(
        [Parameter(Mandatory=$true)]
        [String]$Command,
        [Parameter(Mandatory=$false)]
        [Int32]$Timer = 2
    )

    process {
        try {
			$ScriptBlock = [ScriptBlock]::Create($Command)
			
			while ($true) {
				Clear-Host
				
				$timestamp = Get-Date -format "ddd MMM H:mm:ss yyyy"
				Write-Host ( "Every {0:N1}s: {1} {2,50}" -f $Timer,$Command,$timestamp )
				
				Invoke-Command -ScriptBlock $ScriptBlock | Out-Host
				
				Start-Sleep -Seconds $Timer
			}
        }
        catch {
            Write-Warning -Message ( "PROCESS - Something bad happened" )
			Write-Warning -Message $Error[0].Exception.Message
        }
    }
}
