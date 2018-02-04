#Requires -Version 5
function Get-ADLockStatus { 
<#
.SYNOPSIS
    This function checks if an AD account is locked and if it is, prompts to unlock.
    
.DESCRIPTION
    This function checks if an AD account is locked and if it is, prompts to unlock.
    
.PARAMETER Identity
    
.EXAMPLE
    Get-ADLockStatus -Identity USER01

.EXAMPLE
    Get-ADLockStatus -Identity USER01,USER02,USER03

.EXAMPLE
    Get-Content C:\users.txt | Get-ADLockStatus
#>

    param(
        [Parameter(
            Mandatory=$true,
            ValueFromPipeline=$true,
            ValueFromPipelineByPropertyName=$true,
            Position=0)]
        [string[]]
        $Identity
    )

    process {
        foreach ($_ in $Identity) {
            [PSCustomObject]@{
                PSTypeName             = 'ADLockStatus'
                BadLogonCount          = $_.BadLogonCount
                Enabled                = $_.Enabled
                LastBadPasswordAttempt = $_.LastBadPasswordAttempt
                LastLogonDate          = $_.LastLogonDate
                LockedOut              = $_.LockedOut
                SamAccountName         = $_.SamAccountName
            }

            if ($_.LockedOut -ne $false) {
                Unlock-ADAccount -Identity $_ -Confirm
            }
        }
    }
}
