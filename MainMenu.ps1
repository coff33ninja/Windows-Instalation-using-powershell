# Initialize theme
$theme = @{
    Primary = "#007bff"
}

# Import the necessary modules and GUI elements
try {
    Import-Module .\gui-elements\Gui.psm1 -ErrorAction Stop
    Import-Module .\Modules\detect.psm1
    Import-Module .\Modules\partition.psm1
    Import-Module .\Modules\isoload.psm1
    Import-Module .\Modules\selectversion.psm1
    Import-Module .\Modules\deploy.psm1
    Import-Module .\Modules\bootable.psm1
} catch {
    [System.Windows.Forms.MessageBox]::Show("Error importing modules: $_", "Error", 
        [System.Windows.Forms.MessageBoxButtons]::OK, [System.Windows.Forms.MessageBoxIcon]::Error)
    exit
}

# Define the main menu
try {
    $MainMenu = New-GuiMenu -Title "Windows Deployment Tool" -Width 800 -Height 600
    # Show the form
    [void]$MainMenu.ShowDialog()
} catch {
    [System.Windows.Forms.MessageBox]::Show("Error creating main menu: $_", "Error", 
        [System.Windows.Forms.MessageBoxButtons]::OK, [System.Windows.Forms.MessageBoxIcon]::Error)
    exit
}

# Create main menu strip
$menuStrip = New-Object System.Windows.Forms.MenuStrip
$menuStrip.BackColor = [System.Drawing.ColorTranslator]::FromHtml($theme.Primary)

# File Menu
$fileMenu = New-GuiMenuItem -Text "File"
$exitItem = New-GuiMenuItem -Text "Exit" -Action { $MainMenu.Close() }
$fileMenu.DropDownItems.Add($exitItem)

# Tools Menu
$toolsMenu = New-GuiMenuItem -Text "Tools"
$settingsItem = New-GuiMenuItem -Text "Settings" -Action { 
    [System.Windows.Forms.MessageBox]::Show("Settings feature coming soon.", "Information",
        [System.Windows.Forms.MessageBoxButtons]::OK, [System.Windows.Forms.MessageBoxIcon]::Information)
}
$toolsMenu.DropDownItems.Add($settingsItem)

# Help Menu
$helpMenu = New-GuiMenuItem -Text "Help"
$aboutItem = New-GuiMenuItem -Text "About" -Action {
    [System.Windows.Forms.MessageBox]::Show("Windows Deployment Tool`nVersion 1.0", "About",
        [System.Windows.Forms.MessageBoxButtons]::OK, [System.Windows.Forms.MessageBoxIcon]::Information)
}
$helpMenu.DropDownItems.Add($aboutItem)

# Add menus to menu strip
$menuStrip.Items.AddRange(@($fileMenu, $toolsMenu, $helpMenu))
$MainMenu.Controls.Add($menuStrip)

# Create tab control
$tabControl = New-GuiTabControl -Width 780 -Height 520
$tabControl.Location = New-Object System.Drawing.Point(10, 30)

# Create tabs
$setupTab = New-GuiTabPage -Text "Setup"
$toolsTab = New-GuiTabPage -Text "Tools"
$statusTab = New-GuiTabPage -Text "Status"

# Tools Tab Content
$toolsGroup = New-GuiGroupBox -Text "Available Tools" -Width 760 -Height 480
$toolsGroup.Location = New-Object System.Drawing.Point(10, 10)
$toolsTab.Controls.Add($toolsGroup)

# Status Tab Content
$statusGroup = New-GuiGroupBox -Text "Operation Status" -Width 760 -Height 480
$statusGroup.Location = New-Object System.Drawing.Point(10, 10)

# Progress bar with label
$progressLabel = New-GuiLabel -Text "Progress:" -Width 100 -Height 20
$progressLabel.Location = New-Object System.Drawing.Point(10, 20)

