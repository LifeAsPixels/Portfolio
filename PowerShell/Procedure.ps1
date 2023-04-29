<#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
> TITLE
ProcessAdd-PCSetting

> ABOUT
Use after setting execution policy to allow for PS scripts
Procedural functions made of rudimentary functions and CMDlets to set PC to user-specifications

> TASK

> AUTHOR
LifeAsPixels

# INCLUDE #>
. .\Settings.ps1
. .\Functions.ps1
<#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~#>
Function z-Procedure-CodingSettings() {
    Import-Module Microsoft.PowerShell.Management -UseWindowsPowerShell
    foreach($i in $zPFMember) {
        z-File-VectorTransfer -Roots $i -Vector 'Import'
    }
}
Function z-Procedure-Network() { # tested and working commands... may need review on parameters, functions and order since refactoring
    # Enable network discovery - required for file sharing and RDP
    foreach($i in $zOU.Members) {
        # write-host $i.Name + $zOU.Name
        Try {
            Add-Computer -ComputerName $i.Name -WorkgroupName $zOU.Name
        }
        Catch [System.Exception] {
            Write-Host "Could not add $($i.Name) to the workgroup, $($zOU.Name)"
        }
    }    
    Set-NetFirewallRule -Profile 'Private' -DisplayGroup 'Network Discovery', "File And Printer Sharing" -Enabled True

    # Enable RDP and firewall rule
    Set-ItemProperty -Path 'HKLM:\System\CurrentControlSet\Control\Terminal Server' -name "fDenyTSConnections" -value 0
    Enable-NetFirewallRule -DisplayGroup "Remote Desktop"

    Enable-PSRemoting
	
	ForEach($i in $zNetDrive) { # create network-shared folders and map net drives
        Try {
            If($i.PCName -eq $env:COMPUTERNAME) { # only do this for entries in the shared drive list matching the name of the PC the script is running on
                # Get-PSDrive
                New-SMBShare -Path $i.Path -Description $i.Description -Name $i.Name -FullAccess $i.FullAccess -FolderEnumerationMode $i.FolderEnumerationMode
            }
            New-PSDrive -Persist -Name $i.NetDrive -PSProvider "FileSystem" -Root "\\$($i.PCName)\$($i.Name)" -Scope Global -ErrorAction Stop
        }
        Catch [System.Exception]{
            Write-Host "Could not connect \\$($i.PCName)\$($i.Name) to $($i.NetDrive)."
        }
	}
}
Function z-Procedure-Fonts() { # Install fonts
    $Fonts = File-SearchRecursive -Source $zdFont -Match $FontExt -Exclude $FontExtExclude # generate font obj list
    If (!($Fonts)) { # if no fonts found in provided folder, search in same folder as script
        $CurrentDirectory = [System.AppDomain]::CurrentDomain.BaseDirectory.TrimEnd('\') 
        If ($CurrentDirectory -eq $PSHOME.TrimEnd('\')) {     
            $CurrentDirectory = $PSScriptRoot 
        }
        $Fonts = File-SearchRecursive -Source $CurrentDirectory -Match $FontExt -Exclude $FontExtExclude # generate font obj list
    }

    If (!($Fonts)) {
        Write-Host "No fonts here:"
        Write-Host "$zdFont"
        Write-Host "$CurrentDirectory"
    }
    Else {
        ForEach ($Item in $Fonts) {
            Font-Install -FontFile $Item.Path
            # Write-Host $Font.Path
        }
    }
}

<#********************************************************************
> REMOVE -- undo settings here
**********************************************************************#>
<#
ForEach ($i in $zNetDrive){ #network folders and drives
    If ($i.PCName -eq $env:COMPUTERNAME) {
        # net use $i.NetDrive /delete
        Remove-PSDrive -Name $i.Name
        Remove-SmbShare -Name $i.Name
        
    }
}
# z-SvcAcct-Remove $zSvcAcct

<#********************************************************************
> CHECK -- inspect current settings here
**********************************************************************#>
<#
Get-SmbShare
Remove-PSDrive
get-localuser
#>
<#********************************************************************
> ADD -- add new settings here
**********************************************************************#>

z-Procedure-CodingSettings
z-Procedure-Fonts
z-Procedure-Network

#>
# z-SvcAcct-Add $zSvcAcct

<#
foreach($i in $zOU.Members) { #network wkggrp proc
    # write-host $i.Name + $zOU.Name
    Add-Computer -WorkgroupName $zOU.Name -ComputerName $i.Name
}
#>
<#
# $PWord = ConvertTo-SecureString -String '' -AsPlainText -Force
# $Credential = New-Object -TypeName System.Management.Automation.PSCredential -ArgumentList $zSvcAcct.Name, $PWord
# $Credential = Get-Credential -UserName $zSvcAcct.Name
Procedure-Network
ForEach($i in $zNetDrive) { # pass parameters from settings as an array of hashes
    if ($i.PCName -eq $env:COMPUTERNAME) { # only do this for entries in the shared drive list matching the name of the PC the script is running on
        # Get-PSDrive
        # 
        #NetworkFolder-CreateShare $zNetDrive # make the shared folders if they do not exist
        #NetDrive-Add $zNetDrive
    }
}
#>

# New-SMBShare -Path $i.Path -Description $i.Description -Name $i.Name -FullAccess $i.FullAccess -FolderEnumerationMode $i.FolderEnumerationMode
#SvcAcct-Add $zSvcAcct
# get-localuser
# Get-SmbShare
#Procedure-Network