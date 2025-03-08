# DiskManager.ps1
# Main disk management functionality

function Initialize-DiskManager {
    [CmdletBinding()]
    param()
    
    Write-Verbose "Initializing Disk Manager"
}

function Get-SystemDisks {
    [CmdletBinding()]
    param()
    
    try {
        $disks = Get-Disk
        return $disks
    }
    catch {
        Write-Error "Failed to get system disks: $_"
        return $null
    }
}

function New-DiskPartitionLayout {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $true)]
        [string]$DiskNumber,
        
        [Parameter(Mandatory = $true)]
        [ValidateSet('BIOS', 'UEFI')]
        [string]$BootMode,
        
        [Parameter(Mandatory = $false)]
        [switch]$Force
    )
    
    try {
        # Load appropriate diskpart script based on boot mode
        $scriptPath = Join-Path $PSScriptRoot "Diskpart\$BootMode.txt"
        if (-not (Test-Path $scriptPath)) {
            throw "Diskpart script not found for boot mode: $BootMode"
        }
        
        # Create temporary script with disk number
        $tempScript = [System.IO.Path]::GetTempFileName()
        $scriptContent = Get-Content $scriptPath
        $scriptContent = $scriptContent -replace 'select disk 0', "select disk $DiskNumber"
        $scriptContent | Set-Content $tempScript
        
        # Execute diskpart script
        $result = diskpart /s $tempScript
        
        # Cleanup
        Remove-Item $tempScript -Force
        
        return $result
    }
    catch {
        Write-Error "Failed to create partition layout: $_"
        return $false
    }
}

Export-ModuleMember -Function Initialize-DiskManager, Get-SystemDisks, New-DiskPartitionLayout