$progressBar = New-GuiProgressBar -Width 730
$progressBar.Location = New-Object System.Drawing.Point(10, 40)

# Status label
$statusLabel = New-GuiLabel -Text "Ready" -Width 730 -Height 20
$statusLabel.Location = New-Object System.Drawing.Point(10, 70)

# Log group box
$logGroup = New-GuiGroupBox -Text "Operation Log" -Width 730 -Height 300
$logGroup.Location = New-Object System.Drawing.Point(10, 100)

# Log text box
$logTextBox = New-Object System.Windows.Forms.RichTextBox
$logTextBox.Size = New-Object System.Drawing.Size(710, 270)
$logTextBox.Location = New-Object System.Drawing.Point(10, 20)
$logTextBox.BackColor = [System.Drawing.Color]::White
$logTextBox.ForeColor = [System.Drawing.Color]::Black
$logTextBox.Font = New-Object System.Drawing.Font("Consolas", 9)
$logTextBox.ReadOnly = $true

$logGroup.Controls.Add($logTextBox)
$statusGroup.Controls.AddRange(@($progressLabel, $progressBar, $statusLabel, $logGroup))
$statusTab.Controls.Add($statusGroup)

# Add tabs to control
$tabControl.Controls.AddRange(@($setupTab, $toolsTab, $statusTab))

# Setup Tab Content
$setupGroup = New-GuiGroupBox -Text "Installation Steps" -Width 760 -Height 230
$setupGroup.Location = New-Object System.Drawing.Point(10, 10)

# Create a flowLayoutPanel for better button organization
$buttonPanel = New-Object System.Windows.Forms.FlowLayoutPanel
$buttonPanel.Size = New-Object System.Drawing.Size(740, 190)
$buttonPanel.Location = New-Object System.Drawing.Point(10, 20)
$buttonPanel.Padding = New-Object System.Windows.Forms.Padding(5)
$buttonPanel.WrapContents = $true

