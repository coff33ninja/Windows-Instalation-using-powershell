function Get-HardDrive {
    # Get list of hard drives via CIM
    $drives = Get-CimInstance -ClassName Win32_DiskDrive

    $form = New-Object System.Windows.Forms.Form
    $form.Text = "Select Hard Drive"
    $form.Width = 400
    $form.Height = 300

    $listBox = New-Object System.Windows.Forms.ListBox
    $listBox.Dock = "Fill"
    foreach ($drive in $drives) {
        $listBox.Items.Add($drive.Model)
    }
    $form.Controls.Add($listBox)

    $okButton = New-GuiButton -Text "OK"
    $okButton.Dock = "Bottom"
    $okButton.Add_Click({
        if ($listBox.SelectedItem) {
            $form.Tag = $listBox.SelectedItem
            $form.DialogResult = [System.Windows.Forms.DialogResult]::OK
            $form.Close()
        }
        else {
            [System.Windows.Forms.MessageBox]::Show("Please select a hard drive.","Selection Required",
                [System.Windows.Forms.MessageBoxButtons]::OK, [System.Windows.Forms.MessageBoxIcon]::Warning)
        }
    })
    $form.Controls.Add($okButton)

    if ($form.ShowDialog() -eq [System.Windows.Forms.DialogResult]::OK) {
        $selectedModel = $form.Tag
        $selectedDrive = $drives | Where-Object { $_.Model -eq $selectedModel }
        return $selectedDrive
    }
    else {
        return $null
    }
}