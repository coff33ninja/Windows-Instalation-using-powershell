# Import the necessary modules and GUI elements
Import-Module .\gui-elements\Gui.psm1
Import-Module .\Modules\detect.psm1
Import-Module .\Modules\partition.psm1
Import-Module .\Modules\isoload.psm1
Import-Module .\Modules\selectversion.psm1
Import-Module .\Modules\deploy.psm1
Import-Module .\Modules\bootable.psm1

# Define the main menu
$MainMenu = New-GuiMenu -Title "Windows Deployment Tool"

# Create tab control
$tabControl = New-GuiTabControl -Width 780 -Height 550
$tabControl.Location = New-Object System.Drawing.Point(10, 10)

# Create tabs
$setupTab = New-GuiTabPage -Text "Setup"
$toolsTab = New-GuiTabPage -Text "Tools"
$statusTab = New-GuiTabPage -Text "Status"

# Add tabs to control
$tabControl.Controls.AddRange(@($setupTab, $toolsTab, $statusTab))

# Setup Tab Content
$setupPanel = New-GuiPanel -Width 760 -Height 250
$setupPanel.Location = New-Object System.Drawing.Point(10, 10)

$DetectHardDriveButton = New-GuiButton -Text "Detect Hard Drive"
$DetectHardDriveButton.Location = New-Object System.Drawing.Point(10, 10)

$PartitionButton = New-GuiButton -Text "Repartition Hard Drive"
$PartitionButton.Location = New-Object System.Drawing.Point(140, 10)

$IsoLoadButton = New-GuiButton -Text "Load ISO File"
$IsoLoadButton.Location = New-Object System.Drawing.Point(270, 10)

$SelectVersionButton = New-GuiButton -Text "Select Windows Version"
$SelectVersionButton.Location = New-Object System.Drawing.Point(400, 10)

$DeployButton = New-GuiButton -Text "Deploy Windows"
$DeployButton.Location = New-Object System.Drawing.Point(530, 10)

$BootableButton = New-GuiButton -Text "Make Image Bootable"
$BootableButton.Location = New-Object System.Drawing.Point(660, 10)

$setupPanel.Controls.AddRange(@(
    $DetectHardDriveButton,
    $PartitionButton,
    $IsoLoadButton,
    $SelectVersionButton,
    $DeployButton,
    $BootableButton
))

# Tools Tab Content
$toolsPanel = New-GuiPanel -Width 760 -Height 250
$toolsPanel.Location = New-Object System.Drawing.Point(10, 10)

# Status Tab Content
$statusPanel = New-GuiPanel -Width 760 -Height 250
$statusPanel.Location = New-Object System.Drawing.Point(10, 10)

# Progress bar
$progressBar = New-GuiProgressBar -Width 740
$progressBar.Location = New-Object System.Drawing.Point(10, 10)

# Status label
$statusLabel = New-GuiLabel -Text "Ready" -Width 740 -Height 30
$statusLabel.Location = New-Object System.Drawing.Point(10, 40)

# Log text box
$logTextBox = New-Object System.Windows.Forms.RichTextBox
$logTextBox.Size = New-Object System.Drawing.Size(740, 180)
$logTextBox.Location = New-Object System.Drawing.Point(10, 80)
$logTextBox.BackColor = [System.Drawing.ColorTranslator]::FromHtml($theme.Secondary)
$logTextBox.ForeColor = [System.Drawing.ColorTranslator]::FromHtml($theme.Text)
$logTextBox.ReadOnly = $true

$statusPanel.Controls.AddRange(@(
    $progressBar,
    $statusLabel,
    $logTextBox
))

# Function to update status
function Update-Status {
    param(
        [string]$Message,
        [int]$Progress = -1
    )
    
    if ($Progress -ge 0) {
        $progressBar.Value = $Progress
    }
    
    $statusLabel.Text = $Message
    $logTextBox.AppendText("$([DateTime]::Now.ToString("HH:mm:ss")) - $Message`n")
    $logTextBox.ScrollToCaret()
}

# Add panels to tabs
$setupTab.Controls.Add($setupPanel)
$toolsTab.Controls.Add($toolsPanel)
$statusTab.Controls.Add($statusPanel)

