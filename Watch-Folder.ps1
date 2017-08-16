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
        [String]$Path,
        [Parameter(Mandatory=$false)]
        [Int32]$Timer = 1000
    )

    process {
        if (Test-Path -Path $Path) {

            #$Items = Get-ChildItem -Path $Path | Select-Object -ExcludeProperty "Name"

            try {
                $Watcher = New-Object -TypeName System.IO.FileSystemWatcher
                $Watcher.Path = $Path

                while ($true) {
                    $Result = $Watcher.WaitForChanged([System.IO.WatcherChangeTypes]::All, $Timer)
                    
                    if ($Result.TimedOut) {
		                continue;
	                }
					
                    $Splatting = @{
                        Object = ( "File {0} has been {1}" -f $Result.Name, $Result.ChangeType )
                    }

                    Write-Host @Splatting
                }
            }
            Catch {
                Write-Warning -Message ( "PROCESS - Something bad happened" )
			    Write-Warning -Message $Error[0].Exception.Message
            }
        }
        else {
            #error correction for invalid path
        }
    }
}
