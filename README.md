<h1 align="center">Windows 11 Configuration Guide</h1>

<img src="https://upload.wikimedia.org/wikipedia/commons/5/5e/Windows_10x_Icon.png" width="30%" align="right" />

A comprehensive guide for configuring and optimizing Windows 11 for development, productivity, and security. This guide covers essential system settings, development environment setup, network configuration, and package management.

<strong>Table of Contents:</strong>

- [System Configuration](#system-configuration)
  - [Windows Activation](#windows-activation)
  - [Power Management](#power-management)
    - [Disable Hibernation](#disable-hibernation)
    - [Disable random awake in sleep mode](#disable-random-awake-in-sleep-mode)
  - [Time settings](#time-settings)
- [Security](#security)
  - [PowerShell Security](#powershell-security)
- [Development Environment](#development-environment)
  - [Visual Studio Code](#visual-studio-code)
    - [Installation](#installation)
    - [Configuration](#configuration)
    - [Recommended Extensions](#recommended-extensions)
  - [Node.JS Setup](#nodejs-setup)
    - [Installation](#installation-1)
    - [Global npm packages](#global-npm-packages)
  - [Windows Subsystem for Linux](#windows-subsystem-for-linux)
    - [Installation](#installation-2)
    - [List distros available to install](#list-distros-available-to-install)
    - [Install Distros](#install-distros)
    - [List Installed Versions](#list-installed-versions)
    - [Get Distro IP Address](#get-distro-ip-address)
    - [Access WSL files](#access-wsl-files)
    - [Access Windows files from WSL](#access-windows-files-from-wsl)
- [Network Configuration](#network-configuration)
  - [Network Credentials](#network-credentials)
  - [Hosts File Management](#hosts-file-management)
- [Package Management](#package-management)
  - [WinGet Usage](#winget-usage)
    - [Search for Packages](#search-for-packages)
    - [List Installed Apps](#list-installed-apps)
    - [Update Apps](#update-apps)
  - [Common Applications](#common-applications)
- [Troubleshooting](#troubleshooting)
  - [Firefox Video Freeze](#firefox-video-freeze)
  - [Common Commands](#common-commands)
- [Environment Variables](#environment-variables)

## System Configuration

### Windows Activation

<img src="https://massgrave.dev/img/logo_small.png" alt="MAS Logo" align="right">

For Windows activation, use the official Microsoft Activation Scripts from the massgravel repository. This provides a reliable and secure method to activate Windows 11:
https://massgrave.dev/

### Power Management

#### Disable Hibernation
Disable hibernation to free up disk space and improve system performance:
```powershell
powercfg.exe /hibernate off
```

#### Disable random awake in sleep mode
Prevent unwanted system wake-ups by identifying and disabling devices that can wake the system from sleep:

List devices that can wake the system:
```powershell
powercfg -devicequery wake_armed
```

Disable wake for specific device:
```powershell
powercfg /devicedisablewake "Device Name"
```

### Time settings
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

(optional) Update PowerShell help files for better command documentation:
```powershell
Update-Help -ErrorAction Ignore
```


## Development Environment

### Visual Studio Code

<img src="https://cdn.svgporn.com/logos/visual-studio-code.svg" align="right" width="25%">

#### Installation
Install Visual Studio Code using WinGet package manager:
```powershell
winget install --id XP9KHM4BK9FZ7Q --accept-source-agreements
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

### Node.JS Setup

<img src="https://cdn.svgporn.com/logos/nodejs-icon.svg" align="right" width="25%">

#### Installation
Install the Long Term Support (LTS) version of Node.js for stable development:
```powershell
winget install --id OpenJS.NodeJS.LTS
```

#### Global npm packages
```powershell
$packages = @(
    "tldr"
); npm install --global $packages
```

> [!IMPORTANT]
> After installing Node.js, restart the terminal to ensure proper environment variable updates before installing npm packages.

### Windows Subsystem for Linux

<img src="https://upload.wikimedia.org/wikipedia/commons/4/49/Windows_Subsystem_for_Linux_logo.png" align="right" width="25%">

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
wsl --install --distribution Ubuntu-24.04
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
wsl --distribution Debian --exec ip route list default
```

#### Access WSL files
Access WSL files from Windows Explorer using the following path format:
```powershell
\\wsl$\<distro-name>
```

For example, to access files in the Debian distribution:
```powershell
\\wsl$\Debian
```

You can also access WSL files directly from Windows applications by using the same path format. This is particularly useful for:
- Opening WSL files in Windows applications
- Copying files between Windows and WSL
- Managing WSL files using Windows file managers

> [!NOTE]
> The WSL filesystem is case-sensitive, unlike Windows. Be mindful of case when accessing files and directories.

#### Access Windows files from WSL

Windows automatically mounts your drives to WSL at the following locations:
- C: drive → `/mnt/c/`
- D: drive → `/mnt/d/`
- E: drive → `/mnt/e/`
- etc.

To access your Windows files, simply navigate to the appropriate mount point:
```bash
cd /mnt/c/
```

> [!IMPORTANT]
> - File permissions and ownership in Windows drives are set to `drwxrwxrwx` (`777`) by default
> - For better performance with Windows files, consider storing project files within the WSL filesystem

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

<img src="https://upload.wikimedia.org/wikipedia/commons/8/8f/Windows_Package_Manager_logo.png" align="right" width="25%">

### WinGet Usage

> [!IMPORTANT]
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
  # AI
  "9NT1R1C2HH7J"     # ChatGPT
  "Anthropic.Claude" # Claude.ai

  # Development
  "Anysphere.Cursor"  # Cursor AI code editor
  "Git.Git"           # Git
  "JetBrains.Toolbox" # JetBrains IDE manager
  "OpenJS.NodeJS.LTS" # Node.JS runtime
  "Python.Python.3"   # Python runtime
  "XP9KHM4BK9FZ7Q"    # Visual Studio Code

  # Entertainment
  "9wzdncrfj3tj" # Netflix
  "9ncbcszsjrsb" # Spotify

  # Internet
  "XP99C9G0KRDZ27"               # 1Password
  "XP8C9QZMS2PC1T"               # Brave Browser
  "XPDC2RH70K22MN"               # Discord
  "Google.Chrome"                # Google Chrome
  "9NZVDKPMR9RD"                 # Mozilla Firefox
  "Notion.Notion"                # Notion
  "qBittorrent.qBittorrent"      # Torrent client
  "ProtonTechnologies.ProtonVPN" # Proton VPN
  "9WZDNCRDK3WP"                 # Slack
  "9NZTWSQNTD0S"                 # Telegram
  "XPFM5P5KDWF0JP"               # Viber

  # Media
  "CodecGuide.K-LiteCodecPack.Mega" # Media codec pack
  "HandBrake.HandBrake"             # Video transcoder
  "9NMZLZ57R3T7"                    # MS HEVC Video Extensions
  "9MVZQVXJBQ9V"                    # MS AV1 Video Extensions
  "9P1J8S7CCWWT"                    # Microsoft Clipchamp
  "XnSoft.XnViewMP"                 # Image viewer
  "XPDM1ZW6815MQM"                  # VLC

  # Office
  "9WZDNCRFJ9W7"                # Cover - Comic Reader
  "9P62ZG8LDZZF"                # DjVu Book Reader
  "9PMZ94127M4G"                # FBReader
  #"9PM5VM1S3VMQ"               # Mozilla Thunderbird Email
  #"ONLYOFFICE.DesktopEditors"  # Office suite
  "XPDF9VL4D5XR9W"              # PDF-XChange Editor

  # System
  "CrystalDewWorld.CrystalDiskInfo" # CrystalDiskInfo
  "CrystalDewWorld.CrystalDiskMark" # CrystalDiskMark
  "CrystalRich.LockHunter"          # File unlocker
  "namazso.OpenHashTab"             # File hash calculator
  "REALiX.HWiNFO"                   # System information
  "9PC3H3V7Q9CH"                    # Rufus
  "Synology.DriveClient"            # Synology Drive
  "WinDirStat.WinDirStat"           # WinDirStat: Disk usage analyzer

  # Utilities
  #"9NBLGGH4S79B"   # OneCommander
  #"9NBLGGH30XJ3"   # Xbox Accessories
  "9PM860492SZD"    # Microsoft PC Manager
  "XP89572Q9J4225"  # Wise Program Uninstaller
  #"XPDLS1XBTXVPP4" # Wise Registry Cleaner
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