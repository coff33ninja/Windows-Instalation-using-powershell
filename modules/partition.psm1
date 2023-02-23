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

    # Calculate the size of the drive in bytes
    $drive = Get-Partition -DriveLetter $DriveLetter
    $driveSize = $drive.Size

    # Convert the partition size from GB to bytes if necessary
    if ($PartitionSize -gt 0) {
        $PartitionSize = $PartitionSize * 1GB
    }

    # Calculate the size of the Windows partition based on the drive size
    $windowsSize = [Math]::Round($driveSize * 0.5)

    # If the user specified a partition size, use that instead
    if ($PartitionSize -gt 0) {
        $windowsSize = $PartitionSize
    }

    # Create the partition using the appropriate partition type
    if ($PartitionType -eq "MBR") {
        $partitionStyle = "MBR"
    } else {
        $partitionStyle = "GPT"
    }

    $partition = New-Partition -DiskNumber $drive.DiskNumber -Size $windowsSize -DriveLetter $DriveLetter -GptType $partitionStyle

    # Label the partition with the appropriate purpose
    if ($PartitionPurpose -eq "Windows") {
        $label = "Windows"
    } else {
        $label = "Data"
    }

    Set-Partition -DriveLetter $DriveLetter -NewFileSystemLabel $label

    # Create a second partition for data if necessary
    if ($PartitionPurpose -eq "Windows" -and $PartitionSize -eq 0) {
        $dataSize = $driveSize - $windowsSize
        $partition = New-Partition -DiskNumber $drive.DiskNumber -Size $dataSize -DriveLetter "$($DriveLetter)1" -GptType $partitionStyle
        Set-Partition -DriveLetter "$($DriveLetter)1" -NewFileSystemLabel "Data"
    }
}
