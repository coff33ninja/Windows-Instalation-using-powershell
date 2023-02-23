function Get-HardDrive {
    # Get the list of hard drives on the system
    $drives = Get-WmiObject -Class Win32_DiskDrive

    # Create an empty array to store the hard drive names
    $driveNames = @()

    # Loop through each hard drive and add its name to the array
    foreach ($drive in $drives) {
        $driveNames += $drive.Model
    }

    # Show the list of hard drives to the user and ask them to select one
    $selectedDrive = $null
    while ($selectedDrive -eq $null) {
        Write-Host "Please select a hard drive:"
        $driveNames | ForEach-Object { Write-Host $_ }
        $input = Read-Host
        $selectedDrive = $drives | Where-Object { $_.Model -eq $input }
        if ($selectedDrive -eq $null) {
            Write-Host "Invalid selection, please try again."
        }
    }

    # Return the selected hard drive object
    return $selectedDrive
}
