# Import required modules
try {
    # Import GUI modules
    Import-Module .\Gui-Elements\gui.psm1 -ErrorAction Stop
    Import-Module .\UIComponents\SetupPanel.psm1 -ErrorAction Stop
    Import-Module .\UIComponents\ToolsPanel.psm1 -ErrorAction Stop
    Import-Module .\UIComponents\StatusPanel.psm1 -ErrorAction Stop

    # Import functional modules
    Import-Module .\Modules\detect.psm1 -ErrorAction Stop
    Import-Module .\Modules\partition.psm1 -ErrorAction Stop
    Import-Module .\Modules\isoload.psm1 -ErrorAction Stop
    Import-Module .\Modules\selectversion.psm1 -ErrorAction Stop
    Import-Module .\Modules\deploy.psm1 -ErrorAction Stop
    Import-Module .\Modules\bootable.psm1 -ErrorAction Stop
    Import-Module .\Modules\file_operations.psm1 -ErrorAction Stop
    Import-Module .\Modules\system_tools.psm1 -ErrorAction Stop
    Import-Module .\Modules\installation_options.psm1 -ErrorAction Stop
} catch {
    [System.Windows.Forms.MessageBox]::Show(
        "Error importing modules: $_`nPlease ensure all required modules are present.", 
        "Module Import Error",
        [System.Windows.Forms.MessageBoxButtons]::OK,
        [System.Windows.Forms.MessageBoxIcon]::Error
    )
    exit
}

# Create main form
$MainForm = New-GuiMenu -Title "Windows Installation Tool" -Width 800 -Height 600

# Create menu strip
$menuStrip = New-Object System.Windows.Forms.MenuStrip
$MainForm.MainMenuStrip = $menuStrip
$MainForm.Controls.Add($menuStrip)

# File Menu
$fileMenu = New-GuiMenuItem -Text "File" -ToolTip "File operations"
$openIsoItem = New-GuiMenuItem -Text "Open ISO..." -ToolTip "Select a Windows ISO file"
$openWimItem = New-GuiMenuItem -Text "Open WIM..." -ToolTip "Select a Windows WIM file"
$openVhdItem = New-GuiMenuItem -Text "Open VHD/VHDX..." -ToolTip "Select a virtual disk file"
$saveLogItem = New-GuiMenuItem -Text "Save Log..." -ToolTip "Save operation log to file"
$separator1 = New-Object System.Windows.Forms.ToolStripSeparator
$exitItem = New-GuiMenuItem -Text "Exit" -ToolTip "Exit the application" -Action { 
    $MainForm.Close() 
}
$fileMenu.DropDownItems.AddRange(@($openIsoItem, $openWimItem, $openVhdItem, $saveLogItem, $separator1, $exitItem))

# Tools Menu
$toolsMenu = New-GuiMenuItem -Text "Tools" -ToolTip "Additional tools and utilities"
$diskPartItem = New-GuiMenuItem -Text "DiskPart" -ToolTip "Launch DiskPart utility"
$registryItem = New-GuiMenuItem -Text "Registry Editor" -ToolTip "Edit Windows Registry"
$cmdItem = New-GuiMenuItem -Text "Command Prompt" -ToolTip "Open Command Prompt"
$powershellItem = New-GuiMenuItem -Text "PowerShell" -ToolTip "Open PowerShell"
$driverItem = New-GuiMenuItem -Text "Driver Management" -ToolTip "Manage Windows drivers"
$separator2 = New-Object System.Windows.Forms.ToolStripSeparator
$settingsItem = New-GuiMenuItem -Text "Settings" -ToolTip "Configure application settings"
$toolsMenu.DropDownItems.AddRange(@($diskPartItem, $registryItem, $cmdItem, $powershellItem, $driverItem, $separator2, $settingsItem))

# Options Menu
$optionsMenu = New-GuiMenuItem -Text "Options" -ToolTip "Installation options"
$bootOptionsItem = New-GuiMenuItem -Text "Boot Options" -ToolTip "Configure boot settings"
$unattendedItem = New-GuiMenuItem -Text "Unattended Setup" -ToolTip "Configure unattended installation"
$languageItem = New-GuiMenuItem -Text "Language Settings" -ToolTip "Set installation language"
$optionsMenu.DropDownItems.AddRange(@($bootOptionsItem, $unattendedItem, $languageItem))

# Help Menu
$helpMenu = New-GuiMenuItem -Text "Help" -ToolTip "Get help and information"
$documentationItem = New-GuiMenuItem -Text "Documentation" -ToolTip "View documentation"
$checkUpdatesItem = New-GuiMenuItem -Text "Check for Updates" -ToolTip "Check for new versions"
$separator3 = New-Object System.Windows.Forms.ToolStripSeparator
$aboutItem = New-GuiMenuItem -Text "About" -ToolTip "About this application"
$helpMenu.DropDownItems.AddRange(@($documentationItem, $checkUpdatesItem, $separator3, $aboutItem))

# Add all menus to the menu strip
$menuStrip.Items.AddRange(@($fileMenu, $toolsMenu, $optionsMenu, $helpMenu))

# Create tab control
$tabControl = New-GuiTabControl -Width 780 -Height 520
$tabControl.Location = New-Object System.Drawing.Point(10, 30)

# Create panels
$setupPanelResult = Get-SetupPanel
$toolsPanelResult = Get-ToolsPanel
$statusPanelResult = Get-StatusPanel

# Add tabs to tab control
$tabControl.TabPages.AddRange(@($setupPanelResult.TabPage, $toolsPanelResult.TabPage))

