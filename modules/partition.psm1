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

    # Clear the disk first
    Clear-Disk -Number $disk.Number -RemoveData -RemoveOEM -Confirm:$false

    # Initialize the disk with the selected partition style
    Initialize-Disk -Number $disk.Number -PartitionStyle $PartitionType

    if ($PartitionType -eq "GPT") {
        # For GPT, create EFI and MSR partitions first
        $efiSize = 260MB
        $msrSize = 128MB
        
        # Create EFI System Partition
        $efiPartition = New-Partition -DiskNumber $disk.Number -Size $efiSize -GptType "{c12a7328-f81f-11d2-ba4b-00a0c93ec93b}"
        Format-Volume -Partition $efiPartition -FileSystem FAT32 -NewFileSystemLabel "EFI" -Confirm:$false

        # Create MSR partition
        $msrPartition = New-Partition -DiskNumber $disk.Number -Size $msrSize -GptType "{e3c9e316-0b5c-4db8-817d-f92df00215ae}"

        # Calculate remaining size for Windows/Data partition
        if ($PartitionSize -gt 0) {
            $mainSize = $PartitionSize * 1GB
        } else {
            $mainSize = $diskSize - $efiSize - $msrSize
            if ($PartitionPurpose -eq "Windows") {
                $mainSize = [Math]::Round($mainSize * 0.5)
            }
        }

        # Create main partition
        $mainPartition = New-Partition -DiskNumber $disk.Number -Size $mainSize -AssignDriveLetter
        Format-Volume -Partition $mainPartition -FileSystem NTFS -NewFileSystemLabel $PartitionPurpose -Confirm:$false

        # If Windows partition and no specific size, create Data partition with remaining space
        if ($PartitionPurpose -eq "Windows" -and $PartitionSize -eq 0) {
            $remainingSize = $diskSize - $efiSize - $msrSize - $mainSize
            $dataPartition = New-Partition -DiskNumber $disk.Number -UseMaximumSize -AssignDriveLetter
            Format-Volume -Partition $dataPartition -FileSystem NTFS -NewFileSystemLabel "Data" -Confirm:$false
        }
    }
    else { # MBR
        # For MBR, create system reserved partition first
        $systemSize = 350MB
        
        # Create System Reserved partition
        $systemPartition = New-Partition -DiskNumber $disk.Number -Size $systemSize
        Format-Volume -Partition $systemPartition -FileSystem NTFS -NewFileSystemLabel "System Reserved" -Confirm:$false
        Set-Partition -InputObject $systemPartition -IsActive $true

        # Calculate size for Windows/Data partition
        if ($PartitionSize -gt 0) {
            $mainSize = $PartitionSize * 1GB
        } else {
            $mainSize = $diskSize - $systemSize
            if ($PartitionPurpose -eq "Windows") {
                $mainSize = [Math]::Round($mainSize * 0.5)
            }
        }

        # Create main partition
        $mainPartition = New-Partition -DiskNumber $disk.Number -Size $mainSize -AssignDriveLetter
        Format-Volume -Partition $mainPartition -FileSystem NTFS -NewFileSystemLabel $PartitionPurpose -Confirm:$false

        # If Windows partition and no specific size, create Data partition with remaining space
        if ($PartitionPurpose -eq "Windows" -and $PartitionSize -eq 0) {
            $remainingSize = $diskSize - $systemSize - $mainSize
            $dataPartition = New-Partition -DiskNumber $disk.Number -UseMaximumSize -AssignDriveLetter
            Format-Volume -Partition $dataPartition -FileSystem NTFS -NewFileSystemLabel "Data" -Confirm:$false
        }
    }

    # Return information about created partitions
    $partitionInfo = @{
        DiskNumber = $disk.Number
        PartitionStyle = $PartitionType
        MainPartition = $mainPartition
    }
    return $partitionInfo
}

Export-ModuleMember -Function Initialize-Partition