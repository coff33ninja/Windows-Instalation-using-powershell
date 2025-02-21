function Start-DiskPartTool {
    param(
        [System.Windows.Forms.Label]$StatusLabel,
        [System.Windows.Forms.RichTextBox]$LogBox
    )
    Start-Process "diskpart" -Verb RunAs
    Update-GuiStatus -Message "Started DiskPart" -Type 'Info' -StatusLabel $StatusLabel -LogBox $LogBox
}

function Start-RegistryEditor {
    param(
        [System.Windows.Forms.Label]$StatusLabel,
        [System.Windows.Forms.RichTextBox]$LogBox
    )
    Start-Process "regedit.exe" -Verb RunAs
    Update-GuiStatus -Message "Started Registry Editor" -Type 'Info' -StatusLabel $StatusLabel -LogBox $LogBox
}

function Start-CommandPrompt {
    param(
        [System.Windows.Forms.Label]$StatusLabel,
        [System.Windows.Forms.RichTextBox]$LogBox
    )
    Start-Process "cmd.exe" -Verb RunAs
    Update-GuiStatus -Message "Started Command Prompt" -Type 'Info' -StatusLabel $StatusLabel -LogBox $LogBox
}

function Start-PowerShellPrompt {
    param(
        [System.Windows.Forms.Label]$StatusLabel,
        [System.Windows.Forms.RichTextBox]$LogBox
    )
    Start-Process "powershell.exe" -Verb RunAs
    Update-GuiStatus -Message "Started PowerShell" -Type 'Info' -StatusLabel $StatusLabel -LogBox $LogBox
}

Export-ModuleMember -Function Start-DiskPartTool, Start-RegistryEditor, Start-CommandPrompt, Start-PowerShellPrompt