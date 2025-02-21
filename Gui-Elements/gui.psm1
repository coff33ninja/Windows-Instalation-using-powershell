# Import required assemblies
Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing

# Define modern, minimalist theme colors
$theme = @{
    Primary      = "#FFFFFF"   # Pure white for main background
    Secondary    = "#F5F5F5"   # Very light gray for secondary elements
    Background   = "#FAFAFA"   # Slightly off-white for contrast
    Text         = "#212121"   # Dark gray for text
    TextLight    = "#757575"   # Medium gray for secondary text
    Accent      = "#2196F3"   # Material Design Blue
    AccentLight = "#BBDEFB"   # Light blue for hover states
    Border      = "#E0E0E0"   # Light gray for borders
    Error       = "#F44336"   # Material Design Red
    Success     = "#4CAF50"   # Material Design Green
    Warning     = "#FFC107"   # Material Design Amber
    Shadow      = "0, 0, 0"   # Shadow color (RGB format for opacity)
}

# Create a modern, flat form
function New-GuiMenu {
    param(
        [string]$Title,
        [int]$Width = 1024,
        [int]$Height = 768
    )

    $form = New-Object System.Windows.Forms.Form
    $form.Text = $Title
    $form.Size = New-Object System.Drawing.Size($Width, $Height)
    $form.BackColor = [System.Drawing.ColorTranslator]::FromHtml($theme.Primary)
    $form.ForeColor = [System.Drawing.ColorTranslator]::FromHtml($theme.Text)
    $form.FormBorderStyle = [System.Windows.Forms.FormBorderStyle]::Sizable
    $form.StartPosition = [System.Windows.Forms.FormStartPosition]::CenterScreen
    $form.Font = New-Object System.Drawing.Font("Segoe UI", 9)
    $form.Icon = [System.Drawing.SystemIcons]::Application
    
    return $form
}

# Create a modern, flat button
function New-GuiButton {
    param(
        [string]$Text,
        [int]$Width = 120,
        [int]$Height = 32,
        [string]$ToolTip
    )

    $button = New-Object System.Windows.Forms.Button
    $button.Text = $Text
    $button.Size = New-Object System.Drawing.Size($Width, $Height)
    $button.FlatStyle = [System.Windows.Forms.FlatStyle]::Flat
    $button.FlatAppearance.BorderSize = 0
    $button.BackColor = [System.Drawing.ColorTranslator]::FromHtml($theme.Accent)
    $button.ForeColor = [System.Drawing.Color]::White
    $button.Cursor = [System.Windows.Forms.Cursors]::Hand
    $button.Font = New-Object System.Drawing.Font("Segoe UI", 9)
    
    if ($ToolTip) {
        $tooltipControl = New-Object System.Windows.Forms.ToolTip
        $tooltipControl.SetToolTip($button, $ToolTip)
    }

    # Modern hover effect
    $button.Add_MouseEnter({
        $this.BackColor = [System.Drawing.ColorTranslator]::FromHtml($theme.AccentLight)
        $this.ForeColor = [System.Drawing.ColorTranslator]::FromHtml($theme.Text)
    })
    $button.Add_MouseLeave({
        $this.BackColor = [System.Drawing.ColorTranslator]::FromHtml($theme.Accent)
        $this.ForeColor = [System.Drawing.Color]::White
    })

    return $button
}

# Create a modern tab control
function New-GuiTabControl {
    param(
        [int]$Width,
        [int]$Height
    )

    $tabControl = New-Object System.Windows.Forms.TabControl
    $tabControl.Size = New-Object System.Drawing.Size($Width, $Height)
    $tabControl.BackColor = [System.Drawing.ColorTranslator]::FromHtml($theme.Primary)
    $tabControl.Appearance = [System.Windows.Forms.TabAppearance]::Normal
    $tabControl.SizeMode = [System.Windows.Forms.TabSizeMode]::Fixed
    $tabControl.ItemSize = New-Object System.Drawing.Size(100, 30)
    $tabControl.Font = New-Object System.Drawing.Font("Segoe UI", 9)
    
    return $tabControl
}

# Create a modern tab page
function New-GuiTabPage {
    param(
        [string]$Text
    )

    $tabPage = New-Object System.Windows.Forms.TabPage
    $tabPage.Text = $Text
    $tabPage.BackColor = [System.Drawing.ColorTranslator]::FromHtml($theme.Primary)
    $tabPage.Padding = New-Object System.Windows.Forms.Padding(15)
    $tabPage.Font = New-Object System.Drawing.Font("Segoe UI", 9)
    
    return $tabPage
}

# Create a modern group box
function New-GuiGroupBox {
    param(
        [string]$Text,
        [int]$Width,
        [int]$Height
    )

    $groupBox = New-Object System.Windows.Forms.GroupBox
    $groupBox.Text = $Text
    $groupBox.Size = New-Object System.Drawing.Size($Width, $Height)
    $groupBox.BackColor = [System.Drawing.ColorTranslator]::FromHtml($theme.Primary)
    $groupBox.ForeColor = [System.Drawing.ColorTranslator]::FromHtml($theme.TextLight)
    $groupBox.Font = New-Object System.Drawing.Font("Segoe UI", 9)
    
    return $groupBox
}

