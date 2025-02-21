function Show-BootOptions {
    param(
        [System.Windows.Forms.Label]$StatusLabel,
        [System.Windows.Forms.RichTextBox]$LogBox
    )

    $bootForm = New-GuiMenu -Title "Boot Options" -Width 500 -Height 400

    $bootGroup = New-GuiGroupBox -Text "Boot Configuration" -Width 460 -Height 320
    $bootGroup.Location = New-Object System.Drawing.Point(10, 10)

    # Boot Mode Selection
    $bootModeLabel = New-Object System.Windows.Forms.Label
    $bootModeLabel.Text = "Boot Mode:"
    $bootModeLabel.Location = New-Object System.Drawing.Point(20, 30)
    $bootModeLabel.AutoSize = $true

    $bootModeCombo = New-Object System.Windows.Forms.ComboBox
    $bootModeCombo.Location = New-Object System.Drawing.Point(120, 30)
    $bootModeCombo.Size = New-Object System.Drawing.Size(200, 20)
    $bootModeCombo.Items.AddRange(@("UEFI", "Legacy BIOS"))
    $bootModeCombo.SelectedIndex = 0

    # Secure Boot Option
    $secureBootCheck = New-GuiCheckBox -Text "Enable Secure Boot" -Location (20, 70)

    # Boot Order
    $bootOrderLabel = New-Object System.Windows.Forms.Label
    $bootOrderLabel.Text = "Boot Order:"
    $bootOrderLabel.Location = New-Object System.Drawing.Point(20, 110)
    $bootOrderLabel.AutoSize = $true

    $bootOrderList = New-Object System.Windows.Forms.ListBox
    $bootOrderList.Location = New-Object System.Drawing.Point(120, 110)
    $bootOrderList.Size = New-Object System.Drawing.Size(200, 100)
    $bootOrderList.SelectionMode = "MultiExtended"

    # Add available boot devices
    $bootDevices = Get-WmiObject -Class Win32_DiskDrive | ForEach-Object { $_.Model }
    $bootOrderList.Items.AddRange($bootDevices)

    # Save Button
    $saveButton = New-GuiButton -Text "Save Configuration" -Location (20, 250)
    $saveButton.Add_Click({
        $bootConfig = @{
            BootMode = $bootModeCombo.SelectedItem
            SecureBoot = $secureBootCheck.Checked
            BootOrder = $bootOrderList.SelectedItems
        }
        Update-GuiStatus -Message "Boot configuration saved" -Type 'Success' -StatusLabel $StatusLabel -LogBox $LogBox
        $bootForm.Close()
    })

    # Add controls to group box
    $bootGroup.Controls.AddRange(@(
        $bootModeLabel, $bootModeCombo,
        $secureBootCheck,
        $bootOrderLabel, $bootOrderList,
        $saveButton
    ))

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

    # User Account Configuration
    $userLabel = New-Object System.Windows.Forms.Label
    $userLabel.Text = "Username:"
    $userLabel.Location = New-Object System.Drawing.Point(20, 30)
    $userLabel.AutoSize = $true

    $userTextBox = New-Object System.Windows.Forms.TextBox
    $userTextBox.Location = New-Object System.Drawing.Point(120, 30)
    $userTextBox.Size = New-Object System.Drawing.Size(200, 20)

    $passwordLabel = New-Object System.Windows.Forms.Label
    $passwordLabel.Text = "Password:"
    $passwordLabel.Location = New-Object System.Drawing.Point(20, 60)
    $passwordLabel.AutoSize = $true

    $passwordTextBox = New-Object System.Windows.Forms.TextBox
    $passwordTextBox.Location = New-Object System.Drawing.Point(120, 60)
    $passwordTextBox.Size = New-Object System.Drawing.Size(200, 20)
    $passwordTextBox.PasswordChar = '*'

    # Time Zone Configuration
    $timeZoneLabel = New-Object System.Windows.Forms.Label
    $timeZoneLabel.Text = "Time Zone:"
    $timeZoneLabel.Location = New-Object System.Drawing.Point(20, 100)
    $timeZoneLabel.AutoSize = $true

    $timeZoneCombo = New-Object System.Windows.Forms.ComboBox
    $timeZoneCombo.Location = New-Object System.Drawing.Point(120, 100)
    $timeZoneCombo.Size = New-Object System.Drawing.Size(200, 20)
    $timeZones = [System.TimeZoneInfo]::GetSystemTimeZones() | ForEach-Object { $_.Id }
    $timeZoneCombo.Items.AddRange($timeZones)

    # Network Configuration
    $networkLabel = New-Object System.Windows.Forms.Label
    $networkLabel.Text = "Network Settings:"
    $networkLabel.Location = New-Object System.Drawing.Point(20, 140)
    $networkLabel.AutoSize = $true

    $dhcpCheck = New-GuiCheckBox -Text "Use DHCP" -Location (120, 140)
    $staticIpCheck = New-GuiCheckBox -Text "Use Static IP" -Location (120, 170)

    # Save Button
    $saveButton = New-GuiButton -Text "Save Configuration" -Location (20, 220)
    $saveButton.Add_Click({
        $unattendConfig = @{
            Username = $userTextBox.Text
            Password = $passwordTextBox.Text
            TimeZone = $timeZoneCombo.SelectedItem
            Network = @{
                UseDHCP = $dhcpCheck.Checked
                UseStaticIP = $staticIpCheck.Checked
            }
        }
        Update-GuiStatus -Message "Unattended configuration saved" -Type 'Success' -StatusLabel $StatusLabel -LogBox $LogBox
        $unattendForm.Close()
    })

    # Add controls to group box
    $unattendGroup.Controls.AddRange(@(
        $userLabel, $userTextBox,
        $passwordLabel, $passwordTextBox,
        $timeZoneLabel, $timeZoneCombo,
        $networkLabel, $dhcpCheck, $staticIpCheck,
        $saveButton
    ))

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

    # System Language
    $langLabel = New-Object System.Windows.Forms.Label
    $langLabel.Text = "System Language:"
    $langLabel.Location = New-Object System.Drawing.Point(20, 30)
    $langLabel.AutoSize = $true

    $langCombo = New-Object System.Windows.Forms.ComboBox
    $langCombo.Location = New-Object System.Drawing.Point(140, 30)
    $langCombo.Size = New-Object System.Drawing.Size(200, 20)
    $langCombo.Items.AddRange(@("English", "French", "German", "Spanish", "Chinese"))
    $langCombo.SelectedIndex = 0

    # Keyboard Layout
    $keyboardLabel = New-Object System.Windows.Forms.Label
    $keyboardLabel.Text = "Keyboard Layout:"
    $keyboardLabel.Location = New-Object System.Drawing.Point(20, 70)
    $keyboardLabel.AutoSize = $true

    $keyboardCombo = New-Object System.Windows.Forms.ComboBox
    $keyboardCombo.Location = New-Object System.Drawing.Point(140, 70)
    $keyboardCombo.Size = New-Object System.Drawing.Size(200, 20)
    $keyboardCombo.Items.AddRange(@("US", "UK", "French", "German", "Spanish"))
    $keyboardCombo.SelectedIndex = 0

    # Save Button
    $saveButton = New-GuiButton -Text "Save Configuration" -Location (20, 120)
    $saveButton.Add_Click({
        $langConfig = @{
            Language = $langCombo.SelectedItem
            Keyboard = $keyboardCombo.SelectedItem
        }
        Update-GuiStatus -Message "Language configuration saved" -Type 'Success' -StatusLabel $StatusLabel -LogBox $LogBox
        $langForm.Close()
    })

    # Add controls to group box
    $langGroup.Controls.AddRange(@(
        $langLabel, $langCombo,
        $keyboardLabel, $keyboardCombo,
        $saveButton
    ))

    $langForm.Controls.Add($langGroup)
    $langForm.ShowDialog()
}

Export-ModuleMember -Function Show-BootOptions, Show-UnattendedSetup, Show-LanguageSettings
