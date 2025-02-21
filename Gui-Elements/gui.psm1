# Import required assemblies
Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing

# Define theme colors for classic Windows look
$theme = @{
    Primary    = "#E1E1E1"   # Light gray for standard controls
    Secondary  = "#F0F0F0"   # Slightly lighter gray for backgrounds
    Background = "#F0F0F0"   # Classic Windows background gray
    Text       = "#000000"   # Black text
    Accent     = "#0078D7"   # Windows blue for highlights
    Border     = "#919191"   # Classic border color
}

# Create a new styled form
function New-GuiMenu {
    param(
        [string]$Title,
        [int]$Width = 800,
        [int]$Height = 600
    )

    $form = New-Object System.Windows.Forms.Form
    $form.Text = $Title
    $form.Size = New-Object System.Drawing.Size($Width, $Height)
    $form.BackColor = [System.Drawing.ColorTranslator]::FromHtml($theme.Background)
    $form.ForeColor = [System.Drawing.ColorTranslator]::FromHtml($theme.Text)
    $form.FormBorderStyle = [System.Windows.Forms.FormBorderStyle]::FixedDialog
    $form.StartPosition = [System.Windows.Forms.FormStartPosition]::CenterScreen
    $form.Font = New-Object System.Drawing.Font("Segoe UI", 9)
    
    # Add MenuStrip to the form
    $menuStrip = New-Object System.Windows.Forms.MenuStrip
    $menuStrip.BackColor = [System.Drawing.ColorTranslator]::FromHtml($theme.Primary)
    $menuStrip.RenderMode = [System.Windows.Forms.ToolStripRenderMode]::System
    $form.MainMenuStrip = $menuStrip
    $form.Controls.Add($menuStrip)
    
    return $form
}

# Create a styled button
function New-GuiButton {
    param(
        [string]$Text,
        [int]$Width = 120,
        [int]$Height = 30
    )

    $button = New-Object System.Windows.Forms.Button
    $button.Text = $Text
    $button.Size = New-Object System.Drawing.Size($Width, $Height)
    $button.BackColor = [System.Drawing.ColorTranslator]::FromHtml($theme.Primary)
    $button.ForeColor = [System.Drawing.ColorTranslator]::FromHtml($theme.Text)
    $button.FlatStyle = [System.Windows.Forms.FlatStyle]::Standard
    $button.UseVisualStyleBackColor = $true
    $button.Cursor = [System.Windows.Forms.Cursors]::Hand
    return $button
}

# Create a tab control
function New-GuiTabControl {
    param(
        [int]$Width,
        [int]$Height
    )

    $tabControl = New-Object System.Windows.Forms.TabControl
    $tabControl.Size = New-Object System.Drawing.Size($Width, $Height)
    $tabControl.BackColor = [System.Drawing.ColorTranslator]::FromHtml($theme.Background)
    $tabControl.ForeColor = [System.Drawing.ColorTranslator]::FromHtml($theme.Text)
    return $tabControl
}

# Create a tab page
function New-GuiTabPage {
    param(
        [string]$Text
    )

    $tabPage = New-Object System.Windows.Forms.TabPage
    $tabPage.Text = $Text
    $tabPage.BackColor = [System.Drawing.ColorTranslator]::FromHtml($theme.Background)
    $tabPage.ForeColor = [System.Drawing.ColorTranslator]::FromHtml($theme.Text)
    $tabPage.BorderStyle = [System.Windows.Forms.BorderStyle]::None
    return $tabPage
}

# Create a group box (replaces panel for better organization)
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
    return $groupBox
}

# Create a panel container
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

# Create a progress bar
function New-GuiProgressBar {
    param(
        [int]$Width,
        [int]$Height = 23
    )

    $progressBar = New-Object System.Windows.Forms.ProgressBar
    $progressBar.Size = New-Object System.Drawing.Size($Width, $Height)
    $progressBar.Style = [System.Windows.Forms.ProgressBarStyle]::Continuous
    return $progressBar
}

# Create a styled label
function New-GuiLabel {
    param(
        [string]$Text,
        [int]$Width,
        [int]$Height
    )

    $label = New-Object System.Windows.Forms.Label
    $label.Text = $Text
    $label.Size = New-Object System.Drawing.Size($Width, $Height)
    $label.ForeColor = [System.Drawing.ColorTranslator]::FromHtml($theme.Text)
    $label.BackColor = [System.Drawing.Color]::Transparent
    return $label
}

# Create a combo box
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
    return $comboBox
}

# Create a check box
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
    return $checkBox
}

# Create a menu strip item
function New-GuiMenuItem {
    param(
        [string]$Text,
        [scriptblock]$Action
    )

    $menuItem = New-Object System.Windows.Forms.ToolStripMenuItem
    $menuItem.Text = $Text
    if ($Action) {
        $menuItem.Add_Click($Action)
    }
    return $menuItem
}

# Add control to container
function Add-GuiControl {
    param(
        [System.Windows.Forms.Control]$Container,
        [System.Windows.Forms.Control]$Control,
        [ScriptBlock]$OnClick = $null
    )

    if ($null -eq $Container) {
        throw "Container cannot be null."
    }

    if ($OnClick -and $Control -is [System.Windows.Forms.Button]) {
        $Control.Add_Click($OnClick)
    }
    $Container.Controls.Add($Control)
}

# Show the form
function Show-GuiMenu {
    param(
        [System.Windows.Forms.Form]$Menu
    )

    return $Menu.ShowDialog()
}

# Export all functions
Export-ModuleMember -Function New-GuiMenu, New-GuiButton, New-GuiTabControl, New-GuiTabPage, 
    New-GuiGroupBox, New-GuiPanel, New-GuiProgressBar, New-GuiLabel, New-GuiComboBox, 
    New-GuiCheckBox, New-GuiMenuItem, Add-GuiControl, Show-GuiMenu