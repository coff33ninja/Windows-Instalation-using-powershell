# Import common UI elements
Import-Module "$PSScriptRoot\..\Gui-Elements\gui.psm1" -ErrorAction Stop

function Get-StatusPanel {
    $statusTab = New-GuiTabPage -Text "Status"

    # Create main status group
    $statusGroup = New-GuiGroupBox -Text "Operation Status" -Width 760 -Height 480
    $statusGroup.Location = New-Object System.Drawing.Point(10, 10)
    
    # Create progress section
    $progressLabel = New-GuiLabel -Text "Progress:" -Width 100 -Height 20
    $progressLabel.Location = New-Object System.Drawing.Point(10, 20)
    
    $progressBar = New-GuiProgressBar -Width 730 -Height 23
    $progressBar.Location = New-Object System.Drawing.Point(10, 40)
    
    # Create status message label
    $statusLabel = New-GuiLabel -Text "Ready" -Width 730 -Height 20
    $statusLabel.Location = New-Object System.Drawing.Point(10, 70)
    
    # Create log section
    $logGroup = New-GuiGroupBox -Text "Operation Log" -Width 730 -Height 300
    $logGroup.Location = New-Object System.Drawing.Point(10, 100)
    
    $logTextBox = New-GuiLogBox -Width 710 -Height 270
    $logTextBox.Location = New-Object System.Drawing.Point(10, 20)
    $logGroup.Controls.Add($logTextBox)

    # Create buttons panel
    $buttonPanel = New-Object System.Windows.Forms.FlowLayoutPanel
    $buttonPanel.Size = New-Object System.Drawing.Size(730, 40)
    $buttonPanel.Location = New-Object System.Drawing.Point(10, 410)
    $buttonPanel.WrapContents = $false

    $buttons = @{
        ClearLogButton = New-GuiButton -Text "Clear Log" -Width 120 -ToolTip "Clear the operation log"
        SaveLogButton = New-GuiButton -Text "Save Log" -Width 120 -ToolTip "Save the operation log to a file"
        RefreshButton = New-GuiButton -Text "Refresh" -Width 120 -ToolTip "Refresh status information"
    }

    # Add buttons to panel
    $buttonPanel.Controls.AddRange($buttons.Values)
    
    # Add all controls to the status group
    $statusGroup.Controls.AddRange(@(
        $progressLabel,
        $progressBar,
        $statusLabel,
        $logGroup,
        $buttonPanel
    ))

    $statusTab.Controls.Add($statusGroup)
    
    # Return all important controls for external access
    return @{
        TabPage = $statusTab
        StatusLabel = $statusLabel
        ProgressBar = $progressBar
        LogTextBox = $logTextBox
        Buttons = $buttons
    }
}

Export-ModuleMember -Function Get-StatusPanel