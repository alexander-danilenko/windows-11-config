# Windows 11 Configuration Guide

<img src="https://upload.wikimedia.org/wikipedia/commons/5/5e/Windows_10x_Icon.png" width="30%" align="right" />

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
For Windows activation, use the official Microsoft Activation Scripts:
https://github.com/massgravel/Microsoft-Activation-Scripts

### Codecs Installation
Install essential codecs from Microsoft Store:
- HEVC: `ms-windows-store://pdp/?ProductId=9n4wgh0z6vhq`
- AV1: `ms-windows-store://pdp/?ProductId=9MVZQVXJBQ9V`

### Power Management

#### Disable Hibernation
```powershell
powercfg.exe /hibernate off
```

#### Disable Random Awake in Sleep Mode
List devices that can wake the system:
```powershell
powercfg -devicequery wake_armed
```

Disable wake for specific device:
```powershell
powercfg /devicedisablewake "Device Name"
```

### Time Settings
For systems with dual-boot (Windows + Linux), configure universal time:

Enable universal time:
```powershell
Set-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Control\TimeZoneInformation" -Name "RealTimeIsUniversal" -Type DWord -Value 1
```

Disable universal time:
```powershell
Set-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Control\TimeZoneInformation" -Name "RealTimeIsUniversal" -Type DWord -Value 0
```

## Security

### Windows Defender Configuration
Add paths to Windows Defender ignore list:
```powershell
ForEach ($item in @(
  "${env:WINDIR}\System32\drivers\etc\hosts"
  "D:\Apps"
  "E:\Install"
)) { Add-MpPreference -ExclusionPath (Convert-Path -Path $item) }
```

### PowerShell Security
Update PowerShell help:
```powershell
Update-Help -ErrorAction Ignore
```

Allow running PowerShell scripts:
```powershell
Set-ExecutionPolicy RemoteSigned
```

## Development Environment

### Visual Studio Code

#### Installation
```powershell
winget install Microsoft.VisualStudioCode
```

#### Configuration
Import settings from dotfiles:
```powershell
Invoke-WebRequest https://raw.githubusercontent.com/alexander-danilenko/dotfiles/main/.config/Code/User/settings.json -OutFile "${env:APPDATA}\Code\User\settings.json"
```

#### Recommended Extensions
```powershell
ForEach ($extension in @(
    "acarreiro.calculate"                # Calculates inline math expr
    "amazonwebservices.aws-toolkit-vscode" # AWS toolkit
    "christian-kohler.path-intellisense" # File path autocomplete
    "coenraads.bracket-pair-colorizer"   # Bracket Pair Colorizer
    "dakara.transformer"                 # Text transformations
    "editorconfig.editorconfig"          # EditorConfig support
    "esbenp.prettier-vscode"             # Code formatter
    "golang.go"                          # Golang support
    "hookyqr.beautify"                   # HTML/JSON beautifier
    "mhutchie.git-graph"                 # Git graph
    "mikestead.dotenv"                   # .env support
    "ms-azuretools.vscode-docker"        # Docker support
    "ms-python.python"                   # Python support
    "ms-vscode-remote.remote-ssh"        # SSH support 
    "tommasov.hosts"                     # Hosts file syntax
    "tyriar.lorem-ipsum"                 # Lorem Ipsum generator
    "william-voyek.vscode-nginx"         # nginx.conf support
    "yzhang.markdown-all-in-one"         # Markdown tools
)) { code --install-extension $extension --force }
```

### Node.js Setup

#### Installation
```powershell
winget install --id OpenJS.NodeJS.LTS
```

> [!IMPORTANT]
> After installing Node.js, restart the terminal before installing npm packages.

