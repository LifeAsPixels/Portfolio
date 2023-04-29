<#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
> TITLE
Settings

> ABOUT
Set static variables, hashes, arrays, and dictionaries; implement inheritences
use vars here as parameters for function calls in a process-file

> TASK

> AUTHOR
LifeAsPixels

# INCLUDE #>
# DO NOT INCLUDE HERE
<#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~#>

<#********************************************************************
# In Disorder
**********************************************************************#>
$Desktop = @{
    Name = "DESKTOPNAME"
    IP = "192.168.1.2"
}
$Laptop = @{
    Name = "LAPTOPNAME"
    IP = "192.168.1.3"
}
$zOU = @{ # Users, Computers, Organizational units
    Name = "WORKGROUP-HOME"
    Members = $Desktop, $Laptop
}
$zSvcAcct = @{ # service account used on LAP for processes that need one like a shared drive
    Name = "$($Desktop.Name)-Svc"
    Description = "Admin service account for $($Desktop.Name)"
    PCName = $Desktop.Name
}

$zRouteProfile = @{
    Gateway = "192.168.1.1"
    MaskBits = 24 # This means subnet mask = 255.255.255.0
    DNS = "1.1.1.1", "1.0.0.1"
    IPv = "IPv4"
}
#write-host "$($Desktop.Name)\$($zSvcAcct.Name)"
$zSMBProfile = @{ # common traits for SMB items
        FullAccess = 'Everyone'
        FolderEnumerationMode = 'AccessBased'
}

$zNetDrive = @(
    @{ # drive on desktop with OS installed on it
        Name = 'DC'
        Description = "OS drive in $($Desktop.Name)."
        Path = 'C:\'
        NetDrive = 'H'
        PCName = $Desktop.Name
    } + $zSMBProfile
    @{ # data drive on desktop -- data drive, information only, no programs installed, no OS, not primary
        Name = 'DD'
        Description = "Data drive in $($Desktop.Name)."
        Path = 'D:\'
        NetDrive = 'I'
        PCName = $Desktop.Name
    } + $zSMBProfile
    @{ # only drive in laptop -- has OS installed on it
        Name = 'LC'
        Description = "OS drive in $($Laptop.Name)"
        Path = 'C:\'
        NetDrive = 'J'
        PCName = $Laptop.Name
    } + $zSMBProfile
)

# shortcuts for programmatically used roots
$zdLife = "I:\Life"
$zdCode = "$($zdLife)\Code"
$zdAsset = "$($zdCode)\_Asset"
$zdProfile = "$($zdAsset)\Profile"
$zdApps = "$($zdAsset)\Auto"
$zdFont = "$($zdAsset)\Font"


# filepaths to profiles and configs for apps for import-export ops
$zPFPowerShell = @{
    Archive = "$($zdProfile)\PowerShell\Profile.ps1"
    App = "$PSHOME\Profile.ps1", "C:\Program Files\PowerShell\7\Profile.ps1"
}
$zPFGitBash = @{
    Archive = "$($zdProfile)\Git-Bash\.minttyrc"
    App = "$env:USERPROFILE\.minttyrc"
}
$zPFVSCode = @{
    Archive = "$($zdProfile)\VSCode\settings.json"
    App = "$env:APPDATA\Code\User\settings.json"
}
$zPFLogitech = @{
    Archive = "$($zdProfile)\Logitech"
    App = "$env:LOCALAPPDATA\Logitech\Logitech Gaming Software\profiles"
}
$zPFMember = $zPFLogitech, $zPFVSCode, $zPFPowerShell, $zPFGitBash

<#********************************************************************
# RegEx
**********************************************************************#>
$NoMatch = ".\*" # does not match any windows directory or file

<#-----------------------------------
# File-Folder
-------------------------------------#>

$FontExt = ".*\.(otf|ttf)"
$FontExtExclude = ".*\.(zip).*"
