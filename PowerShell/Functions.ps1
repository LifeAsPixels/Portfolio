<#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
> TITLE
Functions

> ABOUT
Monolithic. Declare functions here - but not procedural functions.
Call these functions in a process file.

> TASK

> AUTHOR
LifeAsPixels

# INCLUDE #>
# DO NOT INCLUDE HERE
<#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~#>

<#********************************************************************
> Generic -- File-system, embedded fn, QOL coding
**********************************************************************#>
Function z-IsFile {
    param (
        $Item
    )
    Return ((Get-Item $Item) -is [System.IO.FileInfo])
}
function z-IsFolder {
    param (
        $Item
    )
    Return ((Get-Item $Item) -is [System.IO.DirectoryInfo])
}

Function z-MakeCPanelFolder() { # Make  the control panel folder for easy browsing entire list of cpanel features
    $CPanelFolder = "ControlPanel.{ED7BA470-8E54-465E-825C-99712043E01C}"
    mkdir $env:USERPROFILE\Desktop\$CPanelFolder
}
Function z-RegistryReferenceFolder() { # take a data reference from the registry to investigate its source by making dot-folder
    $Reference = "tmp.{1a184871-359e-4f67-aad9-5b9905d62232}"
    mkdir $env:USERPROFILE\Desktop\$Reference
}
Function z-IsNull($obj) { # possible human interpretations for a null
    if ( ($Null -eq $obj) -or
         (($obj -is [String]) -and ($obj -eq [String]::Empty)) -or
         ($obj -is [DBNull]) -or
         ($obj -is [System.Management.Automation.Language.NullString]) )
    { Return $true; }   
    Return $false;
}
Function z-IsAdmin() { # returns true if user session is an admin
    Return ([Security.Principal.WindowsPrincipal] `
      [Security.Principal.WindowsIdentity]::GetCurrent() `
    ).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)
}
Function z-File-Recursive(){ # change this name to Get-FileRecursive
    Param (
        [Parameter(Mandatory)] $Source,
        $Match = $Null,
        $Exclude = $Null
    )
    $ObjShell = New-Object -ComObject Shell.Application # make a new COM Obj to add files and folders so methods and properties can be accessed from their Folder Object and Folder Item classes
    $ObjFolder = $ObjShell.NameSpace($Source) #instantiate an instance of the the COM object using a folder path
    $ObjFolder.Items() | Where-Object {$_.IsFolder} | ForEach-Object {RecursiveFileSearch -Source $_.Path -Match $Match -Exclude $Exclude} # recursively call this Function z-for each sub-folder
    $ObjList = $ObjFolder.Items() | Where-Object {!($_.IsFolder) -And !($_.Path -Match $Exclude) -And ($_.Name -Match "$Match")} # filter files using matching and exclusions
    Return $ObjList # return the list of objects
}
Function z-Trace() {
    Read-Host "Press 'Enter' or 'Return' to continue."
}
Function z-Kudzu() { # Pass two lists or singles (Sources, Destinations)
# Copies all sources to all destionations -- CAREFUL this is a many-to-many operation (X^X)
    Param (
        $Source,
        $Destination
    )
    Foreach($s in $Source) {
        Foreach($d in $Destination) {
            Write-Host "Copy `'$s`' --> `'$d`'"
            Try {
                If (!(Test-Path (Split-Path $d))) {
                    New-Item (Split-Path $d) -Force -Type 'Directory' -ErrorAction Stop
                }
                if (z-IsFolder($s)) {
                    Copy-Item -Path $s -Destination $d -Recurse -ErrorAction Stop
                }
                else {
                    If(Get-Item $d) {
                        Remove-Item $d
                    }
                    Copy-Item -Path $s -Destination $d -ErrorAction Stop
                }
            }
            Catch [System.Exception] {
                Write-Host "Could not copy $s --> $d"
            }
        }
    }
}
<#********************************************************************
> NETWORK (NET) -- Remoting, RDP, RemotePS, Firewall, Routes, FSD
**********************************************************************#>
Function z-StaticIP($NetworkProfile) {
    # Retrieve the network adapter that you want to configure
    $adapter = Get-NetAdapter | ? {$_.Status -eq "up"}
    # Remove any existing IP, gateway from our ipv4 adapter
    If (($adapter | Get-NetIPConfiguration).IPv4Address.IPAddress) {
     $adapter | Remove-NetIPAddress -AddressFamily $NetworkProfile.IPv -Confirm:$false
    }
    If (($adapter | Get-NetIPConfiguration).Ipv4DefaultGateway) {
     $adapter | Remove-NetRoute -AddressFamily $NetworkProfile.IPv -Confirm:$false
    }
    # Configure the IP address and default gateway
    $adapter | New-NetIPAddress `
     -AddressFamily $NetworkProfile.IPv `
     -IPAddress $NetworkProfile.IP `
     -PrefixLength $NetworkProfile.MaskBits `
     -DefaultGateway $NetworkProfile.Gateway
    # Configure the DNS client server IP addresses
    $adapter | Set-DnsClientServerAddress -ServerAddresses $NetworkProfile.DNS
}
Function z-EnableDHCP() {
    $IPType = "IPv4"
    $adapter = Get-NetAdapter | ? {$_.Status -eq "up"}
    $interface = $adapter | Get-NetIPInterface -AddressFamily $IPType
    If ($interface.Dhcp -eq "Disabled") {
        # Remove existing gateway
        If (($interface | Get-NetIPConfiguration).Ipv4DefaultGateway) {
        $interface | Remove-NetRoute -Confirm:$false
        }

        # Enable DHCP
        $interface | Set-NetIPInterface -DHCP Enabled
        # Configure the DNS Servers automatically
        $interface | Set-DnsClientServerAddress -ResetServerAddresses
    }
}
<#-----------------------------------
> File-System Share Drive (FSD)
-------------------------------------#>
Function z-NetworkFolder-Add($SMBEntries) { # create a network shared folder -- network area storage NAS
    <#SMBObject must be either a single SMB defined object predefined here
     or vairable set to attributes of SMBObject #>
        
}
Function z-NetDrive-Add($i){ # map shared drives to letters and connect using svc acct credentials takes in an array of shared folder objects
    New-PSDrive -Persist -Name $i.NetDrive -PSProvider "FileSystem" -Root "\\$($i.PCName)\$($i.Name)" -Scope Global
}
<#********************************************************************
> ORGANIZATIONAL UNITS (OU) -- Group
*******************************************************************

