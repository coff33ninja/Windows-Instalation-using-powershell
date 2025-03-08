# ImageParser.ps1
# Functions for parsing Windows image files

function Get-ISOContent {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $true)]
        [string]$ISOPath
    )
    
    try {
        # Mount ISO and get contents
        $mountResult = Mount-DiskImage -ImagePath $ISOPath -PassThru
        $driveLetter = ($mountResult | Get-Volume).DriveLetter
        
        $isoContent = Get-ChildItem -Path "$($driveLetter):\*" -Recurse
        
        # Cleanup
        Dismount-DiskImage -ImagePath $ISOPath
        
        return $isoContent
    }
    catch {
        Write-Error "Failed to parse ISO: $_"
        return $null
    }
}

function Get-WIMInfo {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $true)]
        [string]$WIMPath
    )
    
    try {
        $wimInfo = Get-WindowsImage -ImagePath $WIMPath
        return $wimInfo
    }
    catch {
        Write-Error "Failed to get WIM info: $_"
        return $null
    }
}

function Get-ESDInfo {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $true)]
        [string]$ESDPath
    )
    
    try {
        $esdInfo = Get-WindowsImage -ImagePath $ESDPath
        return $esdInfo
    }
    catch {
        Write-Error "Failed to get ESD info: $_"
        return $null
    }
}

Export-ModuleMember -Function Get-ISOContent, Get-WIMInfo, Get-ESDInfo