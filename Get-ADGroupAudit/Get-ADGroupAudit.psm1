function Get-ADGroupAudit {
<#
.SYNOPSIS
    Get the group owner and list of members.

.DESCRIPTION
    The Get-ADGroupAudit cmdlet gets the group owner and list of members.

.EXAMPLE
    PS C:\> Get-ADGroupAudit -Identity GROUP01

.EXAMPLE
    PS C:\> Get-ADGroupAudit -Identity GROUP01,GROUP02,GROUP03

.EXAMPLE
    PS C:\> Get-Content -Path C:\something.txt | Get-ADGroupAudit
#>

    [CmdletBinding()]

    param (
        [parameter(
            Mandatory=$true,
            ValueByPipeline=$true,
            ValueFromPipelineByPropertyName=$true,
            Position=0)]
        [alias('ADGroup')]
        [string[]]
        $Identity
    )

    process {
        $Splatting = {
            SearchBase = 'OU=Group,DC=contoso,DC=com'
            Properties = 'ManagedBy','Members','Description'
        }

        foreach ( $Group in (Get-ADGroup @Splatting -Identity $Identity) ) {
            if ($Group.ManagedBy) {
                $ManagedBy = Get-ADUser -Identity $Group.ManagedBy -Properties 'Name', 'Mail'
            }

            $Members = New-Object -TypeName System.Net.Array.List
            foreach ($Member In $Group.Members) {
                $Members.Add( ( ($Member.Split(',') )[0]).Replace('CN=', '') )
            }

            [PSCustomObject]@{
                PSTypeName    = 'ADGroupAudit'
                Group         = $Group.Name
                ManagedByName = $ManagedBy.Name
                ManagedByMail = $ManagedBy.Mail
                Members       = $Members
            }
        }
    }
}
