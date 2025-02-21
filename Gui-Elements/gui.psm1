# Import required assemblies
Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing

# Define theme colors for a professional look inspired by WinNTSetup
$theme = @{
    Primary       = "#E1E1E1"   # Light gray for standard controls
    Secondary     = "#F0F0F0"   # Slightly lighter gray for backgrounds
    Background    = "#FFFFFF"   # White background for better contrast
    Text          = "#000000"   # Black text
    Accent       = "#0078D7"   # Windows blue for highlights
    Border       = "#919191"   # Classic border color
    Error        = "#FF3333"   # Error message color
    Success      = "#33AA33"   # Success message color
    Warning      = "#FFA500"   # Warning message color
    HeaderBg     = "#E5E5E5"   # Header background
    SelectedBg   = "#CCE8FF"   # Selected item background
}

# Create a new styled form with enhanced visuals
function New-GuiMenu {
    param(
        [string]$Title,
        [int]$Width = 1024,
        [int]$Height = 768
    )

    $form = New-Object System.Windows.Forms.Form
    $form.Text = $Title
    $form.Size = New-Object System.Drawing.Size($Width, $Height)
    $form.BackColor = [System.Drawing.ColorTranslator]::FromHtml($theme.Background)
    $form.ForeColor = [System.Drawing.ColorTranslator]::FromHtml($theme.Text)
    $form.FormBorderStyle = [System.Windows.Forms.FormBorderStyle]::FixedDialog
    $form.StartPosition = [System.Windows.Forms.FormStartPosition]::CenterScreen
    $form.Font = New-Object System.Drawing.Font("Segoe UI", 9)
    
    # Add MenuStrip with enhanced styling
    $menuStrip = New-Object System.Windows.Forms.MenuStrip
    $menuStrip.BackColor = [System.Drawing.ColorTranslator]::FromHtml($theme.Primary)
    $menuStrip.RenderMode = [System.Windows.Forms.ToolStripRenderMode]::System
    $form.MainMenuStrip = $menuStrip
    $form.Controls.Add($menuStrip)
    
    return $form
}

# Create a styled button with hover effects
function New-GuiButton {
    param(
        [string]$Text,
        [int]$Width = 120,
        [int]$Height = 30,
        [string]$ToolTip
    )

    $button = New-Object System.Windows.Forms.Button
    $button.Text = $Text
    $button.Size = New-Object System.Drawing.Size($Width, $Height)
    $button.BackColor = [System.Drawing.ColorTranslator]::FromHtml($theme.Primary)
    $button.ForeColor = [System.Drawing.ColorTranslator]::FromHtml($theme.Text)
    $button.FlatStyle = [System.Windows.Forms.FlatStyle]::Standard
    $button.UseVisualStyleBackColor = $true
    $button.Cursor = [System.Windows.Forms.Cursors]::Hand
    
    if ($ToolTip) {
        $tooltipControl = New-Object System.Windows.Forms.ToolTip
        $tooltipControl.SetToolTip($button, $ToolTip)
    }

    # Add hover effect
    $button.Add_MouseEnter({
        $this.BackColor = [System.Drawing.ColorTranslator]::FromHtml($theme.SelectedBg)
    })
    $button.Add_MouseLeave({
        $this.BackColor = [System.Drawing.ColorTranslator]::FromHtml($theme.Primary)
    })

    return $button
}

# Create a styled tab control with enhanced visuals
function New-GuiTabControl {
    param(
        [int]$Width,
        [int]$Height
    )

    $tabControl = New-Object System.Windows.Forms.TabControl
    $tabControl.Size = New-Object System.Drawing.Size($Width, $Height)
    $tabControl.BackColor = [System.Drawing.ColorTranslator]::FromHtml($theme.Background)
    $tabControl.ForeColor = [System.Drawing.ColorTranslator]::FromHtml($theme.Text)
    $tabControl.Appearance = [System.Windows.Forms.TabAppearance]::Normal
    $tabControl.SizeMode = [System.Windows.Forms.TabSizeMode]::Fixed
    
    return $tabControl
}

