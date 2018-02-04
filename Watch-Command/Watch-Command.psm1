function Watch-Command {
<#

#>
    [CmdletBinding()]

    param(
        [parmeter()]
        $Command
    )

    process {
        Clear-Host
    
        $Old = & $Command
        while ($true) {
            Clear-Host
    
            $New = & $Command | $Null
            foreach 
    
    
            #switch ($Item.Extension)  
            #{ 
            #    ".Exe" {$Host.UI.RawUI.ForegroundColor = "Yellow"}
            #    ".cmd" {$Host.UI.RawUI.ForegroundColor = "Red"}
            #} 
            if ($Item.Mode.StartsWith("d")) {$Host.UI.RawUI.ForegroundColor = "Green"}
            $Item
        }
        
    }
}
