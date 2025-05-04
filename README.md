# Windows 11 Configuration Guide

<img src="https://upload.wikimedia.org/wikipedia/commons/5/5e/Windows_10x_Icon.png" width="30%" align="right" />

A comprehensive guide for configuring and optimizing Windows 11 for development, productivity, and security. This guide covers essential system settings, development environment setup, network configuration, and package management.

## Table of Contents

- [System Configuration](#system-configuration)
  - [Windows Activation](#windows-activation)
  - [Codecs Installation](#codecs-installation)
  - [Power Management](#power-management)
  - [Time Settings](#time-settings)
- [Security](#security)
  - [Windows Defender Configuration](#windows-defender-configuration)
  - [PowerShell Security](#powershell-security)
- [Development Environment](#development-environment)
  - [Visual Studio Code](#visual-studio-code)
  - [Node.js Setup](#nodejs-setup)
  - [WSL2 Configuration](#wsl2-configuration)
- [Network Configuration](#network-configuration)
  - [Network Shares](#network-shares)
  - [Hosts File Management](#hosts-file-management)
- [Package Management](#package-management)
  - [WinGet Usage](#winget-usage)
  - [Common Applications](#common-applications)
- [Troubleshooting](#troubleshooting)
- [Environment Variables](#environment-variables)

## System Configuration

### Windows Activation
For Windows activation, use the official Microsoft Activation Scripts from the massgravel repository. This provides a reliable and secure method to activate Windows 11:
https://github.com/massgravel/Microsoft-Activation-Scripts

### Codecs Installation
Install essential video codecs from Microsoft Store to ensure proper playback of various media formats:
- HEVC (High Efficiency Video Coding): `ms-windows-store://pdp/?ProductId=9n4wgh0z6vhq`
- AV1 (AOMedia Video 1): `ms-windows-store://pdp/?ProductId=9MVZQVXJBQ9V`

### Power Management

#### Disable Hibernation
Disable hibernation to free up disk space and improve system performance:
```powershell
powercfg.exe /hibernate off
```

#### Disable Random Awake in Sleep Mode
Prevent unwanted system wake-ups by identifying and disabling devices that can wake the system from sleep:

List devices that can wake the system:
```powershell
powercfg -devicequery wake_armed
```

Disable wake for specific device:
```powershell
powercfg /devicedisablewake "Device Name"
```

### Time Settings
For systems with dual-boot (Windows + Linux), configure universal time to prevent time synchronization issues between operating systems:

Enable universal time:
```powershell
Set-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Control\TimeZoneInformation" -Name "RealTimeIsUniversal" -Type DWord -Value 1
```

Disable universal time:
```powershell
Set-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Control\TimeZoneInformation" -Name "RealTimeIsUniversal" -Type DWord -Value 0
```

## Security

### PowerShell Security
Enhance PowerShell security and functionality with these essential configurations:

Configure PowerShell execution policy to allow running local scripts while maintaining security:
```powershell
Set-ExecutionPolicy RemoteSigned
```

Update PowerShell help files for better command documentation:
```powershell
Update-Help -ErrorAction Ignore
```


## Development Environment

### Visual Studio Code

#### Installation
Install Visual Studio Code using WinGet package manager:
```powershell
winget install Microsoft.VisualStudioCode
```

#### Configuration
Import settings from dotfiles repository for optimal development experience:
```powershell
Invoke-WebRequest https://raw.githubusercontent.com/alexander-danilenko/dotfiles/main/.config/Code/User/settings.json -OutFile "${env:APPDATA}\Code\User\settings.json"
```

#### Recommended Extensions
Install essential extensions for enhanced development workflow:
```powershell
ForEach ($extension in @(
    "acarreiro.calculate"                # Inline mathematical expression calculator
    "editorconfig.editorconfig"          # EditorConfig support for consistent coding styles
    "mikestead.dotenv"                   # Environment variable management
    "ms-python.python"                   # Python development environment
    "tyriar.lorem-ipsum"                 # Lorem Ipsum text generator
    "yzhang.markdown-all-in-one"         # Markdown editing and preview tools
)) { code --install-extension $extension --force }
```

### Node.js Setup

#### Installation
Install the Long Term Support (LTS) version of Node.js for stable development:
```powershell
winget install --id OpenJS.NodeJS.LTS
```

> [!IMPORTANT]
> After installing Node.js, restart the terminal to ensure proper environment variable updates before installing npm packages.

### WSL2 Configuration

#### Installation
Install WSL2 with Debian as the default distribution:
```powershell
wsl --install --distribution Debian
wsl --set-default-version 2
```

#### List distros available to install 
View all available Linux distributions for WSL:
```powershell
wsl --list --online
```

> [!IMPORTANT]
> After WSL installation and before installing any distro, a system reboot is required to ensure proper kernel integration!

#### Install Distros
Install specific Linux distributions for development:
```powershell
wsl --install --distribution Ubuntu-20.04
wsl --install --distribution Debian
```

#### List Installed Versions
View detailed information about installed WSL distributions:
```powershell
wsl --list --verbose
```

#### Get Distro IP Address
Retrieve the IP address of a specific WSL distribution:
```powershell
wsl --distribution Ubuntu-20.04 --exec ip route list default
```

## Network Configuration

### Network Credentials
Configure persistent secure credentials:
```powershell
$SmbAddresses = @("192.168.50.123", "NetworkStorage")
$cred = Get-Credential -Message "Enter credentials for NAS SMB access"
foreach ($address in $SmbAddresses) {
    # Remove leading backslashes for cmdkey.exe
    $cmdkeyTarget = $address -replace "^\\\\+", ""
    # Remove existing Windows Credential
    cmdkey.exe /delete:$cmdkeyTarget | Out-Null
    # Add new Windows Credential
    cmdkey.exe /add:$cmdkeyTarget /user:$($cred.UserName) /pass:$($cred.GetNetworkCredential().Password)
}
```

### Hosts File Management
Open the hosts file in Visual Studio Code for easy editing:
```powershell
code %SystemRoot%\System32\drivers\etc\hosts
```

## Package Management

### WinGet Usage

> [!NOTE]
> `winget` app is not available by default. [**App Installer**](https://www.microsoft.com/en-us/p/app-installer/9nblggh4nns1) needs to be installed first from the Microsoft Store.

#### Search for Packages
Search for available applications in the WinGet repository:
```powershell
winget search <appName>
```

#### List Installed Apps
View all installed applications managed by WinGet:
```powershell
winget list
```

#### Update Apps
Update all installed applications to their latest versions:
```powershell
winget upgrade --all
```

### Common Applications
Install essential applications for development, productivity, and system management:
```powershell
ForEach ($item in @(
  # Internet
  "AgileBits.1Password"          # Password management
  "Discord.Discord"              # Communication platform
  "Google.Chrome"                # Web browser
  "Mozilla.Firefox"              # Web browser
  "Notion.Notion"                # Note-taking and collaboration
  "qBittorrent.qBittorrent"      # Torrent client
  "ProtonTechnologies.ProtonVPN" # VPN service
  "SlackTechnologies.Slack"      # Team communication
  "Telegram.TelegramDesktop"     # Messaging app
  "Viber.Viber"                  # Messaging app

  # System
  "7zip.7zip"                    # File archiver
  "CrystalDewWorld.CrystalDiskInfo" # Disk health monitoring
  "CrystalDewWorld.CrystalDiskMark" # Disk performance testing
  "CrystalRich.LockHunter"       # File unlocker
  "namazso.OpenHashTab"          # File hash calculator
  "REALiX.HWiNFO"               # System information
  "Rufus.Rufus"                  # USB bootable media creator
  "Synology.DriveClient"         # Cloud storage sync
  "TeamViewer.TeamViewer"        # Remote access
  "WinDirStat.WinDirStat"        # Disk usage analyzer

  # Media
  "CodecGuide.K-LiteCodecPack.Mega" # Media codec pack
  "HandBrake.HandBrake"          # Video transcoder
  "XnSoft.XnViewMP"             # Image viewer

  # Development
  "Git.Git"                      # Version control
  "JetBrains.Toolbox"            # JetBrains IDE manager
  "Microsoft.VisualStudioCode"   # Code editor
  "OpenJS.NodeJS.LTS"            # JavaScript runtime
  "Python.Python.3"              # Python interpreter

  # Office
  "ONLYOFFICE.DesktopEditors"    # Office suite
  "TrackerSoftware.PDF-XChangePRO" # PDF editor
)) { winget install --id $item --accept-source-agreements }
```

## Troubleshooting

### Firefox Video Freeze
If video playback freezes in Firefox when running games on a second monitor, follow these steps:
1. Open `about:config` in Firefox
2. Set `widget.windows.window_occlusion_tracking.enabled` to `false`

### Common Commands
| Action | Command |
| ------ | ------- |
| Disable password prompt on windows load | `netplwiz` |
| Reset DNS and network stack | `ipconfig /flushdns; netsh winsock reset` |

## Environment Variables

<details><summary>See table</summary>

| Variable | Volatile (Read-Only) | Default value assuming the system drive is C: |
|----------|:--------------------:|-----------------------------------------|
| `ALLUSERSPROFILE` | | C:\ProgramData |
| `APPDATA` | | C:\Users\{username}\AppData\Roaming |
| `CD` | Y | The current directory (string). |
| `ClientName` | Y | Terminal servers only - the ComputerName of a remote host. |
| `CMDEXTVERSION` | Y | The current Command Processor Extensions version number. |
| `CMDCMDLINE` | Y | The original command line that invoked the Command Processor. |
| `CommonProgramFiles` | | C:\Program Files\Common Files |
| `COMMONPROGRAMFILES(x86)` | | C:\Program Files (x86)\Common Files |
| `COMPUTERNAME` | | {computername} |
| `COMSPEC` | | C:\Windows\System32\cmd.exe |
| `DATE` | Y | The current date using same region specific format as DATE. |
| `ERRORLEVEL` | Y | The current ERRORLEVEL value, automatically set when a program exits. |
| `HOMEDRIVE` | Y | C: |
| `HOMEPATH` | Y | \Users\{username} |
| `LOCALAPPDATA` | | C:\Users\{username}\AppData\Local |
| `LOGONSERVER` | | \\{domain_logon_server} |
| `NUMBER_OF_PROCESSORS` | Y | The Number of processors running on the machine. |
| `PATH` | User and System | C:\Windows\System32\;C:\Windows\;C:\Windows\System32\Wbem;{plus program paths}|
| `PATHEXT` | | .COM; .EXE; .BAT; .CMD; .VBS; .VBE; .JS ; .WSF; .WSH; .MSC |
| `PROCESSOR_ARCHITECTURE` | Y | AMD64/IA64/x86 |
| `PROCESSOR_IDENTIFIER` | Y | Processor ID of the user's workstation. |
| `PROCESSOR_LEVEL` | Y | Processor level of the user's workstation. |
| `PROCESSOR_REVISION` | Y | Processor version of the user's workstation. |
| `ProgramFiles` | | C:\Program Files or C:\Program Files (x86) |
| `ProgramFiles(x86)` | | C:\Program Files (x86) |
| `PSModulePath` | | %SystemRoot%\system32\WindowsPowerShell\v1.0\Modules\ |
| `SYSTEMDRIVE` | | C:|
| `SYSTEMROOT` | | C:\Windows |
| `TEMP` and `TMP` | User Variable | C:\Users\{Username}\AppData\Local\Temp |
| `TIME` | Y | The current time using same format as TIME. |
| `USERDOMAIN` | | {userdomain} |
| `USERNAME` | | {username} |
| `USERPROFILE` | | %SystemDrive%\Users\{username} |
| `WINDIR` | | %SystemRoot% |

</details>