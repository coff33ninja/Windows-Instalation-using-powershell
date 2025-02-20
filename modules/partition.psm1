function Initialize-Partition {
    param(
        [Parameter(Mandatory = $true)]
        [string]$DriveLetter,

        [Parameter(Mandatory = $true)]
        [ValidateSet("MBR", "GPT")]
        [string]$PartitionType,

        [Parameter(Mandatory = $true)]
        [ValidateSet("Windows", "Data")]
        [string]$PartitionPurpose,

        [Parameter(Mandatory = $false)]
        [int]$PartitionSize = 0
    )

    # Get the volume and disk for the specified drive letter
    $volume = Get-Volume -DriveLetter $DriveLetter -ErrorAction Stop
    $disk = Get-Disk -Number $volume.DiskNumber -ErrorAction Stop
    $diskSize = $disk.Size

    if ($PartitionSize -gt 0) {
        $windowsSize = $PartitionSize * 1GB
    }
    else {
        $windowsSize = [Math]::Round($diskSize * 0.5)
    }

    # Create a new partition.
    $partition = New-Partition -DiskNumber $disk.Number -UseMaximumSize:$false -Size $windowsSize -AssignDriveLetter

    if ($PartitionPurpose -eq "Windows") {
        $label = "Windows"
    }
    else {
        $label = "Data"
    }

    Format-Volume -Partition $partition -FileSystem NTFS -NewFileSystemLabel $label -Confirm:$false

    # If creating Windows partition without a user-specified size, create a second partition for Data.
    if ($PartitionPurpose -eq "Windows" -and $PartitionSize -eq 0) {
        $dataSize = $diskSize - $windowsSize
        $secondPartition = New-Partition -DiskNumber $disk.Number -Size $dataSize -AssignDriveLetter
        Format-Volume -Partition $secondPartition -FileSystem NTFS -NewFileSystemLabel "Data" -Confirm:$false
    }
}