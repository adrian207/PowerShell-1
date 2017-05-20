function Encode-Base64 {
<#
.SYNOPSIS
	This function takes a string and encodes it to base64.

.DESCRIPTION
	This function takes a string and encodes it to base64.

.EXAMPLE
	Encode-Base64 "The quick brown fox jumps over the lazy dog."
    
	VGhlIHF1aWNrIGJyb3duIGZveCBqdW1wcyBvdmVyIHRoZSBsYXp5IGRvZy4=

.EXAMPLE
	Out-File -FilePath c:\something.txt | Encode-Base64
#>

	[CmdletBinding()]

	Param(
	[Parameter(ValueFromPipeline = $True)]
		[String]$Object
	)
	
	Process {
		Try {
            		Write-Verbose -Message "[ConvertTo-Base64] Converting image to Base64 $Object"
	       		[System.convert]::ToBase64String([Text.Encoding]::UTF8.GetBytes($Object))
        	}
		Catch {
			Write-Warning "PROCESS - Something bad happened"
			Write-Warning -Message $Error[0].Exception.Message
		}
	}
}

function Decode-Base64 {
<#
.SYNOPSIS
	This function takes a base64 string and decodes it.

.DESCRIPTION
	This function takes a base64 string and decodes it.

.EXAMPLE
	Decode-Base64 VGhlIHF1aWNrIGJyb3duIGZveCBqdW1wcyBvdmVyIHRoZSBsYXp5IGRvZy4=

	The quick brown fox jumps over the lazy dog.

.EXAMPLE
	Out-File -FilePath c:\something.txt | Decode-Base64
#>

	[CmdletBinding()]
	
	Param(
        	[Parameter(ValueFromPipeline = $True)]
		[String]$Object
    	)
	
	Process {
		Try {
            		Write-Verbose -Message "[ConvertTo-Base64] Converting image to Base64 $Object"
            		[System.Text.Encoding]::UTF8.GetString([System.Convert]::FromBase64String($Object))
        	}
		Catch {
			Write-Warning "PROCESS - Something bad happened"
			Write-Warning -Message $Error[0].Exception.Message
		}
	}
}
