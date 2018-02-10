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

    param(
        [Parameter(
            Mandatory=$true,
            ValueFromPipeline=$true,
            ValueFromPipelineByPropertyName=$true)]
        [string]
        $InputObject
    )
    
    process {
        Write-Verbose -Message ("PROCESS - Encoding to base64: {0}" -f $InputObject)
        [System.convert]::ToBase64String([Text.Encoding]::UTF8.GetBytes($InputObject))
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
    
    param(
        [Parameter(
            Mandatory=$true,
            ValueFromPipeline=$true,
            ValueFromPipelineByPropertyName=$true)]
        [string]$InputObject
    )
    
    process {
        Write-Verbose -Message ("PROCESS - Decoding from base64: {0}" -f $InputObject)
        [System.Text.Encoding]::UTF8.GetString([System.Convert]::FromBase64String($InputObject))
    }
}