# Create a styled tab page
function New-GuiTabPage {
    param(
        [string]$Text
    )

    $tabPage = New-Object System.Windows.Forms.TabPage
    $tabPage.Text = $Text
    $tabPage.BackColor = [System.Drawing.ColorTranslator]::FromHtml($theme.Background)
    $tabPage.ForeColor = [System.Drawing.ColorTranslator]::FromHtml($theme.Text)
    $tabPage.BorderStyle = [System.Windows.Forms.BorderStyle]::None
    $tabPage.Padding = New-Object System.Windows.Forms.Padding(10)
    
    return $tabPage
}

# Create a styled group box with enhanced visuals
function New-GuiGroupBox {
    param(
        [string]$Text,
        [int]$Width,
        [int]$Height
    )

    $groupBox = New-Object System.Windows.Forms.GroupBox
    $groupBox.Text = $Text
    $groupBox.Size = New-Object System.Drawing.Size($Width, $Height)
    $groupBox.BackColor = [System.Drawing.ColorTranslator]::FromHtml($theme.Background)
    $groupBox.ForeColor = [System.Drawing.ColorTranslator]::FromHtml($theme.Text)
    $groupBox.Font = New-Object System.Drawing.Font("Segoe UI Semibold", 9)
    
    return $groupBox
}

# Create a styled panel with shadow effect
function New-GuiPanel {
    param(
        [int]$Width,
        [int]$Height
    )

    $panel = New-Object System.Windows.Forms.Panel
    $panel.Size = New-Object System.Drawing.Size($Width, $Height)
    $panel.BackColor = [System.Drawing.ColorTranslator]::FromHtml($theme.Background)
    $panel.BorderStyle = [System.Windows.Forms.BorderStyle]::FixedSingle
    
    return $panel
}

# Create a styled progress bar with animation
function New-GuiProgressBar {
    param(
        [int]$Width,
        [int]$Height = 23
    )

    $progressBar = New-Object System.Windows.Forms.ProgressBar
    $progressBar.Size = New-Object System.Drawing.Size($Width, $Height)
    $progressBar.Style = [System.Windows.Forms.ProgressBarStyle]::Continuous
    $progressBar.MarqueeAnimationSpeed = 30
    
    return $progressBar
}

# Create a styled label with optional icons
function New-GuiLabel {
    param(
        [string]$Text,
        [int]$Width,
        [int]$Height,
        [switch]$IsHeader
    )

    $label = New-Object System.Windows.Forms.Label
    $label.Text = $Text
    $label.Size = New-Object System.Drawing.Size($Width, $Height)
    $label.ForeColor = [System.Drawing.ColorTranslator]::FromHtml($theme.Text)
    $label.BackColor = if ($IsHeader) { 
        [System.Drawing.ColorTranslator]::FromHtml($theme.HeaderBg) 
    } else { 
        [System.Drawing.Color]::Transparent 
    }
    if ($IsHeader) {
        $label.Font = New-Object System.Drawing.Font("Segoe UI Semibold", 9)
    }
    
    return $label
}

# Create a styled combo box with enhanced dropdown
function New-GuiComboBox {
    param(
        [int]$Width,
        [int]$Height = 23
    )

    $comboBox = New-Object System.Windows.Forms.ComboBox
    $comboBox.Size = New-Object System.Drawing.Size($Width, $Height)
    $comboBox.DropDownStyle = [System.Windows.Forms.ComboBoxStyle]::DropDownList
    $comboBox.BackColor = [System.Drawing.Color]::White
    $comboBox.ForeColor = [System.Drawing.ColorTranslator]::FromHtml($theme.Text)
    $comboBox.FlatStyle = [System.Windows.Forms.FlatStyle]::Standard
    $comboBox.Font = New-Object System.Drawing.Font("Segoe UI", 9)
    
    return $comboBox
}