#### Global NPM Packages
```powershell
$packages=@(
  "bower"
  "eslint"
  "eslint-config-airbnb"
  "eslint-config-google"
  "eslint-config-standard"
  "eslint-plugin-import"
  "eslint-plugin-jsx-a11y"
  "eslint-plugin-node"
  "eslint-plugin-promise"
  "eslint-plugin-react"
  "eslint-plugin-react-hooks"
  "firebase-tools"
  "flow"
  "flow-bin"
  "gulp"
  "http-server"
  "lsp"
  "snyk"
  "typescript"
  "vscode-css-languageserver-bin"
  "vscode-html-languageserver-bin"
  "yarn"
); npm install -g $packages
```

### WSL2 Configuration

#### Installation
```powershell
wsl --install --distribution Debian
wsl --set-default-version 2
```

#### List Available Distros
```powershell
wsl --list --online
```

> [!IMPORTANT]
> After WSL installation and before installing any distro, you need to reboot!

#### Install Distros
```powershell
wsl --install --distribution Ubuntu-20.04
wsl --install --distribution Debian
```

#### List Installed Versions
```powershell
wsl --list --verbose
```

#### Get Distro IP Address
```powershell
wsl --distribution Ubuntu-20.04 --exec ip route list default
```

## Network Configuration

### Network Shares
```powershell
$cred = Get-Credential -Message "Enter NAS User credentials"
$drives = @{
    B = "\\192.168.50.123\Books"
    H = "\\192.168.50.123\Homes\admin"
    M = "\\192.168.50.123\Music\Музыка"
    V = "\\192.168.50.123\Videos"
}; foreach($driveLetter in $drives.keys) {
  Remove-PSDrive -Name $driveLetter -ErrorAction SilentlyContinue
  New-PSDrive -Name $driveLetter -Root $drives[$driveLetter] -Persist -PSProvider "FileSystem" -Credential $cred
}
```

### Hosts File Management
```powershell
code %SystemRoot%\System32\drivers\etc\hosts
```

## Package Management

### WinGet Usage

> [!NOTE]
> `winget` app is not available by default. [**App Installer**](https://www.microsoft.com/en-us/p/app-installer/9nblggh4nns1) needs to be installed first.

#### Search for Packages
```powershell
winget search <appName>
```

#### List Installed Apps
```powershell
winget list
```

#### Update Apps
```powershell
winget upgrade --all
```

### Common Applications
```powershell
ForEach ($item in @(
  # Internet
  "AgileBits.1Password"
  "Discord.Discord"
  "Google.Chrome"
  "Mozilla.Firefox"
  "Notion.Notion"
  "qBittorrent.qBittorrent"
  "ProtonTechnologies.ProtonVPN"
  "SlackTechnologies.Slack"
  "Telegram.TelegramDesktop"
  "Viber.Viber"

  # System
  "7zip.7zip"
  "CrystalDewWorld.CrystalDiskInfo"
  "CrystalDewWorld.CrystalDiskMark"
  "CrystalRich.LockHunter"
  "namazso.OpenHashTab"
  "REALiX.HWiNFO"
  "Rufus.Rufus"
  "Synology.DriveClient"
  "TeamViewer.TeamViewer"
  "WinDirStat.WinDirStat"

  # Media
  "CodecGuide.K-LiteCodecPack.Mega"
  "HandBrake.HandBrake"
  "XnSoft.XnViewMP"

  # Development
  "Git.Git"
  "JetBrains.Toolbox"
  "Microsoft.VisualStudioCode"
  "OpenJS.NodeJS.LTS"
  "Python.Python.3"

  # Office
  "ONLYOFFICE.DesktopEditors"
  "TrackerSoftware.PDF-XChangePRO"
)) { winget install --id $item --accept-source-agreements }
```

## Troubleshooting

### Firefox Video Freeze
If video freezes in Firefox when running games on a second monitor:
1. Open `about:config` in Firefox
2. Set `widget.windows.window_occlusion_tracking.enabled` to `false`

### Common Commands
| Action | Command |
| ------ | ------- |
| Disable password prompt on windows load | `netplwiz` |
| Reset DNS | `ipconfig /flushdns; netsh winsock reset` |

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