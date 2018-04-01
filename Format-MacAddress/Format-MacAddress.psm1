function Format-MacAddress
{
<#
    .SYNOPSIS
        Formats a string MAC address.

    .DESCRIPTION
        The Format-MacAddress cmdlet to cleanup a MACAddress string

    .PARAMETER MacAddress
        Specifies the MacAddress

    .PARAMETER Separator
        Specifies the separator every two characters

    .PARAMETER Uppercase
        Specifies the output must be Uppercase

    .PARAMETER Lowercase
        Specifies the output must be LowerCase

    .EXAMPLE
        Format-MacAddress -MacAddress 00:11:22:33:44:55

        001122334455
    .EXAMPLE
        Format-MacAddress -MacAddress 00:11:22:dD:ee:FF -Uppercase

        001122DDEEFF

    .EXAMPLE
        Format-MacAddress -MacAddress 00:11:22:dD:ee:FF -Lowercase

        001122ddeeff

    .EXAMPLE
        Format-MacAddress -MacAddress 00:11:22:dD:ee:FF -Lowercase -Separator -

        00-11-22-dd-ee-ff

    .EXAMPLE
        Format-MacAddress -MacAddress 00:11:22:dD:ee:FF -Lowercase -Separator .

        00.11.22.dd.ee.ff

    .EXAMPLE
        Format-MacAddress -MacAddress 00:11:22:dD:ee:FF -Lowercase -Separator :

        00:11:22:dd:ee:ff
#>

    [CmdletBinding(
        DefaultParameterSetName='Upper')]

    param(
        [Parameter(
            ParameterSetName='Lower')]
        [Parameter(
            ParameterSetName='Upper')]
        [String]
        $MacAddress,

        [Parameter(
            ParameterSetName='Lower')]
        [Parameter(
            ParameterSetName='Upper')]
        [ValidateSet(':','.',"-")]
        [string]
        $Separator,

        [Parameter(
            ParameterSetName='Upper')]
        [Switch]
        $Uppercase,

        [Parameter(
            ParameterSetName='Lower')]
        [Switch]
        $Lowercase
    )

    process {

        $MacAddress = $MacAddress -replace '-', ''
        $MacAddress = $MacAddress -replace ':', ''
        $MacAddress = $MacAddress -replace '/s', ''
        $MacAddress = $MacAddress -replace ' ', ''
        $MacAddress = $MacAddress -replace '\.', ''

        switch ($MacAddress) {
            'Uppercase' { $MacAddress.ToUpper(); break }
            'Lowercase' { $MacAddress.ToLower(); break }
        }

        if ($PSBoundParameters['Separator']) {
            $MacAddress = $MacAddress -replace '(..(?!$))', "`$1$Separator"
        }

        $MacAddress
    }
}
