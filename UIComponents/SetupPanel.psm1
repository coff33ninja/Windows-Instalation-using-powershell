# Import common UI elements
Import-Module "$PSScriptRoot\..\Gui-Elements\gui.psm1" -ErrorAction Stop

function Get-SetupPanel {
    # Create a new tab page for Setup
    $setupTab = New-GuiTabPage -Text "Setup"

    # Create a group box to hold the installation steps
    $setupGroup = New-GuiGroupBox -Text "Installation Steps" -Width 760 -Height 230
    $setupGroup.Location = New-Object System.Drawing.Point(10, 10)
    
    # Create a FlowLayoutPanel to organize step buttons
    $buttonPanel = New-Object System.Windows.Forms.FlowLayoutPanel
    $buttonPanel.Size = New-Object System.Drawing.Size(740, 190)
    $buttonPanel.Location = New-Object System.Drawing.Point(10, 20)
    $buttonPanel.Padding = New-Object System.Windows.Forms.Padding(5)
    $buttonPanel.WrapContents = $true

    # Create buttons for the steps
    $buttons = @{
        DetectButton = New-GuiButton -Text "1. Detect Hard Drive" -Width 180 -ToolTip "Detect available hard drives"
        PartitionButton = New-GuiButton -Text "2. Partition Drive" -Width 180 -ToolTip "Repartition Drive"
        IsoLoadButton = New-GuiButton -Text "3. Load ISO File" -Width 180 -ToolTip "Select a Windows ISO file"
        SelectVersionButton = New-GuiButton -Text "4. Select Windows Version" -Width 180 -ToolTip "Choose a Windows edition"
        DeployButton = New-GuiButton -Text "5. Deploy Windows" -Width 180 -ToolTip "Deploy Windows onto the destination drive"
        BootableButton = New-GuiButton -Text "6. Make Image Bootable" -Width 180 -ToolTip "Update boot information on the image"
    }

    # Add buttons to the panel
    $buttonPanel.Controls.AddRange($buttons.Values)

    # Create info panel below buttons
    $infoGroup = New-GuiGroupBox -Text "Current Settings" -Width 760 -Height 200
    $infoGroup.Location = New-Object System.Drawing.Point(10, 250)

    $infoTextBox = New-GuiLogBox -Width 740 -Height 170
    $infoTextBox.Location = New-Object System.Drawing.Point(10, 20)
    $infoTextBox.ReadOnly = $true
    $infoGroup.Controls.Add($infoTextBox)

    # Add all controls to the setup tab
    $setupGroup.Controls.Add($buttonPanel)
    $setupTab.Controls.AddRange(@($setupGroup, $infoGroup))

    # Return both the tab and the buttons for event handling
    return @{
        TabPage = $setupTab
        Buttons = $buttons
        InfoBox = $infoTextBox
    }
}

Export-ModuleMember -Function Get-SetupPanel