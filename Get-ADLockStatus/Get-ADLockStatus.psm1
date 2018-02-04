#Requires -Version 2 
function Get-ADLockStatus { 
<#
.SYNOPSIS
    This function checks if an AD account is locked and if it is, it prompts to unlock.
    
.DESCRIPTION
    This function checks if an AD account is locked and if it is, it prompts to unlock.
    
.PARAMETER Identity
    
.EXAMPLE
    Get-ADAccountLock -Identity USER01

.EXAMPLE
    Get-ADAccountLock -Identity USER01,USER02,USER03

.EXAMPLE
    Get-Content C:\users.txt | Get-ADAccountLock
#>

    param(
        [Parameter(Mandatory = $true)]
        [string[]]$Identity
    )

    process {
        foreach ($_ in $Identity) {
            $Object = Get-ADUser -Identity $_ -Property @{"SamAccountName", "LockedOut", "LastLogonDate"}

            if ( $Object.LockedOut -ne $false ) {
                Unlock-ADAccount -Identity $_ -Confirm
            }
            else {
                Write-Warning -Message ( "{0} is not locked out" -f $Object.SamAccountName )
            }
        }
    }
}
