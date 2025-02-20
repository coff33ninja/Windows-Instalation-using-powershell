# Windows Installation Automation Tool

A PowerShell-based GUI tool for automating Windows installation and deployment processes. This tool simplifies the process of preparing, partitioning, and deploying Windows installations through an intuitive graphical interface.

## Features

- **Hard Drive Detection**: Automatically detect and select target hard drives
- **Disk Partitioning**: Create and manage disk partitions (MBR/GPT support)
- **ISO Handling**: Mount and manage Windows installation ISO files
- **Windows Version Selection**: Choose specific Windows editions from installation media
- **Automated Deployment**: Streamlined Windows deployment process
- **Boot Sector Management**: Make images bootable with proper boot sector configuration

## Components

### Main Interface (MainMenu.ps1)
The central GUI that provides access to all functionality through an intuitive button interface.

### Core Modules

1. **detect.psm1**
   - Hard drive detection and selection
   - Uses modern CIM instances for hardware detection
   - GUI-based drive selection interface

2. **partition.psm1**
   - Disk partitioning functionality
   - Supports both MBR and GPT partition styles
   - Handles Windows and Data partition creation
   - Includes proper volume formatting and labeling

3. **isoload.psm1**
   - ISO file mounting and management
   - Secure image mounting with proper error handling
   - Drive letter assignment and tracking

4. **selectversion.psm1**
   - Windows edition detection and selection
   - Parses DISM output for available Windows versions
   - User-friendly version selection interface

5. **deploy.psm1**
   - Windows deployment automation
   - System partition handling
   - DISM-based image application
   - Progress tracking and error handling

6. **bootable.psm1**
   - Boot sector configuration
   - Partition activation
   - Boot file verification

## Requirements

- Windows PowerShell 5.1 or later
- Administrative privileges
- DISM (Deployment Image Servicing and Management) tool
- .NET Framework 4.5 or later

## Usage

1. Run MainMenu.ps1 with administrative privileges
2. Follow the GUI prompts for each step:
   - Select target hard drive
   - Configure partitions
   - Mount Windows installation ISO
   - Select Windows version
   - Deploy Windows
   - Configure boot settings

## Best Practices

- Always run with administrative privileges
- Backup important data before partitioning
- Verify Windows ISO integrity before deployment
- Ensure proper boot sector configuration
- Follow Windows deployment guidelines

## Error Handling

The tool includes comprehensive error handling:
- Drive detection verification
- Partition operation validation
- ISO mount status checking
- Deployment process monitoring
- Boot sector verification

## Recent Updates

### Code Quality Improvements
- Replaced WMI queries with modern CIM instances
- Implemented proper PowerShell approved verbs
- Enhanced variable scope management
- Improved error handling and user feedback
- Added GUI-based parameter input forms
- Fixed variable reference syntax
- Standardized function naming conventions

### Technical Improvements
- Better partition management
- Enhanced boot sector handling
- Improved ISO mounting reliability
- More robust Windows version detection
- Streamlined deployment process

## Contributing

Contributions are welcome! Please follow these steps:
1. Fork the repository
2. Create a feature branch
3. Commit your changes
4. Push to the branch
5. Create a Pull Request

## License

MIT
