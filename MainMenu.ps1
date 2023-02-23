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

$DetectHardDriveButton = New-GuiButton -Text "Detect Hard Drive"
$PartitionButton = New-GuiButton -Text "Repartition Hard Drive"
$IsoLoadButton = New-GuiButton -Text "Load ISO File"
$SelectVersionButton = New-GuiButton -Text "Select Windows Version"
$DeployButton = New-GuiButton -Text "Deploy Windows"
$BootableButton = New-GuiButton -Text "Make Image Bootable"

Add-GuiMenuItem -Menu $MainMenu -Control $DetectHardDriveButton -OnClick {
    # Call the Detect-HardDrive function from the detect.psm1 module
    Detect-HardDrive
}

Add-GuiMenuItem -Menu $MainMenu -Control $PartitionButton -OnClick {
    # Call the Repartition function from the partition.psm1 module
    Repartition
}

Add-GuiMenuItem -Menu $MainMenu -Control $IsoLoadButton -OnClick {
    # Call the Load-IsoFile function from the isoload.psm1 module
    Load-IsoFile
}

Add-GuiMenuItem -Menu $MainMenu -Control $SelectVersionButton -OnClick {
    # Call the Select-WindowsVersion function from the selectversion.psm1 module
    Select-WindowsVersion
}

Add-GuiMenuItem -Menu $MainMenu -Control $DeployButton -OnClick {
    # Call the Deploy-Windows function from the deploy.psm1 module
    Deploy-Windows
}

Add-GuiMenuItem -Menu $MainMenu -Control $BootableButton -OnClick {
    # Call the Make-ImageBootable function from the bootable.psm1 module
    Make-ImageBootable
}

# Display the main menu
Show-GuiMenu $MainMenu
