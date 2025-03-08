# PartitionManager.ps1
# Functions for managing disk partitions

function Get-DiskPartitions {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $true)]
        [string]$DiskNumber
    )
    
    try {
        $partitions = Get-Partition -DiskNumber $DiskNumber
        return $partitions
    }
    catch {
        Write-Error "Failed to get partitions: $_"
        return $null
    }
}

function New-SystemPartition {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $true)]
        [string]$DiskNumber,
        
        [Parameter(Mandatory = $true)]
        [uint64]$Size,
        
        [Parameter(Mandatory = $true)]
        [string]$DriveLetter,
        
        [Parameter(Mandatory = $false)]
        [ValidateSet('Basic', 'Recovery', 'System', 'Reserved')]
        [string]$Type = 'Basic'
    )
    
    try {
        $partition = New-Partition -DiskNumber $DiskNumber -Size $Size -DriveLetter $DriveLetter
        return $partition
    }
    catch {
        Write-Error "Failed to create partition: $_"
        return $null
    }
}

function Format-SystemPartition {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $true)]
        [string]$DriveLetter,
        
        [Parameter(Mandatory = $false)]
        [ValidateSet('NTFS', 'FAT32', 'exFAT')]
        [string]$FileSystem = 'NTFS',
        
        [Parameter(Mandatory = $false)]
        [string]$Label
    )
    
    try {
        $result = Format-Volume -DriveLetter $DriveLetter -FileSystem $FileSystem -NewFileSystemLabel $Label -Confirm:$false
        return $result
    }
    catch {
        Write-Error "Failed to format partition: $_"
        return $null
    }
}

Export-ModuleMember -Function Get-DiskPartitions, New-SystemPartition, Format-SystemPartition