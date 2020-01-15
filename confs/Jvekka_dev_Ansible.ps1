# Forked from
#   Description: Boxstarter Script
#   Author: Microsoft
#   chocolatey fest demo

# Jvekka notes
#   When WSL and Hyper-V is used, Virtualbox doesn't work.

Disable-UAC
$ConfirmPreference = "None" # Ensure installing powershell modules don't prompt on needed dependencies
choco feature enable -n=allowGlobalConfirmation # Enable allowGlobalConfirmation to confirm packages automatically

# Get the base URI path from the ScriptToCall value
$bstrappackage = "-bootstrapPackage"
$helperUri = $Boxstarter['ScriptToCall']
$strpos = $helperUri.IndexOf($bstrappackage)
$helperUri = $helperUri.Substring($strpos + $bstrappackage.Length)
$helperUri = $helperUri.TrimStart("'", " ")
$helperUri = $helperUri.TrimEnd("'", " ")
$strpos = $helperUri.LastIndexOf("/confs/")
$helperUri = $helperUri.Substring(0, $strpos)
$helperUri += "/scripts"
write-host "helper script base URI is $helperUri"

function executeScript {
    Param ([string]$script)
    write-host "executing $helperUri/$script ..."
	Invoke-Expression ((new-object net.webclient).DownloadString("$helperUri/$script"))
}

#--- Setting up Windows ---
executeScript "FileExplorerSettings.ps1";
executeScript "SystemConfiguration.ps1";
executeScript "RemoveDefaultApps.ps1";
executeScript "CommonDevTools.ps1";
executeScript "Browsers.ps1";
executeScript "HyperV.ps1";
RefreshEnv
executeScript "WSL.ps1";
RefreshEnv
executeScript "VSCode.ps1";
executeScript "coreApps.ps1";


# Install MS developer tools | Not doing anything currently with Az/O365
#   Install-Module -Force Az
#   Install-Module -Force posh-git

# Install tools in WSL instance
write-host "Installing tools inside the WSL distro..."
Ubuntu1804 run apt install ansible -y
Ubuntu1804 run apt install nodejs -y

# personalize
choco install -y microsoft-teams
choco install -y office365business
choco install -y franz
choco install -y spotify

# Set desktop wallpaper randomly from Unsplash.com
New-Item -ItemType Directory C:\Jvekka-projects
New-Item -ItemType Directory C:\Jvekka-projects\Boxstarter
Set-Location C:\Jvekka-projects

Add-Type -AssemblyName System.Windows.Forms
$monitorResolution = "{0}x{1}" -f [System.Windows.Forms.SystemInformation]::PrimaryMonitorSize.Width,[System.Windows.Forms.SystemInformation]::PrimaryMonitorSize.Height
$unsplashWithRes = 'https://source.unsplash.com/random/'+$monitorResolution+'/?computer,tech'
Invoke-WebRequest -Uri $unsplashWithRes -Method Get -ContentType image/jpeg -OutFile 'C:\Jvekka-projects\Boxstarter\bg.jpg'
Set-ItemProperty -path 'HKCU:\Control Panel\Desktop\' -name wallpaper -value 'C:\Jvekka-projects\Boxstarter\bg.jpg'
rundll32.exe user32.dll, UpdatePerUserSystemParameters
RefreshEnv

# Restore
Enable-UAC
Enable-MicrosoftUpdate
Install-WindowsUpdate -acceptEula
choco feature disable -n=allowGlobalConfirmation # Disable allowGlobalConfirmation to confirm packages automatically
