<#PSScriptInfo
#####################################################
# Set-EnvPath
#####################################################
.VERSION 0.0

.GUID eee8891e-18c7-40ab-b706-4db68d3131b1

.AUTHOR David Walker, Sitecore Dave, Radical Dave

.COMPANYNAME David Walker, Sitecore Dave, Radical Dave

.COPYRIGHT David Walker, Sitecore Dave, Radical Dave

.TAGS powershell script

.LICENSEURI https://github.com/Radical-Dave/Set-EnvPath/blob/main/LICENSE

.PROJECTURI https://github.com/Radical-Dave/Set-EnvPath

.ICONURI

.EXTERNALMODULEDEPENDENCIES

.REQUIREDSCRIPTS

.EXTERNALSCRIPTDEPENDENCIES

.RELEASENOTES


#>

<#
.SYNOPSIS
PowerShell Script helper for System.Environment.Path

.DESCRIPTION
PowerShell Script helper for System.Environment.Path

.EXAMPLE
PS> .\Set-EnvPath 'path'

.Link
https://github.com/Radical-Dave/Set-EnvPath

.OUTPUTS
    System.String
#>
Param (
	# Path to add
    [Parameter(Mandatory=$true,ValueFromPipeline)]
    [ValidateScript({
        if (-not (Test-Path -Path $_ -PathType Container)) {
            throw 'Path must be a Folder'
        }
        if (-not ([System.IO.Path]::IsPathRooted($_))) {
            throw 'Path must be Rooted'
        }
        return $true
    })]
    [string] $Path,

    [ValidateSet('Machine', 'User', 'Session')]
    [string] $Scope = 'Session',

    [switch] $Remove
)
if ($Scope -ne 'Session') {
    $paths = [Environment]::GetEnvironmentVariable('Path', $Scope) -split ';'
    if ($paths -notcontains $Path) {
        $paths = $paths + $Path | Where-Object { $_ }
        [Environment]::SetEnvironmentVariable('Path', $paths -join ';', $Scope)
    }
}

$envPaths = $env:Path -split ';'
if ($envPaths -notcontains $Path) {
    $envPaths = $envPaths + $Path | Where-Object { $_ }
    $env:Path = $envPaths -join ';'
}