# Create buttons with consistent styling
$DetectHardDriveButton = New-GuiButton -Text "1. Detect Hard Drive" -Width 180
$PartitionButton = New-GuiButton -Text "2. Repartition Drive" -Width 180
$IsoLoadButton = New-GuiButton -Text "3. Load ISO File" -Width 180
$SelectVersionButton = New-GuiButton -Text "4. Select Windows Version" -Width 180
$SelectVersionButton.Add_Click({
    Update-Status "Selecting Windows version..."
    $folderBrowser = New-Object System.Windows.Forms.FolderBrowserDialog
    if ($folderBrowser.ShowDialog() -eq [System.Windows.Forms.DialogResult]::OK) {
        try {
            Update-Status "Processing selected version..."
            $version = Select-WindowsVersion -ImagePath $folderBrowser.SelectedPath
            Update-Status "Version selected: Index $($version.Index) - Edition: $($version.Edition)"
            [System.Windows.Forms.MessageBox]::Show(
                "Selected version: Index $($version.Index) - Edition: $($version.Edition)",
                "Version Selected",
                [System.Windows.Forms.MessageBoxButtons]::OK,
                [System.Windows.Forms.MessageBoxIcon]::Information)
        }
        catch {
            Update-Status "Error selecting version: $_"
            [System.Windows.Forms.MessageBox]::Show("Error selecting version: $_", "Error",
                [System.Windows.Forms.MessageBoxButtons]::OK, [System.Windows.Forms.MessageBoxIcon]::Error)
        }
    }
})
$DeployButton = New-GuiButton -Text "5. Deploy Windows" -Width 180
$DeployButton.Add_Click({
    $deployForm = New-GuiMenu -Title "Deploy Windows" -Width 500 -Height 400
    
    $deployGroup = New-GuiGroupBox -Text "Deployment Settings" -Width 480 -Height 320
    $deployGroup.Location = New-Object System.Drawing.Point(10, 10)

    # Image Path
    $imagePathLabel = New-GuiLabel -Text "Image Path:" -Width 120 -Height 20
    $imagePathLabel.Location = New-Object System.Drawing.Point(20, 30)
    
    $imagePathText = New-Object System.Windows.Forms.TextBox
    $imagePathText.Size = New-Object System.Drawing.Size(250, 20)
    $imagePathText.Location = New-Object System.Drawing.Point(150, 30)
    
    $browseButton = New-GuiButton -Text "Browse" -Width 80
    $browseButton.Location = New-Object System.Drawing.Point(410, 28)

    # Destination Drive
    $destinationLabel = New-GuiLabel -Text "Destination Drive:" -Width 120 -Height 20
    $destinationLabel.Location = New-Object System.Drawing.Point(20, 70)
    
    $destinationCombo = New-GuiComboBox -Width 100
    $destinationCombo.Location = New-Object System.Drawing.Point(150, 70)
    Get-WmiObject Win32_LogicalDisk | ForEach-Object { $destinationCombo.Items.Add($_.DeviceID) }

    # Windows Version Index
    $versionLabel = New-GuiLabel -Text "Version Index:" -Width 120 -Height 20
    $versionLabel.Location = New-Object System.Drawing.Point(20, 110)
    
    $versionCombo = New-GuiComboBox -Width 100
    $versionCombo.Location = New-Object System.Drawing.Point(150, 110)
    1..10 | ForEach-Object { $versionCombo.Items.Add($_) }
    $versionCombo.SelectedIndex = 0

    # Partition Style
    $styleLabel = New-GuiLabel -Text "Partition Style:" -Width 120 -Height 20
    $styleLabel.Location = New-Object System.Drawing.Point(20, 150)
    
    $styleCombo = New-GuiComboBox -Width 100
    $styleCombo.Location = New-Object System.Drawing.Point(150, 150)
    $styleCombo.Items.AddRange(@("MBR", "GPT"))
    $styleCombo.SelectedIndex = 1

    # OK Button
    $okButton = New-GuiButton -Text "Start Deployment" -Width 150
    $okButton.Location = New-Object System.Drawing.Point(165, 250)

    $deployGroup.Controls.AddRange(@(
        $imagePathLabel, $imagePathText, $browseButton,
        $destinationLabel, $destinationCombo,
        $versionLabel, $versionCombo,
        $styleLabel, $styleCombo,
        $okButton
    ))

    $deployForm.Controls.Add($deployGroup)

    $browseButton.Add_Click({
        $folderBrowser = New-Object System.Windows.Forms.FolderBrowserDialog
        if ($folderBrowser.ShowDialog() -eq [System.Windows.Forms.DialogResult]::OK) {
            $imagePathText.Text = $folderBrowser.SelectedPath
        }
    })

    $okButton.Add_Click({
        try {
            Install-Windows -ImagePath $imagePathText.Text `
                         -DestinationDrive $destinationCombo.Text `
                         -WindowsVersionIndex $versionCombo.Text `
                         -PartitionStyle $styleCombo.Text
            Update-Status "Installation started"
            [System.Windows.Forms.MessageBox]::Show("Installation initiated.", "Success",
                [System.Windows.Forms.MessageBoxButtons]::OK, [System.Windows.Forms.MessageBoxIcon]::Information)
            $deployForm.Close()
        }
        catch {
            Update-Status "Installation error: $_"
            [System.Windows.Forms.MessageBox]::Show("Installation error: $_", "Error",
                [System.Windows.Forms.MessageBoxButtons]::OK, [System.Windows.Forms.MessageBoxIcon]::Error)
        }
    })

    $deployForm.ShowDialog()
})
$BootableButton = New-GuiButton -Text "6. Make Image Bootable" -Width 180
$BootableButton.Add_Click({
    $bootForm = New-GuiMenu -Title "Make Image Bootable" -Width 500 -Height 300
    
    $bootGroup = New-GuiGroupBox -Text "Bootable Settings" -Width 480 -Height 220
    $bootGroup.Location = New-Object System.Drawing.Point(10, 10)

    # Image Path
    $imagePathLabel = New-GuiLabel -Text "Image Path:" -Width 120 -Height 20
    $imagePathLabel.Location = New-Object System.Drawing.Point(20, 30)
    
    $imagePathText = New-Object System.Windows.Forms.TextBox
    $imagePathText.Size = New-Object System.Drawing.Size(250, 20)
    $imagePathText.Location = New-Object System.Drawing.Point(150, 30)
    
    $browseButton = New-GuiButton -Text "Browse" -Width 80
    $browseButton.Location = New-Object System.Drawing.Point(410, 28)

    # Boot Sector Path
    $bootSectorLabel = New-GuiLabel -Text "Boot Sector Path:" -Width 120 -Height 20
    $bootSectorLabel.Location = New-Object System.Drawing.Point(20, 70)
    
    $bootSectorText = New-Object System.Windows.Forms.TextBox
    $bootSectorText.Size = New-Object System.Drawing.Size(250, 20)
    $bootSectorText.Location = New-Object System.Drawing.Point(150, 70)
    
    $browseSectorButton = New-GuiButton -Text "Browse" -Width 80
    $browseSectorButton.Location = New-Object System.Drawing.Point(410, 68)

    # OK Button
    $okButton = New-GuiButton -Text "Make Bootable" -Width 150
    $okButton.Location = New-Object System.Drawing.Point(165, 150)

    $bootGroup.Controls.AddRange(@(
        $imagePathLabel, $imagePathText, $browseButton,
        $bootSectorLabel, $bootSectorText, $browseSectorButton,
        $okButton
    ))

    $bootForm.Controls.Add($bootGroup)

    $browseButton.Add_Click({
        $openFileDialog = New-Object System.Windows.Forms.OpenFileDialog
        if ($openFileDialog.ShowDialog() -eq [System.Windows.Forms.DialogResult]::OK) {
            $imagePathText.Text = $openFileDialog.FileName
        }
    })

    $browseSectorButton.Add_Click({
        $openFileDialog = New-Object System.Windows.Forms.OpenFileDialog
        if ($openFileDialog.ShowDialog() -eq [System.Windows.Forms.DialogResult]::OK) {
            $bootSectorText.Text = $openFileDialog.FileName
        }
    })

    $okButton.Add_Click({
        try {
            Set-BootableImage -ImagePath $imagePathText.Text -BootSectorPath $bootSectorText.Text
            Update-Status "Image made bootable"
            [System.Windows.Forms.MessageBox]::Show("Image made bootable.", "Success",
                [System.Windows.Forms.MessageBoxButtons]::OK, [System.Windows.Forms.MessageBoxIcon]::Information)
            $bootForm.Close()
        }
        catch {
            Update-Status "Bootable error: $_"
            [System.Windows.Forms.MessageBox]::Show("Bootable error: $_", "Error",
                [System.Windows.Forms.MessageBoxButtons]::OK, [System.Windows.Forms.MessageBoxIcon]::Error)
        }
    })

    $bootForm.ShowDialog()
})

# Button Event Handlers
$DetectHardDriveButton.Add_Click({
    Update-Status "Detecting hard drives..."
    $drive = Get-HardDrive
    if ($drive) {
        Update-Status "Drive detected: $($drive.Model)"
        $diskInfoLabel.Text = "Disk Information: $($drive.Model)"
        [System.Windows.Forms.MessageBox]::Show("Selected drive: $($drive.Model)", "Drive Detected",
            [System.Windows.Forms.MessageBoxButtons]::OK, [System.Windows.Forms.MessageBoxIcon]::Information)
    }
    else {
        Update-Status "No drives detected"
        $diskInfoLabel.Text = "Disk Information: No drive detected"
    }
})

$PartitionButton.Add_Click({
    $partitionForm = New-GuiMenu -Title "Partition Drive" -Width 500 -Height 400
    
    $partitionGroup = New-GuiGroupBox -Text "Partition Settings" -Width 480 -Height 320
    $partitionGroup.Location = New-Object System.Drawing.Point(10, 10)

    # Drive Selection
    $driveLetterLabel = New-GuiLabel -Text "Drive Letter:" -Width 120 -Height 20
    $driveLetterLabel.Location = New-Object System.Drawing.Point(20, 30)
    
    $driveLetterCombo = New-GuiComboBox -Width 100
    $driveLetterCombo.Location = New-Object System.Drawing.Point(150, 30)
    Get-WmiObject Win32_LogicalDisk | ForEach-Object { $driveLetterCombo.Items.Add($_.DeviceID) }

    # Partition Style
    $partitionTypeLabel = New-GuiLabel -Text "Partition Style:" -Width 120 -Height 20
    $partitionTypeLabel.Location = New-Object System.Drawing.Point(20, 70)
    
    $partitionTypeCombo = New-GuiComboBox -Width 100
    $partitionTypeCombo.Location = New-Object System.Drawing.Point(150, 70)
    $partitionTypeCombo.Items.AddRange(@("GPT", "MBR"))
    $partitionTypeCombo.SelectedIndex = 0

    # Purpose
    $partitionPurposeLabel = New-GuiLabel -Text "Purpose:" -Width 120 -Height 20
    $partitionPurposeLabel.Location = New-Object System.Drawing.Point(20, 110)
    
    $partitionPurposeCombo = New-GuiComboBox -Width 100
    $partitionPurposeCombo.Location = New-Object System.Drawing.Point(150, 110)
    $partitionPurposeCombo.Items.AddRange(@("Windows", "Data"))
    $partitionPurposeCombo.SelectedIndex = 0

    # Custom Size Option
    $customSizeCheck = New-Object System.Windows.Forms.CheckBox
    $customSizeCheck.Text = "Specify custom size"
    $customSizeCheck.Location = New-Object System.Drawing.Point(20, 150)
    $customSizeCheck.Width = 150

    $customSizeLabel = New-GuiLabel -Text "Size (GB):" -Width 120 -Height 20
    $customSizeLabel.Location = New-Object System.Drawing.Point(20, 180)
    $customSizeLabel.Enabled = $false
    
    $customSizeBox = New-Object System.Windows.Forms.NumericUpDown
    $customSizeBox.Location = New-Object System.Drawing.Point(150, 180)
    $customSizeBox.Width = 100
    $customSizeBox.Minimum = 10
    $customSizeBox.Maximum = 2048
    $customSizeBox.Value = 100
    $customSizeBox.Enabled = $false

    $customSizeCheck.Add_CheckedChanged({
        $customSizeLabel.Enabled = $customSizeCheck.Checked
        $customSizeBox.Enabled = $customSizeCheck.Checked
    })

    # Partition Info
    $infoLabel = New-GuiLabel -Text "Note: GPT is recommended for modern systems and required for UEFI boot." -Width 400 -Height 40
    $infoLabel.Location = New-Object System.Drawing.Point(20, 220)

    # OK Button
    $okButton = New-GuiButton -Text "Start Partitioning" -Width 150
    $okButton.Location = New-Object System.Drawing.Point(165, 270)

    $partitionGroup.Controls.AddRange(@(
        $driveLetterLabel, $driveLetterCombo,
        $partitionTypeLabel, $partitionTypeCombo,
        $partitionPurposeLabel, $partitionPurposeCombo,
        $customSizeCheck, $customSizeLabel, $customSizeBox,
        $infoLabel, $okButton
    ))

    $partitionForm.Controls.Add($partitionGroup)

    $okButton.Add_Click({
        try {
            $size = if ($customSizeCheck.Checked) { $customSizeBox.Value } else { 0 }
            
            Update-Status "Starting partition process..."
            $result = Initialize-Partition -DriveLetter $driveLetterCombo.Text.Substring(0,1) `
                                        -PartitionType $partitionTypeCombo.Text `
                                        -PartitionPurpose $partitionPurposeCombo.Text `
                                        -PartitionSize $size

            $message = "Partitioning completed successfully.`n`n"
            $message += "Partition Style: $($result.PartitionStyle)`n"
            $message += "Drive Letter: $($result.MainPartition.DriveLetter)"
            
            Update-Status "Partition initialized: Drive $($result.MainPartition.DriveLetter)"
            [System.Windows.Forms.MessageBox]::Show($message, "Success",
                [System.Windows.Forms.MessageBoxButtons]::OK, [System.Windows.Forms.MessageBoxIcon]::Information)
            $partitionForm.Close()
        }
        catch {
            Update-Status "Partition error: $_"
            [System.Windows.Forms.MessageBox]::Show("Error: $_", "Partition Error",
                [System.Windows.Forms.MessageBoxButtons]::OK, [System.Windows.Forms.MessageBoxIcon]::Error)
        }
    })

    $partitionForm.ShowDialog()
})

