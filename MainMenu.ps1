# Import the necessary modules and GUI elements
Import-Module .\gui-elements\Gui.psm1
Import-Module .\Modules\detect.psm1
Import-Module .\Modules\partition.psm1
Import-Module .\Modules\isoload.psm1
Import-Module .\Modules\selectversion.psm1
Import-Module .\Modules\deploy.psm1
Import-Module .\Modules\bootable.psm1

# Define the main menu
$MainMenu = New-GuiMenu -Title "Windows Deployment Tool" -Width 500 -Height 300

# Create buttons and position them
$DetectHardDriveButton = New-GuiButton -Text "Detect Hard Drive"
$DetectHardDriveButton.Location = New-Object System.Drawing.Point(10,10)

$PartitionButton = New-GuiButton -Text "Repartition Hard Drive"
$PartitionButton.Location = New-Object System.Drawing.Point(10,50)

$IsoLoadButton = New-GuiButton -Text "Load ISO File"
$IsoLoadButton.Location = New-Object System.Drawing.Point(10,90)

$SelectVersionButton = New-GuiButton -Text "Select Windows Version"
$SelectVersionButton.Location = New-Object System.Drawing.Point(10,130)

$DeployButton = New-GuiButton -Text "Deploy Windows"
$DeployButton.Location = New-Object System.Drawing.Point(10,170)

$BootableButton = New-GuiButton -Text "Make Image Bootable"
$BootableButton.Location = New-Object System.Drawing.Point(10,210)

# Button for detecting hard drive (calls Get-HardDrive from detect.psm1)
Add-GuiMenuItem -Menu $MainMenu -Control $DetectHardDriveButton -OnClick {
    $drive = Get-HardDrive
    if ($drive) {
        [System.Windows.Forms.MessageBox]::Show("Selected drive: $($drive.Model)", "Drive Detected",
            [System.Windows.Forms.MessageBoxButtons]::OK, [System.Windows.Forms.MessageBoxIcon]::Information)
    }
}

# Button for repartitioning (calls Initialize-Partition from partition.psm1)
Add-GuiMenuItem -Menu $MainMenu -Control $PartitionButton -OnClick {
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
    $openFileDialog = New-Object System.Windows.Forms.OpenFileDialog
    $openFileDialog.Filter = "ISO files (*.iso)|*.iso|All files (*.*)|*.*"
    if ($openFileDialog.ShowDialog() -eq [System.Windows.Forms.DialogResult]::OK) {
        try {
            $driveLetter = Mount-IsoImage -IsoPath $openFileDialog.FileName
            [System.Windows.Forms.MessageBox]::Show("ISO mounted to drive $driveLetter","Success",
                [System.Windows.Forms.MessageBoxButtons]::OK, [System.Windows.Forms.MessageBoxIcon]::Information)
        }
        catch {
            [System.Windows.Forms.MessageBox]::Show("Error mounting ISO: $_","Error",
                [System.Windows.Forms.MessageBoxButtons]::OK, [System.Windows.Forms.MessageBoxIcon]::Error)
        }
    }
}

# Button for selecting Windows version (calls Select-WindowsVersion from selectversion.psm1)
Add-GuiMenuItem -Menu $MainMenu -Control $SelectVersionButton -OnClick {
    $folderBrowser = New-Object System.Windows.Forms.FolderBrowserDialog
    if ($folderBrowser.ShowDialog() -eq [System.Windows.Forms.DialogResult]::OK) {
        try {
            $version = Select-WindowsVersion -ImagePath $folderBrowser.SelectedPath
            [System.Windows.Forms.MessageBox]::Show("Selected version: Index $($version.Index) - Edition: $($version.Edition)",
                "Version Selected", [System.Windows.Forms.MessageBoxButtons]::OK, [System.Windows.Forms.MessageBoxIcon]::Information)
        }
        catch {
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