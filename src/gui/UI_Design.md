# UI Design for Lazy Windows Installer

## Overview
The user interface for the Lazy Windows Installer is designed to be modern, minimalistic, and user-friendly. It allows users to easily select installation files, configure settings, and initiate the installation process.

## Layout
The UI consists of the following sections:

1. **Header**: Displays the project name and version information.
   - Example: "Lazy Windows Installer 1.0"

2. **Select Location of Windows Installation Files**:
   - Dropdown for selecting the file path.
   - Search button to browse for files.

3. **Select Location of the Boot Drive**:
   - Displays available drives and their status.
   - Dropdown for selecting the boot drive.
   - Search button for drive selection.

4. **Select Location of the Installation Drive**:
   - Similar to the boot drive section.
   - Dropdown for selecting the installation drive.
   - Search button for drive selection.

5. **Options Section**:
   - **Edition**: Dropdown for selecting the Windows edition.
   - **Patch Options**: Checkbox for patching `UxTheme.dll`.
   - **Unattended Settings**: Button to configure unattended installation options.
   - **Add Drivers**: Button to add drivers.

6. **Status Section**: Displays the current status of selections and configurations.

7. **Setup Button**: Initiates the installation process.

## Styling
- **Theme**: Dark theme with contrasting text for readability.
- **Visual Cues**: Use of icons and status indicators to enhance user experience.

## Framework
- Consider using windows forms via powershell for a desktop application.

This design aims to provide a seamless experience for users while ensuring all necessary functionalities are easily accessible.
