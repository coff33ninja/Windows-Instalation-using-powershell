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
    $toolTip = New-Object System.Windows.Forms.ToolTip
    $toolTip.SetToolTip($bootModeCombo, "Select the boot mode for the installation (UEFI recommended for modern systems)")

    # Secure Boot Option
    $secureBootCheck = New-GuiCheckBox -Text "Enable Secure Boot" -Location (20, 70)
    $toolTip.SetToolTip($secureBootCheck, "Enable Secure Boot for enhanced security (requires UEFI mode)")

    # Boot Order
    $bootOrderLabel = New-Object System.Windows.Forms.Label
    $bootOrderLabel.Text = "Boot Order:"
    $bootOrderLabel.Location = New-Object System.Drawing.Point(20, 110)
    $bootOrderLabel.AutoSize = $true

    $bootOrderList = New-Object System.Windows.Forms.ListBox
    $bootOrderList.Location = New-Object System.Drawing.Point(120, 110)
    $bootOrderList.Size = New-Object System.Drawing.Size(200, 100)
    $bootOrderList.SelectionMode = "MultiExtended"
    $toolTip.SetToolTip($bootOrderList, "Select and arrange the boot order (drag to reorder)")

    # Add available boot devices
    $bootDevices = Get-WmiObject -Class Win32_DiskDrive | ForEach-Object { $_.Model }
    $bootOrderList.Items.AddRange($bootDevices)

    # Save Button
    $saveButton = New-GuiButton -Text "Save Configuration" -Location (20, 250) -Width 200
    $toolTip.SetToolTip($saveButton, "Save the current boot configuration settings")
    $saveButton.Add_Click({
        try {
            if (-not $bootModeCombo.SelectedItem) {
                throw "Please select a boot mode"
            }
            if ($bootOrderList.SelectedItems.Count -eq 0) {
                throw "Please select at least one boot device"
            }

            $bootConfig = @{
                BootMode = $bootModeCombo.SelectedItem
                SecureBoot = $secureBootCheck.Checked
                BootOrder = $bootOrderList.SelectedItems
            }
            # Save configuration
            Save-BootConfiguration -Config $bootConfig
            Update-GuiStatus -Message "Boot configuration saved" -Type 'Success' -StatusLabel $StatusLabel -LogBox $LogBox
            $bootForm.Close()
        }
        catch {
            Update-GuiStatus -Message "Error: $_" -Type 'Error' -StatusLabel $StatusLabel -LogBox $LogBox
        }
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
    $toolTip = New-Object System.Windows.Forms.ToolTip

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
    $toolTip.SetToolTip($userTextBox, "Enter the username for the new account (alphanumeric characters only)")

    $passwordLabel = New-Object System.Windows.Forms.Label
    $passwordLabel.Text = "Password:"
    $passwordLabel.Location = New-Object System.Drawing.Point(20, 60)
    $passwordLabel.AutoSize = $true

    $passwordTextBox = New-Object System.Windows.Forms.TextBox
    $passwordTextBox.Location = New-Object System.Drawing.Point(120, 60)
    $passwordTextBox.Size = New-Object System.Drawing.Size(200, 20)
    $passwordTextBox.PasswordChar = '*'
    $toolTip.SetToolTip($passwordTextBox, "Enter a strong password for the new account (minimum 8 characters)")

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
    $toolTip.SetToolTip($timeZoneCombo, "Select the appropriate time zone for the installation")

    # Network Configuration
    $networkLabel = New-Object System.Windows.Forms.Label
    $networkLabel.Text = "Network Settings:"
    $networkLabel.Location = New-Object System.Drawing.Point(20, 140)
    $networkLabel.AutoSize = $true

    $dhcpCheck = New-GuiCheckBox -Text "Use DHCP" -Location (120, 140)
    $toolTip.SetToolTip($dhcpCheck, "Automatically configure network settings using DHCP")

    $staticIpCheck = New-GuiCheckBox -Text "Use Static IP" -Location (120, 170)
    $toolTip.SetToolTip($staticIpCheck, "Manually configure network settings with a static IP address")


    # Save Button
    $saveButton = New-GuiButton -Text "Save Configuration" -Location (20, 220) -Width 200
    $toolTip.SetToolTip($saveButton, "Save the current unattended setup configuration")
    $saveButton.Add_Click({
        try {
            if ([string]::IsNullOrWhiteSpace($userTextBox.Text)) {
                throw "Username is required"
            }
            if ([string]::IsNullOrWhiteSpace($passwordTextBox.Text)) {
                throw "Password is required"
            }
            if (-not $timeZoneCombo.SelectedItem) {
                throw "Please select a time zone"
            }

            $unattendConfig = @{
                Username = $userTextBox.Text
                Password = $passwordTextBox.Text
                TimeZone = $timeZoneCombo.SelectedItem
                Network = @{
                    UseDHCP = $dhcpCheck.Checked
                    UseStaticIP = $staticIpCheck.Checked
                }
            }
            # Save configuration
            Save-UnattendedConfiguration -Config $unattendConfig
            Update-GuiStatus -Message "Unattended configuration saved" -Type 'Success' -StatusLabel $StatusLabel -LogBox $LogBox
            $unattendForm.Close()
        }
        catch {
            Update-GuiStatus -Message "Error: $_" -Type 'Error' -StatusLabel $StatusLabel -LogBox $LogBox
        }
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
    $toolTip = New-Object System.Windows.Forms.ToolTip

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
    $toolTip.SetToolTip($langCombo, "Select the primary system language for the installation")

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
    $toolTip.SetToolTip($keyboardCombo, "Select the keyboard layout for the installation")

    # Save Button
    $saveButton = New-GuiButton -Text "Save Configuration" -Location (20, 120) -Width 200
    $toolTip.SetToolTip($saveButton, "Save the current language settings configuration")
    $saveButton.Add_Click({
        try {
            if (-not $langCombo.SelectedItem) {
                throw "Please select a system language"
            }
            if (-not $keyboardCombo.SelectedItem) {
                throw "Please select a keyboard layout"
            }

            $langConfig = @{
                Language = $langCombo.SelectedItem
                Keyboard = $keyboardCombo.SelectedItem
            }
            # Save configuration
            Save-LanguageConfiguration -Config $langConfig
            Update-GuiStatus -Message "Language configuration saved" -Type 'Success' -StatusLabel $StatusLabel -LogBox $LogBox
            $langForm.Close()
        }
        catch {
            Update-GuiStatus -Message "Error: $_" -Type 'Error' -StatusLabel $StatusLabel -LogBox $LogBox
        }
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

function Save-BootConfiguration {
    param(
        [hashtable]$Config
    )
    # Implementation to save boot configuration
    # Example: Write to config file or registry
}

function Save-UnattendedConfiguration {
    param(
        [hashtable]$Config
    )
    # Implementation to save unattended setup configuration
    # Example: Generate unattend.xml file
}

function Save-LanguageConfiguration {
    param(
        [hashtable]$Config
    )
    # Implementation to save language settings
    # Example: Apply language packs and keyboard layouts
}

Export-ModuleMember -Function Show-BootOptions, Show-UnattendedSetup, Show-LanguageSettings,
    Save-BootConfiguration, Save-UnattendedConfiguration, Save-LanguageConfiguration
