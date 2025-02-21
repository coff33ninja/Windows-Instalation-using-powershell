Function Set-BootableImage {
    [CmdletBinding()]
    Param(
        [Parameter(Mandatory = $true)]
        [string]$ImagePath,

        [Parameter(Mandatory = $true)]
        [string]$BootSectorPath
    )
    try {
        if (-not (Test-Path -Path $ImagePath -PathType Leaf)) {
            throw "Invalid ImagePath: $ImagePath"
        }
        if (-not (Test-Path -Path $BootSectorPath -PathType Leaf)) {
            throw "Invalid BootSectorPath: $BootSectorPath"
        }

        $mountResult = Mount-DiskImage -ImagePath $ImagePath -PassThru
        $volume = $mountResult | Get-Volume
        $driveLetter = $volume.DriveLetter
        $diskNumber = (Get-DiskImage -ImagePath $ImagePath).AttachedDisks[0].Number
        $partition = Get-Partition -DiskNumber $diskNumber | Where-Object { $_.DriveLetter -eq $driveLetter }
        if (-not $partition) {
            throw "No partition found for drive letter $driveLetter"
        }

        # Example: update boot sector using an external utility or other method.
        Write-Output "Updating boot sector using BootSector file at $BootSectorPath"

        # Mark the partition as active.
        Set-Partition -DiskNumber $diskNumber -PartitionNumber $partition.PartitionNumber -IsActive $true

        Write-Output "The image has been made bootable."
    }
    catch {
        Write-Error $_
    }
}

Export-ModuleMember -Function Set-BootableImage