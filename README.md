<img src="https://upload.wikimedia.org/wikipedia/commons/5/5e/Windows_10x_Icon.png" width="30%" align="right" />

<h1>Windows 11 Cheatsheet</h1>

> [!NOTE]
> All scripts in this document should be executed in **Windows Powershell as Administrator**.

- [Windows Defender ignore list](#windows-defender-ignore-list)
- [Powershell](#powershell)
- [Mount network shares](#mount-network-shares)
- [WinGet (Windows Package Manager CLI)](#winget-windows-package-manager-cli)
- [Universal time](#universal-time)
- [Visual Studio Code](#visual-studio-code)
- [Node.js](#nodejs)
- [Common commands](#common-commands)
- [WSL2](#wsl2)
- [Docksal (WSL2)](#docksal-wsl2)
- [Edit hosts](#edit-hosts)
- [List of `ENVIRONMENT` variables](#list-of-environment-variables)

## Activation

https://github.com/massgravel/Microsoft-Activation-Scripts

## Codecs

Open in browser: 
- HEVC: `ms-windows-store://pdp/?ProductId=9n4wgh0z6vhq`
- AV1: `ms-windows-store://pdp/?ProductId=9MVZQVXJBQ9V`

## Windows Defender ignore list

```powershell
ForEach ($item in @(
  "${env:WINDIR}\System32\drivers\etc\hosts"
  "D:\Apps"
  "E:\Install"
)) { Add-MpPreference -ExclusionPath (Convert-Path -Path $item) }
```

## Powershell

Update help for powershell:

```powershell
Update-Help -ErrorAction Ignore
```

Allow to run PS scripts:

```powershell
Set-ExecutionPolicy RemoteSigned
```

## Disable hibernation

```powershell
powercfg.exe /hibernate off
```

## Disable random awake in sleep mode

List devices that can awake system:

```powershell
powercfg -devicequery wake_armed
```

Disable awake for the device:
```powershell
powercfg /devicedisablewake "Device Name"
```

## Mount network shares

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

## WinGet (Windows Package Manager CLI)

> [!NOTE]
> `winget` app is not available by default. [**App Installer**](https://www.microsoft.com/en-us/p/app-installer/9nblggh4nns1) app needs to be installed first (using Microsoft Store).

Search for packages

```powershell
winget search <appName>
```

List installed apps

```powershell
winget list
```

Update apps

```powershell
winget upgrade --all
```

Install packages

```powershell
ForEach ($item in @(
  #"SteelSeries.GG"
  #"Nvidia.GeForceExperience" 

  ###> Internet
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
  #"TorProject.TorBrowser"
  #"WireGuard.WireGuard"
  #"Cloudflare.Warp" # CloudFlare's VPN
  #"tailscale.tailscale"
  #"Transmission.Transmission"
  ###< Internet

  ###> System
  "7zip.7zip"
  "CrystalDewWorld.CrystalDiskInfo"
  "CrystalDewWorld.CrystalDiskMark"
  "CrystalRich.LockHunter"
  "namazso.OpenHashTab"
  "REALiX.HWiNFO" # Hardware Analysis, Monitoring and Reporting
  "Rufus.Rufus"
  "Synology.DriveClient"
  "TeamViewer.TeamViewer"
  "WinDirStat.WinDirStat"
  #"WiseCleaner.WiseRegistryCleaner"
  #"WiseCleaner.WiseProgramUninstaller"
  #"WiseCleaner.WiseDiskCleaner"
  #"HermannSchinagl.LinkShellExtension"
  #"Piriform.CCleaner"
  #"Piriform.Defraggler"
  #"Piriform.Recuva"
  #"Piriform.Speccy"
  ###< System

  ###> Media
  "CodecGuide.K-LiteCodecPack.Mega"
  "HandBrake.HandBrake" # Video converter
  "XnSoft.XnViewMP"
  #"VideoLAN.VLC"
  ###< Media

  ###> Runtimes, language interpriters
  # "Google.PlatformTools" # Adds adb and fastboot
  "OpenAL.OpenAL"
  "Microsoft.DirectX"
  "Microsoft.DotNet.DesktopRuntime.3_1"
  "Microsoft.DotNet.DesktopRuntime.5"
  "Microsoft.DotNet.DesktopRuntime.6"
  "Microsoft.DotNet.DesktopRuntime.7"
  "Microsoft.DotNet.DesktopRuntime.8"
  "Microsoft.DotNet.DesktopRuntime.9"
  "Microsoft.VCRedist.2015+.x64"
  "Microsoft.VCRedist.2015+.x86"
  #"Microsoft.VCRedist.2015+.arm64"

  "Oracle.JavaRuntimeEnvironment"
  "Microsoft.OpenJDK.21" # LTS
  #"AdoptOpenJDK.OpenJDK.21" # LTS

  "OpenJS.NodeJS.LTS"
  "Python.Python.3"
  ###< Runtimes, language interpriters

  ###> Developer tools, editors, IDEs
  "Git.Git"
  "JetBrains.Toolbox"
  "Microsoft.VisualStudioCode"
  #"Amazon.AWSCLI"
  #"Amazon.SAM-CLI"
  #"Docker.DockerDesktop"
  #"GitHub.cli"
  #"SublimeHQ.SublimeMerge"
  #"SublimeHQ.SublimeText.4"
  ###< Developer tools, editors, IDEs

  ###> Games
  #"EpicGames.EpicGamesLauncher"
  #"Libretro.RetroArch"
  #"Valve.Steam"
  ###< Games

  ###> Office
  #"TheDocumentFoundation.LibreOffice"
  "ONLYOFFICE.DesktopEditors"
  "TrackerSoftware.PDF-XChangePRO"
  ###< Office
)) { winget install --id $item --accept-source-agreements }
```

## Universal time

For fixing incorrect time in Windows with dual-boot installed linux, import following to registry:  

Enable:
```powershell
Set-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Control\TimeZoneInformation" -Name "RealTimeIsUniversal" -Type DWord -Value 1
```

Disable:
```powershell
Set-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Control\TimeZoneInformation" -Name "RealTimeIsUniversal" -Type DWord -Value 0
```

<img src="https://cdn.svgporn.com/logos/visual-studio-code.svg" width="20%" align="right" /><br/>

## Visual Studio Code

Install using winget

```powershell
winget install Microsoft.VisualStudioCode
```

Use config from my dotfiles repo:

```powershell
Invoke-WebRequest https://raw.githubusercontent.com/alexander-danilenko/dotfiles/main/.config/Code/User/settings.json -OutFile "${env:APPDATA}\Code\User\settings.json"
```

Following command installs `code` extensions by extension id:

```powershell
ForEach ($extension in @(
    "acarreiro.calculate"                # Calculates inline math expr
    "amazonwebservices.aws-toolkit-vscode" # AWS toolkit
    "christian-kohler.path-intellisense" # File path autocomplete
    "coenraads.bracket-pair-colorizer"   # Bracket Pair Colorizer
    "dakara.transformer"                 # Filter, Sort, Unique, Reverse, Align, CSV, Line Selection, Text Transformations and Macros
    "editorconfig.editorconfig"          # EditorConfig support
    "esbenp.prettier-vscode"             # Prettier - Code formatter
    "golang.go"                          # Golang support
    "hookyqr.beautify"                   # HTML/JSON beautifier
    "mhutchie.git-graph"                 # Git graph
    "mikestead.dotenv"                   # .env support
    "ms-azuretools.vscode-docker"        # Docker support
    "ms-python.python"                   # Python support
    "ms-vscode-remote.remote-ssh"        # SSH support 
    "tommasov.hosts"                     # Hosts file syntax highlighter.
    "tyriar.lorem-ipsum"                 # Lorem Ipsum generator
    "william-voyek.vscode-nginx"         # nginx.conf support
    "yzhang.markdown-all-in-one"         # Markdown tools
    #"alefragnani.Bookmarks"             # Bookmarks
    #"TabNine.tabnine-vscode"            # AI-assisted autocomplete

    # Node/NPM/Yarn specific extensions
    "christian-kohler.npm-intellisense" # NPM better autocomplete
    "dbaeumer.vscode-eslint"           # Eslint support
    "mariusschulz.yarn-lock-syntax"    # yarn.lock syntax highlight

    # PHP/Drupal specific extensions
    "ikappas.composer" # Composer support
    "ikappas.phpcs"    # PHP CodeSniffer

    # Themes
    "github.github-vscode-theme"    # GitHub color theme
    "pkief.material-icon-theme"     # Material Icon Theme
    "rokoroku.vscode-theme-darcula" # JetBrains-like theme.
)) { code --install-extension $extension --force }
```

<img src="https://cdn.svgporn.com/logos/nodejs.svg" width="17%" align="right" /><br/>

## Node.js

Install node:

```bash
winget install --id OpenJS.NodeJS.LTS
```

> [!IMPORTANT]
> After installing node.js **need to restart terminal** before installing npm packages.

NPM global packages:

```bash
$packages=@(
  "bower"
  "dynamodb-admin" # Handy Web-UI for viewing local DynamoDB data
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

## Common commands

| Action | Command |
| ------ | ------- |
| Disable password prompt on windows load | `netplwiz` |
| Reset DNS | `ipconfig /flushdns; netsh winsock reset` |

## WSL2

Enable WSL (Windows Subsystem Linux) and set WSL2 as the default.

```powershell
wsl --install --distribution Debian
wsl --set-default-version 2
```

List all available to install distros:
```powershell
wsl --list --online
```

> [!IMPORTANT]
> After WSL installation and before installing any distro you **need to reboot**!

Install distros:
```powershell
wsl --install --distribution Ubuntu-20.04
wsl --install --distribution Debian
```

List installed versions:
```
wsl --list --verbose
```

Get distro ip address:
```powershell
wsl --distribution Ubuntu-20.04 --exec ip route list default
```

✨ Check out my [**Ubuntu Cheatsheet**](https://gist.github.com/alexander-danilenko/175b15a02c419bdec9ccc4c83189e510).

## Docksal (WSL2)

> [!IMPORTANT]
> Make sure you have WSLv2 engine used for Ubuntu distro by running `wsl --list --verbose`. `VERSION` should be `2`.

Run **Windows Terminal**, open **Ubuntu** terminal tab.

Install docker using docker repos (run in Ubuntu shell):
```
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg && \
echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null && \
sudo apt update && \
sudo apt install -y docker-ce docker-ce-cli docker-compose
```

Add current user to docker user group (run in Ubuntu shell):
```
sudo usermod -aG docker "$USER" && \
newgrp docker
```

Install Docksal (run in Ubuntu shell):
```bash
bash <(curl -fsSL https://get.docksal.io) && \
fin config set --global DOCKSAL_VHOST_PROXY_IP=127.0.0.1 && \
fin config set --global DOCKSAL_DNS_DOMAIN=docksal.site && \
fin system reset vhost-proxy
```

Grab WSL Distro IP (run in Ubuntu shell):
```bash
ip route list default
```

Add all projects to windows hosts using WSL distro IP.

## Backup

```powershell
$backupDate=$(Get-Date -Format 'yyyyMMdd_HHmm')
$dirs=@{
  $env:USERNAME = $env:USERPROFILE
  APPDATA = $env:APPDATA
}; foreach ($key in $dirs.GetEnumerator()) {
  $backupDir=$($key.Value)
  $backupType=$($key.Name)
  $archiveName="${backupDate}_${backupType}.zip"

  Write-Host -ForegroundColor Yellow "Archiving '$backupDir' to '$archiveName'..."
  Compress-Archive $backupDir -Force -CompressionLevel NoCompression -DestinationPath $archiveName
  Write-Host -ForegroundColor Green "Archive created: $archiveName"
}
pause
```

## Edit hosts

```powershell
code %SystemRoot%\System32\drivers\etc\hosts
```

## List of `ENVIRONMENT` variables
<details><summary>See table</summary>

| Variable | Volatile (Read-Only) | Default value assuming the system drive is C: |
|----------|:--------------------:|-----------------------------------------|
| `ALLUSERSPROFILE` | | C:\ProgramData |
| `APPDATA` | | C:\Users\{username}\AppData\Roaming |
| `CD` | Y | The current directory (string). |
| `ClientName` | Y | Terminal servers only - the ComputerName of a remote host. |
| `CMDEXTVERSION` | Y | The current Command Processor Extensions version number. (NT = "1", Win2000+ = "2".) |
| `CMDCMDLINE` | Y | The original command line that invoked the Command Processor. |
| `CommonProgramFiles` | | C:\Program Files\Common Files |
| `COMMONPROGRAMFILES(x86)` | | C:\Program Files (x86)\Common Files |
| `COMPUTERNAME` | | {computername} |
| `COMSPEC` | | C:\Windows\System32\cmd.exe or if running a 32 bit WOW - C:\Windows\SysWOW64\cmd.exe |
| `DATE` | Y | The current date using same region specific format as DATE. |
| `ERRORLEVEL` | Y | The current ERRORLEVEL value, automatically set when a program exits. |
| `FPS_BROWSER_APP_PROFILE_STRING` `FPS_BROWSER_USER_PROFILE_STRING` | | Internet Explorer Default These are undocumented variables for the Edge browser in Windows 10. |
| `HighestNumaNodeNumber` | Y (hidden) | The highest NUMA node number on this computer. |
| `HOMEDRIVE` | Y | C: |
| `HOMEPATH` | Y | \Users\{username} |
| `LOCALAPPDATA` | | C:\Users\{username}\AppData\Local |
| `LOGONSERVER` | | \\{domain_logon_server} |
| `NUMBER_OF_PROCESSORS` | Y | The Number of processors running on the machine. | Y | Operating system on the user's workstation. |
| `PATH` | User and System | C:\Windows\System32\;C:\Windows\;C:\Windows\System32\Wbem;{plus program paths}|
| `PATHEXT` | | .COM; .EXE; .BAT; .CMD; .VBS; .VBE; .JS ; .WSF; .WSH; .MSC Determine the default executable file extensions to search for and use, and in which order, left to right. The syntax is like the PATH variable - semicolon separators. |
| `PROCESSOR_ARCHITECTURE` | Y | AMD64/IA64/x86 This doesn't tell you the architecture of the processor but only of the current process, so it returns "x86" for a 32 bit WOW process running on 64 bit Windows. See detecting OS 32/64 bit |
| `PROCESSOR_ARCHITEW6432` | | =%PROCESSOR_ARCHITECTURE% (but only available to 64 bit processes) |
| `PROCESSOR_IDENTIFIER` | Y | Processor ID of the user's workstation. |
| `PROCESSOR_LEVEL` | Y | Processor level of the user's workstation. |
| `PROCESSOR_REVISION` | Y | Processor version of the user's workstation. |
| `ProgramW6432` | | =%ProgramFiles%(but only available when running under a 64 bit OS) |
| `ProgramData` | | C:\ProgramData |
| `ProgramFiles` | | C:\Program Files or C:\Program Files (x86) |
| `ProgramFiles(x86) 1` | | C:\Program Files (x86) (but only available when running under a 64 bit OS) |
| `PROMPT` | | Code for current command prompt format,usually $P$G C:> |
| `PSModulePath` | | %SystemRoot%\system32\WindowsPowerShell\v1.0\Modules\ |
| `Public` | | C:\Users\Public |
| `RANDOM` | Y | A random integer number, anything from 0 to 32,767 (inclusive). |
| `%SessionName%` | | Terminal servers only - for a terminal server session, SessionName is a combination of the connection name, followed by #SessionNumber. For a console session, SessionName returns "Console". |
| `SYSTEMDRIVE` | | C:|
| `SYSTEMROOT` | | By default, Windows is installed to C:\Windows but there's no guarantee of that, Windows can be installed to a different folder, or a different drive letter. systemroot is a read-only system variable that will resolve to the correct location. Defaults in early Windows versions are C:\WINNT, C:\WINNT35 and C:\WTSRV |
| `TEMP` and `TMP` | User Variable | C:\Users\{Username}\AppData\Local\Temp Under XP this was \{username}\Local Settings\Temp |
| `TIME` | Y | The current time using same format as TIME. |
| `UserDnsDomain` | Y User Variable | Set if a user is a logged on to a domain and returns the fully qualified DNS domain that the currently logged on user's account belongs to. |
| `USERDOMAIN` | | {userdomain} |
| `USERDOMAIN_roamingprofile` | | The user domain for RDS or standard roaming profile paths. Windows 8/10/2012 (or Windows 7/2008 with Q2664408) |
| `USERNAME` | | {username} |
| `USERPROFILE` | | %SystemDrive%\Users\{username} This is equivalent to the $HOME environment variable in Unix/Linux |
| `WINDIR` | | %windir% is a regular User variable and can be changed, which makes it less robust than %SystemRoot% Set by default as windir=%SystemRoot% %WinDir% pre-dates Windows NT, its use in many places has been replaced by the system variable: %SystemRoot% |

</details>


## Troubleshooting

### Firefox video freeze

If video opened in 2nd monitor Firefox freezes during a game ran on 1st monitor:
- Open `about:config` in firefox
- Set `widget.windows.window_occlusion_tracking.enabled` to `false`