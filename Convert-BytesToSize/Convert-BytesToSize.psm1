function Convert-BytesToSize {
<#
.SYNOPSIS
    Converts any integer size given to a user friendly size.

.DESCRIPTION
    Converts any integer size given to a user friendly size.

.PARAMETER Size

.EXAMPLE
    PS> Convert-BytesToSize -Size 134217728

    Converts size to show 128MB
#>

    [CmdletBinding()]

    param(
        [parameter(
            Mandatory=$true,
            ValueFromPipelineByPropertyName=$true,
            Position = 0)]
        [int64]
        $Size,

        [parameter(
            Mandatory=$false,
            ValueFromPipelineByPropertyName=$true,
            Position = 1)]
        [int]
        $Precision = 2
    )

    #Decide what is the type of size
    switch ($Size) {
        {$Size -gt 1PB} { $NewSize = "$([math]::Round(($Size / 1PB),$Precision))PB" }
        {$Size -gt 1TB} { $NewSize = "$([math]::Round(($Size / 1TB),$Precision))TB" }
        {$Size -gt 1GB} { $NewSize = "$([math]::Round(($Size / 1GB),$Precision))GB" }
        {$Size -gt 1MB} { $NewSize = "$([math]::Round(($Size / 1MB),$Precision))MB" }
        {$Size -gt 1KB} { $NewSize = "$([math]::Round(($Size / 1KB),$Precision))KB" }
        Default { $NewSize = "$([math]::Round($Size,$Precision))Bytes" }
    }

    [PSCustomObject]@{
        PSTypeName = 'ConvertBytesToSize'
        NewSize    = $NewSize
    }
}
