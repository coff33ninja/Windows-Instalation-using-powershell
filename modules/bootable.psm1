Function Make-ImageBootable {
    [CmdletBinding()]
    Param(
        [Parameter(Mandatory = $true)]
        [string]$ImagePath,

        [Parameter(Mandatory = $true)]
        [string]$BootSectorPath
    )
    try {
        # Check if ImagePath and BootSectorPath are valid
        if (-not (Test-Path -Path $ImagePath -PathType Leaf)) {
            throw "Invalid ImagePath: $ImagePath"
        }
        if (-not (Test-Path -Path $BootSectorPath -PathType Leaf)) {
            throw "Invalid BootSectorPath: $BootSectorPath"
        }

        # Get drive letter of the image file
        $driveLetter = (Mount-DiskImage -ImagePath $ImagePath | Get-Volume).DriveLetter

        # Get disk number of the drive containing the image file
        $diskNumber = (Get-DiskImage -ImagePath $ImagePath).AttachedDisks[0].DiskNumber

        # Get partition number of the partition containing the image file
        $partitionNumber = (Get-Partition -DriveLetter $driveLetter).PartitionNumber

        # Set the boot sector
        Set-Partition -DiskNumber $diskNumber -PartitionNumber $partitionNumber -NewDiskSector $BootSectorPath

        # Mark the partition as active
        Set-Partition -DiskNumber $diskNumber -PartitionNumber $partitionNumber -IsActive $true

        Write-Output "The image has been made bootable."
    }
    catch {
        Write-Error $_
    }
}