# Create a styled check box
function New-GuiCheckBox {
    param(
        [string]$Text,
        [int]$Width,
        [int]$Height = 20
    )

    $checkBox = New-Object System.Windows.Forms.CheckBox
    $checkBox.Text = $Text
    $checkBox.Size = New-Object System.Drawing.Size($Width, $Height)
    $checkBox.ForeColor = [System.Drawing.ColorTranslator]::FromHtml($theme.Text)
    $checkBox.BackColor = [System.Drawing.Color]::Transparent
    $checkBox.Font = New-Object System.Drawing.Font("Segoe UI", 9)
    
    return $checkBox
}

# Create a styled menu item
function New-GuiMenuItem {
    param(
        [string]$Text,
        [scriptblock]$Action,
        [string]$ToolTip
    )

    $menuItem = New-Object System.Windows.Forms.ToolStripMenuItem
    $menuItem.Text = $Text
    if ($Action) {
        $menuItem.Add_Click($Action)
    }
    if ($ToolTip) {
        $menuItem.ToolTipText = $ToolTip
    }
    
    return $menuItem
}

# Create a rich text box for logging
function New-GuiLogBox {
    param(
        [int]$Width,
        [int]$Height
    )

    $logBox = New-Object System.Windows.Forms.RichTextBox
    $logBox.Size = New-Object System.Drawing.Size($Width, $Height)
    $logBox.BackColor = [System.Drawing.Color]::White
    $logBox.ForeColor = [System.Drawing.ColorTranslator]::FromHtml($theme.Text)
    $logBox.Font = New-Object System.Drawing.Font("Consolas", 9)
    $logBox.ReadOnly = $true
    $logBox.MultiLine = $true
    $logBox.WordWrap = $false
    $logBox.ScrollBars = [System.Windows.Forms.RichTextBoxScrollBars]::Both
    
    return $logBox
}

# Add control to container with optional event handlers
function Add-GuiControl {
    param(
        [System.Windows.Forms.Control]$Container,
        [System.Windows.Forms.Control]$Control,
        [ScriptBlock]$OnClick = $null,
        [hashtable]$Events = @{}
    )

    if ($null -eq $Container) {
        throw "Container cannot be null."
    }

    if ($OnClick -and $Control -is [System.Windows.Forms.Button]) {
        $Control.Add_Click($OnClick)
    }

    foreach ($eventName in $Events.Keys) {
        $Control."Add_$eventName"($Events[$eventName])
    }

    $Container.Controls.Add($Control)
}

# Show the form
function Show-GuiMenu {
    param(
        [Parameter(Mandatory = $true)]
        [System.Windows.Forms.Form]$Form
    )

    return $Form.ShowDialog()
}

# Helper function to update status and log
function Update-GuiStatus {
    param(
        [string]$Message,
        [ValidateSet('Info', 'Success', 'Warning', 'Error')]
        [string]$Type = 'Info',
        [System.Windows.Forms.Label]$StatusLabel,
        [System.Windows.Forms.RichTextBox]$LogBox
    )

    $timestamp = Get-Date -Format "HH:mm:ss"
    $color = switch ($Type) {
        'Success' { $theme.Success }
        'Warning' { $theme.Warning }
        'Error' { $theme.Error }
        default { $theme.Text }
    }

    if ($StatusLabel) {
        $StatusLabel.Text = $Message
    }
    if ($LogBox) {
        $LogBox.SelectionColor = [System.Drawing.ColorTranslator]::FromHtml($color)
        $LogBox.AppendText("[$timestamp] $Message`r`n")
        $LogBox.SelectionStart = $LogBox.Text.Length
        $LogBox.ScrollToCaret()
    }
}

# Export all functions and the theme variable
Export-ModuleMember -Function New-GuiMenu, New-GuiButton, New-GuiTabControl, New-GuiTabPage, 
    New-GuiGroupBox, New-GuiPanel, New-GuiProgressBar, New-GuiLabel, New-GuiComboBox, 
    New-GuiCheckBox, New-GuiMenuItem, Add-GuiControl, Show-GuiMenu, New-GuiLogBox,
    Update-GuiStatus
Export-ModuleMember -Variable theme