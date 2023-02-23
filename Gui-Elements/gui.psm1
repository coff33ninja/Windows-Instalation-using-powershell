# Import the required Windows Forms assembly
Add-Type -AssemblyName System.Windows.Forms

# Define the New-GuiMenu function
function New-GuiMenu {
    param(
        [string]$Title,
        [int]$Width,
        [int]$Height
    )

    # Create a new Windows Forms form object with the specified title and size
    $form = New-Object System.Windows.Forms.Form
    $form.Text = $Title
    $form.Width = $Width
    $form.Height = $Height

    # Return the form object
    return $form
}

# Define the New-GuiButton function
function New-GuiButton {
    param(
        [string]$Text,
        [int]$Width = 75,
        [int]$Height = 23
    )

    # Create a new Windows Forms button object with the specified text, width, and height
    $button = New-Object System.Windows.Forms.Button
    $button.Text = $Text
    $button.Width = $Width
    $button.Height = $Height

    # Return the button object
    return $button
}

# Define the Add-GuiMenuItem function
function Add-GuiMenuItem {
    param(
        [System.Windows.Forms.Form]$Menu,
        [System.Windows.Forms.Button]$Control,
        [ScriptBlock]$OnClick
    )

    # Set the button's OnClick event handler to the specified script block
    $Control.Add_Click($OnClick)

    # Add the button to the form's Controls collection
    $Menu.Controls.Add($Control)
}

# Define the Show-GuiMenu function
function Show-GuiMenu {
    param(
        [System.Windows.Forms.Form]$Menu
    )

    # Display the menu form as a dialog and return the result
    return $Menu.ShowDialog()
}
