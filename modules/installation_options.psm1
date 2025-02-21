function Show-BootOptions {
    param(
        [System.Windows.Forms.Label]$StatusLabel,
        [System.Windows.Forms.RichTextBox]$LogBox
    )
    
    $bootForm = New-GuiMenu -Title "Boot Options" -Width 500 -Height 400
    
    $bootGroup = New-GuiGroupBox -Text "Boot Configuration" -Width 460 -Height 320
    $bootGroup.Location = New-Object System.Drawing.Point(10, 10)
    
    # TODO: Add boot configuration controls
    $bootForm.Controls.Add($bootGroup)
    $bootForm.ShowDialog()
}

function Show-UnattendedSetup {
    param(
        [System.Windows.Forms.Label]$StatusLabel,
        [System.Windows.Forms.RichTextBox]$LogBox
    )
    
    $unattendForm = New-GuiMenu -Title "Unattended Setup" -Width 600 -Height 500
    
    $unattendGroup = New-GuiGroupBox -Text "Unattended Configuration" -Width 560 -Height 420
    $unattendGroup.Location = New-Object System.Drawing.Point(10, 10)
    
    # TODO: Add unattended setup controls
    $unattendForm.Controls.Add($unattendGroup)
    $unattendForm.ShowDialog()
}

function Show-LanguageSettings {
    param(
        [System.Windows.Forms.Label]$StatusLabel,
        [System.Windows.Forms.RichTextBox]$LogBox
    )
    
    $langForm = New-GuiMenu -Title "Language Settings" -Width 400 -Height 300
    
    $langGroup = New-GuiGroupBox -Text "Language Configuration" -Width 360 -Height 220
    $langGroup.Location = New-Object System.Drawing.Point(10, 10)
    
    # TODO: Add language selection controls
    $langForm.Controls.Add($langGroup)
    $langForm.ShowDialog()
}

Export-ModuleMember -Function Show-BootOptions, Show-UnattendedSetup, Show-LanguageSettings