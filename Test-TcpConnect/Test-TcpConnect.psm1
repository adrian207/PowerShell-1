function Test-TcpConnect {
<#
.SYNOPSIS
    This function 

.DESCRIPTION
    This function 

.EXAMPLE
    Test-TcpConnect -ComputerName COMPUTER01

.EXAMPLE
    Test-TcpConnect -ComputerName COMPUTER01,COMPUTER02,COMPUTER03

.EXAMPLE
    Get-Content -Path c:\something.txt | Test-TcpConnect
#>

    [CmdletBinding()]

    param(
        [parameter(
            Mandatory=$true,
            ValueFromPipeline=$true,
            ValueFromPipelineByPropertyName=$true,
            Position=0)]
        [alias("IPAddress")]
        [string[]]$ComputerName
    )

    process {
        foreach ($Computer in $ComputerName) {
            $Name = $Computer.ToUpper()
            $Ports = @(
                22,     #SSH
                23,     #Telnet
                25,     #SNMP
                80,     #HTTP
                443,    #HTTPS
                8080,   #HTTP alternative
                8443    #HTTPS alternative
            )

            foreach ($Port in $Ports) {
                $Splatting = @{
                    ComputerName  = $Name
                    Port          = $Port
                    WarningAction = 'SilentlyContinue'
                }
                $Result = Test-NetConnection @Splatting

                New-Object -TypeName 'PSCustomObject' -Property @{
                    'Remote Port'        = $Result.RemotePort
                    'TCP Test Succeeded' = $Result.TcpTestSucceeded
                }
            }
        }
    }
}
