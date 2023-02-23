function Select-WindowsVersion {
    param(
        [Parameter(Mandatory = $true)]
        [string]$ImagePath
    )

    # Check if the install.wim/install.esd file exists in the specified image path
    if (-not (Test-Path "$ImagePath\sources\install.wim") -and -not (Test-Path "$ImagePath\sources\install.esd")) {
        throw "The specified image path does not contain a valid install.wim or install.esd file: $ImagePath"
    }

    # If the install.wim file exists, use the DISM tool to list its available versions
    if (Test-Path "$ImagePath\sources\install.wim") {
        $versions = (dism /Get-WimInfo /WimFile:$ImagePath\sources\install.wim).Split("`n") | Select-String "^Index"
    }
    # If the install.esd file exists, use the DISM tool to list its available versions
    else {
        $versions = (dism /Get-ImageInfo /ImageFile:$ImagePath\sources\install.esd).Split("`n") | Select-String "^Index"
    }

    # Display a menu of available Windows versions and prompt the user to select one
    $menu = New-Object System.Management.Automation.Host.ChoiceDescription "&$_", $_.ToString() for ($i=0; $i -lt $versions.Count; $i++) {
        $versions[$i] = $versions[$i] -replace "^Index\s+:\s+(\d+).+Edition\s+:\s+(.+)$", "`$1: `$2"
        $menu += New-Object System.Management.Automation.Host.ChoiceDescription "&$($i+1)", $versions[$i]
    }
    $result = $Host.UI.PromptForChoice("Select Windows Version", "Select the Windows version to deploy:", $menu, 0)

    # Extract the selected version index and edition from the user's choice
    $versionIndex = $versions[$result] -replace "^(\d+):.+?$", "`$1"
    $edition = $versions[$result] -replace "^\d+:\s+(.+)$", "`$1"

    # Return the selected Windows version index and edition
    return @{Index=$versionIndex; Edition=$edition}
}
