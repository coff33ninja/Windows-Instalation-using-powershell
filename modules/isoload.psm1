function Load-Iso {
    param(
        [Parameter(Mandatory = $true)]
        [string]$IsoPath
    )

    # Check if the ISO file exists
    if (-not (Test-Path $IsoPath)) {
        throw "The specified ISO file does not exist: $IsoPath"
    }

    # Mount the ISO file
    $mountResult = Mount-DiskImage -ImagePath $IsoPath -PassThru

    # Get the drive letter of the mounted ISO file
    $driveLetter = ($mountResult | Get-Volume).DriveLetter

    # Return the drive letter of the mounted ISO file
    return $driveLetter
}
