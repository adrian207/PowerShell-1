function Generate-Password {
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
    Generate-Password
#>
	param (
		[Int32]$Length = 12,
		
		[Int32]$NumberOfNonAlphanumericCharacters = 5,
		
		[Int32]$Count = 1
	)
	
	begin {
		Add-Type -AssemblyName System.Web
	}
	
	process	{
        $ScriptBlock = {
            [System.Web.Security.Membership]::GeneratePassword($Length, $NumberOfNonAlphanumericCharacters)
        }
        
		$Password = (1..$Count) | ForEach-Object -Process $ScriptBlock
        Set-Clipboard -Value $Password
	}
}