<#********************************************************************
> IDENTITY MANAGEMENT (IDM) -- Individual
**********************************************************************#>
Function z-SvcAcct-Add($u, $p){ # check if running on LAP, if svc acct exists, then make svc acct
    If(!(Get-LocalUser | Where-Object {$_.Name -eq $u.Name})) {
        if (!($p)) {
            $p = Read-Host -AsSecureString -Message "Enter a password for $($u.Name): "
        }        
        New-LocalUser -Name $u.Name -Password $p -Description $u.Description -AccountNeverExpires -PasswordNeverExpires
    }
    Else {
        Write-Host "$($u.Name) already exists."
    }
}
Function z-SvcAcct-Remove($i){ # check if running on LAP, if svc acct exists, then make svc acct
    If(Get-LocalUser | Where-Object {$_.Name -eq $i.Name}) {
        Remove-LocalUser -Name $i.Name
    }
    Else {
        Write-Host "$($i.Name) not found."
    }
    
}
<#********************************************************************
> PROFILES -- Profiles, Settings, Configuration files, etc.
**********************************************************************#>
Function z-Profile-Archive() {

}
<#********************************************************************
> FONTS -- Install, Nichtspell
**********************************************************************#>
Function z-FontName-Get() { # Compiles font name from parts of file data
    Param (  
        [System.IO.FileInfo] $FontFile
    )
    # get font name
    $TypeFaceObj = [Windows.Media.GlyphTypeface]::new($FontFile.FullName)
    $Family = $TypeFaceObj.Win32FamilyNames['en-us']
    if ($Null -eq $Family) {
        $Family = $TypeFaceObj.Win32FamilyNames.Values.Item(0)
    }
    $Face = $TypeFaceObj.Win32FaceNames['en-us']
    if ($Null -eq $Face) {
        $Face = $TypeFaceObj.Win32FaceNames.Values.Item(0)
    }
    $FontName = ("$Family $Face").Trim() 
           
    Switch ($FontFile.Extension) {  
		".ttf" {$FontName += " (TrueType)"}  
        ".otf" {$FontName += " (OpenType)"}
    }
    Return $FontName
}