# Add controls to form
$MainForm.Controls.AddRange(@($menuStrip, $tabControl, $statusPanelResult.Panel))

# Store important controls in script scope for event handlers
$script:setupButtons = $setupPanelResult.Buttons
$script:toolsButtons = $toolsPanelResult.Buttons
$script:statusLabel = $statusPanelResult.StatusLabel
$script:logBox = $statusPanelResult.LogTextBox
$script:statusControls = @{
    Label = $statusPanelResult.StatusLabel
    ProgressBar = $statusPanelResult.ProgressBar
    LogBox = $statusPanelResult.LogTextBox
}

# Add event handlers for setup buttons
$setupButtons.DetectButton.Add_Click({
    try {
        $drive = Get-HardDrive
        if ($drive) {
            Update-GuiStatus -Message "Selected drive: $($drive.Model)" -Type 'Success' `
                -StatusLabel $statusPanelResult.StatusLabel `
                -LogBox $statusPanelResult.LogTextBox
            $setupPanelResult.InfoBox.AppendText("Selected Drive: $($drive.Model)`r`n")
        }
    } catch {
        Update-GuiStatus -Message "Error detecting drive: $_" -Type 'Error' `
            -StatusLabel $statusPanelResult.StatusLabel `
            -LogBox $statusPanelResult.LogTextBox
    }
})

$setupButtons.IsoLoadButton.Add_Click({
    $openFileDialog = New-Object System.Windows.Forms.OpenFileDialog
    $openFileDialog.Filter = "ISO files (*.iso)|*.iso|All files (*.*)|*.*"
    $openFileDialog.Title = "Select Windows ISO"
    
    if ($openFileDialog.ShowDialog() -eq 'OK') {
        try {
            $driveLetter = Mount-IsoImage -IsoPath $openFileDialog.FileName
            Update-GuiStatus -Message "ISO mounted successfully to drive $driveLetter" -Type 'Success' `
                -StatusLabel $statusPanelResult.StatusLabel `
                -LogBox $statusPanelResult.LogTextBox
            $setupPanelResult.InfoBox.AppendText("Mounted ISO: $($openFileDialog.FileName) to $driveLetter`r`n")
        } catch {
            Update-GuiStatus -Message "Error mounting ISO: $_" -Type 'Error' `
                -StatusLabel $statusPanelResult.StatusLabel `
                -LogBox $statusPanelResult.LogTextBox
        }
    }
})

# Add event handlers for menu items
$openIsoItem.Add_Click({ Open-IsoFile -StatusLabel $script:statusLabel -LogBox $script:logBox })
$openWimItem.Add_Click({ Open-WimFile -StatusLabel $script:statusLabel -LogBox $script:logBox })
$openVhdItem.Add_Click({ Open-VhdFile -StatusLabel $script:statusLabel -LogBox $script:logBox })
$saveLogItem.Add_Click({ 
    $saveFileDialog = New-Object System.Windows.Forms.SaveFileDialog
    $saveFileDialog.Filter = "Log files (*.log)|*.log|All files (*.*)|*.*"
    $saveFileDialog.Title = "Save Log File"
    
    if ($saveFileDialog.ShowDialog() -eq 'OK') {
        try {
            $script:logBox.Text | Out-File $saveFileDialog.FileName
            Update-GuiStatus -Message "Log saved successfully" -Type 'Success' `
                -StatusLabel $script:statusLabel -LogBox $script:logBox
        } catch {
            Update-GuiStatus -Message "Error saving log: $_" -Type 'Error' `
                -StatusLabel $script:statusLabel -LogBox $script:logBox
        }
    }
})

$diskPartItem.Add_Click({ Start-DiskPartTool -StatusLabel $script:statusLabel -LogBox $script:logBox })
$registryItem.Add_Click({ Start-RegistryEditor -StatusLabel $script:statusLabel -LogBox $script:logBox })
$cmdItem.Add_Click({ Start-CommandPrompt -StatusLabel $script:statusLabel -LogBox $script:logBox })
$powershellItem.Add_Click({ Start-PowerShellPrompt -StatusLabel $script:statusLabel -LogBox $script:logBox })
$driverItem.Add_Click({ Show-DriverManager -StatusLabel $script:statusLabel -LogBox $script:logBox })

$bootOptionsItem.Add_Click({ Show-BootOptions -StatusLabel $script:statusLabel -LogBox $script:logBox })
$unattendedItem.Add_Click({ Show-UnattendedSetup -StatusLabel $script:statusLabel -LogBox $script:logBox })
$languageItem.Add_Click({ Show-LanguageSettings -StatusLabel $script:statusLabel -LogBox $script:logBox })

$documentationItem.Add_Click({ 
    Start-Process "https://github.com/yourusername/Windows-Instalation-using-powershell/wiki"
})
$checkUpdatesItem.Add_Click({
    Update-GuiStatus -Message "Checking for updates..." -Type 'Info' `
        -StatusLabel $script:statusLabel -LogBox $script:logBox
    # TODO: Implement update check
})
$aboutItem.Add_Click({
    [System.Windows.Forms.MessageBox]::Show(
        "Windows Deployment Tool`nVersion 1.0`n`nA PowerShell-based Windows deployment tool.",
        "About",
        [System.Windows.Forms.MessageBoxButtons]::OK,
        [System.Windows.Forms.MessageBoxIcon]::Information
    )
})

# Show the form
Show-GuiMenu -Form $MainForm