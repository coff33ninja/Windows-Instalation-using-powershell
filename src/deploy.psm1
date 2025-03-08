function Install-Windows {
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

    if (-not (Test-Path $DestinationDrive) -or (Get-Volume -DriveLetter $DestinationDrive).DriveType -ne 'Fixed') {
        throw "The specified destination drive is not a valid, writable hard drive: $DestinationDrive"
    }

    if ($PartitionStyle -eq "MBR") {
        $systemPartition = Get-Partition -DriveLetter $DestinationDrive -PartitionNumber 1 -ErrorAction SilentlyContinue
        if (-not $systemPartition) {
            New-Partition -DiskNumber (Get-Disk -DriveLetter $DestinationDrive).Number -Size 350MB -AssignDriveLetter | Out-Null
            Format-Volume -DriveLetter "$($DestinationDrive)1" -FileSystem NTFS -Force | Out-Null
            $systemPartition = Get-Partition -DriveLetter $DestinationDrive -PartitionNumber 1
            Set-Partition -Partition $systemPartition -NewDriveLetter S -ErrorAction Stop
            Add-PartitionAccessPath -Partition $systemPartition -AccessPath "S:\"
        }
    }

    $installIndex = "$WindowsVersionIndex" + ",1"
    if (Test-Path (Join-Path $ImagePath "sources\install.wim")) {
        dism /Apply-Image /ImageFile:(Join-Path $ImagePath "sources\install.wim") /Index:$installIndex /ApplyDir:"$($DestinationDrive):" /CheckIntegrity /Verify /LogLevel:4
    }
    else {
        dism /Apply-Image /ImageFile:(Join-Path $ImagePath "sources\install.esd") /Index:$installIndex /ApplyDir:"$($DestinationDrive):" /CheckIntegrity /Verify /LogLevel:4
    }
}

Export-ModuleMember -Function Install-Windows