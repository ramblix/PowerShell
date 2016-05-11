#Requires -Version 3.0
<#
.SYNOPSIS
    Get-LockedOutUser.ps1 returns a list of users who were locked out in Active Directory.
 
.DESCRIPTION
    Get-LockedOutUser.ps1 is an advanced script that returns a list of users who were locked out in Active Directory
by querying the event logs on the PDC emulator in the domain.
 
.EXAMPLE
    Get-LockedOutUser.ps1
 
.EXAMPLE
    Get-LockedOutUser.ps1 -UserName '198324772'
 
.EXAMPLE
    Get-LockedOutUser.ps1 -UserName '198324772' -StartTime (Get-Date).AddDays(-1)
#>
 
[CmdletBinding()]
param (
    [ValidateNotNullOrEmpty()]
    [string]$DomainName = $env:USERDOMAIN,
 
    [ValidateNotNullOrEmpty()]
    [string]$UserName = "198324772",
 
    [ValidateNotNullOrEmpty()]
    [datetime]$StartTime = (Get-Date).AddDays(-3)
)
 
Invoke-Command -ComputerName (
 
    [System.DirectoryServices.ActiveDirectory.Domain]::GetDomain((
        New-Object System.DirectoryServices.ActiveDirectory.DirectoryContext('Domain', $DomainName))
    ).PdcRoleOwner.name
 
) {
 
    Get-WinEvent -FilterHashtable @{LogName='Security';Id=4740;StartTime=$Using:StartTime} |
    Where-Object {$_.Properties[0].Value -like "$Using:UserName"} |
    Select-Object -Property TimeCreated, 
        @{Label='UserName';Expression={$_.Properties[0].Value}},
        @{Label='ClientName';Expression={$_.Properties[1].Value}}
 
} -Credential (Get-Credential) |
Select-Object -Property TimeCreated, UserName, ClientName