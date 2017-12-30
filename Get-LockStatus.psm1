#Requires -Version 2 
function Get-LockStatus { 
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
        foreach ($Id in $Identity) {
            $Splatting = @{
                Identity = $Id
                Property = "SamAccountName", "LockedOut", "LastLogonDate"
            }
            $Object = Get-ADUser @Splatting

            if ( $Object.LockedOut -ne $false ) {
                Unlock-ADAccount -Identity $Id -Confirm
            }
            else {
                Write-Warning -Message ( "{0} is not locked out" -f $Object.SamAccountName )
            }
        }
    }
}
