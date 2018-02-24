function New-Password {
<#
.SYNOPSIS
    This function generates a random password.

.DESCRIPTION
    This function generates a random password.
    
.PARAMETER Length
    The number of characters in the generated password. The length must be between 1 and 128 characters.
    Default is 12.

.PARAMETER NumberOfNonAlphanumericCharacters
    The minimum number of non-alphanumeric characters (such as @, #, !, %, &, and so on) in the generated password.
    Default is 5.

.PARAMETER Count
    Specifies how many passwords you want to generate.
    Default is 1.

.EXAMPLE
    PS> New-Password

.EXAMPLE
    PS> New-Password -Length 15 -NumberOfNonAlphanumericCharacters 1 -Count 6
#>

    [CmdletBinding()]

    param (
        [parameter(
            Mandatory=$false,
            ValueFromPipelineByPropertyName=$true,
            Position=0)]
        [int32]
        $Length = 12,
        
        [parameter(
            Mandatory=$false,
            ValueFromPipelineByPropertyName=$true,
            Position=1)]
        [int32]
        $NumberOfNonAlphanumericCharacters = 5,
        
        [parameter(
            Mandatory=$false,
            ValueFromPipelineByPropertyName=$true,
            Position=2)]
        [int32]
        $Count = 1
    )
    
    process {
        Add-Type -AssemblyName System.Web
        
        for ($i = 1; $i -le $Count; $i++) {
            [System.Web.Security.Membership]::GeneratePassword(
                $Length, $NumberOfNonAlphanumericCharacters)
        }
    }
}