# Add tab control to main menu
Add-GuiMenuItem -Container $MainMenu -Control $tabControl

# Button for detecting hard drive (calls Get-HardDrive from detect.psm1)
Add-GuiMenuItem -Menu $MainMenu -Control $DetectHardDriveButton -OnClick {
    Update-Status "Detecting hard drives..."
    $drive = Get-HardDrive
    if ($drive) {
        Update-Status "Drive detected: $($drive.Model)"
        [System.Windows.Forms.MessageBox]::Show("Selected drive: $($drive.Model)", "Drive Detected",
            [System.Windows.Forms.MessageBoxButtons]::OK, [System.Windows.Forms.MessageBoxIcon]::Information)
    }
    else {
        Update-Status "No drives detected"
    }
}

# Button for repartitioning (calls Initialize-Partition from partition.psm1)
Add-GuiMenuItem -Menu $MainMenu -Control $PartitionButton -OnClick {
    Update-Status "Starting partition process..."
    # Prompt for parameters with a simple form
    $formPartition = New-GuiMenu -Title "Partition Parameters" -Width 300 -Height 200

    $driveLetterLabel = New-Object System.Windows.Forms.Label
    $driveLetterLabel.Text = "Drive Letter:"
    $driveLetterLabel.Location = New-Object System.Drawing.Point(10,20)

    $driveLetterText = New-Object System.Windows.Forms.TextBox
    $driveLetterText.Location = New-Object System.Drawing.Point(100,20)

    $partitionTypeLabel = New-Object System.Windows.Forms.Label
    $partitionTypeLabel.Text = "Partition Type:"
    $partitionTypeLabel.Location = New-Object System.Drawing.Point(10,60)

    $partitionTypeCombo = New-Object System.Windows.Forms.ComboBox
    $partitionTypeCombo.Items.AddRange(@("MBR","GPT"))
    $partitionTypeCombo.Location = New-Object System.Drawing.Point(100,60)

    $partitionPurposeLabel = New-Object System.Windows.Forms.Label
    $partitionPurposeLabel.Text = "Partition Purpose:"
    $partitionPurposeLabel.Location = New-Object System.Drawing.Point(10,100)

    $partitionPurposeCombo = New-Object System.Windows.Forms.ComboBox
    $partitionPurposeCombo.Items.AddRange(@("Windows","Data"))
    $partitionPurposeCombo.Location = New-Object System.Drawing.Point(100,100)

    $okButton = New-GuiButton -Text "OK"
    $okButton.Location = New-Object System.Drawing.Point(100,140)
    $formPartition.Controls.AddRange(@($driveLetterLabel, $driveLetterText,
        $partitionTypeLabel, $partitionTypeCombo, $partitionPurposeLabel, $partitionPurposeCombo, $okButton))

    $script:partitionDriveLetter = $null
    $script:partitionType = $null
    $script:partitionPurpose = $null

    $okButton.Add_Click({
        $script:partitionDriveLetter = $driveLetterText.Text
        $script:partitionType = $partitionTypeCombo.Text
        $script:partitionPurpose = $partitionPurposeCombo.Text
        $formPartition.DialogResult = [System.Windows.Forms.DialogResult]::OK
        $formPartition.Close()
    })

    if($formPartition.ShowDialog() -eq [System.Windows.Forms.DialogResult]::OK) {
        try {
            Initialize-Partition -DriveLetter $script:partitionDriveLetter -PartitionType $script:partitionType -PartitionPurpose $script:partitionPurpose
            [System.Windows.Forms.MessageBox]::Show("Partition initialized successfully.","Success",
                [System.Windows.Forms.MessageBoxButtons]::OK, [System.Windows.Forms.MessageBoxIcon]::Information)
        }
        catch {
            [System.Windows.Forms.MessageBox]::Show("Error: $_","Partition Error",
                [System.Windows.Forms.MessageBoxButtons]::OK, [System.Windows.Forms.MessageBoxIcon]::Error)
        }
    }
}