Function z-Font-Install() {  
    Param (  
        [System.IO.FileInfo] $FontFile # derived from object type FolderItem.Path
    )
    Try {
        
        $FontName = z-FontName-Get -FontFile $FontFile
        #Write-Host $FontName
        write-host "Installing: $($FontFile.Name) with font name '$FontName'" # process-details output to console
        If (!(Test-Path ("$($env:windir)\Fonts\" + $FontFile.Name))) { # test font existence and copy to fonts folder
            write-host "Copying font: $($FontFile.Name)"
            Copy-Item -Path $FontFile.Path -Destination ("$($env:windir)\Fonts\" + $FontFile.Name) -Force 
        } else {  write-host "Font already exists: $($FontFile.Name)" }

        # test font existence and make registry entry --required these days in windows for use on system and in apps - was not always the case :(
        If (!(Get-ItemProperty -Name $FontName -Path "HKLM:\Software\Microsoft\Windows NT\CurrentVersion\Fonts" -ErrorAction SilentlyContinue)) {
			write-host "Registering font: $($FontFile.Name)"
            New-ItemProperty -Name $FontName -Path "HKLM:\Software\Microsoft\Windows NT\CurrentVersion\Fonts" -PropertyType string -Value $FontFile.Name -Force -ErrorAction SilentlyContinue | Out-Null  
        } else {  write-host "Font already registered: $($FontFile.Name)" }
        #>
        <#
        [System.Runtime.Interopservices.Marshal]::ReleaseComObject($oShell) | out-null 
        Remove-Variable oShell
        #>   
	}
    Catch {            
		Write-Host "Error installing font: $($FontFile.Name). " $_.exception.message
	}
	
 } 
Function z-Font-Uninstall() {  
    param (  
	    [System.IO.FileInfo] $FontFile  # derived from object type FolderItem.Path
    )  
    Try { 
        $FontName = z-FontName-Get -FontFile $FontFile

        write-host "Uninstalling font: $($FontFile.Name) with font name '$FontName'"

        If (Test-Path ("$($env:windir)\Fonts\" + $FontFile.Name)) {  
			write-host "Removing font: $FontFile"
            Remove-Item -Path "$($env:windir)\Fonts\$($FontFile.Name)" -Force 
        }
        Else {
            write-host "Font does not exist: $FontFile"
        }

        If (Get-ItemProperty -Name $FontName -Path "HKLM:\Software\Microsoft\Windows NT\CurrentVersion\Fonts" -ErrorAction SilentlyContinue) {  
			write-host "Unregistering font: $FontFile"
            Remove-ItemProperty -Name $FontName -Path "HKLM:\Software\Microsoft\Windows NT\CurrentVersion\Fonts" -Force                      
        }
        Else {
            write-host "Font not registered: $FontFile"
        }
    }
    Catch {            
		write-host "Error uninstalling font: $FontFile. " $_.exception.message
    }        
} 
Function z-File-VectorTransfer() {
# takes hash of an app-file location and user-archive location of the file for import and export
    Param(
        $Roots, # hash of app file-dir(s) and archive dir(s) for those app-files
        $Vector # Import or Export
    )
    if ($Vector = 'Import') {
        z-Kudzu -Source $Roots.Archive -Destination $Roots.App
    }
    elseif ($Vector = 'Export') {
        z-Kudzu -Source $Roots.App -Destination $Roots.Archive
    }
    else {
        Write-Host 'No file-folder(s) transfered.'
    }    
}