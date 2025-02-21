# Import common UI elements
Import-Module "$PSScriptRoot\..\Gui-Elements\gui.psm1" -ErrorAction Stop
Import-Module "$PSScriptRoot\..\Modules\tools.psm1" -ErrorAction Stop

function Get-ToolsPanel {
    $toolsTab = New-GuiTabPage -Text "Tools"
    
    # Create group box for available tools
    $toolsGroup = New-GuiGroupBox -Text "Available Tools" -Width 760 -Height 480
    $toolsGroup.Location = New-Object System.Drawing.Point(10, 10)
    
    # Create a FlowLayoutPanel for tools buttons
    $buttonPanel = New-Object System.Windows.Forms.FlowLayoutPanel
    $buttonPanel.Size = New-Object System.Drawing.Size(740, 440)
    $buttonPanel.Location = New-Object System.Drawing.Point(10, 20)
    $buttonPanel.Padding = New-Object System.Windows.Forms.Padding(5)
    $buttonPanel.WrapContents = $true

    # Create buttons for various tools
    $buttons = @{
        SettingsButton = New-GuiButton -Text "Settings" -Width 200 -ToolTip "Configure advanced options"
        DiskManagerButton = New-GuiButton -Text "Disk Manager" -Width 200 -ToolTip "Advanced disk management"
        DriverManagerButton = New-GuiButton -Text "Driver Manager" -Width 200 -ToolTip "Manage Windows drivers"
        BackupRestoreButton = New-GuiButton -Text "Backup/Restore" -Width 200 -ToolTip "Backup or restore Windows installation"
        CustomizeButton = New-GuiButton -Text "Customize Windows" -Width 200 -ToolTip "Customize Windows installation"
        LogViewerButton = New-GuiButton -Text "Log Viewer" -Width 200 -ToolTip "View detailed operation logs"
    }

    # Add event handlers
    $buttons.SettingsButton.Add_Click({
        Show-Settings -StatusLabel $script:statusLabel -LogBox $script:logBox
    })
    
    $buttons.DiskManagerButton.Add_Click({
        Show-DiskManager -StatusLabel $script:statusLabel -LogBox $script:logBox
    })
    
    $buttons.DriverManagerButton.Add_Click({
        Show-DriverManager -StatusLabel $script:statusLabel -LogBox $script:logBox
    })
    
    $buttons.BackupRestoreButton.Add_Click({
        Show-BackupRestore -StatusLabel $script:statusLabel -LogBox $script:logBox
    })
    
    $buttons.CustomizeButton.Add_Click({
        Show-CustomizeWindows -StatusLabel $script:statusLabel -LogBox $script:logBox
    })
    
    $buttons.LogViewerButton.Add_Click({
        Show-LogViewer -StatusLabel $script:statusLabel -LogBox $script:logBox
    })

    # Add buttons to the panel
    $buttonPanel.Controls.AddRange($buttons.Values)
    $toolsGroup.Controls.Add($buttonPanel)
    $toolsTab.Controls.Add($toolsGroup)

    # Return both the tab and buttons for event handling
    return @{
        TabPage = $toolsTab
        Buttons = $buttons
    }
}

Export-ModuleMember -Function Get-ToolsPanel