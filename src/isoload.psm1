function Mount-IsoImage {
    param(
        [Parameter(Mandatory = $true)]
        [string]$IsoPath
    )

    if (-not (Test-Path $IsoPath)) {
        throw "The specified ISO file does not exist: $IsoPath"
    }

    $mountResult = Mount-DiskImage -ImagePath $IsoPath -PassThru
    $driveLetter = ($mountResult | Get-Volume).DriveLetter
    return $driveLetter
}