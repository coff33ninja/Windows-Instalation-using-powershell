# Import required modules
Import-Module "$PSScriptRoot\detect.psm1" -ErrorAction Stop

function Show-Settings {
    param(
        [System.Windows.Forms.Label]$StatusLabel,
        [System.Windows.Forms.RichTextBox]$LogBox
    )
    
    $settingsForm = New-GuiMenu -Title "Settings" -Width 500 -Height 400
    
    $settingsGroup = New-GuiGroupBox -Text "Application Settings" -Width 460 -Height 320
    $settingsGroup.Location = New-Object System.Drawing.Point(10, 10)
    
    # Add settings controls here
    $settingsForm.Controls.Add($settingsGroup)
    $settingsForm.ShowDialog()
}

function Show-DiskManager {
    param(
        [System.Windows.Forms.Label]$StatusLabel,
        [System.Windows.Forms.RichTextBox]$LogBox
    )
    
    $diskForm = New-GuiMenu -Title "Disk Manager" -Width 800 -Height 600
    
    $diskGroup = New-GuiGroupBox -Text "Disk Management" -Width 760 -Height 520
    $diskGroup.Location = New-Object System.Drawing.Point(10, 10)
    
    # Add disk management controls here
    $diskForm.Controls.Add($diskGroup)
    $diskForm.ShowDialog()
}

function Show-DriverManager {
    param(
        [System.Windows.Forms.Label]$StatusLabel,
        [System.Windows.Forms.RichTextBox]$LogBox
    )
    
    $driverForm = New-GuiMenu -Title "Driver Manager" -Width 700 -Height 500
    
    $driverGroup = New-GuiGroupBox -Text "Driver Management" -Width 660 -Height 420
    $driverGroup.Location = New-Object System.Drawing.Point(10, 10)
    
    # Add driver management controls here
    $driverForm.Controls.Add($driverGroup)
    $driverForm.ShowDialog()
}

function Show-BackupRestore {
    param(
        [System.Windows.Forms.Label]$StatusLabel,
        [System.Windows.Forms.RichTextBox]$LogBox
    )
    
    $backupForm = New-GuiMenu -Title "Backup/Restore" -Width 600 -Height 450
    
    $backupGroup = New-GuiGroupBox -Text "Backup and Restore" -Width 560 -Height 370
    $backupGroup.Location = New-Object System.Drawing.Point(10, 10)
    
    # Add backup/restore controls here
    $backupForm.Controls.Add($backupGroup)
    $backupForm.ShowDialog()
}

function Show-CustomizeWindows {
    param(
        [System.Windows.Forms.Label]$StatusLabel,
        [System.Windows.Forms.RichTextBox]$LogBox
    )
    
    $customizeForm = New-GuiMenu -Title "Customize Windows" -Width 700 -Height 500
    
    $customizeGroup = New-GuiGroupBox -Text "Windows Customization" -Width 660 -Height 420
    $customizeGroup.Location = New-Object System.Drawing.Point(10, 10)
    
    # Add customization controls here
    $customizeForm.Controls.Add($customizeGroup)
    $customizeForm.ShowDialog()
}

function Show-LogViewer {
    param(
        [System.Windows.Forms.Label]$StatusLabel,
        [System.Windows.Forms.RichTextBox]$LogBox
    )
    
    $logViewerForm = New-GuiMenu -Title "Log Viewer" -Width 800 -Height 600
    
    $logViewerGroup = New-GuiGroupBox -Text "Operation Logs" -Width 760 -Height 520
    $logViewerGroup.Location = New-Object System.Drawing.Point(10, 10)
    
    $logViewerBox = New-GuiLogBox -Width 740 -Height 460
    $logViewerBox.Location = New-Object System.Drawing.Point(10, 20)
    $logViewerBox.Text = $LogBox.Text
    
    $logViewerGroup.Controls.Add($logViewerBox)
    $logViewerForm.Controls.Add($logViewerGroup)
    $logViewerForm.ShowDialog()
}

Export-ModuleMember -Function Show-Settings, Show-DiskManager, Show-DriverManager, 
    Show-BackupRestore, Show-CustomizeWindows, Show-LogViewer