function Deploy-Windows {
    param(
        [Parameter(Mandatory = $true)]
        [string]$ImagePath,
        [Parameter(Mandatory = $true)]
        [string]$DestinationDrive,
        [Parameter(Mandatory = $true)]
        [string]$WindowsVersionIndex,
        [Parameter(Mandatory = $true)]
        [string]$PartitionStyle
    )

    # Check if the specified destination drive is valid and writable
    if (-not (Test-Path $DestinationDrive) -or (Get-Volume -DriveLetter $DestinationDrive).DriveType -ne 'Fixed') {
        throw "The specified destination drive is not a valid, writable hard drive: $DestinationDrive"
    }

    # If the destination drive is using the MBR partition style, check if it has a system partition and create one if not
    if ($PartitionStyle -eq "MBR") {
        $systemPartition = Get-Partition -DriveLetter $DestinationDrive -PartitionNumber 1 -ErrorAction SilentlyContinue
        if (-not $systemPartition) {
            New-Partition -DiskNumber (Get-Disk -DriveLetter $DestinationDrive).Number -Size 350MB -AssignDriveLetter | Format-List
            Format-Volume -DriveLetter "$DestinationDrive"1 -FileSystem NTFS -Force | Format-List
            $systemPartition = Get-Partition -DriveLetter $DestinationDrive -PartitionNumber 1
            Set-Partition -Partition $systemPartition -NewDriveLetter S -ErrorAction Stop
            Add-PartitionAccessPath -Partition $systemPartition -AccessPath "S:\"
        }
    }

    # Apply the Windows image to the destination drive using the DISM tool
    $installIndex = "$WindowsVersionIndex" + ",1"
    if (Test-Path "$ImagePath\sources\install.wim") {
        dism /Apply-Image /ImageFile:$ImagePath\sources\install.wim /Index:$installIndex /ApplyDir:$DestinationDrive:\ /CheckIntegrity /Verify /LogLevel:4
    }
    else {
        dism /Apply-Image /ImageFile:$ImagePath\sources\install.esd /Index:$installIndex /ApplyDir:$DestinationDrive:\ /CheckIntegrity /Verify /LogLevel:4
    }
}
