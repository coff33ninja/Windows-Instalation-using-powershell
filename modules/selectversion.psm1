function Select-WindowsVersion {
    param(
        [Parameter(Mandatory = $true)]
        [string]$ImagePath
    )

    $wimPath = Join-Path $ImagePath "sources\install.wim"
    $esdPath = Join-Path $ImagePath "sources\install.esd"

    if (-not (Test-Path $wimPath) -and -not (Test-Path $esdPath)) {
        throw "The specified image path does not contain a valid install.wim or install.esd file: $ImagePath"
    }

    if (Test-Path $wimPath) {
        $dismOutput = dism /Get-WimInfo /WimFile:$wimPath
    }
    else {
        $dismOutput = dism /Get-ImageInfo /ImageFile:$esdPath
    }

    $versions = $dismOutput -split "`n" | Where-Object { $_ -match "^Index" }
    $menu = @()
    $versionDetails = @()
    for ($i=0; $i -lt $versions.Count; $i++) {
        $line = $versions[$i].Trim()
        if ($line -match "^Index\s+:\s+(\d+).+Edition\s+:\s+(.+)$") {
            $index = $matches[1]
            $edition = $matches[2]
            $menu += New-Object System.Management.Automation.Host.ChoiceDescription ("&$($i+1)"), "${index}: ${edition}"
            $versionDetails += ,@{ Index = $index; Edition = $edition }
        }
    }

    if ($menu.Count -eq 0) {
        throw "No Windows versions found in the image."
    }

    $choice = $Host.UI.PromptForChoice("Select Windows Version", "Select the Windows version to deploy:", $menu, 0)
    return $versionDetails[$choice]
}