$IsoLoadButton.Add_Click({
    Update-Status "Selecting ISO file..."
    $openFileDialog = New-Object System.Windows.Forms.OpenFileDialog
    $openFileDialog.Filter = "ISO files (*.iso)|*.iso|All files (*.*)|*.*"
    if ($openFileDialog.ShowDialog() -eq [System.Windows.Forms.DialogResult]::OK) {
        try {
            Update-Status "Mounting ISO file..."
            $driveLetter = Mount-IsoImage -IsoPath $openFileDialog.FileName
            Update-Status "ISO mounted to drive $driveLetter"
            $isoInfoLabel.Text = "ISO Information: Mounted at $driveLetter - $($openFileDialog.FileName)"
            [System.Windows.Forms.MessageBox]::Show("ISO mounted to drive $driveLetter", "Success",
                [System.Windows.Forms.MessageBoxButtons]::OK, [System.Windows.Forms.MessageBoxIcon]::Information)
        }
        catch {
            Update-Status "Error mounting ISO: $_"
            [System.Windows.Forms.MessageBox]::Show("Error mounting ISO: $_", "Error",
                [System.Windows.Forms.MessageBoxButtons]::OK, [System.Windows.Forms.MessageBoxIcon]::Error)
        }
    }
})

# Add buttons to flow panel
$buttonPanel.Controls.AddRange(@(
    $DetectHardDriveButton,
    $PartitionButton,
    $IsoLoadButton,
    $SelectVersionButton,
    $DeployButton,
    $BootableButton
))

$setupGroup.Controls.Add($buttonPanel)
$setupTab.Controls.Add($setupGroup)

# Create info group box
$infoGroup = New-GuiGroupBox -Text "System Information" -Width 760 -Height 230
$infoGroup.Location = New-Object System.Drawing.Point(10, 250)

# Add system info labels
$sysInfoLabel = New-GuiLabel -Text "System Details:" -Width 740 -Height 20
$sysInfoLabel.Location = New-Object System.Drawing.Point(10, 20)
$sysInfoLabel.Font = New-Object System.Drawing.Font("Segoe UI", 9, [System.Drawing.FontStyle]::Bold)

$diskInfoLabel = New-GuiLabel -Text "Disk Information:" -Width 740 -Height 20
$diskInfoLabel.Location = New-Object System.Drawing.Point(10, 50)

$isoInfoLabel = New-GuiLabel -Text "ISO Information:" -Width 740 -Height 20
$isoInfoLabel.Location = New-Object System.Drawing.Point(10, 80)

$infoGroup.Controls.AddRange(@($sysInfoLabel, $diskInfoLabel, $isoInfoLabel))
$setupTab.Controls.Add($infoGroup)