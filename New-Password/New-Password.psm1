function New-Password {
<#
.SYNOPSIS
    Generates a new password.

.DESCRIPTION
    The New-Password cmdlet generates a random password. By default, the password length is set to 12 and will contain at least one non-alpanumeric character.
    
.PARAMETER Length
    Specifies the number of characters in the generated password. The length must be between 1 and 128 characters.

.PARAMETER NumberOfNonAlphanumericCharacters
    Specifies the minimum number of non-alphanumeric characters in the generated password.

.PARAMETER Count
    Specifies how many passwords you want to generate.

.EXAMPLE
    PS C:\> New-Password

    This command generates a new password.

.EXAMPLE
    PS C:\> New-Password -Length 24 -NumberOfNonAlphanumericCharacters 1 -Count 5

    This command generates five new passwords with a length of 24 and at least 1 non-alpanumeric character.

.EXAMPLE
    PS C:\> New-Password -Length 6 -NumberOfNonAlphanumericCharacters 6

    This command generates a new password with a length of 6 characters and 6 non-alphanumeric characters.
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
            $Object = [PSCustomObject]@{
                PSTypeName = 'Password'
                Password = [System.Web.Security.Membership]::GeneratePassword(
                    $Length, $NumberOfNonAlphanumericCharacters)
            }

            $Splatting = @{
                MemberType = 'ScriptMethod'
                InputObject = $Object
                Name = 'ToString'
                Value = { $this.Password }
                Force = $true
            }
            Add-Member @Splatting
            
            $Object
        }
    }
}