# Button for loading ISO (calls Mount-IsoImage from isoload.psm1)
Add-GuiMenuItem -Menu $MainMenu -Control $IsoLoadButton -OnClick {
    Update-Status "Selecting ISO file..."
    $openFileDialog = New-Object System.Windows.Forms.OpenFileDialog
    $openFileDialog.Filter = "ISO files (*.iso)|*.iso|All files (*.*)|*.*"
    if ($openFileDialog.ShowDialog() -eq [System.Windows.Forms.DialogResult]::OK) {
        try {
            Update-Status "Mounting ISO file..."
            $driveLetter = Mount-IsoImage -IsoPath $openFileDialog.FileName
            Update-Status "ISO mounted to drive $driveLetter"
            [System.Windows.Forms.MessageBox]::Show("ISO mounted to drive $driveLetter","Success",
                [System.Windows.Forms.MessageBoxButtons]::OK, [System.Windows.Forms.MessageBoxIcon]::Information)
        }
        catch {
            Update-Status "Error mounting ISO: $_"
            [System.Windows.Forms.MessageBox]::Show("Error mounting ISO: $_","Error",
                [System.Windows.Forms.MessageBoxButtons]::OK, [System.Windows.Forms.MessageBoxIcon]::Error)
        }
    }
}

# Button for selecting Windows version (calls Select-WindowsVersion from selectversion.psm1)
Add-GuiMenuItem -Menu $MainMenu -Control $SelectVersionButton -OnClick {
    Update-Status "Selecting Windows version..."
    $folderBrowser = New-Object System.Windows.Forms.FolderBrowserDialog
    if ($folderBrowser.ShowDialog() -eq [System.Windows.Forms.DialogResult]::OK) {
        try {
            Update-Status "Processing selected version..."
            $version = Select-WindowsVersion -ImagePath $folderBrowser.SelectedPath
            Update-Status "Version selected: Index $($version.Index) - Edition: $($version.Edition)"
            [System.Windows.Forms.MessageBox]::Show("Selected version: Index $($version.Index) - Edition: $($version.Edition)",
                "Version Selected", [System.Windows.Forms.MessageBoxButtons]::OK, [System.Windows.Forms.MessageBoxIcon]::Information)
        }
        catch {
            Update-Status "Error selecting version: $_"
            [System.Windows.Forms.MessageBox]::Show("Error selecting version: $_","Error",
                [System.Windows.Forms.MessageBoxButtons]::OK, [System.Windows.Forms.MessageBoxIcon]::Error)
        }
    }
}

