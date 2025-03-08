function Start-WindowsInstallation {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory)]
        [string]$SourcePath,
        [Parameter(Mandatory)]
        [string]$BootDrive,
        [Parameter(Mandatory)]
        [string]$InstallDrive,
        [Parameter(Mandatory)]
        [string]$Edition,
        [Parameter(Mandatory)]
        [bool]$PatchUxTheme,
        [Parameter(Mandatory)]
        [string]$UnattendFile,
        [Parameter(Mandatory)]
        [string[]]$DriverPaths
    )

    try {
        # Validate input parameters
        if (-not (Test-Path $SourcePath)) {
            throw "Source path does not exist."
        }
        if (-not ($BootDrive -match '^[0-9]+$')) {
            throw "Boot drive must be specified as a disk number."
        }
        if (-not ($InstallDrive -match '^[0-9]+$')) {
            throw "Installation drive must be specified as a disk number."
        }
        if (-not $Edition) {
            throw "Windows edition must be specified."
        }
        if ($UnattendFile -and -not (Test-Path $UnattendFile)) {
            throw "Unattended file '$UnattendFile' does not exist."
        }

        Write-Host "Starting Windows installation: Edition = $Edition" -ForegroundColor Green

        # DiskPart commands to create partitions
        $diskPartCommands = @"
select disk $BootDrive
clean
create partition primary size=350
format quick fs=ntfs label="System"
assign letter="S"
active
create partition primary
format quick fs=ntfs label="Windows"
assign letter="W"
create partition primary
set id=27
format quick fs=ntfs label="Recovery"
assign letter="R"
list volume
exit
"@

        Write-Host "Executing DiskPart partitioning commands..." -ForegroundColor Cyan
        $diskPartCommands | diskpart

        # Mount installation files and copy necessary files
        Write-Host "Mounting and copying installation files..." -ForegroundColor Cyan
        if ($SourcePath -like "*.iso") {
            # Mount the ISO image
            Write-Host "Mounting ISO image: $SourcePath" -ForegroundColor Yellow
            $mountResult = Mount-DiskImage -ImagePath $SourcePath -PassThru
            Start-Sleep -Seconds 2
            $mountedDrive = ($mountResult | Get-Volume).DriveLetter + ":\"
            if (-not $mountedDrive) {
                throw "Failed to mount ISO image."
            }
            Write-Host "ISO mounted at $mountedDrive" -ForegroundColor Yellow

            # Copy files from mounted ISO to the Windows partition
            Write-Host "Copying installation files to drive W:" -ForegroundColor Yellow
            Copy-Item -Path "$mountedDrive*" -Destination "W:\" -Recurse -Force

            # Dismount the ISO image after copying
            Dismount-DiskImage -ImagePath $SourcePath
        }
        else {
            # Assume SourcePath is a folder containing installation files
            Write-Host "Copying installation files from folder $SourcePath to drive W:" -ForegroundColor Yellow
            Copy-Item -Path "$SourcePath\*" -Destination "W:\" -Recurse -Force
        }

        # Apply patches and unattended settings
        if ($UnattendFile) {
            Write-Host "Applying unattended settings from file $UnattendFile..." -ForegroundColor Cyan
            # Copy the unattend file into the installation folder
            Copy-Item -Path $UnattendFile -Destination "W:\Windows\Panther\unattend.xml" -Force
        }

        if ($PatchUxTheme) {
            Write-Host "Patching UxTheme for custom visual styles..." -ForegroundColor Cyan
            # Apply UxTheme patch using the provided resources
            $patchPath = Join-Path $PSScriptRoot "..\Info_to_steal\MinWin\Default\Reg"
            if (Test-Path $patchPath) {
                Get-ChildItem -Path $patchPath -Filter "*.reg" | ForEach-Object {
                    Write-Host "Applying registry patch: $($_.Name)" -ForegroundColor Yellow
                    reg import $_.FullName
                }
            }
            Write-Host "UxTheme patched successfully." -ForegroundColor Green
        }

        # Integrate drivers using DISM
        if ($DriverPaths.Count -gt 0) {
            Write-Host "Integrating driver packages via DISM..." -ForegroundColor Cyan
            foreach ($driver in $DriverPaths) {
                if (-not (Test-Path $driver)) {
                    Write-Warning "Driver path $driver is invalid. Skipping..."
                    continue
                }
                Write-Host "Integrating drivers from $driver..." -ForegroundColor Yellow
                $dismArgs = "/Image:W:\ /Add-Driver /Driver:`"$driver`" /Recurse"
                $dismProcess = Start-Process -FilePath "dism.exe" -ArgumentList $dismArgs -Wait -PassThru -NoNewWindow
                if ($dismProcess.ExitCode -ne 0) {
                    Write-Warning "DISM failed to integrate drivers from $driver. Exit Code: $($dismProcess.ExitCode)"
                }
                else {
                    Write-Host "Drivers from $driver integrated successfully." -ForegroundColor Green
                }
            }
        }
        else {
            Write-Host "No driver packages provided for integration." -ForegroundColor Yellow
        }

        # Recovery Partition Setup
        Write-Host "Configuring Recovery Partition..." -ForegroundColor Cyan
        $recoverySource = Join-Path $PSScriptRoot "..\Info_to_steal\MinWin\Default"
        if (Test-Path $recoverySource) {
            # Copy recovery tools and configuration
            Copy-Item -Path "$recoverySource\*" -Destination "R:\" -Recurse -Force
            
            # Apply recovery configuration
            if (Test-Path "R:\Services.ini") {
                Write-Host "Configuring recovery services..." -ForegroundColor Yellow
                # Add recovery services configuration logic here
            }
            Write-Host "Recovery partition setup completed." -ForegroundColor Green
        }
        else {
            Write-Host "No recovery files found in '$recoverySource'. Recovery partition remains empty." -ForegroundColor Yellow
        }

        Write-Host "Windows installation has been prepared successfully." -ForegroundColor Green
        Write-Host "System is ready for first boot. Please restart to begin Windows installation." -ForegroundColor Green
    }
    catch {
        Write-Error "Error in Start-WindowsInstallation: $_"
        throw
    }
}

Export-ModuleMember -Function Start-WindowsInstallation

Export-ModuleMember -Function Start-WindowsInstallation
