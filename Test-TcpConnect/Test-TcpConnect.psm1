function Test-TcpConnect {
<#
.SYNOPSIS
    Tests TCP handshake connections on common ports.

.DESCRIPTION
    The Test-TcpConnect cmdlet initiates a TCP handshake on common ports and returns true or false.

.EXAMPLE
    PS C:\> Test-TcpConnect -ComputerName COMPUTER01

.EXAMPLE
    PS C:\> Test-TcpConnect -ComputerName COMPUTER01,COMPUTER02,COMPUTER03

.EXAMPLE
    PS C:\> Get-Content -Path C:\servers.txt | Test-TcpConnect
#>

    [CmdletBinding()]

    param(
        [parameter(
            Mandatory=$false,
            ValueFromPipeline=$true,
            ValueFromPipelineByPropertyName=$true,
            Position=0)]
        [alias('CN','__Server','IPAddress')]
        [string[]]
        $ComputerName = $env:ComputerName
    )

    process {
        $CommonPort = @(
            20,     #FTP data
            21,     #FTP control
            22,     #SSH
            23,     #Telnet
            25,     #SMTP
            80,     #HTTP
            88,     #Kerberos
            161,    #SNMP
            443,    #HTTPS
            8080,   #HTTP alternative
            8443    #HTTPS alternative
        )

        foreach ($Computer in $ComputerName) {

            foreach ($Port in $CommonPort) {
                $ScriptBlock = {
                    param ($Computer,$Port)
                    Test-NetConnection -ComputerName $Computer -Port $Port -ErrorAction SilentlyContinue -WarningAction SilentlyContinue
                }
                Start-Job -ScriptBlock $ScriptBlock -ArgumentList $Computer,$Port | Out-Null
            }

            do {
                $more = $false
                
                foreach ($_ in Get-Job) {
                    if ($_.State -eq 'Completed') {
                        $Job = Receive-Job -Job $_

                        [PSCustomObject]@{
                            PSTypeName       = 'TcpConnectResult'
                            Source           = $env:ComputerName.ToUpper()
                            Destination      = $Job.ComputerName
                            IPv4Address      = $Job.RemoteAddress
                            DestinationPort  = $Job.RemotePort
                            TcpTestSucceeded = $Job.TcpTestSucceeded
                            InterfaceAlias   = $Job.InterfaceAlias
                        }
                        Remove-Job -Job $_
                    }
                    $more = $true

                    Start-Sleep -Milliseconds 500
                }
            } while ($more -ne $false)
        }
    }
}