# Button for deployment (calls Deploy-Windows from deploy.psm1)
Add-GuiMenuItem -Menu $MainMenu -Control $DeployButton -OnClick {
    $deployForm = New-GuiMenu -Title "Deployment Parameters" -Width 300 -Height 250

    $imagePathLabel = New-Object System.Windows.Forms.Label
    $imagePathLabel.Text = "Image Path:"
    $imagePathLabel.Location = New-Object System.Drawing.Point(10,20)
    $imagePathText = New-Object System.Windows.Forms.TextBox
    $imagePathText.Location = New-Object System.Drawing.Point(100,20)

    $destinationLabel = New-Object System.Windows.Forms.Label
    $destinationLabel.Text = "Destination Drive:"
    $destinationLabel.Location = New-Object System.Drawing.Point(10,60)
    $destinationText = New-Object System.Windows.Forms.TextBox
    $destinationText.Location = New-Object System.Drawing.Point(100,60)

    $versionLabel = New-Object System.Windows.Forms.Label
    $versionLabel.Text = "Windows Version Index:"
    $versionLabel.Location = New-Object System.Drawing.Point(10,100)
    $versionText = New-Object System.Windows.Forms.TextBox
    $versionText.Location = New-Object System.Drawing.Point(150,100)

    $partitionStyleLabel = New-Object System.Windows.Forms.Label
    $partitionStyleLabel.Text = "Partition Style:"
    $partitionStyleLabel.Location = New-Object System.Drawing.Point(10,140)
    $partitionStyleCombo = New-Object System.Windows.Forms.ComboBox
    $partitionStyleCombo.Items.AddRange(@("MBR","GPT"))
    $partitionStyleCombo.Location = New-Object System.Drawing.Point(100,140)

    $okButtonDeploy = New-GuiButton -Text "OK"
    $okButtonDeploy.Location = New-Object System.Drawing.Point(100,180)
    $deployForm.Controls.AddRange(@($imagePathLabel, $imagePathText,
        $destinationLabel, $destinationText, $versionLabel, $versionText, $partitionStyleLabel, $partitionStyleCombo, $okButtonDeploy))

    $script:deployImagePath = $null
    $script:deployDestination = $null
    $script:deployVersionIndex = $null
    $script:deployPartitionStyle = $null

    $okButtonDeploy.Add_Click({
        $script:deployImagePath = $imagePathText.Text
        $script:deployDestination = $destinationText.Text
        $script:deployVersionIndex = $versionText.Text
        $script:deployPartitionStyle = $partitionStyleCombo.Text
        $deployForm.DialogResult = [System.Windows.Forms.DialogResult]::OK
        $deployForm.Close()
    })

    if ($deployForm.ShowDialog() -eq [System.Windows.Forms.DialogResult]::OK) {
        try {
            Deploy-Windows -ImagePath $script:deployImagePath -DestinationDrive $script:deployDestination `
                -WindowsVersionIndex $script:deployVersionIndex -PartitionStyle $script:deployPartitionStyle
            [System.Windows.Forms.MessageBox]::Show("Deployment initiated.","Success",
                [System.Windows.Forms.MessageBoxButtons]::OK,[System.Windows.Forms.MessageBoxIcon]::Information)
        }
        catch {
            [System.Windows.Forms.MessageBox]::Show("Deployment error: $_","Error",
                [System.Windows.Forms.MessageBoxButtons]::OK,[System.Windows.Forms.MessageBoxIcon]::Error)
        }
    }
}

# Button for bootable image (calls Set-ImageBootable from bootable.psm1)
Add-GuiMenuItem -Menu $MainMenu -Control $BootableButton -OnClick {
    $bootForm = New-GuiMenu -Title "Bootable Parameters" -Width 300 -Height 200

    $imagePathLabelB = New-Object System.Windows.Forms.Label
    $imagePathLabelB.Text = "Image Path:"
    $imagePathLabelB.Location = New-Object System.Drawing.Point(10,20)
    $imagePathTextB = New-Object System.Windows.Forms.TextBox
    $imagePathTextB.Location = New-Object System.Drawing.Point(100,20)

    $bootSectorLabel = New-Object System.Windows.Forms.Label
    $bootSectorLabel.Text = "Boot Sector Path:"
    $bootSectorLabel.Location = New-Object System.Drawing.Point(10,60)
    $bootSectorText = New-Object System.Windows.Forms.TextBox
    $bootSectorText.Location = New-Object System.Drawing.Point(130,60)

    $okButtonBoot = New-GuiButton -Text "OK"
    $okButtonBoot.Location = New-Object System.Drawing.Point(100,100)
    $bootForm.Controls.AddRange(@($imagePathLabelB, $imagePathTextB, $bootSectorLabel, $bootSectorText, $okButtonBoot))

    $script:bootImagePath = $null
    $script:bootSectorPath = $null

    $okButtonBoot.Add_Click({
        $script:bootImagePath = $imagePathTextB.Text
        $script:bootSectorPath = $bootSectorText.Text
        $bootForm.DialogResult = [System.Windows.Forms.DialogResult]::OK
        $bootForm.Close()
    })

    if ($bootForm.ShowDialog() -eq [System.Windows.Forms.DialogResult]::OK) {
        try {
            Set-ImageBootable -ImagePath $script:bootImagePath -BootSectorPath $script:bootSectorPath
            [System.Windows.Forms.MessageBox]::Show("Image made bootable.","Success",
                [System.Windows.Forms.MessageBoxButtons]::OK,[System.Windows.Forms.MessageBoxIcon]::Information)
        }
        catch {
            [System.Windows.Forms.MessageBox]::Show("Bootable error: $_","Error",
                [System.Windows.Forms.MessageBoxButtons]::OK,[System.Windows.Forms.MessageBoxIcon]::Error)
        }
    }
}

# Display the main menu
Show-GuiMenu $MainMenu