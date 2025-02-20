# Import required assemblies
Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing

# Define theme colors
$theme = @{
    Primary = "#0078D7"
    Secondary = "#2D2D30"
    Background = "#1E1E1E"
    Text = "#FFFFFF"
    Accent = "#3E3E42"
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
    $form.FormBorderStyle = [System.Windows.Forms.FormBorderStyle]::FixedSingle
    $form.StartPosition = [System.Windows.Forms.FormStartPosition]::CenterScreen
    $form.Font = New-Object System.Drawing.Font("Segoe UI", 9)
    return $form
}

# Create a styled button
function New-GuiButton {
    param(
        [string]$Text,
        [int]$Width = 120,
        [int]$Height = 35
    )

    $button = New-Object System.Windows.Forms.Button
    $button.Text = $Text
    $button.Size = New-Object System.Drawing.Size($Width, $Height)
    $button.BackColor = [System.Drawing.ColorTranslator]::FromHtml($theme.Primary)
    $button.ForeColor = [System.Drawing.ColorTranslator]::FromHtml($theme.Text)
    $button.FlatStyle = [System.Windows.Forms.FlatStyle]::Flat
    $button.FlatAppearance.BorderSize = 0
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
    $tabControl.BackColor = [System.Drawing.ColorTranslator]::FromHtml($theme.Secondary)
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
    return $tabPage
}

# Create a panel container
function New-GuiPanel {
    param(
        [int]$Width,
        [int]$Height
    )

    $panel = New-Object System.Windows.Forms.Panel
    $panel.Size = New-Object System.Drawing.Size($Width, $Height)
    $panel.BackColor = [System.Drawing.ColorTranslator]::FromHtml($theme.Accent)
    return $panel
}

# Create a progress bar
function New-GuiProgressBar {
    param(
        [int]$Width,
        [int]$Height = 20
    )

    $progressBar = New-Object System.Windows.Forms.ProgressBar
    $progressBar.Size = New-Object System.Drawing.Size($Width, $Height)
    $progressBar.Style = [System.Windows.Forms.ProgressBarStyle]::Continuous
    $progressBar.ForeColor = [System.Drawing.ColorTranslator]::FromHtml($theme.Primary)
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
    return $label
}

# Create a combo box
function New-GuiComboBox {
    param(
        [int]$Width,
        [int]$Height = 25
    )

    $comboBox = New-Object System.Windows.Forms.ComboBox
    $comboBox.Size = New-Object System.Drawing.Size($Width, $Height)
    $comboBox.DropDownStyle = [System.Windows.Forms.ComboBoxStyle]::DropDownList
    $comboBox.BackColor = [System.Drawing.ColorTranslator]::FromHtml($theme.Secondary)
    $comboBox.ForeColor = [System.Drawing.ColorTranslator]::FromHtml($theme.Text)
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
    return $checkBox
}

# Add control to container
function Add-GuiMenuItem {
    param(
        [System.Windows.Forms.Control]$Container,
        [System.Windows.Forms.Control]$Control,
        [ScriptBlock]$OnClick = $null
    )

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