# Create a modern panel with subtle shadow
function New-GuiPanel {
    param(
        [int]$Width,
        [int]$Height
    )

    $panel = New-Object System.Windows.Forms.Panel
    $panel.Size = New-Object System.Drawing.Size($Width, $Height)
    $panel.BackColor = [System.Drawing.ColorTranslator]::FromHtml($theme.Primary)
    $panel.BorderStyle = [System.Windows.Forms.BorderStyle]::None
    $panel.Padding = New-Object System.Windows.Forms.Padding(10)
    
    return $panel
}

# Create a modern progress bar
function New-GuiProgressBar {
    param(
        [int]$Width,
        [int]$Height = 3  # Thin, modern progress bar
    )

    $progressBar = New-Object System.Windows.Forms.ProgressBar
    $progressBar.Size = New-Object System.Drawing.Size($Width, $Height)
    $progressBar.Style = [System.Windows.Forms.ProgressBarStyle]::Continuous
    $progressBar.MarqueeAnimationSpeed = 30
    $progressBar.BackColor = [System.Drawing.ColorTranslator]::FromHtml($theme.Border)
    $progressBar.ForeColor = [System.Drawing.ColorTranslator]::FromHtml($theme.Accent)
    
    return $progressBar
}

# Create a modern label
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
    $label.BackColor = [System.Drawing.Color]::Transparent
    
    if ($IsHeader) {
        $label.Font = New-Object System.Drawing.Font("Segoe UI Semibold", 12)
        $label.ForeColor = [System.Drawing.ColorTranslator]::FromHtml($theme.Text)
    } else {
        $label.Font = New-Object System.Drawing.Font("Segoe UI", 9)
        $label.ForeColor = [System.Drawing.ColorTranslator]::FromHtml($theme.TextLight)
    }
    
    return $label
}

# Create a modern combo box
function New-GuiComboBox {
    param(
        [int]$Width,
        [int]$Height = 30
    )

    $comboBox = New-Object System.Windows.Forms.ComboBox
    $comboBox.Size = New-Object System.Drawing.Size($Width, $Height)
    $comboBox.DropDownStyle = [System.Windows.Forms.ComboBoxStyle]::DropDownList
    $comboBox.FlatStyle = [System.Windows.Forms.FlatStyle]::Flat
    $comboBox.BackColor = [System.Drawing.ColorTranslator]::FromHtml($theme.Primary)
    $comboBox.Font = New-Object System.Drawing.Font("Segoe UI", 9)
    
    return $comboBox
}

# Create a modern checkbox
function New-GuiCheckBox {
    param(
        [string]$Text,
        [int]$Width,
        [int]$Height = 24
    )

    $checkBox = New-Object System.Windows.Forms.CheckBox
    $checkBox.Text = $Text
    $checkBox.Size = New-Object System.Drawing.Size($Width, $Height)
    $checkBox.FlatStyle = [System.Windows.Forms.FlatStyle]::Flat
    $checkBox.BackColor = [System.Drawing.Color]::Transparent
    $checkBox.Font = New-Object System.Drawing.Font("Segoe UI", 9)
    
    return $checkBox
}

# Create a modern menu item
function New-GuiMenuItem {
    param(
        [string]$Text,
        [scriptblock]$Action,
        [string]$ToolTip
    )

    $menuItem = New-Object System.Windows.Forms.ToolStripMenuItem
    $menuItem.Text = $Text
    $menuItem.Font = New-Object System.Drawing.Font("Segoe UI", 9)
    
    if ($Action) {
        $menuItem.Add_Click($Action)
    }
    if ($ToolTip) {
        $menuItem.ToolTipText = $ToolTip
    }
    
    return $menuItem
}

# Create a modern log box
function New-GuiLogBox {
    param(
        [int]$Width,
        [int]$Height
    )

    $logBox = New-Object System.Windows.Forms.RichTextBox
    $logBox.Size = New-Object System.Drawing.Size($Width, $Height)
    $logBox.BackColor = [System.Drawing.ColorTranslator]::FromHtml($theme.Secondary)
    $logBox.ForeColor = [System.Drawing.ColorTranslator]::FromHtml($theme.Text)
    $logBox.Font = New-Object System.Drawing.Font("Cascadia Code", 9)
    $logBox.BorderStyle = [System.Windows.Forms.BorderStyle]::None
    $logBox.ReadOnly = $true
    $logBox.MultiLine = $true
    $logBox.WordWrap = $false
    $logBox.ScrollBars = [System.Windows.Forms.RichTextBoxScrollBars]::Both
    $logBox.Padding = New-Object System.Windows.Forms.Padding(5)
    
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

# Helper function to update status and log with modern styling
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
        default { $theme.TextLight }
    }

    if ($StatusLabel) {
        $StatusLabel.Text = $Message
        $StatusLabel.ForeColor = [System.Drawing.ColorTranslator]::FromHtml($color)
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